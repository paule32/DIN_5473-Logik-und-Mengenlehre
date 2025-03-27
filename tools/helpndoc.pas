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

// --------------------------------------------------------------------
// there are internal used classes that are stored simplified in a
// TStringList.
// --------------------------------------------------------------------
type
  TEditor = class(TObject)
  private
    ID: String;
    Content: String;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Clear;

    procedure LoadFromFile(AFileName: String);
    procedure LoadFromString(AString: String);
    
    procedure SaveToFile(AFileName: String);
  end;

type
  TTopic = class(TObject)
  private
    TopicTitle  : String ;
    TopicLevel  : Integer;
    TopicID     : String ;
    TopicEditor : TEditor;
  public
    constructor Create(AName: String); overload;
    constructor Create(AName: String; ALevel: Integer); overload;
    destructor Destroy; override;
    
    procedure LoadFromFile(AFileName: String);
    procedure LoadFromString(AString: String);
    
    procedure MoveRight;
  end;

type
  TTemplate = class(TObject)
  end;

type
  TProject = class(TObject)
  private
    FLangCode: String;
    Title : String;
    ID : Integer;
    Topics: Array of TTopic;
    Template: TTemplate;
  public
    constructor Create(AName: String); overload;
    constructor Create; overload;
    destructor Destroy; override;
    
    procedure AddTopic(AName: String; ALevel: String); overload;
    procedure AddTopic(AName: String); overload;
    
    procedure SaveToFile(AFileName: String);
    
    procedure SetTemplate(AFileName: String);
    procedure CleanUp;
  published
  property
    LanguageCode: String read FLangCode write FLangCode;
  end;

// ---------------------------------------------------------------------------
// common used constants and variables...
// ---------------------------------------------------------------------------
var PRO_default: TPoject;

// ---------------------------------------------------------------------------
// calculates the indent level of the numbering TOC String
// ---------------------------------------------------------------------------
function GetLevel(const TOCString: String): Integer;
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

{ TEditor }

// ---------------------------------------------------------------------------
// \brief This is the constructor for class TEditor. A new Content Editor
//         object will be created. The default state is empty.
// ---------------------------------------------------------------------------
constructor TEditor.Create;
begin
  inherited Create;
  ID := HndEditor.CreateTemporaryEditor;
  Clear;
end;

// ---------------------------------------------------------------------------
// \brief This is the destructor for class EDitor. Here, we try to remove so
//         much memory as possible that was allocated before.
// ---------------------------------------------------------------------------
destructor TEditor.Destroy;
begin
  Clear;
  HndEditor.DestroyTemporaryEditor(ID);
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// \brief This function make the current content editor clean for new input.
// ---------------------------------------------------------------------------
procedure TEditor.Clear;
begin
  if not Assigned(ID) then
  raise Exception.Create('Editor not created.');
  
  HndEditorHelper.CleanContent(ID);
  HndEditor.Clear(ID);
end;

// ---------------------------------------------------------------------------
// \brief This function loads the HTML Content for the current content editor
//         Warning: Existing Code will be overwrite through this function !
// ---------------------------------------------------------------------------
procedure TEditor.LoadFromFile(AFileName: String);
var strList: TStringList;
begin
  if Length(Trim(ID)) < 1 then
  raise Exception.Create('Error: Editor ID unknown.');
  try
    try
      strList := TStringList.Create;
      strList.LoadFromFile(AFileName);
      Content := Trim(strList.Text);
      
      HndEditor.InsertContentFromHTML(ID, Content);
    except
      on E: Exception do
      raise Exception.Create('Error: editor content can not load from file.');
    end;
  finally
    strList.Clear;
    strList.Free;
    strList := nil;
  end;
end;

// ---------------------------------------------------------------------------
// \brief This function load the HTML Content for the current Content Editor
//         by the given AString HTML code.
//         Warning: Existing Code will be overwrite throug this function !
// ---------------------------------------------------------------------------
procedure TEditor.LoadFromString(AString: String);
begin
  if Length(Trim(ID)) < 1 then
  raise Exception.Create('Error: editor ID unknown.');
  try
    Content := Trim/AFileName);
    HndEditor.InsertContentFromHTML(ID, AString);
  except
    on E: Exception do
    raise Exception.Create('Error: editor content could not set.');
  end;
