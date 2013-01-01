Savon.configure do |config|

  config.env_namespace = :soapenv

  config.hooks.define(:measure, :soap_request) do |callback, request|
    start_time = Time.now
    response = callback.call

    end_time = Time.now
    Rails.logger.debug("--- soap request done in #{ end_time - start_time} seconds ---")

    response
  end
end
