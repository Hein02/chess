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

  describe '#pth_nt_under_atk' do
    context 'when both paths\' sqs are not under attack' do
      it 'returns both paths' do
        rook_sqs = %i[a1 h1]
        paths = king.pth_nt_under_atk(rook_sqs, {})
        expect(paths).to eq([%i[d1 c1], %i[f1 g1]])
      end
    end

    context 'when a path has sq under attack' do
      let(:black_queen) { double('queen', { id: :Q, clr: :b }) }

      it 'returns other path' do
        rook_sqs = %i[a1 h1]
        sqrs = { a7: black_queen }
        paths = king.pth_nt_under_atk(rook_sqs, sqrs)
        expect(paths).to eq([%i[d1 c1]])
      end
    end

    context 'when both paths has sq under attack' do
      let(:black_queen) { double('queen', { id: :Q, clr: :b }) }

      it 'returns empty arr' do
        rook_sqs = %i[a1 h1]
        sqrs = { c5: black_queen }
        paths = king.pth_nt_under_atk(rook_sqs, sqrs)
        expect(paths).to be_empty
      end
    end
  end

  describe '#king_sqs' do
    it 'returns the sqrs king can make for castling' do
      castling_paths = [%i[d1 c1], %i[f1 g1]]
      sqrs = king.king_sqs(castling_paths)
      expect(sqrs).to eq(%i[c1 g1])
    end
  end

  describe '#rooks_dest' do
    it 'returns the sqrs rooks need to move for castling' do
      castling_paths = [%i[d1 c1], %i[f1 g1]]
      sqrs = king.rooks_dest(castling_paths)
      expect(sqrs).to eq(%i[d1 f1])
    end
  end

  describe '#update_rooks' do
    let(:l_rook) { double('rook', { clr: :w, id: :R, first_move: true }) }
    let(:r_rook) { double('rook', { clr: :w, id: :R, first_move: true }) }

    it 'calls Rook#update_castling_sq' do
      sqrs = { a1: l_rook, h1: r_rook }
      castling_pths = [%i[d1 c1], %i[f1 g1]]
      expect(l_rook).to receive(:update_castling_sq).with(:d1)
      expect(r_rook).to receive(:update_castling_sq).with(:f1)
      king.update_rooks(%i[a1 h1], sqrs, castling_pths)
    end
  end
end
