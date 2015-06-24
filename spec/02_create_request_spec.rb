require 'spec_helper'

RSpec.describe "Creating Defence Request" do
  specify "CSO creates a new Defence Request" do
    given_cso_is_in_the_service_app
    when_they_create_and_submit_new_request
    then_they_are_on_the_dashboard
    and_they_can_see_the_new_request_in_the_list
  end

  def given_cso_is_in_the_service_app
    visit SERVICE_APP_URI
  end

  def when_they_create_and_submit_new_request
    click_link "New request"

    within ".detainee" do
      fill_in "Name", with: "Mannie Badder"
      choose "Male"
      fill_in "defence_request_date_of_birth_year", with: "1976"
      fill_in "defence_request_date_of_birth_month", with: "01"
      fill_in "defence_request_date_of_birth_day", with: "01"
      fill_in "defence_request_detainee_address",
        with: "House of the rising sun, Letsby Avenue, Right up my street, London, Greater London, XX1 1XX"
      choose "defence_request_appropriate_adult_false"
      choose "defence_request_interpreter_required_false"
    end

    within ".case-details" do
      fill_in "defence_request_investigating_officer_name", with: "Dave Mc.Copper"
      fill_in "defence_request_investigating_officer_contact_number", with: "0207 111 0000"
      fill_in "Custody number", with: "AN14574637587"
      fill_in "Offences", with: "BadMurder"
      fill_in "defence_request_circumstances_of_arrest", with: "He looked a bit shady"
      choose "defence_request_fit_for_interview_true"
      fill_in "defence_request_time_of_arrest_date", with: "02 Feb 2002"
      fill_in "defence_request_time_of_arrest_hour", with: "02"
      fill_in "defence_request_time_of_arrest_min", with: "02"
      fill_in "defence_request_time_of_arrival_date", with: "01 Jan 2001"
      fill_in "defence_request_time_of_arrival_hour", with: "01"
      fill_in "defence_request_time_of_arrival_min", with: "01"
      fill_in "defence_request_time_of_detention_authorised_date", with: "03 Mar 2003"
      fill_in "defence_request_time_of_detention_authorised_hour", with: "03"
      fill_in "defence_request_time_of_detention_authorised_min", with: "03"
    end

    click_button "Create request"

    click_button "Submit request"
  end

  def then_they_are_on_the_dashboard
    expect(page.current_url).to eql("#{SERVICE_APP_URI}/dashboard")
  end

  def and_they_can_see_the_new_request_in_the_list
    expect(page).to have_css(".name", text: "Mannie Badder")
    expect(page).to have_css(".state", text: "Submitted")
  end

end
