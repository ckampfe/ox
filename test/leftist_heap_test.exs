defmodule LeftistHeapTest do
  use ExUnit.Case, async: true
  require Ox.LeftistHeap, as: Heap
  use ExUnitProperties

  test "creates a new empty heap" do
    leq = fn(x, y) -> x <= y end
    assert %Heap{heap: nil, leq: leq} == Heap.new(leq)
  end

  property "min always gets min" do
    leq = fn(x, y) -> x <= y end

    check all list <- nonempty(list_of(integer())),
              min = Enum.min(list),
              max_runs: 500 do

      heap = Heap.new(list, leq)
      assert min == Heap.min(heap)
    end
  end

  property "delete_min always deletes min" do
    leq = fn(x, y) -> x <= y end

    check all list <- nonempty(list_of(integer())),
              min = Enum.min(list),
              max_runs: 500 do

      heap = Heap.new(list, leq)
      assert min <= Heap.delete_min(heap) |> Heap.min
    end
  end

  property "count always returns the right count" do
    leq = fn(x, y) -> x <= y end

    check all list <- nonempty(uniq_list_of(integer(), max_tries: 500)),
              count = Enum.count(list),
              max_runs: 500 do

      heap = Heap.new(list, leq)
      assert count == Heap.count(heap)
    end
  end

  property "always works for strings too" do
    leq = fn(x, y) -> x <= y end

    check all list <- nonempty(list_of(string(:alphanumeric))),
              min = Enum.min(list),
              max_runs: 100 do

      heap = Heap.new(list, leq)
      assert min == Heap.min(heap)
    end
  end
end
