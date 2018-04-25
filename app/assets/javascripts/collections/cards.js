var Cards = Backbone.Collection.extend({
  url: '/api/cards',
  model: Card,
  comparator: function(card) {
    return card.get("position");
  }
});
