module Pentago
  module Players
    class Base
      def initialize(marble)
        @marble     = marble
        @last_move  = nil 
      end
      
      attr_reader :marble, :last_move
            
      def play_turn(board)
        # to be overriden by subclasses
        raise 'not directly usable'
      end
    end
  end
end