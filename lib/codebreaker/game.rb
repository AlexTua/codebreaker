module Codebreaker
  class Game
    ATTEMPTS_NUMBER = 7
    HINTS_NUMBER = 1

    attr_reader :attempts, :hints

    def initialize
      @secret_code = generate_secret_code
      @attempts =  ATTEMPTS_NUMBER
      @hints = HINTS_NUMBER
    end

    def check_guess(guess)
      return "You don't have any attempts." if game_over?
      @attempts -= 1
      return '++++' if guess == @secret_code

      mark(@secret_code.chars, guess.chars)
    end

    def get_hint
      return "You don't have any hints." if @hints == 0
      @hints -= 1
      @secret_code[rand(4)]
    end

    def game_over?
      @attempts == 0
    end

    def to_s
      "Secret code: #{@secret_code}, " +
      "attempts left: #{@attempts}, hints left: #{@hints}"
    end

    private

    def generate_secret_code
      (0...4).map { rand(1..6) }.join
    end

    def mark(code, guess)
      answer = ''

      guess.each_with_index do |number, index|
        if code.include?(number) && code[index] == number
          answer << '+'
          code[index], guess[index] = nil
        end
      end

      [code,guess].each(&:compact!)

      guess.each_with_index do |number, index|
        if code.include?(number)
          answer << '-'
          code[code.find_index(number)] = nil
        end
      end
      
      answer
    end
  end
end