var ProfileOptionsView = Backbone.View.extend({
  className: "general_modal",
  template: App.templates.profile_options,
  events: {
    "click .x_out_card_options_window": "closeModal",
    "click .close_modal_layer": "closeModal",
  },
  closeModal: function() {
    this.$el.remove();
  },
  render: function() {
    this.$el.html(this.template({ "admin": App.user.get("admin") }));
    this.$el.appendTo($("#header_username"));
  },
  initialize: function() {
    this.render();
  }
});
