<template>
  <div v-show="!isLoading" class="barcode-scanner">
    <video class="barcode-scanner-video" ref="scanner"></video>
    <div class="barcode-scanner-focus"></div>
    <div class="barcode-scanner-border">
      <div class="corner top-left"></div>
      <div class="corner top-right"></div>
      <div class="corner bottom-left"></div>
      <div class="corner bottom-right"></div>
    </div>
    <div class="laser"></div>
    
    <!-- Header -->
    <div class="barcode-scanner-header">
      <button v-if="showCloseButton" class="icon-button" @click="handleClose" aria-label="Close scanner">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
          <path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
        </svg>
      </button>
      <slot name="header"></slot>
      <button
        v-if="hasTorch"
        :class="['icon-button', { 'disabled': !isTorchSupported }]"
        @click="toggleTorch"
        :disabled="!isTorchSupported"
        :aria-label="isTorchOn ? 'Turn off flashlight' : 'Turn on flashlight'"
      >
        <svg v-if="!isTorchOn" width="24" height="24" viewBox="0 0 24 24" fill="none">
          <path d="M9 2h6l3 4v4a5 5 0 01-5 5 5 5 0 01-5-5V6l3-4z" stroke="currentColor" stroke-width="2"/>
          <path d="M12 15v7" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
        </svg>
        <svg v-else width="24" height="24" viewBox="0 0 24 24" fill="none">
          <path d="M9 2h6l3 4v4a5 5 0 01-5 5 5 5 0 01-5-5V6l3-4z" fill="currentColor" stroke="currentColor" stroke-width="2"/>
          <path d="M12 15v7" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
        </svg>
      </button>
    </div>
    
    <!-- Instructions -->
    <div class="barcode-scanner-instructions">
      <slot name="instructions">
        <div class="instruction-text">{{ instructionText }}</div>
      </slot>
    </div>
    
    <!-- Footer -->
    <div class="barcode-scanner-footer">
      <slot name="footer"></slot>
    </div>
  </div>
</template>

<script>
import { BrowserMultiFormatReader, BarcodeFormat, DecodeHintType } from '@zxing/library';

