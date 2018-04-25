var ArchiveCardView = Backbone.View.extend({
  className: "edit_modal",
  template: App.templates.edit_archive_card,
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo($("#card_window_layer"));
  },
  initialize: function() {
    this.render();
  }
});
