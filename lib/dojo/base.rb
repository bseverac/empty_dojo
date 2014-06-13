module Dojo
  class Base
    DISCOUNTS = [0, 0, 0.05, 0.1, 0.2, 0.25]

    def self.price(books)
      price = 0.0
      while(books.uniq.size > 1)
        price += self.discounted(books)*books.uniq.size*8
        remove_uniq!(books)
      end
      price += books.size * 8
    end

    def self.remove_uniq!(books)
      books.uniq.each do |book|
        books.delete_at( books.find_index(book ))
      end
    end

    def self.discount(unique_books)
      DISCOUNTS[unique_books]
    end

    def self.discounted(books)
      1 - discount(books.uniq.size)
    end

  end
end
