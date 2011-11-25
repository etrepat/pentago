module Pentago
  class HumanPlayer < Player
    def initialize(opts={})
      super(opts)
      @ask_for_move_callback = opts.fetch(:callback, nil)
    end

    attr_accessor :ask_for_move_callback

    def compute_next_move
      raise 'how come should I ask a user for a move?' unless @ask_for_move_callback
      @ask_for_move_callback.call(self, @board)
    end
  end
end
