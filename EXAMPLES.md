# Usage Examples

## Table of Contents
- [Basic Usage](#basic-usage)
- [With Options API](#with-options-api)
- [Custom Styling](#custom-styling)
- [With Torch Control](#with-torch-control)
- [Custom Instructions](#custom-instructions)
- [Multiple Scanners](#multiple-scanners)
- [With Manual Input Fallback](#with-manual-input-fallback)
- [Filtering Barcode Formats](#filtering-barcode-formats)
- [Full Featured Example](#full-featured-example)

---

## Basic Usage

The simplest way to use the scanner:

```vue
<template>
  <div>
    <button @click="showScanner = true">Scan Barcode</button>
    
    <StreamBarcodeScanner
      v-if="showScanner"
      @decoded="handleScan"
      @close="showScanner = false"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

const showScanner = ref(false);

const handleScan = (barcode) => {
  console.log('Scanned:', barcode);
  showScanner.value = false;
};
</script>
```

---

## With Options API

Using the component with Vue's Options API:

```vue
<template>
  <div>
    <button @click="startScan">Open Scanner</button>
    
    <StreamBarcodeScanner
      v-if="isScanning"
      @decoded="onBarcodeScanned"
      @close="closeScanner"
    />
    
    <div v-if="lastBarcode">
      Last scanned: {{ lastBarcode }}
    </div>
  </div>
</template>

<script>
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

export default {
  components: {
    StreamBarcodeScanner
  },
  data() {
    return {
      isScanning: false,
      lastBarcode: null
    };
  },
  methods: {
    startScan() {
      this.isScanning = true;
    },
    closeScanner() {
      this.isScanning = false;
    },
    onBarcodeScanned(barcode) {
      this.lastBarcode = barcode;
      this.closeScanner();
      // Process barcode...
    }
  }
};
</script>
```

---

## Custom Styling

Customizing the scanner with slots:

```vue
<template>
  <StreamBarcodeScanner
    v-if="showScanner"
    instruction-text="Scan product barcode"
    @decoded="handleScan"
    @close="showScanner = false"
  >
    <template #header>
      <div class="custom-header">
        <h2>Product Scanner</h2>
      </div>
    </template>
    
    <template #footer>
      <div class="custom-footer">
        <button @click="openManualInput">Enter Manually</button>
        <button @click="showHelp">Need Help?</button>
      </div>
    </template>
  </StreamBarcodeScanner>
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

const showScanner = ref(false);

const handleScan = (barcode) => {
  console.log('Product:', barcode);
};

const openManualInput = () => {
  // Show manual input modal
};

const showHelp = () => {
  // Show help dialog
};
</script>

<style scoped>
.custom-header {
  text-align: center;
  color: white;
}

.custom-footer {
  display: flex;
  gap: 12px;
}

.custom-footer button {
  flex: 1;
  padding: 12px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 8px;
  font-weight: 600;
}
</style>
```

---

## With Torch Control

Adding flashlight toggle functionality:

```vue
<template>
  <div>
    <button @click="startScanning">Start Scanner</button>
    
    <StreamBarcodeScanner
      v-if="scanning"
      :torch="torchOn"
      @decoded="handleBarcode"
      @close="stopScanning"
      @error="handleError"
    >
      <template #footer>
        <button @click="toggleTorch" class="torch-button">
          <span v-if="!torchOn">🔦 Turn On Flash</span>
          <span v-else>💡 Turn Off Flash</span>
        </button>
      </template>
    </StreamBarcodeScanner>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

const scanning = ref(false);
const torchOn = ref(false);

const startScanning = () => {
  scanning.value = true;
};

const stopScanning = () => {
  scanning.value = false;
  torchOn.value = false;
};

const toggleTorch = () => {
  torchOn.value = !torchOn.value;
};

const handleBarcode = (code) => {
  console.log('Scanned:', code);
  stopScanning();
};

const handleError = (error) => {
  console.error('Scanner error:', error);
  alert('Camera error: ' + error.message);
};
</script>

<style scoped>
.torch-button {
  padding: 12px 24px;
  background: rgba(0, 0, 0, 0.8);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 24px;
  font-weight: 600;
  cursor: pointer;
}
</style>
```

---

## Custom Instructions

Providing custom scan instructions:

```vue
<template>
  <StreamBarcodeScanner
    v-if="showScanner"
    @decoded="handleScan"
    @close="showScanner = false"
  >
    <template #instructions>
      <div class="custom-instructions">
        <h3>📦 Scan Product Barcode</h3>
        <p>Position the barcode within the frame</p>
        <ul>
          <li>Ensure good lighting</li>
          <li>Hold device steady</li>
          <li>Keep barcode flat</li>
        </ul>
      </div>
    </template>
  </StreamBarcodeScanner>
</template>

<style scoped>
.custom-instructions {
  background: rgba(0, 0, 0, 0.8);
  padding: 20px;
  border-radius: 12px;
  color: white;
  max-width: 400px;
  text-align: center;
}

.custom-instructions h3 {
  margin-bottom: 12px;
  font-size: 20px;
}

.custom-instructions p {
  margin-bottom: 12px;
  opacity: 0.9;
}

.custom-instructions ul {
  list-style: none;
  padding: 0;
  font-size: 14px;
  opacity: 0.8;
}

.custom-instructions li {
  margin: 4px 0;
}
</style>
```

---

## Multiple Scanners

Managing different scanner types:

```vue
<template>
  <div>
    <button @click="openScanner('product')">Scan Product</button>
    <button @click="openScanner('qr')">Scan QR Code</button>
    
    <StreamBarcodeScanner
      v-if="scannerType === 'product'"
      instruction-text="Scan product barcode (EAN/UPC)"
      :formats="productFormats"
      @decoded="handleProductScan"
      @close="closeScanner"
    />
    
    <StreamBarcodeScanner
      v-if="scannerType === 'qr'"
      instruction-text="Scan QR code"
      :formats="qrFormats"
      @decoded="handleQRScan"
      @close="closeScanner"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';
import { BarcodeFormat } from '@zxing/library';

const scannerType = ref(null);

const productFormats = [
  BarcodeFormat.EAN_13,
  BarcodeFormat.EAN_8,
  BarcodeFormat.UPC_A,
  BarcodeFormat.UPC_E
];

const qrFormats = [
  BarcodeFormat.QR_CODE
];

const openScanner = (type) => {
  scannerType.value = type;
};

const closeScanner = () => {
  scannerType.value = null;
};

const handleProductScan = (barcode) => {
  console.log('Product code:', barcode);
  // Fetch product details...
  closeScanner();
};

const handleQRScan = (data) => {
  console.log('QR data:', data);
  // Process QR code...
  closeScanner();
};
</script>
```

---

## With Manual Input Fallback

Adding manual input option:

```vue
<template>
  <div>
    <button @click="showScanner = true">Scan</button>
    
    <StreamBarcodeScanner
      v-if="showScanner"
      @decoded="handleScan"
      @close="showScanner = false"
    >
      <template #footer>
        <button @click="openManualInput" class="manual-btn">
          ⌨️ Enter Code Manually
        </button>
      </template>
    </StreamBarcodeScanner>
    
    <!-- Manual Input Modal -->
    <div v-if="showManualInput" class="modal">
      <div class="modal-content">
        <h3>Enter Barcode</h3>
        <input
          v-model="manualCode"
          type="text"
          placeholder="Enter barcode number"
          @keyup.enter="submitManualCode"
        />
        <div class="modal-actions">
          <button @click="submitManualCode">Submit</button>
          <button @click="showManualInput = false">Cancel</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

const showScanner = ref(false);
const showManualInput = ref(false);
const manualCode = ref('');

const handleScan = (code) => {
  processBarcode(code);
};

const openManualInput = () => {
  showScanner.value = false;
  showManualInput.value = true;
};

const submitManualCode = () => {
  if (manualCode.value.trim()) {
    processBarcode(manualCode.value);
    showManualInput.value = false;
    manualCode.value = '';
  }
};

const processBarcode = (code) => {
  console.log('Processing:', code);
  // Your logic here
};
</script>
```

---

## Filtering Barcode Formats

Restricting to specific barcode types:

```vue
<template>
  <StreamBarcodeScanner
    v-if="showScanner"
    :formats="allowedFormats"
    instruction-text="Scan EAN-13 product barcode"
    @decoded="handleScan"
    @close="showScanner = false"
  />
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';
import { BarcodeFormat } from '@zxing/library';

const showScanner = ref(false);

// Only allow EAN-13 format
const allowedFormats = [BarcodeFormat.EAN_13];

const handleScan = (barcode) => {
  // Will only receive EAN-13 barcodes
  console.log('EAN-13:', barcode);
};
</script>
```

---

## Full Featured Example

A complete implementation with all features:

```vue
<template>
  <div class="app">
    <div class="controls">
      <button @click="openScanner" class="btn-primary">
        📸 Start Scanner
      </button>
      
      <div v-if="lastScan" class="result">
        <strong>Last Scan:</strong> {{ lastScan.code }}
        <small>{{ lastScan.time }}</small>
      </div>
    </div>
    
    <StreamBarcodeScanner
      v-if="scanning"
      :torch="torchEnabled"
      :zoom="zoomLevel"
      :scan-interval="150"
      @decoded="onDecode"
      @loaded="onLoaded"
      @close="closeScanner"
      @error="onError"
    >
      <template #header>
        <div class="scanner-header">
          <h2>Barcode Scanner</h2>
          <span class="badge">{{ scannedCount }} scanned</span>
        </div>
      </template>
      
      <template #footer>
        <div class="scanner-controls">
          <button @click="torchEnabled = !torchEnabled">
            {{ torchEnabled ? '💡' : '🔦' }} Flash
          </button>
          <button @click="adjustZoom">
            🔍 Zoom {{ zoomLevel }}x
          </button>
          <button @click="manualInput = true">
            ⌨️ Manual
          </button>
        </div>
      </template>
    </StreamBarcodeScanner>
    
    <!-- Manual Input -->
    <div v-if="manualInput" class="modal">
      <div class="modal-content">
        <h3>Enter Barcode Manually</h3>
        <input
          v-model="code"
          type="text"
          placeholder="Enter code"
          @keyup.enter="submitCode"
        />
        <div class="modal-buttons">
          <button @click="submitCode">Submit</button>
          <button @click="manualInput = false">Cancel</button>
        </div>
      </div>
    </div>
    
    <!-- History -->
    <div v-if="history.length" class="history">
      <h3>Scan History</h3>
      <div v-for="item in history" :key="item.id" class="history-item">
        <code>{{ item.code }}</code>
        <span>{{ item.time }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

const scanning = ref(false);
const torchEnabled = ref(false);
const zoomLevel = ref(2);
const manualInput = ref(false);
const code = ref('');
const lastScan = ref(null);
const history = ref([]);
const scannedCount = ref(0);

const openScanner = () => {
  scanning.value = true;
};

const closeScanner = () => {
  scanning.value = false;
  torchEnabled.value = false;
};

const onDecode = (barcode) => {
  const scan = {
    id: Date.now(),
    code: barcode,
    time: new Date().toLocaleTimeString()
  };
  
  lastScan.value = scan;
  history.value.unshift(scan);
  scannedCount.value++;
  
  // Keep only last 10
  if (history.value.length > 10) {
    history.value = history.value.slice(0, 10);
  }
  
  closeScanner();
};

const onLoaded = () => {
  console.log('Camera loaded');
};

const onError = (error) => {
  console.error('Error:', error);
  alert('Camera error: ' + error.message);
  closeScanner();
};

const adjustZoom = () => {
  zoomLevel.value = zoomLevel.value >= 4 ? 2 : zoomLevel.value + 1;
};

const submitCode = () => {
  if (code.value.trim()) {
    onDecode(code.value);
    code.value = '';
    manualInput.value = false;
  }
};
</script>

<style scoped>
/* Add your styles */
</style>
```

---

## Need More Help?

Check out the [main README](./README.md) for API reference and more details!

