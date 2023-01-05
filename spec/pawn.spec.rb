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
end
