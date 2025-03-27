# ---------------------------------------------------------
# created on: 2025-03-24 by paule32
# all rights reserved.
# free for education usage - not for commercial use !
# ---------------------------------------------------------
import sys
import os

# --------------------------------------------------------------------
# common exception classes for better readings ...
# --------------------------------------------------------------------
class InputFileError(Exception):
    pass
class OutputPathError(Exception):
    pass
class OutputFileError(Exception):
    pass

# --------------------------------------------------------------------
# place holder definition to minimize code space ...
# --------------------------------------------------------------------
def check_exit(exitCode):
    if not parser == None:
        parser.exit(exitCode)
    sys.exit(exitCode)

# --------------------------------------------------------------------
# try to import needed modules - they should be installed on yout venv
# directory (user space).
# --------------------------------------------------------------------
try:
    import argparse
    #
    from bs4 import BeautifulSoup
    from pathlib import Path

    def parse_hhc_to_topics(hhc_path):
        with open(hhc_path, "r", encoding="utf-8") as file:
            content = file.read()
        soup = BeautifulSoup(content, "html.parser")
        hhc_topics = []
        def parse_ul(ul, depth=0):
            for li in ul.find_all("li", recursive=False):
                obj = li.find("object")
                if obj:
                    title = ""
                    for param in obj.find_all("param"):
                        if param.get("name").lower() == "name":
                            title = param.get("value")
                    hhc_topics.append({
                        "title": title,
                        "depth": depth
                    })
                nested = li.find("ul")
                if nested:
                    parse_ul(nested, depth + 1)
        root_ul = soup.find("ul")
        if root_ul:
            parse_ul(root_ul)
        return hhc_topics

    def generate_helpndoc_pascal(topics):
        lines = []
        lines.append("""
// --------------------------------------------------------------------
// \\file   [::HelpNDocPascalFile::]
// \\autor  (c) 2025 by Jens Kallup - paule32
// \\copy   all rights reserved.
//
// \\detail Read-in an existing Microsoft HTML-Workshop *.hhc file, and
//         extract the topics, generate a HelpNDoc.com Pascal Engine
//         ready Skript for running in/with the Script-Editor.
//         Currently the Text (the Topic Caption's) must occured in
//         numbering like "1. Caption" or "1.1.1. Sub-Caption"
//
// \\param  nothing - the Pascal File is created automatically.
// \\param  toc.hhc - the HTML Help Chapters (for read-in in Python).
//         The Path to this file must be adjusted.
// \\param  TopicTemplate.htm - the HTML Template File that is inserted
//         into the created Topic (Editor). Currently the toc.hhc is
//         assumed in the same directory as this Python Script.
// \\param  ProjectName - the name of the Project, default.hnd.  
//
// \\return HelpNDoc.com compatible TOC Pascal file - HelpNDocPasFile.
//         Currently assumed in the same Directory as this Python Script
//
// \\error  On Error, the User will be informed with the context deepend
//         Error Information's.
// --------------------------------------------------------------------
const HelpNDocTemplateHTM = '[::HelpNDocTemplateHTM::]';
const HelpNDocProjectName = '[::HelpNDocProjectName::]';
const HelpNDocProjectPath = '[::HelpNDocProjectPath::]';

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
    ID: TObject;
    Content: String;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Clear;

    procedure LoadFromFile(AFileName: String);
    procedure LoadFromString(AString: String);
    
    procedure SaveToFile(AFileName: String);
    
    function getID: TObject;
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
    
    function getEditor: TEditor;
    function getID: String;
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
var HelpNDoc_[::HelpNDocProjectPRO::]: TProject;

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
// \\brief This is the constructor for class TEditor. A new Content Editor
//         object will be created. The default state is empty.
// ---------------------------------------------------------------------------
constructor TEditor.Create;
begin
  inherited Create;
  ID := HndEditor.CreateTemporaryEditor;
  Clear;
end;

// ---------------------------------------------------------------------------
// \\brief This is the destructor for class EDitor. Here, we try to remove so
//         much memory as possible that was allocated before.
// ---------------------------------------------------------------------------
destructor TEditor.Destroy;
begin
  Clear;
  HndEditor.DestroyTemporaryEditor(ID);
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// \\brief This function make the current content editor clean for new input.
// ---------------------------------------------------------------------------
procedure TEditor.Clear;
begin
  if not Assigned(ID) then
  raise Exception.Create('Editor not created.');
  
  HndEditorHelper.CleanContent(getID);
  HndEditor.Clear(getID);
end;

// ---------------------------------------------------------------------------
// \\brief This function loads the HTML Content for the current content editor
//         Warning: Existing Code will be overwrite through this function !
// ---------------------------------------------------------------------------
procedure TEditor.LoadFromFile(AFileName: String);
var strList: TStringList;
begin
  if not Assigned(ID) then
  raise Exception.Create('Error: Editor ID unknown.');
  try
    try
      strList := TStringList.Create;
      strList.LoadFromFile(AFileName);
      Content := Trim(strList.Text);
      
      HndEditor.InsertContentFromHTML(getID, Content);
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
// \\brief This function load the HTML Content for the current Content Editor
//         by the given AString HTML code.
//         Warning: Existing Code will be overwrite throug this function !
// ---------------------------------------------------------------------------
procedure TEditor.LoadFromString(AString: String);
begin
  if not Assigned(getID) then
  raise Exception.Create('Error: editor ID unknown.');
  try
    Content := Trim(AFileName);
    HndEditor.InsertContentFromHTML(getID, AString);
  except
    on E: Exception do
    raise Exception.Create('Error: editor content could not set.');
  end;
end;

procedure TEditor.SaveToFile(AFileName: String);
begin
  //GetContentAsHtml()
end;

function TEditor.getID: TObject;
begin
  result := ID;
end;

{ TTopic }

// ---------------------------------------------------------------------------
// \\brief This is the constructor for class TTopic. It creates a new fresh
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
// \\brief This is a overloaded constructor for class TTopic. It creates a new
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
// \\brief This is the destructor for class TTopic. Here we try to remove so
//         much memory as possible is allocated before.
// ---------------------------------------------------------------------------
destructor TTopic.Destroy;
begin
  TopicEditor.Free;
  TopicEditor := nil;
  
  inherited Destroy;
end;

// ---------------------------------------------------------------------------
// \\brief This is a place holder function to reduce code redundance.
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
// \\brief This function loads the Topic Content from a File and fill it into
//         the Content Editor.
// ---------------------------------------------------------------------------
procedure TTopic.LoadFromFile(AFileName: String);
var strList: TStringList;
begin
  try
    try
      strList := TStringList.Create;
      strList.LoadFromFile(AFileName);
      TopicContent := Trim(strList.Text);
      
      HndEditor.InsertContentFromHTML(getEditor.getID, TopicContent);
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

function TTopic.getEditor: TEditor;
begin
  result := TopicEditor;
end;

function TTopic.getID: String;
begin
  result := TopicID;
end;

{ TProject }

// ---------------------------------------------------------------------------
// \\brief This is the constructor for class TProject. It creates a new fresh
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
    HndProjects.SetProjectLanguageCode(850);
    HndProjects.SaveProject;
  except
    on E: Exception do
    raise Exception.Create('Project file could not be created.');
  end;
end;

// ---------------------------------------------------------------------------
// \\brief This is the overloaded constructor to create a new Project with the
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
    HndProjects.SetProjectLanguageCode(850);
    HndProjects.SaveProject;
  except
    on E: Exception do
    raise Exception.Create();
  end;
end;

// ---------------------------------------------------------------------------
// \\brief This is the destructor of class TProject. Here we try to remove so
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
// \\brief This function save the HTML Content and Project Data to storage.
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
// \\brief add an new Topic with AName and ALevel
// ---------------------------------------------------------------------------
procedure TProject.AddTopic(AName: String; ALevel: Integer);
var
  Topic: TTopic;
begin
  try
    Topic  := TTopic.Create(AName, ALevel);
    HndEditor.SetAsTopicContent(Topic.getEditor.getID, Topic.getID);
    Topics := Topics + [Topic];
  except
    on E: Exception do
    raise Exception.Create('Error: can not create topic.');
  end;
end;

// ---------------------------------------------------------------------------
// \\brief add a new Topic with AName. the level is getting by GetLevel
// ---------------------------------------------------------------------------
procedure TProject.AddTopic(AName: String);
var
  Topic: TTopic;
begin
  try
    Topic  := TTopic.Create(AName, GetLevel(AName));
    HndEditor.SetAsTopicContent(Topic.getEditor.getID, Topic.getID);
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
// \\brief This function extracts the Topic Caption/Titel of the given String.
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
// \\brief  This function create a fresh new Project. If a Project with the
//         name already exists, then it will be overwrite !
//
// \\param  projectName - String: The name of the Project.
// ---------------------------------------------------------------------------
procedure CreateProject(const projectName: String);
var projectID: String;
begin
  result := '';
  HelpNDoc_[::HelpNDocProjectPRO::] := TProject.Create(projectName);
end;

// ---------------------------------------------------------------------------
// \\brief This function create the Table of Contents (TOC).
// ---------------------------------------------------------------------------
procedure CreateTableOfContents;
var i, p, g: Integer;
begin
  HelpNDoc_[::HelpNDocProjectPRO::] := TProject.Create('[::HelpNDocProjectPRO::]')
  try
    print('1. pre-processing data...');
    HelpNDoc_[::HelpNDocProjectPRO::].SetTemplate(HelpNDocTemplateHTM);
""")
        # -----------------------------------------------------------------------
        for idx, t in enumerate(hhc_topics):
            title = t["title"].replace("'", "''")
            depth = t["depth"]
            lines.append(f"    HelpNDoc_[::HelpNDocProjectPRO::].AddTopic('{title}');")
        # -----------------------------------------------------------------------
        lines.append("""
  finally
    print('3.  clean up memory...');
    
    HelpNDoc_[::HelpNDocProjectPRO::].Free;
    HelpNDoc_[::HelpNDocProjectPRO::] := nil;
    
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
""")
        # -----------------------------------------------------------------------
        return "\n".join(lines)
    
    # -----------------------------------------------------------------------
    # check if the given input parameter "pname" is a directory. If it a dir
    # then return value is boolean - True; else raise an error.
    # -----------------------------------------------------------------------
    def check_path(pname):
        pathInput = Path(pname)
        if not pathInput.is_dir():
            raise InputPathError('error: name is no path')
        return True
    
    # -----------------------------------------------------------------------
    # check if the given input parameter "fname" is a file or if it exists.
    # if it exists, then return value is True, else raise an error.
    # -----------------------------------------------------------------------
    def check_file(fname):
        pathInput = Path(fname)
        if not pathInput.exists():
            raise InputPathError("error: input path does not exists.")
        if not pathInput.is_file():
            raise InputIsFileError('error: input file does not exists.')
        return True
    
    # -----------------------------------------------------------------------
    # another definition that checks if a fial is exists or not - on context
    # of the argument parser.
    # -----------------------------------------------------------------------
    def file_exists(filepath):
        if not os.path.isfile(filepath):
            raise argparse.ArgumentTypeError(f'File not found: {filepath}')
        return filepath
    
    # -----------------------------------------------------------------------
    # Entry point of this Python Script.
    # -----------------------------------------------------------------------
    if __name__ == "__main__":
        parser = argparse.ArgumentParser(description='Example for Arguments')
        
        # -------------------------------------
        # argument group "file handling":
        # -------------------------------------
        file_group = parser.add_argument_group('Input/Output File Handling Options')
        file_group.add_argument('-i', '--input', help='Input file, default: toc.hhc.', type=file_exists, nargs='?', default='toc.hhc')
        file_group.add_argument('-o', '--output', help='Output file, default: helpndoc.pas', default='helpndoc.pas')
        file_group.add_argument('-t', '--template', help='HTML Template Page, default: template.htm', default='template.htm')
        
        # -------------------------------------
        # argument group: "processing options":
        # -------------------------------------
        proc_group = parser.add_argument_group('Processing Options')
        proc_group.add_argument('-pn', '--projectname', help=f'Name of the Project, default: default.hnd', default='default.hnd')
        proc_group.add_argument('-pp', '--path', help=f'Path for the Project, default: {os.getcwd()}', default=(os.getcwd()))
        
        args = parser.parse_args()
        
        # ----------------------------
        # check, if no arguments given
        # ----------------------------
        if args.input is None:
            parser.print_help()
            parser.exit(1)
        
        check_path(args.path)
        check_file(args.input)
        check_file(args.template)
        
        print(f'Input : {args.input}')
        print(f'Output: {args.output}')
        
        # -----------------------------------------------------------------------
        # this is a sanity chqck, if the file can be read before it is handled.
        # -----------------------------------------------------------------------
        #with open(args.input, "r", encoding="utf-8") as inpFile:
        #    content = inpFile.read()
        hhc_topics = parse_hhc_to_topics(args.input)
        pascal_code = generate_helpndoc_pascal(hhc_topics)
        
        # -----------------------------------------------------------------------
        # replace the place holders in "pascal_code" with given option args.
        # -----------------------------------------------------------------------
        pascal_code = pascal_code.replace('[::HelpNDocTemplateHTM::]', args.template)
        pascal_code = pascal_code.replace('[::HelpNDocPascalFile::]' , args.output)
        pascal_code = pascal_code.replace('[::HelpNDocProjectName::]', args.projectname)
        pascal_code = pascal_code.replace('[::HelpNDocProjectPath::]', args.path)
        #
        path_code, _ = os.path.splitext(args.projectname)
        pascal_code  = pascal_code.replace('[::HelpNDocProjectPRO::]', path_code)
        
        # -----------------------------------------------------------------------
        # finaly, write the output pascal file ...
        # -----------------------------------------------------------------------
        with open(args.output, "w", encoding="utf-8") as outFile:
            outFile.write("// automated created - all data will be lost on next run !\n")
            outFile.write(pascal_code)
        
        print(f"HelpNDoc.com Pascal-Script: created successfully")

# --------------------------------------------------------------------
# Exception handling section for this Python Script:
# --------------------------------------------------------------------
except ArgumentTypeError as e:
    print(f"error: argument problem:\n{e}")
    check_exit(1)
except InputFileError as e:
    print(e)
    check_exit(1)
except InputPathError as e:
    print(e)
    check_exit(1)
except OutputFileError as e:
    print(e)
    check_exit(1)
except PermissionError as e:
    print(f"error: access problem:\n{e}")
    check_exit(1)
except ModuleNotFoundError as e:
    print(f"error: module not found:\n{e}")
    check_exit(1)
except ImportError as e:
    print(f"error: module could not be import:\n{e}")
    check_exit(1)
except IsADirectoryError as e:
    print(f"error: path is not a file:\n{e}")
    check_exit(1)
except FileNotFoundError as e:
    print(f"error: file not found:\n{e}")
    check_exit(1)
except OSError as e:
    print(f"error: OS error:\n{e}")
    check_exit(1)
except Exception as e:
    print(f"error: common exception:\n{e}")
    check_exit(1)
finally:
    print("done.")
    check_exit(0)

# ---------------------------------------------------------
# EOF - End Of File
# ---------------------------------------------------------
