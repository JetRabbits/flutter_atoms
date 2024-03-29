import 'package:collection/collection.dart' show IterableExtension;
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';

/// This is a extended message lookup mechanism that delegates to one of a collection
/// of individual [MessageLookupByLibrary] instances.
class BigCompositeMessageLookup implements MessageLookup {
  /// A mapped lists from locale names to the corresponding list of MessageLookupByLibrary.
  final Map<String, List<MessageLookupByLibrary>> availableMessages = {};

  /// Return true if we have a message lookup for [localeName].
  bool localeExists(localeName) => availableMessages.containsKey(localeName);

  /// The last locale in which we looked up messages.
  ///
  ///  If this locale matches the new one then we can skip looking up the
  ///  messages and assume they will be the same as last time.
  String? _lastLocale;

  /// Caches the last messages lookup libs that we found
  List<MessageLookupByLibrary>? _lastLookupLibs;

  /// Look up the message with the given [name] and [locale] and return the
  /// first translated version in all registered message libraries with the values in [args] interpolated.
  /// If nothing isfound, return the result of [ifAbsent] or [messageText].
  String? lookupMessage(String? messageText, String? locale, String? name,
      List<dynamic>? args, String? meaning,
      {MessageIfAbsent? ifAbsent}) {
    // If passed null, use the default.
    var knownLocale = locale ?? Intl.getCurrentLocale();
    List<MessageLookupByLibrary> messagesLibs = (knownLocale == _lastLocale)
        ? _lastLookupLibs!
        : _lookupMessageCatalog(knownLocale)!;

    var messages =
        messagesLibs.firstWhereOrNull((lib) => lib.messages.containsKey(name));

    if (messages == null) {
      return ifAbsent == null
          ? messageText
          : ifAbsent(messageText, args as List<Object>?);
    }
    return messages.lookupMessage(
        messageText, locale, name, args as List<Object>?, meaning,
        ifAbsent: ifAbsent);
  }

  List<MessageLookupByLibrary>? _lookupMessageCatalog(String locale) {
    var verifiedLocale = Intl.verifiedLocale(locale, localeExists,
        onFailure: (locale) => locale);
    _lastLocale = locale;
    _lastLookupLibs = availableMessages[verifiedLocale!];
    return _lastLookupLibs;
  }

  /// Register message library function [findLocale] by [localeName]
  /// When external l10n message source call this then [findLocale] is added to corresponed locale list
  /// So this creates the chain of message libraries function which can be lookup until appropriated lib will be found
  void addLocale(String localeName, Function findLocale) {
    var canonical = Intl.canonicalizedLocale(localeName);
    var newLocaleFunc = findLocale(canonical);
    if (newLocaleFunc != null) {
      availableMessages.putIfAbsent(localeName, () => [])..add(newLocaleFunc);
      availableMessages.putIfAbsent(canonical, () => [])..add(newLocaleFunc);
      if (_lastLocale == newLocaleFunc) {
        _lastLocale = null;
        _lastLookupLibs = null;
      }
    }
  }
}

///
/// Activates big composite message lookup mechanism
///
void initializeBigIntlMessageLookup() {
  messageLookup = BigCompositeMessageLookup();
}
