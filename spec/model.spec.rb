# frozen_string_literal: true

require_relative '../lib/model'

describe Model do
  let(:brd) { double('board') }
  subject(:model) { described_class.new(brd) }

  describe '#select_pc' do
    it 'calls Board#find_pc' do
      sqr = :a1
      expect(brd).to receive(:find_pc).with(sqr)
      model.select_pc(sqr)
    end
  end

  describe '#find_movement' do
    let(:pc) { double('piece') }

    it 'calls Piece#movement' do
      sqr = :a1
      expect(pc).to receive(:movement).with(sqr)
      model.find_movement(pc, sqr)
    end
  end

  describe '#move_pc' do
    it 'calls Board#reassign_pc' do
      from = :a2
      to = :a4
      expect(brd).to receive(:reassign_pc).with(from, to)
      model.move_pc(from, to)
    end
  end

  describe '#record_king_sqr' do
    let(:cur_p) { double('player') }
    subject(:model_cur_p) { described_class.new(brd, cur_p) }

    it 'calls Player#update_king_sqr' do
      sqr = :a2
      expect(cur_p).to receive(:update_king_sqr).with(sqr)
      model_cur_p.record_king_sqr(sqr)
    end
  end
end
