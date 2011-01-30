module Pentago
  class Game
    DuplicatedPlayersError  = Class.new(StandardError)
    
    include Observable
    include Pentago::Rules
    
    def initialize(params)
      @player1  = params.fetch(:player1)
      @player2  = params.fetch(:player2)
      raise DuplicatedPlayersError if @player1 == @player2
      
      @board    = params.fetch(:board, Board.new)
    end

    attr_reader :player1, :player2, :board, :current_player

    def play
      reset
      play_turn while !game_over?
    end
    
    def reset
      @board.clear
      @current_player = nil
      @winner         = nil
      turn.rewind
    end
    
    def play_turn
      @current_player = turn.next
      @current_player.play_turn(@board)

      changed
      notify_observers self
    end

    def turns_played
      @board && @board.moves
    end

    def players
      @players ||= [player1, player2]
    end
    
    def winner
      unless @winner
        who_won = find_winner(@board)
        @winner = players.select { |p| p.marble == who_won }.first
      end
      
      @winner
    end
    
    def board_full?
      @board.full?
    end
    
    def game_over?
      check_game_over(@board)
    end
    
    def tie_game?
      check_tie_game(@board)
    end
    
    private
    
    def turn
      @turn ||= players.cycle
    end
  end
end