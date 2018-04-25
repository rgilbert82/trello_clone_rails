# Trello Clone

This is a single-page clone of Trello that I made with Rails 5 and Backbone.js, using Handlebars for templating. Features include:

* Users can sign up for new accounts for $4.99 per month.
* Subscriptions and credit card payments are handled by the [Stripe API](https://stripe.com/) (currently set in test mode).
* Registered users can update their account info.
* Registered users can update their credit card info and subscription status.
* Registered users can have a password-reset email sent to them if they forget their password.
* Subscribed users can create and modify boards, lists, and cards.
* Subscribed users can upload and download images. Image uploads are handled by the [CarrierWave](https://github.com/carrierwaveuploader/carrierwave) gem.
* Cards can hold a variety of information, such as notes, due dates, labels, images, and activity.
* Cards can be moved between lists, and lists can be moved between boards via drag-and-drop functionality.
* Admins get full access to the TrelloClone app for free.
* Admins can manage the accounts of the other users.
* Admins can view all credit card payments.

------
[Heroku link](https://rg-trello-rails.herokuapp.com/)
