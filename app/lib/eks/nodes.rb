module Eks
  class Nodes
    def self.node_stats(options = { mode: :all, format: :json })

      res = map_nodes_by_instance_type

      inject_pods!(res)

      inject_limits!(res)

      if options[:mode] == "scheduled"
        filter_by_schedulable!(res)
      end

      if options[:mode] == "counters"
        strip_pods!(res)
      end

      if options[:format] == "prometheus"
        promethify(res)
      else
        res
      end
    end

    # generate a prometheus format metrics string for parsing and ingestion by prometheus
    def self.promethify(data)
      res = ''

      data.each do |node, vals|
        res << <<~NODEDATA
# HELP node max node_schedulable_pods for node #{node}
# TYPE node_schedulable_pods gauge
node_schedulable_pods{node="#{node}",category="max"} #{vals[:max_pods]}
# HELP node current node_schedulable_pods for node #{node}
# TYPE node_schedulable_pods gauge
node_schedulable_pods{node="#{node}",category="scheduled"} #{vals[:current_pods]}
# HELP node available node_schedulable_pods for node #{node}
# TYPE node_schedulable_pods gauge
node_schedulable_pods{node="#{node}",category="available"} #{vals[:max_pods] - vals[:current_pods]}
        NODEDATA
      end

      res
    end

    private

    def self.strip_pods!(res)
      res.each do |_, data|
        data.delete(:pods)
      end
    end

    def self.filter_by_schedulable!(res)
      res.each do |_, data|
        data[:pods].select! {|p| %w|Pending Running|.include?(p[:status])}
      end
    end

    def self.inject_limits!(res)
      res.each do |_, data|
        data[:current_pods] = data[:pods].select {|p| %w|Pending Running|.include?(p[:status])}.length
        data[:max_pods] = Rails.application.config.x.node_capacities[data[:instance_class]]
      end
    end

    def self.inject_pods!(res)
      Eks.client.get_pods.map do |pod|
        res[pod.spec.nodeName][:pods] << {name: pod.metadata.name, status: pod.status.phase}
      end
    end

    def self.map_nodes_by_instance_type
      Hash[Eks.client.get_nodes.map { |node| [node.metadata.name,
                                              {instance_class: node.metadata.labels["beta.kubernetes.io/instance-type"],
                                                                   pods: []} ] }]
    end
  end
end