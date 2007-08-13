class MissingCodec
  def initialize(a)
    @framework = a[0]
    @framework_version = a[1]
    @application = a[2]
    @description = a[3]
    @fourcc = a[4]
  end

  def framework
    @framework
  end

  def framework_version
    @framework_version
  end

  def application
    @application 
  end
  
  def description
    @description 
  end

  def fourcc
    @fourcc
  end
end

