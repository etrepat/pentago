module Pentago
  describe Rules do
    before(:each) do
      # full board, no winning conditions
      @full_squares         = [1,2,2,2,2,1,2,1,1,1,1,2,1,2,2,2,2,1,2,1,1,1,1,2,1,
        2,2,2,2,1,2,1,1,1,1,2]
      @full_board           = Board.restore(@full_squares)

      # from an actual game, actually this one:
      # http://en.wikipedia.org/wiki/File:Pentago-Game-Winning-Position.jpg
      @winning_squares      = [1,1,1,nil,2,nil,nil,2,1,2,2,1,nil,nil,2,1,2,nil,
        nil,1,2,nil,1,nil,2,nil,nil,2,nil,1,nil,nil,nil,nil,nil,nil]
      @winning_board        = Board.restore(@winning_squares)

      # open board, no full, no winners
      @open_squares         = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,
        nil,nil,2,1,2,nil,nil,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
      @open_board           = Board.restore(@open_squares)

      # two winners board (tie-game)
      @two_winners_squares  = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,
        nil,nil,2,2,2,2,2,2,1,nil,nil,nil,nil,1,2,1,1,1,1,1]
      @two_winners_board    = Board.restore(@two_winners_squares)
    end

    describe '#find_winner' do
      it 'should return nil if no winner' do
        @full_board.find_winner.should be_nil
        @open_board.find_winner.should be_nil
      end

      it 'should detect a winner when 5 consecutive marbles' do
        @winning_board.find_winner.should_not be_nil

        @full_board.squares[0] = 2
        @full_board.squares[3] = 1
        @full_board.squares[5] = 2
        @full_board.find_winner.should be_nil

        @full_board.squares[3] = 2
        @full_board.find_winner.should_not be_nil
      end

      it 'should return marble value of winner' do
        @winning_board.find_winner.should == 1

        @open_board.find_winner.should be_nil
        @open_board[3,5] = 1
        @open_board.rotate(2, :counter_clockwise)
        @open_board.find_winner.should == 1

        @full_board.find_winner.should be_nil
        @full_board.squares[0] = 2
        @full_board.find_winner.should == 2
      end

      it 'should return array of winners if more than one (tie game)' do
        @full_board.squares[0] = 2
        @full_board.squares[Board::SIZE-1] = 1
        @full_board.find_winner.should have(2).items

        @two_winners_board.find_winner.should have(2).items
      end
    end

    describe '#game_over?' do
      it 'should return true if there is a winner' do
        @winning_board.game_over?.should be_true
      end

      it 'should return true if there is more than one winner (tie game)' do
        @two_winners_board.game_over?.should be_true
      end

      it 'should return false if game is open' do
        @open_board.game_over?.should be_false
      end
    end

    describe '#tie_game?' do
      it 'should return false when game is open (not full)' do
        @open_board.tie_game?.should be_false
      end

      it 'should return true when board is full' do
        @full_board.tie_game?.should be_true
      end

      it 'should return false when there is only one winner' do
        @full_board.squares[0] = 2
        @full_board.find_winner.should == 2
        @full_board.tie_game?.should be_false

        @winning_board.find_winner.should == 1
        @winning_board.tie_game?.should be_false
      end

      it 'should return true if two winners at the same time' do
        @full_board.squares[0] = 2
        @full_board.squares[Board::SIZE-1] = 1
        @full_board.tie_game?.should be_true

        @two_winners_board.tie_game?.should be_true
      end
    end
  end
end
