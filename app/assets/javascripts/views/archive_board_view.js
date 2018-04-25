var ArchiveBoardView = Backbone.View.extend({
  className: "archive_board_modal",
  template: App.templates.archive_board,
  events: {
    "click .x_out_card_options_window": "removeModal",
    "submit form": "archiveBoard"
  },
  archiveBoard: function(e) {
    e.preventDefault()
    
    this.removeModal();
    App.archiveBoard(this.model);
    router.navigate("/", { trigger: true });
  },
  removeModal: function() {
    this.$el.remove();
  },
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo($(App.$el));
  },
  initialize: function() {
    this.render();
    $(".menu_modal").on("click", this.removeModal.bind(this));
  }
});
