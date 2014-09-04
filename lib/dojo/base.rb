require 'set'
module Dojo
  class Base

    def line_size
      15
    end

    def word_list
      [
        ["il est "],
        ["une","deux","trois","quatre","cinq","six","sept","huit","neuf", "dix" ,"onze" ],
        ["midi","minuit"],
        [" heures"],
        [" moins"],
        ["et"],["le"],
        ["demi","dix","vingt","trente","quarante","cinquante"],
        ["et"],
        ["quart"],
        ["une","deux","cinq","quatre","sept","trois","six","neuf","onze","douze", "huit","treize", "quatorze", "seize" ],
        [" minutes"]
      ]
    end

    def tell_me_the_truth
      result = {nb_line:1, rest:line_size}
      final_string = ''
      word_list.each do |list|
        permu = permute_tab(word_tab_to_length_tab(list))
        result = smallest_permutation(permu,line_size-result[:rest],result[:nb_line])
        final_string += result[:str]
        puts result
      end
      puts final_string
      string_to_word_square(final_string)
    end

    def string_to_word_square(string)
      w_l = word_list
      current_line = 0
      square_string = ''
      string.chars.to_a.each do |ch|
        w_l.delete [] if w_l.first.empty?
        w_l.first.each do |word|
          if word.size == ch.to_i
            if current_line + ch.to_i <= line_size
              current_line += ch.to_i
              square_string += word
            else
              square_string += $/+word
              current_line = ch.to_i
            end
            w_l.first.delete word
            break
          end
        end
      end
      puts square_string
    end

    def permute_tab(tab)
      permutations(optimize(tab)).to_a
    end

    def compute_string_permutation(str,current_line = 0,nb_line = 0)
      str.chars.to_a.each do |ch|
        if current_line + ch.to_i <= line_size
          current_line += ch.to_i
        else
          current_line = ch.to_i
          nb_line +=1
        end
      end
      result = { nb_line: nb_line,str: str, rest: (line_size-current_line)}
    end

    def smallest_permutation(tab,init_char,init_line)
      best_result = nil
      tab.each do |string_permutation|
        result = compute_string_permutation( string_permutation,init_char, init_line )
        if best_result.nil? || result[:nb_line] < best_result[:nb_line] || (result[:nb_line] == best_result[:nb_line] && result[:rest] > best_result[:rest])
          best_result = result
        end
      end
      best_result
    end

    def word_tab_to_length_tab(tab)
      result = []
      tab.each do |val|
        result.push val.size.to_s
      end
      result
    end

    def optimize(x)
      references = {}
      x.each do |ch|
        references[ch] ||= 0
        references[ch] += 1
      end
      sorted = references.sort {|b,a| (a.last <=> b.last) }
      sorted.inject([]) { |accum,pair| accum + [pair.first] * pair.last }
    end

    def permutations(x)
      return x if x.empty?
      ch = x.delete_at(0)
      underlying = Set.new([ch])
      x.each do |ch|
        new_set = Set.new
        underlying.each do |permutation|
          (0..permutation.length).each do |idx|
            new_set.add(permutation.dup.insert(idx, ch))
          end
        end
        underlying = new_set
      end
      underlying.each
    end

  end
end
