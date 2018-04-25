var Board = Backbone.Model.extend({
  defaults: {
    starred: false,
  },
  setLists: function() {
    this.set({"lists": new Lists() });
  },
  resetLists: function() {
    this.get("lists").reset(App.lists.where({"board_id": this.id}));
  },
  addList: function(model) {
    var newListPosition = model.get("position");

    this.reorderLists(newListPosition);
    this.get("lists").add(model);
  },
  reorderLists: function(newListPosition) {
    this.get("lists").each(function(list, index) {
      var position = index + 1;
      if (newListPosition && position >= newListPosition) {
        list.set({ "position": position + 1 });
      } else {
        list.set({ "position": position });
      }
    });
  },
  changePosition: function(obj) {
    var model = this.get("lists").remove(obj.id);

    model.set({ "position":obj.position });
    this.addList(model);
  },
  changeLists: function(model) {
    this.get("lists").remove(model);
    this.reorderLists();
    App.addListToBoard.call(App, model);
  },
  writeChanges: function() {
    this.save();
  },
  bindEvents: function() {
    this.listenTo(this, "change:starred", this.writeChanges.bind(this));
    this.listenTo(this, "change:title", this.writeChanges.bind(this));
    this.listenTo(this.get("lists"), "change:board_id", this.changeLists.bind(this));
  },
  initialize: function() {
    this.setLists();
    this.bindEvents();
  }
});
