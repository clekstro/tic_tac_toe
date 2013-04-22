require 'uri'

Given(/^I have started a computer game$/) do
  @game = ComputerGame.create
  driver = Capybara.current_session.driver
  driver.set_cookie "game_token", @game.token, domain: "127.0.0.1", path: "/games/#{@game.id}"
end

Given(/^I make my first move$/) do
  visit "/games/1"
  find("#A1").click
end

Then(/^my move should be visible$/) do
  within("#A1") do
    page.should have_text("X")
  end
end

Then(/^the computer should respond$/) do
  within("#gameboard") do
    page.should have_text("O")
  end
end

Given(/^someone else started a computer game$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I attempt to play it$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not be able to access the game$/) do
  pending # express the regexp above with the code you wish you had
end
