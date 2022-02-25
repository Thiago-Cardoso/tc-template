class Template
    attr_accessor :sentence

    def initialize(sentence = nil)
      @sentence = sentence
    end

    def clouses_data
      clouses = [
        { "id": 1, "text": 'The quick brown fox' },
        { "id": 2, "text": 'jumps over the lazy dog' },
        { "id": 3, "text": 'And dies' },
        { "id": 4, "text": 'The white horse is white' }
      ]
      clouses
    end

    def sections_data
      sections = [
        { "id": 1, "clauses_ids": [1, 2] }
      ]
      sections
    end

  end

