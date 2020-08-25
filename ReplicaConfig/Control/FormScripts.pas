{==============================================================================*
* Copyright © 2020, Pukhkiy Igor                                               *
* All rights reserved.                                                         *
*==============================================================================*
* This Source Code Form is subject to the terms of the Mozilla                 *
* Public License, v. 2.0. If a copy of the MPL was not distributed             *
* with this file, You can obtain one at http://mozilla.org/MPL/2.0/.           *
*==============================================================================*
* The Initial Developer of the Original Code is Pukhkiy Igor (Ukraine).        *
* Contacts: nspytnik-programming@yahoo.com                                     *
*==============================================================================*
* DESCRIPTION:                                                                 *
* FormScripts.pas - unit editor sql script                                     *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit FormScripts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, SynEdit,
  Vcl.StdCtrls, Vcl.ToolWin, Vcl.ComCtrls, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, SynEditTypes, SynEditHighlighter, SynHighlighterSQL, RDBDataModule, RDBClass,
  Vcl.Menus, Vcl.StdActns, SynEditMiscClasses, SynEditSearch, SynEditPrint;

type
  TTreeSQLData = class (TTreeNode)
  private
    FFileName: string;
    FIsFile: Boolean;
    FIsRoot: Boolean;
    FExecuted: Boolean;
    FInMemory: Boolean;
    FScript: string;
  public
    property Script: string read FScript write FScript;
    property FileName: string read FFileName write FFileName;
    property IsFile: Boolean read FIsFile write FIsFile;
    property IsRoot: Boolean read FIsRoot write FIsRoot;
    property Executed: Boolean read FExecuted write FExecuted;
    property InMemory: Boolean read FInMemory write FInMemory;
  end;


  TScriptsForm = class(TForm)
    SynEdit: TSynEdit;
    ActionList: TActionList;
    actExecute: TAction;
    actSelectFile: TAction;
    actSaveFile: TAction;
    tvFiles: TTreeView;
    Splitter: TSplitter;
    actOpenFile: TAction;
    actOpenFolder: TAction;
    ImageList: TImageList;
    SynSQLSyn: TSynSQLSyn;
    actExecuteALL: TAction;
    actRedo: TAction;
    actUndo: TAction;
    actApply: TAction;
    pnlTree: TPanel;
    pnlEditor: TPanel;
    ToolBarTree: TToolBar;
    tb1: TToolButton;
    tb2: TToolButton;
    ToolBarEditor: TToolBar;
    tb3: TToolButton;
    tb4: TToolButton;
    tb5: TToolButton;
    tb6: TToolButton;
    tb8: TToolButton;
    actExecuteOnMaster: TAction;
    actExecuteOnSlave: TAction;
    ToolButtonSep1: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    StatusBar: TStatusBar;
    FindDialog: TFindDialog;
    ReplaceDialog: TReplaceDialog;
    PopupMenu: TPopupMenu;
    actSelectALL: TAction;
    N2: TMenuItem;
    Find1: TMenuItem;
    FindNext1: TMenuItem;
    actFindPrevios1: TMenuItem;
    Replace1: TMenuItem;
    N3: TMenuItem;
    actPrint: TAction;
    actPrint1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N1: TMenuItem;
    actCut: TAction;
    actCopy: TAction;
    actPaste: TAction;
    actDelete: TAction;
    actFind: TAction;
    actFindNext: TAction;
    actFindPrevios: TAction;
    actReplace: TAction;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    SelectAll1: TMenuItem;
    SynEditSearch: TSynEditSearch;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tvFilesCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure actOpenFolderExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure tvFilesGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvFilesChange(Sender: TObject; Node: TTreeNode);
    procedure actExecuteExecute(Sender: TObject);
    procedure actExecuteALLExecute(Sender: TObject);
    procedure tvFilesChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure actRedoExecute(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure SynEditChange(Sender: TObject);
    procedure actApplyExecute(Sender: TObject);
    procedure actExecuteOnMasterExecute(Sender: TObject);
    procedure actSaveFileExecute(Sender: TObject);
    procedure ToolBar55CustomDrawButton(Sender: TToolBar; Button: TToolButton;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure SynEditStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure actCopyExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actSelectALLExecute(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFindNextExecute(Sender: TObject);
    procedure actFindPreviosExecute(Sender: TObject);
    procedure DoFindText(Sender: TObject);
    procedure actReplaceExecute(Sender: TObject);
    procedure DoReplaceText(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
  private
    { Private declarations }
    FFiles: TStringList;
    FLastDir: string;
    FMemCount: Integer;
    FChanged: Boolean;
    FCurrent: TTreeSQLData;
    FFirstSearch: Boolean;
    procedure LoadFolder(const DirName: string);
    procedure LoadFile(const FileName: string);
    procedure SaveFile(const FileName: string);
    procedure ResetSynEdit;
    procedure ApplySynEdit;
    function CheckSynEditChanges: Boolean;
    function GetCurrentNode: TTreeSQLData;
    procedure UpdateEditActions(DocumentChanged: Boolean);

  public

    { Public declarations }
    procedure AddScript(const s: string; const ScriptName: string = '');
  end;

var
  ScriptsForm: TScriptsForm;

implementation
uses
  FileCtrl, Vcl.Themes, Vcl.GraphUtil;
{$R *.dfm}

procedure TScriptsForm.actApplyExecute(Sender: TObject);
begin
  ApplySynEdit;
end;

procedure TScriptsForm.actCopyExecute(Sender: TObject);
begin
  SynEdit.CopyToClipboard
end;

procedure TScriptsForm.actCutExecute(Sender: TObject);
begin
  SynEdit.CutToClipboard
end;

procedure TScriptsForm.actDeleteExecute(Sender: TObject);
begin
  SynEdit.SelText := '';
end;

procedure TScriptsForm.actExecuteALLExecute(Sender: TObject);
var
  n: TTreeSQLData;
  i: Integer;
  list: TStringList;
begin
  list := TStringList.Create;
  try
  for I := 0 to FFiles.Count-1 do
    begin
      n := TTreeSQLData(FFiles.Objects[i]);
      if (n <> nil) and n.IsFile and not n.Executed then
        begin
          if n.Script = '' then
            begin
              list.LoadFromFile(n.FileName);
              n.Script := list.Text;
            end;
          // execute()
          n.Executed := true;
        end;
    end;
  finally
    list.Free;
  end;
end;

procedure TScriptsForm.actExecuteExecute(Sender: TObject);
var
  n: TTreeSQLData;
begin
  if actExecuteOnMaster.Checked then
    RDB.ExecuteScript(SynEdit.Lines.Text, mkMaster) else
    RDB.ExecuteScript(SynEdit.Lines.Text, mkSlave);
  n := TTreeSQLData(tvFiles.Selected);
  if (n = nil) or not n.IsFile or (n.Executed and not FChanged) then exit;
  n.Script := SynEdit.Lines.Text;
//  if rbMaster.Checked then
//    RDB.ExecuteScript(n.Script, mkMaster) else
//    RDB.ExecuteScript(n.Script, mkSlave);
  n.Executed := true;
  if actExecuteOnMaster.Checked then
    MessageBox(Handle, 'Success! Master', 'Script execute', MB_ICONINFORMATION or MB_OK) else
    MessageBox(Handle, 'Success! Slave', 'Script execute', MB_ICONINFORMATION or MB_OK);
end;

procedure TScriptsForm.actExecuteOnMasterExecute(Sender: TObject);
begin
//
end;

procedure TScriptsForm.actFindExecute(Sender: TObject);
begin
  FFirstSearch := true;
  FindDialog.Execute(Handle)
end;

procedure TScriptsForm.actFindNextExecute(Sender: TObject);
begin
  FindDialog.Options := FindDialog.Options + [frDown];
  DoFindText(Sender);
end;

procedure TScriptsForm.actFindPreviosExecute(Sender: TObject);
begin
  FindDialog.Options := FindDialog.Options - [frDown];
  DoFindText(Sender);
end;

procedure TScriptsForm.actOpenFileExecute(Sender: TObject);
begin
    with TOpenDialog.Create(nil) do
      try
        Title := 'Select SQL script';
        Filter := 'SQL script files|*.sql';
        if not Execute(Handle) then exit;
        FLastDir := ExtractFileDir(FileName);
        LoadFile(FileName);
      finally
        Free;
      end
end;

procedure TScriptsForm.actOpenFolderExecute(Sender: TObject);
begin
  if Win32MajorVersion >= 6 then
    with TFileOpenDialog.Create(nil) do
      try
        Title := 'Select Directory';
        Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem]; // YMMV
        OkButtonLabel := 'Select';
        DefaultFolder := FLastDir;
        FileName := FLastDir;
        if not Execute(Handle) then exit;
        FLastDir := FileName;
      finally
        Free;
      end
  else
    if not SelectDirectory('Select Directory', ExtractFileDrive(FLastDir), FLastDir,
               [sdNewUI, sdNewFolder]) then exit;
  LoadFolder(FLastDir);
end;

procedure TScriptsForm.actPasteExecute(Sender: TObject);
begin
  SynEdit.PasteFromClipboard
end;

procedure TScriptsForm.actPrintExecute(Sender: TObject);
var
  SynPrint: TSynEditPrint;
begin
  SynPrint := TSynEditPrint.Create(nil);
  try
    SynPrint.SynEdit := SynEdit;
    SynPrint.Title   := GetCurrentNode.Text;
    SynPrint.Wrap    := true;
    SynPrint.Header.Add(DateTimeToStr(Now), nil, taRightJustify, 1 );
    SynPrint.Header.Add(SynPrint.Title, nil, taLeftJustify, 1 );
  with TPrintDialog.Create(nil) do
    try
      Parent   := Self;
      MinPage  := 1;
      FromPage := 1;
      MaxPage  := SynPrint.PageCount;
      ToPage   := MaxPage;
    if Execute(Handle) then
      begin
        SynPrint.Copies := Copies;
        case PrintRange of
          prAllPages: SynPrint.Print;
          prPageNums: SynPrint.PrintRange(FromPage, ToPage);
        end;
      end;
    finally
      Free;
    end;
  finally
    SynPrint.Free;
  end;
end;

procedure TScriptsForm.actRedoExecute(Sender: TObject);
begin
  SynEdit.Redo;
end;

procedure TScriptsForm.actReplaceExecute(Sender: TObject);
begin
  FFirstSearch := true;
  ReplaceDialog.Execute(Handle)
end;

procedure TScriptsForm.actSaveFileExecute(Sender: TObject);
var
  n: TTreeSQLData;
  s: string;
begin
  n := GetCurrentNode;
  if (n = nil) or not n.IsFile then exit;
  s := '';
  if n.InMemory then
   with TSaveDialog.Create(nil) do
     try
       Title := 'Select SQL script';
       Filter := 'SQL script files|*.sql';
       if not Execute(Handle) then exit;
       s := FileName;
     finally
       Free;
     end
   else
     s := n.FileName;
  SaveFile(s);
end;

procedure TScriptsForm.actSelectALLExecute(Sender: TObject);
begin
  SynEdit.SelectAll
end;

procedure TScriptsForm.actUndoExecute(Sender: TObject);
begin
  SynEdit.Undo;
end;

procedure TScriptsForm.AddScript(const s: string; const ScriptName: string);
var
  n, p: TTreeSQLData;
  i: Integer;
  sn: string;
begin
  i := FFiles.Add(':memory:');
  p := TTreeSQLData(FFiles.Objects[i]);
  if p = nil then
    begin
      p := TTreeSQLData(tvFiles.Items.AddChild(nil, ':memory:'));
      FFiles.Objects[i] := p;
      p.IsRoot := true;
    end;

  if ScriptName <> '' then
    sn := ScriptName else
    begin
      Inc(FMemCount);
      sn := 'script #'+IntToStr(FMemCount);
    end;
  i := FFiles.IndexOf(sn);
  if i <> -1 then
    begin
      n := TTreeSQLData(FFiles.Objects[i]);
    end else
    begin
      n := TTreeSQLData(tvFiles.Items.AddChild(p, sn));
      FFiles.AddObject(sn, n)
    end;
  n.InMemory := true;
  n.IsFile   := true;
  n.Script := s;
  n.Selected := true;
end;

procedure TScriptsForm.ApplySynEdit;
begin
  SynEdit.MarkModifiedLinesAsSaved;
  SynEdit.RedoList.Clear;
  SynEdit.UndoList.Clear;
  SynEdit.Modified := false;
end;

function TScriptsForm.CheckSynEditChanges: Boolean;
begin
  Result := true;
end;


procedure TScriptsForm.DoFindText(Sender: TObject);
var
  rOptions: TSynSearchOptions;
  dlg: TFindDialog absolute Sender;
  sSearch: string;
begin
  sSearch := dlg.FindText;
  if Length(sSearch) = 0 then
    begin
      Beep;
      StatusBar.Panels[3].Text := 'Can''t search for empty text!';
    end
  else
    begin
      rOptions := [];
      if FFirstSearch then
        Include(rOptions, ssoEntireScope);
      FFirstSearch := false;
      if not (frDown in dlg.Options) then
        Include(rOptions, ssoBackwards);
      if frMatchCase in dlg.Options then
        Include(rOptions, ssoMatchCase);
      if frWholeWord in dlg.Options then
        Include(rOptions, ssoWholeWord);
      if SynEdit.SearchReplace(sSearch, '', rOptions) = 0 then
        begin
          Beep;
          StatusBar.Panels[3].Text := 'SearchText ''' + sSearch + ''' not found!';
        end
      else
        StatusBar.Panels[3].Text := '';
  end;
end;

procedure TScriptsForm.DoReplaceText(Sender: TObject);
var
  rOptions: TSynSearchOptions;
  sSearch: string;
begin
  sSearch := ReplaceDialog.FindText;
  if Length(sSearch) = 0 then
    begin
      Beep;
      StatusBar.Panels[3].Text := 'Can''t replace an empty text!';
    end
  else
    begin
    rOptions := [];
    if FFirstSearch then
      Include(rOptions, ssoEntireScope);
    FFirstSearch := false;
    if frMatchCase in ReplaceDialog.Options then
      Include(rOptions, ssoMatchCase);
    if frWholeWord in ReplaceDialog.Options then
      Include(rOptions, ssoWholeWord);
    if frReplaceAll in ReplaceDialog.Options then
      Include(rOptions, ssoReplaceAll);
    if SynEdit.SearchReplace(sSearch, ReplaceDialog.ReplaceText, rOptions) = 0 then
      begin
        Beep;
        StatusBar.Panels[3].Text := 'SearchText ''' + sSearch + ''' could not be replaced!';
      end
    else
      StatusBar.Panels[3].Text := '';
  end;

end;


procedure TScriptsForm.FormCreate(Sender: TObject);
begin
  FFiles := TStringList.Create(dupIgnore, true, false);
  SynEdit.Lines.Clear;
  LoadFolder('..\scripts');
end;

procedure TScriptsForm.FormDestroy(Sender: TObject);
begin
  FFiles.Free;
end;

function TScriptsForm.GetCurrentNode: TTreeSQLData;
begin
  Result := TTreeSQLData(tvFiles.Selected);
end;

procedure TScriptsForm.LoadFile(const FileName: string);
var
  node: TTreeSQLData;
  l: TStringList;
  s: string;
  i: Integer;
begin
  s := ExpandFileName(FileName);
  i := FFiles.IndexOf(s);
  if i <> -1 then
    begin
      node := TTreeSQLData(FFiles.Objects[i]);
      node.Selected := true;
      exit;
    end;

  node := nil;

  l := TStringList.Create;
  try
    while node = nil do
      begin
        s := ExtractFileDir(s);
        if (Length(s) = 3) and (s[2] = ':') then
          begin
            l.Add(Copy(s, 1, 2)+'='+s);
            break;
          end;
        i := FFiles.IndexOf(s);
        if i <> -1 then
          begin
            node := TTreeSQLData(FFiles.Objects[i]);
            break;
          end;
        l.Add(ExtractFileName(s)+'='+s);
      end;

    for I := l.Count-1 downto 0 do
      begin
        node := TTreeSQLData(tvFiles.Items.AddChild(node, l.Names[i]));
        node.FileName := l.ValueFromIndex[i];
        FFiles.AddObject(node.FileName, node);
      end;
    node := TTreeSQLData(tvFiles.Items.AddChild(node, ExtractFileName(FileName)));
    node.FileName := ExpandFileName(FileName);
    Node.IsFile := true;
    FFiles.AddObject(node.FileName, node);
    node.Selected := true;

  finally
    l.Free;
  end;

end;

procedure TScriptsForm.LoadFolder(const DirName: string);
var
  FileName: string;
  n: TTreeSQLData;
  procedure WalkThroughDirectory(Root: TTreeNode; const Path: string);
  var
    SearchRec: TSearchRec;
    Node: TTreeSQLData;
    I: Integer;
    s: string;
  begin
    if FindFirst(IncludeTrailingPathDelimiter(Path)+'\*.*', faAnyFile, SearchRec) = 0 then // DO NOT LOCALIZE
    try
      repeat
          s := IncludeTrailingPathDelimiter(Path)+ SearchRec.Name;
          i := FFiles.Add(s);
          Node := TTreeSQLData(FFiles.Objects[i]);
          if (SearchRec.Attr = faDirectory) then
            begin
              if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
                begin
                  if Node = nil then
                    Node := TTreeSQLData(tvFiles.Items.AddChild(Root, SearchRec.Name));
                  WalkThroughDirectory(Node, IncludeTrailingPathDelimiter(Path)+ SearchRec.Name);
                end;
            end
          else if SameFileName(ExtractFileExt(SearchRec.Name), '.sql') then
            if Node = nil then
              begin
                Node := TTreeSQLData(tvFiles.Items.AddChild(Root, SearchRec.Name));
                Node.FFileName := s;
                Node.IsFile := true;
              end;
          FFiles.Objects[i] := Node;
      until (FindNext(SearchRec) <> 0);
    finally
      FindClose(SearchRec);
    end;
  end;

begin
  n := TTreeSQLData(FFiles.Objects[FFiles.Add(DirName)]);
  if n = nil then
    begin
      n := TTreeSQLData(tvFiles.Items.AddChild(nil, ExtractFileName(DirName)));
      n.IsRoot := true;
      FFiles.Objects[FFiles.Add(DirName)] := n
    end;

  WalkThroughDirectory(n, DirName);

end;



procedure TScriptsForm.ResetSynEdit;
begin
  SynEdit.ResetModificationIndicator;
  SynEdit.RedoList.Clear;
  SynEdit.UndoList.Clear;
  SynEdit.Modified := false;
  UpdateEditActions(true);
  UpdateEditActions(false);
end;

procedure TScriptsForm.SaveFile(const FileName: string);
var
  f: TFileStream;
  s: RawByteString;
  n: TTreeSQLData;
begin
  n := GetCurrentNode;
  s := SynEdit.Lines.Text;
  f := TFileStream.Create(FileName, fmCreate);
  try
    f.WriteBuffer(Pointer(s)^, Length(s));
  finally
    f.Free;
  end;
  ApplySynEdit;

  if n.InMemory then
    begin
      n.Delete;
      LoadFile(FileName);
    end;






end;

procedure TScriptsForm.SynEditChange(Sender: TObject);
begin
  UpdateEditActions(true);
end;

procedure TScriptsForm.SynEditStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
const
  ModifiedStrs: array[boolean] of string = ('', 'Modified');
  InsertModeStrs: array[boolean] of string = ('Overwrite', 'Insert');
var
  p: TBufferCoord;
begin
  if Changes * [scAll, scCaretX, scCaretY] <> [] then
    begin
      p := SynEdit.CaretXY;
      Statusbar.Panels[0].Text := Format('%6d:%3d', [p.Line, p.Char]);
    end;
  if Changes * [scAll, scInsertMode, scReadOnly] <> [] then
    begin
      if SynEdit.ReadOnly then
        Statusbar.Panels[2].Text := 'ReadOnly'
      else
        Statusbar.Panels[2].Text := InsertModeStrs[SynEdit.InsertMode];
    end;
  if Changes * [scAll, scModified] <> [] then
    Statusbar.Panels[1].Text := ModifiedStrs[SynEdit.Modified];
  UpdateEditActions(false);
end;

type
  TToolBarEx = class (TToolBar);
procedure TScriptsForm.ToolBar55CustomDrawButton(Sender: TToolBar;
  Button: TToolButton; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  FillColor, EdgeColor, FontColor: TColor;
  cvs: TCanvas;
  R: TRect;
  s: string;
  flags: TTBCustomDrawFlags;
begin
  case Button.Tag of
    1:  begin
          s := 'Master';
          FillColor := clLime;
        end;
    2:  begin
          s := 'Slave';
          FillColor := clBlue;
        end;
    else
      exit;
  end;
  DefaultDraw := false;
  R := Button.BoundsRect;
  cvs := TToolBar(Sender).Canvas;

  if Button.Down then
    begin
        OffsetRect(R, -1, 0);
        if cdsSelected in State then
          FillColor := GetShadowColor(FillColor, -25);
        EdgeColor := GetShadowColor(FillColor);
        cvs.Brush.Color := EdgeColor;
        cvs.FillRect(R);
        InflateRect(R, -cvs.Pen.Width, -cvs.Pen.Width);
        cvs.Brush.Color := FillColor;
        cvs.FillRect(R);
        //InflateRect(R, cvs.Pen.Width, cvs.Pen.Width);
        cvs.Brush.Style := bsClear;
        cvs.Font.Style  := [fsBold];
        cvs.Font.Size   := cvs.Font.Size + 1;
        R.Left := R.Left + 4;
        StyleServices.DrawText(cvs.Handle, StyleServices.GetElementDetails(ttbButtonPressed),
                              s, R, [tfCenter, tfVerticalCenter, tfSingleLine], clWhite);
    end
  else
    begin
        flags := [];
        cvs.Brush.Style := bsClear;
        cvs.Font.Style  := [fsBold];
        cvs.Font.Size   := cvs.Font.Size;
        TToolBarEx(Sender).GradientDrawButton(Button, State, flags);
        StyleServices.DrawText(cvs.Handle, StyleServices.GetElementDetails(ttbButtonPressed),
                              s, R, [tfCenter, tfVerticalCenter, tfSingleLine], clGrayText);
    end;
end;

procedure TScriptsForm.tvFilesChange(Sender: TObject; Node: TTreeNode);
var
  n: TTreeSQLData absolute Node;
begin
  if n.IsFile then
    begin
      if n.Script = '' then
        SynEdit.Lines.LoadFromFile(TTreeSQLData(node).FileName) else
        SynEdit.Lines.Text := n.Script;
        ResetSynEdit;
    end;
  actSaveFile.Enabled := n.IsFile;
  actExecute.Enabled := n.IsFile;
  ResetSynEdit();
  SynEdit.Enabled := n.IsFile;
  SynEditStatusChange(Self, [scAll]);
end;

procedure TScriptsForm.tvFilesChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
var
  n: TTreeSQLData absolute Node;
begin
  if n.IsFile and FChanged then
    begin
      AllowChange := CheckSynEditChanges;
      if not AllowChange then exit;

      n.Script := SynEdit.Lines.Text;
      n.Executed := n.Executed and not FChanged;
    end;
  FChanged := false;
  SynEdit.Lines.Clear;
end;

procedure TScriptsForm.tvFilesCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TTreeSQLData;
end;

procedure TScriptsForm.tvFilesGetImageIndex(Sender: TObject; Node: TTreeNode);
begin
  if TTreeSQLData(node).IsFile then
    node.ImageIndex := 0
  else if TTreeSQLData(node).IsRoot then
    node.ImageIndex := 2
  else
    node.ImageIndex := 2;
   node.SelectedIndex := node.ImageIndex
end;



procedure TScriptsForm.UpdateEditActions(DocumentChanged: Boolean);
begin
  if DocumentChanged then
    begin
      actUndo.Enabled := SynEdit.CanUndo;
      actRedo.Enabled := SynEdit.CanRedo;
      actApply.Enabled:= SynEdit.Modified;
    end
  else
    begin
      actCut.Enabled         := SynEdit.SelAvail;
      actCopy.Enabled        := SynEdit.SelAvail;
      actPaste.Enabled       := SynEdit.CanPaste;
      actSelectALL.Enabled   := SynEdit.Lines.Count > 0;
      actFind.Enabled        := actSelectALL.Enabled;
      actFindNext.Enabled    := actSelectALL.Enabled;
      actFindPrevios.Enabled := actSelectALL.Enabled;
      actReplace.Enabled     := actSelectALL.Enabled;
    end;

end;

end.
