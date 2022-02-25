class Template
  attr_accessor :error, :sections, :clauses
  def initialize(sentence)
    @sentence = sentence
    @error = error
    @clauses = [
      { "id": 1, "text": 'The quick brown fox' },
      { "id": 2, "text": 'jumps over the lazy dog' },
      { "id": 3, "text": 'And dies' },
      { "id": 4, "text": 'The white horse is white' }
    ]
    @sections = [
      { "id": 1, "clauses_ids": [1, 2] }
    ]
  end

  def add_clause(id:, text:)
    @clauses.push({"id": id, "text": text})
  end

  def delete_clause(id:)
    @clauses.delete_if {|clause| clause[:id] == id}
  end

  def add_section(id:, clauses_ids:)
    @sections.push({"id": id, "clauses_ids": clauses_ids})
  end

  def delete_section(id:)
    @sections.delete_if {|section| section[:id] == id}
  end

  def process_sentence
    begin
      if @sentence.match(/\s(\[CLAUSE-\d{1,}\])/)
        regex_sentence = /\s(\[CLAUSE-\d{1,}\])/
        tag_id = extract_tag_id(regex_sentence)
        text = clause_sentence(regex_sentence, tag_id)
        return print_clause(text)
      elsif @sentence.match(/\s(\[SECTION-\d{1,}\])/)
        regex_sentence = /\s(\[SECTION-\d{1,}\])/
        tag_id = extract_tag_id(regex_sentence)
        text = section_sentence(regex_sentence, tag_id)
        return print_section(text)
      else
        false
      end
    rescue StandardError => e
      @error = e.message
    end
  end

  private

  def extract_tag_id(regex_sentence)
    tag = @sentence.split(regex_sentence)
    tag_id = tag[1].match(/-\d{1,}/)[0].gsub("-", "")
    tag_id
  end

  def section_sentence(regex_sentence, index_tag)
    section = @sections.select  { |section| section[:id].to_s == index_tag.to_s ? section : nil}.reject(&:nil?)
    raise "section index not found!" if section.empty?
    clauses_ids = section[0][:clauses_ids]
    text = clauses_ids.map do |clause_id |
      clause_sentence(regex_sentence, clause_id)
    end
  end

  def clause_sentence(regex_sentence, clause_id)
    clause = @clauses.select  { |clouse| clouse[:id].to_s == clause_id.to_s ? clouse : nil}.reject(&:nil?)
    raise "clause index not found!" if clause.empty?
    " " + clause[0][:text]
  end

  def print_clause(text)
    @sentence.gsub(/\s(\[CLAUSE-\d{1,}\])/,text)
  end

  def print_section(text)
    @sentence.gsub(/\s(\[SECTION-\d{1,}\])/,text.join(';'))
  end
end

p ":::: OUTPUT ::::"
template = Template.new("Is made of [CLAUSE-3].")
puts template.process_sentence

template = Template.new("Is made of [CLAUSE-4].")
puts template.process_sentence

template = Template.new("Is made of [SECTION-1].")
puts template.process_sentence