// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../models/tournament_match.dart';
// import '../../../providers/matches_provider.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/custom_styles.dart';
//
// class DeleteMatchDialog extends StatefulWidget {
//   DeleteMatchDialog(this.match);
//   final TournamentMatch match;
//   @override
//   _DeleteMatchDialogState createState() => _DeleteMatchDialogState();
// }
//
// class _DeleteMatchDialogState extends State<DeleteMatchDialog> {
//   bool tapped = false;
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: CustomColors.kMainColor,
//       title: Text(
//         "Seguro que desea eliminar este partido?",
//         style:
//             CustomStyles.kResultStyle.copyWith(color: CustomColors.kWhiteColor),
//       ),
//       actions: [
//         FlatButton(
//           child: Text(
//             "Cancelar",
//             style: TextStyle(color: Colors.grey),
//           ),
//           onPressed: () {
//             Navigator.of(context).pop(false);
//           },
//         ),
//         FlatButton(
//           child: Text(
//             tapped ? "Eliminando..." : "Eliminar",
//             style: TextStyle(
//               color: tapped ? Colors.grey : Colors.red,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           onPressed: tapped
//               ? null
//               : () {
//                   setState(() {
//                     tapped = true;
//                   });
//                   context
//                       .read<MatchesProvider>()
//                       .deleteMatch(context, widget.match.id)
//                       .then((value) => Navigator.of(context).pop(true));
//                 },
//         ),
//       ],
//     );
//   }
// }
