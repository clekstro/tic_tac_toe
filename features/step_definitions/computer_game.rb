Given(/^I choose (.*) as game type$/) do |game_type|
  choose("game_type_#{game_type}")
  click_on 'Start Game'
end

Then(/^the human vs\. computer game should begin$/) do
  page.should have_content("Please make a move.")
end
