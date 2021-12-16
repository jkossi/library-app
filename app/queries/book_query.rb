class BookQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  def initialize(page: nil, per_page: nil)
    @page = page || DEFAULT_PAGE
    @per_page = per_page || DEFAULT_PER_PAGE
  end

  def result
    Book
      .order(:id)
      .page(page)
      .per(per_page.to_i.zero? ? DEFAULT_PER_PAGE : per_page)
  end

  private

  attr_reader :page, :per_page
end
