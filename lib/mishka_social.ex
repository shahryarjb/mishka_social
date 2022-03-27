defmodule MishkaSocial do
  # TODO: Determine a default struct to send request
  # TODO: Determine it is a login part or register
  # TODO: If user select login but he/she does not exist before what we should do
  # TODO: Make a way for Api and html endpoint
  # TODO: Use MishkaCms limiter for allowed login number
  # TODO: This part of live should use MishkaCms out put, Both from Api and Html
  # TODO: Should have a connection with identity db of MishkaUser

  def auth(:html, _socket) do
    # TODO: It should cover either login or register
  end

  def auth(:api, _conn) do
    # TODO: It should cover either login or register
  end

  def get_config(item) do
    :mishka_social
    |> Application.fetch_env!(:social)
    |> Keyword.fetch!(item)
  end

  def router, do: MishkaInstaller.get_config(:html_router)

  def cms_module_loads(module) do
    case Code.ensure_compiled(module) do
      {:module, _} -> {:ok, :cms_module_loads, module}
      {:error, _} ->
        {:error, :cms_module_loads,
        "This library should be under MishkaCMS's apps. Hence, the mix file you target should have access to mishka_conetent and mishka_user"
      }
    end
  end
end
