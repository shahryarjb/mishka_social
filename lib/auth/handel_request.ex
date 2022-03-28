defmodule MishkaSocial.Auth.HandelRequest do
  use Phoenix.Controller, namespace: MishkeSocialWeb
  import Plug.Conn
  # TODO: it should be changeable
  @social_integrations ["google", "github", "facebook", "twitter"]

  @spec handle_social_sender(MishkaSocial.Auth.Strategy.t()) :: Plug.Conn.t()
  def handle_social_sender(%MishkaSocial.Auth.Strategy{conn: conn, endpoint: "html", id: social, callback: _callback}) when social in @social_integrations do
    Map.merge(conn, %{request_path: "/auth/#{social}", method: "GET"})
    |> Ueberauth.call(Ueberauth.init([]))
    |> halt()
  end

  def handle_social_sender(%MishkaSocial.Auth.Strategy{conn: conn}), do: invalid_social_integrations(conn)

  @spec handel_social_callback(MishkaSocial.Auth.Strategy.t()) :: Plug.Conn.t()
  def handel_social_callback(%MishkaSocial.Auth.Strategy{conn: conn, endpoint: "html", id: social, callback: callback}) when social in @social_integrations do
    Map.merge(conn, %{request_path: "/auth/#{social}/callback", method: "GET"})
    |> Ueberauth.call(Ueberauth.init(callback |> Map.to_list))
    |> callback(conn)
  end

  def handel_social_callback(%MishkaSocial.Auth.Strategy{conn: conn}), do: invalid_social_integrations(conn)

  # When your authentication is success, you get information about a user like this:
  # ueberauth_auth: %Ueberauth.Auth{
  #   credentials: %Ueberauth.Auth.Credentials{
  #     ...
  #   },
  #   extra: %Ueberauth.Auth.Extra{
  #     raw_info: %{
  #       token: %OAuth2.AccessToken{
  #         ...
  #       },
  #       user: %{
  #         ....
  #       }
  #     }
  #   },
  #   info: %Ueberauth.Auth.Info{
  #     ....
  #   },
  #   provider: :github,
  #   strategy: Ueberauth.Strategy.Github,
  #   uid: ....
  # }
  defp callback(%{assigns: %{ueberauth_auth: auth}}, conn) do
    with {{:ok, :cms_module_loads, user_module}, :user} <- {MishkaSocial.cms_module_loads(MishkaUser.User), :user},
         {:ok, :get_record_by_field, :user, user_info} <- user_module.show_by_email(auth.info.email),
         {:user_is_not_deactive, false} <- {:user_is_not_deactive, user_info.status == :inactive},
         {{:ok, :cms_module_loads, user_token_module}, :user_token_module} <- {MishkaSocial.cms_module_loads(MishkaUser.Token.Token), :user_token_module},
         {:ok, :save_token, token} <- user_token_module.create_token(user_info, :current),
         {{:ok, :cms_module_loads, home_router_module}, :home_router} <- {MishkaSocial.cms_module_loads(MishkaHtmlWeb.HomeLive), :home_router},
         {{:ok, :cms_module_loads, user_identity_module}, :user_identity} <- {MishkaSocial.cms_module_loads(MishkaUser.User), :user_identity} do

        # We do not need to check this function's answer
        user_identity_module.create(%{"user_id" => user_info.id, "identity_provider" => auth.provider, "provider_uid" => auth.uid})

        conn
        |> renew_session()
        |> put_session(:current_token, token)
        |> put_session(:user_id, user_info.id)
        |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(user_info.id)}")
        |> put_flash(:info, "You have successfully entered the site")
        |> redirect(to: "#{MishkaSocial.router().live_path(conn, home_router_module)}")
    else
      {{:error, :cms_module_loads, msg}, _} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: "/")

      {:error, :get_record_by_field, _error_atom} -> register(auth, conn)
      {:user_is_not_deactive, true} ->
        conn
        |> put_flash(:error, "Your account was deactivated, you should activate your account with sending the request.")
        |> redirect(to: "#{MishkaSocial.router().auth_path(conn, :login)}")

      {:error, :more_device, _error_tag} ->
        conn
        |> put_flash(:error, "Your account was entered more than 5 times, if you want to log in again please sign out of one of them.")
        |> redirect(to: "#{MishkaSocial.router().auth_path(conn, :login)}")

      _error ->
        conn
        |> put_flash(:error, "An unhandled error happened, if you are sure your request is true, and it happens again please contact with our support.")
        |> redirect(to: "#{MishkaSocial.router().auth_path(conn, :login)}")
    end
  end

  # When your authentication is failed you get some output like this, it is a map and struct type
  # %Ueberauth.Failure{
  #   errors: [
  #     %Ueberauth.Failure.Error{
  #       message: "The code passed is incorrect or expired.",
  #       message_key: "bad_verification_code"
  #     }
  #   ],
  #   provider: :github,
  #   strategy: Ueberauth.Strategy.Github
  # }
  defp callback(%{assigns: %{ueberauth_failure: _fails}}, conn)do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "#{MishkaSocial.router().live_path(conn, MishkeInstallerDeveloperWeb.LiveTestPageOne)}")
  end

  defp register(auth, conn) do
    with {{:ok, :cms_module_loads, user_module}, :user} <- {MishkaSocial.cms_module_loads(MishkaUser.User), :user},
         {:ok, :add, _error_tag, repo_data} <- user_module.create(%{"full_name" => auth.info.name, "email" => auth.info.email}),
         {{:ok, :cms_module_loads, user_identity_module}, :user_identity} <- {MishkaSocial.cms_module_loads(MishkaUser.User), :user_identity} do

        user_identity_module.create(%{"user_id" => repo_data.id, "identity_provider" => auth.provider, "provider_uid" => auth.uid})

        callback(%{assigns: %{ueberauth_auth: auth}}, conn)
    else
      {{:error, :cms_module_loads, msg}, _} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: "/")

      _ ->
        conn
        |> put_flash(:error, "An unhandled error happened, Please register in our site directly, after registration you can connect your social networks to your account.")
        |> redirect(to: "/")
    end
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp invalid_social_integrations(conn) do
    case MishkaSocial.cms_module_loads(MishkaHtmlWeb.HomeLive) do
      {:ok, :cms_module_loads, login_router_module} ->
        conn
        |> put_flash(:error, "Your social network is not connected or it is invalid.")
        |> redirect(to: "#{MishkaSocial.router().live_path(conn, login_router_module)}")

      {:error, :cms_module_loads, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: "/")
    end
  end
end
