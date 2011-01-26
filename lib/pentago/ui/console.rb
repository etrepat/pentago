module Pentago
  module UI
    class Console
      def initialize(arguments, stdin, stdout)
        @arguments  = arguments
        @options    = {}
        @input      = stdin
        @output     = stdout
      end

      def run
        if parsed_options? && options_valid?
          @board  = Pentago::Board.new
          @game   = Pentago::Game.new(@options[:player1], @options[:player2], @board)
          @game.add_observer(self)

          @game.play
        else
          output_usage
        end
      end

      def update(player_at_turn, board)
        # get info
        marble      = player_at_turn.marble
        x, y, s, d  = player_at_turn.last_move

        # output turn info & board
        say "\nTurn #{board.moves}: Player #{marble} played: [#{x}, #{y}], rotated square: #{s} #{d}"
        if board.game_over?
          if board.tie?
            say "Game ends w/state: --- TIE GAME ---"
          else
            say "Game ends w/state: --- PLAYER #{board.find_winner} WINS! ---"
          end
        end

        say board
      end

      def ask_for_move(player, board)
        say board if board.moves == 0
        say "Player #{player.marble}. It's your Turn."

        x, y = nil, nil
        while x.nil? && y.nil?
          x, y = ask_coords("Enter marble position")
        end

        s, d = nil, nil
        direction_mapping = { 'cw' => :clockwise, 'ccw' => :counter_clockwise }
        while s.nil? && d.nil?
          s, d = ask_rotation("Enter square and direction to rotate")
        end

        [x, y, s, direction_mapping[d]]
      end

      def parsed_options?
        @options_parser ||= OptionParser.new do |opts|
          opts.banner = <<BANNER
Pentago Bot/Game AI Console Lab v#{Pentago.version}

Usage:
  pentago --player1=[Engine] --player2=[Engine] ([options])

Example:
  pentago --player1=Human --player2=Minimax

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
          # TODO: option to set level of dificulty (of course, AI should be done first)

          opts.separator ''

          opts.on('-h', '--help', 'Show this message') do
            puts opts
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

      protected

      def options_valid?
        @options.keys.include?(:player1) && @options.keys.include?(:player2)
      end

      def output_usage
        puts @options_parser
      end

      def load_player(engine_name, player_marble)
        player = player_to_constant(engine_name).new(player_marble)
        raise TypeError if player.instance_of?(Pentago::Player)

        if player.kind_of?(Pentago::HumanPlayer)
          player.ask_for_move_callback = lambda { |player, board| ask_for_move(player, board) }
        end

        player
      rescue Exception => e
        raise TypeError, "#{e.message}\n#{e.backtrace}\n!! invalid player engine (#{engine_name})"
      end

      def player_to_constant(name)
        camel = name.to_s.split('_').map { |s| s.capitalize }.join
        eval("Pentago::#{camel}Player")
      end

      def gets
        @input ? @input.gets : ''
      end

      def say(message)
        @output.puts(message) if @output
      end

      def ask(question)
        say("#{question} [yn]: ")
        gets.chomp.downcase == 'y'
      end

      def ask_coords(question)
        say("#{question} [ex: 3,4]: ")
        gets.chomp.split(',').map { |n| n.strip.to_i }
      end

      def ask_rotation(question)
        say("#{question} [ex: 1,cw || 0,ccw]: ")
        gets.chomp.split(',').map { |n| n.strip }.map{ |n| n.start_with?('c') ? n : n.to_i }
      end
    end
  end
end

