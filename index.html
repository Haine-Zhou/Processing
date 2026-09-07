<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
  <style>
    body { margin: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background: #0a080c; }
    canvas { display: block; border-radius: 8px; box-shadow: 0 0 40px rgba(200, 80, 20, 0.15); }
  </style>
</head>
<body>
<script>
// ============================================================
// 火 · 交互诗歌 · p5.js 版
// 鼠标滑过 → 周围两字母放大 + 正中字符化为火焰飘散并消失
// ============================================================

let particles = [];
let poemLines = [];
let hoverIndex = -1;

const WORD_SIZE = 26;
const LINE_SPACING = 1.5;
const CHAR_SPACING = 0.8;
const NEIGHBOR_RADIUS = 2;   // 周围字母数量（左右各 N 个）
const FLAME_SPEED = 0.6;     // 飘散速度系数

let fontRegular;
let isPixelMode = true;

function preload() {
  // 使用系统等宽字体（像素感）
  fontRegular = loadFont('https://cdnjs.cloudflare.com/ajax/libs/processing.js/1.4.8/fonts/OCRAStd-24.vlw');
}

function setup() {
  createCanvas(1000, 700);
  textFont(fontRegular);
  textSize(WORD_SIZE);
  textAlign(CENTER, CENTER);
  
  // ---- 诗歌内容 ----
  poemLines = [
    "I dreamt of falling into an incinerator for ghost money,",
    "writhing in the karmic flames that lead to hell.",
    "I admired the naked, leaping fire, until my sight grew hazy and blurred.",
    "Something inside me seemed to be seeping out,",
    "but my senses had long ceased to function—",
    "replaced instead by an unending agony.",
    "Charred fat fused with the outer fabric of my coat;",
    "the slightest move sent a piercing torment through me...",
    "",
    "The fire rose higher.",
    "I wanted to paint flames assaulting the sky, a wild blaze sweeping the plains...",
    "",
    "This is what you said:",
    "that I would one day find inspiration within myself.",
    "",
    "The cold blade slowly parted the skin at my wrist,",
    "baring the yellow layer of fat beneath—",
    "the wound blooming like a vivid camellia.",
    "I was utterly transfixed; for a moment, I felt no pain.",
    "Droplets fell onto the paper, red and radiant.",
    "",
    "But this was not the colour of fire—",
    "it was something more alive.",
    "I picked up the bristle brush and tried to spread that red across the sheet,",
    "yet its pigment was far too poor, wholly unusable as dye.",
    "",
    "So the romance of 'painting in blood' is merely an artist's delusion, after all.",
    "",
    "I came to myself—another vision from the past.",
    "And yet the sickening tang of rust and the cloying sweetness of labdanum,",
    "clinging to my nostrils, felt utterly, unbearably real."
  ];
  
  // ---- 构建粒子 ----
  let y = 50;
  let globalIdx = 0;
  for (let line of poemLines) {
    if (line.trim().length === 0) {
      y += WORD_SIZE * 0.4;
      continue;
    }
    let x = 40;
    for (let i = 0; i < line.length; i++) {
      let c = line.charAt(i);
      if (c === ' ') {
        x += WORD_SIZE * 0.3;
        globalIdx++;
        continue;
      }
      let p = new WordParticle(c, x, y, WORD_SIZE, globalIdx);
      particles.push(p);
      let charW = textWidth(c) * CHAR_SPACING;
      x += charW;
      globalIdx++;
    }
    y += WORD_SIZE * LINE_SPACING;
  }
  
  // 像素风格
  if (isPixelMode) {
    pixelDensity(1);
    noSmooth();
  }
}

function draw() {
  background(10, 8, 12);
  
  // ---- 检测鼠标悬停的字符 ----
  hoverIndex = -1;
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    if (p.isGone) continue;
    let charW = textWidth(p.c) * CHAR_SPACING;
    let charH = p.size * 0.85;
    let left = p.x - charW / 2;
    let right = p.x + charW / 2;
    let top = p.y - charH / 2;
    let bottom = p.y + charH / 2;
    if (mouseX > left && mouseX < right && mouseY > top && mouseY < bottom) {
      hoverIndex = i;
      break;
    }
  }
  
  // ---- 更新所有粒子 ----
  for (let i = 0; i < particles.length; i++) {
    let p = particles[i];
    let inRange = false;
    if (hoverIndex >= 0) {
      let dist = Math.abs(i - hoverIndex);
      inRange = (dist <= NEIGHBOR_RADIUS && dist > 0);
    }
    let isHovered = (i === hoverIndex);
    p.update(isHovered, inRange);
    p.display();
  }
  
  // ---- 提示 ----
  noStroke();
  fill(60, 50, 70, 80);
  textSize(12);
  textAlign(LEFT, BOTTOM);
  text("hover → surrounding 2 letters enlarge · center burns away · [R] reset  [P] pixel", 20, height - 20);
}

// ============================================================
//  WordParticle 类
// ============================================================
class WordParticle {
  constructor(c, x, y, size, idx) {
    this.c = c;
    this.origX = x;
    this.origY = y;
    this.x = x;
    this.y = y;
    this.size = size;
    this.origSize = size;
    this.targetSize = size;
    this.idx = idx;
    
    this.vx = 0;
    this.vy = 0;
    this.life = 1.0;
    this.angle = 0;
    this.flameIntensity = 0;
    
    this.isFlaming = false;
    this.isGone = false;
    this.isHovered = false;
    this.isNeighbor = false;
    
    this.flameColor = [255, 120, 20];
  }
  
