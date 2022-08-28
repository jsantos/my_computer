# frozen_string_literal: true

require './lib/stack'

# Computer Simulator
class Computer
  attr_reader :stack, :program_counter # Read-only, only used in test cases

  def initialize(stack_size)
    @stack = Stack.new(stack_size)
    @program_counter = 0 # By default, the program counter is at address 0
  end

  # Usually in Ruby we don't prefix writer method names with `set_`,
  # keeping this to comply with the examples given on the assignment.
  def set_address(value)
    @program_counter = value
    self # Returning the object instance will allow for method chaining
  end

  def insert(*instruction)
    # TODO: Extract Stack Nodes to Objects (instead of using an Hash)
    case instruction.size
    when 2
      unless instruction[1].is_a? Integer
        raise InvalidArgumentError.new, 'Invalid Argument: Addresses should be Integers'
      end

      # Insert instructions at the current PC
      @stack.data[@program_counter] = {
        instruction: instruction[0],
        value: instruction[1]
      }
    when 1
      @stack.data[@program_counter] = { instruction: instruction[0] }
    else
      msg = "Wrong number of arguments (given #{instruction.size}, expected 1 or 2)"
      raise WrongNumberOfArgumentsError, msg
    end
    @program_counter += 1

    # Set the stack pointer to the top location of the stack
    @stack.update_pointer
    self
  end

  def execute
    # Iterate from the current PC position until the end of the stack
    while @program_counter < @stack.data.size
      break if @stack.data[@program_counter][:instruction] == 'STOP'

      parse_command(@stack.data[@program_counter])
      @program_counter += 1
    end
  end

  private

  def parse_command(command)
    case command[:instruction]
    when 'PUSH'
      @stack.push(command[:value])
    when 'PRINT'
      value = @stack.pop
      puts value
    when 'CALL'
      # Set the program counter (PC) to `addr`
      @program_counter = command[:value] - 1
      # FIXME: This '-1' dance is done since the program counter is always
      # updated after this function
    when 'MULT'
      # Pop the last 2 values from the stack and multiply them
      a = @stack.pop
      b = @stack.pop
      result = a * b
      @stack.push(result) # Push the operation result back to the stack
    when 'RET'
      # Pop address from the stack and set PC to it
      address = @stack.pop
      @program_counter = address - 1
      # FIXME: This '-1' dance is done since the program counter is always
      # updated after this function
    else
      raise InvalidCommandError, 'Invalid command'
    end
  end
end

WrongNumberOfArgumentsError = Class.new StandardError
InvalidArgumentError = Class.new StandardError
InvalidCommandError = Class.new StandardError
