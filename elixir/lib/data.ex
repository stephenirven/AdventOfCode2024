defmodule Data do
  # Read in data
  def read(number) do
    Path.expand("../inputs/#{number}.txt", __DIR__)
    |> File.read!()
  end
end
