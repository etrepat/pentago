require 'spec_helper'

module Pentago
  describe Game do
    before(:each) do
      @player1  = Pentago::DummyPlayer.new(1)
      @player2  = Pentago::DummyPlayer.new(2)
      @board    = Pentago::Board.new

      @game     = Pentago::Game.new(@player1, @player2, @board)
    end

    describe '#initialize' do
      it 'should hold player representations' do
        @game.player1.should == @player1
        @game.player2.should == @player2
      end

      it 'should hold a board object' do
        @game.board.should == @board
      end
    end

    describe '#play' do
      it 'should alternatively make players play their turn' do

      end
    end
  end
end

