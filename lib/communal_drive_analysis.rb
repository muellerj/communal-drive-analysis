require "thor"
require "json"
require "fileutils"

class CommunalDriveAnalysis < Thor
  desc "sort SOURCE DESTINATION", "Sort files from SOURCE into DESTINATION"
  option :config,  aliases: ["-c"], default: "config.json"
  option :verbose, aliases: ["-v"], type: :boolean, default: false
  def sort(source, destination)
    JSON.parse(File.read(options[:config])).each do |key, folder|
      File.join(destination, folder).tap do |destination_folder|
        FileUtils.mkdir_p(destination_folder)
        Dir.glob(File.join(source, "**/*#{key}*")).each do |file|
          puts "Copying #{file}" if options[:verbose]
          FileUtils.cp(file, destination_folder)
        end
      end
    end
  end
end
