# Computational Exercise in PAUP*

We will be using the software program called PAUP\* (Phylogenetic Analysis Under Parsimony \*and other methods) written by David Swofford. PAUP\* is an old program that has been around for decades now (v3 in 1989). As its name suggests the original version only performed parsimony. For many years, PAUP* v4.0b10 was commercial software distributed by Sinauer Associates. However, recently the license has expired and PAUP* will now be released as an open-source software as v.5.0, with “test” versions available now. While a variety of alternative likelihood and parsimony software programs exist, few have as reliable a likelihood estimation as PAUP*. There are GUIs available for some versions, but we will be using 

## Logging into the server
I have given you accounts on my server. You can access a terminal to this machine by going to the following address in your browser, with *<pid>* replaced with your VT PID. You will see a screen warning you not to continue, do it anyway. I will supply your initial password in class. 

```
https://128.173.187.20:8080/wetty/ssh/<pid>
```

As your first action, please update your password using the command below, replacing *username* with your PID. Please use something secure. 

```
passwd username
```
####*Alternative method*
We are using a browser that access my lab's computer to get you up and running as soon as possible. Note that more features will be available if you 1) install PAUP\* on your own machine (https://paup.phylosolutions.com/) 2) you SSH into my machine through a command line using an SSH client (native in Mac & Linux, https://www.putty.org/ or equivalent in Windows). If you would prefer this option or already know something about SSH, you can do the following from  terminal (this will only work if you are the VT network or VPN): 
```
ssh username@128.173.187.20
```
Either way, please change your pwd to something secure once you are in!

## Get the data for the lab

We are going to use git to clone the course repository. First, let's make a new directory in our home directory. 

```
mkdir repos
cd repos
```

Now clone the repository.
```
git clone https://github.com/uyedaj/macrophy_course.git
cd macrophy_course
ls
```

Now navigate to the lab folder (NB: you can hit tab to autocomplete):
```
cd projects/PAUP_lab/
ls
```

We're going to make a directory for your results. Make the folder your username
```
mkdir juyeda
```

## Getting started with PAUP\*
Today, we are working with data that has been simulated on a bear phylogeny. Let's look at the phylogeny itself and how it is stored. 
```
more bears.tre

```
What are the numbers? How is the topology represented? 
  
Now let's look at the data, which is saved in *NEXUS* format. 
```
more bears_JC69.nex
```

To launch paup, simply type the name of the program. Because I installed the software in the system path, 
it can be launched from anywhere. Otherwise, you'd have to be in the directory with the program. 

```
paup
```
You should be greated by the following screen: 

```
P A U P *
Version 4.0a (build 163) for Unix/Linux (built on Jul 23 2018 at 19:49:27)
Tue Sep 11 21:03:57 2018

        -----------------------------NOTICE-----------------------------
          This is an alpha-test version that is still changing rapidly.
          It will expire on 1 Nov 2018.

          Please report bugs to dave@phylosolutions.com
        ----------------------------------------------------------------

Running on Intel(R) 64 architecture
SSE vectorization enabled
SSSE3 instructions supported
Multithreading enabled for likelihood using Pthreads
Compiled using GNU C compiler (gcc) 4.8.4

paup> 
```
Type "?" to get a list of possible commands. Type a command followed by a question mark (e.g. "lset ?") to get 
help about a specific function. 

Next we execute our data block and do an exhaustive parsimony analysis.
```
execute bears_JC69.nex
outgroup Canis_lupus
```
Now conduct an exhaustive parsimony search. 
```
set criterion=parsimony
alltrees

```
The best tree (or trees) are automatically saved to memory, how many trees were found? Use *ShowTrees*, *DescribeTrees* and *pscores* to examine the phylogenies (e.g. *ShowTrees 5* will examine the 5th tree saved in memory, if it exists). 

We can also do a branch and bound search.
```
bandb
```

Was it any faster? 

After we have found trees, we can save our results. You are going to write these results to the output folder you created earlier with your username on it. 
```
savetrees file=./username/descriptive-file-name.tre format=newick root=yes brlens=yes supportvalues=nodelabels trees=all
```


Now we can estimate the tree using likelihood. We have to specify the model using the function *lset*. Use *lset ?* to see the current (default) settings. 
```
set criterion=likelihood
lset ?
```

Let's start with a Jukes-Cantor model (what this data were simulated under). 
```
lset nst=1 basefreq=equal
hsearch
```
How many trees were found? How do they compare to those found under parsimony? Instead of using *pscores*, use *lscores* to see the likelihood of the data given the ML tree. Also use *describetrees /plot=phylogram* to plot the tree with branch lengths. Try modifying the model lset (increasing *nst=2* or *nst=6* w/*rmatrix=estimate*; or setting *basefreq=empirical*) and rerun hsearch. Does this increase the likelihood (decrease the -lnL) substantially? 

Now let's consider another dataset. Let's first load the modified "true tree" that I used to simulate the data. How is it different? What is the biological meaning of the changes?
```
execute bears_LBAtree.nex
describetrees /plot=phylogram
```
Now perform a parsimony anaylsis. How has the resulting tree changed? How does it compare to the true tree? 

Let's now determine how confident we are in the tree. We're going to use a method called the boostrap, which will be explained in class. 

```
bootstrap nreps=100
```

Sequentially load all the files *bears_LBAXXX.nex* which have sequences of different length and perform a bootstrap analysis. What happens as you increase the length of the sequences? 

Now analyze these sequences using likelihood. Notice that the bootstrap is going to take WAAAY too long for us if we do the larger sequences. So instead of using the better search algorithms, let's make it simpler. These are quick and dirty ways of analyzing data. If you wanted publication quality, you may want to search more exhaustively. 

```
bootstrap nreps=100 search=heuristic/swap=NNI nreps=1
```

What is the consequence of adding more data in the likelihood example? 

## Finally...a real dataset!

We are now going to actually analyze a real dataset. We have a real sequence dataset from these species. But first, we need to establish what the correct model of sequence evolution is. We could do this all within PAUP\*. In fact, if you run the following command: 

```
execute modelblockPAUPb10.nex
```
It will fit a large set of models which can then be ranked. However, the output is a bit dense to parse, and the software used to summarize them is a bit hard to get these days. Folks usually select models using stand alone software like *jModeltest2*. We're going to use *modeltest-ng*, which can be run from command line. Open up another browser tab and navigate again to the portal for accessing the server. Navigate to the PAUP_lab director again, and run the following command:
```
modeltest-ng -i bears_irbp.phy
```
Note that we have two files with our sequence data, *bears_irbp.phy*, which is in Phylip format, while PAUP\* will want Nexus format (*bears_irbp.nex*). There are lots of conversion tools available, I've done it already to save time. 

What is the best model? Does the answer differ depending on the criterion you pick? What is the correct criterion anyway!?!

Challenge: Implement the model in PAUP\* and analyze using a heuristic search. Perform a bootstrap analysis with 100 replicates that takes a reasonable amount of time. Save the tree in your output folder. 

## Submit your final analysis to github

Get a github account if you don't already have one. Now you're going to take your results and submit them to the github repository so I can take a look and give you credit. 

Navigate to the macrophy-course directory: 
```
cd ~/repos/macrophy-course
git status
git add ./projects/PAUP_lab/username/
git commit -m "Adding <username>'s lab exercise results"
```



