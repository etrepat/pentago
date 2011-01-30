module Pentago
  class HumanPlayer < Pentago::Player
    def initialize(marble, name='', callback=nil)
      super(marble, name)
      @ask_for_move_callback = callback
    end

    attr_accessor :ask_for_move_callback

    def compute_next_move(board)
      raise 'how come should I ask a user for a move?' unless ask_for_move_callback
      @ask_for_move_callback.call(self, board)
    end
  end
end