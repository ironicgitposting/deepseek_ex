defmodule DeepseekEx.ClientTest do
  use ExUnit.Case, async: true

  alias DeepseekEx.Client

  test "generate_content/2 works with valid inputs" do
    assert {:ok, _response} = Client.generate_content("Hello", "You are a helpful assistant.")
  end
end
