## 0.2.1
- Added nested coroutine support
- Fixed concurrent access issues (@luanpotter 💙)
- Added [Flame game engine](https://flame-engine.org/) example (@luanpotter 💙)
- Improved async tests (@luanpotter 💙)
- Improved CI & docgen tasks

## 0.2.0
- Added async coroutine support
- (**breaking!**) Removed `dart:coroutine/coroutine.dart` barrel import (use `dart:coroutines/sync.dart` or `dart:coroutines/async.dart` instead)
- Improved documentation

## 0.1.1

- Fixed coroutine instance not being removed after completion
- Implemented `isCoroutineRunning`
- Improved inlining


## 0.1.0

- Initial release
- Implemented synchronous coroutines
- Added tests
