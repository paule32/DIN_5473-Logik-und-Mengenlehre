// automated created - all data will be lost on next run !

// --------------------------------------------------------------------
// \file   helpndoc.pas
// \autor  (c) 2025 by Jens Kallup - paule32
// \copy   all rights reserved.
//
// \detail Read-in an existing Microsoft HTML-Workshop *.hhc file, and
//         extract the topics, generate a HelpNDoc.com Pascal Engine
//         ready Skript for running in/with the Script-Editor.
//         Currently the Text (the Topic Caption's) must occured in
//         numbering like "1. Caption" or "1.1.1. Sub-Caption"
//
// \param  nothing - the Pascal File is created automatically.
// \param  toc.hhc - the HTML Help Chapters (for read-in in Python).
//         The Path to this file must be adjusted.
// \param  TopicTemplate.htm - the HTML Template File that is inserted
//         into the created Topic (Editor). Currently the toc.hhc is
//         assumed in the same directory as this Python Script.
// \param  ProjectName - the name of the Project, default.hnd.  
//
// \return HelpNDoc.com compatible TOC Pascal file - HelpNDocPasFile.
//         Currently assumed in the same Directory as this Python Script
//
// \error  On Error, the User will be informed with the context deepend
//         Error Information's.
// --------------------------------------------------------------------
const HelpNDocTemplateHTM = 'template.htm';
const HelpNDocProjectName = 'default.hnd';
const HelpNDocProjectPath = 'F:\Bücher\projects\DIN_5473\tools';

// --------------------------------------------------------------------
// [End of User Space]
// --------------------------------------------------------------------

type
  TThema = class(TObject)
    Caption: String;
    TopicLevel: Integer;
    TopicID: String;
  end;

const MAX_TOPICS = 1024;
var Thema: Array [0..MAX_TOPICS] of TThema;
var toplist: THndTopicsInfoArray;

function GetLevel(const nummerierterTitel: String): Integer;
var
  i, count: Integer;
begin
  count := 0;
  for i := 1 to Length(nummerierterTitel) do
    if nummerierterTitel[i] = '.' then
    Inc(count);
  Result := count;
end;

function ExtractTitel(const nummerierterTitel: String): String;
var
  posSpace: Integer;
begin
  // -------------------------------------
  // find white space after numbering ...
  // -------------------------------------
  posSpace := Pos(' ', nummerierterTitel);
  if posSpace > 0 then
    Result := Copy(nummerierterTitel, posSpace + 1, Length(nummerierterTitel))
  else
    // --------------------
    // if no white space...
    // --------------------
    Result := nummerierterTitel;
end;

// ---------------------------------------------------------------------------
// calculates the indent level of the numbering TOC String
// ---------------------------------------------------------------------------
function GetLevelFromTOCString(const TOCString: String): Integer;
var
  i, count: Integer;
begin
  count := 0;
  // ---------------------------
  // count dot's to get level...
  // ---------------------------
  for i := 1 to Length(TOCString) do
  if TOCString[i] = '.' then
  Inc(count);

  // ------------------------------
  // count of dot's is indent level
  // ------------------------------
  Result := count;
end;

