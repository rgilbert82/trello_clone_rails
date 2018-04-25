var ArchiveListView = Backbone.View.extend({
  className: "list_options_modal modal_window",
  template: App.templates.archive_list,
  events: {
    "click .x_out_card_options_window": "closeModal",
    "click .close_modal_layer": "closeModal",
    "submit form": "archiveList"
  },
  closeModal: function() {
    this.$el.remove();
  },
  archiveList: function(e) {
    var board_id = this.model.get("board_id");

    e.preventDefault();

    App.archiveList(this.model);
    App.reSetupBoard(board_id);
  },
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo(this.attributes.parent);
  },
  initialize: function() {
    this.render();
  }
});
