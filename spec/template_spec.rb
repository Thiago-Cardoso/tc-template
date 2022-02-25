require 'spec_helper'
require './template'

describe Template do
  describe 'When call process' do
    context '#call' do
        before do
          @sentence = "Is made of [CLAUSE-3]."
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
      it 'With clause valid params' do
        @template = Template.new("Is made of [CLAUSE-3].").process_sentence
        expect(@template).to eq("Is made of #{@clauses[2][:text]}.")
      end

      it 'With clause invalid params' do
        template_invalid = Template.new("Is made of [CLAUSE-1000].")
        template_invalid.add_clause(id: 10, text: "ruby puro")
        template_invalid.process_sentence
        expect(template_invalid.error).to eq("clause index not found!")
      end

      it 'With section valid params' do
        template = Template.new("Is made of [SECTION-1].").process_sentence
        expect(template).to eq("Is made of The quick brown fox; jumps over the lazy dog.")
      end

      it 'With section invalid params' do
        template_invalid = Template.new("Is made of [SECTION-2].")
        template_invalid.add_section(id: 4, clauses_ids: [2,4])
        template_invalid.process_sentence
        expect(template_invalid.error).to eq("section index not found!")
      end

      it 'With add_section  params' do
        template = Template.new("Is made of [SECTION-2].")
        new_section = {id: 2, clauses_ids: [2, 4]}
        template.add_section(new_section)
        expect(template.sections).to include(new_section)
      end

      it 'With add_clause  params' do
        template = Template.new("Is made of [CLAUSE-5].")
        new_clause = {id: 5, text: "test"}
        template.add_clause(new_clause)
        expect(template.clauses).to include(new_clause)
      end
    end
  end
end