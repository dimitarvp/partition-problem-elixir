# Partition problem #

This is an Elixir project demonstrating implementations of algorithms that solve the [Partition problem](https://en.wikipedia.org/wiki/Partition_problem).

# Installation #

- Clone this repo.
- Run `mix deps.get`

# Adding your algorithm implementation #
Create a function in `lib/pp.ex` whose name starts with `impl_` and is preferrably ending with your GIT username. The function must accept a single argument -- list of integers. Check the first reference implementation for guidance.

# Testing your algorithm implementation #
As long as you adhere to the above specification of your function in the `PP` module then simply running `mix test` will check all implementations, yours included.

# Changes to this repository #
The author is open to PRs containing alternative implementations. PRs that change the default unit tests and introduce additional property tests are welcome as well.

Additionally, the plan is to add benchmarking if there is more than one implementation.
