## Creating datasets for phylogenetic analysis in macrophy lab
## These are the answers for the lab exercise. 

tree <- read.nexus("bears.tre")
plot(tree)
tree_sl <- tree
tree_sl$edge.length <- tree$edge.length/100
tree_sl$edge.length <- tree_sl$edge.length + 0.01
write.tree(tree_sl, file="bears.nwk")
system("seq-gen -mHKY -t0.5 -f0.25,0.25,0.25,0.25 -l300 -n1 -on <bears.nwk> bears_JC69.nex")
#system("seq-gen -mHKY -t1 -f0.25,0.25,0.25,0.25 -l300 -n1 -on <bears.nwk> bears_JC69.nex")


tree_fz <- tree
tree_fz$edge.length <- tree_sl$edge.length
tree_fz$edge.length[c(5,11)] <- tree_fz$edge.length[c(5,11)]+1
plot(tree_fz)
write.tree(tree_fz, file="bears_fz.nwk")
write.nexus(tree_fz, file="bears_LBAtree.nex")
system("seq-gen -mHKY -t0.5 -f0.25,0.25,0.25,0.25 -l5000 -n1 -on <bears_fz.nwk> bears_LBA5000.nex")
system("seq-gen -mHKY -t0.5 -f0.25,0.25,0.25,0.25 -l1000 -n1 -on <bears_fz.nwk> bears_LBA1000.nex")
system("seq-gen -mHKY -t0.5 -f0.25,0.25,0.25,0.25 -l500 -n1 -on <bears_fz.nwk> bears_LBA500.nex")
system("seq-gen -mHKY -t0.5 -f0.25,0.25,0.25,0.25 -l100 -n1 -on <bears_fz.nwk> bears_LBA100.nex")

tree_fz$tip.label <- LETTERS[1:length(tree_fz$tip.label)]
write.tree(tree_fz, file="bears_fz2.nwk")
system("seq-gen -mHKY -t3.5 -f0.18,0.33,0.32,0.17 -l1281 -z12345 -p4 -n1 -op <bears_unk2.nwk> bears_unk.phy")
system("seq-gen -mHKY -t3.5 -f0.18,0.33,0.32,0.17 -l1281 -z12345 -p4 -n1 -on <bears_unk1.nwk> bears_unk.nex")


