// 火 - 交互式诗歌视觉装置（局部放大版）
// 鼠标滑过文字，周围两个字母范围放大并化为火焰飘散

PFont font;
String poemLines[];
ArrayList<WordParticle> particles;
float wordSize = 26;
float spacing = 1.5;
float charSpacing = 0.8;
boolean isPixelMode = true;

// 鼠标悬停检测的字符索引
int hoverIndex = -1;

void setup() {
  size(1000, 700);
  frameRate(30);
  
  font = createFont("Courier New", wordSize, true);
  textFont(font);
  textSize(wordSize);
  
  poemLines = new String[]{
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
  };
  
  particles = new ArrayList<WordParticle>();
  float y = 50;
  int globalIndex = 0;
  for (String line : poemLines) {
    if (line.trim().length() == 0) {
      y += wordSize * 0.4;
      continue;
    }
    float x = 40;
    for (int i = 0; i < line.length(); i++) {
      char c = line.charAt(i);
      if (c == ' ') {
        x += wordSize * 0.3;
        globalIndex++;
        continue;
      }
      WordParticle p = new WordParticle(c, x, y, wordSize, globalIndex);
      particles.add(p);
      x += textWidth(c) * charSpacing;
      globalIndex++;
    }
    y += wordSize * spacing;
  }
  
  if (isPixelMode) {
    noSmooth();
  }
}

void draw() {
  background(10, 8, 12);
  
  // 先检测鼠标悬停在哪个字符上（只检测未消失的字符）
  hoverIndex = -1;
  for (int i = particles.size() - 1; i >= 0; i--) {
    WordParticle p = particles.get(i);
    if (p.isGone) continue;
    
    float charWidth = textWidth(p.c) * charSpacing;
    float charHeight = p.size * 0.85;
    float left = p.x - charWidth/2;
    float right = p.x + charWidth/2;
    float top = p.y - charHeight/2;
    float bottom = p.y + charHeight/2;
    
    if (mouseX > left && mouseX < right && mouseY > top && mouseY < bottom) {
      hoverIndex = i;
      break;
    }
  }
  
  // 更新所有粒子
  for (int i = 0; i < particles.size(); i++) {
    WordParticle p = particles.get(i);
    // 判断是否在悬停字符周围两个字母范围内
    boolean inRange = false;
    if (hoverIndex >= 0) {
      int dist = Math.abs(i - hoverIndex);
      inRange = (dist <= 2 && dist > 0); // 周围两个字母
    }
    p.update(mouseX, mouseY, i == hoverIndex, inRange);
    p.display();
  }
  
  fill(60, 50, 70, 80);
  textSize(12);
  text("move mouse over words → surrounding 2 letters enlarge & become flame", 20, height - 30);
}

// ==================== 粒子类 ====================
class WordParticle {
  char c;
  float origX, origY;
  float x, y;
  float size;
  float targetSize;        // 目标字号（放大或正常）
  float vx, vy;
  float life;
  boolean isFlaming;
  boolean isGone;
  boolean isHovered;       // 是否是被悬停的字符
  boolean isNeighbor;      // 是否是周围两个字母
  float angle;
  float flameIntensity;
  color flameColor;
  int index;
  
  WordParticle(char c_, float x_, float y_, float s_, int idx_) {
    c = c_;
    origX = x_;
    origY = y_;
    x = x_;
    y = y_;
    size = s_;
    targetSize = s_;
    vx = 0;
    vy = 0;
    life = 1.0;
    isFlaming = false;
    isGone = false;
    isHovered = false;
    isNeighbor = false;
    angle = 0;
    flameIntensity = 0;
    flameColor = color(255, 120, 20);
    index = idx_;
  }
  
