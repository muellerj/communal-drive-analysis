require "thor"
require "json"
require "fileutils"
require "colorize"
require_relative "core_ext"
require_relative "maneuver_list"

class CommunalDriveAnalysis < Thor
  desc "sort SOURCE DESTINATION", "Sort files from SOURCE into DESTINATION"
  option :config,  aliases: ["-c"], default: "config.json"
  option :verbose, aliases: ["-v"], type: :boolean, default: false
  def sort(source, destination)
    ManeuverList.new(options[:config]).each do |maneuver|
      File.join(destination, maneuver.folder).tap do |destination_folder|
        FileUtils.mkdir_p(destination_folder)
        Dir.globi(File.join(source, "**/*#{maneuver.tag}*")).each do |file|
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
      [].tap do |missing|
        ManeuverList.new(options[:config]).each do |maneuver|
          if Dir.globi(File.join(folder, "**", "*#{maneuver.tag}*")).empty? && maneuver.required?
            missing << maneuver.tag
          end
        end
        display_vehicle_status(vehicle: File.basename(folder), missing: missing)
      end
    end
  end

  private

  def display_vehicle_status(vehicle:, missing:)
    if missing.empty?
      puts "#{vehicle}: All files present".green
    else
      puts "#{vehicle}: Missing #{missing.sort.join(", ")}".red
    end
  end
end
