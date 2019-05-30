# frozen_string_literal: true

module SearchHelper
  def prepare_desc(desc)
    desc.gsub(/([\w.]+)@([\w.]+)/, '\1 [at] xxx').gsub(/\n/, "<br/>")
  end

  def trust_level(package, project)
    # 3: official package
    # 2: official package in Factory
    # 1: experimental package
    # 0: community package
    case package.project
    when project, "#{project}:Update", "#{project}:NonFree" then 3
    when 'openSUSE:Factory' then 2
    when /^home/ then 0
    else 1
    end
  end
end
