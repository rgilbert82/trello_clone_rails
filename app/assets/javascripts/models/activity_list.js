var ActivityList = Backbone.Model.extend({
  setupActivityList: function() {
    var self = this;

    var boardActivity = App.activities.filter(function(act) {
      if (App.cards.get(act.get("card_id"))) {
        return self.get("board") === App.boards.get(App.lists.get(App.cards.get(act.get("card_id")).get("list_id")).get("board_id"));
      } else {
        return false;
      }
    });

    var menuActivity = boardActivity.map(function(act) {
      var activityObj = act.toJSON();
      var cardTitle = cardTitle = "<u>" + App.cards.get(activityObj.card_id).get("title") + "</u>";

      if (activityObj.description) {
        activityObj.description = activityObj.description.replace("this card", cardTitle);
      }
      activityObj.cardTitle = cardTitle;
      return activityObj;
    }).reverse();

    if (menuActivity.length > 0) {
      this.set({ "activity": menuActivity });
    }
  },
  initialize: function() {
    this.setupActivityList();
  }
});
