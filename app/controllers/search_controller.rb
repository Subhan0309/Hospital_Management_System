
class SearchController < ApplicationController
  def index
    @query = params[:query]
    Rails.logger.info "Current query is: #{@query}"

    if @query.present?
      # Perform the search with pagination
      @user_results = User.search(
        @query,
        fields: [{ name: :word_middle }, { email: :word_middle }, { role: :word_middle }],
        highlight: {
          tag: "<strong>",
          fields: {
            name: { fragment_size: 100 },
            email: { fragment_size: 100 },
            role: { fragment_size: 100 }
          }
        }
      )
    end
  end
end
