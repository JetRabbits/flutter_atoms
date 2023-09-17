import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_atoms/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutCompanyPage extends StatelessWidget {
  final String companyName;

  final String? phone;

  final String? webSite;

  const AboutCompanyPage({Key? key, required this.companyName, this.phone, this.webSite})
      : super(key: key);

  List<Map<String, dynamic>> createInfo(BuildContext context) {
    List<Map<String, dynamic>> info = [
      {
        "icon": Icons.business_center,
        "subtitle": AtomsStrings.of(context).company,
        "title": companyName,
        "tap": (context) async {
          await Clipboard.setData(ClipboardData(text: companyName));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: AutoSizeText(AtomsStrings.of(context).copiedToClipboard),
          ));
        },
      },
      {
        "icon": Icons.phone,
        "subtitle": AtomsStrings.of(context).phone,
        "title": phone,
        "tap": (_) => launchUrl(Uri.parse("tel:$phone")),
      },
      {
        "icon": Icons.language,
        "subtitle": AtomsStrings.of(context).website,
        "title": webSite,
        "tap": (_) => launchUrl(Uri.parse(webSite!)),
      },
    ]..retainWhere((element) => element["title"] != null);
    return info;
  }

  @override
  Widget build(BuildContext context) {
    var info = createInfo(context);

    return Scaffold(
        appBar: AppBar(
          title: AutoSizeText(AtomsStrings.current.about_company),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.black, height: 10.0, thickness: 0.1),
                itemCount: info.length,
                itemBuilder: (context, index) => ListTile(
                      onTap: () => info[index]["tap"](context),
                      leading: Icon(info[index]["icon"]),
                      title: AutoSizeText(info[index]["title"]),
                      subtitle: AutoSizeText(info[index]["subtitle"]),
                    )),
          ),
        )));
  }
}
