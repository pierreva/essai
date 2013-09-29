$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'familysearch/gedcomx'
require 'active_support/core_ext'
require 'json'
require 'pp'

def add_person(id, gender)
  person = FamilySearch::Gedcomx::Person.new()
  person.id = id
  if gender == "male"
    person.gender = FamilySearch::Gedcomx::Gender.new(:type => "http://gedcomx.org/Male")
  else gender == "female"
    person.gender = FamilySearch::Gedcomx::Gender.new(:type => "http://gedcomx.org/Female")
  end
  person.names = []
  person.facts = []
  person.childAndParentsRelationships = []
  return person
end
def add_names(person, surname, given_name)
  
  name = FamilySearch::Gedcomx::Name.new(:nameForms => [])
  person.names[0] = name
  sur = FamilySearch::Gedcomx::NamePart.new(:type => "http://gedcomx.org/Surname", :value => "#{surname}")
  giv = FamilySearch::Gedcomx::NamePart.new(:type => "http://gedcomx.org/Given", :value => "#{given_name}")
  name_form = FamilySearch::Gedcomx::NameForm.new(:fullText => "#{surname} #{given_name}", :parts => [sur, giv])
  person.names[0].nameForms[0] = name_form
  return person
end
def add_birth(person, date, place)
  bir = FamilySearch::Gedcomx::Fact.new(:type => "http://gedcomx.org/Birth", :date => "#{date}", :place => "#{place}")
  person.facts[0] = bir
  return person
end
def add_child_parentsrelationship(person, father_id, mother_id)
  rel_father = FamilySearch::Gedcomx::ChildAndParentsRelationship.new(:father => {:resource=>"https://familysearch.org/platform/tree/persons/#{father_id}", :resourceId=>"#{father_id}"})
  person.childAndParentsRelationships[0] = rel_father
  rel_mother = FamilySearch::Gedcomx::ChildAndParentsRelationship.new(:mother => {:resource=>"https://familysearch.org/platform/tree/persons/#{mother_id}", :resourceId=>"#{mother_id}"})
  person.childAndParentsRelationships[1] = rel_mother
  return person
end

person = add_person("L7PD-KY3", "male")
person = add_names(person, "Parker P", "Felch")
person = add_child_parentsrelationship(person, "L78M-RLN", "L78M-TD6")
pp person
# {"id"=>"L7PD-KY3",
# "gender"=>{"type"=>"http://gedcomx.org/Male"},
# "names"=>
#  [{"nameForms"=>
#     [{"fullText"=>"Parker P Felch",
#       "parts"=>
#        [{"type"=>"http://gedcomx.org/Surname", "value"=>"Parker P"},
#         {"type"=>"http://gedcomx.org/Given", "value"=>"Felch"}]}]}],
# "facts"=>[],
# "childAndParentsRelationships"=>
#  [{"father"=>
#     {"resource"=>"https://familysearch.org/platform/tree/persons/L78M-RLN",
#      "resourceId"=>"L78M-RLN"}},
#   {"mother"=>
#     {"resource"=>"https://familysearch.org/platform/tree/persons/L78M-TD6",
#      "resourceId"=>"L78M-TD6"}}]}