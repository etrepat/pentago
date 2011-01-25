module Pentago
  module Players
    class Human < Base
      attr_accessor :ask_for_move_callback

      def compute_next_move(board)
        raise 'how come should I ask a user for a move?' unless ask_for_move_callback
        @ask_for_move_callback.call(self, board)
      end
    end
  end
end

