module Pentago
  describe Rules do
    class RulesTest
      include Pentago::Rules
    end
    
    before(:each) do
      # full board, no winning conditions
      @full_squares = [1,2,2,2,2,1,2,1,1,1,1,2,1,2,2,2,2,1,2,1,1,1,1,2,1,2,2,
        2,2,1,2,1,1,1,1,2]
      @full_board   = Pentago::Board.restore(@full_squares)

      # from an actual game, actually this one:
      # http://en.wikipedia.org/wiki/File:Pentago-Game-Winning-Position.jpg
      @winning_squares  = [1,1,1,nil,2,nil,nil,2,1,2,2,1,nil,nil,2,1,2,nil,
        nil,1,2,nil,1,nil,2,nil,nil,2,nil,1,nil,nil,nil,nil,nil,nil]
      @winning_board    = Pentago::Board.restore(@winning_squares)

      # open board, no full, no winners
      @open_squares = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,
        nil,2,1,2,nil,nil,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
      @open_board   = Pentago::Board.restore(@open_squares)
      
      @rules = RulesTest.new
    end

    describe '#find_winner' do
      it 'should return nil if no winner' do
        @rules.find_winner(@full_board).should be_nil
        @rules.find_winner(@open_board).should be_nil
      end
      
      it 'should detect a winner when 5 consecutive marbles' do
        @rules.find_winner(@winning_board).should_not be_nil

        @full_board.squares[0] = 2
        @full_board.squares[3] = 1
        @full_board.squares[5] = 2
        @rules.find_winner(@full_board).should be_nil
        
        @full_board.squares[3] = 2
        @rules.find_winner(@full_board).should_not be_nil
      end
      
      it 'should return marble value of winner' do
        @rules.find_winner(@winning_board).should == 1
        
        @rules.find_winner(@open_board).should be_nil
        @open_board[3,5] = 1
        @open_board.rotate(2, :counter_clockwise)
        @rules.find_winner(@open_board).should == 1
        
        @rules.find_winner(@full_board).should be_nil
        @full_board.squares[0] = 2
        @rules.find_winner(@full_board).should == 2
      end
      
      it 'should return nil if more than one winner (tie game)' do
        @full_board.squares[0] = 2
        @full_board.squares[Pentago::Board::SIZE-1] = 1
        @rules.find_winner(@full_board).should be_nil
        
        two_winners = Board.restore([nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,
          nil,1,2,nil,nil,2,1,2,2,2,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1])
        two_winners[3,5] = 1
        two_winners.rotate(2, :counter_clockwise)
        # now there's two winners there (tie)
        @rules.find_winner(two_winners).should be_nil
      end
    end

    describe '#check_game_over' do
      it 'should return true if there is a winner' do
        @rules.check_game_over(@winning_board).should be_true
      end
      
      it 'should return true if tie game' do
        def @rules.check_tie_game(board)
          true
        end
        
        @rules.check_game_over(@open_board).should be_true
      end
      
      it 'should return false if game is open' do
        @rules.find_winner(@open_board).should be_nil
        def @rules.check_tie_game(board)
          false
        end
        
        @rules.check_tie_game(@open_board).should be_false
      end
    end
    
    describe '#check_tie_game' do
      it 'should return false when game is open (not full)' do
        @rules.find_winner(@open_board).should be_nil
        @open_board.full?.should be_false
        @rules.check_tie_game(@open_board).should be_false
      end
      
      it 'should return true when board is full & no winner, false othw' do
        @rules.find_winner(@full_board).should be_nil
        @full_board.full?.should be_true
        @rules.check_tie_game(@full_board).should be_true
      end
      
      it 'should return false when there is only one winner' do        
        @full_board.squares[0] = 2
        @rules.find_winner(@full_board).should == 2
        @rules.check_tie_game(@full_board).should be_false        
        
        @rules.find_winner(@winning_board).should == 1
        @rules.check_tie_game(@winning_board).should be_false
      end
      
      it 'should return true if two winners at the same time' do
        @full_board.squares[0] = 2
        @full_board.squares[Pentago::Board::SIZE-1] = 1
        @rules.check_tie_game(@full_board).should be_true
        
        two_winners = Board.restore([nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,
          nil,1,2,nil,nil,2,1,2,2,2,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1])
        two_winners[3,5] = 1
        two_winners.rotate(2, :counter_clockwise)
        # now there's two winners there (tie)
        @rules.check_tie_game(two_winners).should be_true        
      end
    end
  end
end