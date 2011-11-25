module Pentago
  class Player
    class << self
      def create(engine_name, options={})
        Pentago.const_get(engine_name).new(options)
      rescue Exception => e
        raise TypeError, "#{e.message}\n!! Invalid player engine (#{engine_name})!"
      end
    end

    def initialize(opts={})
      @board      = opts.fetch(:board)
      @marble     = opts.fetch(:marble)
      @name       = opts.fetch(:name, '')
      @last_move  = nil
    end

    attr_accessor :board
    attr_reader :marble, :name, :last_move

    def play_turn
      x, y, s, d = compute_next_move

      execute_move(x, y, s, d)

      @last_move = [x, y, s, d]
    end

    def compute_next_move
      # to be overriden by subclasses
      raise 'compute_next_move should be overriden by a subclass'
    end

    def execute_move(x, y, square, direction)
      @board[x, y] = @marble
      @board.rotate(square, direction)
    end

    def ==(other)
      @board == other.board && @marble == other.marble
    end

    alias_method :eql?, :==

    def to_s
      name.empty? ? marble.to_s : name
    end

    alias_method :to_str, :to_s
  end
end

