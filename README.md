# README

This guide will help you set up and run this Rails application on your local machine.

Prerequisites
Make sure you have the following installed on your system:

Ruby (version 3.3.3)
Rails (version 7.1.5)

Install Ruby and Rails dependencies
    gem install bundler
    bundle install

Set up the Database
    rails db:create
    rails db:migrate

Start the Rails server
    rails server

Access the Application
    Open your browser and navigate to http://localhost:3000 to view the application.


To test run following command in terminal
    rspec


NOTE:- if you get any tailwind css error in assets please run rails assets:precompile before running rails server