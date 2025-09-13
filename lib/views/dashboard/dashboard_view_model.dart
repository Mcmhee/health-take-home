// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class UserViewModel extends AsyncNotifier<User> {
//   @override
//   Future<User> build() async {
//     throw UnimplementedError("Call loadUser to fetch a user.");
//   }

//   Future<void> loadUser(int id) async {
//     state = const AsyncLoading();

//     try {
//       final json = await ApiService.instance.getUser(id);
//       final user = User.fromJson(json);
//       state = AsyncData(user);
//     } catch (e, st) {
//       state = AsyncError(e, st);
//     }
//   }
// }

// final userProvider = AsyncNotifierProvider<UserViewModel, User>(() {
//   return UserViewModel();
// });
