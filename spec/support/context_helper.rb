# We need to do a find here because there are redirections that occur
# doing an assertion on the page immediately will fail because it does
# not wait, find does.

def we_are_back_on_the_service_app
  expect { find("a", text: "Defence Solicitor Deployment Service") }.to_not raise_error
end

def we_get_redirected_to_the_auth_app
  expect { find("a", text: "Defence Request Service Authentication") }.to_not raise_error
end