  // ----------------------------------------------------------
  update(hovered, neighbor) {
    if (this.isGone) return;
    
    this.isHovered = hovered;
    this.isNeighbor = neighbor;
    
    // ---- 触发火焰（仅当被悬停且未燃烧） ----
    if (this.isHovered && !this.isFlaming) {
      this.isFlaming = true;
      this.life = 1.0;
      this.vx = random(-0.3, 0.3) * FLAME_SPEED;
      this.vy = random(-1.8, -1.0) * FLAME_SPEED;
      this.angle = random(-0.08, 0.08);
      this.flameColor = [
        200 + random(55),
        80 + random(100),
        10 + random(40)
      ];
    }
    
    // ---- 相邻字母放大 ----
    if (this.isNeighbor && !this.isFlaming && !this.isGone) {
      this.targetSize = this.origSize * 1.4;
    } else if (!this.isFlaming && !this.isGone) {
      this.targetSize = this.origSize;
    }
    
    // 平滑尺寸过渡
    if (!this.isFlaming && !this.isGone) {
      this.size += (this.targetSize - this.size) * 0.12;
    }
    
    // ---- 燃烧物理 ----
    if (this.isFlaming) {
      this.vx += random(-0.03, 0.03) * FLAME_SPEED;
      this.vy += random(-0.04, 0.015) * FLAME_SPEED;
      this.vy *= 0.995;
      this.vx *= 0.995;
      this.vx = constrain(this.vx, -2.0, 2.0);
      this.vy = constrain(this.vy, -3.2, 1.0);
      
      this.x += this.vx;
      this.y += this.vy;
      this.angle += random(-0.015, 0.015);
      
      this.life -= 0.006;
      if (this.life < 0) this.life = 0;
      
      this.flameIntensity = 0.6 + 0.4 * sin(frameCount * 0.1 + this.x * 0.05);
      
      // 彻底消失
      if (this.life <= 0 || this.y < -50 || this.x < -50 || this.x > width + 50) {
        this.isGone = true;
        this.isFlaming = false;
        this.life = 0;
      }
    } else {
      // 未燃烧时锚定回原位
      this.x += (this.origX - this.x) * 0.15;
      this.y += (this.origY - this.y) * 0.15;
      this.life = 1.0;
    }
  }
  
  // ----------------------------------------------------------
  display() {
    if (this.isGone) return;
    
    push();
    translate(this.x, this.y);
    rotate(this.angle);
    
    // ---- 燃烧状态 ----
    if (this.isFlaming && this.life > 0.01) {
      noStroke();
      // 光晕
      for (let r = 4; r > 0; r--) {
        let radius = r * 3.0;
        let alpha = 30 * (1 - r / 4.0) * this.life * this.flameIntensity;
        fill(this.flameColor[0], this.flameColor[1] * 0.6, 0, alpha);
        ellipse(0, 0, radius, radius * 1.3);
      }
      
      let rCol = this.flameColor[0] * (0.7 + 0.3 * this.life);
      let gCol = this.flameColor[1] * (0.5 + 0.5 * this.life);
      let bCol = this.flameColor[2] * (0.2 + 0.8 * this.life);
      
      // 外发光文字
      fill(rCol * 0.5, gCol * 0.2, 0, 50 * this.life * this.flameIntensity);
      textSize(this.size * 1.2);
      text(this.c, 0, 0);
      
      // 主文字
      fill(rCol, gCol, bCol, 255 * this.life);
      textSize(this.size);
      text(this.c, 0, 0);
      
      // 高光
      if (this.life > 0.4) {
        fill(255, 220, 120, 100 * this.life * this.flameIntensity);
        textSize(this.size * 0.7);
        text(this.c, -1, -1);
      }
      
      // 小火焰粒子
      for (let i = 0; i < 3; i++) {
        let aOff = frameCount * 0.1 + i * 2.1;
        let dist = 5 + 3 * sin(frameCount * 0.15 + i);
        let fx = cos(aOff + i) * dist;
        let fy = sin(aOff * 0.7 + i) * dist - 2;
        fill(255, 150 + 50 * sin(frameCount * 0.2 + i), 20, 70 * this.life * this.flameIntensity);
        noStroke();
        ellipse(fx, fy, 2 + 2 * sin(frameCount * 0.1 + i), 2 + 2 * cos(frameCount * 0.12 + i));
      }
    }
    // ---- 相邻放大（暖色高亮） ----
    else if (this.isNeighbor && !this.isFlaming) {
      fill(255, 180, 80, 200);
      if (isPixelMode) {
        let px = round(this.x);
        let py = round(this.y);
        push();
        translate(px - this.x, py - this.y);
        text(this.c, 0, 0);
        pop();
      } else {
        text(this.c, 0, 0);
      }
    }
    // ---- 静态文字 ----
    else {
      fill(200, 195, 205, 220);
      if (isPixelMode) {
        let px = round(this.x);
        let py = round(this.y);
        push();
        translate(px - this.x, py - this.y);
        text(this.c, 0, 0);
        pop();
      } else {
        text(this.c, 0, 0);
      }
    }
    
    pop();
  }
}

// ============================================================
//  键盘交互
// ============================================================
function keyPressed() {
  // R 重置
  if (key === 'r' || key === 'R') {
    for (let p of particles) {
      p.isGone = false;
      p.isFlaming = false;
      p.x = p.origX;
      p.y = p.origY;
      p.size = p.origSize;
      p.life = 1.0;
      p.vx = 0;
      p.vy = 0;
      p.angle = 0;
    }
  }
  // P 切换像素风格
  if (key === 'p' || key === 'P') {
    isPixelMode = !isPixelMode;
    if (isPixelMode) {
      pixelDensity(1);
      noSmooth();
    } else {
      pixelDensity(1);
      smooth();
    }
  }
}

function windowResized() {
  // resizeCanvas(windowWidth, windowHeight);
}
</script>
</body>
</html>
