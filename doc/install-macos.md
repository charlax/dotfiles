# macOS Installation Notes

## Rectangle (Window Manager)

Rectangle settings are applied via `defaults write` commands in `install/set-config-osx.sh`.

Run the settings script to configure Rectangle:

```bash
./install/set-config-osx.sh
```

If the defaults commands don't work, you can import the config manually:

1. Open Rectangle preferences
2. Go to the gear icon (Settings)
3. Click "Import" and select `rectangle/RectangleConfig.json`
