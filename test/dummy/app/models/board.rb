class Board < ApplicationRecord
    has_many :tasks

    broadcasts_refreshes
end