end;

procedure TEditor.SaveToFile(AFileName: String);
begin
  //GetContentAsHtml()
end;

{ TTopic }

// ---------------------------------------------------------------------------
// \brief This is the constructor for class TTopic. It creates a new fresh
//         Topic with given AName and a indent with ALevel.
// ---------------------------------------------------------------------------
constructor TTopic.Create(AName: String; ALevel: Integer);
begin
  inherited Create;
  
  TopicTitle  := AName;
  TopicLevel  := ALevel;
  TopicID     := HndTopics.CreateTopic;
  
  HndTopics.SetTopicCaption(TopicID, TopicTitle);
  MoveRight;
  
  TopicEditor := TEditor.Create;
end;

// ---------------------------------------------------------------------------
// \brief This is a overloaded constructor for class TTopic. It creates a new
//         fresh Topic if the given AName, and a indent which is automatically
//         filled in.
// ---------------------------------------------------------------------------
constructor TTopic.Create(AName: String);
begin
  inherited Create;
  
  TopicTitle  := AName;
  TopicLevel  := GetLevel(TopicTitle);
  TopicID     := HndTopics.CreateTopic;
  
  HndTopics.SetTopicCaption(TopicID, TopicTitle);
  MoveRight;
  
  TopicEditor := TEditor.Create;
end;

// ---------------------------------------------------------------------------
// \brief This is the destructor for class TTopic. Here we try to remove so
//         much memory as possible is allocated before.
// ---------------------------------------------------------------------------
destructor TTopic.Destroy;
begin
  TopicEditor.Free;
  TopicEditor := nil;
  
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// \brief This is a place holder function to reduce code redundance.
// ---------------------------------------------------------------------------
procedure TTopic.MoveRight;
var idx: Integer;
begin
  if TopicLevel > 1 then
  begin
    for idx := 1 to TopicLevel do
    HndTopics.MoveTopicRight(TopicID);
  end;
end;

// ---------------------------------------------------------------------------
// \brief This function loads the Topic Content from a File and fill it into
//         the Content Editor.
// ---------------------------------------------------------------------------
procedure TTopic.LoadFromFile(AFileName: String);
var strList: TStringList;
begin
  try
    try
      strList := TStringList.Create;
      strList.LoadFromFile(AFileName);
      Content := Trim(strList.Text);
      
      HndEditor.InsertContentFromHTML(ID, Content);
    except
      on E: Exception do
      raise Exception.Create('Error: editor content can not load from file.');
    end;
  finally
    strList.Clear;
    strList.Free;
    strList := nil;
  end;
end;

procedure TTopic.LoadFromString(AString: String);
begin
end;

{ TProject }

// ---------------------------------------------------------------------------
// \brief This is the constructor for class TProject. It creates a new fresh
//         Project with the given AName.
// ---------------------------------------------------------------------------
constructor TProject.Create(AName: String);
begin
  inherited Create;
  
  try
    Title     := AName;
    ID        := HndProjects.NewProject(AName);
    FLangCode := 'en-us';
    
    HndProjects.SetProjectModified(True);
    HndProjects.SetProjectLanguageCode(FLangCode);
    HndProjects.SaveProject;
  except
    on E: Exception do
    raise Exception.Create('Project file could not be created.');
  end;
end;

// ---------------------------------------------------------------------------
// \brief This is the overloaded constructor to create a new Project with the
//         default settings.
// ---------------------------------------------------------------------------
constructor TProject.Create;
begin
  inherited Create;
  
  try
    Title     := 'default.hnd';
    ID        := HndProjects.NewProject(Title);
    FLangCode := 'en-us';
    
    HndProjects.SetProjectModified(True);
    HndProjects.SetProjectLanguageCode(FLangCode);
    HndProjects.SaveProject;
  except
    on E: Exception do
    raise Exception.Create();
  end;
end;

// ---------------------------------------------------------------------------
// \brief This is the destructor of class TProject. Here we try to remove so
//         much memory as possible is allocated before.
// ---------------------------------------------------------------------------
destructor TProject.Destroy;
var index: Integer;
begin
  CleanUp;
  
  HndProjects.CloseProject;
  inherited Destroy;
end;

