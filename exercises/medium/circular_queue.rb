class CircularQueue
  attr_accessor :oldest_index_value, :youngest_index_value
  attr_reader :SIZE

  def initialize(size)
    @SIZE = size
    @circ_queue = Array.new(size)
    @youngest_index_value = 0
    @oldest_index_value = 0
  end

  def enqueue(object)
    if @circ_queue[@youngest_index_value] != nil
      advance_oldest_index
    end
    @circ_queue[@youngest_index_value] = object
      if @youngest_index_value < (@SIZE - 1)
        @youngest_index_value += 1
      else
        @youngest_index_value = 0
      end
  end

  def dequeue
    removed_object = @circ_queue[@oldest_index_value]
    @circ_queue[@oldest_index_value] = nil
    if removed_object != nil
      advance_oldest_index
    end
    removed_object
  end

  protected

  def advance_oldest_index
    if @oldest_index_value < (@SIZE - 1)
      @oldest_index_value += 1
    else
      @oldest_index_value = 0
    end
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

puts "Creating a new circular queue"
queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
