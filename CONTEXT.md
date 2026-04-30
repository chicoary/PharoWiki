# NAVAL BATTLE — Project Context
> Roblox game in pre-alpha. Read this file before every task.
> Last updated: 2026-03-31 | Version: 0.4.1

---

## Project Overview
2D multiplayer Battleship game for Roblox. Grid-based, paper-and-pen visual style (flat colored squares, no 3D models). Two players or Player vs Computer. Built entirely in Lua/Roblox.

---

## File Structure

| File | Location in Studio | Type |
|---|---|---|
| `GameServer.lua` | ServerScriptService | Script (server) |
| `GameClient.lua` | StarterPlayerScripts | LocalScript (client) |
| `NavalBattle_Tests.lua` | ServerScriptService | Script (keep Disabled=true in production) |
| Remote Events folder | ReplicatedStorage → `NavalBattleEvents` | Folder |

**No other scripts exist.** Do not create new scripts without being asked.

### NavalBattle_Tests.lua
Standalone test suite with its own mini test runner (describe/it/expect, no external deps).
Covers: Ship, Board, Fleet placement, processShot, fleetDamageState, confirmedWaterCells,
normalizeCode, all pure lobby handlers, handleFireShotAlternating, handleFireShotSimultaneous,
adaptive salvo edge cases, simultaneous mode (10 scenarios), integration tests.
**When adding new pure functions to GameServer, mirror them here and add tests before shipping.**
To run: set `Disabled = false` → Play → check Output → set `Disabled = true`.

---

## Grid & Board

- Size: **15 × 15** cells
- Cell visual size: 28px
- Coordinates: row (1–15), col (1–15)
- Column labels: A–O (letters), Row labels: 1–15 (numbers)
- Visual style: flat colored squares, paper-and-pen aesthetic, no 3D

---

## Fleet Definition

| Ship Type | Size (cells) | Count | Shape | Notes |
|---|---|---|---|---|
| Battleship | 5 | 1 | Linear horizontal | Standard |
| Cruiser | 4 | 2 | Linear horizontal | Standard |
| Destroyer | 2 | 3 | Linear horizontal | Standard |
| Submarine | 1 | 4 | Single cell | Intentionally futile — design choice |
| Seaplane | 3 | 5 | **Diagonal** `{0,0},{1,-1},{1,1}` | Only diagonal ship |

Total pieces on board: 1×5 + 2×4 + 3×2 + 4×1 + 5×3 = 30 pieces per player.

### Ship Colors (client)
```lua
SHIP_COLORS = {
    Battleship = RGB(180, 60,  60),
    Cruiser    = RGB(180, 120, 0),
    Destroyer  = RGB(0,   160, 80),
    Submarine  = RGB(120, 0,   180),
    Seaplane   = RGB(0,   160, 200),
}
```

### Ship Labels
`B` = Battleship, `C` = Cruiser, `D` = Destroyer, `S` = Submarine, `P` = Seaplane

---

## Architecture

### Server (GameServer.lua)
- Manages all game sessions (`sessions` table, keyed by NATO code)
- All game logic runs server-side (board, fleet, shots, turns)
- **Player Interface pattern**: `HumanPlayer` and `ComputerPlayer` share the same interface (`.Name`, `.UserId`, `.isComputer`, `:sendSyncBoard()`, `:sendShotResult()`, `:sendGameOver()`, `:isAlive()`)
- Pure functions for lobby logic: `handleJoinChallenge`, `handleRespondJoin`, `handleCancelChallenge`, `handlePauseRequest`, `handleResign`
- Pure functions for shot logic: `handleFireShotAlternating`, `handleFireShotSimultaneous`
- Trace system: `traceInit`, `trace`, `traceDump` — controlled by `TRACE_ENABLED` flag
- `DEBUG_FIXTURE` flag for rapid testing (1 sub per side, board pre-fired)

