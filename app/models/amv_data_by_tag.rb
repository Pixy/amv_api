class AmvDataByTag < AmvData

  validates_uniqueness_of :q

  def get_products

      if expired?
          self.update_attribute(:data, "")
          delay.get_products_from_remote(:fetch_products_by_tag, q)       # done in a background job
      end
      parse_data
    end
end