procedure TProject.CleanUp;
var index: Integer;
begin
  for index := High(Topics) downto Low(Topics) do
  begin
    Topics[index].Free;
    Topics[index] = nil;
  end;
  Topics := nil;
end;

// ---------------------------------------------------------------------------
// \brief This function save the HTML Content and Project Data to storage.
// ---------------------------------------------------------------------------
procedure TProject.SaveToFile(AFileName: String);
begin
  if Length(Trim(ID)) < 1 then
  raise Exception.Create('Error: Project ID is nil.')
  
  if Length(Trim(AFileName)) > 0 then
  HndProjects.CopyProject(AFileName, false) else
  HndProjects.SaveProject;
end;

// ---------------------------------------------------------------------------
// \brief add an new Topic with AName and ALevel
// ---------------------------------------------------------------------------
procedure TProject.AddTopic(AName: String; ALevel: Integer);
var
  Topic: TTopic;
begin
  try
    Topic  := TTopic.Create(AName, ALevel);
    HndEditor.SetAsTopicContent(Topic.TopicEditor, Topic.TopicID);
    Topics := Topics + [Topic];
  except
    on E: Exception do
    raise Exception.Create('Error: can not create topic.');
  end;
end;

// ---------------------------------------------------------------------------
// \brief add a new Topic with AName. the level is getting by GetLevel
// ---------------------------------------------------------------------------
procedure TProject.AddTopic(AName: String);
var
  Topic: TTopic;
begin
  try
    Topic  := TTopic.Create(AName, GetLevel(AName));
    HndEditor.SetAsTopicContent(Topic.TopicEditor, Topic.TopicID);
    Topics := Topics + [Topic];
  except
    on E: Exception do
    raise Exception.Create('Error: can not create topic.');
  end;
end;

procedure TProject.SetTemplate(AFileName: String);
begin
end;

// ---------------------------------------------------------------------------
// \brief This function extracts the Topic Caption/Titel of the given String.
// ---------------------------------------------------------------------------
function ExtractTitel(const TOCString: String): String;
var
  posSpace: Integer;
begin
  // -------------------------------------
  // find white space after numbering ...
  // -------------------------------------
  posSpace := Pos(' ', TOCString);
  if posSpace > 0 then
  Result := Copy(TOCString, posSpace + 1, Length(TOCString)) else
  
  // --------------------
  // if no white space...
  // --------------------
  Result := TOCString;
end;

// ---------------------------------------------------------------------------
// \brief  This function create a fresh new Project. If a Project with the
//         name already exists, then it will be overwrite !
//
// \param  projectName - String: The name of the Project.
// ---------------------------------------------------------------------------
procedure CreateProject(const projectName: String);
var projectID: String;
begin
  result := '';
  PRO_default := TProject.Create(projectName);
end;

