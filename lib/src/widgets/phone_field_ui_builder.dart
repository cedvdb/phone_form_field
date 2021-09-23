// import 'package:flutter/material.dart';

// import 'measure_initial_size.dart';

// class PrefixPhoneFieldBuilder {
//   Widget build(
//     BuildContext context,
//     Widget textField,
//     Widget dialCodeChip,
//     String? errorText,
//     Function selectCountry,
//   ) {
//     return Stack(
//       children: [
//         MeasureInitialSize(
//           onSizeFound: (size) => setState(() => _size = size),
//           child: InputDecorator(
//             isFocused: _focusNode.hasFocus,
//             isEmpty: _nationalNumberController.text == '',
//             decoration: widget.decoration.copyWith(
//               errorText: errorText,
//               // prefixIcon: Padding(
//               //   padding: const EdgeInsets.all(15),
//               //   child: _getDialCodeChip(),
//               // ),
//               prefix: dialCodeChip,
//               // icon: _getDialCodeChip(),
//               label: Text(''),
//             ),
//             child: textField,
//           ),
//         ),
//         // if (_focusNode.hasFocus) _inkWellOverlay(),
//       ],
//     );
//   }
// }
