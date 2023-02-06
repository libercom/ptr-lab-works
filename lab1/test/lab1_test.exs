defmodule Lab1Test do
  use ExUnit.Case
  doctest Lab1, async: true

  test "hello test" do
    assert Lab1.hello() == "Hello PTR"
  end
end
