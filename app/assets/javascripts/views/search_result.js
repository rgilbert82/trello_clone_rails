var SearchResultView = Backbone.View.extend({
  className: "search_result",
  template: App.templates.search_result,
  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.$el.appendTo($("#search_results_list"));
  },
  initialize: function() {
    this.render();
  }
});
