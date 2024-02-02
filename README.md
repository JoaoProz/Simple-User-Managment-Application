# Simple User Application

This project is part of the technical assignment for ziggu.

This project consists of a simple user management application where you could add new users, edit or delete existing users.

* Versions:
    Ruby 2.7.5, Rails 5.2.8.1 and Vue 3.4.15

* Tests:
    There's testing for the backend side of the application using the rspec framework.


Video showing how it works:

https://github.com/JoaoProz/ziggu-code-assignment/assets/37293167/1253dc6a-d0fc-4e49-8756-83d236b8b609


Concerns and extra considerations:

    - Testing: Tried to use Vitest to create tests for the frontend but got a lot of problems with dependencies and decided to move forward without implementing it.
    
    - User Experience: The UI is basic and could be improved to make it more appealing and easier to use.
    
    - Error Handling: I have implemented some error handling mechanisms but I think there are better ways to do it.

    - Security: I've hardcoded the API URL and its not the best practice, probably creating a env file for development and add the url there would be a better aproach.

