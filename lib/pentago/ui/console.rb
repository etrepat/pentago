module Pentago
  module UI
    class Console
      def initialize(arguments, stdin, stdout)
        @arguments  = arguments
        @options    = {}
        @input      = stdin
        @output     = stdout
        @terminal   = HighLine.new(@input, @output)
      end

      def run
        if parsed_options? && options_valid?
          @game = Pentago::Game.new(
            :board    => @options[:board],
            :player1  => @options[:player1],
            :player2  => @options[:player2]
          )
          @game.add_observer(self)

          @game.play
        else
          output_usage
        end
      end

      def parsed_options?
        @options_parser ||= OptionParser.new do |opts|
          opts.banner = <<BANNER
Pentago Bot/Game AI Console Lab v#{Pentago.version}

Usage:
  pentago --player1=[Engine] --player2=[Engine] ([options])

Example/s:
  * Player vs Negamax engine:
  pentago --player1=Human --player2=Negamax

  * Watch computer play w/ itself:
  pentago --player1=Negamax --player2=Negamax

  * Player vs Player
  pentago --player1=Human --player2=Human

Options are:
BANNER
          opts.on('--player1=PLAYER', String,
            'Player 1 Engine (required)') do |engine|
              @options[:player1] = load_player(engine, 1)
          end

          opts.on('--player2=PLAYER', String,
            'Player 2 Engine (required)') do |engine|
              @options[:player2] = load_player(engine, 2)
          end

          # TODO: option for reading a board from a text file
          # TODO: option to set level of dificulty

          opts.separator ''

          opts.on('-h', '--help', 'Show this message') do
            terminal.say opts.to_s
            exit
          end

          opts.separator ''
        end

        begin
          @options_parser.parse!(@arguments)
        rescue TypeError, OptionParser::ParseError => e
          @options_parser.warn e.message
          nil
        end
      end

      def update(game)
        # get info
        player      = game.current_player
        x, y, s, d  = game.current_player.last_move
        total_turns = game.turns_played
        winner      = game.winner

        # output turn info & board
        terminal.say "\nTurn #{total_turns}: Player #{player} played: [#{x}, #{y}], rotated square: #{s} #{d}"
        if game.game_over?
          if game.tie_game?
            terminal.say "Game ends w/state: --- TIE GAME ---"
          else
            terminal.say "Game ends w/state: --- PLAYER #{winner} WINS! ---"
          end
        end

        terminal.say "#{game.board}\n"
      end

      def ask_for_move(player, board)
        terminal.say board if board.moves == 0
        terminal.say "\nPlayer #{player}. It's your Turn."

        x, y = terminal.ask("Marble position? (x,y) ", lambda { |s|
          s.split(',').map(&:to_i) }) do |q|
          q.whitespace  = :remove
          q.validate    = /[0-5],[0-5]/
        end

        s = terminal.ask('Square to rotate? (0-3) ', String) do |q|
          q.validate = /[0-3]/
        end.to_i

        d = terminal.ask('Direction? (cw or ccw)', lambda { |s|
          s == 'cw' ? :clockwise : :counter_clockwise }) do |q|
          q.validate = /cw|ccw/
          q.default  = 'cw'
        end

        [x, y, s, d]
      end

      private

      attr_reader :terminal

      def options_valid?
        @options.keys.include?(:player1) && @options.keys.include?(:player2)
      end

      def output_usage
        terminal.say @options_parser.to_s
      end

      def load_player(engine_name, player_marble)
        player = player_to_constant(engine_name).new(player_marble)
        raise TypeError if player.instance_of?(Pentago::Player)

        if player.kind_of?(Pentago::HumanPlayer)
          player.ask_for_move_callback = method(:ask_for_move)
        end

        player
      rescue Exception => e
        raise TypeError, "#{e.message}\n!! invalid player engine (#{engine_name})!"
      end

      def player_to_constant(name)
        camel = name.to_s.split('_').map { |s| s.capitalize }.join
        Pentago.const_get("#{camel}Player")
      end
    end
  end
end
