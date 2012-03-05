module PackageHelper
  
  def human_arch arch
    case arch
    when "i586"
      "32 Bit"
    when "x86_64"
      "64 Bit"
    when "src"
      "Source"
    when "nosrc"
      "Source"
    else
      arch
    end
  end

 
end
