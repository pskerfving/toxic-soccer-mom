Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "431440640317180", "c53cac220b6ac79e493e064a2b3142da"
  provider :twitter, "CN0T73px63exy7euJcszA", "huhQG2sMvnOqa4euC2BEZ8JWeISus9vdkA4ymvKMoQ"
  provider :identity, on_failed_registration: lambda { |env|
      SessionsController.action(:new).call(env)
    }
end
