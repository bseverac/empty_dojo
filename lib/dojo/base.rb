module Dojo
  class Base
    DISCOUNTS = [0, 0, 0.05, 0.1, 0.2, 0.25]

    def self.price(books)
      price = 0.0
      cluster = optimize_cluster cluster_books(books)
      cluster.each_with_index do |count, index|
        nb_book = index+1
        price += (1-discount( nb_book))*count*nb_book*8
      end
      price
    end

    def self.cluster_books(books)
      cluster = [0] * 5
      while(books.uniq.size > 1)
        cluster[books.uniq.size-1] += 1
        remove_uniq!(books)
      end
      cluster[0] += books.size
      cluster
    end

    def self.optimize_cluster(cluster)
      offset = [cluster[2], cluster[4]].min
      cluster[2] -= offset
      cluster[4] -= offset
      cluster[3] += offset * 2
      cluster
    end

    def self.remove_uniq!(books)
      books.uniq.each do |book|
        books.delete_at( books.find_index(book ))
      end
    end

    def self.discount(unique_books)
      DISCOUNTS[unique_books]
    end

  end
end