export default {
  name: 'StreamBarcodeScanner',
  emits: ['decoded', 'loaded', 'close', 'error'],

  props: {
    torch: {
      type: Boolean,
      default: false
    },
    zoom: {
      type: Number,
      default: 3
    },
    autofocus: {
      type: Boolean,
      default: true
    },
    focusDistance: {
      type: Number,
      default: 0
    },
    landscape: {
      type: Boolean,
      default: false
    },
    deviceIndex: {
      type: Number,
      default: 0
    },
    msBetweenDecoding: {
      type: Number,
      default: 500
    },
    scanInterval: {
      type: Number,
      default: 200
    },
    showCloseButton: {
      type: Boolean,
      default: true
    },
    instructionText: {
      type: String,
      default: 'Position barcode within the frame to scan'
    },
    formats: {
      type: Array,
      default: () => Object.values(BarcodeFormat)
    }
  },

  data() {
    return {
      idealDevice: {},
      cameraDetails: {},
      videoDevices: [],
      isLoading: true,
      browserMultiFormatReader: null,
      isMediaStreamAPISupported: navigator && navigator.mediaDevices && 'enumerateDevices' in navigator.mediaDevices,
      isTorchOn: false,
      isTorchSupported: true,
      scanningInterval: null,
      metadataLoaded: false
    };
  },

  computed: {
    hasTorch() {
      return !!this.idealDevice?.torch;
    },
    hasZoom() {
      return this.idealDevice?.zoom ? this.idealDevice.zoom : false;
    },
    hasAutofocus() {
      return !!this.idealDevice?.focusMode?.includes('continuous');
    },
    hasFocusDistance() {
      return this.idealDevice?.focusDistance ? this.idealDevice.focusDistance : false;
    }
  },

  watch: {
    torch() {
      if (this.hasTorch) {
        this.applyCameraConstraints();
      }
    },
    zoom() {
      if (this.hasZoom) {
        this.applyCameraConstraints();
      }
    },
    autofocus() {
      if (this.hasAutofocus) {
        this.applyCameraConstraints();
      }
    },
    focusDistance() {
      if (!this.autofocus) {
        this.applyCameraConstraints();
      }
    },
    landscape() {
      if (this.landscape) {
        this.fullscreenLandscape();
      } else {
        this.exitFullscreenLandscape();
      }
    },
    deviceIndex() {
      if (
        this.deviceIndex != this.videoDevices.selectedIndex &&
        this.deviceIndex == Number(this.deviceIndex) &&
        this.videoDevices?.devices?.length > 1
      ) {
        this.isLoading = true;
        this.browserMultiFormatReader.reset();
        this.cameraDetails = {};
        this.cameraDetails.previousDevice = this.idealDevice;
        const deviceId = this.videoDevices?.devices[this.deviceIndex]?.deviceId;
        navigator.mediaDevices.enumerateDevices().then(devices => {
          this.findIdealDevice(devices, deviceId).then(() => {
            this.selectCamera();
          });
        });
      }
    }
  },

  mounted() {
    if (!this.isMediaStreamAPISupported) {
      const error = new Error('Media Stream API is not supported in this browser');
      this.$emit('error', error);
      return;
    }

    // Initialize the reader with supported formats
    this.browserMultiFormatReader = new BrowserMultiFormatReader(
      new Map([[DecodeHintType.POSSIBLE_FORMATS, this.formats]])
    );

    this.idealDevice = JSON.parse(localStorage.getItem('vue-barcode-scanner-ideal') || '{}');
    this.cameraDetails.previousDevice = this.idealDevice;
    
    if (this.landscape) {
      this.fullscreenLandscape();
    }
    
    if (typeof this.idealDevice === 'object' && Object.keys(this.idealDevice).length > 0) {
      this.selectCamera();
    } else {
      navigator.mediaDevices.enumerateDevices().then(devices => {
        this.findIdealDevice(devices).then(() => {
          this.selectCamera();
        });
      });
    }
  },

  beforeUnmount() {
    if (this.scanningInterval) {
      clearInterval(this.scanningInterval);
      this.scanningInterval = null;
    }

    this.isLoading = true;
    this.cleanupScannerResources();
  },

  methods: {
    cleanupScannerResources() {
      document.body.style.overflow = '';
      document.body.style.position = '';
      document.body.style.width = '';

      this.stopScanning();
      this.browserMultiFormatReader?.reset();
      this.stopScannerVideo(this.$refs.scanner);
    },

    async toggleTorch() {
      const videoTrack = this.$refs.scanner?.srcObject?.getVideoTracks()?.[0];
      if (videoTrack && this.hasTorch) {
        const currentTorchState = this.isTorchOn;
        try {
          await videoTrack.applyConstraints({
            advanced: [{ torch: !currentTorchState }]
          });
          this.isTorchOn = !currentTorchState;
        } catch (error) {
          console.error('Error toggling torch:', error);
          this.$emit('error', error);
        }
      }
    },

    stopScanning() {
      if (this.browserMultiFormatReader) {
        this.browserMultiFormatReader.stopContinuousDecode();
      }
    },

    startScanning() {
      this.selectCamera();
    },

    handleClose() {
      this.cleanupScannerResources();
      this.$emit('close');
    },

    async findIdealDevice(devices, deviceId = false) {
      let deviceOptions = [];
      let cameras = [];
      
      if (deviceId) {
        cameras = devices.filter(device => device.kind === 'videoinput' && device.deviceId === deviceId);
      }
      
      if (cameras?.length !== 1) {
        cameras = devices.filter(
          device => device.kind === 'videoinput' && device.label.toLowerCase().indexOf('front') === -1
        );
        if (cameras?.length === 0) {
          cameras = devices.filter(device => device.kind === 'videoinput');
        }
      }
      
      this.cameraDetails.requestedDeviceId = deviceId;
      this.cameraDetails.cameras = devices.filter(device => device.kind === 'videoinput');
      this.cameraDetails.filteredCameras = cameras;
      this.cameraDetails.constraints = [];
      
      for (let index = 0; index < cameras.length; index++) {
        const constraints = { video: true };
        if (deviceId) {
          constraints.video = {
            deviceId: {
              exact: cameras[index].deviceId
            }
          };
        } else {
          constraints.video = { facingMode: 'environment' };
          if (cameras[index].deviceId) {
            constraints.video.deviceId = {
              exact: cameras[index].deviceId
            };
          }
        }
        
        this.cameraDetails.constraints.push(constraints);
        
        await navigator.mediaDevices
          .getUserMedia(constraints)
          .then(stream => {
            const track = stream.getVideoTracks()[0];
            const trackCapabilities = {
              deviceId: cameras[index].deviceId,
              ...(track.getCapabilities?.() ?? {})
            };
            deviceOptions.push(trackCapabilities);
            stream.getTracks().forEach(track => {
              track.stop();
            });
            return true;
          })
          .catch(() => {
            return false;
          });
      }

      this.cameraDetails.deviceOptions = deviceOptions;

      if (deviceOptions.length > 0) {
        const environmentFacing = deviceOptions.filter(device => device.facingMode?.includes('environment'));
        if (environmentFacing.length > 0) {
          deviceOptions = environmentFacing;
        }

        let idealIndex = deviceOptions.length - 1;
        for (let index = 0; index < deviceOptions.length; index++) {
          if (deviceOptions[index].torch && deviceOptions[index].focusMode?.includes('continuous')) {
            idealIndex = index;
            break;
          } else if (deviceOptions[index].torch) {
            idealIndex = index;
          }
        }

        this.idealDevice = deviceOptions[idealIndex];
        localStorage.setItem('vue-barcode-scanner-ideal', JSON.stringify(deviceOptions[idealIndex]));
        return true;
      } else {
        return false;
      }
    },

    async fullscreenLandscape() {
      await document.documentElement
        .requestFullscreen()
        .then(() => {
          screen.orientation.lock('landscape').catch(() => {});
          return true;
        })
        .catch(() => {
          return false;
        });
    },

    async exitFullscreenLandscape() {
      screen.orientation.lock('portrait-primary').catch(() => {});
      await document
        .exitFullscreen()
        .then(() => {
          return true;
        })
        .catch(() => {
          return false;
        });
    },

    selectCamera() {
      this.browserMultiFormatReader.listVideoInputDevices().then(videoInputDevices => {
        this.videoDevices = { devices: videoInputDevices };
        if (videoInputDevices.findIndex(device => device.deviceId === this.idealDevice.deviceId) === -1) {
          this.idealDevice = {};
          localStorage.removeItem('vue-barcode-scanner-ideal');
          navigator.mediaDevices.enumerateDevices().then(devices => {
            this.findIdealDevice(devices).then(() => {
              this.selectCamera();
            });
          });
          return;
        }

        this.startCodeReader(this.idealDevice.deviceId);
        this.$refs.scanner.oncanplay = () => {
          this.isLoading = false;
          this.videoDevices.selectedId = this.idealDevice.deviceId;
          this.videoDevices.selectedIndex = this.videoDevices?.devices?.findIndex(
            device => device.deviceId === this.idealDevice.deviceId
          );
          this.cameraDetails.videoDevices = this.videoDevices.devices;
          this.cameraDetails.selectedIndex = this.videoDevices.selectedIndex;
          this.cameraDetails.selectedDeviceId = this.idealDevice.deviceId;
          this.cameraDetails.selectedDevice = this.idealDevice;
          this.$emit('loaded');
          this.applyCameraConstraints();
        };
      });
    },

    applyCameraConstraints() {
      const advanced = {};
      if (this.hasTorch) advanced.torch = this.torch;
      if (this.hasZoom)
        advanced.zoom = Math.min(Math.max(this.idealDevice.zoom.min, this.zoom), this.idealDevice.zoom.max);
      if (this.hasAutofocus || (!this.hasAutofocus && !this.autofocus && this.hasFocusDistance))
        advanced.focusMode = this.autofocus ? 'continuous' : 'manual';
      if (!this.autofocus && this.hasFocusDistance)
        advanced.focusDistance = Math.min(
          Math.max(this.idealDevice.focusDistance.min, this.focusDistance),
          this.idealDevice.focusDistance.max
        );
      this.cameraDetails.applyConstraints = advanced;
      this.$refs.scanner?.srcObject
        ?.getVideoTracks()[0]
        ?.applyConstraints({
          advanced: [advanced]
        })
        .catch(() => {});
    },

    startCodeReader(deviceId) {
      const scannerVideo = this.$refs.scanner;
      document.body.style.overflow = 'hidden';
      document.body.style.position = 'fixed';
      document.body.style.width = '100%';
      this.initializeCamera(deviceId, scannerVideo);
    },

    initializeCamera(deviceId, scannerVideo) {
      navigator.mediaDevices
        .getUserMedia({
          video: {
            deviceId: deviceId,
            width: { min: 640, ideal: 1280, max: 1920 },
            height: { min: 480, ideal: 720, max: 1080 },
            facingMode: 'environment',
            autofocus: true,
            focusMode: 'continuous'
          }
        })
        .then(stream => {
          scannerVideo.srcObject = stream;
          scannerVideo.setAttribute('playsinline', true);

          scannerVideo.onloadedmetadata = () => {
            if (this.metadataLoaded) return;
            this.metadataLoaded = true;

            this.setupCanvas(scannerVideo);
          };

          scannerVideo.play().catch(err => {
            console.error('Error playing video:', err);
            this.$emit('error', err);
          });
        })
        .catch(error => {
          console.error('Camera access error:', error);
          this.$emit('error', error);
        });
    },

    setupCanvas(scannerVideo) {
      const overlayCanvas = document.createElement('canvas');
      overlayCanvas.width = scannerVideo.videoWidth;
      overlayCanvas.height = scannerVideo.videoHeight;

      const overlayCtx = overlayCanvas.getContext('2d');
      this.startScanningInterval(scannerVideo, overlayCanvas, overlayCtx);
    },

    startScanningInterval(scannerVideo, overlayCanvas, overlayCtx) {
      this.scanningInterval = setInterval(() => {
        try {
          overlayCtx.drawImage(scannerVideo, 0, 0, overlayCanvas.width, overlayCanvas.height);

          const { boxX, boxY, boxWidth, boxHeight } = this.getScanRegion(overlayCanvas);
          const croppedImage = this.cropImage(overlayCanvas, boxX, boxY, boxWidth, boxHeight);

          croppedImage.onload = () => {
            this.browserMultiFormatReader
              .decodeFromImage(croppedImage)
              .then(res => {
                if (res) {
                  const decodedText = res.text.startsWith('S') && res.text.length >= 11 ? res.text.slice(1) : res.text;
                  this.handleDecodedResult(decodedText);
                }
              })
              .catch(() => {
                // Silently fail - no barcode detected in this frame
              });
          };
        } catch (err) {
          console.error('Decoding error:', err);
        }
      }, this.scanInterval);
    },

    getScanRegion(overlayCanvas) {
      return {
        boxX: Math.floor(overlayCanvas.width * 0.02),
        boxY: Math.floor(overlayCanvas.height * 0.4),
        boxWidth: Math.floor(overlayCanvas.width * 0.96),
        boxHeight: Math.floor(overlayCanvas.height * 0.1)
      };
    },

    cropImage(overlayCanvas, boxX, boxY, boxWidth, boxHeight) {
      const tempCanvas = document.createElement('canvas');
      tempCanvas.width = boxWidth;
      tempCanvas.height = boxHeight;
      const tempCtx = tempCanvas.getContext('2d');

      tempCtx.drawImage(overlayCanvas, boxX, boxY, boxWidth, boxHeight, 0, 0, boxWidth, boxHeight);

      const img = new Image();
      img.src = tempCanvas.toDataURL('image/png');
      return img;
    },

    handleDecodedResult(decodedText) {
      this.$emit('decoded', decodedText);
    },

    stopScannerVideo(scannerVideo) {
      clearInterval(this.scanningInterval);
      if (scannerVideo?.srcObject) {
        const tracks = scannerVideo.srcObject.getTracks();
        tracks.forEach(track => {
          if (track?.readyState === 'live') {
            track.stop();
            if (track?.getCapabilities?.().torch) {
              track.applyConstraints({ advanced: [{ torch: false }] });
            }
          }
        });
        scannerVideo.srcObject = null;
      }
    }
  }
};
</script>

