# frozen_string_literal: true

require_relative '../lib/king'

describe King do
  subject(:king) { described_class.new(:w) }

  describe '#collect_paths' do
    it 'returns all adjacent sqrs' do
      cur_sq = :d5
      paths = {
        N: [:d6],
        E: [:e5],
        W: [:c5],
        S: [:d4],
        NE: [:e6],
        NW: [:c6],
        SE: [:e4],
        SW: [:c4]
      }
      actual = king.collect_paths(cur_sq)
      expect(actual).to eq(paths)
    end
  end
end
