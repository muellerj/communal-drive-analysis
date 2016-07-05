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
    ManeuverList.new(options[:config]).tap do |maneuver_list|
      Dir.glob(File.join(source, "*/")).each do |folder|
        [].tap do |missing|
          maneuver_list.each do |maneuver|
            if Dir.globi(File.join(folder, "**", "*#{maneuver.tag}*")).empty? && maneuver.required?
              missing << maneuver.tag
            end
          end
          display_vehicle_status(vehicle: vehicle_name(folder), missing: missing, maneuvers: maneuver_list)
        end
      end
      display_legend(maneuvers: maneuver_list)
    end
  end

  private

  def vehicle_name(folder)
    File.basename(folder).tap do |name|
      name << " (#{File.read(File.join(folder, "fahrer.txt"))})" if File.exist?(File.join(folder, "fahrer.txt"))
    end
  end

  def display_legend(maneuvers:)
    puts "\n"
    puts "# Legende".colorize(:yellow)
    puts maneuvers.each.map { |maneuver| "#{maneuver.tag}: #{maneuver.folder}\n" }
  end

  def display_vehicle_status(vehicle:, missing:, maneuvers:)
    if missing.empty?
      puts "#{vehicle}: All files present".colorize(:green)
    elsif missing.sort == maneuvers.each.select(&:required?).map(&:tag).sort
      puts "#{vehicle}: Missing all files".colorize(:red)
    else
      puts "#{vehicle}: Missing #{missing.sort.join(", ")}".colorize(:red)
    end
  end
end
