#!/usr/bin/env python3
"""Generate QR code for the website"""

import qrcode
import os

# Website URL
url = "https://sopel-przeprowadzki-site.netlify.app"

# Create QR code
qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=10,
    border=2,
)
qr.add_data(url)
qr.make(fit=True)

# Create image
img = qr.make_image(fill_color="black", back_color="white")

# Save to images folder
output_path = os.path.join(os.path.dirname(__file__), "images", "qr-code.png")
img.save(output_path)

print(f"✅ QR code created successfully!")
print(f"📍 Location: {output_path}")
print(f"🔗 URL: {url}")
print(f"📏 Size: {img.size[0]}x{img.size[1]} pixels")
