
require 'rails_helper'

RSpec.describe 'Book', type: :model do
 describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'belongs_to userとなる' do
        expect(Book.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let!(:book) { build(:book, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        book.title = ''
        expect(book.valid?).to eq false
      end
    end
    context 'bodyカラム' do
      it '空欄でないこと' do
        book.body = ''
        expect(book.valid?).to eq false
      end
      it '200文字以下であること' do
        book.body = Faker::Lorem.characters(number:201)
        expect(book.valid?).to eq false
      end
    end
  end
  
end
