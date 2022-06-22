# MishkaSocial
MishkaSocial is a plugin for [MishkaCms](https://github.com/mishka-group/mishka-cms) as a social networking gateway

## Social Auth
Authentication with social networks connection is one of important part of this library. We use Ueberauth library to do this, for example you can log in with Google and GitHub without password or registering without fulling fields.

### Put these below lines to your project config file
```elixir 
# ueberauth config can delete in developer pkg
config :ueberauth, Ueberauth,
base_path: "/auth",
providers: [
   # For now, we need normal information of a user, but in the future it  should be possible to use dynamic default_scope
   # /auth/github?scope=user,public_repo
  github: {Ueberauth.Strategy.Github, [default_scope: "read:user", send_redirect_uri: false]},
  google: {Ueberauth.Strategy.Google, [
     default_scope:
     "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile"
   ]}
]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
   client_id: System.get_env("GITHUB_CLIENT_ID"),
   client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
   client_id: System.get_env("GOOGLE_CLIENT_ID"),
   client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
   redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")
```