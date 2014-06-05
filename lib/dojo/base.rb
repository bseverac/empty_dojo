module Dojo
  class Game

    def initialize
      @frames = [Frame.new]
    end

    def score
      @frames.reduce(0){|sum, frame| sum + frame.score}
    end

    def record!(pins)
      frame.add!(pins)
    end

    def frame
      if @frames.last.finish?
        @frames.last.next = add_frame
      else
        @frames.last
      end
    end

    private
    def add_frame
      @frames << Frame.new
      @frames.last
    end
  end

  class Frame

    def initialize
      @pins = []
    end
    
    def next= frame
      @next = frame
    end

    def finish?
      @pins.length == 2
    end

    def spare?
      @pins[1]=='/'
    end
    
    def pins(index)
      @pins[index]
    end

    def spare_score
      if @next
        10 + @next.pins(0).to_i
      else
        0
      end
    end

    def score
      return spare_score if spare?
      finish? ? @pins.reduce(0){|sum, pin| sum + pin.to_i } : 0
    end

    def add!(pins)
      @pins << pins
    end
  end
end
