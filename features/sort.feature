Feature: Sorting measurements
  In order to quickly access and distribute measurements
  As an organiser of a communal drive event
  I want to sort measurements and check-ins into folders

  Scenario: Sorting measurements and check-ins
    Given I have a directory `tmp/messungen` with the following files
      """
      vehicle-a/2016-02-29_Y301V9_CDA-01_Kriechen.dat
      vehicle-a/2016-02-29_Y301V9_CDA-02_Fahren.dat
      vehicle-a/2016-02-29_Y301V9_CDA-03_Rumstehen.dat
      vehicle-a/20160230_Y301V9_CheckIn.txt
      vehicle-b/2016-02-29_Y73000_Kriechen_CDA-01.dat
      vehicle-b/20160230_Y73000_foo_CheckIn.txt
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
    When I type `cda sort -c tmp/messungen/config.json tmp/messungen tmp/auswertung`
    Then I want to see the following files in `tmp/auswertung`
      """
      CDA-01_Kriechen/2016-02-29_Y301V9_CDA-01_Kriechen.dat
      CDA-01_Kriechen/2016-02-29_Y73000_Kriechen_CDA-01.dat
      CDA-02_Fahren/2016-02-29_Y301V9_CDA-02_Fahren.dat
      CDA-03_Stehen/2016-02-29_Y301V9_CDA-03_Rumstehen.dat
      CheckIns/20160230_Y73000_foo_CheckIn.txt
      CheckIns/20160230_Y301V9_CheckIn.txt
      """
