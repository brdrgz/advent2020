defmodule TicketDecoder do
  def find_field_order(rules, your_ticket, nearby_tickets) do
    invalid_nearby = invalid_nearby_tickets(rules, nearby_tickets)
    valid_nearby = nearby_tickets -- invalid_nearby
    fields_and_ranges = to_map_of_ranges(rules)
    fields = Map.keys(fields_and_ranges)
    possible_fields_at_indexes =
      0..(Enum.count(fields) - 1)
      |> Enum.to_list()
      |> Enum.map(&({&1, fields}))
      |> Map.new()
    tickets = [your_ticket | valid_nearby]

    find_field_order_rec(tickets, fields_and_ranges, possible_fields_at_indexes)
  end

  defp find_field_order_rec(tickets, ranges_for_field, possible_fields_at_i) do
    done? =
      possible_fields_at_i
      |> Map.to_list()
      |> Enum.all?(fn x -> Enum.count(elem(x, 1)) == 1 end)

    if done? do
      possible_fields_at_i
    else
      less_possible_fields_at_i =
        Enum.reduce_while(tickets, possible_fields_at_i, fn ticket, f_i ->
          fields_at_indexes =
            ticket
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)
            |> Enum.with_index()
            |> Enum.reduce(f_i, fn {value, i}, acc ->
            impossible_fields =
              acc
              |> Map.get(i)
              |> Enum.filter(fn field ->
                   Map.get(ranges_for_field, field)
                   |> Enum.all?(&(value not in &1))
            end)

            Map.update(acc, i, [], &(&1 -- impossible_fields))
          end)

            known_index_fields =
              fields_at_indexes
              |> Map.to_list()
              |> Enum.filter(&(Enum.count(elem(&1, 1)) == 1))

            index_fields_to_update =
              Map.to_list(fields_at_indexes) -- known_index_fields

            fields_to_remove =
              known_index_fields
              |> Enum.map(&(elem(&1, 1)))
              |> List.flatten()

            fields_at_indexes =
              index_fields_to_update
              |> Enum.map(fn {k, v} -> {k, v -- fields_to_remove} end)
              |> Enum.concat(known_index_fields)
              |> Map.new()

            all_fields_processed? =
              fields_at_indexes
              |> Map.to_list()
              |> Enum.all?(fn x ->
              Enum.count(elem(x, 1)) == 1
            end)

            if all_fields_processed? do
              {:halt, fields_at_indexes}
            else
              {:cont, fields_at_indexes}
            end
        end)

      find_field_order_rec(tickets, ranges_for_field, less_possible_fields_at_i)
    end
  end

  def invalid_nearby_ticket_values(rules, tickets) do
    rules = to_ranges(rules)

    tickets
    |> Enum.reduce([], fn ticket_row, all_invalid_ticket_values ->
      invalid_ticket_values =
        ticket_row
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> Enum.reject(fn x -> Enum.any?(rules, &(x in &1)) end)

      invalid_ticket_values ++ all_invalid_ticket_values
    end)
  end

  def to_ranges(rules) do
    rules
    |> Map.to_list()
    |> Enum.flat_map(fn {_name, rule} ->
      rule
      |> String.split(" or ")
      |> Enum.map(fn range ->
        [from, to] =
          range
          |> String.split("-")
          |> Enum.map(&String.to_integer/1)
        from..to
      end)
    end)
  end

  defp invalid_nearby_tickets(rules, nearby_tickets) do
    rules = to_ranges(rules)

    Enum.filter(nearby_tickets, fn ticket_row ->
      ticket_row
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.any?(fn x -> Enum.all?(rules, &(x not in &1)) end)
    end)
  end

  defp to_map_of_ranges(rules) do
    rules
    |> Map.to_list()
    |> Enum.map(fn {name, rule} ->
      ranges = rule
      |> String.split(" or ")
      |> Enum.map(fn range ->
        [from, to] =
          range
          |> String.split("-")
          |> Enum.map(&String.to_integer/1)
        from..to
      end)

      {name, ranges}
    end)
    |> Map.new()
  end
end
