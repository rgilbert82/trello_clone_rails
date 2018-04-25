var MenuView = Backbone.View.extend({
  className: "menu_modal",
  template: App.templates.menu,
  events: {
    "click .x_out_card_options_window": "closeModal",
    "click .close_modal_layer": "closeModal",
    "click .delete_this_board": "openDeleteBoardWindow"
  },
  openDeleteBoardWindow: function(e) {
    var board = this.model.get("board");

    e.preventDefault();

    App.archiveBoardView(board);
  },
  closeModal: function() {
    this.$el.remove();
  },
  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.$el.appendTo(App.$el);
  },
  initialize: function() {
    this.render();
  }
});
