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

  describe '#movement' do
    let(:piece) { double('piece', { clr: :w }) }

    context 'when there is a piece'
  end
end
