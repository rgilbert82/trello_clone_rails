var CopyListView = Backbone.View.extend({
  className: "list_options_modal modal_window",
  template: App.templates.copy_list,
  events: {
    "click .x_out_card_options_window": "closeModal",
    "click .close_modal_layer": "closeModal",
    "submit form": "copyList"
  },
  closeModal: function() {
    this.$el.remove();
  },
  cloneCards: function() {
    return this.model.get("cards").map(function(card) {
      var cardData = card.toJSON();

      delete cardData.id
      return cardData;
    });
  },
  copyList: function(e) {
    var title = $(e.target).serializeArray()[0].value;
    var position = App.boards.get(this.model.get("board_id")).get("lists").length + 1;
    var data = this.model.toJSON();
    var newList;
    var newCards;

    e.preventDefault();

    delete data.id;
    data.title = title;
    data.position = position;
    newList = new List(data);
    newCardData = this.cloneCards();
    App.addNewList.call(App, newList, newCardData);
  },
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo(this.attributes.parent);
  },
  initialize: function() {
    this.render();
  }
});
