require "thor"
require "json"
require "fileutils"
require "colorize"
require_relative "core_ext"

class CommunalDriveAnalysis < Thor
  desc "sort SOURCE DESTINATION", "Sort files from SOURCE into DESTINATION"
  option :config,  aliases: ["-c"], default: "config.json"
  option :verbose, aliases: ["-v"], type: :boolean, default: false
  def sort(source, destination)
    JSON.parse(File.read(options[:config])).each do |_, tag, folder|
      File.join(destination, folder).tap do |destination_folder|
        FileUtils.mkdir_p(destination_folder)
        Dir.globi(File.join(source, "**/*#{tag}*")).each do |file|
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
      JSON.parse(File.read(options[:config])).each do |required, tag, _|
        required = required == "required" ? true : false
        missing << tag if Dir.globi(File.join(folder, "*#{tag}*")).empty? && required
      end
      if missing.empty?
        puts "#{File.basename(folder)}: All files present".green
      else
        puts "#{File.basename(folder)}: Missing #{missing.sort.join(", ")}".red
      end
    end
  end
end
