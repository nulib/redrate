# frozen_string_literal: true

require 'time'

module Redrate
  class Queue
    EPOCH = 0

    def initialize(size, interval: 60, key: 'queue')
      @ring = Ring.new(size, key, EPOCH)
      @interval = interval
    end

    def shift
      time = nil

      @ring.lock do
        sleep_until(@ring.current + @interval)
        @ring.rotate!
      end

      time
    end

    private

      def sleep_until(time)
        interval = time - @ring.now
        return unless interval.positive?
        sleep(interval)
      end
  end
end
