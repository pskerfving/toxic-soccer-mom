Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "1597504820579278", "f528a065b990b6c530fa70fdea314d46"
  provider :twitter, "SbRLYrG8RkUhDQ4w9aK4oXfhc", "	rNHe43s7Nmn1s1cxrhEFK9zL1ANCCEZtXvqv2bd3CqXlF9ZBJw"
  provider :identity, on_failed_registration: lambda { |env|
      SessionsController.action(:new).call(env)
    }
end
