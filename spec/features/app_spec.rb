require "rspec"
require "capybara"

feature "Messages" do
  scenario "As a user, I can submit a message" do
    visit "/"

    expect(page).to have_content("Message Roullete")

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "Click edit button and see form to edit message" do
    visit '/'
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_button "Edit Message"
    expect(page).to have_content('Edit this message:')
    fill_in "Edit this message:", :with => "New, better message"
    click_button "Edit Message"
    expect(page).to have_content('New, better message')
  end

  scenario "I still cannot submit a message over 140 characters when editting a message" do
    visit '/'
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_button "Edit Message"
    expect(page).to have_content('Edit this message:')
    fill_in "Edit this message:", :with => "a" * 141
    click_button "Edit Message"
    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "I can delete a message" do
    visit '/'
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_button "Delete"
    expect(page).to have_no_content("Hello Everyone!")
  end

  scenario "I can add a comment to a message" do
    visit '/'
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    click_button "Comment"
    expect(page).to have_content "Comment"
    fill_in "Comment", :with => "Hello to you too!"
    click_button "Add Comment"
    expect(page).to have_content "Hello to you too!"
  end
end
