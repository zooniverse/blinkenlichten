class TimedPin
  attr_reader :board, :pin, :state, :default, :on_until

  def initialize(board, pin, default = false)
    @board = board
    @pin = pin
    @on_until = nil
    @default = default
    @state = default

    @thread = Thread.new do
      loop do
        if should_be_on?
          on!
        else
          off!
        end

        sleep 0.05
      end
    end
  end

  def publish(status)
    # nothing
  end

  def trigger(duration = 1)
    puts "Trigger pin #{pin}"
    @on_until = Time.now + duration
  end

  def cancel
    @on_until = Time.now
  end

  private

  def should_be_on?
    on_until && Time.now < on_until
  end

  def on!
    set!(!default)
  end

  def off!
    set!(default)
  end

  def set!(value)
    if state != value
      puts "Switching pin #{pin} from #{state} to #{value}"
      @state = value
      board.digital_write(pin, value)
    end
  end
end
