import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutter_atoms.dart';

class AboutApplicationPage extends StatefulWidget {
  final VersionModel version;

  final List<String> servers;

  final String supportEmail;

  final String supportSubject;

  final String supportEmailBody;

  const AboutApplicationPage({
    Key key,
    @required this.version,
    this.servers,
    this.supportEmail,
    this.supportSubject = "",
    this.supportEmailBody = "",
  }) : super(key: key);

  @override
  _AboutApplicationPageState createState() => _AboutApplicationPageState();
}

class _AboutApplicationPageState extends State<AboutApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(AtomsStrings.of(context).about_application),
      ),
      body: SingleChildScrollView(
          child: ListBody(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.apps),
            subtitle: AutoSizeText(widget.version.projectName),
            title:
                AutoSizeText(AtomsStrings.of(context).application_title_text),
          ),
          ListTile(
            leading: const Icon(Icons.devices),
            subtitle: AutoSizeText(widget.version.platformVersion),
            title: AutoSizeText(AtomsStrings.of(context).platform),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            subtitle: AutoSizeText(widget.version.projectAppID),
            title: const AutoSizeText('App ID'),
          ),
          ListTile(
            leading: const Icon(Icons.new_releases),
            subtitle: AutoSizeText(widget.version.projectVersion),
            title: AutoSizeText(AtomsStrings.of(context).version_name),
          ),
          ListTile(
            leading: const Icon(Icons.filter_9_plus),
            subtitle: AutoSizeText(widget.version.projectCode),
            title: AutoSizeText(AtomsStrings.of(context).build),
          ),
          if (widget.servers != null)
            Divider(
              height: 20.0,
            ),
          if (widget.servers != null)
            ListTile(
              leading: const Icon(Icons.public),
              subtitle: Column(
                  children: widget.servers
                      .map(
                        (e) => AutoSizeText(e),
                      )
                      .toList()),
              title: AutoSizeText(AtomsStrings.of(context).servers),
//todo: Сделать переход на страницу настроек
//              onTap: () => Navigator.of(context)
//                  .pushNamed(Constants.ROUTE_APPLICATION_SETTINGS_PAGE),
            ),
          if (widget.supportEmail != null)
            Divider(
              height: 20.0,
            ),

          if (widget.supportEmail != null)
            ListTile(
              leading: const Icon(Icons.email),
              subtitle: AutoSizeText(widget.supportEmail),
              title: AutoSizeText(AtomsStrings.of(context).contact_email),
              onTap: ()=> launch("mailto:${widget.supportEmail}?subject=${widget.supportSubject}&body=${widget.supportEmailBody}"),
            ),

          Divider(
            height: 20.0,
          ),
          ListTile(
            leading: const Icon(Icons.text_snippet),
            subtitle:
            AutoSizeText(AtomsStrings.of(context).license_agreement),
            title: AutoSizeText(AtomsStrings.of(context).license_agreement),
//              onTap: () => Navigator.of(context)
//                  .pushNamed(Constants.ROUTE_LICENSE_AGREEMENT_PAGE),
          ),
          ListTile(
              leading: const Icon(Icons.note),
              subtitle: AutoSizeText(
                AtomsStrings.of(context).thirdPartyLicenses,
              ),
              title: AutoSizeText(
                AtomsStrings.of(context).thirdPartyLicenses,
              ),
              onTap: () {
                showLicensePage(context: context);
              }),

        ],
      )),
    );
  }
}
