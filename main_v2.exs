Code.require_file("sim.ex")
Code.require_file("sim_generator.ex")
Code.require_file("sim_aggregator.ex")

# ms
report_interval = 1500
process_count = 2
target = 20_000_000_000
# target = 10_000_000
iv = %{0 => 3_412_495_146, 1 => 3_581_869_201, 2 => 2_208_527_285, 3 => 797_108_368}

IO.puts("start")

{:ok, ag_pid} = SimAggregator.start_link(process_count, target, iv)

Stream.interval(report_interval)
|> Stream.map(fn _ -> SimAggregator.get_data(ag_pid) end)
|> Stream.take_while(fn _ -> SimAggregator.is_running?(ag_pid) end)
|> Stream.each(&IO.puts(inspect(&1)))
|> Stream.run()

IO.puts(inspect(SimAggregator.get_data(ag_pid)))

IO.puts("done")
