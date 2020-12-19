defmodule ExpressionEvaluator do
  def sum_expressions_with_precedence(expressions) do
    expressions
    |> Enum.map(fn e ->
      String.codepoints(e)
      |> Enum.reject(&(&1 == " "))
    end)
    |> Enum.map(&evaluate_with_precedence/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def sum_expressions(expressions) do
    expressions
    |> Enum.map(fn e ->
      String.codepoints(e)
      |> Enum.reject(&(&1 == " "))
    end)
    |> Enum.map(&evaluate/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp evaluate_with_precedence(expression) do
    {operators, values} = eval_with_precedence([], [], expression)
    combine(operators, values)
  end

  defp evaluate(expression) do
    {operators, values} = eval([], [], expression)
    combine(operators, values)
  end

  defp combine([], [final_value]), do: final_value
  defp combine(operators, values) do
    {ops, vals} = calculate_result(operators, values)
    combine(ops, vals)
  end

  defp eval_with_precedence(operators, values, []), do: {operators, values}
  defp eval_with_precedence(operators, values, [t | expr]) do
    case t do
      "(" -> eval_with_precedence([t | operators], values, expr)
      "*" ->
        {o, v} = apply_operators(t, operators, values)
        eval_with_precedence([t | o], v, expr)
      "+" ->
        {o, v} = apply_operators(t, operators, values)
        eval_with_precedence([t | o], v, expr)
      ")" ->
        {o, v} = rollup(operators, values)
        eval_with_precedence(o, v, expr)
      _ -> eval_with_precedence(operators, [t | values], expr)
    end
  end

  defp eval(operators, values, []), do: {operators, values}
  defp eval(operators, values, [t | expr]) do
    case t do
      "(" -> eval([t | operators], values, expr)
      "*" ->
        {o, v} = apply_operators(operators, values)
        eval([t | o], v, expr)
      "+" ->
        {o, v} = apply_operators(operators, values)
        eval([t | o], v, expr)
      ")" ->
        {o, v} = rollup(operators, values)
        eval(o, v, expr)
      _ -> eval(operators, [t | values], expr)
    end
  end

  defp rollup(["(" | operators], values), do: {operators, values}
  defp rollup(operators, values) do
    {ops, vals} = calculate_result(operators, values)
    rollup(ops, vals)
  end

  defp apply_operators(_, ops = [], values), do: {ops, values}
  defp apply_operators(_, ops = ["(" | _], values), do: {ops, values}
  defp apply_operators(_, ops = [")" | _], values), do: {ops, values}
  defp apply_operators("+", ops = ["*" | _], values), do: {ops, values}
  defp apply_operators(cur_op, ops, values) do
    {ops, vals} = calculate_result(ops, values)
    apply_operators(cur_op, ops, vals)
  end

  defp apply_operators(operators = [], values), do: {operators, values}
  defp apply_operators(operators = ["(" | _], values), do: {operators, values}
  defp apply_operators(operators = [")" | _], values), do: {operators, values}
  defp apply_operators(operators, values) do
    {ops, vals} = calculate_result(operators, values)
    apply_operators(ops, vals)
  end

  defp calculate_result(operators, values) do
    [operator | rest_of_ops] = operators
    [a | [b | rest_of_vals]] = values

    case operator do
      "*" ->
        result = String.to_integer(b) * String.to_integer(a)
        {rest_of_ops, ["#{result}" | rest_of_vals]}
      "+" ->
        result = String.to_integer(b) + String.to_integer(a)
        {rest_of_ops, ["#{result}" | rest_of_vals]}
    end
  end
end
