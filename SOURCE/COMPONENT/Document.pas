unit Document;

{$I ..\dsdVer.inc}

interface

uses Classes, dsdDB, dsdAction {$IFDEF DELPHI103RIO}, Actions {$ENDIF};

type
  TDocument = class(TComponent)
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
    procedure OpenDocument;
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

  procedure Register;

  var
    EnvironmentStrings: TStringList;

implementation

uses Dialogs, UnilWin, ZLibEx, FormStorage, VCL.ActnList, SysUtils, ShellApi,
     Forms, Windows;


procedure Register;
begin
   RegisterComponents('DSDComponent', [TDocument]);
   RegisterActions('DSDLib', [TDocumentOpenAction], TDocumentOpenAction);
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
  ptr:=windows.GetEnvironmentStrings;
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
     FileName := trim(TempDir + Copy(Data, 1, 255));
     FileWriteString(FileName, Copy(Data, 256, maxint));
     ShellExecute(Application.Handle, 'open', PWideChar(FileName), nil, nil, SW_SHOWNORMAl);
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

initialization
  Classes.RegisterClass(TDocument);
  Classes.RegisterClass(TDocumentOpenAction);
  EnvironmentStrings := TStringList.Create;
  GetEnvironmentStrings(EnvironmentStrings);

finalization

  EnvironmentStrings.Free;

end.
