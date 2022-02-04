#!/bin/bash

# SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5154/14550001 --aspect onos.topo.Location='{"lat":52.504315,"lng":13.453262}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5154/14550002 --aspect onos.topo.Location='{"lat":52.504315,"lng":13.453262}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5154/14550003 --aspect onos.topo.Location='{"lat":52.504315,"lng":13.453262}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5153/1454c001 --aspect onos.topo.Location='{"lat":52.486405,"lng":13.412234}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5153/1454c002 --aspect onos.topo.Location='{"lat":52.486405,"lng":13.412234}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5153/1454c003 --aspect onos.topo.Location='{"lat":52.486405,"lng":13.412234}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5154/14550001 --aspect onos.topo.Coverage='{"arc_width":120,"tilt":-15,"height":46,"azimuth":0}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5154/14550002 --aspect onos.topo.Coverage='{"arc_width":120,"tilt":10,"height":49,"azimuth":120}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5154/14550003 --aspect onos.topo.Coverage='{"arc_width":120,"tilt":-6,"height":29,"azimuth":240}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5153/1454c001 --aspect onos.topo.Coverage='{"arc_width":120,"tilt":1,"height":43,"azimuth":0}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5153/1454c002 --aspect onos.topo.Coverage='{"arc_width":120,"tilt":-10,"height":28,"azimuth":120}'
kubectl exec -it deployment/onos-cli -n riab -- onos topo set entity e2:1/5153/1454c003 --aspect onos.topo.Coverage='{"arc_width":120,"tilt":-10,"height":22,"azimuth":240}'