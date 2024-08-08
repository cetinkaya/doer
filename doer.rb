# Ahmet Cetinkaya, 2024

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
