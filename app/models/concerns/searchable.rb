module Searchable
    extend ActiveSupport::Concern
  
    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks
  
      settings index: {
        number_of_shards: 1,
        max_ngram_diff: 8,
        analysis: {
          analyzer: {
            ngram_analyzer: { tokenizer: "ngram_tokenizer", filter: ["lowercase"] },
            whitespace_analyzer: { tokenizer: "whitespace", filter: ["lowercase"] }
          },
          tokenizer: {
            ngram_tokenizer: { type: "ngram", min_gram: 2, max_gram: 10, token_chars: ["letter", "digit"] }
          }
        }
      } do
        mappings dynamic: false do
          indexes :id,   type: :keyword
          indexes :name, type: :text, analyzer: :ngram_analyzer, search_analyzer: :whitespace_analyzer
        end
      end
    end
  
    def as_indexed_json(_options = {})
      { id: id, name: name }
    end
  
    module ClassMethods
      def search_by_name(query)
        __elasticsearch__.search(
          {
            query: {
              bool: {
                should: [
                  { match: { name: { query: query, fuzziness: "AUTO" } } },
                  { match_phrase_prefix: { name: { query: query } } }
                ]
              }
            }
          }
        )
      end
    end
end
  