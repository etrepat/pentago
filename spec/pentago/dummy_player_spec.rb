require 'spec_helper'

module Pentago
  describe DummyPlayer do
    describe '#play_turn' do
      before(:each) do
        @player = DummyPlayer.new(:board => Board.new, :marble => 1)
      end

      it 'holds last played move' do
        @player.last_move.should be_nil

        @player.play_turn
        @player.last_move.should_not be_nil
      end

      it 'should play a move for its player' do
        @player.play_turn
        @player.board.squares.compact.first.should == @player.marble
      end
    end
  end
end

