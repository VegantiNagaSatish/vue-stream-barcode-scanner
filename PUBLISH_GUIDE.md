# 📦 Publishing Guide

This guide will help you publish your Vue Stream Barcode Scanner to GitHub and npm.

## 🚀 Quick Start

### 1. Install Dependencies

```bash
cd /Users/vegantinaga/Desktop/vue-stream-barcode-scanner
npm install
```

### 2. Test the Demo

```bash
npm run dev
```

Visit `https://localhost:5173` (note: HTTPS is required for camera access)

### 3. Build the Library

```bash
npm run build
```

---

## 📤 Publishing to GitHub

### Step 1: Create a GitHub Repository

1. Go to [GitHub](https://github.com/new)
2. Create a new repository named `vue-stream-barcode-scanner`
3. **Don't** initialize with README (we already have one)
4. Click "Create repository"

### Step 2: Initialize Git and Push

```bash
cd /Users/vegantinaga/Desktop/vue-stream-barcode-scanner

# Initialize git
git init

# Add all files
git add .

# Make first commit
git commit -m "Initial commit: Vue Stream Barcode Scanner"

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/vue-stream-barcode-scanner.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 3: Update package.json

Before publishing, update `package.json` with your information:

```json
{
  "name": "vue-stream-barcode-scanner",
  "author": "Your Name <your.email@example.com>",
  "repository": {
    "type": "git",
    "url": "https://github.com/YOUR_USERNAME/vue-stream-barcode-scanner.git"
  },
  "bugs": {
    "url": "https://github.com/YOUR_USERNAME/vue-stream-barcode-scanner/issues"
  },
  "homepage": "https://github.com/YOUR_USERNAME/vue-stream-barcode-scanner#readme"
}
```

### Step 4: Enable GitHub Pages (Optional)

To host the demo online:

1. Go to your repository settings
2. Navigate to "Pages"
3. Set source to "GitHub Actions"
4. Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Demo

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      - run: npm ci
      - run: npm run build
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./dist
```

---

## 📦 Publishing to npm (Optional)

### Step 1: Create npm Account

1. Go to [npmjs.com](https://www.npmjs.com/signup)
2. Create an account
3. Verify your email

### Step 2: Login via CLI

```bash
npm login
```

### Step 3: Update Package Name

If `vue-stream-barcode-scanner` is taken, use a scoped package:

```json
{
  "name": "@your-username/vue-stream-barcode-scanner"
}
```

### Step 4: Publish

```bash
# Dry run to see what will be published
npm publish --dry-run

# Publish to npm
npm publish

# Or for scoped packages
npm publish --access public
```

### Step 5: Update Version

When making updates:

```bash
# Patch (1.0.0 -> 1.0.1)
npm version patch

# Minor (1.0.0 -> 1.1.0)
npm version minor

# Major (1.0.0 -> 2.0.0)
npm version major

# Then publish again
npm publish
```

---

## 🎨 Customization Tips

### Update README

1. Replace `YOUR_USERNAME` with your GitHub username
2. Add screenshots/GIFs of your scanner in action
3. Update the demo link
4. Add your contact information

### Add Screenshots

Create a `screenshots` folder and add images:

```bash
mkdir screenshots
# Add your images here
```

Then reference in README:

```markdown
![Demo Screenshot](./screenshots/demo.png)
```

### Create a Demo GIF

Use tools like:
- [ScreenToGif](https://www.screentogif.com/) (Windows)
- [Kap](https://getkap.co/) (macOS)
- [Peek](https://github.com/phw/peek) (Linux)

### Update LICENSE

Replace `[Your Name]` in `LICENSE` with your actual name.

---

## 📝 Checklist Before Publishing

- [ ] Test the scanner on multiple devices
- [ ] Update all placeholder names (YOUR_USERNAME, Your Name, etc.)
- [ ] Add screenshots/GIFs to README
- [ ] Update LICENSE with your name
- [ ] Test `npm install` from your package
- [ ] Verify demo works correctly
- [ ] Check all links in README
- [ ] Review CONTRIBUTING.md
- [ ] Add topics/tags to GitHub repository
- [ ] Write a good README with clear examples

---

## 🏷️ Recommended GitHub Topics

Add these topics to make your repo discoverable:

- `vue`
- `vue3`
- `barcode`
- `barcode-scanner`
- `qr-code`
- `camera`
- `zxing`
- `scanner`
- `vue-component`
- `javascript`

---

## 🌟 Promoting Your Library

1. **Create a Demo Video**: Record yourself using the scanner
2. **Write a Blog Post**: Explain how it works
3. **Share on Social Media**:
   - Twitter/X with hashtags: #vuejs #opensource
   - Reddit: r/vuejs
   - Dev.to article
4. **Submit to Awesome Lists**:
   - [Awesome Vue](https://github.com/vuejs/awesome-vue)
5. **Add to Vue Component Libraries**

---

## 🔧 Maintenance

### Keep Dependencies Updated

```bash
npm outdated
npm update
```

### Handle Issues

- Respond to issues within 48 hours
- Use issue templates
- Tag issues appropriately (bug, enhancement, etc.)

### Accept Pull Requests

- Review code carefully
- Test changes
- Thank contributors
- Update CHANGELOG

---

## 📚 Additional Resources

- [npm Publishing Guide](https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry)
- [GitHub Pages](https://pages.github.com/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)

---

## 🎉 You're Ready!

Your Vue Stream Barcode Scanner is ready to share with the world! Good luck! 🚀

For questions, create an issue in your repository.

