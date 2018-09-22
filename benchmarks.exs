alias Ox.LeftistHeap, as: Heap

random = StreamData.integer() |> Stream.map(&abs/1)

[random_int] = StreamData.integer() |> Stream.map(&abs/1) |> Enum.take(1)

small = random |> Enum.take(100)
medium = random |> Enum.take(10_000)
large = random |> Enum.take(1_000_000)

int_compare_fn = fn x, y -> x <= y end

small_heap = Heap.new(small, int_compare_fn)
medium_heap = Heap.new(medium, int_compare_fn)
large_heap = Heap.new(large, int_compare_fn)

Benchee.run(
  %{
    "new small" => fn -> Heap.new(small, int_compare_fn) end,
    "new medium" => fn -> Heap.new(medium, int_compare_fn) end,
    "new large" => fn -> Heap.new(large, int_compare_fn) end,
    "insert small" => fn -> Heap.insert(small_heap, random_int) end,
    "insert medium" => fn -> Heap.insert(medium_heap, random_int) end,
    "insert large" => fn -> Heap.insert(large_heap, random_int) end,
    "min small" => fn -> Heap.min(small_heap) end,
    "min medium" => fn -> Heap.min(medium_heap) end,
    "min large" => fn -> Heap.min(large_heap) end,
    "delete_min small" => fn -> Heap.delete_min(small_heap) end,
    "delete_min medium" => fn -> Heap.delete_min(medium_heap) end,
    "delete_min large" => fn -> Heap.delete_min(large_heap) end
  },
  memory_time: 2,
  print: [fast_warning: false]
)
