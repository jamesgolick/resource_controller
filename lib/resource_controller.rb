module ResourceController
  ACTIONS          = [:index, :new, :create, :edit, :update, :destroy].freeze
  FAILABLE_ACTIONS = ACTIONS - [:index, :new, :edit].freeze
end