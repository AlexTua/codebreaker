require 'yaml'

module Codebreaker
  class Console
    def initialize
      @game = Game.new  
    end

    def play_game
      puts 'Welcome to Codebreaker!'
      puts "Type 'hint' to get hint, 'exit' to leave. " +
           'Make a guess of 4 numbers from 1 to 6.'
      
      begin 
        case guess = gets.chomp
          when 'hint'
            puts @game.get_hint
          when 'exit'
            return
          when /^[1-6]{4}$/
            answer = @game.check_guess(guess)
            puts answer
            game_over(:win) if answer == '++++'
          else
            puts 'You should type a guess of four numbers from 1 to 6.'
        end
      end while @game.any_attempts?

      game_over(:lose)
    end

    private

    def game_over(game_status)
      message = { :win => "Congratulations, you broke the code! #{@game.to_s}",
                  :lose => "Unfortunately there are no more attempts. #{@game.to_s}" }
      puts message[game_status]
      ask_for_save
      play_again
    end

    def play_again
      puts "Would you like to play again? (y/n)"
      exit unless gets.chomp == 'y' 
      @game = Game.new 
      play_game
    end

    def ask_for_save
      puts 'Would you like to save game result? (y/n)'
      return unless gets.chomp == 'y'
      save_data
    end

    def get_statisctics
      data = @game.to_h
      puts "Type your name"
      data[:name] = gets.chomp

      statistics = YAML.load_file('statistics.yaml') || []
      statistics << data
    end

    def save_data
      File.new('statistics.yaml', 'w') unless File.exist?('statistics.yaml')
      
      statistics = get_statisctics

      File.open('statistics.yaml', "w") do |f|
        f.write(statistics.to_yaml)
      end
    end
  end
end