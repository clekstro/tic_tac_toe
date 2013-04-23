Feature: Play Against Human
  Scenario: No Available Human Opponent
    Given I choose human as game type
    And I am the first player
    Then a new game should be created
    And I should wait for another player

  Scenario: Human Opponent Waiting
    Given I choose human as game type
    And I am the second player
    Then no new game should be created
    And the game should begin
