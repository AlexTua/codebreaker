require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    let(:game) { Game.new('Alex') }
    
    context '#initialize' do
      it 'generates secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end

      it 'should be with player name' do
        expect(game.instance_variable_get(:@player_name)).to eq('Alex')
      end
    end

    context '#check_guess' do
      [
        ['1234', '1234', '++++'], ['5143', '4153', '++--'], ['5523', '5155', '+-'],
        ['6235', '2365', '+---'], ['1234', '4321', '----'], ['1234', '1235', '+++'],
        ['1234', '6254', '++'], ['1234', '5635', '+'], ['1234', '4326', '---'],
        ['1234', '3525', '--'], ['1234', '2552', '-'], ['1234', '4255', '+-'],
        ['1234', '1524', '++-'], ['1234', '5431', '+--'], ['1234', '6666', ''],
        ['1115', '1231', '+-']
      ].each do |item|
          it "Secret code is #{item[0]}, guess is #{item[1]}, must return #{item[2]}" do
            game.instance_variable_set(:@secret_code, item[0])
            expect(game.check_guess(item[1])).to eq(item[2])
          end
        end
    end
  end
end