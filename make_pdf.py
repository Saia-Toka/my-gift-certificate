import asyncio
from pathlib import Path
from pyppeteer import launch

async def main():
    browser = await launch(
        headless=True,
        args=['--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu', '--disable-dev-shm-usage', '--disable-software-rasterizer']
    )
    page = await browser.newPage()
    file_url = Path('site/index.html').resolve().as_uri()
    await page.goto(file_url, {'waitUntil': 'networkidle2'})
    await page.pdf({
        'path': 'site/certificate.pdf',
        'format': 'A4',
        'printBackground': True,
        'margin': {'top': '20mm', 'right': '15mm', 'bottom': '20mm', 'left': '15mm'},
    })
    await browser.close()

asyncio.run(main())
