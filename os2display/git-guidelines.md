Git & Git-flow guidelines
==========

__TODO__ jeskr: Remove the git-flow commands and use normal git commands. This will make it eaiser for other developers to understand what happens.

This document is a guideline for using GIT with loop.

These are *guidelines*, and if you think it's necessary to deviate feel free to do so, **but** please be
sensible and only do this when necessary and make sure you don't break it for everyone else.

* Be familiar with [Git](http://git-scm.com/)
* and [A successful Git branching model (Gitflow)](http://nvie.com/posts/a-successful-git-branching-model/)
* and [Gitflow workflow](https://www.atlassian.com/git/workflows#!workflow-gitflow)

Below is only summarized, so be sure to familiarize yourself with the above mentioned. For a
visual summary see this [Cheat Sheet](http://danielkummer.github.io/git-flow-cheatsheet/).

Content
----------

1. [Gitflow Workflow](#workflow)
2. [Branch Model](#branches)
3. [Main Branches](#main)
4. [Feature Branches](#feature)
5. [Release Branches](#release)
6. [Maintenance Branches](#maintenance)
7. [Gitflow made visual](#visual)
8. [Commit messages](#commit)



<a name="workflow"></a>
1. Gitflow Workflow Setup
----------

We use the gitflow workflow for our projects. It's a workflow utilizing a strict branching
model around our project release. If you are unfamiliar with gitflow please read
[Gitflow workflow](https://www.atlassian.com/git/workflows#!workflow-gitflow) and
[A successful Git branching model (Gitflow)](http://nvie.com/posts/a-successful-git-branching-model/)

### Install extension

For convenience please install the [git flow extensions](https://github.com/nvie/gitflow):

```Shell
 brew install git-flow
```

If you don't use Mac / Homebrew please see the [installation instructions](https://github.com/nvie/gitflow/wiki/Installation)

### Init

Use the following command to set up a repository for gitflow:

```Shell
git flow init
```

You will be asked to define the specific setup. Please choose as follows:

```Shell
Branch name for production releases: [master]
Branch name for "next release" development: [develop]
How to name your supporting branch prefixes?
Feature branches? [feature/]
Release branches? [release/]
Hotfix branches? [hotfix/]
Support branches? [support/]
Version tag prefix? [v]
```

### Start work on project

1. Clone/create repository
2. Initialize repository for Git flow using above settings (Note: Git flow is an entirely local setting - it needs to be done each time you clone/create)

### Daily Workflow

1. Decide if the work your are doing belongs in af feature/* or hotfix/* branch. As a rule of thumb any tickets on the support board are hotfixes and tickets on the team board/project boards are features.
2. Make a new branch from either master (hotfix) or develop (feature)
3. Fix/implement and commit the required changes
4. Complete your branch as described below

_Never work directly in either master or develop_



<a name="branches"></a>
2. Branch Model
----------

<a name="main"></a>
1. Main Branches


We use to main branches to store our project history, these branches have an _infinite lifetime_.

* master (stores the official release history)
* develop (serves as an integration branch for features)

It's convenient to tag all merges to the master branch with a version number eg. 'v1.1.0'

Further we use the following temporary branch types:

* feature/* (Each new feature gets a dedicated feature branch)
* release/* (Collection of completed features ready to be launched)
* hotfix/*  (For fixing bugs in code deployed to production)

Temporary branches should always be deleted after completion.



<a name="feature"></a>
3. Feature Branches
----------

New features should reside in its own branch, which can then be pushed to the central repository. Never branch off of master, feature branches use develop as their parent. When a feature is completed, it is merged back into develop. Feature branches should never interact directly with master.

**Conventions:**

* branch off: develop
* merge into: develop
* naming convention: feature/*

**Commands:**

Start a new feature using:

```Shell
git flow feature start [name]
```

Ex:

```Shell
git flow feature start split-screen
```

Will create a branch called "feature/spli-screen

this will create a new branch called feature/[name] based on develop branch and git-flow automatically switch to it. Now when you’re done, just finish it using:

```Shell
git flow feature finish [name]
```

It’ll merge feature/[name] back to develop and delete the feature branch.

If others need to work on the same feature you need to publish (push to origin) your feature branch:

```Shell
git flow feature publish [name]
```

To work on a feature branch started by someone else you need to pull it:

```Shell
git flow feature pull [name]
```

<a name="release"></a>
4. Release Branches
----------

When enough features have been accumulated into the develop branch a release branch is created. While this might seem redundant for smaller updates it ensures that we can always develop/test/launch/roolback with out issues.

**Conventions:**

* branch off: develop
* merge into: master, develop
* naming convention: release/*

**Commands:**

**Caution!** Finishing a release merges to master. Do not do this until the release is ready to deploy to prod!

To list/start/finish release branches, use:

```Shell
git flow release
git flow release start [name]
git flow release finish [name]
```

When you finish a release branch, it’ll merge your changes to master and back to develop, also git-flow will create a tag for this release.


<a name="maintenance"></a>
5. Maintenance Branches
----------

Maintenance or "hotfix" branches are used to quickly patch production releases. This is the only branch that can and should branch out directly of master. As soon as the fix is complete, it should be merged into both master and develop (or the current release branch), and master should be tagged with an updated version number.

__Conventions:__

* branch off: master
* merge into: develop and master
* naming convention: hotfix/[issue#]

__Commands:__

To list/start/finish release branches, use:
```Shell
git flow hotfix
git flow hotfix start [name]
git flow hotfix finish [name]
```

When you finish a release branch, it’ll merge your changes to master and back to develop.



<a name="visual"></a>
6. Visual view of Gitflow model
----------

![gitflow](assets/git-workflow-gitflow.png "Gitflow, image taken from atlassian.com")
image courtesy of atlassian.com



<a name="devsetup"></a>
7. Mapping git flow to our dev setup
----------

In a typical project the various branches will map to our development setup as follows:

| Branch        | Server        | Notes  |
| ------------- | ------------- | ------ |
| Master        | prod          | -      |
| Develop       | dev           | -      |
| Release       | stg           | -      |
| Feature       | vagrant       | -      |
| Hotfix        | vagrant / stg | Optionally test on stg before deploying to prod      |



<a name="commit"></a>
8. Writing good commit messages
----------

Good commit messages serve three important purposes:

* Speed up the reviewing process.
* Help us write a good release note.
* Help the future maintainers (it could be you!), say five years into the future, to find out why a particular change was made to the code or why a specific feature was added.

Structure your commit message like this:


>Summarize clearly in one line what the commit is about
</br></br>
>Describe the problem the commit solves or the use
>case for a new feature. Justify why you chose
>the particular solution.

### Do


* Write the summary line and description of what you have done in past tense, indicating that the event took place in the past. Write "fixed", "added", "changed", "updated" instead of "fix", "add", "chang", "update.
* Line break the commit message (to make the commit message readable without having to scroll horizontally).

Usually, commit messages start with the (past tense) verb

* "Added" (new feature)
* "Fixed" (bug fix)
* "Changed" (task)
* "Updated" (task, due to changes in third-party code)

### Don't

* Don't end the summary line with a period.

### Tips

* If it seems difficult to summarize what your commit does, it may be because it includes several logical changes or bug fixes, and are better split up into several commits using [git add -p](http://johnkary.net/blog/git-add-p-the-most-powerful-git-feature-youre-not-using-yet/).

