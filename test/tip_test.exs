defmodule TipTest do
  use ExUnit.Case
  doctest Tip

  test "greets the world" do
    assert Tip.hello() == :world
  end
end
