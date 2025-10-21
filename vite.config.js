import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import basicSsl from '@vitejs/plugin-basic-ssl';
import { resolve } from 'path';

export default defineConfig({
  plugins: [vue(), basicSsl()],
  build: {
    lib: {
      entry: resolve(__dirname, 'src/components/StreamBarcodeScanner.vue'),
      name: 'StreamBarcodeScanner',
      fileName: (format) => `stream-barcode-scanner.${format}.js`
    },
    rollupOptions: {
      external: ['vue', '@zxing/library'],
      output: {
        globals: {
          vue: 'Vue',
          '@zxing/library': 'ZXing'
        }
      }
    }
  },
  server: {
    host: true
  }
});

