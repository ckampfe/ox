defmodule Ox.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ox,
      version: "0.1.0",
      elixir: "~> 1.5",
      package: package(),
      description: "An implementation of Okasaki data structures",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:stream_data, "~> 0.3", only: [:test, :dev]},
      {:ex_doc, "~> 0.14", only: :dev},
      {:benchee, "~> 0.13", only: :dev}
    ]
  end

  def package do
    [
      maintainers: ["Clark Kampfe"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/ckampfe/ox"}
    ]
  end
end
