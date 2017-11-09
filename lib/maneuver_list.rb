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
      source_files.none? do |f|
        f.match(%r{#{vehicle}}i) && self.matches?(f)
      end && required?
    end

    def matches?(file)
      file.match(%r{#{tag}}i)
    end
  end
end
