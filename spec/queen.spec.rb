# frozen_string_literal: true

require_relative '../lib/queen'

describe Queen do
  subject(:queen) { described_class.new(:w) }
  describe '#collect_paths' do
    it 'collects paths for all eight directions' do
      paths = queen.collect_paths(:d1, {})
      expected = {
        N: %i[d2 d3 d4 d5 d6 d7 d8],
        E: %i[e1 f1 g1 h1],
        W: %i[c1 b1 a1],
        S: [],
        NE: %i[e2 f3 g4 h5],
        NW: %i[c2 b3 a4],
        SE: [],
        SW: []
      }
      expect(paths).to eq(expected)
    end

    context 'when a piece is blocking on one of the paths' do
      let(:piece) { double('piece') }

      it 'collects paths for all eight directions' do
        sqrs = { d5: piece }
        path = queen.collect_paths(:d1, sqrs)
        expected = %i[d2 d3 d4 d5]
        expect(path[:N]).to eq(expected)
      end
    end
  end
end
