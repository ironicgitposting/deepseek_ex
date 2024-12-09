defmodule DeepseekEx.Client do
  alias Finch.Response
  require Logger

  @moduledoc """
  A client for interacting with the Deepseek API.
  """

  @doc """
  Starts the Finch child process with custom pool settings.
  """
  def child_spec do
    pool_size = Application.get_env(:deepseek_ex, :pool_size, 20)
    idle_timeout = Application.get_env(:deepseek_ex, :idle_timeout, 200_000)
    checkout_timeout = Application.get_env(:deepseek_ex, :checkout_timeout, 15_000)

    {
      Finch,
      name: __MODULE__,
      pools: %{
        default: [
          size: pool_size,
          idle_timeout: idle_timeout,
          checkout_timeout: checkout_timeout
        ]
      }
    }
  end

  @doc """
  Generates content using the Deepseek API.
  """
  def generate_content(text, system_prompt \\ "You are a helpful assistant.", format \\ :text) do
    api_key = Application.fetch_env!(:deepseek_ex, :api_key)
    url = "https://api.deepseek.com/chat/completions"

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{api_key}"}
    ]

    body = %{
      "messages" => [
        %{"content" => system_prompt, "role" => "system"},
        %{"content" => text, "role" => "user"}
      ],
      "model" => "deepseek-chat",
      "response_format" => %{"type" => Atom.to_string(format)},
      "max_tokens" => 4096,
      "temperature" => 1,
      "top_p" => 1
    }
    |> Jason.encode!()

    :post
    |> Finch.build(url, headers, body)
    |> Finch.request(__MODULE__, receive_timeout: 200_000)
    |> handle_response()
  end

  defp handle_response({:ok, %Response{status: 200, body: body}}) do
    case Jason.decode(body) do
      {:ok, decoded} -> {:ok, decoded}
      {:error, _error} -> {:error, :failed_to_decode}
    end
  end

  defp handle_response({:error, reason}), do: {:error, :request_failed, reason}
end
