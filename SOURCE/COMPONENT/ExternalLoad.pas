unit ExternalLoad;

{$I ..\dsdVer.inc}

interface

uses
  dsdAction, dsdDb, Classes, DB, ExternalData, ADODB, Winapi.ActiveX, System.Win.COMObj, Vcl.Forms
  {$IFDEF DELPHI103RIO}, JSON, Actions {$ELSE} , DBXJSON {$ENDIF};

type

  TDataSetType = (dtDBF, dtXLS, dtMMO, dtODBC);

  TExternalLoad = class(TExternalData)
  protected
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  public
    property Active: boolean read FActive;
  end;

  TFileExternalLoad = class(TExternalLoad)
  private
    FInitializeDirectory: string;
    FDataSetType: TDataSetType;
    FAdoConnection: TADOConnection;
    FFileExtension: string;
    FFileFilter: string;
    FExtendedProperties: string;
    FStartRecord: integer;
    // Создаем тут обработку mmo файлов
    procedure CreateMMODataSet(FileName: string);
  protected
    procedure First; override;
  public
    constructor Create(DataSetType: TDataSetType = dtDBF; StartRecord: integer = 1; ExtendedProperties: string = ''); reintroduce;
    destructor Destroy; override;
    procedure Open(FileName: string);
    procedure Activate; override;
    procedure Close; override;
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
  end;

  TODBCExternalLoad = class(TExternalLoad)
  private
    FAdoConnection: TADOConnection;
  protected
    procedure First; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Open(AConnection, ASQL: string);
    procedure Activate; override;
    procedure Close; override;
  end;

  TExternalLoadAction = class(TdsdCustomAction)
  private
    FInitializeDirectory: string;
    FFileName: string;
  protected
    function GetStoredProc: TdsdStoredProc; virtual; abstract;
    function GetExternalLoad: TExternalLoad; virtual; abstract;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AStoredProc: TdsdStoredProc); virtual; abstract;
  public
    property FileName: string read FFileName write FFileName;
    constructor Create(Owner: TComponent); override;
    function Execute: boolean; override;
  published
    // Директория загрузки. Сделана published что бы сохранять данные по стандартной схеме
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
  end;

  TImportSettingsItems = class (TCollectionItem)
  public
    ItemName: string;
    Param: TdsdParam;
    ConvertFormatInExcel: boolean;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  end;

  TImportSettings = class (TCollection)
  public
    JuridicalId: Integer;
    ContractId: Integer;
    FileType: TDataSetType;
    StoredProc: TdsdStoredProc;
    StartRow: integer;
    HDR: boolean;
    Directory: string;
    Query: string;
    JSONParamName: string;
    constructor Create(ItemClass: TCollectionItemClass);
    destructor Destroy; override;
  end;

  TImportSettingsFactory = class
  private
    class function GetDefaultByFieldType(FieldType: TFieldType): OleVariant;
    class function CreateImportSettings(Id: integer; Directory_add :String): TImportSettings;
  public
    class function GetImportSettings(Id: integer; Directory_add :String): TImportSettings;
  end;

  TExecuteProcedureFromExternalDataSet = class
  private
    FExternalLoad: TExternalLoad;
    FImportSettings: TImportSettings;
    FExternalParams: TdsdParams;
    function GetFieldName(AFieldName: AnsiString; AImportSettings: TImportSettings): string;
    function ProcessingOneRow(AExternalLoad: TExternalLoad; AImportSettings: TImportSettings): TJSONObject;
  public
    constructor Create(FileType: TDataSetType; FileName: string; ImportSettings: TImportSettings; ExternalParams: TdsdParams = nil); overload;
    constructor Create(ConnectionString, SQL: string; ImportSettings: TImportSettings; ExternalParams: TdsdParams = nil); overload;
    destructor Destroy; override;
    procedure Load;
  end;

  TExecuteImportSettings = class
    class procedure Execute(ImportSettings: TImportSettings; ExternalParams: TdsdParams = nil);
  end;

  TExecuteImportSettingsAction = class(TdsdCustomAction)
  private
    FImportSettingsId: TdsdParam;
    FExternalParams: TdsdParams;
  protected
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ImportSettingsId: TdsdParam read FImportSettingsId write FImportSettingsId;
    property ExternalParams: TdsdParams read FExternalParams Write FExternalParams;
  end;

  procedure Register;

implementation

uses VCL.ActnList, SysUtils, Dialogs, SimpleGauge, VKDBFDataSet, UnilWin,
     DBClient, TypInfo, Variants, UtilConvert, WinApi.Windows, StrUtils,
     System.Types, Registry;

const cArchive = 'Archive';

procedure Register;
begin
  RegisterActions('dsdImportExport', [TExecuteImportSettingsAction], TExecuteImportSettingsAction);
end;

function GetFileType(FileTypeName: string): TDataSetType;
begin
  if FileTypeName = 'ODBC' then
     result := dtODBC
  else
    if FileTypeName = 'DBF' then
       result := dtDBF
    else
      if FileTypeName = 'Excel' then
         result := dtXLS
      else
        if FileTypeName = 'MMO' then
           result := dtMMO
        else
          raise Exception.Create('Тип файла "' + FileTypeName + '" не определен в программе');
end;

{ TFileExternalLoad }

procedure TFileExternalLoad.Activate;
begin
  with {File}TOpenDialog.Create(nil) do
  try
    InitialDir := InitializeDirectory;
    DefaultExt := FFileExtension;
    Filter := FFileFilter;
    if Execute then begin
       InitializeDirectory := ExtractFilePath(FileName);
       Self.Open(FileName);
    end;
  finally
    Free;
  end;
