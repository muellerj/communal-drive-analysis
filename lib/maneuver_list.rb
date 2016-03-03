class ManeuverList
  def initialize(filepath)
    @maneuvers = JSON.parse(File.read(filepath)).map do |line|
      Maneuver.new(*line)
    end
  end

  def each
    @maneuvers.each do |maneuver|
      yield(maneuver)
    end
  end

  class Maneuver
    attr_reader :tag, :folder
    def initialize(required, tag, folder)
      @required = required
      @tag      = tag
      @folder   = folder
    end

    def required?
      @required == "required"
    end
  end
end
