from datetime import datetime
import pytz
from tzlocal import get_localzone

# Ambil zona waktu lokal dari sistem
local_tz = get_localzone()

# Ambil waktu lokal saat ini
local_time = datetime.now(local_tz)

print("Waktu lokal:", local_time)
