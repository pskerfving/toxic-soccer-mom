Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "363428070366915", "7bc644fff2e4e37e1e1e6192112042e9"
  provider :identity, on_failed_registration: lambda { |env|
      SessionsController.action(:new).call(env)
    }
end
