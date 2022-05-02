defmodule SimGenerator do
  use GenServer

  def start_link(trials, mod, func, args) when is_list(args) do
    GenServer.start_link(__MODULE__, {trials, mod, func, args})
  end

  def stop(pid) when is_pid(pid) do
    GenServer.cast(pid, :stop)
  end

  @impl true
  def init({trials, mod, func, args}) when is_list(args) do
    {:ok, {trials, mod, func, args}, 0}
  end

  @impl true
  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  @impl true
  def handle_info(:timeout, {trials, mod, func, args}) do
    res = Sim.run(trials, Sim.card_list())
    apply(mod, func, args ++ [res])
    {:noreply, {trials, mod, func, args}, 0}
  end
end
