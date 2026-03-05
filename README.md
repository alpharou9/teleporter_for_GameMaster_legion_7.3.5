# Legion Teleporter

A World of Warcraft addon for Game Masters on Legion 7.3.5 servers. Provides quick teleportation to all Legion dungeons, raids, and major cities.

## Features

- **Quick Access**: Simple UI with one-click teleportation
- **Cities**: Stormwind, Dalaran (Legion)
- **12 Legion Dungeons**: All mythic dungeons including Eye of Azshara, Black Rook Hold, Court of Stars, and more
- **5 Legion Raids**: Emerald Nightmare, Trial of Valor, Nighthold, Tomb of Sargeras, and Antorus

## Installation

1. Download or clone this repository
2. Copy the `LegionTeleporter` folder to your `World of Warcraft\Interface\AddOns\` directory
3. Restart WoW or type `/reload` in-game

## Usage

Open the teleporter with any of these commands:
- `/t` (primary command)
- `/lt`
- `/legiontp`

A minimap button is also available for quick access.

### Saving New Positions

To collect accurate coordinates for your server:

1. Fly to the dungeon/raid entrance
2. Type `/savepos <name>` (example: `/savepos Eye of Azshara`)
3. The addon will print the coordinates in a ready-to-paste format
4. Copy the printed line and add it to the `locations` table in `LegionTeleporter.lua`
5. Type `/listpos` to see all saved positions

This makes it easy to update coordinates or add new locations!

## Requirements

- World of Warcraft Legion 7.3.5
- GM permissions to use `.go xyz` commands

## Notes

All coordinates point to entrance locations (outside instances), not inside the actual dungeons/raids.

## Version

1.1.0 - Added position saving feature (`/savepos` and `/listpos` commands)
