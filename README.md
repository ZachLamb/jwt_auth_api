---

# JWT-Based Authentication and Authorization API

## Objective

Build a JWT-based API for user authentication and authorization. The system should include user registration, login, token validation, token refresh, and secure data retrieval. I used Ruby on Rails in part to use what you all use in your workplace. Also, Rails is known for its "convention over configuration philosophy", which is useful for quickly spinning up technical solutions.

## Process

I took a TDD approach since I'm newer to RoR to help me every step of the way. Along with this, I also used Postman to validate the API as if I was a frontend dev consuming this API and tested both happy and sad paths.


## Best Practices Followed
Skipping CSRF for APIs: I disabled CSRF for testing purposes, but it could easily be hidden behind an env flag or removed entirely
Parameter Filtering: Strong parameter filtering with user_params ensures that only the allowed parameters are accepted, preventing mass assignment vulnerabilities.
Error Handling: Proper error handling and response status codes are used to inform clients about the outcome of their requests, enhancing the developer experience.
Database Seeding for Testing: Seeding the database with specific data for testing ensures that the tests are consistent and reliable.


## Installation

1. Install Ruby:
    ```sh
    brew install ruby@3.1
    ```

2. Install dependencies:
   ```sh
   bundle install
   ```

3. Set up the database:
   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Run the server:
   ```sh
   rails server
   ```

## Running Tests

To run the tests, use the following command:
```sh
bundle exec rspec
```

I have included a collection of Postman routes in case you want to test those. After registering a user, make sure to grab the token and put it inside the bearer token in the Authorization token.
