require 'spec_helper'

module Pentago
  describe Player do
    describe '#initialize' do
      it 'should create a player with a marble' do
        base_1 = Player.new(1)
        base_1.marble.should == 1

        base_x = Player.new('x')
        base_x.marble.should == 'x'
      end
    end

    describe '#play_turn' do
      it 'should raise RuntimeError when this method is called' do
        base  = Player.new(1)
        board = Board.new
        expect {
          base.play_turn(board)
        }.to raise_error(RuntimeError)
      end
    end

    describe '#compute_next_move' do
      it 'should raise RuntimeError when this method is called' do
        base  = Player.new(1)
        board = Board.new
        expect {
          base.compute_next_move(board)
        }.to raise_error(RuntimeError)
      end
    end

    describe '#execute_move' do
      before(:each) do
        @base_player1 = Player.new(1)
        @base_player2 = Player.new(2)
        @board        = Board.new
        @other_board  = Board.new
      end

      it 'should place a marble of its own player' do
        @base_player1.execute_move(@board, 0, 0, 0, :clockwise)
        @base_player2.execute_move(@board, 1, 0, 1, :counter_clockwise)

        @board[2,0].should == @base_player1.marble
        @board[1,0].should == @base_player2.marble
      end

      it 'should do exactly the same as doing it directly' do
        @base_player1.execute_move(@board, 1, 1, 0, :clockwise)
        @base_player2.execute_move(@board, 2, 1, 1, :counter_clockwise)

        @other_board[1,1]   = @base_player1.marble
        @other_board.rotate(0, :clockwise)

        @other_board[2,1]   = @base_player2.marble
        @other_board.rotate(1, :counter_clockwise)

        @board.squares.should == @other_board.squares
      end
    end
  end

end

