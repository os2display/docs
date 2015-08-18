# Release process
This document explains the steps involved in make the next release of the aroskanalen display system. The repositories use the git flow branching module, which can be found here: http://nvie.com/posts/a-successful-git-branching-model/


## Conventions
This document uses __[]__ square brackets around the different variables in the commands below, their content should be swap with the correct values.

Here is an explanation of the different variables.

  * [VERSION] the release version that you are tagging e.g. 3.1.0
  * [NEXT NUMBER] the next release candidate number e.g. 2
  
<pre>
Things in boxes are commands that should be executed in the terminal.
</pre>

# The repositories and versioning
The three components _admin_, _middleware_ and _screen_ have the same version number while _search node_ follows it's own as it is used by other projects as well. The version number is based on http://semver.org/. The basic is summed up in the quote below.

> Given a version number MAJOR.MINOR.PATCH, increment the:
>
>    1. MAJOR version when you make incompatible API changes,
>    2. MINOR version when you add functionality in a backwards-compatible manner, and
>    3 .PATCH version when you make backwards-compatible bug fixes.
>
> Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

The documentation repositories should also be released with the same version number as the code because the information it provides relates to that specific release. Before it is merged and tagged, please review it to ensure that the version number etc. matches the actual release that you are doing.

__Note__: The release steps done in git has to be repeated for each of repository in the application.

# Release branch
First step before doing a finale release is to create a release branch that can be used to do testing and create release candidates. The release branch should follow the naming conversion _release/[VERSION]_.

<pre>
git checkout -B release/[VERSION]
git push -u origin release/[VERSION]
</pre>

The code below shows how to tag a release candidate.
<pre>
git checkout release
git pull origin release
git tag v[VERSION]-rc[NEXT NUMBER]
git push origin v[VERSION]-rc[NEXT NUMBER]
</pre>

# Merge into master
When the code is tested and approved, the release branch needs to be merged into the master branch and tagged.

First be sure that you have the newest code in your local copy of the repositories.
<pre>
git checkout release
git pull -u release
</pre>

Change to the master branch and merge the code in and push to remote. For more information about the _no fast forward_ merge command see the git flow branching module link in the top of this file.
<pre>
git checkout master
git pull -u origin master
git merge --no-ff release/[VERSION]
git push origin master
</pre>

Now that the release branch has been merged into master we need to remove it from remote.
<pre>
git branch -D release/[VERSION]
git push origin :release/[VERSION]
</pre>

# Tag release
Master now contains the newest version of the code and can be tagged with the release number.
<pre>
git tag v[VERSION]
git push origin v[VERSION]
</pre>


# Deployment

Before doing any deployment to production environments you should checkout the https://github.com/aroskanalen/docs/blob/development/upgrade.md for information about the steps required to upgrade to the current version.

Start by stopping the application and prevent users from accessing the application during update.
<pre>
sudo service nginx stop
sudo service supervisor stop
</pre>

Start by updating the _middleware_ and _search node_ applications. They are located in _/home/www/middleware_ and _/home/www/search___node_.
<pre>
git checkout master
git pull origin master
git check v[VERSION]
</pre>

You should be able to start up again.
<pre>
sudo service supervisor start
</pre>


Next checkout the administration interfaces and screens, which are located in _/home/www/client name].aroskanalen.dk/admin_ and _/home/www/client name].aroskanalen.dk/screen_.

<pre>
git checkout master
git pull origin master
git check v[VERSION]
</pre>


Start the web-service agin. Remember to check the _upgrade_ document as it may contain steps that you have to preform before opening for users.
<pre>
sudo service nginx start
</pre>


# Helpful commands.
When making a new release these commands can be useful

 * git branch -a see all branches also those not checkout locally.
 * git diff master...v[VERSION] see the different between as tag and the current master branch. Useful to se if anything have changed since last release tag.
 * git log --oneline --decorate master...v[VERSION] see all commits as one-lines since last release and the current master branch.
 

