# 📸 Vue Stream Barcode Scanner

A high-performance, production-ready Vue 3 barcode scanner component with **real-time camera streaming**. Built with **ZXing library** for reliable barcode detection.

![Demo](https://img.shields.io/badge/vue-3.x-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## ✨ Features

- 🎥 **Real-time camera streaming** - Scan barcodes directly from camera feed
- 🔦 **Torch/Flashlight control** - Toggle device torch for low-light scanning
- 🎯 **Smart focus region** - Optimized scan area for better performance
- 📱 **Mobile-first design** - Responsive and touch-friendly
- 🎨 **Beautiful UI** - Animated scan laser and corner guides
- 🔧 **Highly configurable** - Customize zoom, focus, scan intervals, and more
- 📦 **Zero dependencies** (except ZXing and Vue 3)
- 🚀 **TypeScript support** (coming soon)

## 📸 Supported Barcode Formats

- **EAN-8, EAN-13** (European Article Number)
- **UPC-A, UPC-E** (Universal Product Code)
- **Code 39, Code 93, Code 128**
- **ITF** (Interleaved 2 of 5)
- **Codabar**
- **QR Code**
- **Data Matrix**
- **PDF417**
- And many more via ZXing!

## 🚀 Quick Start

### Installation

```bash
npm install vue-stream-barcode-scanner
# or
yarn add vue-stream-barcode-scanner
# or
pnpm add vue-stream-barcode-scanner
```

### Basic Usage

```vue
<template>
  <div>
    <button @click="showScanner = true">Start Scanner</button>
    
    <StreamBarcodeScanner
      v-if="showScanner"
      @decoded="onBarcodeDetected"
      @close="showScanner = false"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

const showScanner = ref(false);

const onBarcodeDetected = (result) => {
  console.log('Barcode detected:', result);
  alert(`Scanned: ${result}`);
  showScanner.value = false;
};
</script>
```

## 📚 API Reference

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `torch` | `Boolean` | `false` | Enable/disable torch (flashlight) |
| `zoom` | `Number` | `3` | Camera zoom level |
| `autofocus` | `Boolean` | `true` | Enable continuous autofocus |
| `focusDistance` | `Number` | `0` | Manual focus distance (when autofocus is off) |
| `landscape` | `Boolean` | `false` | Force landscape orientation |
| `deviceIndex` | `Number` | `0` | Camera device index (0 = first camera) |
| `msBetweenDecoding` | `Number` | `500` | Milliseconds between decode attempts |
| `scanInterval` | `Number` | `200` | Milliseconds between frame captures |
| `showCloseButton` | `Boolean` | `true` | Show close button in header |
| `instructionText` | `String` | `'Position barcode in frame'` | Custom instruction text |

### Events

| Event | Payload | Description |
|-------|---------|-------------|
| `decoded` | `String` | Emitted when a barcode is successfully decoded |
| `close` | - | Emitted when the close button is clicked |
| `loaded` | - | Emitted when camera is ready |
| `error` | `Error` | Emitted when an error occurs |

### Slots

| Slot | Description |
|------|-------------|
| `header` | Custom header content |
| `footer` | Custom footer content |
| `instructions` | Custom instruction content |

## 🎨 Advanced Usage

### Custom Styling

```vue
<template>
  <StreamBarcodeScanner
    v-if="showScanner"
    :torch="torchEnabled"
    :zoom="2.5"
    :scan-interval="150"
    instruction-text="Scan product barcode"
    @decoded="handleScan"
    @close="close"
  >
    <template #footer>
      <button @click="toggleTorch">Toggle Flash</button>
      <button @click="enterManually">Enter Manually</button>
    </template>
  </StreamBarcodeScanner>
</template>

<script setup>
import { ref } from 'vue';
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

const showScanner = ref(true);
const torchEnabled = ref(false);

const handleScan = (barcode) => {
  console.log('Scanned:', barcode);
  // Process barcode
};

const toggleTorch = () => {
  torchEnabled.value = !torchEnabled.value;
};

const enterManually = () => {
  // Show manual input modal
};
</script>
```

### Options API

```vue
<template>
  <StreamBarcodeScanner
    v-if="isScanning"
    @decoded="onDecode"
    @close="isScanning = false"
  />
</template>

<script>
import StreamBarcodeScanner from 'vue-stream-barcode-scanner';

export default {
  components: {
    StreamBarcodeScanner
  },
  data() {
    return {
      isScanning: false
    };
  },
  methods: {
    onDecode(barcode) {
      console.log('Decoded:', barcode);
      this.isScanning = false;
    }
  }
};
</script>
```

## 🔧 Browser Support

- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14.5+
- ✅ iOS Safari 14.5+
- ✅ Chrome for Android 90+

**Note:** Requires browsers with `getUserMedia` API support.

## 🐛 Troubleshooting

### Camera not working?

1. **Check HTTPS**: Camera access requires HTTPS (or localhost for development)
2. **Check permissions**: User must grant camera permissions
3. **Check device**: Ensure device has a working camera

### Torch not working?

- Torch support varies by device and browser
- The component automatically detects torch capability
- Torch icon will be disabled if not supported

### Poor scan performance?

- Increase lighting conditions
- Adjust `zoom` prop (try values between 2-4)
- Reduce `scan-interval` for faster scanning
- Ensure barcode is within the scan region

## 🛠️ Development

```bash
# Clone the repository
git clone https://github.com/VegantiNagaSatish/vue-stream-barcode-scanner.git

# Install dependencies
npm install

# Run demo in development mode
npm run dev

# Build for production
npm run build
```

## 📝 License

MIT License - feel free to use this in your projects!

## 🙌 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 💖 Support

If this project helped you, please consider giving it a ⭐️!

## 🔗 Related Projects

- [ZXing](https://github.com/zxing-js/library) - The barcode scanning library powering this component
- [Vue 3](https://vuejs.org/) - The progressive JavaScript framework

---

Made with ❤️ by [Your Name]