  void update(float mx, float my, boolean hovered, boolean neighbor) {
    if (isGone) return;
    
    isHovered = hovered;
    isNeighbor = neighbor;
    
    // 如果是被悬停的字符，触发火焰
    if (isHovered && !isFlaming) {
      isFlaming = true;
      life = 1.0;
      vx = random(-0.3, 0.3);    // 更小的飘散速度
      vy = random(-1.5, -0.8);
      angle = random(-0.08, 0.08);
      flameColor = color(
        200 + random(55), 
        80 + random(100), 
        10 + random(40)
      );
    }
    
    // 如果是周围两个字母，放大但不燃烧
    if (isNeighbor && !isFlaming && !isGone) {
      targetSize = size * 1.4;   // 放大1.4倍
    } else if (!isFlaming && !isGone) {
      targetSize = size;         // 恢复正常大小
    }
    
    // 平滑过渡到目标大小
    if (!isFlaming && !isGone) {
      size += (targetSize - size) * 0.12;
    }
    
    if (isFlaming) {
      // 飘散物理（更慢、更柔和）
      vx += random(-0.03, 0.03);
      vy += random(-0.04, 0.015);
      vy *= 0.995;
      vx *= 0.995;
      vx = constrain(vx, -2.0, 2.0);
      vy = constrain(vy, -3.0, 1.0);
      
      x += vx;
      y += vy;
      angle += random(-0.015, 0.015);
      
      life -= 0.006;
      if (life < 0) life = 0;
      
      flameIntensity = 0.6 + 0.4 * sin(frameCount * 0.1 + x * 0.05);
      
      if (life <= 0 || y < -50 || x < -50 || x > width + 50) {
        isGone = true;
        isFlaming = false;
        life = 0;
      }
    } else {
      // 未燃烧时固定在原始位置
      x += (origX - x) * 0.15;
      y += (origY - y) * 0.15;
      life = 1.0;
    }
  }
  
  void display() {
    if (isGone) return;
    
    pushMatrix();
    translate(x, y);
    rotate(angle);
    
    if (isFlaming && life > 0.01) {
      // ---- 火焰绘制 ----
      noStroke();
      // 发光光晕
      for (int r = 4; r > 0; r--) {
        float radius = r * 3.0;
        float alpha = 30 * (1 - r/4.0) * life * flameIntensity;
        fill(red(flameColor), green(flameColor)*0.6, 0, alpha);
        ellipse(0, 0, radius, radius * 1.3);
      }
      
      textAlign(CENTER, CENTER);
      
      float rCol = red(flameColor) * (0.7 + 0.3 * life);
      float gCol = green(flameColor) * (0.5 + 0.5 * life);
      float bCol = blue(flameColor) * (0.2 + 0.8 * life);
      
      // 外发光
      fill(rCol * 0.5, gCol * 0.2, 0, 50 * life * flameIntensity);
      textSize(size * 1.2);
      text(c, 0, 0);
      
      // 主文字
      fill(rCol, gCol, bCol, 255 * life);
      textSize(size);
      text(c, 0, 0);
      
      // 高光
      if (life > 0.4) {
        fill(255, 220, 120, 100 * life * flameIntensity);
        textSize(size * 0.7);
        text(c, -1, -1);
      }
      
      // 小火焰粒子
      for (int i = 0; i < 3; i++) {
        float angleOff = frameCount * 0.1 + i * 2.1;
        float dist = 5 + 3 * sin(frameCount * 0.15 + i);
        float fx = cos(angleOff + i) * dist;
        float fy = sin(angleOff * 0.7 + i) * dist - 2;
        fill(255, 150 + 50 * sin(frameCount * 0.2 + i), 20, 70 * life * flameIntensity);
        noStroke();
        ellipse(fx, fy, 2 + 2 * sin(frameCount * 0.1 + i), 2 + 2 * cos(frameCount * 0.12 + i));
      }
      
    } else if (isNeighbor && !isFlaming) {
      // ---- 放大的相邻字母（暖色高亮） ----
      textAlign(CENTER, CENTER);
      fill(255, 180, 80, 200);  // 暖金色
      if (isPixelMode) {
        int px = round(x);
        int py = round(y);
        pushMatrix();
        translate(px - x, py - y);
        text(c, 0, 0);
        popMatrix();
      } else {
        text(c, 0, 0);
      }
      
    } else {
      // ---- 静态文字 ----
      textAlign(CENTER, CENTER);
      fill(200, 195, 205, 220);
      if (isPixelMode) {
        int px = round(x);
        int py = round(y);
        pushMatrix();
        translate(px - x, py - y);
        text(c, 0, 0);
        popMatrix();
      } else {
        text(c, 0, 0);
      }
    }
    
    popMatrix();
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    for (WordParticle p : particles) {
      p.isGone = false;
      p.isFlaming = false;
      p.x = p.origX;
      p.y = p.origY;
      p.life = 1.0;
      p.vx = 0;
      p.vy = 0;
      p.angle = 0;
    }
  }
  if (key == 'p' || key == 'P') {
    isPixelMode = !isPixelMode;
    if (isPixelMode) {
      noSmooth();
    } else {
      smooth();
    }
  }
}
