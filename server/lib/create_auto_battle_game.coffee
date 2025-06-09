moment = require 'moment'
Promise = require 'bluebird'
{GameManager} = require '../redis/'
CONFIG = require '../../app/common/config'
Logger = require '../../app/common/logger'
config = require '../../config/config'
{version} = require '../../version'

GameSetup = require '../../app/sdk/gameSetup'
GameType = require '../../app/sdk/gameType'
GameStatus = require '../../app/sdk/gameStatus'
GameSession = require '../../app/sdk/gameSession'
GameFormat = require '../../app/sdk/gameFormat'
Cards = require '../../app/sdk/cards/cardsLookupComplete'
GamesModule = require './data_access/games'

createAutoBattleGame = (userId)->
  player1Deck = [
    {id: Cards.Faction1.General}
  ]
  player2Deck = [
    {id: Cards.Faction2.General}
  ]

  player1Board = [
    {id: Cards.Neutral.Yun, position:{x:1, y:1}},
    {id: Cards.Neutral.Amu, position:{x:1, y:2}},
    {id: Cards.Neutral.DaggerKiri, position:{x:1, y:3}}
  ]
  player2Board = [
    {id: Cards.Neutral.Yun, position:{x:7, y:1}},
    {id: Cards.Neutral.Amu, position:{x:7, y:2}},
    {id: Cards.Neutral.DaggerKiri, position:{x:7, y:3}}
  ]

  player1DataForGame =
    userId: userId
    name: "You"
    deck: player1Deck
    startingBoardCardsData: player1Board

  player2DataForGame =
    userId: CONFIG.AI_PLAYER_ID
    name: "Opponent"
    deck: player2Deck
    startingBoardCardsData: player2Board

  withoutManaTiles = true

  newGameSession = GameSession.create()
  newGameSession.gameType = GameType.AutoBattle
  newGameSession.gameFormat = GameFormat.Legacy
  newGameSession.version = version
  newGameSession.setIsRunningAsAuthoritative(true)
  GameSetup.setupNewSession(newGameSession, player1DataForGame, player2DataForGame, withoutManaTiles)
  newGameSession.setAiPlayerId(CONFIG.AI_PLAYER_ID)
  newGameSession.setAiDifficulty(0)

  GameManager.generateGameId()
  .then (gameId) ->
    newGameSession.gameId = gameId
    GameManager.saveGameSession(gameId, newGameSession.serializeToJSON(newGameSession))
    .then ->
      createdDate = moment().utc().valueOf()
      newGameSession.createdAt = createdDate
      gameData =
        game_type: GameType.AutoBattle
        game_id: gameId
        is_player_1: true
        opponent_username: "Opponent"
        opponent_id: CONFIG.AI_PLAYER_ID
        opponent_faction_id: player2DataForGame.deck[0].id
        opponent_general_id: newGameSession.getGeneralForPlayer2().getId()
        status: GameStatus.active
        created_at: createdDate
        faction_id: player1DataForGame.deck[0].id
        general_id: newGameSession.getGeneralForPlayer1().getId()
        game_version: version

      GamesModule.newUserGame(userId, gameId, gameData)
      .then -> gameData

module.exports = createAutoBattleGame
