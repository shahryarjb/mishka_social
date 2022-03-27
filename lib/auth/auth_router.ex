defimpl MishkaSocial.AuthProtocol, for: MishkaSocial.Auth.Strategy do
  @spec login(MishkaSocial.Auth.Strategy.t()) :: Plug.Conn.t()
  def login(%MishkaSocial.Auth.Strategy{conn: conn, endpoint: "html", id: social, callback: callback}) do
    MishkaSocial.Auth.HandelRequest.handle_social_sender(%MishkaSocial.Auth.Strategy{conn: conn, endpoint: "html", id: social, callback: callback})
  end

  def register(%MishkaSocial.Auth.Strategy{conn: conn, endpoint: "html", id: social, callback: _callback}) do
    callback = Map.drop(Map.get(conn, :params), ["params"])
    MishkaSocial.Auth.HandelRequest.handel_social_callback(%MishkaSocial.Auth.Strategy{conn: conn, endpoint: "html", id: social, callback: callback})
  end
end
