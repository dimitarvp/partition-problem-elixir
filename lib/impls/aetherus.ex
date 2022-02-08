defmodule PP.Impls.Aetherus do
  @spec solve([pos_integer()]) :: {
          {partition1_sum :: non_neg_integer(), partition2_sum :: non_neg_integer()},
          {partition1_length :: non_neg_integer(), partition2_length :: non_neg_integer()},
          {partition1 :: [pos_integer()], partition2 :: [pos_integer()]}
        }
  def solve(nums) do

    # Reversely sort the nums
    # so that subset-sum can converge faster
    nums =
      nums
      |> Enum.sort()
      |> Enum.reverse()

    sum = Enum.sum(nums)
    len = length(nums)
    sum_target = div(sum, 2)
    len_target = div(len, 2)

    {sum_diff, len_diff, partition1} =
      Task.async(fn ->
        closest_subset_sum(Enum.with_index(nums), sum_target, len_target)
      end)
      |> Task.await(:infinity)

    partition2 =
      nums
      |> List.myers_difference(partition1)
      |> Keyword.get_values(:del)
      |> List.flatten()

    {
      {sum_target + sum_diff, sum - sum_target - sum_diff},
      {len_target + len_diff, len - len_target - len_diff},
      {partition1, partition2}
    }
  end

  @spec closest_subset_sum(
          [{item :: pos_integer(), index :: non_neg_integer()}],
          non_neg_integer(),
          non_neg_integer()
        ) ::
          {integer(), integer(), [pos_integer()]}
  defp closest_subset_sum([], sum_target, length_target) do
    {-sum_target, -length_target, []}
  end

  # Truncates the cases
  defp closest_subset_sum(_, sum_target, length_target) when sum_target <= 0 do
    {-sum_target, -length_target, []}
  end

  defp closest_subset_sum([{h, i} | t], sum_target, length_target) do
    key = {i, sum_target, length_target}

    case Process.get(key) do
      solution when solution != nil ->
        solution

      nil ->
        {sum_diff1, len_diff1, solution1} =
          closest_subset_sum(t, sum_target - h, length_target - 1)

        {sum_diff2, len_diff2, solution2} = closest_subset_sum(t, sum_target, length_target)

        cond do
          abs(sum_diff1) < abs(sum_diff2) ->
            {sum_diff1, len_diff1, [h | solution1]}

          abs(sum_diff1) > abs(sum_diff2) ->
            {sum_diff2, len_diff2, solution2}

          abs(len_diff1) <= abs(len_diff2) ->
            {sum_diff1, len_diff1, [h | solution1]}

          true ->
            {sum_diff2, len_diff2, solution2}
        end
        |> tap(fn solution -> Process.put(key, solution) end)
    end
  end
end
