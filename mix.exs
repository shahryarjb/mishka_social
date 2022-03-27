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
      {:mishka_installer, git: "https://github.com/mishka-group/mishka_installer.git"},
      {:ueberauth, "~> 0.7.0"},
      {:ueberauth_google, "~> 0.10.1"},
      {:ueberauth_github, "~> 0.8.1"},
      {:phoenix, "~> 1.6"},
      {:phoenix_live_view, "~> 0.17.7"}
    ]
  end
end
