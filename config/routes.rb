Rails.application.routes.draw do
  get 'metrics/get_cluster_metrics'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  get '/', to: 'metrics#get_cluster_metrics'

  get '/live', to: 'metrics#get_cluster_metrics', defaults: { mode: "scheduled" }

  get '/count', to: 'metrics#get_cluster_metrics', defaults: { mode: "counters" }

  get '/metrics', to: 'metrics#get_cluster_metrics', defaults: { mode: "counters", format: "prometheus" }
end
