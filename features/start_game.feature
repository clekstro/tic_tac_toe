Feature: Start Game
  Scenario: Start Game with Computer
    Given I am on the start game menu screen
    And I choose computer as game type
    Then the human vs. computer game should begin
#  Scenario: Start Game with Human Present
#    Given I am on the start game menu screen
#    And I choose human as game type
#    Then the human vs. human game should begin
#  Scenario: Start Game with Human Absent
#    Given I am on the start game menu screen
#    And I choose human as game type
#    Then the human vs. human game should not begin
#    And I should see a message that no one else is present

    

