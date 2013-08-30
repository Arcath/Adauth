module Adauth
  class SearchResults < Array
    def limit(x)
      return self[0..(x-1)]
    end
    
    def order(field, direction = :asc)
      case direction
      when :asc
        return sort! { |x, y| x.send(field) <=> y.send(field) }
      when :desc
        return order(field, :asc).reverse!
      else
        raise "Invalid Order Provided, please use :asc or :desc"
      end
    end
  end
end