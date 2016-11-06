require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    let(:game) { Game.new('Alex') }
    before { game.start_game }
    
    context '#initialize' do
      it 'should be with player name' do
        expect(game.instance_variable_get(:@player_name)).to eq('Alex')
      end
    end

    context '#start_game' do
      it 'generates secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
    end

    context "#generate_secret_code" do
      it 'return 4 numbers' do
        expect(game.send(:generate_secret_code)).to match(/^[1-6]{4}$/)
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

    context '#get_hint' do
      it 'reduce hints number by 1' do
        expect { game.get_hint }.to change{ game.hints }.by(-1)
      end

      it 'return one number of secret code' do
        expect(game.instance_variable_get(:@secret_code)).to include(game.get_hint)
      end

      it 'return warning message if no hints' do
        game.instance_variable_set(:@hints, 0)
        expect(game.get_hint).to eq("You don't have any hints")
      end
    end
  end
end