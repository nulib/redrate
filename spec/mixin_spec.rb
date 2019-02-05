# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Redrate::Mixin do
  subject(:object) { test_class.new }
  let(:rate)       { 2 }
  let(:interval)   { 1 }
  let(:count)      { 10 }
  let(:expected)   { count.to_f / rate }
  let(:tolerance)  { expected * 0.2 }
  let(:test_class) do
    local_rate = rate
    local_interval = interval

    Class.new do
      extend Redrate::Mixin
      
      limit_method :tick, rate: local_rate, interval: local_interval

      attr_reader :ticks

      def initialize
        @ticks = 0
      end

      def tick(how_many = 1)
        @ticks += how_many
      end
    end
  end

  it 'is rate limited' do
    expect(elapsed_time { count.times { object.tick } }).to be_within(tolerance).of(expected)
  end

  it 'calls the original method' do
    count.times { object.tick }
    expect(object.ticks).to eq(count)
  end

  it 'passes arguments' do
    object.tick(count)
    expect(object.ticks).to eq(count)
  end
end