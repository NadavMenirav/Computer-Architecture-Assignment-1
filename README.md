# 🎲 Number Guessing Game

A number guessing game implemented in x86-64 assembly language.

## 📝 Description

This is an interactive command-line number guessing game where players try to guess a randomly generated number. The game features configurable difficulty modes and a "double or nothing" mechanic for continued play.

## 🎮 Game Features

### Core Mechanics
- **🎰 Random Number Generation**: Uses a user-provided seed to generate random numbers
- **⏱️ Limited Attempts**: Players have M attempts (default: 5) to guess the correct number
- **📊 Range**: Numbers are generated between 1 and N (default: 10)

### Game Modes

#### 😊 Easy Mode
When enabled, the game provides hints after each incorrect guess:
- ⬆️ Tells you if your guess was too high
- ⬇️ Tells you if your guess was too low

#### 💰 Double or Nothing
After winning a round, players can choose to continue:
- **✅ Accept**: Range doubles (N × 2), seed doubles, attempts reset to 5
- **❌ Decline**: End game with current wins

## 🎯 How to Play

1. **Initial Setup**
   ```
   Enter configuration seed: [your seed number]
   Would you like to play in easy mode? (y/n) [y or n]
   ```

2. **Making Guesses**
   ```
   What is your guess? [your number]
   ```

3. **Outcomes**
   - **✅ Correct Guess**: Win the round! Option to play double or nothing
   - **❌ Incorrect Guess**: Receive feedback (if easy mode) and continue with remaining attempts
   - **💀 Out of Attempts**: Game over, shows the correct answer

## 🔧 Compilation and Execution

### Compile
```bash
gcc -no-pie main.s -o guessing_game
```

### Run
```bash
./guessing_game
```

## 🚀 Example Gameplay

```
Enter configuration seed: 12345
Would you like to play in easy mode? (y/n) y
What is your guess? 5
Incorrect. Your guess was below the actual number ...
What is your guess? 8
Incorrect. Your guess was above the actual number ...
What is your guess? 7
Double or nothing! Would you like to continue to another round? (y/n) y
What is your guess? 15
Congratz! You won 2 rounds!
```

## ⚙️ Technical Details

### Data Structures
- `user_seed`: Seed for random number generation
- `random_number`: Current target number
- `user_guess`: Player's current guess
- `rounds_won`: Total rounds won by player
- `N`: Upper bound for random numbers (default: 10)
- `M`: Remaining attempts (default: 5)

### Key Functions
- `main`: Initializes and starts the game
- `play_game`: Main game loop
- `play_guess`: Handles individual guess attempts
- `easy_mode`: Provides hints in easy mode
- `double_or_nothing`: Handles round continuation logic
- `initialize_random_number`: Generates new random number
- `get_rand_number_under_N`: Returns random number in range [1, N]

## Game Logic

1. Player provides seed and chooses difficulty
2. Random number generated between 1 and N
3. Player makes guesses until:
   - Correct guess → Win round, option to continue
   - M attempts exhausted → Game over
4. If continuing after win:
   - N doubles
   - Seed doubles
   - M resets to 5
   - New random number generated

## Notes

- The game uses standard C library functions (`printf`, `scanf`, `srand`, `rand`)
- Assembly follows x86-64 calling conventions
- Input validation is minimal - expect valid integer/character inputs
