class MetricsController < ApplicationController

  def get_cluster_metrics
    if params[:format] == "prometheus"
      render plain: Eks::Nodes.node_stats(params), content_type: "text/plain"
    else
      render json: Eks::Nodes.node_stats(params)
    end
  end

end
