param D > 0 integer;
param E > 0 integer;
param V > 0 integer;

set Nodes   := 1..V;
set Links	:= 1..E;
set Demands := 1..D;

param link_orig {Links} within Nodes;
param link_term {Links} within Nodes;
param link_cost {Links} > 0;
param M > 0;

param demand_orig {Demands} within Nodes;
param demand_term {Demands} within Nodes;
param h {v1 in Nodes, v2 in Nodes} >= 0;
param H {v in Nodes} := sum {n in Nodes diff {v}} h[v,n];

param a {e in Links, v in Nodes} 
	:= if link_orig[e]=v then 1 else 0;
param b {e in Links, v in Nodes} 
	:= if link_term[e]=v then 1 else 0;
param c {e in Links, l in Links}
	:= if link_orig[e] = link_term[l] and link_orig[l] = link_term[e]
	then 1 else 0;

var x {Links,Nodes} >= 0;
var u {Links} >= 0 integer;

minimize Cost: sum{e in Links} (link_cost[e]*u[e]*M);	 

subj to flow_conservation1 {v in Nodes}: 
sum{e in Links} a[e,v]*x[e,v] = H[v];

subj to flow_conservation2 {v1 in Nodes, v2 in Nodes diff {v1}}:  
(sum{e in Links} b[e,v2]*x[e,v1]) - (sum{e in Links} a[e,v2]*x[e,v1]) = h[v1,v2];

subj to capacity1 {e in Links}:
sum {v in Nodes} x[e,v] <= u[e] * M;

subj to cons1 {e in Links}:
sum {l in Links diff {e}} c[e,l] * u[l] = u[e];