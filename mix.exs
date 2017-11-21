defmodule DigitalCurrency.Mixfile do
  use Mix.Project

  def project do
    [
      app: :digital_currency,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpotion, :table_rex, :timex]
    ]
  end

  def escript do
    [main_module: DigitalCurrency.Cli]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.0.2"},
      {:poison, "~> 3.1"},
      {:table_rex, "~> 0.10"},
      {:money, "~> 1.2.1"},
      {:timex, "~> 3.0"},
      {:html_entities, "~> 0.3"}
    ]
  end
end
