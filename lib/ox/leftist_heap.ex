defmodule Ox.LeftistHeap do
  defstruct heap: nil, leq: nil

  def new(leq) when is_function(leq, 2) do
    %__MODULE__{leq: leq}
  end

  def new(list, leq) when is_list(list) do
    list
    |> Enum.reduce(new(leq), fn val, acc ->
      merge(new(val, leq), acc)
    end)
  end

  def new(el, leq) do
    new(leq) |> insert(el)
  end

  def rank(%__MODULE__{heap: nil}), do: 0
  def rank(%__MODULE__{heap: {r, _, _, _}}), do: r

  def empty?(%__MODULE__{heap: nil}), do: true
  def empty?(_), do: false

  def insert(%__MODULE__{leq: leq} = heap, element) do
    merge(heap, %__MODULE__{heap: {1, element, new(leq), new(leq)}, leq: leq})
  end

  def make(x, a, b) do
    if rank(a) >= rank(b) do
      %__MODULE__{heap: {rank(b) + 1, x, a, b}, leq: b.leq}
    else
      %__MODULE__{heap: {rank(a) + 1, x, b, a}, leq: a.leq}
    end
  end

  def merge(heap1, %__MODULE__{heap: nil}), do: heap1
  def merge(%__MODULE__{heap: nil}, heap2), do: heap2

  def merge(
        %__MODULE__{heap: {_, x, a1, b1}, leq: leq} = heap1,
        %__MODULE__{heap: {_, y, a2, b2}} = heap2
      ) do
    if leq.(x, y) do
      make(x, a1, merge(b1, heap2))
    else
      make(y, a2, merge(heap1, b2))
    end
  end

  def min(%__MODULE__{heap: nil}), do: nil

  def min(%__MODULE__{heap: {_, x, _, _}}) do
    x
  end

  def delete_min(%__MODULE__{heap: nil} = h), do: h

  def delete_min(%__MODULE__{heap: {_, _, a, b}}) do
    merge(a, b)
  end

  def count(%__MODULE__{heap: nil}), do: 0

  def count(%__MODULE__{heap: _heap} = heap) do
    do_count(heap, 0)
  end

  defp do_count(%__MODULE__{heap: nil}, count), do: count

  defp do_count(heap, count) do
    do_count(delete_min(heap), count + 1)
  end

  defimpl Enumerable do
    def reduce(_heap, {:halt, acc}, _fun), do: {:halted, acc}
    def reduce(heap, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(heap, &1, fun)}

    def reduce(heap, {:cont, acc}, fun) do
      if Ox.LeftistHeap.empty?(heap) do
        {:done, acc}
      else
        reduce(Ox.LeftistHeap.delete_min(heap), fun.(Ox.LeftistHeap.min(heap), acc), fun)
      end
    end

    def count(_heap), do: {:error, __MODULE__}
    def member?(_heap, _element), do: {:error, __MODULE__}
    def slice(_heap), do: {:error, __MODULE__}
  end
end
