# Contributing to Vue Stream Barcode Scanner

Thank you for your interest in contributing! 🎉

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/vue-stream-barcode-scanner.git`
3. Create a new branch: `git checkout -b feature/my-feature`
4. Install dependencies: `npm install`
5. Start development server: `npm run dev`

## Development Setup

### Prerequisites
- Node.js 16+ and npm/yarn/pnpm
- A device with a camera (or use Chrome DevTools device emulation)
- HTTPS is required for camera access (development server includes HTTPS by default)

### Project Structure
```
vue-stream-barcode-scanner/
├── src/
│   ├── components/
│   │   └── StreamBarcodeScanner.vue  # Main component
│   ├── App.vue                        # Demo app
│   ├── main.js                        # Entry point
│   └── style.css                      # Global styles
├── package.json
├── vite.config.js                     # Build configuration
└── README.md
```

## Making Changes

### Code Style
- Use 2 spaces for indentation
- Use single quotes for strings
- Add comments for complex logic
- Follow Vue 3 Composition API best practices

### Component Guidelines
1. **Props**: Add proper type checking and defaults
2. **Events**: Document all emitted events
3. **Performance**: Minimize re-renders and optimize heavy operations
4. **Accessibility**: Include ARIA labels and keyboard navigation

### Testing
Before submitting:
1. Test on multiple devices (mobile, tablet, desktop)
2. Test in different browsers (Chrome, Firefox, Safari)
3. Test with different barcode types
4. Verify camera permissions work correctly

## Submitting Changes

1. Commit your changes: `git commit -m "Add feature: description"`
2. Push to your fork: `git push origin feature/my-feature`
3. Open a Pull Request with:
   - Clear description of changes
   - Screenshots/videos if UI changes
   - List of tested devices/browsers

## Pull Request Guidelines

- Keep PRs focused on a single feature/fix
- Update documentation if needed
- Ensure demo app still works
- Follow existing code style

## Reporting Issues

When reporting bugs, please include:
- Browser and version
- Device and OS
- Steps to reproduce
- Expected vs actual behavior
- Console errors (if any)
- Screenshots/videos (if applicable)

## Feature Requests

We welcome feature requests! Please:
- Check if the feature already exists or is planned
- Describe the use case
- Explain why it would be useful
- Provide examples if possible

## Questions?

Feel free to open an issue for any questions or discussions!

Thank you for contributing! 🙏

