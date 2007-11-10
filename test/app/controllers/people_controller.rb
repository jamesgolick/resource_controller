class PeopleController < ResourceController::Base
  create.before :name_person
  
  private
    def model_name
      'account'
    end
    
    def name_person
      @person.name = "Bob Loblaw"
    end
end
