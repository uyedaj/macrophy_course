# Revbayes Analysis Script

Today we are going to be using the software [Revbayes](https://revbayes.github.io/), which is a project that replaces the commonly used [MrBayes](http://mrbayes.sourceforge.net/). Revbayes is a lot like R, but specifically designed for building customized Bayesian phylogenetic models. While it takes a bit more to learn how to use Revbayes than other Bayesian phylogenetic software it is 1) infinitely more customizable 2) better pedagogically since you get to see "under the hood" and 3) will likely be more extensively used in the future. 

You can check out the manuscript introducing revbayes [here](https://www.researchgate.net/profile/Sebastian_Hoehna/publication/303590369_RevBayes_Bayesian_Phylogenetic_Inference_Using_Graphical_Models_and_an_Interactive_Model-Specification_Language/links/574980fc08ae5bf2e63f11d1.pdf).

## Simple linear regression
Let's start with our standard, non-phylogenetic linear regression to get a feel for the Rev language. I have some data I made in R with a particular set of parameters values. Let's load in these data and see if we can estimate the model in Revbayes.

```
x_obs <- readDataDelimitedFile(file="./data/x.csv", header=TRUE, delimiter=",")[1]
y_obs <- readDataDelimitedFile(file="./data/y.csv", header=TRUE, delimiter=",")[1]
```

Revbayes is built on _graphical models_. Stochastic nodes represent any parameter _or_ node that will be attached/clamped to observed data. Our 3 parameters for our linear regression model are stochastic nodes. In the context of a Bayesian model, these are _priors_:
```
m ~ dnNormal(0, 1)
b ~ dnNormal(0, 1)
sigma ~ dnExponential(1)
```
Have a look at what it means to be a stochastic node in revbayes:

```
m
m.redraw()
m.probability()
m.lnProbability()
```

We may also have _deterministic nodes_. A deterministic node is not drawn from a probability distribution, but calculated from existing values. For each observed value in x_obs we will create a deterministic 
node for mu_y and a stochastic node for y:
```
for (i in 1:x_obs.size()) {
  mu_y[i] := (m * x_obs[i]) + b
  y[i] ~ dnNormal(mu_y[i], sigma)
}
```
Unlike the stochastic node, we cannot redraw mu_y, because it is deterministically determined by _m_, x_obs and _b_. Redrawing it would require redrawing both _m_ and _b_. However, we can redraw elements of the vector y[i].redraw(). 

We could run this model as is, but since no data is attached, we would only return the prior on the parameters as a posterior. However, we want to estimate the posterior probabilities conditional on our observed data. We therefore _clamp_ the _y_ values to the observed values. These are still stochastic nodes, but they are forced to match our observations. This is how Rev knows how to calculate the likelihood of our model. 
```
for(i in 1:y.size()) {
  y[i].clamp(y_obs[i])
}
```

We can now define our model by grabbing any node in our graph. Here I have chosen _m_ but it could be any of the above nodes.
```
mymodel = model(m)
```

Next we have to define our MCMC moves. A move is how our proposals for new parameters are made during our MCMC. If we do not propose a move for a parameter, it will not change and we will not estimate the posterior for the model. Thus, we need a good move for every parameter. A "good" move is one that explores the parameter space efficiently and obtains good _mixing_. We will see what that means in a second. 

For all three parameters we can define a _slide_ move, which proposes new values around the current value of the parameter with a window size determeined by the tuning parameter _delta_. The _weight_ option gives the relative frequency of proposing this move relative to other moves. 
```
moves[1] = mvSlide(m, delta=0.001, weight=1)
moves[2] = mvSlide(b, delta=0.001, weight=1)
moves[3] = mvSlide(sigma, delta=0.001, weight=1)
```

Next, we want to save some results. So we have to define some monitors that will output these results to the screen and to a log file. 
```
monitors[1] = mnScreen()
monitors[2] = mnModel("./output/linear_regression1.log")
```

We define our MCMC by combining our model, our moves, and our monitors and run for 10,000 generations.
```
mymcmc = mcmc(mymodel, moves, monitors)
mymcmc.run(10000)
```

Load up the results in Rstudio. Have they converged? How can you tell? 

We can try again by changing the delta values.
```
moves[1] = mvSlide(m, delta=1, weight=1)
moves[2] = mvSlide(b, delta=1, weight=1)
moves[3] = mvSlide(sigma, delta=1, weight=1)
```

```
monitors[1] = mnScreen()
monitors[2] = mnModel("./output/linear_regression2.log")
```

```
mymcmc = mcmc(mymodel, moves, monitors)
mymcmc.run(10000)
```

What happens if delta is too large? Feel free to try it if there is time. 

# Phylogenetic Models 
_Adapted from exercise by:_
_Sebastian Hoehna, Michael Landis, and Tracy A. Heath_

Read in sequence data for the gene
```
data = readDiscreteCharacterData("data/primates_and_galeopterus_cox2.nex")
```

Get some useful variables from the data. We need these later on.
```
num_taxa <- data.ntaxa();
num_branches <- 2 * num_taxa - 3;
taxa <- data.taxa();

mvi = 1;
mni = 1;
```
Specify the stationary frequency parameters
```
pi_prior <- v(1,1,1,1); 
pi ~ dnDirichlet(pi_prior);
moves[mvi++] = mvBetaSimplex(pi, weight=2.0);
moves[mvi++] = mvDirichletSimplex(pi, weight=1.0);
```

Specify the exchangeability rate parameters
```
er_prior <- v(1,1,1,1,1,1);
er ~ dnDirichlet(er_prior);
moves[mvi++] = mvBetaSimplex(er, weight=3.0);
moves[mvi++] = mvDirichletSimplex(er, weight=1.5);
```

Create a deterministic variable for the rate matrix, GTR

```
Q := fnGTR(er,pi) 
```

#### Tree model
Set the prior on tree topology:
```
out_group = clade("Galeopterus_variegatus");
topology ~ dnUniformTopology(taxa, outgroup=out_group);
moves[mvi++] = mvNNI(topology, weight=num_taxa/2.0);
#moves[mvi++] = mvSPR(topology, weight=num_taxa/10.0); #A nice SPR move, but omitting for speed!
```

#### Branch length prior
```
for (i in 1:num_branches) {
    bl[i] ~ dnExponential(10.0);
    moves[mvi++] = mvScale(bl[i])
};

TL := sum(bl);

psi := treeAssembly(topology, bl);
```


#### PhyloCTMC Model

The sequence evolution model
```
seq ~ dnPhyloCTMC(tree=psi, Q=Q, type="DNA");
seq.clamp(data)
```

#### Analysis 
```
mymodel = model(psi)
```
Add monitors
```
monitors[mni++] = mnScreen(TL, printgen=100);
monitors[mni++] = mnFile(psi, filename="output/primates_cox2_GTR.trees", printgen=10);
monitors[mni++] = mnModel(filename="output/primates_cox2_GTR.log", printgen=10)
```
Run the analysis
```
mymcmc = mcmc(mymodel, monitors, moves, nruns=2);
mymcmc.run(generations=5000,tuningInterval=200)
```

Summarize output
```
treetrace = readTreeTrace("output/primates_cox2_GTR.trees", treetype="non-clock", outgroup=out_group)
```
And then get the MAP tree
```
map_tree = mapTree(treetrace,"output/primates_cox2_GTR_MAP.tre")
```


# Total evidence dating of a tree using the fossilized birth-death process. 

We will discuss how phylogenetic trees are dated. While we do so, have the following script
running in the background. 

```
source("./mcmc_CEFBDP_Specimens.Rev")
```
