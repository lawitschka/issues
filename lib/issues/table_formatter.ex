defmodule Issues.TableFormatter do
  @moduledoc """
  Prints a list of maps formatted as table to standard output.
  """

  def format(list_of_maps, columns) do
    column_widths = Enum.reduce columns, %{}, fn col, result ->
      Map.put(result, col, max_value_length(list_of_maps, col))
    end

    print_header(columns, column_widths)
    print_separator(columns, column_widths)
    print_maps(list_of_maps, columns, column_widths)
  end

  defp max_value_length(list_of_maps, key) do
    _max_value_length(list_of_maps, key, String.length(key))
  end

  defp _max_value_length([], _, max_length) do
    max_length
  end

  defp _max_value_length([head | tail], key, current_max_length) do
    new_max_length = head
                     |> Map.get(key)
                     |> (&("#{&1}")).()
                    #  |> (fn(value) -> "#{value}" end).()
                     |> String.length
                     |> max(current_max_length)

    _max_value_length(tail, key, new_max_length)
  end

  defp print_header(columns, col_widths) do
    columns
    |> Enum.map(&(String.pad_trailing(&1, Map.get(col_widths, &1))))
    |> Enum.join(" | ")
    |> IO.puts
  end

  defp print_separator(columns, col_widths) do
    columns
    |> Enum.map(&(String.pad_trailing("", Map.get(col_widths, &1), "-")))
    |> Enum.join("-+-")
    |> IO.puts
  end

  defp print_maps([], _, _) do
    :ok
  end

  defp print_maps([head | tail], columns, col_widths) do
    columns
    |> Enum.map(&(String.pad_trailing("#{Map.get(head, &1)}", Map.get(col_widths, &1))))
    |> Enum.join(" | ")
    |> IO.puts

    print_maps(tail, columns, col_widths)
  end
end
