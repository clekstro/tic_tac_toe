Given(/^I am on the start game menu screen$/) do
  visit '/'
end

Then(/^I should see a welcome message$/) do
  page.should have_text("Welcome to Tic-Tac-Toe!")
end

Then(/^I should see gameplay options$/) do
  page.should have_field("game_type_computer")
  page.should have_field("game_type_human")
end

Then(/^I should see the board$/) do
  page.should have_css("#gameboard")
  within "#gameboard" do
    page.should have_css("#A1")
    page.should have_css("#A2")
    page.should have_css("#A3")
    page.should have_css("#B1")
    page.should have_css("#B2")
    page.should have_css("#B3")
    page.should have_css("#C1")
    page.should have_css("#C2")
    page.should have_css("#C3")
  end
end
