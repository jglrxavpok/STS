# Level format
Levels are stored inside "scenes/maps/".

Each level has its own folder, and the folder name is used to identify the level inside the game code (called level ID).

## Files
- `thumbnail.png`: Thumbnail used for the level selection screen
- `name.txt`: Name displayed under the level inside the level selection screen, may be different from the level ID.
- `<level_id>.tscn`: scene representing the character. Replace `<level_id>` with your character id
