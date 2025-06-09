// pragma PKGS: game
'use strict';

var DeckSelectSinglePlayerCompositeView = require('./deck_select_single_player');
var DeckSelectAutoBattleTmpl = require('app/ui/templates/composite/deck_select_auto_battle.hbs');
var EVENTS = require('app/common/event_types');

var DeckSelectAutoBattleCompositeView = DeckSelectSinglePlayerCompositeView.extend({
  className: 'sliding-panel-select deck-select deck-select-auto-battle',
  template: DeckSelectAutoBattleTmpl,

  getConfirmSelectionEvent: function () {
    return EVENTS.start_auto_battle;
  }
});

module.exports = DeckSelectAutoBattleCompositeView;
