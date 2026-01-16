class Board < ApplicationRecord
  broadcasts_refreshes
  broadcasts_refreshes nil
  broadcasts_refreshes :columns; def columns = [self, :columns]
  broadcasts_refreshes ->(board) { [board, :cards] }
end
