const path = require('path');
require('app-module-path').addPath(path.join(__dirname, '../../../../'));
require('coffeescript/register');
const expect = require('chai').expect;
const SDK = require('app/sdk');
const Logger = require('app/common/logger');
const UtilsSDK = require('../../utils/utils_sdk');

Logger.enabled = false;

describe('auto battle mode', () => {
  beforeEach(() => {
    const player1Deck = [
      { id: SDK.Cards.Faction1.General },
    ];
    const player2Deck = [
      { id: SDK.Cards.Faction2.General },
    ];
    UtilsSDK.setupSession(player1Deck, player2Deck, true, true);
    const gameSession = SDK.GameSession.getInstance();
    UtilsSDK.applyCardToBoard({ id: SDK.Cards.Neutral.Yun }, 1, 1, gameSession.getPlayer1Id());
    UtilsSDK.applyCardToBoard({ id: SDK.Cards.Neutral.Amu }, 1, 2, gameSession.getPlayer1Id());
    UtilsSDK.applyCardToBoard({ id: SDK.Cards.Neutral.DaggerKiri }, 1, 3, gameSession.getPlayer1Id());
    UtilsSDK.applyCardToBoard({ id: SDK.Cards.Neutral.Yun }, 7, 1, gameSession.getPlayer2Id());
    UtilsSDK.applyCardToBoard({ id: SDK.Cards.Neutral.Amu }, 7, 2, gameSession.getPlayer2Id());
    UtilsSDK.applyCardToBoard({ id: SDK.Cards.Neutral.DaggerKiri }, 7, 3, gameSession.getPlayer2Id());
  });

  afterEach(() => {
    SDK.GameSession.reset();
  });

  it('expect battle pets to act automatically at start of turn', () => {
    const gameSession = SDK.GameSession.getInstance();
    const board = gameSession.getBoard();
    gameSession.executeAction(gameSession.actionEndTurn());
    const oldPos = board.getUnitAtPosition({ x: 7, y: 1 });
    expect(oldPos).to.not.be.undefined;
  });
});
