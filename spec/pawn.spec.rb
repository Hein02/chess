# frozen_string_literal: true

require_relative '../lib/pawn'

describe Pawn do
  subject(:pawn) { described_class.new(:w) }

  describe '#add_one_sq' do
    context 'when it is white' do
      it 'adds extra one sq for north dir' do
        paths = {
          N: [:d2],
          NE: [:e3],
          NW: [:c3]
        }
        actual = pawn.add_one_sq(paths)
        expected = %i[d2 d3]
        expect(actual[:N]).to eq(expected)
      end
    end

    context 'when it is black' do
      it 'adds extra one sq for south dir' do
        paths = {
          S: [:d7],
          SE: [:e6],
          SW: [:c6]
        }
        actual = pawn.add_one_sq(paths)
        expected = %i[d7 d6]
        expect(actual[:S]).to eq(expected)
      end
    end
  end
end
