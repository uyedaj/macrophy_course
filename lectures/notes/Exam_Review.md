# Review for Exam I
#### Format of Exam: 
~ 7-10ish essay (1 paragraph or less) questions or equivalent short answer questions

#### (Possible) Content of Exam: 
* There will be an essay question for you to critically evaluate the history of phylogenetic inference, the different schools of thought through time, and/or the reasons and resolutions to conflict. 
* Understand what a phylogeny represents, why it's useful.

* Understand the principle of parsimony, history, Hennigian terminology and logic
    *  How to fit trees using parsimony, what types of characters are used
    *  Understand a bit about tree-space, how you move around it, why it's so big, how you search it, why you may end up with multiple equivalent trees, why you might end up with two different searches resulting in different trees

* Understand the principle of Maximum Likelihood, specifically how it works for a linear regression, in principle how it works for a general phylogenetic inference (but don't need to know the specific likelihoods or anything)
    * What are the parameters of a linear regression? How do you calculate the likelihood?
    * AND rules and OR rules in probability
    * Compare to Parsimony - what are the advantages over parsimony? What's LBA? Why does it occur? What, more generally, is the advantage of statistical phylogenetics? What arguments would favor parsimony? What are the units of branch lengths in statistical phylogenetics vs. parsimony? 
    
* Relationship between Maximum Likelihood and Bayesian Statistics
    * Bayes Rule & conditional probability
    * How does Bayesian Inference ask a different question than Frequentist statistics? 
    * What are the potential drawbacks of Bayesian inference? When is it essentially equivalent? 
    
* Phylogenetic models of evolution in discrete traits: Continuous Time Markov Chains
    *   Be able to define all the parameters in a CTMC
    *   Be able to interpret a particular Q matrix
    *   Understand in general terms how a likelihood is calculated on a tree (pruning algorithm)
    *   Understand how and why inferences may differ between parsimony and CTMCs. 
    *   **Understand all the major assumptions of the CTMC, which of them we can relax, and how (Something about this is guaranteed to be on the exam...)**
    
*   How do we deal with topological uncertainty in phylogenetic models? 
    *   Understand how a bootstrap works, how you would generally implement it and interpret it
    *   Understand how we estimate uncertainty in a Bayesian model 

*   Be able to describe the basics of model selection using relative goodness of fit measures, like AIC, BIC and LRTs
    *  When can you use a LRT? What are some drawbacks when comparing phylogenetic models?
    *  What trade-off do AIC and BIC try to represent? Understand how to interpret them and which model to choose given a set of AIC scores and knowledge of their complexity. 
    *  Understand the relationship between marginal likelihoods, Bayes rule and Bayes Factors; and why Bayesians aren't as worried about over-parameterized models as frequentists
    *  Understand why we might want absolute goodness of fit, and how parametric bootstrap and posterior predictive simulation accomplish this, including the role of summary statistics
    
*  Technical skills
    * You don't have to memorize commands in PAUP\* or anything like that, but understand the basic flow of an analysis, what a heuristic search produces, what will make it take longer/shorter, why you might want to change how you perform a search etc.
    * How is a tree represented in Newick format? 

