## iOS App for Yale's Special Services Van

------

Wheels is an iOS application for hailing rides on Yale's Special Services Van. The app's objective is to replace its predecessor system for scheduling rides at Yale. In the previous system, users were required to call the Special Services dispatcher and provide the details (time, address, and accessibility requirements) for each ride. This system was inconvenient and had low bandwidth for scheduling rides. People often had to wait on hold for 5-10 minutes before reaching the dispatcher, and pickup locations were often miscommunicated. By contrast, Wheels eliminates waiting for the dispatcher (since many users can schedule rides simultaneously), and ride summaries are accompanied with GPS-based pickup information. The app allows users to quickly schedule rides and view their upcoming itinerary. Moreover, users can request to be picked up at their current GPS location.

Wheels synchronizes through Amazon Web Services' (AWS) DynamoDB. All users' rides are stored in a DynamoDB table, and, using AWS Lambda triggers, the dispatcher receives notifications when a ride is scheduled, deleted, or needs to be executed. Users are authenticated using AWS Cognito, where NetIDs are checked against a whitelist maintained by Yale's Resource Office of Disabilities. This backend design was chosen to combine the extensibility of DynamoDB, security of Cognito, and the reliability of AWS in general. In short, Wheels replaces both the rider-dispatcher communication channel and the centralized data store for rides on Yale's Special Services Van. We hope that Wheels will improve the campus experience for all limited-mobility students, staff, and faculty at Yale.
