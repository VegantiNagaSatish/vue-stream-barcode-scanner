<template>
  <div class="app">
    <!-- Hero Section -->
    <header class="hero">
      <div class="container">
        <div class="hero-content fade-in">
          <div class="logo">📸</div>
          <h1 class="title">Vue Stream Barcode Scanner</h1>
          <p class="subtitle">
            High-performance, real-time barcode scanning for Vue 3 applications
          </p>
          <div class="hero-buttons">
            <button class="btn btn-primary btn-large" @click="startScanner">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                <path d="M3 7v4m0 6v4m18-14v4m0 6v4M7 3h4m6 0h4M7 21h4m6 0h4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                <rect x="9" y="9" width="6" height="6" rx="1" stroke="currentColor" stroke-width="2"/>
              </svg>
              Start Demo Scanner
            </button>
            <a href="https://github.com/VegantiNagaSatish/vue-stream-barcode-scanner" target="_blank" class="btn btn-secondary btn-large" style="text-decoration: none;">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
              </svg>
              View on GitHub
            </a>
          </div>
        </div>
      </div>
    </header>

    <!-- Features Section -->
    <section class="features">
      <div class="container">
        <h2 class="section-title">Features</h2>
        <div class="features-grid">
          <div class="feature-card card">
            <div class="feature-icon">🎥</div>
            <h3>Real-time Streaming</h3>
            <p>Scan barcodes directly from camera feed with optimized performance</p>
          </div>
          <div class="feature-card card">
            <div class="feature-icon">🔦</div>
            <h3>Torch Control</h3>
            <p>Built-in flashlight toggle for scanning in low-light conditions</p>
          </div>
          <div class="feature-card card">
            <div class="feature-icon">📱</div>
            <h3>Mobile First</h3>
            <p>Responsive design optimized for mobile and tablet devices</p>
          </div>
          <div class="feature-card card">
            <div class="feature-icon">🎯</div>
            <h3>Smart Focus</h3>
            <p>Intelligent scan region with visual guides for better accuracy</p>
          </div>
          <div class="feature-card card">
            <div class="feature-icon">⚡</div>
            <h3>High Performance</h3>
            <p>Configurable scan intervals and optimized decoding algorithms</p>
          </div>
          <div class="feature-card card">
            <div class="feature-icon">🔧</div>
            <h3>Customizable</h3>
            <p>Extensive props, events, and slots for complete control</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Results Section -->
    <section class="results" v-if="scannedResults.length > 0">
      <div class="container">
        <div class="card">
          <h2 class="section-title">Scanned Results</h2>
          <div class="results-list">
            <div v-for="(result, index) in scannedResults" :key="index" class="result-item">
              <div class="result-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                  <path d="M20 6L9 17l-5-5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="result-content">
                <div class="result-code">{{ result.code }}</div>
                <div class="result-time">{{ result.time }}</div>
              </div>
              <button class="btn-copy" @click="copyToClipboard(result.code)" :title="copiedIndex === index ? 'Copied!' : 'Copy'">
                <svg v-if="copiedIndex !== index" width="20" height="20" viewBox="0 0 24 24" fill="none">
                  <rect x="9" y="9" width="13" height="13" rx="2" stroke="currentColor" stroke-width="2"/>
                  <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1" stroke="currentColor" stroke-width="2"/>
                </svg>
                <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="none">
                  <path d="M20 6L9 17l-5-5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
              </button>
            </div>
          </div>
          <button class="btn btn-secondary" @click="clearResults" style="margin-top: 16px;">
            Clear Results
          </button>
        </div>
      </div>
    </section>

    <!-- Usage Example Section -->
    <section class="usage">
      <div class="container">
        <h2 class="section-title">Quick Start</h2>
        <div class="card">
          <h3 style="margin-bottom: 16px; color: var(--primary);">Installation</h3>
          <pre><code>npm install vue-stream-barcode-scanner</code></pre>
          
          <h3 style="margin: 24px 0 16px; color: var(--primary);">Basic Usage</h3>
          <pre><code>&lt;template&gt;
  &lt;div&gt;
    &lt;button @click="showScanner = true"&gt;Start Scanner&lt;/button&gt;
    
    &lt;StreamBarcodeScanner
      v-if="showScanner"
      @decoded="onBarcodeDetected"
      @close="showScanner = false"
    /&gt;
  &lt;/div&gt;
&lt;/template&gt;

&lt;script setup&gt;
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

const showScanner = ref(false);

