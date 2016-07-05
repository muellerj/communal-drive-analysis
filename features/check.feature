Feature: Checking measurements
  In order to quickly access and distribute measurements
  As an organiser of a communal drive event
  I want to know if all the measurements for each vehicle are present

  Scenario: Checking measurements and check-ins
    Given I have a directory `tmp/messungen` with the following files
      """
      vehicle-a/2016-02-29_Y301V9_CDA-01_Kriechen.dat
      vehicle-a/2016-02-29_Y301V9_CDA-02_Fahren.dat
      vehicle-a/2016-02-29_Y301V9_CDA-03_Rumstehen.dat
      vehicle-a/20160230_Y301V9_CheckIn.txt
      vehicle-b/2016-02-29_Y73000_Kriechen_CDA-01.dat
      """
    And I have a config file at `tmp/messungen/config.json` with the following content
      """
      [
        ["required", "CDA-01", "CDA-01_Kriechen"],
        ["optional", "CDA-02", "CDA-02_Fahren"],
        ["required", "CDA-03", "CDA-03_Stehen"],
        ["required", "CheckIn", "CheckIns"]
      ]
      """
    And I have a config file at `tmp/messungen/vehicle-b/fahrer.txt` with the following content
      """
      Fahrer 1, Fahrer 2
      """
    When I type `cda check -c tmp/messungen/config.json tmp/messungen`
    Then I want to see the following output
      """
      vehicle-a: All files present
      vehicle-b (Fahrer 1, Fahrer 2): Missing CDA-03, CheckIn

      """
