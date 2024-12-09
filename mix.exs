defmodule DeepseekEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :deepseek_ex,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex metadata
      description: "A client for interacting with the Deepseek API.",
      package: package(),
      source_url: "https://github.com/ironicgitposting/deepseek_ex",
      homepage_url: "https://github.com/ironicgitposting/deepseek_ex",
      licenses: ["MIT"],
      maintainers: ["Your Name"]
    ]
  end

  defp package do
    [
      name: :deepseek_ex,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/ironicgitposting/deepseek_ex",
        "Docs" => "https://hexdocs.pm/deepseek_ex"
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.15"},
      {:jason, "~> 1.4"}
    ]
  end
end
