require 'rails_helper'

describe '投稿のテスト' do
  let(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:book) { create(:book, user: user) }
  let!(:book_2) { create(:book, user: user_2) }
  # 予め、ログインする
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ログイン後に表示される左側のサイドバー' do
    context '表示の確認' do
      it 'New bookと表示される' do
        expect(page).to have_content 'New book'
      end
      it 'titleフォームが表示される' do
        expect(page).to have_field 'book[title]'
      end
      it 'bodyフォームが表示される' do
        expect(page).to have_field 'book[body]'
      end
      it 'Create Bookボタンが表示される' do
        expect(page).to have_button 'Create Book'
      end
    end

    context '投稿ができる' do
      it '投稿に成功する' do
        fill_in 'book[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'book[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Create Book'
        expect(page).to have_content 'Book was successfully created'
      end
      it '投稿に失敗する' do
        click_button 'Create Book'
        expect(page).to have_content 'error'
        expect(current_path).to eq('/books')
      end
    end
  end

  describe '編集' do
    context '自分の投稿の編集画面への遷移' do
      it '遷移する' do
        visit edit_book_path(book)
        expect(current_path).to eq("/books/#{book.id}/edit")
      end
    end

    context '他人の投稿の編集画面への遷移' do
      it '遷移できない' do
        visit edit_book_path(book_2)
        # リダイレクトして一覧に戻される
        expect(current_path).to eq('/books')
      end
    end

    context '表示' do
      before do
        visit edit_book_path(book)
      end
      it 'Editing Book' do
        expect(page).to have_content('Editing Book')
      end
      it 'title' do
        expect(page).to have_field 'book[title]', with: book.title
      end
      it 'body' do
        expect(page).to have_field 'book[body]', with: book.body
      end
      it 'Showリンク' do
        expect(page).to have_link 'Show', href: book_path(book)
      end
      it 'Backリンクが表示される' do
        expect(page).to have_link 'Back', href: books_path
      end
    end

    context 'フォームの確認' do
      it '編集に成功' do
        visit edit_book_path(book)
        click_button 'Update Book'
        expect(page).to have_content 'Book was successfully updated'
        expect(current_path).to eq("/books/#{book.id}")
      end
      it '編集に失敗' do
        visit edit_book_path(book)
        fill_in 'book[title]', with: ''
        click_button 'Update Book'
        expect(page).to have_content 'error'
        expect(current_path).to eq("/books/#{book.id}")
      end
    end
  end

  describe '一覧画面のテスト' do
    before do
      visit books_path
    end
    context '表示の確認' do
      it 'Booksと表示される' do
        expect(page).to have_content 'Books'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(book.user)
        expect(page).to have_link '', href: user_path(book_2.user)
      end
      it '自分と他人のタイトルのリンク先が正しい' do
        expect(page).to have_link book.title, href: book_path(book)
        expect(page).to have_link book_2.title, href: book_path(book_2)
      end
      it '自分と他人のオピニオンが表示される' do
        expect(page).to have_content book.body
        expect(page).to have_content book_2.body
      end
    end
  end

  describe '詳細画面のテスト' do
    context '自分・他人共通の投稿詳細画面の表示を確認' do
      it 'Book detailと表示される' do
        visit book_path(book)
        expect(page).to have_content 'Book detail'
      end
      it 'ユーザー画像・名前のリンク先が正しい' do
        visit book_path(book)
        expect(page).to have_link book.user.name, href: user_path(book.user)
      end
      it '投稿のtitleが表示される' do
        visit book_path(book)
        expect(page).to have_content book.title
      end
      it '投稿のopinionが表示される' do
        visit book_path(book)
        expect(page).to have_content book.body
      end
    end
    context '自分の投稿詳細画面の表示を確認' do
      it '投稿の編集リンクが表示される' do
        visit book_path book
        expect(page).to have_link 'Edit', href: edit_book_path(book)
      end
      it '投稿の削除リンクが表示される' do
        visit book_path book
        expect(page).to have_link 'Destroy', href: book_path(book)
      end
    end
    context '他人の投稿詳細画面の表示を確認' do
      it '投稿の編集リンクが表示されない' do
        visit book_path(book_2)
        expect(page).to have_no_link 'Edit', href: edit_book_path(book_2)
      end
      it '投稿の削除リンクが表示されない' do
        visit book_path(book_2)
        expect(page).to have_no_link 'Destroy', href: book_path(book_2)
      end
    end
  end
end
