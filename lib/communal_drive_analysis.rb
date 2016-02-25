require "thor"
require "json"
require "fileutils"
require "colorize"

class CommunalDriveAnalysis < Thor
  desc "sort SOURCE DESTINATION", "Sort files from SOURCE into DESTINATION"
  option :config,  aliases: ["-c"], default: "config.json"
  option :verbose, aliases: ["-v"], type: :boolean, default: false
  def sort(source, destination)
    JSON.parse(File.read(options[:config])).each do |tag, folder|
      File.join(destination, folder).tap do |destination_folder|
        FileUtils.mkdir_p(destination_folder)
        Dir.glob(File.join(source, "**/*#{tag}*")).each do |file|
          puts "Copying #{file}" if options[:verbose]
          FileUtils.cp(file, destination_folder)
        end
      end
    end
  end

  desc "check SOURCE", "Check if all subfolders inside SOURCE have the required files"
  option :config,  aliases: ["-c"], default: "config.json"
  def check(source)
    Dir.glob(File.join(source, "*/")).each do |folder|
      missing = []
      JSON.parse(File.read(options[:config])).each do |tag, _|
        missing << tag if Dir.glob(File.join(folder, "*#{tag}*")).empty?
      end
      if missing.empty?
        puts "#{File.basename(folder)}: All files present"
      else
        puts "#{File.basename(folder)}: Missing #{missing.join(", ")}"
      end
    end
  end
end
