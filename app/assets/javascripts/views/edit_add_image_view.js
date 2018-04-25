var AddImageView = Backbone.View.extend({
  className: "edit_modal",
  template: App.templates.edit_add_image,
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo($("#card_window_layer"));
  },
  initialize: function() {
    this.render();
  }
});
