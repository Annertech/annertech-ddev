module.exports = async (page, scenario, vp) => {
  // 0. Hide the Cookiebot consent banner and other dynamic/admin elements.
  //    `removeSelectors` is unreliable because elements load asynchronously.
  //    Inject CSS so they stay hidden regardless of when they mount.
  if (!scenario.keepCookiebot) {
    await page.addStyleTag({
      content: `
        #CybotCookiebotDialog,
        #CybotCookiebotDialogBodyUnderlay,
        .anrt-gdpr-floating-cookie,
        #toolbar-administration,
        #toolbar-item-administration-tray,
        .toolbar-tray-open {
          display: none !important;
        }
      `,
    });
  }

  // 1. Kill all animations, transitions and smooth scrolling.
  //    Apply deterministic text rendering to prevent sub-pixel vertical jitter.
  await page.addStyleTag({
    content: `
      *, *::before, *::after {
        animation-duration: 0s !important;
        animation-delay: 0s !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0s !important;
        transition-delay: 0s !important;
        scroll-behavior: auto !important;
        caret-color: transparent !important;
      }
      body {
        -webkit-font-smoothing: antialiased !important;
        -moz-osx-font-smoothing: grayscale !important;
      }
      /* Force deterministic text rendering */
      * {
        text-rendering: geometricPrecision !important;
        -webkit-font-variant-ligatures: none !important;
        font-variant-ligatures: none !important;
        font-kerning: none !important;
      }
      @font-face {
        font-display: block !important;
      }
      html {
        overflow-y: scroll !important;
        -webkit-text-size-adjust: 100% !important;
      }
    `,
  });

  // 2. Wait for fonts to be ready.
  await page.evaluate(async () => {
    await document.fonts.ready;
  });

  // 3. Pause any autoplaying media (hero slideshow, video).
  await page.evaluate(() => {
    document.querySelectorAll('video, audio').forEach((m) => {
      try { m.pause(); } catch (e) {}
    });
  });

  // 4. Force lazy-loaded images to load by scrolling the full page height,
  //    then return to the top.
  await page.evaluate(async () => {
    await new Promise((resolve) => {
      let total = 0;
      const step = 400;
      const timer = setInterval(() => {
        window.scrollBy(0, step);
        total += step;
        if (total >= document.body.scrollHeight) {
          clearInterval(timer);
          window.scrollTo(0, 0);
          resolve();
        }
      }, 50);
    });
    // Promote native lazy images to eager and decode them.
    document.querySelectorAll('img[loading="lazy"]').forEach((img) => {
      img.loading = 'eager';
    });
  });

  // 5. Wait for every image (including background images) to finish loading.
  await page.evaluate(async () => {
    const decodeImage = (img) => {
      if (img.decode) {
        return img.decode().catch(() => {});
      }
      return Promise.resolve();
    };

    const waitForImage = (img) => {
      if (img.complete) {
        return decodeImage(img);
      }
      return new Promise((res) => {
        img.addEventListener('load', () => decodeImage(img).then(res));
        img.addEventListener('error', res);
      });
    };

    // Find all foreground images.
    const imgs = Array.from(document.images);
    
    // Find all background images by checking computed styles of all elements.
    const allElements = document.querySelectorAll('*');
    const bgImgs = [];
    allElements.forEach(el => {
      const bg = window.getComputedStyle(el).backgroundImage;
      if (bg && bg !== 'none') {
        const urlMatch = bg.match(/url\((['"]?)(.*?)\1\)/);
        if (urlMatch && urlMatch[2]) {
          const img = new Image();
          img.src = urlMatch[2];
          bgImgs.push(img);
        }
      }
    });

    await Promise.all([
      ...imgs.map(waitForImage),
      ...bgImgs.map(waitForImage)
    ]);
  });

  // 6. Wait for network and JS activity to settle.
  try {
    await page.waitForNetworkIdle({ idleTime: 500, timeout: 5000 });
  } catch (e) {}

  // 7. Settle.
  await new Promise((r) => setTimeout(r, 1000));
};
