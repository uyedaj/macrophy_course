# Instructions for turning in PAUP\* lab
1. Go to https://github.com and sign up if you have not done so already. Using your @vt.edu email address will allow you to apply for the [student developer pack](https://help.github.com/articles/applying-for-a-student-developer-pack/). Sign in to your account.

2. Go to https://github.com/uyedaj/macrophy_course/ and in the upper right corner you should see a 'fork' button. Click the button and select your account. Wait a few moments and you will be taken to a screen with the forked repository. 

3. You have already made changes to the original respository in the lab we did last week. Therefore, we will need to reset the origin of our modified directory to be our newly forked repository. To do so, navigate to the ./macrophy_course/ folder on my server: https://128.173.187.20:8080/wetty/ssh/<username>

4. Type ```git status``` and you should see the changes that you've made during the last lab. Type the following commands to reset the origin of this git repository to your new fork (Note that <username> needs to be replaced with your github username!!!) :
```
git remote rename origin upstream
git remote add origin https://github.com/<username>/macrophy_course.git
git fetch origin
git branch --set-upstream-to origin/master master
git push
```

5. Now commit your output folder from lab. Replace "<user_results>" with the folder holding your results from lab. You will be prompted for your username and password upon pushing these results to github.
```
git add ./projects/PAUP_lab/<user_results>/*
git commit -m "Results from lab for user <username>"
git push
```

6. Navigate to your fork's webpage, https://github.com/<your_github_username>/macrophy_course/, and click on the button that says ```New pull request```. Hit ```Create pull request```. Give it a descriptive name and leave a comment. Then finish by hitting ```Create pull request``` again.
