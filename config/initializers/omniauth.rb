Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "431440640317180", "c53cac220b6ac79e493e064a2b3142da"
  provider :twitter, "SbRLYrG8RkUhDQ4w9aK4oXfhc", "	rNHe43s7Nmn1s1cxrhEFK9zL1ANCCEZtXvqv2bd3CqXlF9ZBJw"
  provider :identity, on_failed_registration: lambda { |env|
      SessionsController.action(:new).call(env)
    }
end
