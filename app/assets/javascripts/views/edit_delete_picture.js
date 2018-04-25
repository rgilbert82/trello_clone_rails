var DeletePictureView = Backbone.View.extend({
  className: "edit_modal",
  template: App.templates.edit_delete_picture,
  render: function() {
    this.$el.html(this.template({image_id: this.model.get("id")}));
    this.$el.appendTo($("#card_window_layer"));
  },
  initialize: function() {
    this.render();
  }
});
