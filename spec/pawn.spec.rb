# frozen_string_literal: true

require_relative '../lib/pawn'

describe Pawn do
  subject(:pawn) { described_class.new(:w) }

  describe '#add_one_sq' do
    it 'adds extra one sq on vertical direction' do
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

  describe '#find_move_path' do
    let(:piece) { double('piece') }

    context 'when there is a piece' do
      it 'returns empty arr' do
        paths = { N: [:d2] }
        sqrs = { d2: piece }
        actual = pawn.find_move_path(paths, sqrs)
        expect(actual).to be_empty
      end
    end
  end
end
