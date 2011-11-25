module Pentago
  class Game
    DuplicatedPlayersError  = Class.new(StandardError)

    include Observable

    class << self
      def create(options)
        board   = options.fetch(:board, Board.new)
        player1 = Player.create(options.fetch(:player_engine_1), :board => board,
          :marble => 1)
        player2 = Player.create(options.fetch(:player_engine_2), :board => board,
          :marble => 2)

        Game.new(:board => board, :player1 => player1, :player2 => player2)
      end
    end

    def initialize(params)
      @board    = params.fetch(:board)
      @player1  = params.fetch(:player1)
      @player2  = params.fetch(:player2)
      raise DuplicatedPlayersError if @player1 == @player2
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
      @current_player.play_turn

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
        who_won = @board.find_winner
        @winner = players.select { |p| p.marble == who_won }.first
      end

      @winner
    end

    def board_full?
      @board.full?
    end

    def game_over?
      @board.game_over?
    end

    def tie_game?
      @board.tie_game?
    end

    private

    def turn
      @turn ||= players.cycle
    end
  end
end
