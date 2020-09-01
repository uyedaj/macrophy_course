# Required and suggested software
This course will include in-class demos and projects requiring the use of phylogenetics and statistical software. In the interests of time and minimal headaches, all activities can be run remotely using a unique server login that will be provided to each student. However, you may wish to install the software we will use on your own machine and get them up and running so that you can carry out your own analyses locally. If you choose to do this, I will help as much as I can, but you will be responsible for setting up the software outside of class. Feel free to ask questions about any challenges you may have.

## Rstudio server
We will primarily be using Rstudio version running on my personal server. You will be provided the IP address, a username, and a temporary password that you will change immediately on your first login. Please choose a strong and secure password. Please do not share any login information or even the IP address with others outside the class. 

When you login for the first time, please click on the `terminal` tab and enter the following at the command prompt, replacing `username` with your unique user ID: 
```
passwd username
```
You will be prompted to enter your old password, and then to type your new password twice. Please choose a password that is SECURE.

This is a shared machine and I am using relatively loose restrictions on it at present. However, please be responsible. Do not run jobs in parallel over more than 5 threads without permission. Manage your memory load and do not load large files without permission. Before running a job that will be computational or memory intensive, or that will take a long period of time, please check the load on the server by running `htop` from the terminal and checking the status of both the CPUs and the Memory. When in doubt, contact your instructor.


## Desktop Software
### _R, Rstudio and Phylogenetics packages_
1. If you want a local version of Rstudio, download and install [Rstudio Desktop](https://www.rstudio.com/products/rstudio/#Desktop)
2. Make sure that your version of R > version 3.4
3. You will need a number of R packages throughout the course, and can install them as they are introduced. However, one easy way to prepare is to install the R package "ctv" and install ALL phylogenetics packages at once by using the [Phylogenetics Taskview](https://cran.r-project.org/web/views/Phylogenetics.html). This will take up to an hour to complete, so make sure you can let it run for a while. However, it's an easy way to be prepared for whatever analyses you may need in the future. 
```
install.packages("ctv")
ctv::install.views("Phylogenetics")
```
### _RevBayes_
Download and install [RevBayes](https://revbayes.github.io/software.html)

### _Optional software (subject to promotion to required, good to have regardless!)_
[MrBayes](http://mrbayes.sourceforge.net/download.php) (Bayesian inference of phylogenies)

[PAUP*](http://phylosolutions.com/paup-test/) Time-tested software for running parsimony and Maximum Likelihood phylogenetic analyses

[FigTree](http://tree.bio.ed.ac.uk/software/figtree/) Software for visualizing phylogenetic trees

[Tracer](http://tree.bio.ed.ac.uk/software/tracer/) Software for visualizing output of Bayesian MCMC software

[Mesquite](https://www.mesquiteproject.org/) User-friendly software suite for phylogenetic tree/data manipulation and analysis with an intuitive GUI. 

### _Other software_
[git](https://gist.github.com/derhuerst/1b15ff4652a867391f03) Version control software that will allow you to connect to interact with my course [github page](https://github.com/uyedaj/macrophy_course)



