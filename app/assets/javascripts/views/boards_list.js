var BoardsListView = Backbone.View.extend({
  className: "general_modal_left",
  template: App.templates.boards_list,
  events: {
    "click .x_out_card_options_window": "closeModal",
    "click .close_modal_layer": "closeModal",
    "click .menu_boards_list_ul li": "navigateToBoard"
  },
  navigateToBoard: function(e) {
    var boardID = $(e.currentTarget).attr("data-board_id");
    var slug = App.boards.get(boardID).get("slug");
    var pathName = "boards/" + slug;

    this.closeModal();
    App.removeCardWindow();
    router.navigate(pathName, { trigger: true });
  },
  closeModal: function() {
    this.$el.remove();
  },
  render: function() {
    this.$el.html(this.template({ personal_boards: App.boards.toJSON(), starred_boards: new Boards(App.boards.where({"starred": true})).toJSON() }));
    this.$el.appendTo($("#header_boards_button"));
  },
  initialize: function() {
    this.render();
  }
});
