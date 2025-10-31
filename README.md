# Bricked

A classic brick breaker game built with [Flutter](https://flutter.dev/) and the [Flame](https://flame-engine.org/) engine.

## How to Play

- **Move the bat:** Use the left and right arrow keys on your keyboard.
- **Start the game:** Press the space bar, the enter key, or tap the screen.
- **Objective:** Break all the bricks with the ball to win the game. If you miss the ball, you lose.

## Project Structure

The project is structured as a standard Flutter application with the game logic separated into different files.

- `lib/main.dart`: The entry point of the application.
- `lib/src/brick_breaker.dart`: The main game class, extending `FlameGame`. It manages the game loop, state, and components.
- `lib/src/components/`: This directory contains all the game components:
    - `ball.dart`: The ball component.
    - `bat.dart`: The player's bat component.
    - `brick.dart`: The brick component.
    - `play_area.dart`: The component that defines the game's boundaries.
- `lib/src/widgets/`: This directory contains widgets that are used as overlays on top of the game, like the score card and overlay screens.
- `lib/src/config.dart`: This file contains game configuration constants like speed, sizes, and colors.

## Getting Started

To run the game, you need to have Flutter installed.

1.  Clone the repository.
2.  Navigate to the project directory: `cd bricked`
3.  Get the dependencies: `flutter pub get`
4.  Run the game: `flutter run`
