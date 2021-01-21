import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/action_button.dart';
import '../../components/category_selector.dart';
import '../../components/text_data_card.dart';
import '../../models/tournament_match.dart';
import '../../providers/matches_provider.dart';
import '../../screens/select_player/select_player_screen.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

// class CreateMatchScreen extends StatefulWidget {
//   static const routeName = "/create-match";
//   @override
//   _CreateMatchScreenState createState() => _CreateMatchScreenState();
// }
//
// class _CreateMatchScreenState extends State<CreateMatchScreen> {
//   String pid1;
//   String pid2;
//   String name1;
//   String name2;
//   int selectedCategory = 1;
//   String tid;
//
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();
//
//   Future<void> _selectDate() async {
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2020, 8),
//       lastDate: DateTime(2101),
//       helpText: "Elegir fecha",
//       confirmText: "Confirmar",
//       cancelText: "Cancelar",
//     );
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//       });
//   }
//
//   Future<void> _selectTime() async {
//     TimeOfDay t = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//       helpText: "Elegir hora",
//       confirmText: "Confirmar",
//       cancelText: "Cancelar",
//     );
//     if (t != null)
//       setState(() {
//         selectedTime = t;
//       });
//   }
//
//   @override
//   void didChangeDependencies() {
//     tid = ModalRoute.of(context).settings.arguments;
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: CustomColors.kMainColor,
//       appBar: AppBar(
//         title: Text(
//           "Nuevo partido",
//           style: CustomStyles.kAppBarTitle,
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       CategorySelector(
//                         selectedCat: selectedCategory,
//                         select: (cat) {
//                           setState(() {
//                             selectedCategory = cat;
//                           });
//                         },
//                         options: [1, 2, 3],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Horario",
//                         style: CustomStyles.kTitleStyle,
//                       ),
//                       _buildDaySelector(),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Text(
//                         "Jugadores",
//                         style: CustomStyles.kTitleStyle,
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       TextDataCard(
//                         title: "Jugador 1",
//                         data: name1 == null ? "Seleccionar jugador" : name1,
//                         size: size,
//                         onTap: () {
//                           Navigator.of(context)
//                               .pushNamed(SelectPlayerScreen.routeName)
//                               .then(
//                             (value) {
//                               if (value == null) return;
//                               final Map<String, String> map = value;
//                               setState(() {
//                                 pid1 = map["id"];
//                                 name1 = map["name"];
//                               });
//                             },
//                           );
//                         },
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       TextDataCard(
//                         title: "Jugador 2",
//                         data: name2 == null ? "Seleccionar jugador" : name2,
//                         size: size,
//                         onTap: () {
//                           Navigator.of(context)
//                               .pushNamed(SelectPlayerScreen.routeName)
//                               .then(
//                             (value) {
//                               if (value == null) return;
//                               final Map<String, String> map = value;
//                               setState(() {
//                                 pid2 = map["id"];
//                                 name2 = map["name"];
//                               });
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               ActionButton(
//                 "Agregar",
//                 () {
//                   context
//                       .read<MatchesProvider>()
//                       .createMatch(
//                         TournamentMatch(
//                           pid1: pid1,
//                           pid2: pid2,
//                           result1: null,
//                           result2: null,
//                           date: DateTime(
//                               selectedDate.year,
//                               selectedDate.month,
//                               selectedDate.day,
//                               selectedTime.hour,
//                               selectedTime.minute),
//                           tid: tid,
//                           isPlayOff: false,
//                           category: selectedCategory,
//                         ),
//                       )
//                       .then((value) {
//                     Navigator.of(context).pop();
//                   });
//                 },
//                 enabled: pid1 != null && pid2 != null,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDaySelector() {
//     final size = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         TextDataCard(
//           title: "Dia",
//           data: DateFormat.MMMMEEEEd().format(selectedDate),
//           size: size,
//           onTap: _selectDate,
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         TextDataCard(
//           title: "Hora",
//           data: selectedTime.format(context),
//           size: size,
//           onTap: _selectTime,
//         ),
//       ],
//     );
//   }
// }
