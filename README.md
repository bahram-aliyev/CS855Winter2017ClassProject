# Setup
The project folder contains a Podfile which lists all the required libraries to compile and run
the application.

CocoaPods package manager is required to download and setup the libraries for the project.
https://cocoapods.org/ There is a convenient visual client, https://cocoapods.org/app, just
install it and drag and drop the pod file, then press the install button in the right top corner.

After pods are installed a .xcworkspace file will appear in the project folder. That file should
be used to open the project in XCode.

# Known Issues
The channel listener is not implemented, therefore the second user must be logged in after
the channel created by the first user.

In general Firebase DB works fine, however, the pattern of its usage in the project is not very
appropriate. It seems to repeat message transmission every time a user signs in. The
preliminary assumption was that synchronization happens only once and the database
“remembers” which message were sent to whom based on the user account info.
Conclusion, it might be more suitable to use Firebase only, however, then it would be difficult
to implement searching.

Stored data disappears after the app restarts, happens randomly, did not have time to
troubleshoot properly. Considering that data gets requested after it is saved, and requested
data is returned, it might be due to a bug in the simulator or in SQLite.swift. However, data
stored and requested properly, that was checked many times.

# Project Structure
* Application - Application related configuration and global entities
* Authentication - Authorization and Authentication related services
* Services - Activity publishing and dispatching related services
* Communication - Networking related protocols and request/response classes
* DataAccess - Data access related protocols and clause classes
* Infrastructure - Technology specific implementation of all abstractions presented in Application, Services, Communication and DataAccess
	* Google - google cloud-related implementations
	* Generic - anything that related to UIKit however needed to be used in services or models, and static object wrappers
	* SQLite - SQLite specific implementation of DataAccess
	* Firebase - networking + application config
* Controllers - UI related view controller and views
* Models - presentation and business models of the application