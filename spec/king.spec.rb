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

  describe '#find_rooks_sqs' do
    let(:l_rook) { double('rook', { clr: :w, id: :R, first_move: true }) }
    let(:r_rook) { double('rook', { clr: :w, id: :R, first_move: true }) }

    context 'when rooks\' conditions for castling rules are met' do
      it 'returns rooks' do
        sqrs = { a1: l_rook, h1: r_rook }
        rooks_sqs = king.find_rooks_sqs(sqrs)
        expect(rooks_sqs).to eq(%i[a1 h1])
      end
    end

    context 'when only one rook\'s conditions for castling rules are met' do
      it 'returns that one rook' do
        sqrs = { a1: l_rook }
        rooks_sqs = king.find_rooks_sqs(sqrs)
        expect(rooks_sqs).to eq(%i[a1])
      end
    end

    context 'when only one rook\'s conditions for castling rules are met' do
      it 'returns empty arr' do
        rooks_sqs = king.find_rooks_sqs({})
        expect(rooks_sqs).to be_empty
      end
    end
  end
end
