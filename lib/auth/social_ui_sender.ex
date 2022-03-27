defmodule MishkaSocial.Auth.SocailUiSender do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  alias MishkaInstaller.Reference.OnUserBeforeLogin

  @spec render(Phoenix.LiveView.Socket.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
      <h4 style="font-family: tahoma; color: #6a85b5;">Login/Register with Social networks</h4>
      <span>
        <%= link raw('<i class="bi bi-google"></i>'), to: MishkaSocial.router().auth_path(@socket, :login, params: params(:google)), method: :post %>
        <%= link raw('<i class="bi bi-github"></i>'), to: MishkaSocial.router().auth_path(@socket, :login, params: params(:github)), method: :post %>
        <%= link raw('<i class="bi bi-facebook"></i>'), to: MishkaSocial.router().auth_path(@socket, :login, params: params(:facebook)), method: :post %>
        <%= link raw('<i class="bi bi-twitter"></i>'), to: MishkaSocial.router().auth_path(@socket, :login, params: params(:twitter)), method: :post %>
        <%= link raw('<i class="bi bi-apple"></i>'), to: MishkaSocial.router().auth_path(@socket, :login, params: params(:apple)), method: :post %>
      </span>
    """
  end

  @spec action(Phoenix.LiveView.Socket.assigns(), OnUserBeforeLogin.t()) :: Phoenix.LiveView.Rendered.t()
  def action(assigns, state) do
    state.output # the previous plugin output if it exists.
    render(assigns) # create a new one and merge with the last output
  end

  defp params(social) do
    %{struct: MishkaSocial.Auth.Strategy, endpoint: "html",  id: social}
  end
end
