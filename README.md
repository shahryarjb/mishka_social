# MishkaSocial
MishkaSocial is a plugin for MishkaCms as a social networking gateway

## Social Auth

### Put these below lines to your project config file
```elixir 
config :ueberauth, Ueberauth,
base_path: "/auth",
providers: [
   # For now, we need normal information of a user, but in the future it  should be possible to use dynamic default_scope
   # /auth/github?scope=user,public_repo
  github: {Ueberauth.Strategy.Github, [default_scope: "read:user", send_redirect_uri: false]},
  google: {Ueberauth.Strategy.Google, [
     # For now, we need normal information of a user, but in the future it  should be possible to use dynamic default_scope
     # /auth/google?scope=email%20profile
     default_scope: 
     "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile"
   ]},
]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
   client_id: "YOUR_CLIENT_ID",
   client_secret: "YOUR_CLIEENT_SECRET"

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
   client_id: "YOUR_CLIENT_ID",
   client_secret: "YOUR_CLIEENT_SECRET",
   redirect_uri: "YOUR_CALL_BACK_URL"
```