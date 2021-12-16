class BooksController < ApplicationController
  before_action :load_book, only: [:show, :update, :destroy]

  def index
    query = BookQuery.new(page: params[:page], per_page: params[:per_page])
    books = query.result

    render json: { 
      data: books, 
      meta: {
        page: books.current_page,
        total_pages: books.total_pages,
        total_books: books.total_count
      }
    }, status: :ok
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created
    else
      render json: FAILURE_RESPONSE.merge(errors: @book.errors.full_messages), status: :unprocessable_entity
    end
  end

  def show
    render json: @book, status: :ok
  end

  def update
    if @book.update(book_params)
      render json: SUCCESS_RESPONSE, status: :ok
    else
      render json: FAILURE_RESPONSE.merge(errors: @book.errors.full_messages), status: :unprocessable_entity
    end
  end

  def destroy
    if @book.destroy
      head :no_content
    else
      render json: FAILURE_RESPONSE, status: :internal_server_error
    end
  end

  private

  def load_book
    @book ||= Book.find(params[:id])
  end

  def book_params
    params.permit(:title, :description, :isbn)
  end
end
