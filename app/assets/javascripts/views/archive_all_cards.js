var ArchiveAllCardsView = Backbone.View.extend({
  className: "list_options_modal modal_window",
  template: App.templates.archive_all_cards,
  events: {
    "click .x_out_card_options_window": "closeModal",
    "click .close_modal_layer": "closeModal",
    "submit form": "archiveAllCards"
  },
  closeModal: function() {
    this.$el.remove();
  },
  archiveAllCards: function(e) {
    e.preventDefault();

    this.model.get("cards").slice().forEach(function(model) {
      App.archiveCard(model);
    });

    App.reSetupBoard(this.model.get("board_id"));
  },
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo(this.attributes.parent);
  },
  initialize: function() {
    this.render();
  }
});
