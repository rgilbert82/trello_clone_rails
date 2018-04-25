# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


User.create(first_name: "Ryan", last_name: "Gilbert", email: "ry.gil.online@gmail.com", password: "password", admin: true)
User.create(first_name: "Hello", last_name: "World", email: "hello@world.com", password: "password", active: false)
