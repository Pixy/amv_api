class AmvDataBySku < AmvData

  validates_uniqueness_of :q

  def skus
      self.q.split(',').map{ |sku| sku.squish }
  end

  def get_products

    if expired?
      self.update_attribute(:data, "")
      delay.get_products_from_remote(:fetch_products_by_skus, skus)       # done in a background job
    end
    parse_data
  end
end