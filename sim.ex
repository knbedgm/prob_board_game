defmodule Sim do
  def card_list do
    [
      {:yellow, 1, 4 / 6},
      {:yellow, 1, 4 / 6},
      {:yellow, 1, 4 / 6},
      {:yellow, 2, 3 / 6},
      {:yellow, 2, 3 / 6},
      {:yellow, 3, 2 / 6},
      {:blue, 1, 4 / 6},
      {:blue, 1, 4 / 6},
      {:blue, 1, 4 / 6},
      {:blue, 2, 3 / 6},
      {:blue, 2, 3 / 6},
      {:blue, 3, 2 / 6},
      {:green, 1, 4 / 6},
      {:green, 1, 4 / 6},
      {:green, 1, 4 / 6},
      {:green, 2, 3 / 6},
      {:green, 2, 3 / 6},
      {:green, 3, 2 / 6},
      {:red, 1, 4 / 6},
      {:red, 1, 4 / 6},
      {:red, 1, 4 / 6},
      {:red, 2, 3 / 6},
      {:red, 2, 3 / 6},
      {:red, 3, 2 / 6}
    ]
  end

  def getPointsFromHand(hand, color) do
    dice = Enum.random(1..6)

    filtered_hand =
      hand
      |> Stream.filter(fn {c, n, _} ->
        c == color && dice in Enum.take_random([1, 2, 3, 4, 5, 6], 5 - n)
      end)

    dice_list = filtered_hand
    # |> Stream.map(fn c -> {c, Enum.take_random([1, 2, 3, 4, 5, 6], trunc(elem(c, 2) * 6))} end)

    points =
      dice_list
      # |> Enum.reduce(0, fn {{_, c, _}, d}, p ->
      #   if dice in d do
      #     max(c, p)
      #   else
      #     p
      #   end
      # end)
      |> Enum.reduce(0, fn {_, c, _}, p -> max(c, p) end)

    points
  end

  def run(trials, card_list) do
    for _ <- 1..trials do
      shuffled = Enum.take_random(card_list, 3)
      points = Sim.getPointsFromHand(shuffled, elem(hd(shuffled), 0))
      # for {col, val, _} <- shuffled do
      # IO.puts [to_string(val)," ",to_string(col)]
      # end
      # IO.puts points
      # IO.puts ""
      points
    end
    |> Enum.frequencies()
  end

  def small do
    run(1000, card_list())
  end

  def make_ev(data) do
    total = count(data)
    data |> Enum.reduce(0, fn {v, c}, a -> v * c / total + a end)
  end

  def count(data) do
    data |> Enum.reduce(0, fn {_, c}, a -> c + a end)
  end

  def merge(d1, d2) do
    Map.merge(d1, d2, fn _, a, b -> a + b end)
  end
end
