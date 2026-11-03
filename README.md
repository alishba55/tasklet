# Toolify – Smart Toolbox

A beautifully designed Flutter app featuring 8 everyday utility tools, built with a strict design system using Riverpod 3.0 and GoRouter.

---

## ✨ Features

| Tool | Category | Description |
|---|---|---|
| BMI Calculator | Health | Body Mass Index with category feedback |
| Age Calculator | Chronology | Exact age from birthdate |
| Tip Calculator | Dining | Bill split + tip percent selector |
| Unit Converter | Metrics | 50+ units across 5 categories |
| Password Generator | Security | Configurable secure password generator |
| Discount Calculator | Shopping | Final price + savings from any discount |
| Loan Calculator | Finance | Monthly payment, total interest |
| Word Counter | Strings | Words, chars, sentences, reading time |

---

## 🏗️ Architecture

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       # All color tokens
│   │   ├── app_dimens.dart       # All spacing/sizing tokens
│   │   ├── app_strings.dart      # All user-facing strings
│   │   ├── app_routes.dart       # Route path constants
│   │   └── app_tools.dart        # Master tool registry
│   ├── models/
│   │   └── tool_item.dart        # ToolItem + ToolCategory
│   ├── router/
│   │   └── app_router.dart       # GoRouter configuration
│   ├── theme/
│   │   └── app_theme.dart        # MaterialTheme definition
│   └── widgets/
│       ├── app_shell.dart        # Bottom-nav shell (ShellRoute)
│       ├── toolify_top_bar.dart  # Logo + nav bar
│       ├── tool_card.dart        # Home grid card
│       ├── tool_screen_scaffold.dart  # Tool screen wrapper
│       ├── input_card.dart       # White shadow input field
│       ├── result_card.dart      # Result display card
│       └── primary_button.dart   # Full-width dark button
└── features/
    ├── home/                     # Home screen (tool grid)
    ├── favorites/                # Favorites screen + provider
    ├── bmi/
    ├── age_calculator/
    ├── tip_calculator/
    ├── unit_converter/
    ├── password_generator/
    ├── discount_calculator/
    ├── loan_calculator/
    └── word_counter/
```

Each feature folder follows:
```
feature_name/
├── presentation/
│   └── screens/
│       └── feature_screen.dart
└── providers/
    └── feature_provider.dart     # Riverpod Notifier
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.10.0
- Dart SDK ≥ 3.0.0

### Setup

```bash
# Clone / open the project
cd toolify

# Install dependencies
flutter pub get

# Generate Riverpod code (run once after setup)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Code Generation

Riverpod uses `riverpod_annotation` for type-safe providers. After modifying any provider file annotated with `@riverpod`, regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
# or watch for changes during development:
dart run build_runner watch --delete-conflicting-outputs
```

The generated `.g.dart` files are committed alongside their source files.

---

## 🎨 Design System

### Colors (`AppColors`)
| Token | Hex | Usage |
|---|---|---|
| `background` | `#F5F5F7` | Screen backgrounds |
| `primary` | `#1A1A2E` | Buttons, active nav, headings |
| `cardBackground` | `#FFFFFF` | All card surfaces |
| `textGrey` | `#9E9E9E` | Descriptions, labels |

Each of the 8 categories has a pastel `iconBgColor` and a saturated `labelColor`.

### Components
- **Cards** – white, `borderRadius: 16`, soft shadow (`elevation: 2–3`)
- **Buttons** – full-width, `height: 56`, `borderRadius: 12`, dark navy bg
- **Input fields** – white card with shadow, large bold value, grey label
- **Icons** – inside 40×40 pastel circle, icon size 20
- **Bottom nav** – white, 2 tabs (Home / Favorites)

---

## ➕ Adding a New Tool

1. Add a route constant to `AppRoutes`.
2. Create the feature folder under `lib/features/`.
3. Add a `ToolItem` entry to `AppTools.all` in `app_tools.dart`.
4. Register the `GoRoute` in `app_router.dart`.
5. Write the screen using `ToolScreenScaffold`, `InputCard`, `ResultCard`, and `PrimaryButton`.
6. Write the provider using `@riverpod class MyNotifier extends _$MyNotifier`.
7. Run `build_runner`.

That's it — the tool card and favorites toggle appear automatically.
