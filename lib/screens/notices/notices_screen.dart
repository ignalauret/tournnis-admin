import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/notice.dart';
import 'package:tournnis_admin/providers/notices_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class NoticesScreen extends StatelessWidget {
  static const routeName = "/notices";
  void _addNotice(BuildContext context, bool isNotice) async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image == null) return;
    context
        .read<NoticesProvider>()
        .uploadNotice(path: image.path, isNotice: isNotice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Noticias",
          style: CustomStyles.kAppBarTitle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.kAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () => _addNotice(context, true),
                  padding: const EdgeInsets.all(20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Subir noticia",
                      style: CustomStyles.kResultStyle
                          .copyWith(color: CustomColors.kMainColor),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () => _addNotice(context, false),
                  padding: const EdgeInsets.all(20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Subir sponsor",
                      style: CustomStyles.kResultStyle
                          .copyWith(color: CustomColors.kMainColor),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Notice>>(
                future: context.watch<NoticesProvider>().notices,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) => GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: CustomColors.kBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.kCardBorderRadius),
                              ),
                              title: Text(
                                "Está seguro que desea eliminar esta noticia?",
                                style: CustomStyles.kNormalStyle,
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    "Cancelar",
                                    style: CustomStyles.kSubtitleStyle,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    context
                                        .read<NoticesProvider>()
                                        .deleteNotice(snapshot.data[index])
                                        .then(
                                          (value) =>
                                              Navigator.of(context).pop(),
                                        );
                                  },
                                  child: Text(
                                    "Eliminar",
                                    style: CustomStyles.kResultStyle.copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          child: Image.network(snapshot.data[index].url),
                        ),
                      ),
                      itemCount: snapshot.data.length,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
