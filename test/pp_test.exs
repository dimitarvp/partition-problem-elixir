defmodule PPTest do
  use ExUnit.Case
  doctest PP

  @inputs [
    [1, 3, 4, 5, 7, 8, 9, 11, 65, 74, 83, 100],
    [1, 2, 3, 4],
    [1, 2, 3, 4, 5],
    [6000, 3000, 480, 240, 120],
    [3, 1, 1, 2, 2, 1],
    [1, 1, 1, 1, 1, 1, 1, 50, 50, 100],
    [2, 3, 10, 5, 8, 9, 7, 3, 5, 2]
  ]

  @expected_results [
    {[4, 7, 9, 65, 100], [1, 3, 5, 8, 11, 74, 83], 185, 185},
    {[1, 4], [2, 3], 5, 5},
    {[1, 2, 5], [3, 4], 8, 7},
    {[6000], [120, 240, 480, 3000], 6000, 3840},
    {[1, 1, 3], [1, 2, 2], 5, 5},
    {[1, 1, 1, 1, 100], [1, 1, 1, 50, 50], 104, 103},
    {[2, 3, 5, 7, 10], [2, 3, 5, 8, 9], 27, 27}
  ]

  @inputs_to_expected_results Enum.zip(@inputs, @expected_results)

  @functions Enum.filter(PP.__info__(:functions), fn {n, i} ->
               String.starts_with?("#{n}", "impl_") and i == 1
             end)

  # Generate several hardcode tests for each function that implements the algorithm.
  for {name, _} <- @functions,
      {input, expected} <- @inputs_to_expected_results,
      expected = Macro.escape(expected) do
    test("#{name}: #{inspect(input)}") do
      assert unquote(expected) == PP.unquote(name)(unquote(input))
    end
  end
end
