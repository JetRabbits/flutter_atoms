import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/generated/l10n.dart';

import '../flutter_atoms.dart';

class AboutApplicationPage extends StatelessWidget {
  final VersionModel version;

  final List<String> servers;

  final String supportEmail;

  const AboutApplicationPage({
    Key key,
    @required this.version,
    this.servers,
    this.supportEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AutoSizeText(AtomsStrings.current.about_application),
        ),
        body: SingleChildScrollView(
            child: ListBody(
          children: <Widget>[
            Container(
              height: 10.0,
            ),
            ListTile(
              leading: const Icon(Icons.apps),
              title: AutoSizeText(version.projectName),
              subtitle: AutoSizeText(AtomsStrings.of(context).application_title_text),
            ),
            Container(
              height: 10.0,
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: AutoSizeText(version.platformVersion),
              subtitle: AutoSizeText(AtomsStrings.of(context).platform),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              leading: const Icon(Icons.new_releases),
              title: AutoSizeText(version.projectVersion),
              subtitle: AutoSizeText(AtomsStrings.of(context).version_name),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              leading: const Icon(Icons.filter_9_plus),
              title: AutoSizeText(version.projectCode),
              subtitle: AutoSizeText(AtomsStrings.of(context).build),
            ),
            if (servers != null)
              ListTile(
                leading: const Icon(Icons.public),
                title: Column(
                    children: servers
                        .map(
                          (e) => AutoSizeText(e),
                        )
                        .toList()),
                subtitle: AutoSizeText(AtomsStrings.of(context).servers),
//todo: Сделать переход на страницу настроек
//              onTap: () => Navigator.of(context)
//                  .pushNamed(Constants.ROUTE_APPLICATION_SETTINGS_PAGE),
              ),
            if (servers != null)
              Divider(
                height: 20.0,
              ),
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: AutoSizeText(AtomsStrings.of(context).license_agreement),
              subtitle: AutoSizeText(AtomsStrings.of(context).license_agreement),
//              onTap: () => Navigator.of(context)
//                  .pushNamed(Constants.ROUTE_LICENSE_AGREEMENT_PAGE),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              leading: const Icon(Icons.shop),
              title: AutoSizeText(version.projectAppID),
              subtitle: const AutoSizeText('App ID'),
            ),
            Divider(
              height: 20.0,
            ),
            if (supportEmail != null)
              ListTile(
                leading: const Icon(Icons.email),
                title: AutoSizeText(supportEmail),
                subtitle: AutoSizeText(AtomsStrings.of(context).contact_email),
              ),
            if (supportEmail != null) Divider(),
            ListTile(
                leading: const Icon(Icons.note),
                title: AutoSizeText(
                  AtomsStrings.of(context).thirdPartyLicenses,
                ),
                onTap: () {
                  showLicensePage(context: context);
                }),
          ],
        )));
  }
}
