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
        topics = []
        
        def parse_ul(ul, depth=0):
            for li in ul.find_all("li", recursive=False):
                obj = li.find("object")
                if obj:
                    title = ""
                    for param in obj.find_all("param"):
                        if param.get("name").lower() == "name":
                            title = param.get("value")
                    topics.append({
                        "title": title,
                        "depth": depth
                    })
                
                nested = li.find("ul")
                if nested:
                    parse_ul(nested, depth + 1)
        
        root_ul = soup.find("ul")
        if root_ul:
            parse_ul(root_ul)
        
        return topics

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
  TThema = class(TObject)
    TopicTitle: String ;
    TopicLevel: Integer;
    TopicID   : String ;
  public
    constructor Create(AName: String); overload;
    constructor Create(AName: String; ALevel: Integer); overload;
    destructor Destroy; override;
    
    procedure Add(AName: String);
  end;

type
  TProject = class(TObject)
  private
    FLangCode: String;
    Title : String;
    Topics: Array of TThema;
  public
    constructor Create(AName: String)
    destructor Destroy; override;
  published
  property
    LanguageCode: String read FLangCode write FLangCode;
  end;

// ---------------------------------------------------------------------------
// common used constants and variables...
// ---------------------------------------------------------------------------
const MAX_TOPICS = 1024;

var PRO_[::HelpNDocProjectPRO::]: TPoject;

{ TTopic }

constructor TTopic.Create(AName: String; ALevel: Integer);
begin
  inherited Create;
  
  TopicTitle := AName;
  TopicLevel := ALevel;
end;
constructor TTopic.Create(AName: String);
begin
  inherited Create;
  
  TopicTitle := AName;
end;
destructor TTopic.Destroy;
begin
  inherited Destroy;
end;

{ TProject }

constructor TProject.Create(AName: String);
begin
  inherited Create;
  
  ID := HndProjects.NewProject(AName);
  try
    HndProjects.SaveProject;
    HndProjects.SetProjectLanguageCode('en-us');
  except
    on E: Exception do
    raise Exception('Project file could not be created.');
  end;
end;
destructor TProject.Destroy;
begin
  for index := High(Topics) downto Low(Topics) do
  begin
    Topics[index].Free;
    Topics[index] = nil;
  end;
  Topics := nil;
  inherited Destroy;
end;

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
// \\brief  This function create a fresh new Project. If a Project with the
//         name already exists, then it will be overwrite !
//
// \\param  projectName - String: The name of the Project.
// ---------------------------------------------------------------------------
procedure CreateProject(const projectName: String);
var projectID: String;
begin
  result := '';
  PRO_[::HelpNDocProjectPRO::] := TProject.Create(projectName);
  
  HndTopics.SetProjectModified(True);
end;

// ---------------------------------------------------------------------------
// \brief This function create the Table of Contents (TOC).
// ---------------------------------------------------------------------------
procedure CreateTableOfContents;
var i, p, g: Integer;
var ThemenEditor: TObject;
var ThemenPage  : TStringList;
var ThemenListe : TStringList;
var Thema: Array [0..MAX_TOPICS] of TThema;
begin

  ThemenListe := TStringList.Create;
  ThemenPage  := TStringList.Create;
  
  try
    print('1. pre-processing data...');
    ThemenPage.LoadFromFile(HelpNDocTemplateHTM);
    
    ThemenEditor := HndEditor.CreateTemporaryEditor;
    HndEditorHelper.CleanContent   (ThemenEditor);
    HndEditor.InsertContentFromHTML(ThemenEditor, ThemenPage.Text);""")
        # -----------------------------------------------------------------------
        for idx, t in enumerate(topics):
            title = t["title"].replace("'", "''")
            depth = t["depth"]
            
            lines.append(f"    // Thema {idx + 1}: {title}")
            lines.append(f"    Thema[{idx}] := TThema.Create;")
            lines.append(f"    Thema[{idx}].Caption := '{title}';")
            lines.append(f"    Thema[{idx}].TopicID := HndTopics.CreateTopic;")
            lines.append(f"    Thema[{idx}].TopicLevel := GetLevel(Thema[{idx}].Caption);")
            lines.append(f"    ThemenListe.AddObject('Topic{idx}', Thema[{idx}]);")
            lines.append(f"    HndEditor.SetAsTopicContent(aEditor, Thema[{idx}].TopicID);")
        # -----------------------------------------------------------------------
        lines.append("""
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
        with open(args.input, "r", encoding="utf-8") as inpFile:
            content = inpFile.read()
        
        pascal_code = generate_helpndoc_pascal(parse_hhc_to_topics(args.input))
        
        # -----------------------------------------------------------------------
        # replace the place holders in "pascal_code" with given option args.
        # -----------------------------------------------------------------------
        pascal_code = pascal_code.replace('[::HelpNDocTemplateHTM::]', args.template)
        pascal_code = pascal_code.replace('[::HelpNDocPascalFile::]' , args.output)
        pascal_code = pascal_code.replace('[::HelpNDocProjectName::]', args.projectname)
        pascal_code = pascal_code.replace('[::HelpNDocProjectPath::]', args.path)
        #
        pascal_code = pascal_code.replace('[::HelpNDocProjectPRO::]', Path(args.projectname).steam)
        
        # -----------------------------------------------------------------------
        # finaly, write the output pascal file ...
        # -----------------------------------------------------------------------
        with open(args.output, "w", encoding="utf-8") as outFile:
            outFile.write("// automated created - all data will be lost on next run !\n")
            outFile.write(pascal_code)
        
        print(f"HelpNDoc.com Pascal-Script: created successfully:\n{HelpNDocPaslFile}")

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
