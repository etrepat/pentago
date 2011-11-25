require 'spec_helper'

module Pentago
  describe Game do
    before(:each) do
      @board    = Pentago::Board.new
      @player1  = Pentago::DummyPlayer.new(:board => @board, :marble => 1)
      @player2  = Pentago::DummyPlayer.new(:board => @board, :marble => 2)
      @game     = Pentago::Game.new(:player1 => @player1, :player2 => @player2,
        :board => @board)
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

    describe 'instance methods' do
      before(:each) do
        @squares = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,
          nil,2,1,2,nil,nil,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
      end

      describe '#turns_played' do
        it 'should return number of turns played' do
          @game.turns_played.should == 0

          @game.board.squares = @squares
          @game.turns_played.should == 18
        end
      end

      describe '#winner' do
        it 'should return nil if no player is in winning position' do
          @game.board.squares = @squares
          @game.winner.should be_nil
        end

        it 'should return player in winning position' do
          @game.board.squares = @squares
          @game.board[3,5] = 1
          @game.board.rotate(2, :counter_clockwise)
          @game.winner.should == @player1
        end
      end
    end
  end
end

