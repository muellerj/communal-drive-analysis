Feature: Sorting measurements
  In order to quickly access and distribute measurements
  As an organiser of a communal drive event
  I want to sort measurements and check-ins into folders

  Scenario: Sorting measurements
    Given I have a directory `tmp/messungen` with the following files
      """
      vehicle-a/2016-02-29_Y301V9_CDA-01_Kriechen.dat
      vehicle-a/2016-02-29_Y301V9_CDA-02_Fahren.dat
      vehicle-b/2016-02-29_Y73000_Kriechen_CDA-01.dat
      """
    And I have a config file at `tmp/messungen/config.json` with the following content
      """
      {
        "CDA-01": "CDA-01_Kriechen",
        "CDA-02": "CDA-02_Fahren"
      }
      """
    When I type `cda sort -c tmp/messungen/config.json tmp/messungen tmp/auswertung`
    And the results folder is `tmp/auswertung`
    Then I want to see the file `CDA-01_Kriechen/2016-02-29_Y301V9_CDA-01_Kriechen.dat` in the results folder
    And I want to see the file `CDA-01_Kriechen/2016-02-29_Y73000_Kriechen_CDA-01.dat` in the results folder
    And I want to see the file `CDA-02_Fahren/2016-02-29_Y301V9_CDA-02_Fahren.dat` in the results folder
