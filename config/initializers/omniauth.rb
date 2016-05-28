Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "1597504820579278", "f528a065b990b6c530fa70fdea314d46", :scope => 'email'
  provider :twitter, "SbRLYrG8RkUhDQ4w9aK4oXfhc", "rNHe43s7Nmn1s1cxrhEFK9zL1ANCCEZtXvqv2bd3CqXlF9ZBJw"
  provider :github, "17ee8cb7c5fc1e85d1ba", "92c7c03a8e8e26e7073a6bef014ca1ffa4143928", scope: "user:email"
  provider :identity, on_failed_registration: lambda { |env|
      SessionsController.action(:new).call(env)
    }
end
