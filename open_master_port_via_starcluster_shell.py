# USAGE: starcluster shell < open_master_port_via_starcluster.py <CLUSTER_NAME>
import argparse
import functools
import time as imported_time


# unfortunate kludge b/c of 'starcluster shell'
parser = argparse.ArgumentParser()
parser.add_argument('_shell', type=str)
parser.add_argument('cluster_name', type=str)
parser.add_argument('--service_name', default='jenkins', type=str)
parser.add_argument('--port', default=8080, type=int)
args = parser.parse_args()
if 'args' not in locals():
    exit()
cluster_name = args.cluster_name
service_name = args.service_name
port = args.port


# always the same
port_min, port_max = port, port
protocol='tcp'
world_cidr='0.0.0.0/0'


master = cm.get_cluster(cluster_name).master_node
group = master.cluster_groups[0]
get_port_open = functools.partial(master.ec2.has_permission, group, protocol,
        port, port, world_cidr)


if not get_port_open():
    log_str = "Authorizing tcp port on %s for: %s" % \
            (port, world_cidr, service_name)
    print log_str
    master.ec2.conn.authorize_security_group(
            group_id=group.id, ip_protocol=protocol,
            from_port=port, to_port=port,
            cidr_ip=world_cidr)

while not get_port_open():
    # don't return till port is open
    imported_time.sleep(2)
