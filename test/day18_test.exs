defmodule Day18Test do
  use ExUnit.Case

  test "sum of all expressions is found" do
    homework = [
      "1 + 2 * 3 + 4 * 5 + 6",
      "1 + (2 * 3) + (4 * (5 + 6))",
      "2 * 3 + (4 * 5)",
      "5 + (8 * 3 + 9 + 3 * 4 * 3)",
      "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
      "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
    ]

    assert 26457 = ExpressionEvaluator.sum_expressions(homework)
  end

  test "sum of all expressions is found using operator precedence" do
    homework = [
      "1 + 2 * 3 + 4 * 5 + 6",
      "1 + (2 * 3) + (4 * (5 + 6))",
      "2 * 3 + (4 * 5)",
      "5 + (8 * 3 + 9 + 3 * 4 * 3)",
      "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
      "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
    ]

    assert 694173 = ExpressionEvaluator.sum_expressions_with_precedence(homework)
  end
end
