defmodule PPPropertyTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  @functions Enum.filter(PP.__info__(:functions), fn {n, i} ->
               String.starts_with?("#{n}", "impl_") and i == 1
             end)

  # Generate property tests for each function that implements the algorithm.
  @functions
  |> Enum.each(fn {name, _arity} ->
    property "#{name}: left list sum must be less than the input list sum" do
      check all(input <- list()) do
        {_llist, _rlist, lsum, _rsum} = PP.unquote(name)(input)
        assert lsum < Enum.sum(input)
      end
    end

    property "#{name}: right list sum must be less than the input list sum" do
      check all(input <- list()) do
        {_llist, _rlist, _lsum, rsum} = PP.unquote(name)(input)
        assert rsum < Enum.sum(input)
      end
    end

    property "#{name}: adding result lists sums must equal the input list sum" do
      check all(input <- list()) do
        {_llist, _rlist, lsum, rsum} = PP.unquote(name)(input)
        assert Enum.sum(input) == lsum + rsum
      end
    end

    property "#{name}: merging the result lists and sorting the result must equal the input list" do
      check all(input <- list()) do
        {llist, rlist, _lsum, _rsum} = PP.unquote(name)(input)
        assert Enum.sort(input) == Enum.sort(Enum.concat(llist, rlist))
      end
    end
  end)

  defp list() do
    gen all(l <- list_of(element(), min_length: 2, max_length: 32)) do
      l
    end
  end

  defp element() do
    gen all(i <- positive_integer(), i <= 18_000_000_000_000) do
      i
    end
  end
end
