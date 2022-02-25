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

  def match_sentence
    if @sentence.match(/\s(\[CLAUSE-\d\])/)
      regex_sentence = /\s(\[CLAUSE-\d\])/
      index_tag = extract_tag_index(@sentence, regex_sentence)
      text = clause_text_sentence(@sentence, regex_sentence, index_tag)
      p print_clause_text(@sentence, text)
    elsif @sentence.match(/\s(\[SECTION-\d\])/)
      regex_sentence = /\s(\[SECTION-\d\])/
      index_tag = extract_tag_index(@sentence, regex_sentence)
      text = section_text_sentence(@sentence, regex_sentence, index_tag)
      p "#{text}"
    else
      false
    end
  end

  private

  def extract_tag_index(sentence, regex_sentence)
      str_tag = sentence.split(regex_sentence)
      tag = str_tag[1].match(/-\d/)
      tag = tag[0].gsub("-", "")
      tag
  end

  def section_text_sentence(sentence, regex_sentence, index_tag)
    text_value = sections_data.select  { |section| section[:id].to_s == index_tag.to_s ? section : nil}.reject(&:nil?)
    clauses_ids = text_value[0][:clauses_ids]
    text = clauses_ids.map do |clause_id |
      clause_text_sentence(sentence, regex_sentence, clause_id)
    end
    print_section_text(sentence, text)
  end

  def clause_text_sentence(sentence, regex_sentence, index_tag)
    text_value = clouses_data.select  { |clouse| clouse[:id].to_s == index_tag.to_s ? clouse : nil}.reject(&:nil?)
    text = " " + text_value[0][:text]
    text
  end

  def print_section_text(sentence, text)
    sentence.gsub(/\s(\[SECTION-\d\])/,text.join(';'))
  end

  def print_clause_text(sentence, text)
    sentence.gsub(/\s(\[CLAUSE-\d\])/,text)
  end

  Template.new('Is made of [CLAUSE-3].').match_sentence
  Template.new('Is made of [CLAUSE-4].').match_sentence
  Template.new('Is made of [SECTION-1].').match_sentence
end

