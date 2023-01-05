# frozen_string_literal: true

require_relative '../lib/queen'

describe Queen do
  subject(:queen) { described_class.new(:w) }
  let(:paths) do
    {
      N: %i[d2 d3 d4 d5],
      E: %i[e1 f1 g1 h1],
      W: %i[c1 b1 a1],
      S: [],
      NE: %i[e2 f3 g4 h5],
      NW: %i[c2 b3 a4],
      SE: [],
      SW: []
    }
  end

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

      it 'returns the path without the sqrs that are blocked' do
        sqrs = { d5: piece }
        path = queen.collect_paths(:d1, sqrs)
        expected = %i[d2 d3 d4 d5]
        expect(path[:N]).to eq(expected)
      end
    end
  end

  describe '#find_moves' do
    let(:pc) { double('piece', { clr: :w }) }
    let(:enemy_pc) { double('piece', { clr: :b }) }

    it 'returns all the empty sqrs' do
      sqrs = { d5: pc, h1: enemy_pc }
      moves = queen.find_moves(paths, sqrs)
      expected = %i[d2 d3 d4 e1 f1 g1 c1 b1 a1 e2 f3 g4 h5 c2 b3 a4]
      expect(moves).to eq(expected)
    end
  end

  describe '#find_captures' do
    let(:enemy_pc) { double('piece', { clr: :b }) }

    it 'returns sqrs with enemy pieces on them' do
      sqrs = { d5: enemy_pc, h1: enemy_pc }
      captures = queen.find_captures(paths, sqrs)
      expected = %i[d5 h1]
      expect(captures).to eq(expected)
    end

    context 'when there is no enemy' do
      it 'returns empty arr' do
        sqrs = {}
        captures = queen.find_captures(paths, sqrs)
        expect(captures).to be_empty
      end
    end
  end
end
