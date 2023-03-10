# frozen_string_literal: true

require_relative '../lib/pawn'

describe Pawn do
  subject(:pawn) { described_class.new(:w) }

  describe '#find_move_path' do
    let(:piece) { double('piece') }

    context 'when it is first move' do
      it 'returns two sqrs' do
        path = pawn.find_move_path(:d2, :N)
        expected = %i[d3 d4]
        expect(path).to eq(expected)
      end
    end

    context 'when it is not first move' do
      it 'returns one sqr' do
        pawn.instance_variable_set(:@first_move, false)
        path = pawn.find_move_path(:d2, :N)
        expected = %i[d3]
        expect(path).to eq(expected)
      end
    end
  end

  describe '#collect_paths' do
    context 'for white pawn' do
      it 'returns all the paths' do
        paths = {
          N: %i[d3 d4],
          NE: [:e3],
          NW: [:c3]
        }
        actual = pawn.collect_paths(:d2)
        expect(actual).to eq(paths)
      end
    end

    context 'for black pawn' do
      subject(:black_pawn) { described_class.new(:b) }

      it 'returns all the paths' do
        paths = {
          S: %i[d6 d5],
          SE: [:e6],
          SW: [:c6]
        }
        actual = black_pawn.collect_paths(:d7)
        expect(actual).to eq(paths)
      end
    end
  end

  describe '#find_sq_behind' do
    it 'returns the sqr behind the given sqr' do
      sqr = pawn.find_sq_behind(:d4)
      expect(sqr).to eq(:d5)
    end

    context 'for black pawn' do
      subject(:black_pawn) { described_class.new(:b) }

      it 'returns the sqr behind the given sqr' do
        sqr = black_pawn.find_sq_behind(:d4)
        expect(sqr).to eq(:d3)
      end
    end
  end

  describe '#movement' do
    context 'when there is an en_passant pawn to capture' do
      it 'adds en_passant list with the sq of that pawn to movement' do
        pawn.instance_variable_set(:@en_pas_sq, :d4)
        movement = pawn.movement(:c4, {})
        expect(movement[:en_pas]).to eq(:d5)
      end
    end
  end
end
