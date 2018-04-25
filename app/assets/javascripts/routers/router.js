var router;

$.when(
  App.cards.fetch(),
  App.lists.fetch(),
  App.boards.fetch(),
  App.comments.fetch(),
  App.activities.fetch(),
  App.pictures.fetch()
).done(function() {
  router = new (Backbone.Router.extend({
    routes: {
      "boards/:board_id": App.setupBoardIfValidRoute.bind(App),
      "cards/:card_id": App.openCardWindowIfValidRoute.bind(App)
    },
    index: function() {
      App.index();
    },
    initialize: function() {
      this.route(/^\/?$/, "index", this.index);
    }
  }))();

  Backbone.history.start({
    pushState: true
  });
});
