# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/computer'

describe Computer do
  let(:stack_size) { 5 }

  describe '#initialize' do
    subject { Computer.new(stack_size) }

    it "should initialize the computer's stack with a given size" do
      computer = subject
      _(computer.stack.size).must_equal stack_size
    end

    it 'should initialize the Program Counter at 0' do
      computer = subject
      _(computer.program_counter).must_equal 0
    end
  end

  describe '#set_address' do
    let(:computer) { Computer.new(stack_size) }
    let(:target_address) { 2 }

    subject { computer.set_address(target_address) }

    it 'should update the Program Counter to the target address' do
      subject
      _(computer.program_counter).must_equal target_address
    end
  end

  describe '#insert' do
    let(:computer) { Computer.new(stack_size) }

    describe 'with valid arguments' do
      describe 'and a single instruction' do
        let(:instruction) { 'PRINT' }
        subject { computer.insert(instruction) }

        it 'inserts the instruction on the stack' do
          subject
          _(computer.stack.data[0][:instruction]).must_equal instruction
        end
      end

      describe 'and a instruction with a value' do
        let(:instruction) { 'PUSH' }
        let(:val) { 100 }
        subject { computer.insert(instruction, val) }

        it 'inserts the instruction on the stack' do
          subject
          _(computer.stack.data[0][:instruction]).must_equal instruction
          _(computer.stack.data[0][:value]).must_equal val
        end
      end
    end

    describe 'with invalid arguments' do
      describe 'wrong number of arguments' do
        subject { computer.insert('PUSH', 100, 200) }
        it 'should raise a WrongNumberOfArgumentsError exception' do
          _(proc { subject }).must_raise WrongNumberOfArgumentsError
        end
      end

      describe 'invalid address format' do
        subject { computer.insert('PUSH', 'BUTTON') }

        it 'should raise a InvalidArgumentError exception' do
          _(proc { subject }).must_raise InvalidArgumentError
        end
      end
    end
  end

  describe '#execute' do
    # TODO: Isolate huge test case into smaller subsets
    describe 'the sample program' do
      subject do
        print_tenten_begin = 50
        main_begin = 0

        computer = Computer.new(100)

        # Instructions for the print_tenten function
        computer.set_address(print_tenten_begin)
                .insert('MULT')
                .insert('PRINT')
                .insert('RET')

        # The start of the main function
        computer.set_address(main_begin)
                .insert('PUSH', 1009)
                .insert('PRINT')

        # Return address for when print_tenten function finishes
        computer.insert('PUSH', 6)

        # Setup arguments and call print_tenten
        computer.insert('PUSH', 101)
                .insert('PUSH', 10)
                .insert('CALL', print_tenten_begin)

        # Stop the program
        computer.insert('STOP')

        computer.set_address(main_begin).execute
      end

      it 'should produce the expected result' do
        assert_output("1009\n1010\n") { subject }
      end
    end
  end
end
