require 'strscan'
module NRB
  module Untappd
    class API
      class URLTokenizer
        attr_reader :map, :string

        def initialize(args)
          @map = args[:map]
          @string = args[:string]
          raise ArgumentError unless @map && @string
        end


        def tr
          return @string unless @string =~ /:[#{word_chars}]+:/
          result = ""
          s = StringScanner.new(@string)
          until s.eos? do
            word = s.scan(/:[#{word_chars}]+:|[#{url_chars}]+/)
            raise RuntimeError.new("String Scanner failed. File a bug.") if word.nil?
            result += tr_word(word)
          end
          result
        end

      private

        def tr_word(word)
          return word unless word =~ /:([#{word_chars}]+):/
          return map[$1.to_sym].to_s
        end


        def url_chars
          word_chars + Regexp.quote('/')
        end


        def word_chars
          "0-9a-zA-Z" + Regexp.quote("$-_.+!*'(),")
        end

      end
    end
  end
end
