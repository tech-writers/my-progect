
const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const SOURCE_DIR = path.resolve(__dirname, '../../bpmn-processes');
const TARGET_DIR = path.resolve(__dirname, '../components/apu/modules/bpmn/images');
const VIEWER_PATH = 'file://' + path.resolve(__dirname, 'viewer.html');

async function convertBpmnFile(browser, bpmnPath, svgPath) {
  const page = await browser.newPage();
  const xml = fs.readFileSync(bpmnPath, 'utf8');

  await page.goto(VIEWER_PATH);
  await page.evaluate((xml) => window.loadDiagram(xml), xml);
  await page.waitForFunction('window.isDiagramLoaded === true');

  const svg = await page.evaluate(() => window.getSVG());

  fs.mkdirSync(path.dirname(svgPath), { recursive: true });
  fs.writeFileSync(svgPath, svg);
  console.log(`✅ SVG сохранён: ${svgPath}`);

  // ➕ Преобразуем текст в кривые через Inkscape
  try {
    execSync(`inkscape "${svgPath}" --export-type=svg --export-plain-svg --export-text-to-path --export-filename="${svgPath}"`);
    console.log(`✒️  Текст преобразован в кривые (Inkscape)`);
  } catch (e) {
    console.warn(`⚠️  Не удалось запустить Inkscape для ${svgPath}`);
  }

  await page.close();
}

async function walkAndConvert(dir, baseDir, browser) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    const relPath = path.relative(baseDir, fullPath);

    if (entry.isDirectory()) {
      await walkAndConvert(fullPath, baseDir, browser);
    } else if (entry.isFile() && entry.name.endsWith('.bpmn')) {
      const svgPath = path.join(TARGET_DIR, relPath.replace(/\.bpmn$/, '.svg'));
      await convertBpmnFile(browser, fullPath, svgPath);
    }
  }
}

(async () => {
  console.log('🎨 Рендеринг BPMN → SVG с белым фоном и контурами текста...');
  const browser = await puppeteer.launch({ headless: "new" });

  await walkAndConvert(SOURCE_DIR, SOURCE_DIR, browser);

  await browser.close();
  console.log('✅ Все файлы обработаны.');
})();
