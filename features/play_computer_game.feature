Feature: Play Against Computer

  @javascript
  Scenario: Game Interactivity For Participant
    Given I am on the start game menu screen
    And I choose computer as game type
    And I make my first move
    Then my move should be visible
    And the computer should respond

  Scenario: Game Interactivity for Non-Participant
    Given someone else started a computer game
    And I attempt to play it
    Then I should not be able to access the game
