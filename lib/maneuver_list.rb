class ManeuverList
  def initialize(filepath)
    @maneuvers = JSON.parse(File.read(filepath)).map do |line|
      Maneuver.new(*line)
    end
  end

  def each(&block)
    @maneuvers.each(&block)
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

    def missing_for?(vehicle, source_files)
      source_files.none? { |f| f.match(%r{#{vehicle}.*#{tag}}i) } && required?
    end
  end
end
