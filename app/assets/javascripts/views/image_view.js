var ImageView = Backbone.View.extend({
  className: "image_modal",
  template: App.templates.image,
  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.$el.appendTo($("#card_window_layer"));
  },
  initialize: function() {
    this.render();
  }
});
