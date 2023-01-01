defmodule CarlaTest do
  use ExUnit.Case
  doctest Carla

  test "greets the world" do
    assert Carla.hello() == :world
  end
end
