#Contribution guidelines

Thank you for your interest in contributing. It is greatly appreciated.



##Content
1. [Pull requests](#pull-requests)
2. [Issues](#issues)



<a name="pull-requests"></a>
##1. Pull requests

Code contributions to this project follow this process and set of requirements:

1. As a contributor you should create an issue on [github](https://github.com/os2display) describing the suggested change. This allows the business side of the project to evaluate your suggestion. If it is accepted for inclusion it will be marked for review.
2. All communication on GitHub should be in English.
3. The title of your pull request must refer to the issue number if applicable e.g. *[issue number]: [short summary of change]*.
4. The description of your pull request should include a link to the issue.
5. The body of the pull request should provide a short description of the suggested change and the reasoning behind the approach you have chosen.
6. If your change affects the user interface you should include a screenshot of the result with the pull request.
7. The first line of your commit message (the subject) must follow this format: `[issue number]: [short summary of change]`. The subject should be kept around 50 characters long. The subject must not be more than 69 characters long. Strive for about 50 characters.
8. Your code must comply with [our coding standards](code-standards.md).
9. Your code will be run through a set of static analysis tools and continuous integration builds to ensure compliance and project integrity. Your code should pass these tests without raising new issues or breaking the build. [The status of the tests will be reported within the pull request](https://github.com/blog/1935-see-results-from-all-pull-request-status-checks). If you want to be notified through other means you must follow the projects/subscribe to updates on the individual test platforms.
10. If your code does not pass these tests please make the necessary changes to pass the tests.
If you think the changes should be accepted despite failed tests you should provide a comment in the pull request explaining why this change should be exempt from the code standards and process. If you have suggestions for changes to our code standards going forward please submit a pull request to the static analysis tool configuration .scrutinizer.yml, .jshintrc. Do not expect changes to be accepted before your current pull request is accepted.
11. Core members will review your proposed change and provide questions, comments and suggestions for changes. Please follow up as quickly as possible. Changes will not be merged before passing through this review.



<a name="issues"></a>
##2. Issues

Issues should be created in the appropriate repository on github.

* __admin__: https://github.com/os2display/admin/issues
* __screen__: https://github.com/os2display/screen/issues
* __middleware__: https://github.com/os2display/middleware/issues
* __vagrant__: https://github.com/os2display/vagrant/issues
* __styleguide__: https://github.com/os2display/styleguide/issues
* __docs__: https://github.com/os2display/docs/issues
