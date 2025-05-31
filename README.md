# 🎮 Sally Game

**Sally Game** is a simple arcade-style Flutter game where the player controls a bucket and catches falling balls while avoiding spiky ones. It demonstrates interactive UI elements, animation, and basic collision mechanics using Flutter's framework.

---

## 🧩 Features

- Drag-to-move bucket control.
- Score points by catching regular balls.
- Avoid spiky balls to preserve lives.
- Randomized ball colors, speeds, and spawn logic.
- Game Over screen with restart functionality.
- Custom asset integration (background, bucket, balls).

---

## 🖼️ Assets

Ensure the following image assets are placed in `assets/images/`:

- `background.png`
- `bucket.png`
- `ball.png`
- `spiky_ball.png`

Update your `pubspec.yaml` to include:
```yaml
flutter:
  assets:
    - assets/images/background.png
    - assets/images/bucket.png
    - assets/images/ball.png
    - assets/images/spiky_ball.png
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed ([Get started](https://flutter.dev/docs/get-started/install))
- A device or emulator to run the app

### Run the App

1. Clone the repository.
2. Add your image assets in the appropriate directory.
3. Run the app:

```bash
flutter run
```

---

## 🎮 Gameplay Overview

- The player controls a bucket at the bottom of the screen by dragging.
- Balls fall from the top and must be caught.
- Regular balls award points.
- Spiky balls reduce lives.
- The game ends when lives reach zero.
- The score and lives are displayed during gameplay.

---

## 🖼️ Screenshots


---

## 🧠 Game Logic Highlights

- Ball objects are created with random colors, speed, and rotation.
- Collision detection is based on position overlap.
- Game loop runs every 16ms (approx. 60 FPS).
- All UI and game rendering is handled with `Stack`, `Positioned`, and `Transform`.

---

## 📄 License

This project is provided for educational and demonstration purposes. Feel free to use and modify for personal or learning projects.

---


## 👩‍💻 Author

Developed as a fun side project to demonstrate Flutter’s capabilities in game-like UI logic.
