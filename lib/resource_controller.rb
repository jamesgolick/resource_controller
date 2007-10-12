module ResourceController
  ACTIONS          = [:index, :new, :create, :edit, :update, :destroy]
  FAILABLE_ACTIONS = ACTIONS - [:index, :new, :edit]
end