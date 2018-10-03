## Programs to install on your machine

The time has come to get a couple programs installed on your personal computers. Windows users, please install the software [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

In addition, everyone should install the software [Tracer](https://github.com/beast-dev/tracer/releases).


## Revbayes part II - Phylogenetic models and dating the tree of life. 

Last time we had some trouble getting your local forks to sync with the upstream master repository. To address this, enter this after navigating to the local directory
with your forked repository:

```
git pull https://github.com/uyedaj/macrophy_course.git
git push origin master
```

You should now have your /projects/Revbayes_lab/ folder available. If you created a second temporary repository, you can simply delete this one. Be careful that 
it is the repository you actually want to delete!
```
rm -r path/to/duplicated/repository/
```


# Phylogenetic Models 
_Adapted from exercise by:_
_Sebastian Hoehna, Michael Landis, and Tracy A. Heath_

Read in sequence data for the gene
```
data = readDiscreteCharacterData("data/primates_and_galeopterus_cytb.nex")
```

Get some useful variables from the data. We need these later on.
```
num_taxa <- data.ntaxa()
num_branches <- 2 * num_taxa - 3
taxa <- data.taxa()

mvi = 1
mni = 1
```
Specify the stationary frequency parameters
```
pi_prior <- v(1,1,1,1) 
pi ~ dnDirichlet(pi_prior)
moves[mvi++] = mvBetaSimplex(pi, weight=2.0)
moves[mvi++] = mvDirichletSimplex(pi, weight=1.0)
```

Specify the exchangeability rate parameters
```
er_prior <- v(1,1,1,1,1,1)
er ~ dnDirichlet(er_prior)
moves[mvi++] = mvBetaSimplex(er, weight=3.0)
moves[mvi++] = mvDirichletSimplex(er, weight=1.5)
```

Create a deterministic variable for the rate matrix under the GTR model.

```
Q := fnGTR(er,pi) 
```

Note that if you wanted to make a matrix for a Jukes-Cantor model, you could use `Q := fnJC(4)`. 
Notice that we do not need a prior on exhcangeabilities or stationary frequencies, only the 
number of states. 

#### Tree model
A prior on tree topology that puts equal weight on all possible topologies, after setting the outgroup.

```
out_group = clade("Galeopterus_variegatus")
# Prior distribution on the tree topology
topology ~ dnUniformTopology(taxa, outgroup=out_group)
moves[mvi++] = mvNNI(topology, weight=num_taxa/2.0)
# Here is a nice SPR move but we're going to omit it to speed up analysis!
#moves[mvi++] = mvSPR(topology, weight=num_taxa/10.0)
```


#### Branch length prior
```
for (i in 1:num_branches) {
    bl[i] ~ dnExponential(10.0)
    moves[mvi++] = mvScale(bl[i])
}

TL := sum(bl)

psi := treeAssembly(topology, bl)
```


#### PhyloCTMC Model

The sequence evolution model
```
seq ~ dnPhyloCTMC(tree=psi, Q=Q, type="DNA")
seq.clamp(data)
```

#### Analysis 
```
mymodel = model(psi)
```
Add monitors
```
monitors[mni++] = mnScreen(TL, printgen=1000)
monitors[mni++] = mnFile(psi, filename="output/primates_cytb_GTR.trees", printgen=10)
monitors[mni++] = mnModel(filename="output/primates_cytb_GTR.log", printgen=10)
```
Run the analysis
```
mymcmc = mcmc(mymodel, monitors, moves, nruns=2)
mymcmc.run(generations=10000)
```

Summarize output
```
treetrace = readTreeTrace("output/primates_cytb_GTR.trees", treetype="non-clock", outgroup=out_group)
```
And then get the MAP tree
```
map_tree = mapTree(treetrace,"output/primates_cytb_GTR_MAP.tre")
```

# Transferring files
We could push our results to your github fork, and then you could download it to your local computer. 
However, if we want a quick look at a file, we can also just grab the file using `scp` or `sftp`. To do so, 
open a terminal (Mac and Linux) or PuTTY (Windows). 

Navigate to the folder you want to put results, and type in:
```
scp <username>@128.173.187.20:path/to/file.ext path/to/destination/file.ext
```
This will copy it over to your directory. Now you can open log files in tracer and examine the results. 
Similarly, you can open the tree files you have created.

# Total evidence dating of a tree using the fossilized birth-death process. 

We will discuss how phylogenetic trees are dated. While we do so, have the following script
running in the background. 

```
source("./mcmc_CEFBDP_Specimens.Rev")
```

Use `scp` to transfer "./output/bears_MAP.tre" to your local directory. Then navigate to icytree.org and create
a figure that shows the estimated dates and error bars (with scale bars) for the tree. Save your "publication ready" tree with a filename
including your username. Add it to your github repository and make a pull request. 


