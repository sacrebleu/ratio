module Eks

  def self.client
    Rails.application.config.x.kube_client
  end

end