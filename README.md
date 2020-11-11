# Monster Shop
[Project Link](https://final-monster-shop-g2.herokuapp.com/)

## Contributors
* [Garrett Cottrell](https://github.com/GarrettCottrell)
* [Greg Mitchell](https://github.com/GregJMitchell)
* [Jake Heft](https://github.com/jakeheft)
* [John Kim](https://github.com/abcdefghijohn)

## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will be able to get "shipped" by an admin. Each user role will have access to some or all CRUD functionality for application models.

## Setup

This project requires Ruby 2.5.3.
This project requires Rails 5.2.4.3.

* From the command line, install gems and set up your DB:
    * `bundle install`
    * `rails db:create`
    * `rails db:migrate`
    * `rails db:seed`
* Run the test suite with `bundle exec rspec`. There should be 198 passing tests.
* Run your development server with `rails s`. Visit [localhost:3000/merchants](http://localhost:3000/merchants) to see the app in action.

## Learning Goals

### Rails
* Create routes for namespaced routes
* Use Sessions to store information about a user and implement login/logout functionality
* Use filters (e.g. `before_action`) in a Rails controller
* Limit functionality to authorized users
* Use BCrypt to hash user passwords before storing in the database
* Use rails resources for RESTful routes
* Implement query params