end;

constructor TExternalLoadAction.Create(Owner: TComponent);
begin
  FileName := '';
  inherited;
end;

function TExternalLoadAction.Execute: boolean;
var
   FExternalLoad: TFileExternalLoad;
   FStoredProc: TdsdStoredProc;
begin
  result := false;
  FExternalLoad := TFileExternalLoad(GetExternalLoad);
  try
    FExternalLoad.InitializeDirectory := InitializeDirectory;
    if FileName <> '' then
       FExternalLoad.Open(FileName)
    else
       FExternalLoad.Activate;
    if FExternalLoad.Active then begin
       InitializeDirectory := FExternalLoad.InitializeDirectory;
       FStoredProc := GetStoredProc;
       try
         if  FExternalLoad.RecordCount > 0 then
             with TGaugeFactory.GetGauge('Загрузка данных', 1, FExternalLoad.RecordCount) do begin
               Start;
               try
                 while not FExternalLoad.EOF do begin
                   ProcessingOneRow(FExternalLoad, FStoredProc);
                   IncProgress;
                   FExternalLoad.Next;
                 end;
               finally
                 Finish
               end;
               result := true
             end;
       finally
         FStoredProc.Free
       end;
    end;
  finally
    FExternalLoad.Free;
  end;
end;

procedure TFileExternalLoad.Close;
begin
  FDataSet.Close;
  if Assigned(FAdoConnection) then
     FAdoConnection.Connected := false;
end;

constructor TFileExternalLoad.Create(DataSetType: TDataSetType; StartRecord: integer; ExtendedProperties: string);
begin
  inherited Create;
  FOEM := true;
  FDataSetType := DataSetType;
  FExtendedProperties := ExtendedProperties;
  FStartRecord := StartRecord;
  case FDataSetType of
    dtDBF: begin
             FFileExtension := '*.dbf';
             FFileFilter := 'Файлы DBF (*.dbf)|*.dbf|';
           end;
    dtXLS: begin
             FFileExtension := '*.xls';
             FFileFilter := 'Файлы выгрузки Excel|*.xls;*.xlsx|';
           end;
  end;
end;

procedure TFileExternalLoad.CreateMMODataSet(FileName: string);
var
  StringList: TStringList;
  OkpoFrom, OkpoTo, InvNumber, InvTaxNumber,
  Remark: string;
  OperDate, ExpirationDate: TDateTime;
  PaymentDate: Variant;
  PriceWithVAT: boolean;
  SyncCode: Integer;
  ElementList: TStringDynArray;
  i: integer;
  Price: Currency;
