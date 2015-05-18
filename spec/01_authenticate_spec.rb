require 'spec_helper'

RSpec.describe "Authentication" do
  specify "Can log in to the service app, using the auth app" do
    visit SERVICE_APP_URI

    we_get_redirected_to_the_auth_app

    fill_in "Email", with: "cso1@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"

    we_are_back_on_the_service_app
  end
end