<style scoped>
.barcode-scanner {
  position: fixed !important;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  z-index: 9999;
  background: #000;
}

.barcode-scanner-video {
  display: block;
  margin: auto;
  width: 100vw;
  height: 100vh;
  object-fit: cover;
}

.barcode-scanner-focus {
  position: absolute;
  top: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  clip-path: polygon(0% 0%, 0% 100%, 2% 100%, 2% 40%, 98% 40%, 98% 60%, 2% 60%, 2% 100%, 100% 100%, 100% 0%);
}

.barcode-scanner-border {
  position: absolute;
  top: 40%;
  left: 2%;
  width: 96%;
  height: 20%;
  border-radius: 0px;
}

.barcode-scanner-header {
  position: absolute;
  top: 15px;
  color: #fff;
  display: flex;
  width: 100vw;
  justify-content: space-between;
  padding: 16px;
  align-items: center;
  gap: 8px;
  z-index: 10;
}

.icon-button {
  background: transparent;
  border: none;
  color: #fff;
  cursor: pointer;
  padding: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: opacity 0.2s;
}

.icon-button:hover {
  opacity: 0.8;
}

.icon-button:active {
  opacity: 0.6;
}

.icon-button.disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.barcode-scanner-instructions {
  position: absolute;
  display: flex;
  justify-content: center;
  width: 100%;
  z-index: 1;
  padding: 16px;
  top: 80px;
}