begin
  FDataSet := TClientDataSet.Create(nil);
  FDataSet.FieldDefs.Add('OKPOFrom', ftString, 255);
  FDataSet.FieldDefs.Add('OKPOTo', ftString, 255);
  FDataSet.FieldDefs.Add('InvNumber', ftString, 255);
  FDataSet.FieldDefs.Add('OperDate', ftDateTime);
  FDataSet.FieldDefs.Add('InvTaxNumber', ftString, 255);
  FDataSet.FieldDefs.Add('PaymentDate', ftDateTime);
  FDataSet.FieldDefs.Add('PriceWithVAT', ftBoolean);
  FDataSet.FieldDefs.Add('SyncCode', ftInteger);
  FDataSet.FieldDefs.Add('Remark', ftString, 255);

  FDataSet.FieldDefs.Add('GoodsCode', ftString, 255);
  FDataSet.FieldDefs.Add('GoodsName', ftString, 255);
  FDataSet.FieldDefs.Add('MakerCode', ftString, 255);
  FDataSet.FieldDefs.Add('MakerName', ftString, 255);
  FDataSet.FieldDefs.Add('CommonCode', ftString, 255);
  FDataSet.FieldDefs.Add('VAT', ftInteger);
  FDataSet.FieldDefs.Add('PartitionGoods', ftString, 255); // Номер серии
  FDataSet.FieldDefs.Add('ExpirationDate', ftDateTime);    // Срок годности
  FDataSet.FieldDefs.Add('FEA', ftString, 255); //
  FDataSet.FieldDefs.Add('MeasureName', ftString, 255); //

  FDataSet.FieldDefs.Add('SertificatNumber', ftString, 255); //
  FDataSet.FieldDefs.Add('SertificatStart', ftDateTime);    // Срок годности
  FDataSet.FieldDefs.Add('SertificatEnd', ftDateTime);    // Срок годности

  FDataSet.FieldDefs.Add('Amount', ftFloat);    // Количество
  FDataSet.FieldDefs.Add('Price', ftFloat);     // Цена Отпускная (для аптеки это закупочная)

  TClientDataSet(FDataSet).CreateDataSet;
  // Считываем файл
  StringList := TStringList.Create;
  try
    StringList.LoadFromFile(FileName);
    // Загрузка заголовка. 3 строки
    ElementList := SplitString(StringList[0], #9);
    OkpoFrom := ElementList[1];
    OkpoTo := ElementList[2];
    ElementList := SplitString(StringList[1], #9);
    InvNumber := ElementList[0];
    OperDate := VarToDateTime(trim(ElementList[1]));
    InvTaxNumber := ElementList[2];
    if (ElementList[13] = '') or (ElementList[13] = '  .  .  ') then
       PaymentDate := Null
    else
       PaymentDate := VarToDateTime(ElementList[13]);

    PriceWithVAT := ElementList[14] = '1';
    SyncCode := StrToIntDef(ElementList[15], 0);

    Remark := '';
    ElementList := SplitString(StringList[2], #9);
    for I := Low(ElementList) to High(ElementList) do
        if ElementList[i] <> '' then begin
           Remark := ReplaceStr(ElementList[i], '""', '"');
           Remark := ReplaceStr(Remark, '´', '`');
           break;
        end;
    for I := 3 to StringList.Count - 1 do
        // разбираем строки
        with FDataSet do begin
          if StringList[i] = '' then
             break;
          ElementList := SplitString(StringList[i], #9);
          if PriceWithVAT then
             Price := gfStrToFloat(ElementList[19])
          else
             Price := gfStrToFloat(AnsiReplaceStr(ElementList[20], ' ', '')) / gfStrToFloat(AnsiReplaceStr(ElementList[15], ' ', ''));
          ElementList[13] := trim(ElementList[13]);
          if (ElementList[13] = '') or (ElementList[13] = '.  .') then
             ExpirationDate := OperDate + 365
          else
             ExpirationDate := VarToDateTime(ElementList[13]);    // Срок годности
          // Проверяем задвоенные позиции
          if Locate('GoodsCode;PartitionGoods;ExpirationDate;Price',
                      VarArrayOf([ElementList[0], ElementList[10], ExpirationDate, Price]), []) then begin
             Edit;
             FieldByName('Amount').AsFloat := FieldByName('Amount').AsFloat + gfStrToFloat(ElementList[15]);    // Количество
             Post
          end
          else begin
            Append;
            FieldByName('OKPOFrom').AsString := OkpoFrom;
            FieldByName('OKPOTo').AsString := OkpoTo;
            FieldByName('InvNumber').AsString := InvNumber;
            FieldByName('OperDate').AsDateTime := OperDate;
            FieldByName('InvTaxNumber').AsString := InvTaxNumber;
            FieldByName('PaymentDate').Value := PaymentDate;
            FieldByName('PriceWithVAT').AsBoolean := PriceWithVAT;
            FieldByName('SyncCode').AsInteger := SyncCode;
            FieldByName('Remark').AsString := Remark;

            FieldByName('GoodsCode').AsString := ElementList[0];
            FieldByName('GoodsName').AsString := ElementList[1];
            FieldByName('MakerCode').AsString := ElementList[2];
            FieldByName('MakerName').AsString := ElementList[3];
            FieldByName('CommonCode').AsString := ElementList[4];
            FieldByName('SertificatNumber').AsString := ElementList[5]; // Номер регистрации
            if (TRIM(ElementList[6]) = '') or (ElementList[6] = '  .  .  ') then
              FieldByName('SertificatStart').Clear
            else
              FieldByName('SertificatStart').asDateTime := VarToDateTime(ElementList[6]);
            if (TRIM(ElementList[7]) = '') or (ElementList[7] = '  .  .  ') then
              FieldByName('SertificatEnd').Clear
            else
              FieldByName('SertificatEnd').AsDateTime := VarToDateTime(ElementList[7]);

            FieldByName('VAT').AsInteger := round(gfStrToFloat(ElementList[8]));
            FieldByName('PartitionGoods').AsString := ElementList[10]; // Номер серии
            FieldByName('ExpirationDate').AsDateTime := ExpirationDate;    // Срок годности
            if High(ElementList) < 21 then
               FieldByName('FEA').AsString := '' // КВЭД
            else
               FieldByName('FEA').AsString := ElementList[21]; // КВЭД
            FieldByName('MeasureName').AsString := ElementList[14]; // Ед Изм
            FieldByName('Amount').AsFloat := gfStrToFloat(ReplaceStr(ElementList[15], ' ', ''));    // Количество
            FieldByName('Price').AsFloat  := Price;    // Цена Отпускная (для аптеки это закупочная)
            Post;
          end;
        end;
  finally
    StringList.Free;
  end;
end;

destructor TFileExternalLoad.Destroy;
begin
  if Assigned(FDataSet) then
     FreeAndNil(FDataSet);
  if Assigned(FAdoConnection) then
     FreeAndNil(FAdoConnection);
  inherited;
end;

procedure TFileExternalLoad.First;
begin
  inherited;
  FDataSet.First
end;

procedure CheckExcelFloat(AFileName: string; AImportSettings: TCollection);
const
  ExcelAppName = 'Excel.Application';
var
  CLSID: TCLSID;
  Excel, Sheet: Variant;
  Row, Col, I: Integer;
  X: Int64;
  aaa:Integer;

  function CheckItemName(AItemName: string): boolean;
  begin
    Result := (Trim(AItemName) <> '') and (Pos('%', AItemName) = 0);
  end;

begin
  if CLSIDFromProgID(PChar(ExcelAppName), CLSID) = S_OK then
  begin
    Excel := CreateOLEObject(ExcelAppName);

    try
      Excel.Visible := False;
      Excel.Application.EnableEvents := False;
      Excel.DisplayAlerts := False;
      Excel.WorkBooks.Open(AFileName);
      Sheet := Excel.WorkBooks[1].WorkSheets[1];

      for I := 0 to AImportSettings.Count - 1 do
        if CheckItemName(TImportSettingsItems(AImportSettings.Items[i]).ItemName) and
           TImportSettingsItems(AImportSettings.Items[i]).ConvertFormatInExcel then
          Sheet.Range[TImportSettingsItems(AImportSettings.Items[i]).ItemName + '1',
                      TImportSettingsItems(AImportSettings.Items[i]).ItemName + IntToStr(Sheet.UsedRange.Rows.Count)].NumberFormat := 0;
      {
      for Row := 1 to Sheet.UsedRange.Rows.Count do
        for Col := 1 to Sheet.UsedRange.Columns.Count do

          if (AnsiUpperCase(Sheet.Cells[Row, Col].NumberFormat) = AnsiUpperCase('General')) then
            if TryStrToInt64(Sheet.Cells[Row, Col], X)
            then // ПРЕОБРАЗУЕМ - Только если там Штрих-код
                 if X > 12345678901 then
                 begin
                    Sheet.Cells[Row, Col].NumberFormat := 0;
                    //Sheet.Cells[Row, Col].Value := X;
                 end
                 else
            else
          else
              if (AnsiUpperCase(Sheet.Cells[Row, Col].NumberFormat) = AnsiUpperCase('Основной')) then
                if TryStrToInt64(Sheet.Cells[Row, Col], X)
                then // ПРЕОБРАЗУЕМ - Только если там Штрих-код
                     if X > 12345678901 then
                     begin
                       Sheet.Cells[Row, Col].NumberFormat := 0;
                       //Sheet.Cells[Row, Col].Value := X;
                     end;
      }
      Excel.WorkBooks[1].Save;
    finally
      if not VarIsEmpty(Excel) then
        Excel.Quit;

      Excel := Unassigned;
    end;
  end;
end;

procedure TFileExternalLoad.Open(FileName: string);
var strConn :  widestring;
    List: TStringList;
    ListName: string;
begin
  case FDataSetType of
    dtMMO: CreateMMODataSet(FileName);
    dtDBF: begin
        FDataSet := TVKSmartDBF.Create(nil);
        TVKSmartDBF(FDataSet).DBFFileName := AnsiString(FileName);
        TVKSmartDBF(FDataSet).OEM := FOEM;
        try
          FDataSet.Open;
        except
          on E: Exception do begin
             if Pos('TVKSmartDBF.InternalOpen: Open error', E.Message) > -1 then
                raise Exception.Create('Файл' + copy (E.Message, length('TVKSmartDBF.InternalOpen: Open error') + 1, MaxInt) + ' открыт другой программой. Закройте ее и попробуйте еще раз!')
             else
                raise Exception.Create(E.Message);
          end;
        end;
    end;
    dtXLS: begin
    {  try
         //   HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\Excel\Security\FileValidation
         with TRegistry.Create(KEY_READ) do begin
           try
             RootKey := HKEY_CURRENT_USER;
             if OpenKey('Software\Microsoft\Office\14.0\Excel\Security\FileValidation', True) then
                CanRead := ReadInteger('DisableEditFromPV');
           finally
             Free;
           end;
         end;
      except
        CanRead := 1;
      end;
      if true then
        with TRegistry.Create(KEY_WRITE) do begin
           try
             RootKey := HKEY_CURRENT_USER;
             if OpenKey('Software\Microsoft\Office\11.0\Excel\Security\FileValidation', True) then
                WriteInteger('DisableEditFromPV', 0);
             if OpenKey('Software\Microsoft\Office\12.0\Excel\Security\FileValidation', True) then
                WriteInteger('DisableEditFromPV', 0);
             if OpenKey('Software\Microsoft\Office\13.0\Excel\Security\FileValidation', True) then
                WriteInteger('DisableEditFromPV', 0);
             if OpenKey('Software\Microsoft\Office\14.0\Excel\Security\FileValidation', True) then
                WriteInteger('DisableEditFromPV', 0);
             if OpenKey('Software\Microsoft\Office\15.0\Excel\Security\FileValidation', True) then
                WriteInteger('DisableEditFromPV', 0);
             if OpenKey('Software\Microsoft\Office\16.0\Excel\Security\FileValidation', True) then
                WriteInteger('DisableEditFromPV', 0);
           finally
             Free;
           end;
         end;
     }

      {
      if Copy(FileName, 1, 3) = '..\' then
        CheckExcelFloat(AnsiReplaceText(UpperCase(ExtractFilePath(Application.ExeName)), '\BIN\', Copy(FileName, 3, Length(FileName))))
      else
        CheckExcelFloat(FileName);
      }

      // Подключение для  xlsx
      if Pos('.xlsx', AnsiLowerCase(FileName)) > 0 then
        strConn:='Provider=Microsoft.ACE.OLEDB.12.0;Mode=Read;' +
                 'Data Source=' + FileName + ';' +
                 'Extended Properties="Excel 12.0 Xml' + FExtendedProperties + ';IMEX=1;"'
      else strConn:='Provider=Microsoft.Jet.OLEDB.4.0;Mode=Read;' +
               'Data Source=' + FileName + ';' +
               'Extended Properties="Excel 8.0' + FExtendedProperties + ';IMEX=1;"';
//      strConn:='Provider=Microsoft.ACE.OLEDB.12.0;Mode=Read;' +
//               'Data Source=' + FileName + ';' +
//               'Extended Properties="Excel 12.0' + FExtendedProperties + ';IMEX=1;"';
      if not Assigned(FAdoConnection) then begin
         FAdoConnection := TAdoConnection.Create(nil);
         FAdoConnection.LoginPrompt := false;
         FDataSet := TADOQuery.Create(nil);
         TADOQuery(FDataSet).Connection := FAdoConnection;
      end;
      FAdoConnection.Connected := False;
      FAdoConnection.ConnectionString := strConn;
      FAdoConnection.Open;

      List := TStringList.Create;
      try
        FAdoConnection.GetTableNames(List, True);
        TADOQuery(FDataSet).ParamCheck := false;
        ListName := '';//List[0];
        if Copy(ListName, 1, 1) = chr(39) then
           ListName := Copy(List[0], 2, length(List[0])-2);
        if Pos('.xlsx', AnsiLowerCase(FileName)) > 0 then
          TADOQuery(FDataSet).SQL.Text := 'SELECT * FROM [' + ListName + 'A' + IntToStr(FStartRecord)+ ':CZ60000]'
        else TADOQuery(FDataSet).SQL.Text := 'SELECT * FROM [' + ListName + 'A' + IntToStr(FStartRecord)+ ':SZ60000]';
        TADOQuery(FDataSet).Open;
      finally
        FreeAndNil(List);
      end;
    end;
  end;
  First;
  FActive := FDataSet.Active;
end;

{ TExecuteProcedureFromFile }

constructor TExecuteProcedureFromExternalDataSet.Create(FileType: TDataSetType; FileName: string; ImportSettings: TImportSettings;
  ExternalParams: TdsdParams = nil);
var ExtendedProperties: string;
begin
  if ImportSettings.HDR then
     ExtendedProperties := '; HDR=Yes'
  else
     ExtendedProperties := '; HDR=No';
  FImportSettings := ImportSettings;
  FExternalParams := ExternalParams;
  FExternalLoad := TFileExternalLoad.Create(FileType, ImportSettings.StartRow, ExtendedProperties);
  TFileExternalLoad(FExternalLoad).Open(FileName);
end;

constructor TExecuteProcedureFromExternalDataSet.Create(ConnectionString,
  SQL: string; ImportSettings: TImportSettings; ExternalParams: TdsdParams = nil);
begin
  FImportSettings := ImportSettings;
  FExternalParams := ExternalParams;
  FExternalLoad := TODBCExternalLoad.Create;
  TODBCExternalLoad(FExternalLoad).Open(ConnectionString, SQL);
  TODBCExternalLoad(FExternalLoad).Activate;
end;

destructor TExecuteProcedureFromExternalDataSet.Destroy;
begin
  FreeAndNil(FExternalLoad);
  inherited;
end;

function TExecuteProcedureFromExternalDataSet.GetFieldName(AFieldName: AnsiString;
  AImportSettings: TImportSettings): string;
var
  c, c1: char;
begin
  result := AFieldName;
  if (AImportSettings.FileType = dtXLS) and (not AImportSettings.HDR) then begin
     if (length(AFieldName) = 1) then begin
        c := lowercase(AFieldName)[1];
        if CharInSet(c,['a'..'z']) then
           result := 'F' + IntToStr(byte(c) - byte('a') + 1);
     end;
     if (length(AFieldName) = 2) then begin
        c  := lowercase(AFieldName)[1];
        c1 := lowercase(AFieldName)[2];
        if CharInSet(c,['a'..'z']) and CharInSet(c1,['a'..'z']) then
           result := 'F' + IntToStr((byte(c) - byte('a') + 1) *26 + byte(c1) - byte('a') + 1);
     end;
  end;
end;

procedure TExecuteProcedureFromExternalDataSet.Load;
var JsonArray: TJSONArray;
    dsdProc: TdsdStoredProc;
    I: integer;
begin
  with TGaugeFactory.GetGauge('Загрузка данных', 1, FExternalLoad.RecordCount) do begin
    Start;
    JSONArray := TJSONArray.Create();
    try
      I := 0;
      while not FExternalLoad.EOF do begin
        JSONArray.AddElement(ProcessingOneRow(FExternalLoad, FImportSettings));
        IncProgress;
        FExternalLoad.Next;
      end;

      {with TStringList.Create do
      begin
        Text := JSONArray.ToString;
        SaveToFile('price.json');
        Free;
      end;}

      if FImportSettings.JSONParamName <> '' then
      begin
        FImportSettings.StoredProc.ParamByName(FImportSettings.JSONParamName).Value := JSONArray.ToString;
        FImportSettings.StoredProc.Execute;
      end
      else
        FImportSettings.StoredProc.Execute(true);

      FExternalLoad.Close;
    finally
     JSONArray.Free;
     Finish
    end;
  end;
end;

function TExecuteProcedureFromExternalDataSet.ProcessingOneRow(AExternalLoad: TExternalLoad;
  AImportSettings: TImportSettings): TJSONObject;
var i: integer;
    D: TDateTime;
    Value: OleVariant;
    Ft: double;
    Field: TField;
    vbFieldName: string;
    cParamName: string;
    JSONObject: TJSONObject;
    bJSON: boolean;
    vParamValue: Variant;

  function AdaptStr(S: string): string;
  var
    C: Char;
    Code: SmallInt;
  begin
    Result := '';

    for C in S do
    begin
      Code := Ord(C);

      if Code = 39 then
        Result := Result + '`'
      else if Code = 188 then
        Result := Result + '1/4'
      else if Code = 189 then
        Result := Result + '1/2'
      else if Code = 190 then
        Result := Result + '3/4'
      else
        Result := Result + C;
    end;
  end;

  procedure AddParamToJSON(AName: string; AValue: Variant; ADataType: TFieldType);
  var intValue: integer;
  begin
    if AValue = NULL then
      JSONObject.AddPair(AName, TJSONNull.Create)
    else if ADataType = ftDateTime then
      JSONObject.AddPair(AName, FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', AValue))
    else if ADataType = ftFloat then
      JSONObject.AddPair(AName, TJSONNumber.Create(AValue))
    else if ADataType = ftInteger then
    begin
      if TryStrToInt(AValue, intValue) then
        JSONObject.AddPair(cParamName, TJSONNumber.Create(intValue))
      else
        JSONObject.AddPair(AName, TJSONNull.Create);
    end
    else
      JSONObject.AddPair(cParamName, ReplaceText(
        ReplaceText(String(AValue), '\', '\\'), '"', '&quot;'));
  end;

begin
  bJSON := AImportSettings.JSONParamName <> '';
  Result := nil;
  if bJSON then
    JSONObject := TJSONObject.Create;
  with AImportSettings do begin
    for i := 0 to Count - 1 do begin
        if TImportSettingsItems(Items[i]).ItemName = '%OBJECT%' then
           StoredProc.Params.Items[i].Value := AImportSettings.JuridicalId
        else
           if TImportSettingsItems(Items[i]).ItemName = '%CONTRACT%' then
              StoredProc.Params.Items[i].Value := AImportSettings.ContractId
           else
             if TImportSettingsItems(Items[i]).ItemName = '%LASTRECORD%' then
                StoredProc.Params.Items[i].Value := AExternalLoad.isLastRecord
             else
               if TImportSettingsItems(Items[i]).ItemName = '%EXTERNALPARAM%' then
               Begin
                 if Assigned(FexternalParams) then
                   if FexternalParams.ParamByName(StoredProc.Params[i].Name) <> nil then
                     StoredProc.Params.Items[i].Value := FexternalParams.ParamByName(StoredProc.Params[i].Name).Value
                   else
                     raise Exception.Create('В наборе внешних параметров не найден параметр с именем <'+StoredProc.Params[i].Name+'>')
                 else
                   raise Exception.Create('Не определен набор внешних параметров');

               end
               else
               begin
                 cParamName := LowerCase(TImportSettingsItems(Items[i]).Param.Name);
                 if TImportSettingsItems(Items[i]).ItemName <> '' then begin
                    vbFieldName := GetFieldName(TImportSettingsItems(Items[i]).ItemName, AImportSettings);
                    Field := AExternalLoad.FDataSet.FindField(vbFieldName);
                    if not Assigned(Field) then
                       raise Exception.Create('Не найдено значение для ячейки ' + TImportSettingsItems(Items[i]).ItemName);
                    case TImportSettingsItems(Items[i]).Param.DataType of
                      ftDateTime: begin
                         D := 0;
                         if Field.Value = null then
                             vParamValue := Null
                         else
                           try
                             Value := Field.Value;
                             D := VarToDateTime(Value);
                             vParamValue := D;

                           except
                             on E: EVariantTypeCastError do
                                vParamValue := Date;
                             on E: Exception do
                                raise E;
                           end;
                        if bJSON then
                          AddParamToJSON(cParamName, vParamValue, TImportSettingsItems(Items[i]).Param.DataType)
                        else
                          StoredProc.Params.Items[i].Value := vParamValue;
                      end;
                      ftFloat: begin
                         try
                           Value := Field.Value;
                           Ft := gfStrToFloat(Value);
                           vParamValue := Ft;
                         except
                           on E: EVariantTypeCastError do
                              vParamValue := 0;
                           on E: Exception do
                              raise E;
                         end;
                        if bJSON then
                          AddParamToJSON(cParamName, vParamValue, TImportSettingsItems(Items[i]).Param.DataType)
                        else
                          StoredProc.Params.Items[i].Value := vParamValue;
                      end
                      else
                      begin
                        if VarIsNULL(Field.Value) then
                          vParamValue := ''
                        else
                          vParamValue := Trim(AdaptStr(Field.Value));
                        if bJSON then
                          AddParamToJSON(cParamName, vParamValue, TImportSettingsItems(Items[i]).Param.DataType)
                        else
                          StoredProc.Params.Items[i].Value := vParamValue;
                      end;
                    end;
                 end;
          end;
    end;
    if not bJSON then
      StoredProc.Execute
    else
      Result := JSONObject;
  end;
end;

{ TExecuteImportSettings }

 class procedure TExecuteImportSettings.Execute(ImportSettings: TImportSettings; ExternalParams: TdsdParams = nil);
var iFilesCount: Integer;
    saFound: TStrings;
    i: integer;
    fErr:Boolean;//09.06.2016
    TextMessage:String;
begin
  case ImportSettings.FileType of
    dtXLS, dtDBF, dtMMO: begin
        saFound := TStringList.Create;
        try
          // Если директории нет, то пусть пользователь выбирает.
          if ImportSettings.Directory = '' then begin
             with {File}TOpenDialog.Create(nil) do
             try
               //InitialDir := InitializeDirectory;
               //DefaultExt := FFileExtension;
               if ImportSettings.FileType = dtXLS then
                  Filter := '*.xls';
               if Execute then begin
                  saFound.Add(FileName);
                  //InitializeDirectory := ExtractFilePath(FileName);
                  //Self.Open(FileName);
               end;
             finally
               Free;
             end;
          end
          else begin
            case ImportSettings.FileType of
               dtXLS: FilesInDir('*.xls', ImportSettings.Directory, iFilesCount, saFound, false);
               dtMMO: FilesInDir('*.mmo', ImportSettings.Directory, iFilesCount, saFound, false);
               dtDBF: FilesInDir('*.dbf', ImportSettings.Directory, iFilesCount, saFound, false);
            end;
          end;
          //сначала - очистили список не загруженных файлов
          if Assigned(ExternalParams) and Assigned(ExternalParams.ParamByName('outMsgText'))
          then ExternalParams.ParamByName('outMsgText').Value:= '';

          TStringList(saFound).Sort;
          for I := 0 to saFound.Count - 1 do
          begin
              // конвертируем формат для штрихкодов (только для Excel)
              if ImportSettings.FileType = dtXLS then
              begin
                if Copy(saFound[i], 1, 3) = '..\' then
                  CheckExcelFloat(AnsiReplaceText(UpperCase(ExtractFilePath(Application.ExeName)),
                                                  '\BIN\',
                                                  Copy(saFound[i], 3, Length(saFound[i]))),
                                  ImportSettings)
                else
                  CheckExcelFloat(saFound[i], ImportSettings);
              end;

              with TExecuteProcedureFromExternalDataSet.Create(ImportSettings.FileType, saFound[i], ImportSettings, ExternalParams) do
                try
                  // Загрузили if + в try с 09.06.2016 - Konstantin
                  if Assigned(ExternalParams) and Assigned(ExternalParams.ParamByName('isNext_aftErr')) and (ExternalParams.ParamByName('isNext_aftErr').Value = TRUE)
                  then
                  try
                    Load;
                    fErr:= false;
                       except
                           on E: Exception do begin
                              fErr:= true;
                              TextMessage := E.Message;
                              if pos('context', AnsilowerCase(TextMessage)) > 0 then
                                TextMessage:=trim (Copy(TextMessage, 1, pos('context', AnsilowerCase(TextMessage)) - 1));
                              if TextMessage <> ''
                              then TextMessage := ' - ' + ReplaceStr(TextMessage, 'ERROR:', 'ОШИБКА:');
                              //добавили в список не загруженных файлов
                              if Assigned(ExternalParams) and Assigned(ExternalParams.ParamByName('outMsgText'))
                              then if ExternalParams.ParamByName('outMsgText').Value <> ''
                                   then ExternalParams.ParamByName('outMsgText').Value:=ExternalParams.ParamByName('outMsgText').Value + #10 + #13 + saFound[i] + TextMessage
                                   else ExternalParams.ParamByName('outMsgText').Value:=saFound[i] + TextMessage;
                           end;
                       end
                  else try
                    Load;
                    fErr:= false;
                       except
                           on E: Exception do begin
                              fErr:= true;
                              TextMessage := E.Message;
                              if pos('context', AnsilowerCase(TextMessage)) > 0 then
                                TextMessage:=trim (Copy(TextMessage, 1, pos('context', AnsilowerCase(TextMessage)) - 1));
                              if TextMessage <> ''
                              then TextMessage := ' - ' + ReplaceStr(TextMessage, 'ERROR:', 'ОШИБКА:');
                           end;
                       end;
                  // Перенесли в Archive
                  if fErr = false then
                  begin
                      ForceDirectories(ExtractFilePath(saFound[i]) + cArchive);
                      RenameFile(saFound[i], ExtractFilePath(saFound[i]) + cArchive + '\' + FormatDateTime('yyyy_mm_dd_hh_mm_', Now) + ExtractFileName(saFound[i]));
                      if FileExists(saFound[i]) then
                         SysUtils.DeleteFile(saFound[i]);
                  end;
                finally
                  Free;
                end;
          end;
        finally
          saFound.Free
        end;
    end;
    dtODBC: begin
              with TExecuteProcedureFromExternalDataSet.Create(ImportSettings.Directory, ImportSettings.Query, ImportSettings, ExternalParams) do
                try
                  // Загрузили
                  Load;
                finally
                  Free;
                end;
    end;
  end;
end;

{ TImportSettings }

constructor TImportSettings.Create(ItemClass: TCollectionItemClass);
begin
  inherited;
  StoredProc := TdsdStoredProc.Create(nil);
end;

destructor TImportSettings.Destroy;
begin
  FreeAndNil(StoredProc);
  inherited;
end;

{ TImportSettingsFactory }

class function TImportSettingsFactory.CreateImportSettings(Id: integer; Directory_add :String): TImportSettings;
var
  GetStoredProc: TdsdStoredProc;
  FieldType: TFieldType;
begin
  GetStoredProc := TdsdStoredProc.Create(nil);
  GetStoredProc.OutputType := otResult;
  GetStoredProc.StoredProcName := 'gpGet_Object_ImportSettings';
  GetStoredProc.Params.AddParam('inId', ftInteger, ptInput, Id);

  GetStoredProc.Params.AddParam('StartRow', ftInteger, ptOutput, 0);
  GetStoredProc.Params.AddParam('HDR', ftBoolean, ptOutput, true);
  GetStoredProc.Params.AddParam('ContractId', ftInteger, ptOutput, 0);
  GetStoredProc.Params.AddParam('JuridicalId', ftInteger, ptOutput, 0);
  GetStoredProc.Params.AddParam('FileTypeName', ftString, ptOutput, '');
  GetStoredProc.Params.AddParam('ImportTypeName', ftString, ptOutput, '');
  GetStoredProc.Params.AddParam('Directory', ftString, ptOutput, '');
  GetStoredProc.Params.AddParam('ProcedureName', ftString, ptOutput, '');
  GetStoredProc.Params.AddParam('Query', ftString, ptOutput, '');
  GetStoredProc.Params.AddParam('JSONParamName', ftString, ptOutput, '');

  GetStoredProc.Execute;
  {Заполняем параметрами процедуру}
  Result := TImportSettings.Create(TImportSettingsItems);
  Result.StartRow := GetStoredProc.Params.ParamByName('StartRow').Value;
  if Directory_add <> ''
  then Result.Directory := GetStoredProc.Params.ParamByName('Directory').Value+Directory_add+'\'
  else Result.Directory := GetStoredProc.Params.ParamByName('Directory').Value;
  Result.FileType := GetFileType(GetStoredProc.Params.ParamByName('FileTypeName').Value);
  Result.JuridicalId := StrToIntDef(GetStoredProc.Params.ParamByName('JuridicalId').AsString, 0);
  Result.ContractId := StrToIntDef(GetStoredProc.Params.ParamByName('ContractId').AsString, 0);
  Result.HDR := GetStoredProc.Params.ParamByName('HDR').Value;
  Result.Query := GetStoredProc.Params.ParamByName('Query').Value;
  Result.JSONParamName := GetStoredProc.Params.ParamByName('JSONParamName').Value;

  //if Result.Directory = '' then begin
  if Result.JSONParamName <> '' then begin
     Result.StoredProc.OutputType := otResult;
     Result.StoredProc.PackSize := 1;
  end
  else begin
     Result.StoredProc.OutputType := otMultiExecute;
     Result.StoredProc.PackSize := 100;
  end;

  Result.StoredProc.StoredProcName := GetStoredProc.Params.ParamByName('ProcedureName').Value;

  GetStoredProc.Params.Clear;
  {Заполняем параметрами параметры процедуры}
  GetStoredProc.StoredProcName := 'gpSelect_Object_ImportSettingsItems';
  GetStoredProc.Params.AddParam('inId', ftInteger, ptInput, Id);
  GetStoredProc.OutputType := otDataSet;
  GetStoredProc.DataSet := TClientDataSet.Create(nil);
  TClientDataSet(GetStoredProc.DataSet).IndexFieldNames := 'ParamNumber';
  GetStoredProc.Execute;

  with GetStoredProc.DataSet do begin
    Filtered := true;
    Filter := 'isErased <> true';
    while not EOF do begin
      FieldType := TFieldType(GetEnumValue(TypeInfo(TFieldType), FieldByName('ParamType').asString));
      with TImportSettingsItems(Result.Add) do begin
        ItemName := FieldByName('ParamValue').asString;
        Param.DataType := FieldType;
        Param.Name := FieldByName('ParamName').asString;
        ConvertFormatInExcel := FieldByName('ConvertFormatInExcel').asBoolean;
        if FieldByName('DefaultValue').AsString = '' then
           Param.Value := GetDefaultByFieldType(FieldType)
        else
           Param.Value := FieldByName('DefaultValue').AsString;

        if ((Result.JSONParamName <> '') and
              ((Pos('%', FieldByName('ParamValue').asString) > 0) or (FieldByName('DefaultValue').AsString <> '')))
           or
           (Result.JSONParamName = '') then
          Result.StoredProc.Params.AddParam(FieldByName('ParamName').asString, FieldType, ptInput, Param.Value);
      end;
      Next;
    end;
  end;

  if Result.JSONParamName <> '' then
    Result.StoredProc.Params.AddParam(Result.JSONParamName, ftWideString, ptInput, NULL);

end;

class function TImportSettingsFactory.GetDefaultByFieldType(
  FieldType: TFieldType): OleVariant;
begin
  case FieldType of
    ftString: result := '';
    ftInteger, ftFloat: result := 0;
    ftBoolean: result := true;
    ftDateTime: result := Date;
  end;
end;

class function TImportSettingsFactory.GetImportSettings(
  Id: integer; Directory_add :String): TImportSettings;
begin
  result := CreateImportSettings(Id, Directory_add);
end;

{ TExecuteImportSettingsAction }

constructor TExecuteImportSettingsAction.Create(AOwner: TComponent);
begin
  inherited;
  FImportSettingsId := TdsdParam.Create(nil);
  FExternalParams := TdsdParams.Create(Self,TdsdParam);
end;

destructor TExecuteImportSettingsAction.Destroy;
begin
  FreeAndNil(FImportSettingsId);
  FreeAndNil(FExternalParams);
  inherited;
end;

function TExecuteImportSettingsAction.LocalExecute: boolean;
var lDirectory_add:String;
    i:Integer;
begin
  //
  lDirectory_add:='';
  if Assigned (FExternalParams) then
    for i := 0 to FExternalParams.Count - 1 do
        if AnsiUpperCase(FExternalParams[i].Name) =  AnsiUpperCase('Directory_add')
        then
           lDirectory_add:=FExternalParams[i].Value;
  //
  TExecuteImportSettings.Execute(TImportSettingsFactory.CreateImportSettings(ImportSettingsId.Value, lDirectory_add),FExternalParams);
  result := true;
end;

{ TImportSettingsItems }

constructor TImportSettingsItems.Create(Collection: TCollection);
begin
  inherited;
  Param := TdsdParam.Create(nil);
end;

destructor TImportSettingsItems.Destroy;
begin
  FreeAndNil(Param);
  inherited;
end;

{ TODBCExternalLoad }

procedure TODBCExternalLoad.Activate;
begin
  inherited;
  FDataSet.Open;
end;

procedure TODBCExternalLoad.Close;
begin
  FDataSet.Close;
end;

constructor TODBCExternalLoad.Create;
begin
  FAdoConnection := TADOConnection.Create(nil);
end;

destructor TODBCExternalLoad.Destroy;
begin
  FreeAndNil(FAdoConnection);
  inherited;
end;

procedure TODBCExternalLoad.First;
begin
  inherited;
  FDataSet.First;
end;

procedure TODBCExternalLoad.Open(AConnection, ASQL: string);
begin
  FAdoConnection.ConnectionString := AConnection;
  FAdoConnection.LoginPrompt := false;
  FAdoConnection.Connected := true;
  FDataSet := TADOQuery.Create(nil);
  with FDataSet as TADOQuery do begin
    Connection := FAdoConnection;
    SQL.Text := ASQL;
  end;
end;

initialization
  Classes.RegisterClass (TExecuteImportSettingsAction);

end.

