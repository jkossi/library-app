require 'rails_helper'

RSpec.describe "Books", type: :request do
  let(:title) { 'Things fall apart' }
  let(:description) { 'By Chinua Achebe' }
  let(:isbn) { 'SN1000' }

  describe "GET /books" do
    context "with records" do
      let!(:books) { create_list(:book, 2, description: nil) }

      it "returns a paginated list of books" do
        get books_path, params: { format: :json }
        
        expect(response).to have_http_status(:ok)
        expect(response.body).to match_json_expression(
          data: [
            {
              id: books.first.id,
              title: books.first.title,
              description: nil,
              isbn: nil,
              created_at: be_a(String),
              updated_at: be_a(String)
            },
            {
              id: books.last.id,
              title: books.last.title,
              description: nil,
              isbn: nil,
              created_at: be_a(String),
              updated_at: be_a(String)
            }
          ],
          meta: {
            page: 1,
            total_pages: 1,
            total_books: 2
          }
        )
      end
      
      context "with pagination params" do
        context "and `per_page` is set to `0`" do
          it "set per_page to the default of 10" do
            get books_path, params: { per_page: 0, format: :json }
    
            expect(response).to have_http_status(:ok)
            
            response_body = JSON.parse(response.body)
            
            expect(response_body['data'].size).to eq(2)
            expect(response.body).to match_json_expression(
              data: be_a(Array),
              meta: {
                page: 1,
                total_pages: 1,
                total_books: 2
              }
            )
          end
        end
        
        context "and `per_page` is set to `1`" do
          it "returns only the number of records set in per_page on the first page" do
            get books_path, params: { per_page: 1, format: :json }
    
            expect(response).to have_http_status(:ok)
            expect(response.body).to match_json_expression(
              data: [
                {
                  id: books.first.id,
                  title: books.first.title,
                  description: nil,
                  isbn: nil,
                  created_at: be_a(String),
                  updated_at: be_a(String)
                }
              ],
              meta: {
                page: 1,
                total_pages: 2,
                total_books: 2
              }
            )
          end
  
          context "and `page` params is set" do
            it "returns only the records for the set page" do
              get books_path, params: { per_page: 1, page: 2, format: :json }
  
              expect(response).to have_http_status(:ok)
              expect(response.body).to match_json_expression(
                data: [
                  {
                    id: books.last.id,
                    title: books.last.title,
                    description: nil,
                    isbn: nil,
                    created_at: be_a(String),
                    updated_at: be_a(String)
                  }
                ],
                meta: {
                  page: 2,
                  total_pages: 2,
                  total_books: 2
                }
              )
            end
          end
        end
      end  
    end
    
    context "with no records" do
      it "returns no records" do
        get books_path, params: { per_page: 2, format: :json }
        expect(response.body).to match_json_expression(
          data: [],
          meta: {
            page: 1,
            total_pages: 0,
            total_books: 0
          }
        )
      end
    end
  end

  describe "POST /books" do
    context "with valid params" do
      it "creates a book record" do
        expect {
          post books_path, params: { 
            title: title, 
            description: description, 
            isbn: isbn, 
            format: :json 
          }  
        }.to change(Book, :count).from(0).to(1)
        
        expect(response).to have_http_status(:created)
        expect(response.body).to match_json_expression(
          id: Book.last.id,
          title: title,
          description: description,
          isbn: isbn,
          created_at: be_a(String),
          updated_at: be_a(String)
        )
      end  
    end
    
    context "with invalid params" do
      let(:title) { '' }

      it "does not create a book" do
        expect {
          post books_path, params: { title: title, format: :json }  
        }.not_to change(Book, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to match_json_expression(
          success: false,
          errors: ["Title can't be blank"]
        )
      end
    end
  end

  describe "GET /books/:id" do
    context "when book record exist" do
      let(:book) { create(:book) }
      
      it "returns the book" do
        get book_path(book.id), params: { format: :json }

        expect(response).to have_http_status(:ok)
        expect(response.body).to match_json_expression(
          id: book.id,
          title: book.title,
          description: book.description,
          isbn: book.isbn,
          created_at: be_a(String),
          updated_at: be_a(String)
        )
      end
    end

    context "when book record does not exist" do
      it "renders not found response" do
        get book_path(200), params: { format: :json }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to match_json_expression(
          success: false,
          error: I18n.t('api.errors.not_found') 
        )
      end
    end
  end

  describe "PUT /books/:id" do
    context "when book record does not exist" do
      it "renders not found response" do
        put book_path(200), params: { format: :json }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to match_json_expression(
          success: false,
          error: I18n.t('api.errors.not_found') 
        )
      end
    end

    context "when book record exist" do
      let(:book) { create(:book) }

      context "with valid params" do
        let(:title) { 'Updates title' }
        let(:description) { 'Updates description' }
        let(:isbn) { '19200' }

        it "updates the book record successfully" do
          put book_path(book.id), params: { title: title, description: description, isbn: isbn, format: :json }

          expect(response).to have_http_status(:ok)
          expect(response.body).to match_json_expression(success: true)
          expect(book.reload).to have_attributes(
            id: book.id,
            title: book.title,
            isbn: book.isbn
          )
        end
      end

      context "with invalid params" do
        let(:title) { '' }

        it "does not update the book record" do
          put book_path(book.id), params: { title: title, format: :json }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to match_json_expression(
            success: false,
            errors: ["Title can't be blank"]
          )  
        end
      end
    end
  end

  describe "DELETE /books/:id" do
    context "when book record exist" do
      let!(:book) { create(:book) }

      context "and deletion is successful" do
        it "returns no content status" do
          expect {
            delete book_path(book.id), params: { format: :json }
          }.to change(Book, :count).from(1).to(0)
  
          expect(response).to have_http_status(:no_content)
        end
      end

      context "and deletion fails" do
        before do
          allow(Book).to receive(:find).with(String(book.id)).and_return(book)
          allow(book).to receive(:destroy).and_return(false)
        end

        it "returns failed json response" do
          delete book_path(book.id), params: { format: :json }

          expect(response).to have_http_status(:internal_server_error)
          expect(response.body).to match_json_expression(
            success: false
          )
        end
      end
    end

    context "when book record does not exist" do
      it "renders not found response" do
        delete book_path(200), params: { format: :json }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to match_json_expression(
          success: false,
          error: I18n.t('api.errors.not_found') 
        )
      end
    end
  end
end
