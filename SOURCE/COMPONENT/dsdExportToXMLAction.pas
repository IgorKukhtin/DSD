unit dsdExportToXMLAction;

interface

uses Forms, Data.DB, System.Classes, System.SysUtils, System.Win.ComObj, Vcl.Graphics,
     Vcl.ActnList, System.Variants, DBClient, Dialogs, dsdAction, dsdDB;

type


  TdsdEncodingType = (etWindows1251, etUtf8);

  TdsdExportToXML = class(TdsdCustomAction)
  private
    FParams: TdsdParams;
    FStoredProc: TdsdStoredProc;
    FRootName: String;
    FTagName: String;
    FEncodingType : TdsdEncodingType;
    FSaveFile: TSaveDialog;
    procedure SetStoredProc(const Value: TdsdStoredProc);
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property RootParams: TdsdParams read FParams write FParams;
    property StoredProc: TdsdStoredProc read FStoredProc write SetStoredProc;
    property RootName: String read FRootName write FRootName;
    property TagName : String read FTagName write FTagName;
    property EncodingType : TdsdEncodingType read FEncodingType write FEncodingType default etWindows1251;
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
  end;


implementation

  {TdsdExportToXML}

constructor TdsdExportToXML.Create(AOwner: TComponent);
begin
  inherited;

  FSaveFile := TSaveDialog.Create(Application);
  FSaveFile.DefaultExt := '.xml';
  FSaveFile.Filter := 'Файл XML|*.xml|Все файлы|*.*';
  FSaveFile.Title := 'Укажите файл для сохранения';
  FSaveFile.Options := [ofFileMustExist, ofOverwritePrompt];

  FParams := TdsdParams.Create(Self, TdsdParam);
end;

destructor TdsdExportToXML.Destroy;
begin
  FreeAndNil(FParams);
  FSaveFile := Nil;
  inherited;
end;

procedure TdsdExportToXML.SetStoredProc(const Value: TdsdStoredProc);
begin
  FStoredProc := Value;
end;

function TdsdExportToXML.LocalExecute: Boolean;
var
  F: TextFile;
  FiteText, cRoot, cTeg: string;
  I : integer;
  DST : TClientDataSet;
  sl : TStringList;

  function CodeTextParam(AParam : TdsdParam) : string;
  begin
    if AParam.Value <> Null then
    begin
      case AParam.DataType of
        ftFloat : Result := CurrToStr(AParam.AsFloat);
        ftDate, ftTime, ftDateTime : Result := StringReplace(AParam.Value, FormatSettings.DateSeparator, '/', [rfReplaceAll]);
        else Result := AParam.Value;
      end;

      Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll, rfIgnoreCase]);
      Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll, rfIgnoreCase]);
      Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll, rfIgnoreCase]);
      Result := StringReplace(Result, '''', '&apos;', [rfReplaceAll, rfIgnoreCase]);
      Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll, rfIgnoreCase]);
    end else Result := '';
  end;

  function CodeTextField(AField : TField) : string;
  begin
    if not AField.IsNull then
    begin
      case AField.DataType of
        ftFloat, ftCurrency, ftBCD : Result := StringReplace(AField.AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]);
        ftDate, ftTime, ftDateTime : Result := StringReplace(AField.AsString, FormatSettings.DateSeparator, '/', [rfReplaceAll]);
        else Result := AField.AsString;
      end;

      Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll, rfIgnoreCase]);
      Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll, rfIgnoreCase]);
      Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll, rfIgnoreCase]);
      Result := StringReplace(Result, '''', '&apos;', [rfReplaceAll, rfIgnoreCase]);
      Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll, rfIgnoreCase]);
    end else Result := '';
  end;

begin
  inherited;
  Result := False;
  DST := Nil;

  cRoot := FRootName;
  if cRoot = '' then cRoot := 'Root';
  cTeg := FTagName;
  if cTeg = '' then cTeg := 'Tag';

  if FStoredProc = Nil then
  begin
    raise Exception.Create('Не определен TagStoredProc..');
    Exit;
  end;

  if FSaveFile.Execute then
  try
    AssignFile(F, FSaveFile.FileName);
    Rewrite(F); // переписываем файл

    case FEncodingType of
      etWindows1251 : FiteText := '<?xml version="1.0" encoding="windows-1251"?>'#13+#10;
      etUtf8 : FiteText := '<?xml version="1.0" encoding="utf-8"?>'#13+#10;
    end;

    FiteText := FiteText + '<' + cRoot;

    if FParams.Count > 0 then
    begin
      for I := 0 to FParams.Count - 1 do
      begin
        FiteText := FiteText + ' ' + FParams.Items[I].Name + '="' +
          CodeTextParam(FParams.Items[I]) + '"';
      end;

    end;
    FiteText := FiteText + '>'#13+#10;

    if FStoredProc.DataSet = Nil then
    begin
      DST := TClientDataSet.Create(Nil);
      FStoredProc.DataSet := DST;
    end;

    FStoredProc.Execute;
    FStoredProc.DataSet.First;
    while not FStoredProc.DataSet.Eof do
    begin

      FiteText := FiteText + '<' + cTeg;
      for I := 0 to FStoredProc.DataSet.FieldCount - 1 do
      begin
        FiteText := FiteText + ' ' + FStoredProc.DataSet.Fields.Fields[I].FieldName + '="' +
          CodeTextField(FStoredProc.DataSet.Fields.Fields[I]) + '"';
      end;
      FiteText := FiteText + '/>'#13+#10;

      FStoredProc.DataSet.Next;
    end;

    FiteText := FiteText + '</' + cRoot + '>';
    Writeln(F, FiteText);

    Result := True;
  finally
    CloseFile(F);
    if Assigned(DST) then
    begin
      FStoredProc.DataSet := Nil;
      DST.Free;
    end;

    if Result and (FEncodingType = etUtf8) then
    begin
      sl := TStringList.Create;
      try
        sl.LoadFromFile(FSaveFile.FileName);
        sl.SaveToFile(FSaveFile.FileName, TEncoding.UTF8)
      finally
        sl.Free;
      end;
    end;
  end;
end;

end.
