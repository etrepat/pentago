require 'spec_helper'

module Pentago
  describe DummyPlayer do
    describe '#play_turn' do
      before(:each) do
        @board = Board.new
      end

      it 'holds last played move' do
        player = DummyPlayer.new(1)
        player.last_move.should be_nil
        player.play_turn(@board)
        player.last_move.should_not be_nil
      end

      it 'should play a move for its player' do
        player = DummyPlayer.new(1)
        player.play_turn(@board)
        @board.squares.compact.first.should == player.marble
      end
    end    
  end
end

