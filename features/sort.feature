Feature: Sorting measurements
  In order to quickly access and distribute measurements
  As an organiser of a communal drive event
  I want to sort measurements and check-ins into folders

  Scenario: Sorting measurements
    Given I have a directory with measurements from a communal drive at `tmp/hinfahrt`
    And in that directory, I have a file `vehicle-a/2016-02-29_Y301V9_CDA-01_Kriechen.dat`
    And in that directory, I have a file `vehicle-a/2016-02-29_Y301V9_CDA-02_Fahren.dat`
    And in that directory, I have a file `vehicle-b/2016-02-29_Y73000_Kriechen_CDA-01.dat`
    And in that directory, I have a config file with the following content
      """
      {
      	"CDA-01": "CDA-01_Kriechen",
      	"CDA-02": "CDA-02_Fahren"
      }
      """
    When I type `cda -c tmp/hinfahrt/config.json tmp/hinfahrt tmp/auswertung`
    And the results folder is `tmp/auswertung`
    Then I want to see the file `Kriechen/2016-02-29_Y301V9_CDA-01_Kriechen.dat` in the results folder
    And I want to see the file `Kriechen/2016-02-29_Y73000_Kriechen_CDA-01.dat` in the results folder
    And I want to see the file `Fahren/2016-02-29_Y301V9_CDA-02_Fahren.dat` in the results folder
