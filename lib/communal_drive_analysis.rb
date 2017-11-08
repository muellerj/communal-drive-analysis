require "thor"
require "json"
require "fileutils"
require "colorize"
require_relative "core_ext"
require_relative "maneuver_list"
require "pp"

class CommunalDriveAnalysis < Thor

  VEHICLE_REGEXP = /(V\d{6})/

  desc "sort SOURCE DESTINATION", "Sort files from SOURCE into DESTINATION"
  option :config,  aliases: ["-c"], default: "config.json"
  option :verbose, aliases: ["-v"], type: :boolean, default: false
  def sort(source, destination)

    maneuver_list = ManeuverList.new(options[:config])
    source_files  = Dir.globi(File.join(source, "**", "*"))

    maneuver_list.each do |maneuver|
      File.join(destination, maneuver.folder).tap do |destination_folder|
        FileUtils.mkdir_p(destination_folder)
        source_files.select { |f| f.match(%r{#{maneuver.tag}}i) }.each do |file|
          puts "#{File.basename(file)} => #{maneuver.folder}" if options[:verbose]
          FileUtils.cp(file, destination_folder)
        end
      end
    end
  end

  desc "check SOURCE", "Check if all subfolders inside SOURCE have the required files"
  option :config,  aliases: ["-c"], default: "config.json"
  def check(source)

    maneuver_list = ManeuverList.new(options[:config])
    source_files  = Dir.globi(File.join(source, "**", "*"))
    vehicles      = source_files.map { |filename| filename.match(VEHICLE_REGEXP) { $1 } }.
                                 compact.
                                 uniq.
                                 map { |vehicle| [ vehicle, drivers_for(vehicle, source_files) ] }.
                                 to_h

    pp vehicles


    vehicles.each do |vehicle, drivers|
      missing = maneuver_list.each.
                              select { |maneuver| maneuver.missing_for?(vehicle, source_files) }.
                              map(&:tag)
      display_vehicle_status(vehicle:    display_name(vehicle, drivers),
                             missing:    missing,
                             maneuvers:  maneuver_list)
    end
    display_legend(maneuvers: maneuver_list)

  end

  private

  def display_name(vehicle, drivers)
    "#{vehicle} (#{drivers.join(", ")})"
  end

  def drivers_for(vehicle, source_files)
    source_files.select { |filename| filename.match("#{vehicle}/fahrer.txt") }.
                 flat_map { |driverfile| File.read(driverfile).chomp.split(", ") }.
                 uniq
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
