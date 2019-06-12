## Ratio

###### Version 0.0.1

#### Overview

Ratio is intended to run within an EKS cluster and expose metrics about capacity limits
for an EKS cluster in AWS.

#### Metrics

    cluster_pods_max integer gauge
    cluster_pods_current integer gauge
    cluster_pods_available integer gauge
    
    node_pods_max integer gauge
    node_pods_available integer gauge
    node_pods_current integer gauge
    
    cluster_sg_rules_available integer gauge
    cluster_sg_rules_max integer gauge
    cluster_sg_rules_current integer gauge
    
    vpc_ip_addresses_max integer gauge
    vpc_ip_addresses_current integer gauge
    vpc_ip_addresses_available integer gauge

#### Prerequisites

1. Ruby 2.5.1
2. MySQL (for local development)

#### Packaging



#### Deployment