# stockalert_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Hot reload automatico (Windows + dispositivo fisico)

`flutter run` solo acepta `r`/`R` desde su stdin, y Windows no soporta las senales
`SIGUSR1`/`SIGUSR2` que usan los trucos de `--pid-file`. Por eso uso `flutter-w`, un
wrapper instalado globalmente que lanza `flutter run`, vigila el proyecto y escribe
`r` en su stdin al guardar:

```bash
flutter-w                              # dispositivo que elijas / unico conectado
flutter-w -d 192.168.1.129:33565
flutter-w -d "Pixel 7" --flavor staging
```

Funciona en cualquier proyecto Flutter: debe ejecutarse desde la raiz del proyecto
(donde esta `pubspec.yaml`), en otra terminal, mientras editas en Neovim.

- Cambios en `lib/**` o `test/**` -> hot reload (`r`).
- Cambios en `assets/**` o `pubspec.yaml` -> hot restart (`R`).
- `Ctrl+C` cierra la app y todos sus procesos.

La primera compilacion tarda lo normal; despues cada guardado recarga en ~1s.


