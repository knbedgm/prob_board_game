Code.require_file("sim.ex")

IO.puts("start")
# trials = 10000
# results = Sim.run(trials,Sim.card_list)
# IO.puts "done1"

trials = 50_000
attempts = 100_000
iv = %{0 => 1_706_262_786, 1 => 1_790_943_212, 2 => 1_104_230_049, 3 => 398_563_953}

stream =
  Stream.repeatedly(fn -> Sim.run(trials, Sim.card_list()) end)
  |> Stream.scan(
    iv,
    fn count, acume ->
      Map.merge(count, acume, fn _, a, b -> a + b end)
    end
  )
  |> Stream.take(attempts)

# IO.puts("built")

# Enum.each(stream, &(IO.puts("#{inspect &1}, \t#{:erlang.float_to_binary(Sim.make_EV(&1), [decimals: 10])}")))
Enum.each(stream, &IO.puts("#{inspect(&1)}, \t#{Sim.make_ev(&1)}"))
IO.puts("done")
IO.puts("")

# IO.puts(inspect(results))
# IO.puts(results |> Enum.reduce(0, fn {v, c}, a -> v * c / trials + a end))
