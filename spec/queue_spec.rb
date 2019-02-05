# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Redrate::Queue do
  subject(:queue) { described_class.new(rate, interval: interval) }
  let(:rate)      { 2 }
  let(:interval)  { 1 }
  let(:count)     { 5 }
  let(:expected)  { count.to_f / rate }
  let(:tolerance) { expected * 0.2 }

  it 'is rate limited' do
    expect(elapsed_time { count.times { queue.shift } }).to be_within(tolerance).of(expected)
  end

  it 'is rate limited across multiple threads' do
    threads = Array.new(count) do
      Thread.new { queue.shift }
    end
    expect(elapsed_time { threads.each(&:join) }).to be_within(tolerance).of(expected)
  end
end
