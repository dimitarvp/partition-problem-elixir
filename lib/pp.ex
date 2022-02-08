defmodule PP do
  @moduledoc """
  This module is dedicated to finding a solution of the [Partition problem](https://en.wikipedia.org/wiki/Partition_problem).
  There's a testing harness in place in this project that runs unit and property tests
  on each function from this module that begins with `impl_` and has an arity 1
  (namely takes one argument which is the list).
  """

  @doc """
  Implementation by @dimitarvp that keeps track of two running sums and adds the largest
  element from the input list to the list whose sum is smaller.
  Adapted from old Java sources of mine and [this article](https://prismoskills.appspot.com/lessons/Arrays/Divide_into_two_equal_sums.jsp).
  """
  def impl_dimitarvp(list) when is_list(list) do
    list
    |> Enum.sort(:desc)
    |> Enum.reduce({[], [], 0, 0}, fn x, {left_list, right_list, left_sum, right_sum} ->
      if left_sum <= right_sum do
        {[x | left_list], right_list, left_sum + x, right_sum}
      else
        {left_list, [x | right_list], left_sum, right_sum + x}
      end
    end)
  end

  def impl_aetherus(list) when is_list(list) do
    {{sum1, sum2}, _, {part1, part2}} = PP.Impls.Aetherus.solve(list)
    {part1, part2, sum1, sum2}
  end
end
