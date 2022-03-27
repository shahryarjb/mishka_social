defmodule MishkaSocial.Auth.Strategy do
  alias MishkaInstaller.Reference.OnUserBeforeLogin

  defstruct [:conn, :endpoint, :id, callback: %{}]
  @type social() :: :google | :github | :facebook | :twitter | :apple
  @type t() :: %__MODULE__{conn: Plug.Conn.t(), endpoint: String.t(), id: social(), callback: map()}

  use MishkaInstaller.Hook,
    module: __MODULE__,
    behaviour: OnUserBeforeLogin,
    event: :on_user_before_login,
    initial: []

  @spec initial(list()) :: {:ok, OnUserBeforeLogin.ref(), list()}
  def initial(args) do
    event = %PluginState{name: "MishkaSocial.Auth.Strategy", event: Atom.to_string(@ref), priority: 1}
    Hook.register(event: event)
    {:ok, @ref, args}
  end

  @spec call(OnUserBeforeLogin.t()) :: {:reply, OnUserBeforeLogin.t()}
  def call(state) do
    new_state = Map.merge(state, %{output: MishkaSocial.Auth.SocailUiSender.action(state.assigns, state)})
    {:reply, new_state}
  end
end
