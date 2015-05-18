require 'spec_helper'

RSpec.describe "Unauthenticate" do
  specify "Can log out of the service app" do
    visit SERVICE_APP_URI

    click_link("Sign out")

    we_get_redirected_to_the_auth_app
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end
end
