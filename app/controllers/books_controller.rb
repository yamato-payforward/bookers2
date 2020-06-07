class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destory]

  def index
    @books = Book.all
    @book = Book.new
  end

  def show
    @new_book = Book.new
  end

  def edit
    redirect_to books_path unless  @book.user_id == current_user.id
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to book_path(@book) , notice: 'Book was successfully created'
    else 
      @books = Book.all
      flash[:alert] = @book.errors.full_messages
      render "index"
    end
  end

  def update
    if @book.update(book_params)
      redirect_to book_path , notice: 'Book was successfully updated'
    else 
      flash[:alert] = @book.errors.full_messages
      render "edit"
    end
  end

  def destroy
    book = Book.find(params[:id]) 
    book.destroy
    redirect_to books_path, notice: 'Book was successfully deleted.'
  end  

  
  private

  def set_book
    @book = Book.find params[:id]
  end
   
  def book_params
    params.require(:book).permit(:title, :body)
  end

end