### Client (GameClient.lua)
- **State Machine (SM)**: `IDLE → LOBBY_HOST/LOBBY_GUEST → PLAYING → GAME_OVER → IDLE`
- All UI built programmatically (no Studio GUI objects)
- `screenConns` pattern: local event connections tracked and cleared on screen transitions
- Global handlers (never disconnected): `ESessionReady`, `ESyncBoard`, `EOpponentLeft`, `EJoinRequest`, `EGameOver`
- Color palette defined in `C` table

---

## Game Modes & Settings

| Setting | Options |
|---|---|
| Mode | Classic (no adjacency info) / Tactical (adjacency count shown) |
| Shot Mode | Single / Salvo ×3 |
| Turn Mode | Alternating / Simultaneous |
| Coordinates | Visible / Hidden |
| Assist Mode | Unassisted / Assisted (Tactical only — highlights confirmed water) |
| CPU Level | 0 (random) to 100 (cheats — picks ship cells directly) |

---

## Remote Events (all in `ReplicatedStorage/NavalBattleEvents`)

### Lobby
`CreateChallenge`, `JoinChallenge`, `SessionCreated`, `JoinRequest`, `RespondJoin`,
`JoinResult`, `JoinError`, `SessionReady`, `CancelChallenge`, `ChallengeCancelled`,
`OpponentLeft`, `PauseRequest`, `PauseNotify`, `Resign`, `ResignNotify`, `CreateVsComputer`

### Game
`FireShot` (C→S), `ShotResult` (S→C), `GameOver` (S→C), `SyncBoard` (S→C)

---

## Session Data Structure (server)
```lua
session = {
    code        = "NATO-Code",
    host        = Player,           -- Roblox Player object
    guest       = Player|CPU,       -- Roblox Player or ComputerPlayer
    hostPlayer  = HumanPlayer,      -- Player interface wrapper
    guestPlayer = HumanPlayer|ComputerPlayer,
    state       = "waiting|confirming|active|paused",
    gamePhase   = "lobby|playing|finished",
    settings    = { classicMode, salvoMode, turnMode, showLabels, assisted },
    turnMode    = "alternating|simultaneous",
    currentTurn = "host|guest",
    hostFleet   = { Ship, ... },
    guestFleet  = { Ship, ... },
    hostBoard   = Board,
    guestBoard  = Board,
    salvoQueue  = {},               -- simultaneous mode only
}
```

---

## Key Conventions

- **Never use FireAllClients** — always target specific players via Player Interface
- **Server owns all state** — client is purely visual, never trusts its own board state
- `myRole` on the client is `"host"` or `"guest"` — used to interpret ShotResult
- Salvo mode: client queues shots locally, sends all at once via `EFireShot {shots = {...}}`
- Adjacent cell count (0–8) shown as cell text in Tactical mode on miss
- `C.SAFE` color marks confirmed water cells in Assisted mode
- `C.PENDING` color marks queued-but-not-sent shots in Salvo mode
- `C.ADJ` (yellow) marks miss with adjacent ships in Tactical mode

---

## Current Status: v0.4.1 Pre-Alpha

### ✅ Implemented
- Full lobby system (create/join/cancel/accept/decline)
- VS Computer mode (CPU runs server-side with configurable level)
- Grid rendering + ship placement (random server-side)
- Shot system: alternating and simultaneous turn modes
- Salvo mode (×3 shots)
- Classic and Tactical modes (adjacency hints)
- Assisted mode (confirmed water highlighting)
- Fleet panels (visual damage state)
- Hit rate widgets (YOUR / OPP)
- Pause / Resume
- Resign
- Game Over screen
- State machine (client)
- Trace/debug system (server)
- DEBUG_FIXTURE for testing

### 🔲 Next: Result/Lobby Screen
The next feature to implement is the **end-of-match result screen and post-game lobby**, allowing players to see match summary and return to the main menu (or rematch flow if applicable).

---

## Do Not Touch (stable, do not refactor)
- `Ship` class and all its methods
- `Board` class and all its methods  
- `HumanPlayer` / `ComputerPlayer` interface
- State machine transitions table (`VALID_TRANSITIONS`)
- Global event handler registrations at the bottom of GameClient.lua
- `screenConns` / `trackScreen` / `clearScreenConns` pattern
- NATO code generation and normalization logic