procedure CreateTableOfContents;
var i, p, g: Integer;
var ThemenEditor: TObject;
var ThemenPage  : TStringList;
var ThemenListe : TStringList;
begin
  toplist := HndTopics.GetTopicList(false);
  
  ThemenListe := TStringList.Create;
  ThemenPage  := TStringList.Create;
  
  try
    print('1. pre-processing data...');
    ThemenPage.LoadFromFile(HelpNDocTemplateHTM);
    
    ThemenEditor := HndEditor.CreateTemporaryEditor;
    HndEditorHelper.CleanContent   (ThemenEditor);
    HndEditor.InsertContentFromHTML(ThemenEditor, ThemenPage.Text);
    // Thema 1: Lizenz - Bitte lesen !!!
    Thema[0] := TThema.Create;
    Thema[0].Caption := 'Lizenz - Bitte lesen !!!';
    Thema[0].TopicID := HndTopics.CreateTopic;
    Thema[0].TopicLevel := GetLevel(Thema[0].Caption);
    ThemenListe.AddObject('Topic0', Thema[0]);
    HndEditor.SetAsTopicContent(aEditor, Thema[0].TopicID);
    // Thema 2: Überblich
    Thema[1] := TThema.Create;
    Thema[1].Caption := 'Überblich';
    Thema[1].TopicID := HndTopics.CreateTopic;
    Thema[1].TopicLevel := GetLevel(Thema[1].Caption);
    ThemenListe.AddObject('Topic1', Thema[1]);
    HndEditor.SetAsTopicContent(aEditor, Thema[1].TopicID);
    // Thema 3: Inhalt
    Thema[2] := TThema.Create;
    Thema[2].Caption := 'Inhalt';
    Thema[2].TopicID := HndTopics.CreateTopic;
    Thema[2].TopicLevel := GetLevel(Thema[2].Caption);
    ThemenListe.AddObject('Topic2', Thema[2]);
    HndEditor.SetAsTopicContent(aEditor, Thema[2].TopicID);
    // Thema 4: Liste der Tabellen
    Thema[3] := TThema.Create;
    Thema[3].Caption := 'Liste der Tabellen';
    Thema[3].TopicID := HndTopics.CreateTopic;
    Thema[3].TopicLevel := GetLevel(Thema[3].Caption);
    ThemenListe.AddObject('Topic3', Thema[3]);
    HndEditor.SetAsTopicContent(aEditor, Thema[3].TopicID);
    // Thema 5: Über dieses Handbuch
    Thema[4] := TThema.Create;
    Thema[4].Caption := 'Über dieses Handbuch';
    Thema[4].TopicID := HndTopics.CreateTopic;
    Thema[4].TopicLevel := GetLevel(Thema[4].Caption);
    ThemenListe.AddObject('Topic4', Thema[4]);
    HndEditor.SetAsTopicContent(aEditor, Thema[4].TopicID);
    // Thema 6: Bezeichnungen
    Thema[5] := TThema.Create;
    Thema[5].Caption := 'Bezeichnungen';
    Thema[5].TopicID := HndTopics.CreateTopic;
    Thema[5].TopicLevel := GetLevel(Thema[5].Caption);
    ThemenListe.AddObject('Topic5', Thema[5]);
    HndEditor.SetAsTopicContent(aEditor, Thema[5].TopicID);
    // Thema 7: Syntax Diagramme
    Thema[6] := TThema.Create;
    Thema[6].Caption := 'Syntax Diagramme';
    Thema[6].TopicID := HndTopics.CreateTopic;
    Thema[6].TopicLevel := GetLevel(Thema[6].Caption);
    ThemenListe.AddObject('Topic6', Thema[6]);
    HndEditor.SetAsTopicContent(aEditor, Thema[6].TopicID);
    // Thema 8: Über die Sprache Pascal
    Thema[7] := TThema.Create;
    Thema[7].Caption := 'Über die Sprache Pascal';
    Thema[7].TopicID := HndTopics.CreateTopic;
    Thema[7].TopicLevel := GetLevel(Thema[7].Caption);
    ThemenListe.AddObject('Topic7', Thema[7]);
    HndEditor.SetAsTopicContent(aEditor, Thema[7].TopicID);
    // Thema 9: 1.  Pascal Zeichen und Symbole
    Thema[8] := TThema.Create;
    Thema[8].Caption := '1.  Pascal Zeichen und Symbole';
    Thema[8].TopicID := HndTopics.CreateTopic;
    Thema[8].TopicLevel := GetLevel(Thema[8].Caption);
    ThemenListe.AddObject('Topic8', Thema[8]);
    HndEditor.SetAsTopicContent(aEditor, Thema[8].TopicID);
    // Thema 10: 1.1  Symbole
    Thema[9] := TThema.Create;
    Thema[9].Caption := '1.1  Symbole';
    Thema[9].TopicID := HndTopics.CreateTopic;
    Thema[9].TopicLevel := GetLevel(Thema[9].Caption);
    ThemenListe.AddObject('Topic9', Thema[9]);
    HndEditor.SetAsTopicContent(aEditor, Thema[9].TopicID);
    // Thema 11: 1.2  Kommentare
    Thema[10] := TThema.Create;
    Thema[10].Caption := '1.2  Kommentare';
    Thema[10].TopicID := HndTopics.CreateTopic;
    Thema[10].TopicLevel := GetLevel(Thema[10].Caption);
    ThemenListe.AddObject('Topic10', Thema[10]);
    HndEditor.SetAsTopicContent(aEditor, Thema[10].TopicID);
    // Thema 12: 1.3  Reservierte Schlüsselwörter
    Thema[11] := TThema.Create;
    Thema[11].Caption := '1.3  Reservierte Schlüsselwörter';
    Thema[11].TopicID := HndTopics.CreateTopic;
    Thema[11].TopicLevel := GetLevel(Thema[11].Caption);
    ThemenListe.AddObject('Topic11', Thema[11]);
    HndEditor.SetAsTopicContent(aEditor, Thema[11].TopicID);
    // Thema 13: 1.3.1.  Turbo Pascal
    Thema[12] := TThema.Create;
    Thema[12].Caption := '1.3.1.  Turbo Pascal';
    Thema[12].TopicID := HndTopics.CreateTopic;
    Thema[12].TopicLevel := GetLevel(Thema[12].Caption);
    ThemenListe.AddObject('Topic12', Thema[12]);
    HndEditor.SetAsTopicContent(aEditor, Thema[12].TopicID);
    // Thema 14: 1.3.2.  Object Pascal
    Thema[13] := TThema.Create;
    Thema[13].Caption := '1.3.2.  Object Pascal';
    Thema[13].TopicID := HndTopics.CreateTopic;
    Thema[13].TopicLevel := GetLevel(Thema[13].Caption);
    ThemenListe.AddObject('Topic13', Thema[13]);
    HndEditor.SetAsTopicContent(aEditor, Thema[13].TopicID);
    // Thema 15: 1.3.3.  Modifikationen
    Thema[14] := TThema.Create;
    Thema[14].Caption := '1.3.3.  Modifikationen';
    Thema[14].TopicID := HndTopics.CreateTopic;
    Thema[14].TopicLevel := GetLevel(Thema[14].Caption);
    ThemenListe.AddObject('Topic14', Thema[14]);
    HndEditor.SetAsTopicContent(aEditor, Thema[14].TopicID);
    // Thema 16: 1.4.  Kennzeichnungen
    Thema[15] := TThema.Create;
    Thema[15].Caption := '1.4.  Kennzeichnungen';
    Thema[15].TopicID := HndTopics.CreateTopic;
    Thema[15].TopicLevel := GetLevel(Thema[15].Caption);
    ThemenListe.AddObject('Topic15', Thema[15]);
    HndEditor.SetAsTopicContent(aEditor, Thema[15].TopicID);
    // Thema 17: 1.5.  Hinweise und Direktiven
    Thema[16] := TThema.Create;
    Thema[16].Caption := '1.5.  Hinweise und Direktiven';
    Thema[16].TopicID := HndTopics.CreateTopic;
    Thema[16].TopicLevel := GetLevel(Thema[16].Caption);
    ThemenListe.AddObject('Topic16', Thema[16]);
    HndEditor.SetAsTopicContent(aEditor, Thema[16].TopicID);
    // Thema 18: 1.6.  Zahlen
    Thema[17] := TThema.Create;
    Thema[17].Caption := '1.6.  Zahlen';
    Thema[17].TopicID := HndTopics.CreateTopic;
    Thema[17].TopicLevel := GetLevel(Thema[17].Caption);
    ThemenListe.AddObject('Topic17', Thema[17]);
    HndEditor.SetAsTopicContent(aEditor, Thema[17].TopicID);
    // Thema 19: 1.7.  Bezeichner
    Thema[18] := TThema.Create;
    Thema[18].Caption := '1.7.  Bezeichner';
    Thema[18].TopicID := HndTopics.CreateTopic;
    Thema[18].TopicLevel := GetLevel(Thema[18].Caption);
    ThemenListe.AddObject('Topic18', Thema[18]);
    HndEditor.SetAsTopicContent(aEditor, Thema[18].TopicID);
    // Thema 20: 1.8.  Zeichenketten
    Thema[19] := TThema.Create;
    Thema[19].Caption := '1.8.  Zeichenketten';
    Thema[19].TopicID := HndTopics.CreateTopic;
    Thema[19].TopicLevel := GetLevel(Thema[19].Caption);
    ThemenListe.AddObject('Topic19', Thema[19]);
    HndEditor.SetAsTopicContent(aEditor, Thema[19].TopicID);
    // Thema 21: 2.  Konstanten
    Thema[20] := TThema.Create;
    Thema[20].Caption := '2.  Konstanten';
    Thema[20].TopicID := HndTopics.CreateTopic;
    Thema[20].TopicLevel := GetLevel(Thema[20].Caption);
    ThemenListe.AddObject('Topic20', Thema[20]);
    HndEditor.SetAsTopicContent(aEditor, Thema[20].TopicID);
    // Thema 22: 2.1.  Gewöhnliche Konstanten
    Thema[21] := TThema.Create;
    Thema[21].Caption := '2.1.  Gewöhnliche Konstanten';
    Thema[21].TopicID := HndTopics.CreateTopic;
    Thema[21].TopicLevel := GetLevel(Thema[21].Caption);
    ThemenListe.AddObject('Topic21', Thema[21]);
    HndEditor.SetAsTopicContent(aEditor, Thema[21].TopicID);
    // Thema 23: 2.2.  Typisierte Konstanten
    Thema[22] := TThema.Create;
    Thema[22].Caption := '2.2.  Typisierte Konstanten';
    Thema[22].TopicID := HndTopics.CreateTopic;
    Thema[22].TopicLevel := GetLevel(Thema[22].Caption);
    ThemenListe.AddObject('Topic22', Thema[22]);
    HndEditor.SetAsTopicContent(aEditor, Thema[22].TopicID);
    // Thema 24: 2.3.  Resourcen Zeichenketten
    Thema[23] := TThema.Create;
    Thema[23].Caption := '2.3.  Resourcen Zeichenketten';
    Thema[23].TopicID := HndTopics.CreateTopic;
    Thema[23].TopicLevel := GetLevel(Thema[23].Caption);
    ThemenListe.AddObject('Topic23', Thema[23]);
    HndEditor.SetAsTopicContent(aEditor, Thema[23].TopicID);
    // Thema 25: 3.  Typen
    Thema[24] := TThema.Create;
    Thema[24].Caption := '3.  Typen';
    Thema[24].TopicID := HndTopics.CreateTopic;
    Thema[24].TopicLevel := GetLevel(Thema[24].Caption);
    ThemenListe.AddObject('Topic24', Thema[24]);
    HndEditor.SetAsTopicContent(aEditor, Thema[24].TopicID);
    // Thema 26: 3.1.  Basistypen
    Thema[25] := TThema.Create;
    Thema[25].Caption := '3.1.  Basistypen';
    Thema[25].TopicID := HndTopics.CreateTopic;
    Thema[25].TopicLevel := GetLevel(Thema[25].Caption);
    ThemenListe.AddObject('Topic25', Thema[25]);
    HndEditor.SetAsTopicContent(aEditor, Thema[25].TopicID);
    // Thema 27: 3.1.1.  Ordinale Typen
    Thema[26] := TThema.Create;
    Thema[26].Caption := '3.1.1.  Ordinale Typen';
    Thema[26].TopicID := HndTopics.CreateTopic;
    Thema[26].TopicLevel := GetLevel(Thema[26].Caption);
    ThemenListe.AddObject('Topic26', Thema[26]);
    HndEditor.SetAsTopicContent(aEditor, Thema[26].TopicID);
    // Thema 28: 3.1.2.  Ganze Zahlen (Integer)
    Thema[27] := TThema.Create;
    Thema[27].Caption := '3.1.2.  Ganze Zahlen (Integer)';
    Thema[27].TopicID := HndTopics.CreateTopic;
    Thema[27].TopicLevel := GetLevel(Thema[27].Caption);
    ThemenListe.AddObject('Topic27', Thema[27]);
    HndEditor.SetAsTopicContent(aEditor, Thema[27].TopicID);
    // Thema 29: 3.1.3.  Boolesche Typen
    Thema[28] := TThema.Create;
    Thema[28].Caption := '3.1.3.  Boolesche Typen';
    Thema[28].TopicID := HndTopics.CreateTopic;
    Thema[28].TopicLevel := GetLevel(Thema[28].Caption);
    ThemenListe.AddObject('Topic28', Thema[28]);
    HndEditor.SetAsTopicContent(aEditor, Thema[28].TopicID);
    // Thema 30: 3.1.4.  Aufzählungen
    Thema[29] := TThema.Create;
    Thema[29].Caption := '3.1.4.  Aufzählungen';
    Thema[29].TopicID := HndTopics.CreateTopic;
    Thema[29].TopicLevel := GetLevel(Thema[29].Caption);
    ThemenListe.AddObject('Topic29', Thema[29]);
    HndEditor.SetAsTopicContent(aEditor, Thema[29].TopicID);
    // Thema 31: 3.1.5.  Untermengen
    Thema[30] := TThema.Create;
    Thema[30].Caption := '3.1.5.  Untermengen';
    Thema[30].TopicID := HndTopics.CreateTopic;
    Thema[30].TopicLevel := GetLevel(Thema[30].Caption);
    ThemenListe.AddObject('Topic30', Thema[30]);
    HndEditor.SetAsTopicContent(aEditor, Thema[30].TopicID);
    // Thema 32: 3.1.6.  Zeichen
    Thema[31] := TThema.Create;
    Thema[31].Caption := '3.1.6.  Zeichen';
    Thema[31].TopicID := HndTopics.CreateTopic;
    Thema[31].TopicLevel := GetLevel(Thema[31].Caption);
    ThemenListe.AddObject('Topic31', Thema[31]);
    HndEditor.SetAsTopicContent(aEditor, Thema[31].TopicID);
    // Thema 33: 3.2.  Zeichen-Typen
    Thema[32] := TThema.Create;
    Thema[32].Caption := '3.2.  Zeichen-Typen';
    Thema[32].TopicID := HndTopics.CreateTopic;
    Thema[32].TopicLevel := GetLevel(Thema[32].Caption);
    ThemenListe.AddObject('Topic32', Thema[32]);
    HndEditor.SetAsTopicContent(aEditor, Thema[32].TopicID);
    // Thema 34: 3.2.1.  Char oder AnsiChar
    Thema[33] := TThema.Create;
    Thema[33].Caption := '3.2.1.  Char oder AnsiChar';
    Thema[33].TopicID := HndTopics.CreateTopic;
    Thema[33].TopicLevel := GetLevel(Thema[33].Caption);
    ThemenListe.AddObject('Topic33', Thema[33]);
    HndEditor.SetAsTopicContent(aEditor, Thema[33].TopicID);
    // Thema 35: 3.2.2.  WideChar
    Thema[34] := TThema.Create;
    Thema[34].Caption := '3.2.2.  WideChar';
    Thema[34].TopicID := HndTopics.CreateTopic;
    Thema[34].TopicLevel := GetLevel(Thema[34].Caption);
    ThemenListe.AddObject('Topic34', Thema[34]);
    HndEditor.SetAsTopicContent(aEditor, Thema[34].TopicID);
    // Thema 36: 3.2.3.  Sonstige
    Thema[35] := TThema.Create;
    Thema[35].Caption := '3.2.3.  Sonstige';
    Thema[35].TopicID := HndTopics.CreateTopic;
    Thema[35].TopicLevel := GetLevel(Thema[35].Caption);
    ThemenListe.AddObject('Topic35', Thema[35]);
    HndEditor.SetAsTopicContent(aEditor, Thema[35].TopicID);
    // Thema 37: 3.2.4.  Einzel-Byte Zeichenketten
    Thema[36] := TThema.Create;
    Thema[36].Caption := '3.2.4.  Einzel-Byte Zeichenketten';
    Thema[36].TopicID := HndTopics.CreateTopic;
    Thema[36].TopicLevel := GetLevel(Thema[36].Caption);
    ThemenListe.AddObject('Topic36', Thema[36]);
    HndEditor.SetAsTopicContent(aEditor, Thema[36].TopicID);
    // Thema 38: 3.2.4.1.  ShortString
    Thema[37] := TThema.Create;
    Thema[37].Caption := '3.2.4.1.  ShortString';
    Thema[37].TopicID := HndTopics.CreateTopic;
    Thema[37].TopicLevel := GetLevel(Thema[37].Caption);
    ThemenListe.AddObject('Topic37', Thema[37]);
    HndEditor.SetAsTopicContent(aEditor, Thema[37].TopicID);
    // Thema 39: 3.2.4.2.  AnsiString
    Thema[38] := TThema.Create;
    Thema[38].Caption := '3.2.4.2.  AnsiString';
    Thema[38].TopicID := HndTopics.CreateTopic;
    Thema[38].TopicLevel := GetLevel(Thema[38].Caption);
    ThemenListe.AddObject('Topic38', Thema[38]);
    HndEditor.SetAsTopicContent(aEditor, Thema[38].TopicID);
    // Thema 40: 3.2.4.3.  Zeichen-Code Umwandlung
    Thema[39] := TThema.Create;
    Thema[39].Caption := '3.2.4.3.  Zeichen-Code Umwandlung';
    Thema[39].TopicID := HndTopics.CreateTopic;
    Thema[39].TopicLevel := GetLevel(Thema[39].Caption);
    ThemenListe.AddObject('Topic39', Thema[39]);
    HndEditor.SetAsTopicContent(aEditor, Thema[39].TopicID);
    // Thema 41: 3.2.4.4.  RawByteString
    Thema[40] := TThema.Create;
    Thema[40].Caption := '3.2.4.4.  RawByteString';
    Thema[40].TopicID := HndTopics.CreateTopic;
    Thema[40].TopicLevel := GetLevel(Thema[40].Caption);
    ThemenListe.AddObject('Topic40', Thema[40]);
    HndEditor.SetAsTopicContent(aEditor, Thema[40].TopicID);
    // Thema 42: 3.2.4.5.  UTF8String
    Thema[41] := TThema.Create;
    Thema[41].Caption := '3.2.4.5.  UTF8String';
    Thema[41].TopicID := HndTopics.CreateTopic;
    Thema[41].TopicLevel := GetLevel(Thema[41].Caption);
    ThemenListe.AddObject('Topic41', Thema[41]);
    HndEditor.SetAsTopicContent(aEditor, Thema[41].TopicID);
    // Thema 43: 3.2.5.  Multi-Byte Zeichenketten
    Thema[42] := TThema.Create;
    Thema[42].Caption := '3.2.5.  Multi-Byte Zeichenketten';
    Thema[42].TopicID := HndTopics.CreateTopic;
    Thema[42].TopicLevel := GetLevel(Thema[42].Caption);
    ThemenListe.AddObject('Topic42', Thema[42]);
    HndEditor.SetAsTopicContent(aEditor, Thema[42].TopicID);
    // Thema 44: 3.2.5.1.  UnicodeString
    Thema[43] := TThema.Create;
    Thema[43].Caption := '3.2.5.1.  UnicodeString';
    Thema[43].TopicID := HndTopics.CreateTopic;
    Thema[43].TopicLevel := GetLevel(Thema[43].Caption);
    ThemenListe.AddObject('Topic43', Thema[43]);
    HndEditor.SetAsTopicContent(aEditor, Thema[43].TopicID);
    // Thema 45: 3.2.5.2.  WideString
    Thema[44] := TThema.Create;
    Thema[44].Caption := '3.2.5.2.  WideString';
    Thema[44].TopicID := HndTopics.CreateTopic;
    Thema[44].TopicLevel := GetLevel(Thema[44].Caption);
    ThemenListe.AddObject('Topic44', Thema[44]);
    HndEditor.SetAsTopicContent(aEditor, Thema[44].TopicID);
    // Thema 46: 3.2.6.  Konstante Zeichenketten
    Thema[45] := TThema.Create;
    Thema[45].Caption := '3.2.6.  Konstante Zeichenketten';
    Thema[45].TopicID := HndTopics.CreateTopic;
    Thema[45].TopicLevel := GetLevel(Thema[45].Caption);
    ThemenListe.AddObject('Topic45', Thema[45]);
    HndEditor.SetAsTopicContent(aEditor, Thema[45].TopicID);
    // Thema 47: 3.2.7.  Nullterminierente Zeichenketten (PChar)
    Thema[46] := TThema.Create;
    Thema[46].Caption := '3.2.7.  Nullterminierente Zeichenketten (PChar)';
    Thema[46].TopicID := HndTopics.CreateTopic;
    Thema[46].TopicLevel := GetLevel(Thema[46].Caption);
    ThemenListe.AddObject('Topic46', Thema[46]);
    HndEditor.SetAsTopicContent(aEditor, Thema[46].TopicID);
    // Thema 48: 3.2.8.  Zeichenketten-Größen
    Thema[47] := TThema.Create;
    Thema[47].Caption := '3.2.8.  Zeichenketten-Größen';
    Thema[47].TopicID := HndTopics.CreateTopic;
    Thema[47].TopicLevel := GetLevel(Thema[47].Caption);
    ThemenListe.AddObject('Topic47', Thema[47]);
    HndEditor.SetAsTopicContent(aEditor, Thema[47].TopicID);
    // Thema 49: 3.3.  Strukturierte Typen
    Thema[48] := TThema.Create;
    Thema[48].Caption := '3.3.  Strukturierte Typen';
    Thema[48].TopicID := HndTopics.CreateTopic;
    Thema[48].TopicLevel := GetLevel(Thema[48].Caption);
    ThemenListe.AddObject('Topic48', Thema[48]);
    HndEditor.SetAsTopicContent(aEditor, Thema[48].TopicID);
    // Thema 50: 3.3.1.  Gepackte Struktur-Typen
    Thema[49] := TThema.Create;
    Thema[49].Caption := '3.3.1.  Gepackte Struktur-Typen';
    Thema[49].TopicID := HndTopics.CreateTopic;
    Thema[49].TopicLevel := GetLevel(Thema[49].Caption);
    ThemenListe.AddObject('Topic49', Thema[49]);
    HndEditor.SetAsTopicContent(aEditor, Thema[49].TopicID);
    // Thema 51: 3.3.2.  Array''s
    Thema[50] := TThema.Create;
    Thema[50].Caption := '3.3.2.  Array''s';
    Thema[50].TopicID := HndTopics.CreateTopic;
    Thema[50].TopicLevel := GetLevel(Thema[50].Caption);
    ThemenListe.AddObject('Topic50', Thema[50]);
    HndEditor.SetAsTopicContent(aEditor, Thema[50].TopicID);
    // Thema 52: 3.3.2.1.  Statische Array''s
    Thema[51] := TThema.Create;
    Thema[51].Caption := '3.3.2.1.  Statische Array''s';
    Thema[51].TopicID := HndTopics.CreateTopic;
    Thema[51].TopicLevel := GetLevel(Thema[51].Caption);
    ThemenListe.AddObject('Topic51', Thema[51]);
    HndEditor.SetAsTopicContent(aEditor, Thema[51].TopicID);
    // Thema 53: 3.3.2.2.  Dynamische Array''s
    Thema[52] := TThema.Create;
    Thema[52].Caption := '3.3.2.2.  Dynamische Array''s';
    Thema[52].TopicID := HndTopics.CreateTopic;
    Thema[52].TopicLevel := GetLevel(Thema[52].Caption);
    ThemenListe.AddObject('Topic52', Thema[52]);
    HndEditor.SetAsTopicContent(aEditor, Thema[52].TopicID);
    // Thema 54: 3.3.2.3:  Typen-Kompatibilität dynamischer Array''s
    Thema[53] := TThema.Create;
    Thema[53].Caption := '3.3.2.3:  Typen-Kompatibilität dynamischer Array''s';
    Thema[53].TopicID := HndTopics.CreateTopic;
    Thema[53].TopicLevel := GetLevel(Thema[53].Caption);
    ThemenListe.AddObject('Topic53', Thema[53]);
    HndEditor.SetAsTopicContent(aEditor, Thema[53].TopicID);
    // Thema 55: 3.3.2.4.  Constuctor dynamischer Array''s
    Thema[54] := TThema.Create;
    Thema[54].Caption := '3.3.2.4.  Constuctor dynamischer Array''s';
    Thema[54].TopicID := HndTopics.CreateTopic;
    Thema[54].TopicLevel := GetLevel(Thema[54].Caption);
    ThemenListe.AddObject('Topic54', Thema[54]);
    HndEditor.SetAsTopicContent(aEditor, Thema[54].TopicID);
    // Thema 56: 3.3.2.5.  Feldkonstanten-Ausdrücke dynamiscer Array''s
    Thema[55] := TThema.Create;
    Thema[55].Caption := '3.3.2.5.  Feldkonstanten-Ausdrücke dynamiscer Array''s';
    Thema[55].TopicID := HndTopics.CreateTopic;
    Thema[55].TopicLevel := GetLevel(Thema[55].Caption);
    ThemenListe.AddObject('Topic55', Thema[55]);
    HndEditor.SetAsTopicContent(aEditor, Thema[55].TopicID);
    // Thema 57: 3.3.2.6.  Packen und Entpacken eines Array''s
    Thema[56] := TThema.Create;
    Thema[56].Caption := '3.3.2.6.  Packen und Entpacken eines Array''s';
    Thema[56].TopicID := HndTopics.CreateTopic;
    Thema[56].TopicLevel := GetLevel(Thema[56].Caption);
    ThemenListe.AddObject('Topic56', Thema[56]);
    HndEditor.SetAsTopicContent(aEditor, Thema[56].TopicID);
    // Thema 58: 3.3.3.  Record''s
    Thema[57] := TThema.Create;
    Thema[57].Caption := '3.3.3.  Record''s';
    Thema[57].TopicID := HndTopics.CreateTopic;
    Thema[57].TopicLevel := GetLevel(Thema[57].Caption);
    ThemenListe.AddObject('Topic57', Thema[57]);
    HndEditor.SetAsTopicContent(aEditor, Thema[57].TopicID);
    // Thema 59: 3.3.3.1.  Layout und Größe
    Thema[58] := TThema.Create;
    Thema[58].Caption := '3.3.3.1.  Layout und Größe';
    Thema[58].TopicID := HndTopics.CreateTopic;
    Thema[58].TopicLevel := GetLevel(Thema[58].Caption);
    ThemenListe.AddObject('Topic58', Thema[58]);
    HndEditor.SetAsTopicContent(aEditor, Thema[58].TopicID);
    // Thema 60: 3.3.3.2.  Bemerkungen und Beispiele
    Thema[59] := TThema.Create;
    Thema[59].Caption := '3.3.3.2.  Bemerkungen und Beispiele';
    Thema[59].TopicID := HndTopics.CreateTopic;
    Thema[59].TopicLevel := GetLevel(Thema[59].Caption);
    ThemenListe.AddObject('Topic59', Thema[59]);
    HndEditor.SetAsTopicContent(aEditor, Thema[59].TopicID);
    // Thema 61: 3.3.4.  Mengen-Typen
    Thema[60] := TThema.Create;
    Thema[60].Caption := '3.3.4.  Mengen-Typen';
    Thema[60].TopicID := HndTopics.CreateTopic;
    Thema[60].TopicLevel := GetLevel(Thema[60].Caption);
    ThemenListe.AddObject('Topic60', Thema[60]);
    HndEditor.SetAsTopicContent(aEditor, Thema[60].TopicID);
    // Thema 62: 3.3.5.  Datei-Typen
    Thema[61] := TThema.Create;
    Thema[61].Caption := '3.3.5.  Datei-Typen';
    Thema[61].TopicID := HndTopics.CreateTopic;
    Thema[61].TopicLevel := GetLevel(Thema[61].Caption);
    ThemenListe.AddObject('Topic61', Thema[61]);
    HndEditor.SetAsTopicContent(aEditor, Thema[61].TopicID);
    // Thema 63: 3.4.  Zeiger
    Thema[62] := TThema.Create;
    Thema[62].Caption := '3.4.  Zeiger';
    Thema[62].TopicID := HndTopics.CreateTopic;
    Thema[62].TopicLevel := GetLevel(Thema[62].Caption);
    ThemenListe.AddObject('Topic62', Thema[62]);
    HndEditor.SetAsTopicContent(aEditor, Thema[62].TopicID);
    // Thema 64: 3.5.  Forward-Deklarationen
    Thema[63] := TThema.Create;
    Thema[63].Caption := '3.5.  Forward-Deklarationen';
    Thema[63].TopicID := HndTopics.CreateTopic;
    Thema[63].TopicLevel := GetLevel(Thema[63].Caption);
    ThemenListe.AddObject('Topic63', Thema[63]);
    HndEditor.SetAsTopicContent(aEditor, Thema[63].TopicID);
    // Thema 65: 3.6.  Prozedur-Typen
    Thema[64] := TThema.Create;
    Thema[64].Caption := '3.6.  Prozedur-Typen';
    Thema[64].TopicID := HndTopics.CreateTopic;
    Thema[64].TopicLevel := GetLevel(Thema[64].Caption);
    ThemenListe.AddObject('Topic64', Thema[64]);
    HndEditor.SetAsTopicContent(aEditor, Thema[64].TopicID);
    // Thema 66: 3.7.  Variant''s
    Thema[65] := TThema.Create;
    Thema[65].Caption := '3.7.  Variant''s';
    Thema[65].TopicID := HndTopics.CreateTopic;
    Thema[65].TopicLevel := GetLevel(Thema[65].Caption);
    ThemenListe.AddObject('Topic65', Thema[65]);
    HndEditor.SetAsTopicContent(aEditor, Thema[65].TopicID);
    // Thema 67: 3.7.1.  Definition
    Thema[66] := TThema.Create;
    Thema[66].Caption := '3.7.1.  Definition';
    Thema[66].TopicID := HndTopics.CreateTopic;
    Thema[66].TopicLevel := GetLevel(Thema[66].Caption);
    ThemenListe.AddObject('Topic66', Thema[66]);
    HndEditor.SetAsTopicContent(aEditor, Thema[66].TopicID);
    // Thema 68: 3.7.2.  Variant''s in Zuweisungen und Ausdrücken
    Thema[67] := TThema.Create;
    Thema[67].Caption := '3.7.2.  Variant''s in Zuweisungen und Ausdrücken';
    Thema[67].TopicID := HndTopics.CreateTopic;
    Thema[67].TopicLevel := GetLevel(Thema[67].Caption);
    ThemenListe.AddObject('Topic67', Thema[67]);
    HndEditor.SetAsTopicContent(aEditor, Thema[67].TopicID);
    // Thema 69: 3.7.3.  Variant''s im Interface-Teil
    Thema[68] := TThema.Create;
    Thema[68].Caption := '3.7.3.  Variant''s im Interface-Teil';
    Thema[68].TopicID := HndTopics.CreateTopic;
    Thema[68].TopicLevel := GetLevel(Thema[68].Caption);
    ThemenListe.AddObject('Topic68', Thema[68]);
    HndEditor.SetAsTopicContent(aEditor, Thema[68].TopicID);
    // Thema 70: 3.8.  Alias-Typen
    Thema[69] := TThema.Create;
    Thema[69].Caption := '3.8.  Alias-Typen';
    Thema[69].TopicID := HndTopics.CreateTopic;
    Thema[69].TopicLevel := GetLevel(Thema[69].Caption);
    ThemenListe.AddObject('Topic69', Thema[69]);
    HndEditor.SetAsTopicContent(aEditor, Thema[69].TopicID);
    // Thema 71: 3.9.  Verwaltete Typen
    Thema[70] := TThema.Create;
    Thema[70].Caption := '3.9.  Verwaltete Typen';
    Thema[70].TopicID := HndTopics.CreateTopic;
    Thema[70].TopicLevel := GetLevel(Thema[70].Caption);
    ThemenListe.AddObject('Topic70', Thema[70]);
    HndEditor.SetAsTopicContent(aEditor, Thema[70].TopicID);
    // Thema 72: 4.  Variablen
    Thema[71] := TThema.Create;
    Thema[71].Caption := '4.  Variablen';
    Thema[71].TopicID := HndTopics.CreateTopic;
    Thema[71].TopicLevel := GetLevel(Thema[71].Caption);
    ThemenListe.AddObject('Topic71', Thema[71]);
    HndEditor.SetAsTopicContent(aEditor, Thema[71].TopicID);
    // Thema 73: 4.1.  Definition
    Thema[72] := TThema.Create;
    Thema[72].Caption := '4.1.  Definition';
    Thema[72].TopicID := HndTopics.CreateTopic;
    Thema[72].TopicLevel := GetLevel(Thema[72].Caption);
    ThemenListe.AddObject('Topic72', Thema[72]);
    HndEditor.SetAsTopicContent(aEditor, Thema[72].TopicID);
    // Thema 74: 4.2.  Erklärung
    Thema[73] := TThema.Create;
    Thema[73].Caption := '4.2.  Erklärung';
    Thema[73].TopicID := HndTopics.CreateTopic;
    Thema[73].TopicLevel := GetLevel(Thema[73].Caption);
    ThemenListe.AddObject('Topic73', Thema[73]);
    HndEditor.SetAsTopicContent(aEditor, Thema[73].TopicID);
    // Thema 75: 4.3.  Geltungssbereich
    Thema[74] := TThema.Create;
    Thema[74].Caption := '4.3.  Geltungssbereich';
    Thema[74].TopicID := HndTopics.CreateTopic;
    Thema[74].TopicLevel := GetLevel(Thema[74].Caption);
    ThemenListe.AddObject('Topic74', Thema[74]);
    HndEditor.SetAsTopicContent(aEditor, Thema[74].TopicID);
    // Thema 76: 4.4.  Initialisierte Variablen
    Thema[75] := TThema.Create;
    Thema[75].Caption := '4.4.  Initialisierte Variablen';
    Thema[75].TopicID := HndTopics.CreateTopic;
    Thema[75].TopicLevel := GetLevel(Thema[75].Caption);
    ThemenListe.AddObject('Topic75', Thema[75]);
    HndEditor.SetAsTopicContent(aEditor, Thema[75].TopicID);
    // Thema 77: 4.5.  Initialisierte Variablen mit Standard-Wert
    Thema[76] := TThema.Create;
    Thema[76].Caption := '4.5.  Initialisierte Variablen mit Standard-Wert';
    Thema[76].TopicID := HndTopics.CreateTopic;
    Thema[76].TopicLevel := GetLevel(Thema[76].Caption);
    ThemenListe.AddObject('Topic76', Thema[76]);
    HndEditor.SetAsTopicContent(aEditor, Thema[76].TopicID);
    // Thema 78: 4.6.  Thread-Variablen
    Thema[77] := TThema.Create;
    Thema[77].Caption := '4.6.  Thread-Variablen';
    Thema[77].TopicID := HndTopics.CreateTopic;
    Thema[77].TopicLevel := GetLevel(Thema[77].Caption);
    ThemenListe.AddObject('Topic77', Thema[77]);
    HndEditor.SetAsTopicContent(aEditor, Thema[77].TopicID);
    // Thema 79: 4.7.  Eigenschaften
    Thema[78] := TThema.Create;
    Thema[78].Caption := '4.7.  Eigenschaften';
    Thema[78].TopicID := HndTopics.CreateTopic;
    Thema[78].TopicLevel := GetLevel(Thema[78].Caption);
    ThemenListe.AddObject('Topic78', Thema[78]);
    HndEditor.SetAsTopicContent(aEditor, Thema[78].TopicID);
    // Thema 80: 5.  Objekte
    Thema[79] := TThema.Create;
    Thema[79].Caption := '5.  Objekte';
    Thema[79].TopicID := HndTopics.CreateTopic;
    Thema[79].TopicLevel := GetLevel(Thema[79].Caption);
    ThemenListe.AddObject('Topic79', Thema[79]);
    HndEditor.SetAsTopicContent(aEditor, Thema[79].TopicID);
    // Thema 81: 5.1.  Deklaration
    Thema[80] := TThema.Create;
    Thema[80].Caption := '5.1.  Deklaration';
    Thema[80].TopicID := HndTopics.CreateTopic;
    Thema[80].TopicLevel := GetLevel(Thema[80].Caption);
    ThemenListe.AddObject('Topic80', Thema[80]);
    HndEditor.SetAsTopicContent(aEditor, Thema[80].TopicID);
    // Thema 82: 5.2.  Abtrakte und Sealed Objekte
    Thema[81] := TThema.Create;
    Thema[81].Caption := '5.2.  Abtrakte und Sealed Objekte';
    Thema[81].TopicID := HndTopics.CreateTopic;
    Thema[81].TopicLevel := GetLevel(Thema[81].Caption);
    ThemenListe.AddObject('Topic81', Thema[81]);
    HndEditor.SetAsTopicContent(aEditor, Thema[81].TopicID);
    // Thema 83: 5.3.  Felder
    Thema[82] := TThema.Create;
    Thema[82].Caption := '5.3.  Felder';
    Thema[82].TopicID := HndTopics.CreateTopic;
    Thema[82].TopicLevel := GetLevel(Thema[82].Caption);
    ThemenListe.AddObject('Topic82', Thema[82]);
    HndEditor.SetAsTopicContent(aEditor, Thema[82].TopicID);
    // Thema 84: 5.4.  Klassen oder statische Felder
    Thema[83] := TThema.Create;
    Thema[83].Caption := '5.4.  Klassen oder statische Felder';
    Thema[83].TopicID := HndTopics.CreateTopic;
    Thema[83].TopicLevel := GetLevel(Thema[83].Caption);
    ThemenListe.AddObject('Topic83', Thema[83]);
    HndEditor.SetAsTopicContent(aEditor, Thema[83].TopicID);
    // Thema 85: 5.5.  Constructor und Destructor
    Thema[84] := TThema.Create;
    Thema[84].Caption := '5.5.  Constructor und Destructor';
    Thema[84].TopicID := HndTopics.CreateTopic;
    Thema[84].TopicLevel := GetLevel(Thema[84].Caption);
    ThemenListe.AddObject('Topic84', Thema[84]);
    HndEditor.SetAsTopicContent(aEditor, Thema[84].TopicID);
    // Thema 86: 5.6.  Methoden
    Thema[85] := TThema.Create;
    Thema[85].Caption := '5.6.  Methoden';
    Thema[85].TopicID := HndTopics.CreateTopic;
    Thema[85].TopicLevel := GetLevel(Thema[85].Caption);
    ThemenListe.AddObject('Topic85', Thema[85]);
    HndEditor.SetAsTopicContent(aEditor, Thema[85].TopicID);
    // Thema 87: 5.6.1.  Erklärung
    Thema[86] := TThema.Create;
    Thema[86].Caption := '5.6.1.  Erklärung';
    Thema[86].TopicID := HndTopics.CreateTopic;
    Thema[86].TopicLevel := GetLevel(Thema[86].Caption);
    ThemenListe.AddObject('Topic86', Thema[86]);
    HndEditor.SetAsTopicContent(aEditor, Thema[86].TopicID);
    // Thema 88: 5.6.2.  Methoden-Aufruf
    Thema[87] := TThema.Create;
    Thema[87].Caption := '5.6.2.  Methoden-Aufruf';
    Thema[87].TopicID := HndTopics.CreateTopic;
    Thema[87].TopicLevel := GetLevel(Thema[87].Caption);
    ThemenListe.AddObject('Topic87', Thema[87]);
    HndEditor.SetAsTopicContent(aEditor, Thema[87].TopicID);
    // Thema 89: 5.6.2.1.  Statische Methoden
    Thema[88] := TThema.Create;
    Thema[88].Caption := '5.6.2.1.  Statische Methoden';
    Thema[88].TopicID := HndTopics.CreateTopic;
    Thema[88].TopicLevel := GetLevel(Thema[88].Caption);
    ThemenListe.AddObject('Topic88', Thema[88]);
    HndEditor.SetAsTopicContent(aEditor, Thema[88].TopicID);
    // Thema 90: 5.6.2.2.  Virtuelle Methoden
    Thema[89] := TThema.Create;
    Thema[89].Caption := '5.6.2.2.  Virtuelle Methoden';
    Thema[89].TopicID := HndTopics.CreateTopic;
    Thema[89].TopicLevel := GetLevel(Thema[89].Caption);
    ThemenListe.AddObject('Topic89', Thema[89]);
    HndEditor.SetAsTopicContent(aEditor, Thema[89].TopicID);
    // Thema 91: 5.6.2.3.  Abstrakte Methoden
    Thema[90] := TThema.Create;
    Thema[90].Caption := '5.6.2.3.  Abstrakte Methoden';
    Thema[90].TopicID := HndTopics.CreateTopic;
    Thema[90].TopicLevel := GetLevel(Thema[90].Caption);
    ThemenListe.AddObject('Topic90', Thema[90]);
    HndEditor.SetAsTopicContent(aEditor, Thema[90].TopicID);
    // Thema 92: 5.6.2.4.  Klassen-Methoden oder statische Methoden
    Thema[91] := TThema.Create;
    Thema[91].Caption := '5.6.2.4.  Klassen-Methoden oder statische Methoden';
    Thema[91].TopicID := HndTopics.CreateTopic;
    Thema[91].TopicLevel := GetLevel(Thema[91].Caption);
    ThemenListe.AddObject('Topic91', Thema[91]);
    HndEditor.SetAsTopicContent(aEditor, Thema[91].TopicID);
    // Thema 93: 5.7.  Sichtbarkeit
    Thema[92] := TThema.Create;
    Thema[92].Caption := '5.7.  Sichtbarkeit';
    Thema[92].TopicID := HndTopics.CreateTopic;
    Thema[92].TopicLevel := GetLevel(Thema[92].Caption);
    ThemenListe.AddObject('Topic92', Thema[92]);
    HndEditor.SetAsTopicContent(aEditor, Thema[92].TopicID);
    // Thema 94: 6.  Klassen
    Thema[93] := TThema.Create;
    Thema[93].Caption := '6.  Klassen';
    Thema[93].TopicID := HndTopics.CreateTopic;
    Thema[93].TopicLevel := GetLevel(Thema[93].Caption);
    ThemenListe.AddObject('Topic93', Thema[93]);
    HndEditor.SetAsTopicContent(aEditor, Thema[93].TopicID);
    // Thema 95: 6.1.  Klassen-Definitionen
    Thema[94] := TThema.Create;
    Thema[94].Caption := '6.1.  Klassen-Definitionen';
    Thema[94].TopicID := HndTopics.CreateTopic;
    Thema[94].TopicLevel := GetLevel(Thema[94].Caption);
    ThemenListe.AddObject('Topic94', Thema[94]);
    HndEditor.SetAsTopicContent(aEditor, Thema[94].TopicID);
    // Thema 96: 6.2.  Abstrakte und Sealed Klassen
    Thema[95] := TThema.Create;
    Thema[95].Caption := '6.2.  Abstrakte und Sealed Klassen';
    Thema[95].TopicID := HndTopics.CreateTopic;
    Thema[95].TopicLevel := GetLevel(Thema[95].Caption);
    ThemenListe.AddObject('Topic95', Thema[95]);
    HndEditor.SetAsTopicContent(aEditor, Thema[95].TopicID);
    // Thema 97: 6.3.  Normale und statische Felder
    Thema[96] := TThema.Create;
    Thema[96].Caption := '6.3.  Normale und statische Felder';
    Thema[96].TopicID := HndTopics.CreateTopic;
    Thema[96].TopicLevel := GetLevel(Thema[96].Caption);
    ThemenListe.AddObject('Topic96', Thema[96]);
    HndEditor.SetAsTopicContent(aEditor, Thema[96].TopicID);
    // Thema 98: 6.3.1.  Normalisierte Felder / Variablen
    Thema[97] := TThema.Create;
    Thema[97].Caption := '6.3.1.  Normalisierte Felder / Variablen';
    Thema[97].TopicID := HndTopics.CreateTopic;
    Thema[97].TopicLevel := GetLevel(Thema[97].Caption);
    ThemenListe.AddObject('Topic97', Thema[97]);
    HndEditor.SetAsTopicContent(aEditor, Thema[97].TopicID);
    // Thema 99: 6.3.2.  Klassen-Felder / Variablen
    Thema[98] := TThema.Create;
    Thema[98].Caption := '6.3.2.  Klassen-Felder / Variablen';
    Thema[98].TopicID := HndTopics.CreateTopic;
    Thema[98].TopicLevel := GetLevel(Thema[98].Caption);
    ThemenListe.AddObject('Topic98', Thema[98]);
    HndEditor.SetAsTopicContent(aEditor, Thema[98].TopicID);
    // Thema 100: 6.4.  Klassen - CTOR (constructor)
    Thema[99] := TThema.Create;
    Thema[99].Caption := '6.4.  Klassen - CTOR (constructor)';
    Thema[99].TopicID := HndTopics.CreateTopic;
    Thema[99].TopicLevel := GetLevel(Thema[99].Caption);
    ThemenListe.AddObject('Topic99', Thema[99]);
    HndEditor.SetAsTopicContent(aEditor, Thema[99].TopicID);
    // Thema 101: 6.5.  Klassen - DTOR (destructor)
    Thema[100] := TThema.Create;
    Thema[100].Caption := '6.5.  Klassen - DTOR (destructor)';
    Thema[100].TopicID := HndTopics.CreateTopic;
    Thema[100].TopicLevel := GetLevel(Thema[100].Caption);
    ThemenListe.AddObject('Topic100', Thema[100]);
    HndEditor.SetAsTopicContent(aEditor, Thema[100].TopicID);
    // Thema 102: 6.6.  Methoden
    Thema[101] := TThema.Create;
    Thema[101].Caption := '6.6.  Methoden';
    Thema[101].TopicID := HndTopics.CreateTopic;
    Thema[101].TopicLevel := GetLevel(Thema[101].Caption);
    ThemenListe.AddObject('Topic101', Thema[101]);
    HndEditor.SetAsTopicContent(aEditor, Thema[101].TopicID);
    // Thema 103: 6.6.1.  Erklärung
    Thema[102] := TThema.Create;
    Thema[102].Caption := '6.6.1.  Erklärung';
    Thema[102].TopicID := HndTopics.CreateTopic;
    Thema[102].TopicLevel := GetLevel(Thema[102].Caption);
    ThemenListe.AddObject('Topic102', Thema[102]);
    HndEditor.SetAsTopicContent(aEditor, Thema[102].TopicID);
    // Thema 104: 6.6.2.  Aufrufen
    Thema[103] := TThema.Create;
    Thema[103].Caption := '6.6.2.  Aufrufen';
    Thema[103].TopicID := HndTopics.CreateTopic;
    Thema[103].TopicLevel := GetLevel(Thema[103].Caption);
    ThemenListe.AddObject('Topic103', Thema[103]);
    HndEditor.SetAsTopicContent(aEditor, Thema[103].TopicID);
    // Thema 105: 6.6.3.  Virtuelle Methoden
    Thema[104] := TThema.Create;
    Thema[104].Caption := '6.6.3.  Virtuelle Methoden';
    Thema[104].TopicID := HndTopics.CreateTopic;
    Thema[104].TopicLevel := GetLevel(Thema[104].Caption);
    ThemenListe.AddObject('Topic104', Thema[104]);
    HndEditor.SetAsTopicContent(aEditor, Thema[104].TopicID);
    // Thema 106: 6.6.4.  Klassen - Methoden
    Thema[105] := TThema.Create;
    Thema[105].Caption := '6.6.4.  Klassen - Methoden';
    Thema[105].TopicID := HndTopics.CreateTopic;
    Thema[105].TopicLevel := GetLevel(Thema[105].Caption);
    ThemenListe.AddObject('Topic105', Thema[105]);
    HndEditor.SetAsTopicContent(aEditor, Thema[105].TopicID);
    // Thema 107: 6.6.5.  Klassen CTOR und DTOR
    Thema[106] := TThema.Create;
    Thema[106].Caption := '6.6.5.  Klassen CTOR und DTOR';
    Thema[106].TopicID := HndTopics.CreateTopic;
    Thema[106].TopicLevel := GetLevel(Thema[106].Caption);
    ThemenListe.AddObject('Topic106', Thema[106]);
    HndEditor.SetAsTopicContent(aEditor, Thema[106].TopicID);
    // Thema 108: 6.6.6.  Statische Klassen - Methoden
    Thema[107] := TThema.Create;
    Thema[107].Caption := '6.6.6.  Statische Klassen - Methoden';
    Thema[107].TopicID := HndTopics.CreateTopic;
    Thema[107].TopicLevel := GetLevel(Thema[107].Caption);
    ThemenListe.AddObject('Topic107', Thema[107]);
    HndEditor.SetAsTopicContent(aEditor, Thema[107].TopicID);
    // Thema 109: 6.6.7.  Nachrichten - Methoden
    Thema[108] := TThema.Create;
    Thema[108].Caption := '6.6.7.  Nachrichten - Methoden';
    Thema[108].TopicID := HndTopics.CreateTopic;
    Thema[108].TopicLevel := GetLevel(Thema[108].Caption);
    ThemenListe.AddObject('Topic108', Thema[108]);
    HndEditor.SetAsTopicContent(aEditor, Thema[108].TopicID);
    // Thema 110: 6.6.8.  Vererbung
    Thema[109] := TThema.Create;
    Thema[109].Caption := '6.6.8.  Vererbung';
    Thema[109].TopicID := HndTopics.CreateTopic;
    Thema[109].TopicLevel := GetLevel(Thema[109].Caption);
    ThemenListe.AddObject('Topic109', Thema[109]);
    HndEditor.SetAsTopicContent(aEditor, Thema[109].TopicID);
    // Thema 111: 6.7.  Eigenschaften
    Thema[110] := TThema.Create;
    Thema[110].Caption := '6.7.  Eigenschaften';
    Thema[110].TopicID := HndTopics.CreateTopic;
    Thema[110].TopicLevel := GetLevel(Thema[110].Caption);
    ThemenListe.AddObject('Topic110', Thema[110]);
    HndEditor.SetAsTopicContent(aEditor, Thema[110].TopicID);
    // Thema 112: 6.7.1.  Definition
    Thema[111] := TThema.Create;
    Thema[111].Caption := '6.7.1.  Definition';
    Thema[111].TopicID := HndTopics.CreateTopic;
    Thema[111].TopicLevel := GetLevel(Thema[111].Caption);
    ThemenListe.AddObject('Topic111', Thema[111]);
    HndEditor.SetAsTopicContent(aEditor, Thema[111].TopicID);
    // Thema 113: 6.7.2.  Indezierte Eigenschaften
    Thema[112] := TThema.Create;
    Thema[112].Caption := '6.7.2.  Indezierte Eigenschaften';
    Thema[112].TopicID := HndTopics.CreateTopic;
    Thema[112].TopicLevel := GetLevel(Thema[112].Caption);
    ThemenListe.AddObject('Topic112', Thema[112]);
    HndEditor.SetAsTopicContent(aEditor, Thema[112].TopicID);
    // Thema 114: 6.7.3.  Array basierte Eigenschaften
    Thema[113] := TThema.Create;
    Thema[113].Caption := '6.7.3.  Array basierte Eigenschaften';
    Thema[113].TopicID := HndTopics.CreateTopic;
    Thema[113].TopicLevel := GetLevel(Thema[113].Caption);
    ThemenListe.AddObject('Topic113', Thema[113]);
    HndEditor.SetAsTopicContent(aEditor, Thema[113].TopicID);
    // Thema 115: 6.7.4.  Standard - Eigenschaften (public)
    Thema[114] := TThema.Create;
    Thema[114].Caption := '6.7.4.  Standard - Eigenschaften (public)';
    Thema[114].TopicID := HndTopics.CreateTopic;
    Thema[114].TopicLevel := GetLevel(Thema[114].Caption);
    ThemenListe.AddObject('Topic114', Thema[114]);
    HndEditor.SetAsTopicContent(aEditor, Thema[114].TopicID);
    // Thema 116: 6.7.5.  Veröffentlichte - Eigenschaften (published)
    Thema[115] := TThema.Create;
    Thema[115].Caption := '6.7.5.  Veröffentlichte - Eigenschaften (published)';
    Thema[115].TopicID := HndTopics.CreateTopic;
    Thema[115].TopicLevel := GetLevel(Thema[115].Caption);
    ThemenListe.AddObject('Topic115', Thema[115]);
    HndEditor.SetAsTopicContent(aEditor, Thema[115].TopicID);
    // Thema 117: 6.7.6.  Speicherinformationen
    Thema[116] := TThema.Create;
    Thema[116].Caption := '6.7.6.  Speicherinformationen';
    Thema[116].TopicID := HndTopics.CreateTopic;
    Thema[116].TopicLevel := GetLevel(Thema[116].Caption);
    ThemenListe.AddObject('Topic116', Thema[116]);
    HndEditor.SetAsTopicContent(aEditor, Thema[116].TopicID);
    // Thema 118: 6.7.7.  Eigenschaften überschreiben und neu deklarieren
    Thema[117] := TThema.Create;
    Thema[117].Caption := '6.7.7.  Eigenschaften überschreiben und neu deklarieren';
    Thema[117].TopicID := HndTopics.CreateTopic;
    Thema[117].TopicLevel := GetLevel(Thema[117].Caption);
    ThemenListe.AddObject('Topic117', Thema[117]);
    HndEditor.SetAsTopicContent(aEditor, Thema[117].TopicID);
    // Thema 119: 6.8.  Klassen - Eigenschaften
    Thema[118] := TThema.Create;
    Thema[118].Caption := '6.8.  Klassen - Eigenschaften';
    Thema[118].TopicID := HndTopics.CreateTopic;
    Thema[118].TopicLevel := GetLevel(Thema[118].Caption);
    ThemenListe.AddObject('Topic118', Thema[118]);
    HndEditor.SetAsTopicContent(aEditor, Thema[118].TopicID);
    // Thema 120: 6.9.  Verschachtelte Typen, Konstanten, und Variablen
    Thema[119] := TThema.Create;
    Thema[119].Caption := '6.9.  Verschachtelte Typen, Konstanten, und Variablen';
    Thema[119].TopicID := HndTopics.CreateTopic;
    Thema[119].TopicLevel := GetLevel(Thema[119].Caption);
    ThemenListe.AddObject('Topic119', Thema[119]);
    HndEditor.SetAsTopicContent(aEditor, Thema[119].TopicID);
    // Thema 121: 7.  Schnittstellen (Interface''s)
    Thema[120] := TThema.Create;
    Thema[120].Caption := '7.  Schnittstellen (Interface''s)';
    Thema[120].TopicID := HndTopics.CreateTopic;
    Thema[120].TopicLevel := GetLevel(Thema[120].Caption);
    ThemenListe.AddObject('Topic120', Thema[120]);
    HndEditor.SetAsTopicContent(aEditor, Thema[120].TopicID);
    // Thema 122: 7.1.  Definition
    Thema[121] := TThema.Create;
    Thema[121].Caption := '7.1.  Definition';
    Thema[121].TopicID := HndTopics.CreateTopic;
    Thema[121].TopicLevel := GetLevel(Thema[121].Caption);
    ThemenListe.AddObject('Topic121', Thema[121]);
    HndEditor.SetAsTopicContent(aEditor, Thema[121].TopicID);
    // Thema 123: 7.2.  Identifikation
    Thema[122] := TThema.Create;
    Thema[122].Caption := '7.2.  Identifikation';
    Thema[122].TopicID := HndTopics.CreateTopic;
    Thema[122].TopicLevel := GetLevel(Thema[122].Caption);
    ThemenListe.AddObject('Topic122', Thema[122]);
    HndEditor.SetAsTopicContent(aEditor, Thema[122].TopicID);
    // Thema 124: 7.3.  Implementierung
    Thema[123] := TThema.Create;
    Thema[123].Caption := '7.3.  Implementierung';
    Thema[123].TopicID := HndTopics.CreateTopic;
    Thema[123].TopicLevel := GetLevel(Thema[123].Caption);
    ThemenListe.AddObject('Topic123', Thema[123]);
    HndEditor.SetAsTopicContent(aEditor, Thema[123].TopicID);
    // Thema 125: 7.4.  Vererbung
    Thema[124] := TThema.Create;
    Thema[124].Caption := '7.4.  Vererbung';
    Thema[124].TopicID := HndTopics.CreateTopic;
    Thema[124].TopicLevel := GetLevel(Thema[124].Caption);
    ThemenListe.AddObject('Topic124', Thema[124]);
    HndEditor.SetAsTopicContent(aEditor, Thema[124].TopicID);
    // Thema 126: 7.5.  Delegation
    Thema[125] := TThema.Create;
    Thema[125].Caption := '7.5.  Delegation';
    Thema[125].TopicID := HndTopics.CreateTopic;
    Thema[125].TopicLevel := GetLevel(Thema[125].Caption);
    ThemenListe.AddObject('Topic125', Thema[125]);
    HndEditor.SetAsTopicContent(aEditor, Thema[125].TopicID);
    // Thema 127: 7.6.  COM
    Thema[126] := TThema.Create;
    Thema[126].Caption := '7.6.  COM';
    Thema[126].TopicID := HndTopics.CreateTopic;
    Thema[126].TopicLevel := GetLevel(Thema[126].Caption);
    ThemenListe.AddObject('Topic126', Thema[126]);
    HndEditor.SetAsTopicContent(aEditor, Thema[126].TopicID);
    // Thema 128: 7.7.  CORBA und andere Schnittstellen
    Thema[127] := TThema.Create;
    Thema[127].Caption := '7.7.  CORBA und andere Schnittstellen';
    Thema[127].TopicID := HndTopics.CreateTopic;
    Thema[127].TopicLevel := GetLevel(Thema[127].Caption);
    ThemenListe.AddObject('Topic127', Thema[127]);
    HndEditor.SetAsTopicContent(aEditor, Thema[127].TopicID);
    // Thema 129: 7.8.  Referenzzählung
    Thema[128] := TThema.Create;
    Thema[128].Caption := '7.8.  Referenzzählung';
    Thema[128].TopicID := HndTopics.CreateTopic;
    Thema[128].TopicLevel := GetLevel(Thema[128].Caption);
    ThemenListe.AddObject('Topic128', Thema[128]);
    HndEditor.SetAsTopicContent(aEditor, Thema[128].TopicID);
    // Thema 130: 8.  Generics
    Thema[129] := TThema.Create;
    Thema[129].Caption := '8.  Generics';
    Thema[129].TopicID := HndTopics.CreateTopic;
    Thema[129].TopicLevel := GetLevel(Thema[129].Caption);
    ThemenListe.AddObject('Topic129', Thema[129]);
    HndEditor.SetAsTopicContent(aEditor, Thema[129].TopicID);
    // Thema 131: 8.1.  Einführung
    Thema[130] := TThema.Create;
    Thema[130].Caption := '8.1.  Einführung';
    Thema[130].TopicID := HndTopics.CreateTopic;
    Thema[130].TopicLevel := GetLevel(Thema[130].Caption);
    ThemenListe.AddObject('Topic130', Thema[130]);
    HndEditor.SetAsTopicContent(aEditor, Thema[130].TopicID);
    // Thema 132: 8.2.  Get''ter Typ - Definition
    Thema[131] := TThema.Create;
    Thema[131].Caption := '8.2.  Get''ter Typ - Definition';
    Thema[131].TopicID := HndTopics.CreateTopic;
    Thema[131].TopicLevel := GetLevel(Thema[131].Caption);
    ThemenListe.AddObject('Topic131', Thema[131]);
    HndEditor.SetAsTopicContent(aEditor, Thema[131].TopicID);
    // Thema 133: 8.3.  Typen - Spezialisierung
    Thema[132] := TThema.Create;
    Thema[132].Caption := '8.3.  Typen - Spezialisierung';
    Thema[132].TopicID := HndTopics.CreateTopic;
    Thema[132].TopicLevel := GetLevel(Thema[132].Caption);
    ThemenListe.AddObject('Topic132', Thema[132]);
    HndEditor.SetAsTopicContent(aEditor, Thema[132].TopicID);
    // Thema 134: 8.4.  Einschränkungen
    Thema[133] := TThema.Create;
    Thema[133].Caption := '8.4.  Einschränkungen';
    Thema[133].TopicID := HndTopics.CreateTopic;
    Thema[133].TopicLevel := GetLevel(Thema[133].Caption);
    ThemenListe.AddObject('Topic133', Thema[133]);
    HndEditor.SetAsTopicContent(aEditor, Thema[133].TopicID);
    // Thema 135: 8.5.  Kompatibilität zu Delphi
    Thema[134] := TThema.Create;
    Thema[134].Caption := '8.5.  Kompatibilität zu Delphi';
    Thema[134].TopicID := HndTopics.CreateTopic;
    Thema[134].TopicLevel := GetLevel(Thema[134].Caption);
    ThemenListe.AddObject('Topic134', Thema[134]);
    HndEditor.SetAsTopicContent(aEditor, Thema[134].TopicID);
    // Thema 136: 8.5.1.  Syntax - Elemente
    Thema[135] := TThema.Create;
    Thema[135].Caption := '8.5.1.  Syntax - Elemente';
    Thema[135].TopicID := HndTopics.CreateTopic;
    Thema[135].TopicLevel := GetLevel(Thema[135].Caption);
    ThemenListe.AddObject('Topic135', Thema[135]);
    HndEditor.SetAsTopicContent(aEditor, Thema[135].TopicID);
    // Thema 137: 8.5.2.  Einschränkungen für Record''s
    Thema[136] := TThema.Create;
    Thema[136].Caption := '8.5.2.  Einschränkungen für Record''s';
    Thema[136].TopicID := HndTopics.CreateTopic;
    Thema[136].TopicLevel := GetLevel(Thema[136].Caption);
    ThemenListe.AddObject('Topic136', Thema[136]);
    HndEditor.SetAsTopicContent(aEditor, Thema[136].TopicID);
    // Thema 138: 8.5.3.  Typen - Überladung(en)
    Thema[137] := TThema.Create;
    Thema[137].Caption := '8.5.3.  Typen - Überladung(en)';
    Thema[137].TopicID := HndTopics.CreateTopic;
    Thema[137].TopicLevel := GetLevel(Thema[137].Caption);
    ThemenListe.AddObject('Topic137', Thema[137]);
    HndEditor.SetAsTopicContent(aEditor, Thema[137].TopicID);
    // Thema 139: 8.5.4.  Überlegungen für Namensbereiche
    Thema[138] := TThema.Create;
    Thema[138].Caption := '8.5.4.  Überlegungen für Namensbereiche';
    Thema[138].TopicID := HndTopics.CreateTopic;
    Thema[138].TopicLevel := GetLevel(Thema[138].Caption);
    ThemenListe.AddObject('Topic138', Thema[138]);
    HndEditor.SetAsTopicContent(aEditor, Thema[138].TopicID);
    // Thema 140: 8.6.  Typen-Kompatibilität
    Thema[139] := TThema.Create;
    Thema[139].Caption := '8.6.  Typen-Kompatibilität';
    Thema[139].TopicID := HndTopics.CreateTopic;
    Thema[139].TopicLevel := GetLevel(Thema[139].Caption);
    ThemenListe.AddObject('Topic139', Thema[139]);
    HndEditor.SetAsTopicContent(aEditor, Thema[139].TopicID);
    // Thema 141: 8.7.  Verwendung der eingebauten Funktionen
    Thema[140] := TThema.Create;
    Thema[140].Caption := '8.7.  Verwendung der eingebauten Funktionen';
    Thema[140].TopicID := HndTopics.CreateTopic;
    Thema[140].TopicLevel := GetLevel(Thema[140].Caption);
    ThemenListe.AddObject('Topic140', Thema[140]);
    HndEditor.SetAsTopicContent(aEditor, Thema[140].TopicID);
    // Thema 142: 8.8.  Überlegungen zum Geltungsbereich
    Thema[141] := TThema.Create;
    Thema[141].Caption := '8.8.  Überlegungen zum Geltungsbereich';
    Thema[141].TopicID := HndTopics.CreateTopic;
    Thema[141].TopicLevel := GetLevel(Thema[141].Caption);
    ThemenListe.AddObject('Topic141', Thema[141]);
    HndEditor.SetAsTopicContent(aEditor, Thema[141].TopicID);
    // Thema 143: 8.9.  Operator-Überladung und Generics
    Thema[142] := TThema.Create;
    Thema[142].Caption := '8.9.  Operator-Überladung und Generics';
    Thema[142].TopicID := HndTopics.CreateTopic;
    Thema[142].TopicLevel := GetLevel(Thema[142].Caption);
    ThemenListe.AddObject('Topic142', Thema[142]);
    HndEditor.SetAsTopicContent(aEditor, Thema[142].TopicID);
    // Thema 144: 9.  Erweiterte Record''s
    Thema[143] := TThema.Create;
    Thema[143].Caption := '9.  Erweiterte Record''s';
    Thema[143].TopicID := HndTopics.CreateTopic;
    Thema[143].TopicLevel := GetLevel(Thema[143].Caption);
    ThemenListe.AddObject('Topic143', Thema[143]);
    HndEditor.SetAsTopicContent(aEditor, Thema[143].TopicID);
    // Thema 145: 9.1.  Definition
    Thema[144] := TThema.Create;
    Thema[144].Caption := '9.1.  Definition';
    Thema[144].TopicID := HndTopics.CreateTopic;
    Thema[144].TopicLevel := GetLevel(Thema[144].Caption);
    ThemenListe.AddObject('Topic144', Thema[144]);
    HndEditor.SetAsTopicContent(aEditor, Thema[144].TopicID);
    // Thema 146: 9.2.  Erweiterte Record-Aufzähler
    Thema[145] := TThema.Create;
    Thema[145].Caption := '9.2.  Erweiterte Record-Aufzähler';
    Thema[145].TopicID := HndTopics.CreateTopic;
    Thema[145].TopicLevel := GetLevel(Thema[145].Caption);
    ThemenListe.AddObject('Topic145', Thema[145]);
    HndEditor.SetAsTopicContent(aEditor, Thema[145].TopicID);
    // Thema 147: 9.3.  Record-Operationen
    Thema[146] := TThema.Create;
    Thema[146].Caption := '9.3.  Record-Operationen';
    Thema[146].TopicID := HndTopics.CreateTopic;
    Thema[146].TopicLevel := GetLevel(Thema[146].Caption);
    ThemenListe.AddObject('Topic146', Thema[146]);
    HndEditor.SetAsTopicContent(aEditor, Thema[146].TopicID);
    // Thema 148: 10.  Klassen, Record''s, und Typen-Helfer
    Thema[147] := TThema.Create;
    Thema[147].Caption := '10.  Klassen, Record''s, und Typen-Helfer';
    Thema[147].TopicID := HndTopics.CreateTopic;
    Thema[147].TopicLevel := GetLevel(Thema[147].Caption);
    ThemenListe.AddObject('Topic147', Thema[147]);
    HndEditor.SetAsTopicContent(aEditor, Thema[147].TopicID);
    // Thema 149: 10.1.  Definition
    Thema[148] := TThema.Create;
    Thema[148].Caption := '10.1.  Definition';
    Thema[148].TopicID := HndTopics.CreateTopic;
    Thema[148].TopicLevel := GetLevel(Thema[148].Caption);
    ThemenListe.AddObject('Topic148', Thema[148]);
    HndEditor.SetAsTopicContent(aEditor, Thema[148].TopicID);
    // Thema 150: 10.2.  Einschränkungen bei Klassen Helfer
    Thema[149] := TThema.Create;
    Thema[149].Caption := '10.2.  Einschränkungen bei Klassen Helfer';
    Thema[149].TopicID := HndTopics.CreateTopic;
    Thema[149].TopicLevel := GetLevel(Thema[149].Caption);
    ThemenListe.AddObject('Topic149', Thema[149]);
    HndEditor.SetAsTopicContent(aEditor, Thema[149].TopicID);
    // Thema 151: 10.3.  Einschränkungen bei Record  Helfer
    Thema[150] := TThema.Create;
    Thema[150].Caption := '10.3.  Einschränkungen bei Record  Helfer';
    Thema[150].TopicID := HndTopics.CreateTopic;
    Thema[150].TopicLevel := GetLevel(Thema[150].Caption);
    ThemenListe.AddObject('Topic150', Thema[150]);
    HndEditor.SetAsTopicContent(aEditor, Thema[150].TopicID);
    // Thema 152: 10.4.  Überlegungen zu einfachen Helper
    Thema[151] := TThema.Create;
    Thema[151].Caption := '10.4.  Überlegungen zu einfachen Helper';
    Thema[151].TopicID := HndTopics.CreateTopic;
    Thema[151].TopicLevel := GetLevel(Thema[151].Caption);
    ThemenListe.AddObject('Topic151', Thema[151]);
    HndEditor.SetAsTopicContent(aEditor, Thema[151].TopicID);
    // Thema 153: 10.5.  Anmerkungen zu Umfang und Lebensdauer von Record-Helper
    Thema[152] := TThema.Create;
    Thema[152].Caption := '10.5.  Anmerkungen zu Umfang und Lebensdauer von Record-Helper';
    Thema[152].TopicID := HndTopics.CreateTopic;
    Thema[152].TopicLevel := GetLevel(Thema[152].Caption);
    ThemenListe.AddObject('Topic152', Thema[152]);
    HndEditor.SetAsTopicContent(aEditor, Thema[152].TopicID);
    // Thema 154: 10.6.  Vererbung
    Thema[153] := TThema.Create;
    Thema[153].Caption := '10.6.  Vererbung';
    Thema[153].TopicID := HndTopics.CreateTopic;
    Thema[153].TopicLevel := GetLevel(Thema[153].Caption);
    ThemenListe.AddObject('Topic153', Thema[153]);
    HndEditor.SetAsTopicContent(aEditor, Thema[153].TopicID);
    // Thema 155: 10.7.  Verwendung
    Thema[154] := TThema.Create;
    Thema[154].Caption := '10.7.  Verwendung';
    Thema[154].TopicID := HndTopics.CreateTopic;
    Thema[154].TopicLevel := GetLevel(Thema[154].Caption);
    ThemenListe.AddObject('Topic154', Thema[154]);
    HndEditor.SetAsTopicContent(aEditor, Thema[154].TopicID);
    // Thema 156: 11.  Objektorientierte Pascal - Klassen
    Thema[155] := TThema.Create;
    Thema[155].Caption := '11.  Objektorientierte Pascal - Klassen';
    Thema[155].TopicID := HndTopics.CreateTopic;
    Thema[155].TopicLevel := GetLevel(Thema[155].Caption);
    ThemenListe.AddObject('Topic155', Thema[155]);
    HndEditor.SetAsTopicContent(aEditor, Thema[155].TopicID);
    // Thema 157: 11.1.  Einführung
    Thema[156] := TThema.Create;
    Thema[156].Caption := '11.1.  Einführung';
    Thema[156].TopicID := HndTopics.CreateTopic;
    Thema[156].TopicLevel := GetLevel(Thema[156].Caption);
    ThemenListe.AddObject('Topic156', Thema[156]);
    HndEditor.SetAsTopicContent(aEditor, Thema[156].TopicID);
    // Thema 158: 11.2.  Klassendeklarationen
    Thema[157] := TThema.Create;
    Thema[157].Caption := '11.2.  Klassendeklarationen';
    Thema[157].TopicID := HndTopics.CreateTopic;
    Thema[157].TopicLevel := GetLevel(Thema[157].Caption);
    ThemenListe.AddObject('Topic157', Thema[157]);
    HndEditor.SetAsTopicContent(aEditor, Thema[157].TopicID);
    // Thema 159: 11.3.  Formele Deklaration
    Thema[158] := TThema.Create;
    Thema[158].Caption := '11.3.  Formele Deklaration';
    Thema[158].TopicID := HndTopics.CreateTopic;
    Thema[158].TopicLevel := GetLevel(Thema[158].Caption);
    ThemenListe.AddObject('Topic158', Thema[158]);
    HndEditor.SetAsTopicContent(aEditor, Thema[158].TopicID);
    // Thema 160: 11.4.  Instanzen zuteilen und zuordnen
    Thema[159] := TThema.Create;
    Thema[159].Caption := '11.4.  Instanzen zuteilen und zuordnen';
    Thema[159].TopicID := HndTopics.CreateTopic;
    Thema[159].TopicLevel := GetLevel(Thema[159].Caption);
    ThemenListe.AddObject('Topic159', Thema[159]);
    HndEditor.SetAsTopicContent(aEditor, Thema[159].TopicID);
    // Thema 161: 11.5.  Protokolldefinitionen
    Thema[160] := TThema.Create;
    Thema[160].Caption := '11.5.  Protokolldefinitionen';
    Thema[160].TopicID := HndTopics.CreateTopic;
    Thema[160].TopicLevel := GetLevel(Thema[160].Caption);
    ThemenListe.AddObject('Topic160', Thema[160]);
    HndEditor.SetAsTopicContent(aEditor, Thema[160].TopicID);
    // Thema 162: 11.6.  Kategorien
    Thema[161] := TThema.Create;
    Thema[161].Caption := '11.6.  Kategorien';
    Thema[161].TopicID := HndTopics.CreateTopic;
    Thema[161].TopicLevel := GetLevel(Thema[161].Caption);
    ThemenListe.AddObject('Topic161', Thema[161]);
    HndEditor.SetAsTopicContent(aEditor, Thema[161].TopicID);
    // Thema 163: 11.7.  Namensumfang und Bezeichner
    Thema[162] := TThema.Create;
    Thema[162].Caption := '11.7.  Namensumfang und Bezeichner';
    Thema[162].TopicID := HndTopics.CreateTopic;
    Thema[162].TopicLevel := GetLevel(Thema[162].Caption);
    ThemenListe.AddObject('Topic162', Thema[162]);
    HndEditor.SetAsTopicContent(aEditor, Thema[162].TopicID);
    // Thema 164: 11.8.  Selektoren
    Thema[163] := TThema.Create;
    Thema[163].Caption := '11.8.  Selektoren';
    Thema[163].TopicID := HndTopics.CreateTopic;
    Thema[163].TopicLevel := GetLevel(Thema[163].Caption);
    ThemenListe.AddObject('Topic163', Thema[163]);
    HndEditor.SetAsTopicContent(aEditor, Thema[163].TopicID);
    // Thema 165: 11.9.  Der ID Typ
    Thema[164] := TThema.Create;
    Thema[164].Caption := '11.9.  Der ID Typ';
    Thema[164].TopicID := HndTopics.CreateTopic;
    Thema[164].TopicLevel := GetLevel(Thema[164].Caption);
    ThemenListe.AddObject('Topic164', Thema[164]);
    HndEditor.SetAsTopicContent(aEditor, Thema[164].TopicID);
    // Thema 166: 11.10. Aufzählungen in Objective-C Klassen
    Thema[165] := TThema.Create;
    Thema[165].Caption := '11.10. Aufzählungen in Objective-C Klassen';
    Thema[165].TopicID := HndTopics.CreateTopic;
    Thema[165].TopicLevel := GetLevel(Thema[165].Caption);
    ThemenListe.AddObject('Topic165', Thema[165]);
    HndEditor.SetAsTopicContent(aEditor, Thema[165].TopicID);
    // Thema 167: 12.  Ausdrücke
    Thema[166] := TThema.Create;
    Thema[166].Caption := '12.  Ausdrücke';
    Thema[166].TopicID := HndTopics.CreateTopic;
    Thema[166].TopicLevel := GetLevel(Thema[166].Caption);
    ThemenListe.AddObject('Topic166', Thema[166]);
    HndEditor.SetAsTopicContent(aEditor, Thema[166].TopicID);
    // Thema 168: 12.1.  Ausdrucks - Syntax
    Thema[167] := TThema.Create;
    Thema[167].Caption := '12.1.  Ausdrucks - Syntax';
    Thema[167].TopicID := HndTopics.CreateTopic;
    Thema[167].TopicLevel := GetLevel(Thema[167].Caption);
    ThemenListe.AddObject('Topic167', Thema[167]);
    HndEditor.SetAsTopicContent(aEditor, Thema[167].TopicID);
    // Thema 169: 12.2.  Funktionsaufrufe
    Thema[168] := TThema.Create;
    Thema[168].Caption := '12.2.  Funktionsaufrufe';
    Thema[168].TopicID := HndTopics.CreateTopic;
    Thema[168].TopicLevel := GetLevel(Thema[168].Caption);
    ThemenListe.AddObject('Topic168', Thema[168]);
    HndEditor.SetAsTopicContent(aEditor, Thema[168].TopicID);
    // Thema 170: 12.3.  Mengen - CTOR
    Thema[169] := TThema.Create;
    Thema[169].Caption := '12.3.  Mengen - CTOR';
    Thema[169].TopicID := HndTopics.CreateTopic;
    Thema[169].TopicLevel := GetLevel(Thema[169].Caption);
    ThemenListe.AddObject('Topic169', Thema[169]);
    HndEditor.SetAsTopicContent(aEditor, Thema[169].TopicID);
    // Thema 171: 12.4.  Typ-Casting von Werten
    Thema[170] := TThema.Create;
    Thema[170].Caption := '12.4.  Typ-Casting von Werten';
    Thema[170].TopicID := HndTopics.CreateTopic;
    Thema[170].TopicLevel := GetLevel(Thema[170].Caption);
    ThemenListe.AddObject('Topic170', Thema[170]);
    HndEditor.SetAsTopicContent(aEditor, Thema[170].TopicID);
    // Thema 172: 12.5.  Typ-Casting von Variablen
    Thema[171] := TThema.Create;
    Thema[171].Caption := '12.5.  Typ-Casting von Variablen';
    Thema[171].TopicID := HndTopics.CreateTopic;
    Thema[171].TopicLevel := GetLevel(Thema[171].Caption);
    ThemenListe.AddObject('Topic171', Thema[171]);
    HndEditor.SetAsTopicContent(aEditor, Thema[171].TopicID);
    // Thema 173: 12.6.  Sonstige Typ-Casting''s
    Thema[172] := TThema.Create;
    Thema[172].Caption := '12.6.  Sonstige Typ-Casting''s';
    Thema[172].TopicID := HndTopics.CreateTopic;
    Thema[172].TopicLevel := GetLevel(Thema[172].Caption);
    ThemenListe.AddObject('Topic172', Thema[172]);
    HndEditor.SetAsTopicContent(aEditor, Thema[172].TopicID);
    // Thema 174: 12.7.  Der @ - Operator
    Thema[173] := TThema.Create;
    Thema[173].Caption := '12.7.  Der @ - Operator';
    Thema[173].TopicID := HndTopics.CreateTopic;
    Thema[173].TopicLevel := GetLevel(Thema[173].Caption);
    ThemenListe.AddObject('Topic173', Thema[173]);
    HndEditor.SetAsTopicContent(aEditor, Thema[173].TopicID);
    // Thema 175: 12.8.  Operatoren
    Thema[174] := TThema.Create;
    Thema[174].Caption := '12.8.  Operatoren';
    Thema[174].TopicID := HndTopics.CreateTopic;
    Thema[174].TopicLevel := GetLevel(Thema[174].Caption);
    ThemenListe.AddObject('Topic174', Thema[174]);
    HndEditor.SetAsTopicContent(aEditor, Thema[174].TopicID);
    // Thema 176: 12.8.1.  Arithmetische Operatoren
    Thema[175] := TThema.Create;
    Thema[175].Caption := '12.8.1.  Arithmetische Operatoren';
    Thema[175].TopicID := HndTopics.CreateTopic;
    Thema[175].TopicLevel := GetLevel(Thema[175].Caption);
    ThemenListe.AddObject('Topic175', Thema[175]);
    HndEditor.SetAsTopicContent(aEditor, Thema[175].TopicID);
    // Thema 177: 12.8.2.  Logische Operatoren
    Thema[176] := TThema.Create;
    Thema[176].Caption := '12.8.2.  Logische Operatoren';
    Thema[176].TopicID := HndTopics.CreateTopic;
    Thema[176].TopicLevel := GetLevel(Thema[176].Caption);
    ThemenListe.AddObject('Topic176', Thema[176]);
    HndEditor.SetAsTopicContent(aEditor, Thema[176].TopicID);
    // Thema 178: 12.8.3.  Boolesche Operatoren
    Thema[177] := TThema.Create;
    Thema[177].Caption := '12.8.3.  Boolesche Operatoren';
    Thema[177].TopicID := HndTopics.CreateTopic;
    Thema[177].TopicLevel := GetLevel(Thema[177].Caption);
    ThemenListe.AddObject('Topic177', Thema[177]);
    HndEditor.SetAsTopicContent(aEditor, Thema[177].TopicID);
    // Thema 179: 12.8.4.  Zeichenketten Operatoren
    Thema[178] := TThema.Create;
    Thema[178].Caption := '12.8.4.  Zeichenketten Operatoren';
    Thema[178].TopicID := HndTopics.CreateTopic;
    Thema[178].TopicLevel := GetLevel(Thema[178].Caption);
    ThemenListe.AddObject('Topic178', Thema[178]);
    HndEditor.SetAsTopicContent(aEditor, Thema[178].TopicID);
    // Thema 180: 12.8.5.  Operatoren bei dynamischen Array''s
    Thema[179] := TThema.Create;
    Thema[179].Caption := '12.8.5.  Operatoren bei dynamischen Array''s';
    Thema[179].TopicID := HndTopics.CreateTopic;
    Thema[179].TopicLevel := GetLevel(Thema[179].Caption);
    ThemenListe.AddObject('Topic179', Thema[179]);
    HndEditor.SetAsTopicContent(aEditor, Thema[179].TopicID);
    // Thema 181: 12.8.6.  Mengen - Operatoren
    Thema[180] := TThema.Create;
    Thema[180].Caption := '12.8.6.  Mengen - Operatoren';
    Thema[180].TopicID := HndTopics.CreateTopic;
    Thema[180].TopicLevel := GetLevel(Thema[180].Caption);
    ThemenListe.AddObject('Topic180', Thema[180]);
    HndEditor.SetAsTopicContent(aEditor, Thema[180].TopicID);
    // Thema 182: 12.8.7.  Relationale Operatoren
    Thema[181] := TThema.Create;
    Thema[181].Caption := '12.8.7.  Relationale Operatoren';
    Thema[181].TopicID := HndTopics.CreateTopic;
    Thema[181].TopicLevel := GetLevel(Thema[181].Caption);
    ThemenListe.AddObject('Topic181', Thema[181]);
    HndEditor.SetAsTopicContent(aEditor, Thema[181].TopicID);
    // Thema 183: 12.8.8.  Klassen - Operatoren
    Thema[182] := TThema.Create;
    Thema[182].Caption := '12.8.8.  Klassen - Operatoren';
    Thema[182].TopicID := HndTopics.CreateTopic;
    Thema[182].TopicLevel := GetLevel(Thema[182].Caption);
    ThemenListe.AddObject('Topic182', Thema[182]);
    HndEditor.SetAsTopicContent(aEditor, Thema[182].TopicID);
    // Thema 184: 13.  Anweisungen
    Thema[183] := TThema.Create;
    Thema[183].Caption := '13.  Anweisungen';
    Thema[183].TopicID := HndTopics.CreateTopic;
    Thema[183].TopicLevel := GetLevel(Thema[183].Caption);
    ThemenListe.AddObject('Topic183', Thema[183]);
    HndEditor.SetAsTopicContent(aEditor, Thema[183].TopicID);
    // Thema 185: 13.1.  Einfache Anweisungen
    Thema[184] := TThema.Create;
    Thema[184].Caption := '13.1.  Einfache Anweisungen';
    Thema[184].TopicID := HndTopics.CreateTopic;
    Thema[184].TopicLevel := GetLevel(Thema[184].Caption);
    ThemenListe.AddObject('Topic184', Thema[184]);
    HndEditor.SetAsTopicContent(aEditor, Thema[184].TopicID);
    // Thema 186: 13.1.1.  Zuweisungen
    Thema[185] := TThema.Create;
    Thema[185].Caption := '13.1.1.  Zuweisungen';
    Thema[185].TopicID := HndTopics.CreateTopic;
    Thema[185].TopicLevel := GetLevel(Thema[185].Caption);
    ThemenListe.AddObject('Topic185', Thema[185]);
    HndEditor.SetAsTopicContent(aEditor, Thema[185].TopicID);
    // Thema 187: 13.1.2.  Prozeduren - PROCEDURE
    Thema[186] := TThema.Create;
    Thema[186].Caption := '13.1.2.  Prozeduren - PROCEDURE';
    Thema[186].TopicID := HndTopics.CreateTopic;
    Thema[186].TopicLevel := GetLevel(Thema[186].Caption);
    ThemenListe.AddObject('Topic186', Thema[186]);
    HndEditor.SetAsTopicContent(aEditor, Thema[186].TopicID);
    // Thema 188: 13.1.3.  Sprungs - Anweisung GOTO
    Thema[187] := TThema.Create;
    Thema[187].Caption := '13.1.3.  Sprungs - Anweisung GOTO';
    Thema[187].TopicID := HndTopics.CreateTopic;
    Thema[187].TopicLevel := GetLevel(Thema[187].Caption);
    ThemenListe.AddObject('Topic187', Thema[187]);
    HndEditor.SetAsTopicContent(aEditor, Thema[187].TopicID);
    // Thema 189: 13.2.  Strukturierte Anweisungen
    Thema[188] := TThema.Create;
    Thema[188].Caption := '13.2.  Strukturierte Anweisungen';
    Thema[188].TopicID := HndTopics.CreateTopic;
    Thema[188].TopicLevel := GetLevel(Thema[188].Caption);
    ThemenListe.AddObject('Topic188', Thema[188]);
    HndEditor.SetAsTopicContent(aEditor, Thema[188].TopicID);
    // Thema 190: 13.2.1.  Zusammengesetzte Anweisungen
    Thema[189] := TThema.Create;
    Thema[189].Caption := '13.2.1.  Zusammengesetzte Anweisungen';
    Thema[189].TopicID := HndTopics.CreateTopic;
    Thema[189].TopicLevel := GetLevel(Thema[189].Caption);
    ThemenListe.AddObject('Topic189', Thema[189]);
    HndEditor.SetAsTopicContent(aEditor, Thema[189].TopicID);
    // Thema 191: 13.2.2.  CASE
    Thema[190] := TThema.Create;
    Thema[190].Caption := '13.2.2.  CASE';
    Thema[190].TopicID := HndTopics.CreateTopic;
    Thema[190].TopicLevel := GetLevel(Thema[190].Caption);
    ThemenListe.AddObject('Topic190', Thema[190]);
    HndEditor.SetAsTopicContent(aEditor, Thema[190].TopicID);
    // Thema 192: 13.2.3.  IF ... THEN
    Thema[191] := TThema.Create;
    Thema[191].Caption := '13.2.3.  IF ... THEN';
    Thema[191].TopicID := HndTopics.CreateTopic;
    Thema[191].TopicLevel := GetLevel(Thema[191].Caption);
    ThemenListe.AddObject('Topic191', Thema[191]);
    HndEditor.SetAsTopicContent(aEditor, Thema[191].TopicID);
    // Thema 193: 13.2.4.  FOR ... TO / DOWNTO ... DO
    Thema[192] := TThema.Create;
    Thema[192].Caption := '13.2.4.  FOR ... TO / DOWNTO ... DO';
    Thema[192].TopicID := HndTopics.CreateTopic;
    Thema[192].TopicLevel := GetLevel(Thema[192].Caption);
    ThemenListe.AddObject('Topic192', Thema[192]);
    HndEditor.SetAsTopicContent(aEditor, Thema[192].TopicID);
    // Thema 194: 13.2.5.  FOR .. IN .. DO
    Thema[193] := TThema.Create;
    Thema[193].Caption := '13.2.5.  FOR .. IN .. DO';
    Thema[193].TopicID := HndTopics.CreateTopic;
    Thema[193].TopicLevel := GetLevel(Thema[193].Caption);
    ThemenListe.AddObject('Topic193', Thema[193]);
    HndEditor.SetAsTopicContent(aEditor, Thema[193].TopicID);
    // Thema 195: 13.2.6.  REPEAT ... UNTIL
    Thema[194] := TThema.Create;
    Thema[194].Caption := '13.2.6.  REPEAT ... UNTIL';
    Thema[194].TopicID := HndTopics.CreateTopic;
    Thema[194].TopicLevel := GetLevel(Thema[194].Caption);
    ThemenListe.AddObject('Topic194', Thema[194]);
    HndEditor.SetAsTopicContent(aEditor, Thema[194].TopicID);
    // Thema 196: 13.2.7.  WHILE ... DO
    Thema[195] := TThema.Create;
    Thema[195].Caption := '13.2.7.  WHILE ... DO';
    Thema[195].TopicID := HndTopics.CreateTopic;
    Thema[195].TopicLevel := GetLevel(Thema[195].Caption);
    ThemenListe.AddObject('Topic195', Thema[195]);
    HndEditor.SetAsTopicContent(aEditor, Thema[195].TopicID);
    // Thema 197: 13.2.8.  WITH
    Thema[196] := TThema.Create;
    Thema[196].Caption := '13.2.8.  WITH';
    Thema[196].TopicID := HndTopics.CreateTopic;
    Thema[196].TopicLevel := GetLevel(Thema[196].Caption);
    ThemenListe.AddObject('Topic196', Thema[196]);
    HndEditor.SetAsTopicContent(aEditor, Thema[196].TopicID);
    // Thema 198: 13.2.9.  Ausnahmen (EXCEPT)
    Thema[197] := TThema.Create;
    Thema[197].Caption := '13.2.9.  Ausnahmen (EXCEPT)';
    Thema[197].TopicID := HndTopics.CreateTopic;
    Thema[197].TopicLevel := GetLevel(Thema[197].Caption);
    ThemenListe.AddObject('Topic197', Thema[197]);
    HndEditor.SetAsTopicContent(aEditor, Thema[197].TopicID);
    // Thema 199: 13.3.  Assembler Anweisungen
    Thema[198] := TThema.Create;
    Thema[198].Caption := '13.3.  Assembler Anweisungen';
    Thema[198].TopicID := HndTopics.CreateTopic;
    Thema[198].TopicLevel := GetLevel(Thema[198].Caption);
    ThemenListe.AddObject('Topic198', Thema[198]);
    HndEditor.SetAsTopicContent(aEditor, Thema[198].TopicID);
    // Thema 200: 14.  Benutzung von Funktionen und Prozeduren
    Thema[199] := TThema.Create;
    Thema[199].Caption := '14.  Benutzung von Funktionen und Prozeduren';
    Thema[199].TopicID := HndTopics.CreateTopic;
    Thema[199].TopicLevel := GetLevel(Thema[199].Caption);
    ThemenListe.AddObject('Topic199', Thema[199]);
    HndEditor.SetAsTopicContent(aEditor, Thema[199].TopicID);
    // Thema 201: 14.1.  FUNCTION Deklarationen
    Thema[200] := TThema.Create;
    Thema[200].Caption := '14.1.  FUNCTION Deklarationen';
    Thema[200].TopicID := HndTopics.CreateTopic;
    Thema[200].TopicLevel := GetLevel(Thema[200].Caption);
    ThemenListe.AddObject('Topic200', Thema[200]);
    HndEditor.SetAsTopicContent(aEditor, Thema[200].TopicID);
    // Thema 202: 14.2.  PROCEDURE Deklarationen
    Thema[201] := TThema.Create;
    Thema[201].Caption := '14.2.  PROCEDURE Deklarationen';
    Thema[201].TopicID := HndTopics.CreateTopic;
    Thema[201].TopicLevel := GetLevel(Thema[201].Caption);
    ThemenListe.AddObject('Topic201', Thema[201]);
    HndEditor.SetAsTopicContent(aEditor, Thema[201].TopicID);
    // Thema 203: 14.3.  Funktion Rückgabewert mittels RESULT
    Thema[202] := TThema.Create;
    Thema[202].Caption := '14.3.  Funktion Rückgabewert mittels RESULT';
    Thema[202].TopicID := HndTopics.CreateTopic;
    Thema[202].TopicLevel := GetLevel(Thema[202].Caption);
    ThemenListe.AddObject('Topic202', Thema[202]);
    HndEditor.SetAsTopicContent(aEditor, Thema[202].TopicID);
    // Thema 204: 14.4.  Parameter Listen
    Thema[203] := TThema.Create;
    Thema[203].Caption := '14.4.  Parameter Listen';
    Thema[203].TopicID := HndTopics.CreateTopic;
    Thema[203].TopicLevel := GetLevel(Thema[203].Caption);
    ThemenListe.AddObject('Topic203', Thema[203]);
    HndEditor.SetAsTopicContent(aEditor, Thema[203].TopicID);
    // Thema 205: 14.4.1.  Werte
    Thema[204] := TThema.Create;
    Thema[204].Caption := '14.4.1.  Werte';
    Thema[204].TopicID := HndTopics.CreateTopic;
    Thema[204].TopicLevel := GetLevel(Thema[204].Caption);
    ThemenListe.AddObject('Topic204', Thema[204]);
    HndEditor.SetAsTopicContent(aEditor, Thema[204].TopicID);
    // Thema 206: 14.4.2.  Variablen
    Thema[205] := TThema.Create;
    Thema[205].Caption := '14.4.2.  Variablen';
    Thema[205].TopicID := HndTopics.CreateTopic;
    Thema[205].TopicLevel := GetLevel(Thema[205].Caption);
    ThemenListe.AddObject('Topic205', Thema[205]);
    HndEditor.SetAsTopicContent(aEditor, Thema[205].TopicID);
    // Thema 207: 14.4.3.  Ausgabe Parameter
    Thema[206] := TThema.Create;
    Thema[206].Caption := '14.4.3.  Ausgabe Parameter';
    Thema[206].TopicID := HndTopics.CreateTopic;
    Thema[206].TopicLevel := GetLevel(Thema[206].Caption);
    ThemenListe.AddObject('Topic206', Thema[206]);
    HndEditor.SetAsTopicContent(aEditor, Thema[206].TopicID);
    // Thema 208: 14.4.4.  Konstante Parameter
    Thema[207] := TThema.Create;
    Thema[207].Caption := '14.4.4.  Konstante Parameter';
    Thema[207].TopicID := HndTopics.CreateTopic;
    Thema[207].TopicLevel := GetLevel(Thema[207].Caption);
    ThemenListe.AddObject('Topic207', Thema[207]);
    HndEditor.SetAsTopicContent(aEditor, Thema[207].TopicID);
    // Thema 209: 14.4.5.  Offene Array''s
    Thema[208] := TThema.Create;
    Thema[208].Caption := '14.4.5.  Offene Array''s';
    Thema[208].TopicID := HndTopics.CreateTopic;
    Thema[208].TopicLevel := GetLevel(Thema[208].Caption);
    ThemenListe.AddObject('Topic208', Thema[208]);
    HndEditor.SetAsTopicContent(aEditor, Thema[208].TopicID);
    // Thema 210: 14.4.6.  Array of Const
    Thema[209] := TThema.Create;
    Thema[209].Caption := '14.4.6.  Array of Const';
    Thema[209].TopicID := HndTopics.CreateTopic;
    Thema[209].TopicLevel := GetLevel(Thema[209].Caption);
    ThemenListe.AddObject('Topic209', Thema[209]);
    HndEditor.SetAsTopicContent(aEditor, Thema[209].TopicID);
    // Thema 211: 14.4.7.  Untypisierte Parameter
    Thema[210] := TThema.Create;
    Thema[210].Caption := '14.4.7.  Untypisierte Parameter';
    Thema[210].TopicID := HndTopics.CreateTopic;
    Thema[210].TopicLevel := GetLevel(Thema[210].Caption);
    ThemenListe.AddObject('Topic210', Thema[210]);
    HndEditor.SetAsTopicContent(aEditor, Thema[210].TopicID);
    // Thema 212: 14.4.8.  Verwaltete Typen und Referenzzähler
    Thema[211] := TThema.Create;
    Thema[211].Caption := '14.4.8.  Verwaltete Typen und Referenzzähler';
    Thema[211].TopicID := HndTopics.CreateTopic;
    Thema[211].TopicLevel := GetLevel(Thema[211].Caption);
    ThemenListe.AddObject('Topic211', Thema[211]);
    HndEditor.SetAsTopicContent(aEditor, Thema[211].TopicID);
    // Thema 213: 14.5.  Überladung von Funktionen
    Thema[212] := TThema.Create;
    Thema[212].Caption := '14.5.  Überladung von Funktionen';
    Thema[212].TopicID := HndTopics.CreateTopic;
    Thema[212].TopicLevel := GetLevel(Thema[212].Caption);
    ThemenListe.AddObject('Topic212', Thema[212]);
    HndEditor.SetAsTopicContent(aEditor, Thema[212].TopicID);
    // Thema 214: 14.6.  Mit FORWARD deklarierte Funktionen
    Thema[213] := TThema.Create;
    Thema[213].Caption := '14.6.  Mit FORWARD deklarierte Funktionen';
    Thema[213].TopicID := HndTopics.CreateTopic;
    Thema[213].TopicLevel := GetLevel(Thema[213].Caption);
    ThemenListe.AddObject('Topic213', Thema[213]);
    HndEditor.SetAsTopicContent(aEditor, Thema[213].TopicID);
    // Thema 215: 14.7.  Externe Funktionen
    Thema[214] := TThema.Create;
    Thema[214].Caption := '14.7.  Externe Funktionen';
    Thema[214].TopicID := HndTopics.CreateTopic;
    Thema[214].TopicLevel := GetLevel(Thema[214].Caption);
    ThemenListe.AddObject('Topic214', Thema[214]);
    HndEditor.SetAsTopicContent(aEditor, Thema[214].TopicID);
    // Thema 216: 14.8.  Assembler Funktionen
    Thema[215] := TThema.Create;
    Thema[215].Caption := '14.8.  Assembler Funktionen';
    Thema[215].TopicID := HndTopics.CreateTopic;
    Thema[215].TopicLevel := GetLevel(Thema[215].Caption);
    ThemenListe.AddObject('Topic215', Thema[215]);
    HndEditor.SetAsTopicContent(aEditor, Thema[215].TopicID);
    // Thema 217: 14.9.  Modifikatoren
    Thema[216] := TThema.Create;
    Thema[216].Caption := '14.9.  Modifikatoren';
    Thema[216].TopicID := HndTopics.CreateTopic;
    Thema[216].TopicLevel := GetLevel(Thema[216].Caption);
    ThemenListe.AddObject('Topic216', Thema[216]);
    HndEditor.SetAsTopicContent(aEditor, Thema[216].TopicID);
    // Thema 218: 14.9.1.  alias
    Thema[217] := TThema.Create;
    Thema[217].Caption := '14.9.1.  alias';
    Thema[217].TopicID := HndTopics.CreateTopic;
    Thema[217].TopicLevel := GetLevel(Thema[217].Caption);
    ThemenListe.AddObject('Topic217', Thema[217]);
    HndEditor.SetAsTopicContent(aEditor, Thema[217].TopicID);
    // Thema 219: 14.9.2.  cdecl
    Thema[218] := TThema.Create;
    Thema[218].Caption := '14.9.2.  cdecl';
    Thema[218].TopicID := HndTopics.CreateTopic;
    Thema[218].TopicLevel := GetLevel(Thema[218].Caption);
    ThemenListe.AddObject('Topic218', Thema[218]);
    HndEditor.SetAsTopicContent(aEditor, Thema[218].TopicID);
    // Thema 220: 14.9.3.  cppdecl
    Thema[219] := TThema.Create;
    Thema[219].Caption := '14.9.3.  cppdecl';
    Thema[219].TopicID := HndTopics.CreateTopic;
    Thema[219].TopicLevel := GetLevel(Thema[219].Caption);
    ThemenListe.AddObject('Topic219', Thema[219]);
    HndEditor.SetAsTopicContent(aEditor, Thema[219].TopicID);
    // Thema 221: 14.9.4.  export
    Thema[220] := TThema.Create;
    Thema[220].Caption := '14.9.4.  export';
    Thema[220].TopicID := HndTopics.CreateTopic;
    Thema[220].TopicLevel := GetLevel(Thema[220].Caption);
    ThemenListe.AddObject('Topic220', Thema[220]);
    HndEditor.SetAsTopicContent(aEditor, Thema[220].TopicID);
    // Thema 222: 14.9.5.  hardfloat
    Thema[221] := TThema.Create;
    Thema[221].Caption := '14.9.5.  hardfloat';
    Thema[221].TopicID := HndTopics.CreateTopic;
    Thema[221].TopicLevel := GetLevel(Thema[221].Caption);
    ThemenListe.AddObject('Topic221', Thema[221]);
    HndEditor.SetAsTopicContent(aEditor, Thema[221].TopicID);
    // Thema 223: 14.9.6.  inline
    Thema[222] := TThema.Create;
    Thema[222].Caption := '14.9.6.  inline';
    Thema[222].TopicID := HndTopics.CreateTopic;
    Thema[222].TopicLevel := GetLevel(Thema[222].Caption);
    ThemenListe.AddObject('Topic222', Thema[222]);
    HndEditor.SetAsTopicContent(aEditor, Thema[222].TopicID);
    // Thema 224: 14.9.7.  interrupt
    Thema[223] := TThema.Create;
    Thema[223].Caption := '14.9.7.  interrupt';
    Thema[223].TopicID := HndTopics.CreateTopic;
    Thema[223].TopicLevel := GetLevel(Thema[223].Caption);
    ThemenListe.AddObject('Topic223', Thema[223]);
    HndEditor.SetAsTopicContent(aEditor, Thema[223].TopicID);
    // Thema 225: 14.9.8.  iocheck
    Thema[224] := TThema.Create;
    Thema[224].Caption := '14.9.8.  iocheck';
    Thema[224].TopicID := HndTopics.CreateTopic;
    Thema[224].TopicLevel := GetLevel(Thema[224].Caption);
    ThemenListe.AddObject('Topic224', Thema[224]);
    HndEditor.SetAsTopicContent(aEditor, Thema[224].TopicID);
    // Thema 226: 14.9.9.  local
    Thema[225] := TThema.Create;
    Thema[225].Caption := '14.9.9.  local';
    Thema[225].TopicID := HndTopics.CreateTopic;
    Thema[225].TopicLevel := GetLevel(Thema[225].Caption);
    ThemenListe.AddObject('Topic225', Thema[225]);
    HndEditor.SetAsTopicContent(aEditor, Thema[225].TopicID);
    // Thema 227: 14.9.10.  MS_ABI_Default
    Thema[226] := TThema.Create;
    Thema[226].Caption := '14.9.10.  MS_ABI_Default';
    Thema[226].TopicID := HndTopics.CreateTopic;
    Thema[226].TopicLevel := GetLevel(Thema[226].Caption);
    ThemenListe.AddObject('Topic226', Thema[226]);
    HndEditor.SetAsTopicContent(aEditor, Thema[226].TopicID);
    // Thema 228: 14.9.11.  MS_ABI_CDecl
    Thema[227] := TThema.Create;
    Thema[227].Caption := '14.9.11.  MS_ABI_CDecl';
    Thema[227].TopicID := HndTopics.CreateTopic;
    Thema[227].TopicLevel := GetLevel(Thema[227].Caption);
    ThemenListe.AddObject('Topic227', Thema[227]);
    HndEditor.SetAsTopicContent(aEditor, Thema[227].TopicID);
    // Thema 229: 14.9.12.  MWPascal
    Thema[228] := TThema.Create;
    Thema[228].Caption := '14.9.12.  MWPascal';
    Thema[228].TopicID := HndTopics.CreateTopic;
    Thema[228].TopicLevel := GetLevel(Thema[228].Caption);
    ThemenListe.AddObject('Topic228', Thema[228]);
    HndEditor.SetAsTopicContent(aEditor, Thema[228].TopicID);
    // Thema 230: 14.9.13.  noreturn
    Thema[229] := TThema.Create;
    Thema[229].Caption := '14.9.13.  noreturn';
    Thema[229].TopicID := HndTopics.CreateTopic;
    Thema[229].TopicLevel := GetLevel(Thema[229].Caption);
    ThemenListe.AddObject('Topic229', Thema[229]);
    HndEditor.SetAsTopicContent(aEditor, Thema[229].TopicID);
    // Thema 231: 14.9.14.  nostackframe
    Thema[230] := TThema.Create;
    Thema[230].Caption := '14.9.14.  nostackframe';
    Thema[230].TopicID := HndTopics.CreateTopic;
    Thema[230].TopicLevel := GetLevel(Thema[230].Caption);
    ThemenListe.AddObject('Topic230', Thema[230]);
    HndEditor.SetAsTopicContent(aEditor, Thema[230].TopicID);
    // Thema 232: 14.9.15.  overload
    Thema[231] := TThema.Create;
    Thema[231].Caption := '14.9.15.  overload';
    Thema[231].TopicID := HndTopics.CreateTopic;
    Thema[231].TopicLevel := GetLevel(Thema[231].Caption);
    ThemenListe.AddObject('Topic231', Thema[231]);
    HndEditor.SetAsTopicContent(aEditor, Thema[231].TopicID);
    // Thema 233: 14.9.16.  pascal
    Thema[232] := TThema.Create;
    Thema[232].Caption := '14.9.16.  pascal';
    Thema[232].TopicID := HndTopics.CreateTopic;
    Thema[232].TopicLevel := GetLevel(Thema[232].Caption);
    ThemenListe.AddObject('Topic232', Thema[232]);
    HndEditor.SetAsTopicContent(aEditor, Thema[232].TopicID);
    // Thema 234: 14.9.17.  public
    Thema[233] := TThema.Create;
    Thema[233].Caption := '14.9.17.  public';
    Thema[233].TopicID := HndTopics.CreateTopic;
    Thema[233].TopicLevel := GetLevel(Thema[233].Caption);
    ThemenListe.AddObject('Topic233', Thema[233]);
    HndEditor.SetAsTopicContent(aEditor, Thema[233].TopicID);
    // Thema 235: 14.9.18.  register
    Thema[234] := TThema.Create;
    Thema[234].Caption := '14.9.18.  register';
    Thema[234].TopicID := HndTopics.CreateTopic;
    Thema[234].TopicLevel := GetLevel(Thema[234].Caption);
    ThemenListe.AddObject('Topic234', Thema[234]);
    HndEditor.SetAsTopicContent(aEditor, Thema[234].TopicID);
    // Thema 236: 14.9.19.  safecall
    Thema[235] := TThema.Create;
    Thema[235].Caption := '14.9.19.  safecall';
    Thema[235].TopicID := HndTopics.CreateTopic;
    Thema[235].TopicLevel := GetLevel(Thema[235].Caption);
    ThemenListe.AddObject('Topic235', Thema[235]);
    HndEditor.SetAsTopicContent(aEditor, Thema[235].TopicID);
    // Thema 237: 14.9.20.  saveregisters
    Thema[236] := TThema.Create;
    Thema[236].Caption := '14.9.20.  saveregisters';
    Thema[236].TopicID := HndTopics.CreateTopic;
    Thema[236].TopicLevel := GetLevel(Thema[236].Caption);
    ThemenListe.AddObject('Topic236', Thema[236]);
    HndEditor.SetAsTopicContent(aEditor, Thema[236].TopicID);
    // Thema 238: 14.9.21.  softfloat
    Thema[237] := TThema.Create;
    Thema[237].Caption := '14.9.21.  softfloat';
    Thema[237].TopicID := HndTopics.CreateTopic;
    Thema[237].TopicLevel := GetLevel(Thema[237].Caption);
    ThemenListe.AddObject('Topic237', Thema[237]);
    HndEditor.SetAsTopicContent(aEditor, Thema[237].TopicID);
    // Thema 239: 14.9.22.  stdcall
    Thema[238] := TThema.Create;
    Thema[238].Caption := '14.9.22.  stdcall';
    Thema[238].TopicID := HndTopics.CreateTopic;
    Thema[238].TopicLevel := GetLevel(Thema[238].Caption);
    ThemenListe.AddObject('Topic238', Thema[238]);
    HndEditor.SetAsTopicContent(aEditor, Thema[238].TopicID);
    // Thema 240: 14.9.23.  SYSV_ABI_Default
    Thema[239] := TThema.Create;
    Thema[239].Caption := '14.9.23.  SYSV_ABI_Default';
    Thema[239].TopicID := HndTopics.CreateTopic;
    Thema[239].TopicLevel := GetLevel(Thema[239].Caption);
    ThemenListe.AddObject('Topic239', Thema[239]);
    HndEditor.SetAsTopicContent(aEditor, Thema[239].TopicID);
    // Thema 241: 14.9.24.  SYSV_ABI_CDecl
    Thema[240] := TThema.Create;
    Thema[240].Caption := '14.9.24.  SYSV_ABI_CDecl';
    Thema[240].TopicID := HndTopics.CreateTopic;
    Thema[240].TopicLevel := GetLevel(Thema[240].Caption);
    ThemenListe.AddObject('Topic240', Thema[240]);
    HndEditor.SetAsTopicContent(aEditor, Thema[240].TopicID);
    // Thema 242: 14.9.25.  VectorCall
    Thema[241] := TThema.Create;
    Thema[241].Caption := '14.9.25.  VectorCall';
    Thema[241].TopicID := HndTopics.CreateTopic;
    Thema[241].TopicLevel := GetLevel(Thema[241].Caption);
    ThemenListe.AddObject('Topic241', Thema[241]);
    HndEditor.SetAsTopicContent(aEditor, Thema[241].TopicID);
    // Thema 243: 14.9.26.  varargs
    Thema[242] := TThema.Create;
    Thema[242].Caption := '14.9.26.  varargs';
    Thema[242].TopicID := HndTopics.CreateTopic;
    Thema[242].TopicLevel := GetLevel(Thema[242].Caption);
    ThemenListe.AddObject('Topic242', Thema[242]);
    HndEditor.SetAsTopicContent(aEditor, Thema[242].TopicID);
    // Thema 244: 14.9.27.  winapi
    Thema[243] := TThema.Create;
    Thema[243].Caption := '14.9.27.  winapi';
    Thema[243].TopicID := HndTopics.CreateTopic;
    Thema[243].TopicLevel := GetLevel(Thema[243].Caption);
    ThemenListe.AddObject('Topic243', Thema[243]);
    HndEditor.SetAsTopicContent(aEditor, Thema[243].TopicID);
    // Thema 245: 14.10.  Nicht unterstützte Modifikatoren
    Thema[244] := TThema.Create;
    Thema[244].Caption := '14.10.  Nicht unterstützte Modifikatoren';
    Thema[244].TopicID := HndTopics.CreateTopic;
    Thema[244].TopicLevel := GetLevel(Thema[244].Caption);
    ThemenListe.AddObject('Topic244', Thema[244]);
    HndEditor.SetAsTopicContent(aEditor, Thema[244].TopicID);
    // Thema 246: 15.  Operatoren Überladung
    Thema[245] := TThema.Create;
    Thema[245].Caption := '15.  Operatoren Überladung';
    Thema[245].TopicID := HndTopics.CreateTopic;
    Thema[245].TopicLevel := GetLevel(Thema[245].Caption);
    ThemenListe.AddObject('Topic245', Thema[245]);
    HndEditor.SetAsTopicContent(aEditor, Thema[245].TopicID);
    // Thema 247: 15.1.  Einleitung
    Thema[246] := TThema.Create;
    Thema[246].Caption := '15.1.  Einleitung';
    Thema[246].TopicID := HndTopics.CreateTopic;
    Thema[246].TopicLevel := GetLevel(Thema[246].Caption);
    ThemenListe.AddObject('Topic246', Thema[246]);
    HndEditor.SetAsTopicContent(aEditor, Thema[246].TopicID);
    // Thema 248: 15.2.  Operatoren - Deklarationen
    Thema[247] := TThema.Create;
    Thema[247].Caption := '15.2.  Operatoren - Deklarationen';
    Thema[247].TopicID := HndTopics.CreateTopic;
    Thema[247].TopicLevel := GetLevel(Thema[247].Caption);
    ThemenListe.AddObject('Topic247', Thema[247]);
    HndEditor.SetAsTopicContent(aEditor, Thema[247].TopicID);
    // Thema 249: 15.3.  Operator - Zuweisung
    Thema[248] := TThema.Create;
    Thema[248].Caption := '15.3.  Operator - Zuweisung';
    Thema[248].TopicID := HndTopics.CreateTopic;
    Thema[248].TopicLevel := GetLevel(Thema[248].Caption);
    ThemenListe.AddObject('Topic248', Thema[248]);
    HndEditor.SetAsTopicContent(aEditor, Thema[248].TopicID);
    // Thema 250: 15.4.  Arithmetische Operatoren
    Thema[249] := TThema.Create;
    Thema[249].Caption := '15.4.  Arithmetische Operatoren';
    Thema[249].TopicID := HndTopics.CreateTopic;
    Thema[249].TopicLevel := GetLevel(Thema[249].Caption);
    ThemenListe.AddObject('Topic249', Thema[249]);
    HndEditor.SetAsTopicContent(aEditor, Thema[249].TopicID);
    // Thema 251: 15.5.  Vergleichende Operatoren
    Thema[250] := TThema.Create;
    Thema[250].Caption := '15.5.  Vergleichende Operatoren';
    Thema[250].TopicID := HndTopics.CreateTopic;
    Thema[250].TopicLevel := GetLevel(Thema[250].Caption);
    ThemenListe.AddObject('Topic250', Thema[250]);
    HndEditor.SetAsTopicContent(aEditor, Thema[250].TopicID);
    // Thema 252: 15.6.  In Operator
    Thema[251] := TThema.Create;
    Thema[251].Caption := '15.6.  In Operator';
    Thema[251].TopicID := HndTopics.CreateTopic;
    Thema[251].TopicLevel := GetLevel(Thema[251].Caption);
    ThemenListe.AddObject('Topic251', Thema[251]);
    HndEditor.SetAsTopicContent(aEditor, Thema[251].TopicID);
    // Thema 253: 15.7.  Logik Operatoren
    Thema[252] := TThema.Create;
    Thema[252].Caption := '15.7.  Logik Operatoren';
    Thema[252].TopicID := HndTopics.CreateTopic;
    Thema[252].TopicLevel := GetLevel(Thema[252].Caption);
    ThemenListe.AddObject('Topic252', Thema[252]);
    HndEditor.SetAsTopicContent(aEditor, Thema[252].TopicID);
    // Thema 254: 15.8.  Auf- und Ab-Zählungs Operatoren
    Thema[253] := TThema.Create;
    Thema[253].Caption := '15.8.  Auf- und Ab-Zählungs Operatoren';
    Thema[253].TopicID := HndTopics.CreateTopic;
    Thema[253].TopicLevel := GetLevel(Thema[253].Caption);
    ThemenListe.AddObject('Topic253', Thema[253]);
    HndEditor.SetAsTopicContent(aEditor, Thema[253].TopicID);
    // Thema 255: 15.9.  Aufzählungs - Operator
    Thema[254] := TThema.Create;
    Thema[254].Caption := '15.9.  Aufzählungs - Operator';
    Thema[254].TopicID := HndTopics.CreateTopic;
    Thema[254].TopicLevel := GetLevel(Thema[254].Caption);
    ThemenListe.AddObject('Topic254', Thema[254]);
    HndEditor.SetAsTopicContent(aEditor, Thema[254].TopicID);
    // Thema 256: 16.  Programme, Module und Blöcke
    Thema[255] := TThema.Create;
    Thema[255].Caption := '16.  Programme, Module und Blöcke';
    Thema[255].TopicID := HndTopics.CreateTopic;
    Thema[255].TopicLevel := GetLevel(Thema[255].Caption);
    ThemenListe.AddObject('Topic255', Thema[255]);
    HndEditor.SetAsTopicContent(aEditor, Thema[255].TopicID);
    // Thema 257: 16.1.  Programme
    Thema[256] := TThema.Create;
    Thema[256].Caption := '16.1.  Programme';
    Thema[256].TopicID := HndTopics.CreateTopic;
    Thema[256].TopicLevel := GetLevel(Thema[256].Caption);
    ThemenListe.AddObject('Topic256', Thema[256]);
    HndEditor.SetAsTopicContent(aEditor, Thema[256].TopicID);
    // Thema 258: 16.2.  Module (Unit''s)
    Thema[257] := TThema.Create;
    Thema[257].Caption := '16.2.  Module (Unit''s)';
    Thema[257].TopicID := HndTopics.CreateTopic;
    Thema[257].TopicLevel := GetLevel(Thema[257].Caption);
    ThemenListe.AddObject('Topic257', Thema[257]);
    HndEditor.SetAsTopicContent(aEditor, Thema[257].TopicID);
    // Thema 259: 16.3.  Namensräume
    Thema[258] := TThema.Create;
    Thema[258].Caption := '16.3.  Namensräume';
    Thema[258].TopicID := HndTopics.CreateTopic;
    Thema[258].TopicLevel := GetLevel(Thema[258].Caption);
    ThemenListe.AddObject('Topic258', Thema[258]);
    HndEditor.SetAsTopicContent(aEditor, Thema[258].TopicID);
    // Thema 260: 16.4.  Abhängigkeiten von Modulen
    Thema[259] := TThema.Create;
    Thema[259].Caption := '16.4.  Abhängigkeiten von Modulen';
    Thema[259].TopicID := HndTopics.CreateTopic;
    Thema[259].TopicLevel := GetLevel(Thema[259].Caption);
    ThemenListe.AddObject('Topic259', Thema[259]);
    HndEditor.SetAsTopicContent(aEditor, Thema[259].TopicID);
    // Thema 261: 16.5.  Blöcke
    Thema[260] := TThema.Create;
    Thema[260].Caption := '16.5.  Blöcke';
    Thema[260].TopicID := HndTopics.CreateTopic;
    Thema[260].TopicLevel := GetLevel(Thema[260].Caption);
    ThemenListe.AddObject('Topic260', Thema[260]);
    HndEditor.SetAsTopicContent(aEditor, Thema[260].TopicID);
    // Thema 262: 16.6.  Anwendungsbereiche (Scope)
    Thema[261] := TThema.Create;
    Thema[261].Caption := '16.6.  Anwendungsbereiche (Scope)';
    Thema[261].TopicID := HndTopics.CreateTopic;
    Thema[261].TopicLevel := GetLevel(Thema[261].Caption);
    ThemenListe.AddObject('Topic261', Thema[261]);
    HndEditor.SetAsTopicContent(aEditor, Thema[261].TopicID);
    // Thema 263: 16.6.1.  Blöcke
    Thema[262] := TThema.Create;
    Thema[262].Caption := '16.6.1.  Blöcke';
    Thema[262].TopicID := HndTopics.CreateTopic;
    Thema[262].TopicLevel := GetLevel(Thema[262].Caption);
    ThemenListe.AddObject('Topic262', Thema[262]);
    HndEditor.SetAsTopicContent(aEditor, Thema[262].TopicID);
    // Thema 264: 16.6.2.  Record''s
    Thema[263] := TThema.Create;
    Thema[263].Caption := '16.6.2.  Record''s';
    Thema[263].TopicID := HndTopics.CreateTopic;
    Thema[263].TopicLevel := GetLevel(Thema[263].Caption);
    ThemenListe.AddObject('Topic263', Thema[263]);
    HndEditor.SetAsTopicContent(aEditor, Thema[263].TopicID);
    // Thema 265: 16.6.3.  Klassen
    Thema[264] := TThema.Create;
    Thema[264].Caption := '16.6.3.  Klassen';
    Thema[264].TopicID := HndTopics.CreateTopic;
    Thema[264].TopicLevel := GetLevel(Thema[264].Caption);
    ThemenListe.AddObject('Topic264', Thema[264]);
    HndEditor.SetAsTopicContent(aEditor, Thema[264].TopicID);
    // Thema 266: 16.6.4.  Unit''s
    Thema[265] := TThema.Create;
    Thema[265].Caption := '16.6.4.  Unit''s';
    Thema[265].TopicID := HndTopics.CreateTopic;
    Thema[265].TopicLevel := GetLevel(Thema[265].Caption);
    ThemenListe.AddObject('Topic265', Thema[265]);
    HndEditor.SetAsTopicContent(aEditor, Thema[265].TopicID);
    // Thema 267: 16.7.  Bibliotheken
    Thema[266] := TThema.Create;
    Thema[266].Caption := '16.7.  Bibliotheken';
    Thema[266].TopicID := HndTopics.CreateTopic;
    Thema[266].TopicLevel := GetLevel(Thema[266].Caption);
    ThemenListe.AddObject('Topic266', Thema[266]);
    HndEditor.SetAsTopicContent(aEditor, Thema[266].TopicID);
    // Thema 268: 17.  Ausnahmen
    Thema[267] := TThema.Create;
    Thema[267].Caption := '17.  Ausnahmen';
    Thema[267].TopicID := HndTopics.CreateTopic;
    Thema[267].TopicLevel := GetLevel(Thema[267].Caption);
    ThemenListe.AddObject('Topic267', Thema[267]);
    HndEditor.SetAsTopicContent(aEditor, Thema[267].TopicID);
    // Thema 269: 17.1.  Die RAISE Anweisung
    Thema[268] := TThema.Create;
    Thema[268].Caption := '17.1.  Die RAISE Anweisung';
    Thema[268].TopicID := HndTopics.CreateTopic;
    Thema[268].TopicLevel := GetLevel(Thema[268].Caption);
    ThemenListe.AddObject('Topic268', Thema[268]);
    HndEditor.SetAsTopicContent(aEditor, Thema[268].TopicID);
    // Thema 270: 17.2.  Ausnahme-Behandlung und Verschachtelung
    Thema[269] := TThema.Create;
    Thema[269].Caption := '17.2.  Ausnahme-Behandlung und Verschachtelung';
    Thema[269].TopicID := HndTopics.CreateTopic;
    Thema[269].TopicLevel := GetLevel(Thema[269].Caption);
    ThemenListe.AddObject('Topic269', Thema[269]);
    HndEditor.SetAsTopicContent(aEditor, Thema[269].TopicID);
    // Thema 271: 18.  Assembler
    Thema[270] := TThema.Create;
    Thema[270].Caption := '18.  Assembler';
    Thema[270].TopicID := HndTopics.CreateTopic;
    Thema[270].TopicLevel := GetLevel(Thema[270].Caption);
    ThemenListe.AddObject('Topic270', Thema[270]);
    HndEditor.SetAsTopicContent(aEditor, Thema[270].TopicID);
    // Thema 272: 18.1.  Anweisungen
    Thema[271] := TThema.Create;
    Thema[271].Caption := '18.1.  Anweisungen';
    Thema[271].TopicID := HndTopics.CreateTopic;
    Thema[271].TopicLevel := GetLevel(Thema[271].Caption);
    ThemenListe.AddObject('Topic271', Thema[271]);
    HndEditor.SetAsTopicContent(aEditor, Thema[271].TopicID);
    // Thema 273: 18.2.  Prozeduren und Funktionen
    Thema[272] := TThema.Create;
    Thema[272].Caption := '18.2.  Prozeduren und Funktionen';
    Thema[272].TopicID := HndTopics.CreateTopic;
    Thema[272].TopicLevel := GetLevel(Thema[272].Caption);
    ThemenListe.AddObject('Topic272', Thema[272]);
    HndEditor.SetAsTopicContent(aEditor, Thema[272].TopicID);
    // Thema 274: Anhang
    Thema[273] := TThema.Create;
    Thema[273].Caption := 'Anhang';
    Thema[273].TopicID := HndTopics.CreateTopic;
    Thema[273].TopicLevel := GetLevel(Thema[273].Caption);
    ThemenListe.AddObject('Topic273', Thema[273]);
    HndEditor.SetAsTopicContent(aEditor, Thema[273].TopicID);
    // Thema 275: Syntax
    Thema[274] := TThema.Create;
    Thema[274].Caption := 'Syntax';
    Thema[274].TopicID := HndTopics.CreateTopic;
    Thema[274].TopicLevel := GetLevel(Thema[274].Caption);
    ThemenListe.AddObject('Topic274', Thema[274]);
    HndEditor.SetAsTopicContent(aEditor, Thema[274].TopicID);

    print('2.  generate tree...');
    for p := Low(Thema) to High(Thema) do
    begin
      if Assigned(Thema[p]) then
      begin
        HndTopics.SetTopicCaption(Thema[p].TopicID, Thema[p].Caption);
        if Thema[p].TopicLevel > 1 then
        begin
          for g := 1 to Thema[p].TopicLevel do
          HndTopics.MoveTopicRight(Thema[p].TopicID);
        end;
      end;
    end;
  finally
    print('3.  clean up memory...');
    for i := High(Thema) downto Low(Thema) do
    if Assigned(Thema[i]) then
    Thema[i].Free;
    Thema := nil;
    
    ThemenListe.Clear;
    ThemenListe.Free;
    ThemenListe := nil;
    
    ThemenPage.Clear;
    ThemenPage.Free;
    ThemenPage := nil;
    
    HndEditorHelper.CleanContent(ThemenEditor);
    HndEditor.Clear(ThemenEditor);
    HndEditor.DestroyTemporaryEditor(ThemenEditor);
    
    print('4.  done.');
  end;
end;
begin
  try
    try
      CreateTableOfContents;
    except
      on E: Exception do
      begin
        ShowMessage('Error:' + #13#10 + E.Message);
      end;
    end;
  finally
  end;
end.
