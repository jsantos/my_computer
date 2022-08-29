# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/stack'

describe Stack do
  describe '#initialize' do
    let(:stack_size) { 5 }

    subject { Stack.new(stack_size) }

    it 'should initialize the stack with a given size' do
      stack = subject
      _(stack.size).must_equal stack_size
    end
  end

  describe '#push' do
    let(:stack) { Stack.new(2) }
    let(:val) { 10 }
    subject { stack.push(val) }

    it 'should add a value to the stack' do
      subject
      _(stack.data[stack.pointer]).must_equal val
    end
  end

  describe '#pop' do
    let(:stack) { Stack.new(2) }
    let(:val) { 10 }

    before { stack.push(val) } # Populate the Stack

    subject { stack.pop }

    it 'returns the value on the top of the stack' do
      _(subject).must_equal val
    end
  end

  describe '#to_s' do
    let(:stack) { Stack.new(1) }

    before { stack.push(10) }

    subject { stack.to_s }

    it 'prints the contents of the stack' do
      assert_output("0: 10\n") { subject }
    end
  end
end
