class PeopleController < ResourceController::Base
  create.before :name_person
  model_name    :account
  responds_to   :xml
  
  private
    def name_person
      @person.name = "Bob Loblaw"
    end
end
