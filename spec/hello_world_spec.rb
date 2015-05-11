require 'spec_helper'

RSpec.describe "Hello world" do
  specify "Can log in to the service app, using the auth app" do
    visit SERVICE_APP_URI

    we_get_redirected_to_the_auth_app

    fill_in "Email", with: "cso1@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"

    we_are_back_on_the_service_app
  end
end


# We need to do a find here because there are redirections that occur
# doing an assertion on the page immediately will fail because it does
# not wait, find does.

def we_are_back_on_the_service_app
  expect { find("a", text: "Defence Solicitor Deployment Service") }.to_not raise_error
end

def we_get_redirected_to_the_auth_app
  expect { find("a", text: "Defence Request Service Authentication") }.to_not raise_error
end