// ---------------------------------------------------------------------------
// \brief This function create the Table of Contents (TOC).
// ---------------------------------------------------------------------------
procedure CreateTableOfContents;
var i, p, g: Integer;
var project: TProject;
begin
  PRO_default := TProject.Create('default')
  try
    print('1. pre-processing data...');
    project := TProject.Create('default');
    project.SetTemplate(HelpNDocTemplateHTM);

    project.AddTopic('Lizenz - Bitte lesen !!!');
    project.AddTopic('Überblich');
    project.AddTopic('Inhalt');
    project.AddTopic('Liste der Tabellen');
    project.AddTopic('Über dieses Handbuch');
    project.AddTopic('Bezeichnungen');
    project.AddTopic('Syntax Diagramme');
    project.AddTopic('Über die Sprache Pascal');
    project.AddTopic('1.  Pascal Zeichen und Symbole');
    project.AddTopic('1.1  Symbole');
    project.AddTopic('1.2  Kommentare');
    project.AddTopic('1.3  Reservierte Schlüsselwörter');
    project.AddTopic('1.3.1.  Turbo Pascal');
    project.AddTopic('1.3.2.  Object Pascal');
    project.AddTopic('1.3.3.  Modifikationen');
    project.AddTopic('1.4.  Kennzeichnungen');
    project.AddTopic('1.5.  Hinweise und Direktiven');
    project.AddTopic('1.6.  Zahlen');
    project.AddTopic('1.7.  Bezeichner');
    project.AddTopic('1.8.  Zeichenketten');
    project.AddTopic('2.  Konstanten');
    project.AddTopic('2.1.  Gewöhnliche Konstanten');
    project.AddTopic('2.2.  Typisierte Konstanten');
    project.AddTopic('2.3.  Resourcen Zeichenketten');
    project.AddTopic('3.  Typen');
    project.AddTopic('3.1.  Basistypen');
    project.AddTopic('3.1.1.  Ordinale Typen');
    project.AddTopic('3.1.2.  Ganze Zahlen (Integer)');
    project.AddTopic('3.1.3.  Boolesche Typen');
    project.AddTopic('3.1.4.  Aufzählungen');
    project.AddTopic('3.1.5.  Untermengen');
    project.AddTopic('3.1.6.  Zeichen');
    project.AddTopic('3.2.  Zeichen-Typen');
    project.AddTopic('3.2.1.  Char oder AnsiChar');
    project.AddTopic('3.2.2.  WideChar');
    project.AddTopic('3.2.3.  Sonstige');
    project.AddTopic('3.2.4.  Einzel-Byte Zeichenketten');
    project.AddTopic('3.2.4.1.  ShortString');
    project.AddTopic('3.2.4.2.  AnsiString');
    project.AddTopic('3.2.4.3.  Zeichen-Code Umwandlung');
    project.AddTopic('3.2.4.4.  RawByteString');
    project.AddTopic('3.2.4.5.  UTF8String');
    project.AddTopic('3.2.5.  Multi-Byte Zeichenketten');
    project.AddTopic('3.2.5.1.  UnicodeString');
    project.AddTopic('3.2.5.2.  WideString');
    project.AddTopic('3.2.6.  Konstante Zeichenketten');
    project.AddTopic('3.2.7.  Nullterminierente Zeichenketten (PChar)');
    project.AddTopic('3.2.8.  Zeichenketten-Größen');
    project.AddTopic('3.3.  Strukturierte Typen');
    project.AddTopic('3.3.1.  Gepackte Struktur-Typen');
    project.AddTopic('3.3.2.  Array''s');
    project.AddTopic('3.3.2.1.  Statische Array''s');
    project.AddTopic('3.3.2.2.  Dynamische Array''s');
    project.AddTopic('3.3.2.3:  Typen-Kompatibilität dynamischer Array''s');
    project.AddTopic('3.3.2.4.  Constuctor dynamischer Array''s');
    project.AddTopic('3.3.2.5.  Feldkonstanten-Ausdrücke dynamiscer Array''s');
    project.AddTopic('3.3.2.6.  Packen und Entpacken eines Array''s');
    project.AddTopic('3.3.3.  Record''s');
    project.AddTopic('3.3.3.1.  Layout und Größe');
    project.AddTopic('3.3.3.2.  Bemerkungen und Beispiele');
    project.AddTopic('3.3.4.  Mengen-Typen');
    project.AddTopic('3.3.5.  Datei-Typen');
    project.AddTopic('3.4.  Zeiger');
    project.AddTopic('3.5.  Forward-Deklarationen');
    project.AddTopic('3.6.  Prozedur-Typen');
    project.AddTopic('3.7.  Variant''s');
    project.AddTopic('3.7.1.  Definition');
    project.AddTopic('3.7.2.  Variant''s in Zuweisungen und Ausdrücken');
    project.AddTopic('3.7.3.  Variant''s im Interface-Teil');
    project.AddTopic('3.8.  Alias-Typen');
    project.AddTopic('3.9.  Verwaltete Typen');
    project.AddTopic('4.  Variablen');
    project.AddTopic('4.1.  Definition');
    project.AddTopic('4.2.  Erklärung');
    project.AddTopic('4.3.  Geltungssbereich');
    project.AddTopic('4.4.  Initialisierte Variablen');
    project.AddTopic('4.5.  Initialisierte Variablen mit Standard-Wert');
    project.AddTopic('4.6.  Thread-Variablen');
    project.AddTopic('4.7.  Eigenschaften');
    project.AddTopic('5.  Objekte');
    project.AddTopic('5.1.  Deklaration');
    project.AddTopic('5.2.  Abtrakte und Sealed Objekte');
    project.AddTopic('5.3.  Felder');
    project.AddTopic('5.4.  Klassen oder statische Felder');
    project.AddTopic('5.5.  Constructor und Destructor');
    project.AddTopic('5.6.  Methoden');
    project.AddTopic('5.6.1.  Erklärung');
    project.AddTopic('5.6.2.  Methoden-Aufruf');
    project.AddTopic('5.6.2.1.  Statische Methoden');
    project.AddTopic('5.6.2.2.  Virtuelle Methoden');
    project.AddTopic('5.6.2.3.  Abstrakte Methoden');
    project.AddTopic('5.6.2.4.  Klassen-Methoden oder statische Methoden');
    project.AddTopic('5.7.  Sichtbarkeit');
    project.AddTopic('6.  Klassen');
    project.AddTopic('6.1.  Klassen-Definitionen');
    project.AddTopic('6.2.  Abstrakte und Sealed Klassen');
    project.AddTopic('6.3.  Normale und statische Felder');
    project.AddTopic('6.3.1.  Normalisierte Felder / Variablen');
    project.AddTopic('6.3.2.  Klassen-Felder / Variablen');
    project.AddTopic('6.4.  Klassen - CTOR (constructor)');
    project.AddTopic('6.5.  Klassen - DTOR (destructor)');
    project.AddTopic('6.6.  Methoden');
    project.AddTopic('6.6.1.  Erklärung');
    project.AddTopic('6.6.2.  Aufrufen');
    project.AddTopic('6.6.3.  Virtuelle Methoden');
    project.AddTopic('6.6.4.  Klassen - Methoden');
    project.AddTopic('6.6.5.  Klassen CTOR und DTOR');
    project.AddTopic('6.6.6.  Statische Klassen - Methoden');
    project.AddTopic('6.6.7.  Nachrichten - Methoden');
    project.AddTopic('6.6.8.  Vererbung');
    project.AddTopic('6.7.  Eigenschaften');
    project.AddTopic('6.7.1.  Definition');
    project.AddTopic('6.7.2.  Indezierte Eigenschaften');
    project.AddTopic('6.7.3.  Array basierte Eigenschaften');
    project.AddTopic('6.7.4.  Standard - Eigenschaften (public)');
    project.AddTopic('6.7.5.  Veröffentlichte - Eigenschaften (published)');
    project.AddTopic('6.7.6.  Speicherinformationen');
    project.AddTopic('6.7.7.  Eigenschaften überschreiben und neu deklarieren');
    project.AddTopic('6.8.  Klassen - Eigenschaften');
    project.AddTopic('6.9.  Verschachtelte Typen, Konstanten, und Variablen');
    project.AddTopic('7.  Schnittstellen (Interface''s)');
    project.AddTopic('7.1.  Definition');
    project.AddTopic('7.2.  Identifikation');
    project.AddTopic('7.3.  Implementierung');
    project.AddTopic('7.4.  Vererbung');
    project.AddTopic('7.5.  Delegation');
    project.AddTopic('7.6.  COM');
    project.AddTopic('7.7.  CORBA und andere Schnittstellen');
    project.AddTopic('7.8.  Referenzzählung');
    project.AddTopic('8.  Generics');
    project.AddTopic('8.1.  Einführung');
    project.AddTopic('8.2.  Get''ter Typ - Definition');
    project.AddTopic('8.3.  Typen - Spezialisierung');
    project.AddTopic('8.4.  Einschränkungen');
    project.AddTopic('8.5.  Kompatibilität zu Delphi');
    project.AddTopic('8.5.1.  Syntax - Elemente');
    project.AddTopic('8.5.2.  Einschränkungen für Record''s');
    project.AddTopic('8.5.3.  Typen - Überladung(en)');
    project.AddTopic('8.5.4.  Überlegungen für Namensbereiche');
    project.AddTopic('8.6.  Typen-Kompatibilität');
    project.AddTopic('8.7.  Verwendung der eingebauten Funktionen');
    project.AddTopic('8.8.  Überlegungen zum Geltungsbereich');
    project.AddTopic('8.9.  Operator-Überladung und Generics');
    project.AddTopic('9.  Erweiterte Record''s');
    project.AddTopic('9.1.  Definition');
    project.AddTopic('9.2.  Erweiterte Record-Aufzähler');
    project.AddTopic('9.3.  Record-Operationen');
    project.AddTopic('10.  Klassen, Record''s, und Typen-Helfer');
    project.AddTopic('10.1.  Definition');
    project.AddTopic('10.2.  Einschränkungen bei Klassen Helfer');
    project.AddTopic('10.3.  Einschränkungen bei Record  Helfer');
    project.AddTopic('10.4.  Überlegungen zu einfachen Helper');
    project.AddTopic('10.5.  Anmerkungen zu Umfang und Lebensdauer von Record-Helper');
    project.AddTopic('10.6.  Vererbung');
    project.AddTopic('10.7.  Verwendung');
    project.AddTopic('11.  Objektorientierte Pascal - Klassen');
    project.AddTopic('11.1.  Einführung');
    project.AddTopic('11.2.  Klassendeklarationen');
    project.AddTopic('11.3.  Formele Deklaration');
    project.AddTopic('11.4.  Instanzen zuteilen und zuordnen');
    project.AddTopic('11.5.  Protokolldefinitionen');
    project.AddTopic('11.6.  Kategorien');
    project.AddTopic('11.7.  Namensumfang und Bezeichner');
    project.AddTopic('11.8.  Selektoren');
    project.AddTopic('11.9.  Der ID Typ');
    project.AddTopic('11.10. Aufzählungen in Objective-C Klassen');
    project.AddTopic('12.  Ausdrücke');
    project.AddTopic('12.1.  Ausdrucks - Syntax');
    project.AddTopic('12.2.  Funktionsaufrufe');
    project.AddTopic('12.3.  Mengen - CTOR');
    project.AddTopic('12.4.  Typ-Casting von Werten');
    project.AddTopic('12.5.  Typ-Casting von Variablen');
    project.AddTopic('12.6.  Sonstige Typ-Casting''s');
    project.AddTopic('12.7.  Der @ - Operator');
    project.AddTopic('12.8.  Operatoren');
    project.AddTopic('12.8.1.  Arithmetische Operatoren');
    project.AddTopic('12.8.2.  Logische Operatoren');
    project.AddTopic('12.8.3.  Boolesche Operatoren');
    project.AddTopic('12.8.4.  Zeichenketten Operatoren');
    project.AddTopic('12.8.5.  Operatoren bei dynamischen Array''s');
    project.AddTopic('12.8.6.  Mengen - Operatoren');
    project.AddTopic('12.8.7.  Relationale Operatoren');
    project.AddTopic('12.8.8.  Klassen - Operatoren');
    project.AddTopic('13.  Anweisungen');
    project.AddTopic('13.1.  Einfache Anweisungen');
    project.AddTopic('13.1.1.  Zuweisungen');
    project.AddTopic('13.1.2.  Prozeduren - PROCEDURE');
    project.AddTopic('13.1.3.  Sprungs - Anweisung GOTO');
    project.AddTopic('13.2.  Strukturierte Anweisungen');
    project.AddTopic('13.2.1.  Zusammengesetzte Anweisungen');
    project.AddTopic('13.2.2.  CASE');
    project.AddTopic('13.2.3.  IF ... THEN');
    project.AddTopic('13.2.4.  FOR ... TO / DOWNTO ... DO');
    project.AddTopic('13.2.5.  FOR .. IN .. DO');
    project.AddTopic('13.2.6.  REPEAT ... UNTIL');
    project.AddTopic('13.2.7.  WHILE ... DO');
    project.AddTopic('13.2.8.  WITH');
    project.AddTopic('13.2.9.  Ausnahmen (EXCEPT)');
    project.AddTopic('13.3.  Assembler Anweisungen');
    project.AddTopic('14.  Benutzung von Funktionen und Prozeduren');
    project.AddTopic('14.1.  FUNCTION Deklarationen');
    project.AddTopic('14.2.  PROCEDURE Deklarationen');
    project.AddTopic('14.3.  Funktion Rückgabewert mittels RESULT');
    project.AddTopic('14.4.  Parameter Listen');
    project.AddTopic('14.4.1.  Werte');
    project.AddTopic('14.4.2.  Variablen');
    project.AddTopic('14.4.3.  Ausgabe Parameter');
    project.AddTopic('14.4.4.  Konstante Parameter');
    project.AddTopic('14.4.5.  Offene Array''s');
    project.AddTopic('14.4.6.  Array of Const');
    project.AddTopic('14.4.7.  Untypisierte Parameter');
    project.AddTopic('14.4.8.  Verwaltete Typen und Referenzzähler');
    project.AddTopic('14.5.  Überladung von Funktionen');
    project.AddTopic('14.6.  Mit FORWARD deklarierte Funktionen');
    project.AddTopic('14.7.  Externe Funktionen');
    project.AddTopic('14.8.  Assembler Funktionen');
    project.AddTopic('14.9.  Modifikatoren');
    project.AddTopic('14.9.1.  alias');
    project.AddTopic('14.9.2.  cdecl');
    project.AddTopic('14.9.3.  cppdecl');
    project.AddTopic('14.9.4.  export');
    project.AddTopic('14.9.5.  hardfloat');
    project.AddTopic('14.9.6.  inline');
    project.AddTopic('14.9.7.  interrupt');
    project.AddTopic('14.9.8.  iocheck');
    project.AddTopic('14.9.9.  local');
    project.AddTopic('14.9.10.  MS_ABI_Default');
    project.AddTopic('14.9.11.  MS_ABI_CDecl');
    project.AddTopic('14.9.12.  MWPascal');
    project.AddTopic('14.9.13.  noreturn');
    project.AddTopic('14.9.14.  nostackframe');
    project.AddTopic('14.9.15.  overload');
    project.AddTopic('14.9.16.  pascal');
    project.AddTopic('14.9.17.  public');
    project.AddTopic('14.9.18.  register');
    project.AddTopic('14.9.19.  safecall');
    project.AddTopic('14.9.20.  saveregisters');
    project.AddTopic('14.9.21.  softfloat');
    project.AddTopic('14.9.22.  stdcall');
    project.AddTopic('14.9.23.  SYSV_ABI_Default');
    project.AddTopic('14.9.24.  SYSV_ABI_CDecl');
    project.AddTopic('14.9.25.  VectorCall');
    project.AddTopic('14.9.26.  varargs');
    project.AddTopic('14.9.27.  winapi');
    project.AddTopic('14.10.  Nicht unterstützte Modifikatoren');
    project.AddTopic('15.  Operatoren Überladung');
    project.AddTopic('15.1.  Einleitung');
    project.AddTopic('15.2.  Operatoren - Deklarationen');
    project.AddTopic('15.3.  Operator - Zuweisung');
    project.AddTopic('15.4.  Arithmetische Operatoren');
    project.AddTopic('15.5.  Vergleichende Operatoren');
    project.AddTopic('15.6.  In Operator');
    project.AddTopic('15.7.  Logik Operatoren');
    project.AddTopic('15.8.  Auf- und Ab-Zählungs Operatoren');
    project.AddTopic('15.9.  Aufzählungs - Operator');
    project.AddTopic('16.  Programme, Module und Blöcke');
    project.AddTopic('16.1.  Programme');
    project.AddTopic('16.2.  Module (Unit''s)');
    project.AddTopic('16.3.  Namensräume');
    project.AddTopic('16.4.  Abhängigkeiten von Modulen');
    project.AddTopic('16.5.  Blöcke');
    project.AddTopic('16.6.  Anwendungsbereiche (Scope)');
    project.AddTopic('16.6.1.  Blöcke');
    project.AddTopic('16.6.2.  Record''s');
    project.AddTopic('16.6.3.  Klassen');
    project.AddTopic('16.6.4.  Unit''s');
    project.AddTopic('16.7.  Bibliotheken');
    project.AddTopic('17.  Ausnahmen');
    project.AddTopic('17.1.  Die RAISE Anweisung');
    project.AddTopic('17.2.  Ausnahme-Behandlung und Verschachtelung');
    project.AddTopic('18.  Assembler');
    project.AddTopic('18.1.  Anweisungen');
    project.AddTopic('18.2.  Prozeduren und Funktionen');
    project.AddTopic('Anhang');
    project.AddTopic('Syntax');

  finally
    print('3.  clean up memory...');
    PRO_default.Free;
    PRO_default := nil;
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
