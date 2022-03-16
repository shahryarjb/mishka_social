defmodule MishkaSocial.MixProject do
  use Mix.Project

  def project do
    [
      app: :mishka_social,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {MishkaSocial.Application, []}
    ]
  end

  defp deps do
    [
      {:ueberauth, "~> 0.7.0"},
      {:ueberauth_google, "~> 0.10.1"},
      {:ueberauth_github, "~> 0.8.1"}
    ]
  end
end
