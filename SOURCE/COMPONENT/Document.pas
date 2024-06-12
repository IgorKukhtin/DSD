unit Document;

{$I ..\dsdVer.inc}

interface

uses VCL.Forms, VCL.Controls, System.Classes, dsdCommon, dsdDB, dsdAction
     {$IFDEF DELPHI103RIO}, System.Actions {$ENDIF};

type
  TDocument = class(TdsdComponent)
  private
    FFileName: string;
    FisOpen: boolean;
    FBlobProcedure: TdsdStoredProc;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetData: string;
    function GetName: string;
    function GetExtractFileName: string;
    procedure OpenDocument;
    procedure SaveDocument; overload;
    procedure SaveDocument(AFullFileName: String); overload;
    property FileName: string read FFileName write FFileName;
  published
    property GetBlobProcedure: TdsdStoredProc read FBlobProcedure write FBlobProcedure;
  end;

  TDocumentOpenAction =  class(TdsdCustomAction)
  private
    FDocument: TDocument;
  protected
    function LocalExecute: boolean; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Document: TDocument read FDocument write FDocument;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
  end;

  TDocumentSaveAction =  class(TdsdCustomAction)
  private
    FDocument: TDocument;
  protected
    function LocalExecute: boolean; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Document: TDocument read FDocument write FDocument;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
  end;

  procedure Register;

  var
    EnvironmentStrings: TStringList;

implementation

uses VCL.Dialogs, UnilWin, ZLibEx, FormStorage, VCL.ActnList, System.SysUtils,
     Winapi.Windows, Winapi.ShellApi;


procedure Register;
begin
   RegisterComponents('DSDComponent', [TDocument]);
   RegisterActions('DSDLib', [TDocumentOpenAction], TDocumentOpenAction);
   RegisterActions('DSDLib', [TDocumentSaveAction], TDocumentSaveAction);
end;

procedure GetEnvironmentStrings(ss: TStrings);
{Переменные среды}
var
  ptr: PChar;
  s: string;
  Done: boolean;
begin
  ss.Clear;
  s:='';
  Done:=FALSE;
  ptr:=Winapi.windows.GetEnvironmentStrings;
  while Done=false do begin
    if ptr^=#0 then begin
      inc(ptr);
      if ptr^=#0 then Done:=TRUE
      else ss.Add(s);
      s:=ptr^;
    end else s:=s+ptr^;
    inc(ptr);
  end;
end;

{ TDocument }

constructor TDocument.Create(AOwner: TComponent);
begin
  inherited;
  FisOpen := false;
end;

function PADR(Src: string; Lg: Integer): string;
begin
  Result := Src;
  while Length(Result) < Lg do
    Result := Result + ' ';
end;

function TDocument.GetData: string;
begin
  result := ConvertConvert(PADR(ExtractFileName(FFileName), 255) + FileReadString(FFileName));
  FisOpen := false;
end;

function TDocument.GetName: string;
begin
  if (csWriting in Owner.ComponentState) or (csDesigning in Owner.ComponentState) then
     exit;
  with {File}TOpenDialog.Create(nil) do
  try
    if Execute then begin
       result := ExtractFileName(FileName);
       FFileName := FileName;
       FisOpen := true;
    end
    else
       abort;
  finally
    Free;
  end;
end;

function TDocument.GetExtractFileName: string;
begin
  if (csWriting in Owner.ComponentState) or (csDesigning in Owner.ComponentState) then
     exit;
  result := ExtractFileName(FFileName);
end;

procedure TDocument.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;

  if csDesigning in ComponentState then
    if (Operation = opRemove) then
         if AComponent = FBlobProcedure then
            FBlobProcedure := nil;
end;

procedure TDocument.OpenDocument;
var TempDir: string;
    FileName: string;
    Data: AnsiString;
begin
  if Assigned(FBlobProcedure) then begin
     TempDir := EnvironmentStrings.Values['TEMP'];
     if TempDir <> '' then
        TempDir := TempDir + '\';
     Data := ReConvertConvert(FBlobProcedure.Execute);
     if Copy(Data, 1, 255) = '' then Exit;
     FileName := trim(TempDir + Copy(Data, 1, 255));
     FileWriteString(FileName, Copy(Data, 256, maxint));
     ShellExecute(Application.Handle, 'open', PWideChar(FileName), nil, nil, SW_SHOWNORMAl);
  end;
end;

procedure TDocument.SaveDocument;
var TempDir: string;
    FullFileName, Ext: string;
    Data: AnsiString;
begin
  if (csWriting in Owner.ComponentState) or (csDesigning in Owner.ComponentState) then
     exit;

  if Assigned(FBlobProcedure) then begin
     Data := ReConvertConvert(FBlobProcedure.Execute);
     FullFileName := trim(TempDir + Copy(Data, 1, 255));
     if FullFileName = '' then Exit;

     Ext := AnsiLowerCase(ExtractFileExt(FullFileName));
     with TSaveDialog.Create(nil) do
     try
       Options := [ofFileMustExist, ofOverwritePrompt];
       if Ext <> '' then
       begin
         Delete(Ext, 1, 1);
         Filter := 'Файл ' + AnsiUpperCase(Ext) + '|*.' + Ext + '|Все файлы|*.*';
         DefaultExt := Ext;
       end else Filter := '|Все файлы|*.*';
       Title := 'Укажите файл для сохранения';
       FileName := FullFileName;

       if Execute then
       begin
         FullFileName := FileName;
         FileWriteString(FullFileName, Copy(Data, 256, maxint));
       end;
     finally
       Free;
     end;

  end;
end;

procedure TDocument.SaveDocument(AFullFileName: String);
var Data: AnsiString;
begin
  if (csWriting in Owner.ComponentState) or (csDesigning in Owner.ComponentState) then
     exit;

  if Assigned(FBlobProcedure) then
  begin
    Data := ReConvertConvert(FBlobProcedure.Execute);

    FileWriteString(AFullFileName, Copy(Data, 256, maxint));
  end;
end;

{ TDocumentOpenAction }

function TDocumentOpenAction.LocalExecute: boolean;
begin
  if Assigned(FDocument) then
     FDocument.OpenDocument
end;

procedure TDocumentOpenAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;

  if csDesigning in ComponentState then
    if (Operation = opRemove) then
         if AComponent = FDocument then
            FDocument := nil;
end;

{ TDocumentOpenAction }

function TDocumentSaveAction.LocalExecute: boolean;
begin
  if Assigned(FDocument) then
     FDocument.SaveDocument
end;

procedure TDocumentSaveAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;

  if csDesigning in ComponentState then
    if (Operation = opRemove) then
         if AComponent = FDocument then
            FDocument := nil;
end;

initialization
  RegisterClasses([TDocument, TDocumentOpenAction, TDocumentSaveAction]);
  EnvironmentStrings := TStringList.Create;
  GetEnvironmentStrings(EnvironmentStrings);

finalization

  EnvironmentStrings.Free;

end.
