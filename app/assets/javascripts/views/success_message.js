var SuccessMessageView = Backbone.View.extend({
  className: "hurray",
  template: App.templates.success_message,
  events: {
    "click": "removeSuccessMessageWindow"
  },
  removeSuccessMessageWindow: function() {
    this.$el.remove();
  },
  fadeOutSuccessMessageWindow: function() {
    var self = this;

    setTimeout(function() {
      self.$el.fadeOut(500);
    }, 3000);
  },
  render: function() {
    this.$el.html(this.template({ message: this.attributes.message }));
    this.$el.appendTo($("body"));
  },
  initialize: function() {
    this.render();
    this.fadeOutSuccessMessageWindow();
  }
});
