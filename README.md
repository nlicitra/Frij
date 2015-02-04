# Frij
_Keep track of your utilities like a real adult!_

Frij is a single page application project using Python/Django for the backend and AngularJS in the front.

![Frij UI]
(http://i.imgur.com/mTVYZuE.png)

###So How Do I Use This Thing?
With the server running, navigate to http://_(somedomain)_/frij/ and it will default to showing you the current month. If no data has been previously entered, all values are initialized to $0.00. The chart on the right will display data for all utilites over the previous 12 months. Clicking on a specific part of the graph will allow you to edit that month's utility charges. Clicking the save button will persist the values to the database and reflect the change on the graph.

On the first day of a new month, the system will create a new charge period for the month and initialize all values for that month to $0.00. You can then enter the quanities as you please.

A small sample database has been included that has been pre-populated with data up until January 2015.

###Gulp Automation
When first running the application or after any change is made to a .coffee file in /src/scripts/, you must run the following gulp commands in order:
* convert - Converts the coffee script into javascript and then lints the resulting files, storing them in build/js/.
* deploy -  Moves all files in build/js/ to django's static script file location.

