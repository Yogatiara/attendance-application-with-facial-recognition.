from datetime import datetime
import pytz
from tzlocal import get_localzone

# Ambil zona waktu lokal dari sistem
local_tz = get_localzone()

# Ambil waktu lokal saat ini
local_time = datetime.now(local_tz)

# Ambil tanggal dalam format YYYY-MM-DD
current_date = local_time.strftime("%d %b %Y")

print("Tanggal lokal:", current_date)
