Feature: Play Against Computer

  @javascript
  Scenario: Game Interactivity For Participant
    Given I am on the start game menu screen
    And I choose computer as game type
    And I make my first move
    Then my move should be visible
    And the computer should respond
    And it should be my turn to play

  Scenario: End of Game (Victory)
    Given a player has won
    Then the game should end
    And I should be asked to play again

  Scenario: End of Game (Tie)
    Given no player has won
    And all the places are taken
    Then the game should end
    And I should be asked to play again

  Scenario: Game Interactivity for Non-Participant
    Given someone else started a computer game
    And I attempt to play it
    Then I should not be able to access the game
