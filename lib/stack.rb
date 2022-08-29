# frozen_string_literal: true

# Computer Stack Implementation
class Stack
  attr_accessor :pointer, :data

  def initialize(size)
    @data = Array.new(size)
    @max_size = size
    @pointer = 0 # Since the stack is empty, its pointer is initally at address 0
  end

  def push(value)
    if @data.none? { |element| !element.nil? }
      # When the stack is empty (no non-nil elements), we put the value directly
      # on the head of the stack
      @data[0] = value
    else # Otherwise we put it on the next available address (pointer + 1)
      @data[@pointer + 1] = value
    end

    update_pointer
  end

  def pop
    value = @data[@pointer]

    # Remove the value from the stack, keeping the original stack size
    @data[@pointer] = nil
    update_pointer

    value
  end

  def size
    @data.size
  end

  def update_pointer
    # The Stack Pointer register will hold the address of the top location
    # of the stack, so we're getting the last non-nil element index
    @pointer = @data.rindex { |element| !element.nil? }
  end

  def to_s
    @data.each_with_index do |register, index|
      if register.is_a? Hash
        puts "#{index}: #{register.dig(:instruction)} #{register.dig(:value)}"
      else
        puts "#{index}: #{register}"
      end
    end
  end
end