.instruction-text {
  display: flex;
  align-items: center;
  text-align: center;
  padding: 12px 24px;
  max-width: 400px;
  background-color: rgba(0, 0, 0, 0.7);
  color: #fff;
  border-radius: 8px;
  font-size: 14px;
  backdrop-filter: blur(10px);
}

.barcode-scanner-footer {
  position: fixed;
  display: flex;
  align-items: flex-end;
  justify-content: center;
  width: 100%;
  bottom: 40px;
  z-index: 1;
  gap: 12px;
  padding: 0 16px;
}

.laser {
  width: 96%;
  margin-left: 2%;
  background: linear-gradient(
    180deg,
    rgba(59, 130, 246, 0) 0%,
    rgba(59, 130, 246, 0.8) 50%,
    rgba(59, 130, 246, 0) 100%
  );
  height: 10%;
  position: absolute;
  top: 40%;
  z-index: 2;
  border-radius: 2px;
  animation: scanning 2s infinite;
}

@keyframes scanning {
  50% {
    transform: translateY(100%);
  }
}

.corner {
  position: absolute;
  width: 40px;
  height: 40px;
  border: 4px solid #fff;
  border-radius: 4px;
}

.corner.top-left {
  top: 0;
  left: 0;
  border-right: none;
  border-bottom: none;
}

.corner.top-right {
  top: 0;
  right: 0;
  border-left: none;
  border-bottom: none;
}

.corner.bottom-left {
  bottom: 0;
  left: 0;
  border-right: none;
  border-top: none;
}

.corner.bottom-right {
  bottom: 0;
  right: 0;
  border-left: none;
  border-top: none;
}
</style>

