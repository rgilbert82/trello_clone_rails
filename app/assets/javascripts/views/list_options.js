var ListOptionsView = Backbone.View.extend({
  className: "list_options_modal modal_window",
  template: App.templates.list_options,
  events: {
    "click .x_out_card_options_window": "closeModal",
    "click #list_option_add_card": "listAddCardView",
    "click #list_option_copy_list": "copyListView",
    "click #list_option_move_list": "moveListView",
    "click #list_option_move_all_cards": "moveAllCardsView",
    "click #list_option_archive_all_cards": "archiveAllCardsView",
    "click #list_option_archive_list": "archiveList",
    "click .close_modal_layer": "closeModal"
  },
  closeModal: function() {
    this.$el.remove();
  },
  listAddCardView: function(e) {
    var $listView = this.$el.closest(".list_view");

    e.preventDefault();

    this.closeModal();
    $listView.find(".footer_add_a_card")[0].click();
  },
  copyListView: function(e) {
    e.preventDefault();

    this.closeModal();
    App.copyListView(this.model, this.attributes.parent);
  },
  moveListView: function(e) {
    e.preventDefault();

    this.closeModal();
    App.moveListView(this.model, this.attributes.parent);
  },
  moveAllCardsView: function(e) {
    e.preventDefault();

    this.closeModal();
    App.moveAllCardsView(this.model, this.attributes.parent);
  },
  archiveAllCardsView: function(e) {
    e.preventDefault();

    this.closeModal();
    App.archiveAllCardsView(this.model, this.attributes.parent);
  },
  archiveList: function(e) {
    e.preventDefault();

    this.closeModal();
    App.archiveListView(this.model, this.attributes.parent);
  },
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo(this.attributes.parent);
  },
  initialize: function() {
    this.render();
  }
});
