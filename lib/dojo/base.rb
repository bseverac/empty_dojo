require 'matrix'

module Dojo
  class Base

    def self.price(books)
      price = 0.0
      cluster = optimize_cluster cluster_books(books)
      price = [8, 2*8 *0.95,3*8*0.9,4*8*0.8,5*8*0.75]
      (Matrix.row_vector(cluster)*Matrix.column_vector(price)).element(0,0)
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


  end
end