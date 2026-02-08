# Prayer Times CLI

A simple command-line tool to display Islamic prayer times. Perfect for use with status bars, Conky, Waybar, Polybar, or any other system monitor.

![Bash](https://img.shields.io/badge/bash-5.0%2B-green.svg)

## Features

- 🕌 Fetches prayer times from [Aladhan API](https://aladhan.com/prayer-times-api)
- ⏱️ Shows remaining time until next prayer
- 📊 Progress percentage (useful for visual indicators)
- 💾 Smart caching to minimize API calls
- 🔧 Easy integration with Conky, Polybar, Waybar, i3blocks, etc.
- 🌍 Supports any city worldwide

## Installation

### Quick Install

```bash
git clone https://github.com/moazizdev/prayer-times.git
cd prayer-times
./install.sh
```

### Manual Install

```bash
# Clone the repository
git clone https://github.com/moazizdev/prayer-times.git
cd prayer-times

# Copy binary to PATH
cp bin/prayer ~/.local/bin/

# Make it executable
chmod +x ~/.local/bin/prayer

# Ensure ~/.local/bin is in your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Dependencies

- `bash` (5.0+)
- `jq` - JSON processor
- `curl` - HTTP client

Install dependencies on Debian/Ubuntu:

```bash
sudo apt install jq curl
```

## Configuration

On first run, a default config is created at `~/.config/prayer-times/config.json`:

```json
{
    "city": "Cairo",
    "country": "Egypt",
    "method": 5,
    "fetch_every_minutes": 360
}
```

### Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `city` | Your city name | `Cairo` |
| `country` | Your country name | `Egypt` |
| `method` | Calculation method (see below) | `5` |
| `fetch_every_minutes` | How often to fetch from API | `360` |

### Calculation Methods

| Method | Name |
|--------|------|
| 0 | Jafari / Shia Ithna-Ashari |
| 1 | University of Islamic Sciences, Karachi |
| 2 | Islamic Society of North America (ISNA) |
| 3 | Muslim World League |
| 4 | Umm Al-Qura University, Makkah |
| 5 | Egyptian General Authority of Survey |
| 7 | Institute of Geophysics, University of Tehran |
| 8 | Gulf Region |
| 9 | Kuwait |
| 10 | Qatar |
| 11 | Majlis Ugama Islam Singapura |
| 12 | Union Organization Islamic de France |
| 13 | Diyanet İşleri Başkanlığı, Turkey |
| 14 | Spiritual Administration of Muslims of Russia |

## Usage

```bash
# Show next prayer and remaining time
prayer
# Output: Dhuhr in 2h 15m

# Show only the prayer name
prayer --name
# Output: Dhuhr

# Show progress (0-100)
prayer --progress
# Output: 45

# Show remaining time
prayer --remaining
# Output: 2h 15m

# Show next prayer time
prayer --time
# Output: 12:15

# Show all prayer times for today
prayer --all
# Output:
# Fajr:    04:52
# Dhuhr:   12:15
# Asr:     15:45
# Maghrib: 18:30
# Isha:    20:00

# Show full JSON output
prayer --json

# Force update from API
prayer --update

# Show current configuration
prayer --config

# Show help
prayer --help
```

## Integrations

### Conky

Add to your `.conkyrc`:

```lua
${execi 60 prayer}
${execi 60 prayer --name}: ${execi 60 prayer --remaining}
```

For a visual progress ring, see `examples/conky/` in this repository.

### Polybar

```ini
[module/prayer]
type = custom/script
exec = prayer
interval = 60
label = 🕌 %output%
```

### Waybar

```json
"custom/prayer": {
    "exec": "prayer",
    "interval": 60,
    "format": "🕌 {}"
}
```

### i3blocks

```ini
[prayer]
command=prayer
interval=60
label=🕌
```

### Cron (Auto-update)

To keep the cache fresh in the background:

```bash
crontab -e
```

Add:

```
* * * * * /home/yourusername/.local/bin/prayer --update > /dev/null 2>&1
```

## Cache Location

- Config: `~/.config/prayer-times/config.json`
- Cache: `~/.cache/prayer-times/`

## API

This tool uses the free [Aladhan Prayer Times API](https://aladhan.com/prayer-times-api).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Aladhan](https://aladhan.com/) for providing the free prayer times API
- The Muslim open-source community
