class PackageController < ApplicationController

  before_filter :set_beta_warning

  def show
    required_parameters :package
    @pkgname = params[:package]
    raise MissingParameterError, "Invalid parameter package" unless valid_package_name? @pkgname

    @packages = Seeker.prepare_result("\"#{@pkgname}\"", nil, nil, nil, nil)

    # TODO: released projects don't give info over the api...
    @packages.each do |package|
      unless package.description.blank?
        @description_package = package
        logger.debug "Found package description in: #{package.project}"
        break
      end
      logger.debug "No package description in: #{package.project}"
    end

    #TODO: get distro spezific screenshot, cache from debshots etc.
    @screenshot_thumb = "http://screenshots.debian.net/thumbnail/" + @pkgname

    # Fetch appstream data for app
    #Appdata.find :project => "test", :repo => "test", :arch => "test", :pkgname => @pkgname



  end


  def set_beta_warning
    flash.now[:warn] = "This is an alpha version of the new package search, part of " +
      "the <a href='https://trello.com/board/appstream/4f156e1c9ce0824a2e1b8831'>current boosters sprint</a>!"
  end


end
 