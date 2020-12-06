defmodule Day6Test do
  use ExUnit.Case

  test "union of all group members' delcarations are combined" do
    assert MapSet.new(["a", "b", "c"]) ==
      CustomsForm.group_declarations_union("abc")
    assert MapSet.new(["a", "b", "c"]) ==
      CustomsForm.group_declarations_union("""
      a
      b
      c
      """)
    assert MapSet.new(["a", "b", "c"]) ==
      CustomsForm.group_declarations_union("""
      ab
      ac
      """)
    assert MapSet.new(["a"]) ==
      CustomsForm.group_declarations_union("""
      a
      a
      a
      a
      """)
    assert MapSet.new(["b"]) ==
      CustomsForm.group_declarations_union("b")
  end

  test "intersection of all group members' delcarations are combined" do
    assert MapSet.new(["a", "b", "c"]) ==
      CustomsForm.group_declarations_intersection("abc")
    assert MapSet.new([]) ==
      CustomsForm.group_declarations_intersection("""
      a
      b
      c
      """)
    assert MapSet.new(["a"]) ==
      CustomsForm.group_declarations_intersection("""
      ab
      ac
      """)
    assert MapSet.new(["a"]) ==
      CustomsForm.group_declarations_intersection("""
      a
      a
      a
      a
      """)
    assert MapSet.new(["b"]) ==
      CustomsForm.group_declarations_intersection("b")
  end
end
