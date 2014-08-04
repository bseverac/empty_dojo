module Dojo
  class Donut
    attr_reader :dimension

    def initialize(options)
      @dimension = options
      @obstacles = options[:obstacles] || []
    end

    def adjust(position)
      {
        x: position[:x] % @dimension[:x],
        y: position[:y] % @dimension[:y]
      }
    end

    def collide!(position)
      raise CollisionError.new(position, "I have to stop there") if @obstacles.include?(position)
      position
    end
  end

  class CollisionError < RuntimeError
    attr_reader :obstacle_position

    def initialize(obstacle_position, msg)
      super msg
      @obstacle_position = obstacle_position
    end
  end

  class Rover

    attr_reader :position, :direction, :donut

    COMMANDS={
      'f' => :forward,
      'b' => :backward,
      'r' => :right,
      'l' => :left
    }

    def initialize(options)
      @navigator = Navigator.new(self)
      @position = {x: options[:x], y: options[:y]}
      @direction = options[:direction]
      @donut = options[:donut]
    end

    def do!(*commands)
      commands.each do |command|
        @position,@direction  = @navigator.send(COMMANDS[command])
      end
    end

    class Navigator
      MOVES = {
        north: {axis: :vertical, operator: :+},
        east:  {axis: :horizontal, operator: :+},
        south: {axis: :vertical, operator: :-},
        west:  {axis: :horizontal, operator: :-}
      }
      DIRECTIONS = [:north, :east, :south, :west]
      def initialize(rover)
        @rover = rover
      end

      def right
        rotate(:+)
      end

      def left
        rotate(:-)
      end

      def forward
        move = MOVES[@rover.direction]
        send("#{move[:axis]}_move", move[:operator])
      end

      def backward
        move = MOVES[@rover.direction]
        send("#{move[:axis]}_move", reverse(move[:operator]))
      end

      def reverse(operator)
        case operator
        when :+
          :-
        when :-
          :+
        end
      end

      private
      def rotate(operator)
        next_index = (DIRECTIONS.index(@rover.direction).send(operator, 1)) % 4
        return @rover.position, DIRECTIONS[next_index]
      end

      def vertical_move(operator)
        move(:y, operator)
      end

      def horizontal_move(operator)
        move(:x, operator)
      end

      def move(property, operator)
        target_position = @rover.position.merge({
          property => @rover.position[property].send(operator, 1)
        })
        return @rover.donut.collide!(
          @rover.donut.adjust(target_position)
        ), @rover.direction
      end
    end
  end
end
