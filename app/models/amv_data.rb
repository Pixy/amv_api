class AmvData < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  self.abstract_class = true

  attr_accessible :q

  CACHE_TTL = 24 * 3600 #seconds

  class << self
    def config
      if Rails.env.production?
        @@api_configuration ||= { 'url' => ENV['AMV_URL'], 'user' => ENV['AMV_USER'], 'password' =>  ENV['AMV_PASSWORD'] }
      else
        @@api_configuration ||= YAML.load(File.read(Rails.root.join("config", "amv_web_services.yml")))[Rails.env]
      end
    end
  end

  def soap_client
    url = AmvData.config["url"]
    Savon::Client.new(url)
  end

  memoize :soap_client

  def remote_session_id
    params = { "username" => AmvData.config["user"], "apiKey" =>AmvData.config["password"] }
    response = soap_client.request("login") do
      soap.body = params
    end

    response.to_hash[:login_response][:login_return].dup
  end

  memoize :remote_session_id

  def fetch_products_by_tag(tag)
      params = { "sessionId" => remote_session_id, "resourcePath" =>"wsapi_amv.getPushProduct", "args" => tag }

      response =  soap_client.request("call") do
        soap.body = params
      end

      response.to_hash[:call_response][:call_return].to_s
  end

  def fetch_products_by_skus(skus)
      response =  soap_client.request("call") do
        soap.body do |xml|
          xml.tag!("sessionId", {"xsi:type" => "xsd:string"}, remote_session_id)
          xml.tag!("resourcePath", "wsapi_amv.getProductPushSku")
          xml.tag!("args", {"SOAP-ENC:arrayType" => "xsd:string4", "xsi:type" => "SOAP-ENC:Array"})  do |xml|
            skus.each do |item|
              xml.tag!("item", item)
            end
          end
        end
      end

      response.to_hash[:call_response][:call_return].to_s
  end


  #todo rspec
  def get_products_from_remote(method_to_fetch, *args)

    return unless expired?                                 # early exit condition

    products_txt = ""

    begin
      products_txt = self.send(method_to_fetch, *args)            # get the products raw text
      self.data = products_txt                             # store it in data
      self.expires_at = CACHE_TTL.seconds.from_now         # reset expires_at
      self.save!                                           # try to save!
    rescue Exception => e
      Honeybadger.notify(
          :error_class   => e.class,
          :error_message => "#{e.class}: #{e.message}",
          :backtrace => e.backtrace,
          :parameters    => {:method_to_fetch => method_to_fetch, :args => args},
          :context => {:products_txt => products_txt, :self => self.to_yaml}
      )
    end

    products_txt
  end

  #todo rspec
  def parse_data
    products = Array.new

    unless data.blank?
      begin
        temp =  Nori.parse(data)
        products = temp[:products][:product]
      rescue Exception => e
        #todo expire unparsable data
        Honeybadger.notify(
            :error_class   => e.class.name,
            :error_message => "#{e.class.name}: #{e.message}",
            :backtrace => e.backtrace,
            :context => {:self => self.to_yaml}
        )
      end
    end

    products
  end

  def expire!
    self.update_attribute(:expires_at, nil)
  end

  def expired?
    expires_at.nil? || (expires_at < Time.now)
  end

end
