var List = Backbone.Model.extend({
  defaults: {
    "archived": false
  },
  setCards: function() {
    this.set({"cards": new Cards()});
  },
  resetCards: function() {
    this.get("cards").reset(App.cards.where({"list_id": this.id}));
  },
  addCard: function(model) {
    var newCardPosition = model.get("position");

    this.reorderCards(newCardPosition);
    this.get("cards").add(model);
  },
  reorderCards: function(newCardPosition) {
    this.get("cards").each(function(card, index) {
      var position = index + 1;

      if (newCardPosition && position >= newCardPosition) {
        card.set({ "position": position + 1 });
      } else {
        card.set({ "position": position });
      }
    });
  },
  changeCards: function(model) {
    this.get("cards").remove(model);
    this.reorderCards();
    App.addCardToList.call(App, model);
  },
  writeChanges: function() {
    this.save();
  },
  bindEvents: function() {
    this.listenTo(this, "change:title", this.writeChanges.bind(this));
    this.listenTo(this, "change:position", this.writeChanges.bind(this));
    this.listenTo(this, "change:board_id", this.writeChanges.bind(this));
    this.listenTo(this.get("cards"), "change:list_id", this.changeCards.bind(this));
  },
  initialize: function() {
    this.setCards();
    this.bindEvents();
  }
});
