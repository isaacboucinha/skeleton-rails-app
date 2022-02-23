# frozen_string_literal: true

# Base class for Application ActiveRecords
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
