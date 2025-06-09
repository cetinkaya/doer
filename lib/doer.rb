# Copyright 2025 Ahmet Cetinkaya

# This file is part of Doer.

# Doer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Doer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Doer.  If not, see <http://www.gnu.org/licenses/>.

module Doer
  class Doer
    def initialize(period, dt)
      @period = period
      @dt = dt
      @lam = lambda{nil}
      @mut = Mutex.new
      @in_call = false
      dloop
    end

    def dloop
      Thread.new do
        last = Time.new
        loop do
          sleep(@dt)
          now = Time.new
          if now - last > @period
            last = now
            @mut.synchronize do
              unless @in_call
                Thread.new do
                  @in_call = true
                  old_lam = @lam
                  @lam.call
                  @in_call = false
                  if @lam == old_lam
                    @lam = lambda{nil}
                  end
                end
              end
            end
          end
        end
      end
    end

    def task(&lam)
      @mut.synchronize do
        @lam = lam
      end
    end
  end
end
