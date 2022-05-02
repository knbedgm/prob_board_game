defmodule SimAggregator do
  use GenServer

  def start_link(gen_count, target, iv \\ %{}) do
    GenServer.start_link(__MODULE__, {gen_count, target, iv})
  end

  def add_data(pid, data) do
    GenServer.cast(pid, {:add_data, data})
  end

  def get_data(pid) do
    GenServer.call(pid, :get_data)
  end

  def is_running?(pid) do
    GenServer.call(pid, :is_running)
  end

  def stop(pid) when is_pid(pid) do
    GenServer.cast(pid, :stop)
  end

  @impl true
  def init({gen_count, target, iv}) do
    pid_list =
      for _ <- 1..gen_count do
        {:ok, pid} = SimGenerator.start_link(50_000, __MODULE__, :add_data, [self()])
        pid
      end

    {:ok, %{generators: pid_list, target: target, data: iv, running: true}}
  end

  @impl true
  def handle_call(:get_data, _from, state) do
    {:reply, {Sim.count(state[:data]), Sim.make_ev(state[:data]), state[:data]}, state}
  end

  @impl true
  def handle_call(:is_running, _from, state) do
    {:reply, state[:running], state}
  end

  @impl true
  def handle_cast({:add_data, data_in}, state = %{running: true}) do
    new_data = Sim.merge(state[:data], data_in)

    if Sim.count(new_data) >= state[:target] do
      stop(self())
      {:noreply, state |> Map.replace(:data, new_data) |> Map.replace(:running, false)}
    end

    {:noreply, Map.replace(state, :data, new_data)}
  end

  def handle_cast({:add_data, _}, state = %{running: false}) do
    {:noreply, state}
  end

  @impl true
  def handle_cast(:stop, state) do
    for pid <- state[:generators] do
      SimGenerator.stop(pid)
    end

    {:noreply, Map.replace(state, :running, false)}
  end
end