const onBarcodeDetected = (result) => {
  console.log('Barcode:', result);
  showScanner.value = false;
};
&lt;/script&gt;</code></pre>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
      <div class="container">
        <p>Made with ❤️ for the Vue.js community</p>
        <p style="margin-top: 8px; opacity: 0.7; font-size: 14px;">
          Powered by <a href="https://github.com/zxing-js/library" target="_blank" style="color: var(--primary);">ZXing</a>
        </p>
      </div>
    </footer>

    <!-- Scanner Component -->
    <StreamBarcodeScanner
      v-if="showScanner"
      :torch="torchEnabled"
      @decoded="handleBarcodeScan"
      @close="closeScanner"
      @error="handleError"
    >
      <template #footer>
        <button class="scanner-button" @click="toggleTorch">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
            <path d="M9 2h6l3 4v4a5 5 0 01-5 5 5 5 0 01-5-5V6l3-4z" :fill="torchEnabled ? 'currentColor' : 'none'" stroke="currentColor" stroke-width="2"/>
            <path d="M12 15v7" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
          </svg>
          {{ torchEnabled ? 'Flash On' : 'Flash Off' }}
        </button>
      </template>
    </StreamBarcodeScanner>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from './components/StreamBarcodeScanner.vue';

const showScanner = ref(false);
const torchEnabled = ref(false);
const scannedResults = ref([]);
const copiedIndex = ref(-1);

const startScanner = () => {
  showScanner.value = true;
};

const closeScanner = () => {
  showScanner.value = false;
  torchEnabled.value = false;
};

const handleBarcodeScan = (barcode) => {
  const now = new Date();
  scannedResults.value.unshift({
    code: barcode,
    time: now.toLocaleTimeString(),
    timestamp: now.getTime()
  });
  
  // Keep only last 10 results
  if (scannedResults.value.length > 10) {
    scannedResults.value = scannedResults.value.slice(0, 10);
  }
  
  closeScanner();
};

const toggleTorch = () => {
  torchEnabled.value = !torchEnabled.value;
};

const handleError = (error) => {
  console.error('Scanner error:', error);
  alert('Camera error: ' + error.message);
};

const clearResults = () => {
  scannedResults.value = [];
};

const copyToClipboard = async (text) => {
  try {
    await navigator.clipboard.writeText(text);
    const index = scannedResults.value.findIndex(r => r.code === text);
    copiedIndex.value = index;
    setTimeout(() => {
      copiedIndex.value = -1;
    }, 2000);
  } catch (err) {
    console.error('Failed to copy:', err);
  }
};
</script>

<style scoped>
.app {
  min-height: 100vh;
}

/* Hero Section */
.hero {
  padding: 80px 20px;
  text-align: center;
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.1) 0%, rgba(147, 51, 234, 0.1) 100%);
  border-bottom: 1px solid var(--border);
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
}

.logo {
  font-size: 80px;
  margin-bottom: 24px;
  animation: pulse 2s infinite;
}

.title {
  font-size: 48px;
  font-weight: 800;
  margin-bottom: 16px;
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle {
  font-size: 20px;
  color: var(--text-secondary);
  margin-bottom: 32px;
  line-height: 1.6;
}

.hero-buttons {
  display: flex;
  gap: 16px;
  justify-content: center;
  flex-wrap: wrap;
}

/* Features Section */
.features {
  padding: 80px 20px;
}

.section-title {
  font-size: 36px;
  font-weight: 700;
  text-align: center;
  margin-bottom: 48px;
  color: var(--text-primary);
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
  max-width: 1200px;
  margin: 0 auto;
}

.feature-card {
  text-align: center;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.feature-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px var(--shadow);
}

.feature-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.feature-card h3 {
  font-size: 20px;
  margin-bottom: 12px;
  color: var(--text-primary);
}

.feature-card p {
  color: var(--text-secondary);
  line-height: 1.6;
}

/* Results Section */
.results {
  padding: 40px 20px;
}

.results-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.result-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  background: var(--background);
  border-radius: 8px;
  border: 1px solid var(--border);
  animation: slideIn 0.3s ease;
}

.result-icon {
  color: var(--success);
  flex-shrink: 0;
}

.result-content {
  flex: 1;
  min-width: 0;
}

.result-code {
  font-size: 18px;
  font-weight: 600;
  font-family: 'Monaco', 'Courier New', monospace;
  color: var(--primary);
  word-break: break-all;
}

.result-time {
  font-size: 14px;
  color: var(--text-secondary);
  margin-top: 4px;
}

.btn-copy {
  background: transparent;
  border: 1px solid var(--border);
  color: var(--text-secondary);
  padding: 8px;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.btn-copy:hover {
  background: var(--surface-light);
  color: var(--text-primary);
}

/* Usage Section */
.usage {
  padding: 40px 20px 80px;
}

/* Footer */
.footer {
  padding: 40px 20px;
  text-align: center;
  border-top: 1px solid var(--border);
  color: var(--text-secondary);
}

/* Scanner Custom Button */
.scanner-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 24px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 64px;
  font-weight: 600;
  backdrop-filter: blur(10px);
}

.scanner-button:hover {
  background: rgba(0, 0, 0, 0.8);
}

/* Responsive */
@media (max-width: 768px) {
  .title {
    font-size: 36px;
  }
  
  .subtitle {
    font-size: 18px;
  }
  
  .hero-buttons {
    flex-direction: column;
  }
  
  .section-title {
    font-size: 28px;
  }
  
  .features-grid {
    grid-template-columns: 1fr;
  }
}
</style>

