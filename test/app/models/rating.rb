class Rating < ActiveRecord::Base
  belongs_to :comment
  delegate   :post, :to => :comment
end
