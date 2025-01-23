unit dsdDB;

interface

uses Classes, Vcl.Controls, dsdCommon, DBClient, DB;

type
  TOutputType = (otResult, otDataSet, otMultiDataSet, otBlob, otMultiExecute);

  TdsdParam = class(TCollectionItem)
  private
    FComponent: TComponent;
    FDataType: TFieldType;
    FValue: Variant;
    FName: String;
    FComponentItem: String;
    FParamType: TParamType;
    FonChange: TNotifyEvent;
    FMultiSelectSeparator: String;
    FValueChange: Boolean;  // add 22.01.2018
    function GetValue: Variant;
    procedure SetValue(const Value: Variant);
    procedure SetComponent(const Value: TComponent);
    procedure SetInDataSet(const DataSet: TDataSet; const FieldName: string; const Value: Variant);
    function GetFromDataSet(const DataSet: TDataSet; const FieldName: string): Variant;
    procedure SetInCrossDBViewAddOn(const Value: Variant);
    function GetFromCrossDBViewAddOn: Variant;
  protected
    function GetDisplayName: string; override;
    procedure AssignParam(Param: TdsdParam);
    function GetOwner: TPersistent; override;
  public
    property isValueChange: Boolean read FValueChange write FValueChange; // add 22.01.2018
    property onChange: TNotifyEvent read FonChange write FonChange;
    function AsString: string;
    function AsFloat: double;
    function AsInteger: Integer;
    procedure Assign(Source: TPersistent); override;
    constructor Create(Collection: TCollection); overload; override;
    constructor Create; reintroduce; overload;
  published
    property Name: String read FName write FName;
    property Value: Variant read GetValue write SetValue;
    // Откуда считывать значение параметра
    property Component: TComponent read FComponent write SetComponent;
    property ComponentItem: String read FComponentItem write FComponentItem;
    property DataType: TFieldType read FDataType write FDataType default ftInteger;
    property ParamType: TParamType read FParamType write FParamType default ptOutput;
    property MultiSelectSeparator: String read FMultiSelectSeparator write FMultiSelectSeparator;
  end;

  TdsdParams = class (TOwnedCollection)
  private
    function GetItem(Index: Integer): TdsdParam;
    procedure SetItem(Index: Integer; const Value: TdsdParam);
  public
    procedure AssignParams(Source: TdsdParams);
    function ParamByName(const Value: string): TdsdParam;
    function Add: TdsdParam;
    function AddParam(AName: string; ADataType: TFieldType; AParamType: TParamType; AValue: Variant): TdsdParam;
    property Items[Index: Integer]: TdsdParam read GetItem write SetItem; default;
  end;

  TdsdFormParams = class (TdsdComponent)
  private
    FParams: TdsdParams;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function ParamByName(const Value: string): TdsdParam;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Params: TdsdParams read FParams write FParams;
  end;

  TdsdDataSetLink = class (TCollectionItem)
  private
    FDataSet: TDataSet;
  protected
    procedure SetDataSet(const Value: TDataSet); virtual;
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property DataSet: TDataSet read FDataSet write SetDataSet;
  end;

  TdsdDataSets = class (TOwnedCollection)
  private
    function GetItem(Index: Integer): TdsdDataSetLink;
    procedure SetItem(Index: Integer; const Value: TdsdDataSetLink);
  public
    function Add: TdsdDataSetLink;
    property Items[Index: Integer]: TdsdDataSetLink read GetItem write SetItem; default;
  end;

  TdsdStoredProc = class (TdsdComponent)
  private
    FDataSets: TdsdDataSets;
    FParams: TdsdParams;
    FStoredProcName: string;
    FOutputType: TOutputType;
    FPackSize: integer;
    FCurrentPackSize: integer;
    FDataXML: string;
    FAutoWidth: boolean;
    FNeedResetData: Boolean;
    FParamKeyField: String;
    FAfterExecute: TNotifyEvent;
    // Возвращает XML строку заполненных параметров
    function FillParams: String;
    procedure FillOutputParams(XML: String);
    function GetDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet);
    procedure DataSetRefresh;
    procedure MultiDataSetRefresh;
    procedure SetStoredProcName(const Value: String);
    function GetDataSetType: string;
    property CurrentPackSize: integer read FCurrentPackSize write FCurrentPackSize;
    procedure MultiExecute(ExecPack, AnyExecPack: boolean); //***12.07.2016 add AnyExecPack
    procedure ResetData;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Execute(ExecPack: boolean = false; AnyExecPack: boolean = false; ACursorHourGlass: Boolean = True): string; virtual;
    function ParamByName(const Value: string): TdsdParam;
    // XML для вызова на сервере
    function GetXML: String;
    //procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // Название процедуры на сервере
    property StoredProcName: String read FStoredProcName write SetStoredProcName;
    // ДатаСет с данными. Введен для удобства, так как зачастую DataSet = DataSets[0]
    property DataSet: TDataSet read GetDataSet write SetDataSet;
    // Обновляемые ДатаСеты
    property DataSets: TdsdDataSets read FDataSets write FDataSets;
    // тип возврата значений
    property OutputType: TOutputType read FOutputType write FOutputType default otDataSet;
    // Параметры процедуры
    property Params: TdsdParams read FParams write FParams;
    // Количество записей в пакете для вызова
    property PackSize: integer read FPackSize write FPackSize;
    // автоматический расчет ширины колонок
    property AutoWidth: boolean read FAutoWidth write FAutoWidth default false;
    // посылать команду перечитывания формам после экзекюта
    property NeedResetData: Boolean read FNeedResetData write FNeedResetData Default False;
    //Имя параметра, в котором ИД записи (нужно для перечитывания форм)
    property ParamKeyField: String read FParamKeyField write FParamKeyField;
    //процедура, которая вызовется после экзекюта
    property AfterExecute: TNotifyEvent read FAfterExecute write FAfterExecute;
  end;


  TSQLStrings = class(TCollectionItem)
  private
    FStrings: TStrings;
    procedure SetStrings(const Value: TStrings);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
  published
    property SQL: TStrings read FStrings write SetStrings;
  end;

  TSQLList = class(TOwnedCollection);

  TdsdStoredProcSQLite = class (TdsdStoredProc)
  private
    FSQLList: TSQLList;
    procedure DataSetSQLiteRefresh;
    procedure MultiDataSetSQLiteRefresh;
    procedure FillOutputParamsSQLite;
    function GetFieldSQLite : String;
  protected
  public
    function Execute(ExecPack: boolean = false; AnyExecPack: boolean = false; ACursorHourGlass: Boolean = True): string; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // Название процедуры на сервере
    property StoredProcName;
    // ДатаСет с данными. Введен для удобства, так как зачастую DataSet = DataSets[0]
    property DataSet;
    // Обновляемые ДатаСеты
    property DataSets;
    // тип возврата значений
    property OutputType;
    // Параметры процедуры
    property Params;
    // Количество записей в пакете для вызова
    property PackSize;
    // автоматический расчет ширины колонок
    property AutoWidth;
    // посылать команду перечитывания формам после экзекюта
    property NeedResetData;
    //Имя параметра, в котором ИД записи (нужно для перечитывания форм)
    property ParamKeyField;
    //процедура, которая вызовется после экзекюта
    property AfterExecute;
    //SQL при получении данных из SQLite
    property SQLList: TSQLList read FSQLList write FSQLList;
  end;

  procedure Register;


implementation

uses Storage, CommonData, TypInfo, UtilConvert, System.SysUtils, cxTextEdit, VCL.Forms,
     XMLDoc, XMLIntf, StrUtils, cxCurrencyEdit, dsdGuides, cxCheckBox, cxCalendar,
     Variants, UITypes, dsdAction, Defaults, UtilConst, Windows, Dialogs,
     dsdAddOn, cxDBData, cxGridDBTableView, Authentication, Document,
     cxButtonEdit, EDI, ExternalSave, Medoc, UnilWin, FormStorage, cxDateNavigator,
     cxMemo, cxImage, cxDropDownEdit, cxMaskEdit, dsdInternetAction, ParentForm,
     Vcl.ActnList, System.Rtti, Log, StorageSQLite, cxDBEdit;

procedure Register;
begin
   RegisterComponents('DSDComponent', [TdsdFormParams]);
   RegisterComponents('DSDComponent', [TdsdStoredProc]);
   RegisterComponents('DSDComponent', [TdsdStoredProcSQLite]);
end;


{ TdsdDataSets }

function TdsdDataSets.Add: TdsdDataSetLink;
begin
  result := TdsdDataSetLink(inherited Add);
end;

function TdsdDataSets.GetItem(Index: Integer): TdsdDataSetLink;
begin
  Result := TdsdDataSetLink(inherited GetItem(Index));
end;

procedure TdsdDataSets.SetItem(Index: Integer; const Value: TdsdDataSetLink);
begin
  inherited SetItem(Index, Value);
end;

{ TdsdDataSetWrapper }

constructor TdsdStoredProc.Create(AOwner: TComponent);
begin
  inherited;
  FDataSets := TdsdDataSets.Create(Self, TdsdDataSetLink);
  FParams := TdsdParams.Create(Self, TdsdParam);
  OutputType := otDataSet;
  CurrentPackSize := 0;
  PackSize := 1;
  FDataXML := '';
  FAutoWidth := false;
  FNeedResetData := False;
  FParamKeyField := '';
end;

procedure TdsdStoredProc.DataSetRefresh;
var B: TBookMark;
    FStringStream: TStringStream;
begin
  if (DataSets.Count > 0) and
      Assigned(DataSets[0]) and
      Assigned(DataSets[0].DataSet) then
   begin
     if DataSets[0].DataSet.State in dsEditModes then begin
        DataSets[0].DataSet.Post;
     end;
     if DataSets[0].DataSet.Active and (DataSets[0].DataSet.RecordCount > 0) then
        B := DataSets[0].DataSet.GetBookmark;
     if DataSets[0].DataSet is TClientDataSet then begin
        FStringStream := GetStringStream(String(TStorageFactory.GetStorage.ExecuteProc(GetXML)));
        try
          TClientDataSet(DataSets[0].DataSet).LoadFromStream(FStringStream);
        finally
          FreeAndNil(FStringStream);
        end;
     end;
     if Assigned(B) then
     begin
        try
          if DataSets[0].DataSet.BookmarkValid(B) then
            DataSets[0].DataSet.GotoBookmark(B);
        except
        end;
        DataSets[0].DataSet.FreeBookmark(B);
     end;
   end;
end;

destructor TdsdStoredProc.Destroy;
begin
  FreeAndNil(FDataSets);
  FreeAndNil(FParams);
  inherited;
end;

function TdsdStoredProc.Execute(ExecPack: boolean = false; AnyExecPack: boolean = false; ACursorHourGlass: Boolean = True): string;
var TickCount: cardinal;
begin
  result := '';
  TickCount := 0;
  if gc_isShowTimeMode then
     TickCount := GetTickCount;
  if ACursorHourGlass then
    Screen.Cursor := crHourGlass;
  try
    if (OutputType = otDataSet) then DataSetRefresh;
    if (OutputType = otMultiDataSet) then MultiDataSetRefresh;
    if (OutputType = otResult) then
       FillOutputParams(TStorageFactory.GetStorage.ExecuteProc(GetXML));
    if (OutputType = otBlob) then
        result := TStorageFactory.GetStorage.ExecuteProc(GetXML);
    if (OutputType = otMultiExecute) then
        MultiExecute(ExecPack, AnyExecPack); //***12.07.2016 add AnyExecPack
  finally
    if ACursorHourGlass then
      Screen.Cursor := crDefault;
  end;
  if gc_isShowTimeMode then
     ShowMessage('Время выполнения ' + StoredProcName + ' - ' + FloatToStr((GetTickCount - TickCount)/1000) + ' сек ' ); ;
  if NeedResetData then
    ResetData;
  if assigned(AfterExecute) then
    AfterExecute(self);
end;

procedure TdsdStoredProc.FillOutputParams(XML: String);
var
  XMLDocument: IXMLDocument;
  i: integer;
begin
  XMLDocument := TXMLDocument.Create(nil);
  XMLDocument.LoadFromXML(XML);
  if XMLDocument.DocumentElement = Nil then
    raise Exception.Create ('Ошибка обработки данных полученных с сервера...');

  for I := 0 to Params.Count - 1 do
      if (Params[i].ParamType in [ptOutput, ptInputOutput])//and(Params[i].Name<>'')
      then
         if XMLDocument.DocumentElement.HasAttribute(LowerCase(Params[i].Name)) then
            // XMLDocument режет перевод строки!!! приходится делать так
            Params[i].Value := XMLDocument.DocumentElement.Attributes[LowerCase(Params[i].Name)];
end;

function TdsdStoredProc.FillParams: String;
var
  i: integer;
  ParamStr: string;
begin
  Result := '';
  for I := 0 to Params.Count - 1 do
      with Params[i] do
        if ParamType in [ptInput, ptInputOutput] then begin
           ParamStr := asString;
           if DataType = ftWideString then
              Result := Result + '<' + Name +
                   '  DataType="ftBlob" '+
                   '  Value="' + gfStrToXmlStr(ParamStr) + '" />'
           else
             if DataType = ftBlob then
                Result := Result + '<' + Name +
                     '  DataType="' + GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" '+
                     '  Value="' + ParamStr + '" />'
           else
             if (DataType = ftDateTime) and (ParamStr <> 'NULL') then
                try   Result := Result + '<' + Name +
                           '  DataType="' + GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" '+
                           '  Value="' + DateTimeToStr(StrToDateTime(ParamStr)) + '" />';
                except
                      Result := Result + '<' + Name +
                           '  DataType="' + GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" '+
                           '  Value="' + gfStrToXmlStr(ParamStr) + '" />';
                end
             else
                Result := Result + '<' + Name +
                     '  DataType="' + GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" '+
                     '  Value="' + gfStrToXmlStr(ParamStr) + '" />';
        end;
end;

function TdsdStoredProc.GetDataSet: TDataSet;
begin
  if DataSets.Count > 0 then
     result := DataSets[0].DataSet
  else
     result := nil
end;

function TdsdStoredProc.GetDataSetType: string;
begin
  if (DataSets.Count > 0) and
      Assigned(DataSets[0]) and
      Assigned(DataSets[0].DataSet) then
        result := DataSets[0].DataSet.ClassName
      else
        result := ''
end;

procedure TdsdStoredProc.SetDataSet(const Value: TDataSet);
begin
  // Если устанавливается или
  if Value <> nil then begin
     if DataSets.Count > 0 then
        DataSets[0].DataSet := Value
     else
        DataSets.Add.DataSet := Value;
  end
  else begin
    //если ставится в NIL
    if DataSets.Count > 0 then
       DataSets.Delete(0);
  end;
end;


procedure TdsdStoredProc.SetStoredProcName(const Value: String);
  function PostgresDataTypeToDelphiDataType(PostgresType: string): TFieldType;
  begin
    result := ftUnknown;
    if PostgresType = 'tdatetime' then
       result := ftDateTime;
    if PostgresType = 'int4' then
       result := ftInteger;
    if PostgresType = 'tvarchar' then
       result := ftString;
    if PostgresType = 'tblob' then
       result := ftBlob;
    if PostgresType = 'tfloat' then
       result := ftFloat;
    if PostgresType = 'boolean' then
       result := ftBoolean;
  end;
  function PostgresParamTypeToDelphiParamType(PostgresType: string): TParamType;
  begin
    result := ptUnknown;
    if PostgresType = 'IN' then
       result := ptInput;
    if PostgresType = 'OUT' then
       result := ptOutput;
    if PostgresType = 'INOUT' then
       result := ptInputOutput;
  end;
var lDataSet: TClientDataSet;
const
   pXML =
  '<xml Session = "">' +
    '<lfGetParams OutputType="otDataSet">' +
       '<inStoredProcName DataType="ftString" Value="%s"/>' +
    '</lfGetParams>' +
  '</xml>';
begin
  if not (csReading in ComponentState) and (csDesigning in ComponentState) then
  begin
     if Value <> FStoredProcName then
     begin
       FStoredProcName := Value;
       if ShiftDown then begin
         Params.Clear;
         lDataSet := TClientDataSet.Create(nil);
         try
           try
             lDataSet.XMLData := TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [FStoredProcName]));
           except
           //  on E: Exception do
           //  ShowMessage(E.Message);
           end;
           if lDataSet.Active then begin
             while not lDataSet.Eof do begin
               // Добавляем OUT параметры только если тип otResult
               // и это не сессия
               if (lDataSet.FieldByName('Name').AsString <> 'insession')
                  and ((OutputType = otResult) or (PostgresParamTypeToDelphiParamType(lDataSet.FieldByName('Mode').AsString) <> ptOutput)) then
                  Params.AddParam(lDataSet.FieldByName('Name').AsString,
                                  PostgresDataTypeToDelphiDataType(lDataSet.FieldByName('TypeName').AsString),
                                  PostgresParamTypeToDelphiParamType(lDataSet.FieldByName('Mode').AsString), null);
               lDataSet.Next;
             end;
           end;
         finally
           lDataSet.Free;
         end;
       end;
     end
  end
  else
    FStoredProcName := Value;
end;

function TdsdStoredProc.GetXML: String;
var
  Session: string;
begin
  Session := '';
  if not (csDesigning in ComponentState) then
     if Assigned(gc_User) then
        Session := gc_User.Session
     else
        raise Exception.Create('Пользователь не установлен');
  if trim(StoredProcName) = '' then
     raise Exception.Create('Не указано название процедуры в объекте ' + Name);
  if FDataXML <> '' then
     FDataXML := '<data>' + FDataXML + '</data>';
  Result :=
           '<xml Session = "' + Session + '" AutoWidth = "' + BoolToStr(AutoWidth) + '" >' +
                '<' + StoredProcName + ' OutputType = "' + GetEnumName(TypeInfo(TOutputType), ord(OutputType)) + '" DataSetType = "' + GetDataSetType + '" >' +
                   FillParams +
                '</' + StoredProcName + '>' +
                FDataXML +
           '</xml>';
end;

procedure TdsdStoredProc.MultiDataSetRefresh;
var B: TBookMark;
    i: integer;
    XMLResult: OleVariant;
    FStringStream: TStringStream;
begin
   for I := 0 to DataSets.Count - 1 do
       if DataSets[i].DataSet.State in [dsEdit, dsInsert] then
          DataSets[i].DataSet.Post;
  XMLResult := TStorageFactory.GetStorage.ExecuteProc(GetXML);
  for I := 0 to DataSets.Count - 1 do begin
     if DataSets[i].DataSet.Active then
        B := DataSets[i].DataSet.GetBookmark;
      if DataSets[i].DataSet is TClientDataSet then begin
//          TClientDataSet(DataSets[i].DataSet).XMLData := XMLResult[i];
//           if (dsdProject = prBoat) and SameText(Copy(XMLResult[i], 1, 19), '<?xml version="1.0"') then
//             FStringStream := TStringStream.Create(String(XMLResult[i]), TEncoding.UTF8)
//           else
           FStringStream := TStringStream.Create(String(XMLResult[i]));
         XMLResult[i] := '';
         try
            TClientDataSet(DataSets[i].DataSet).LoadFromStream(FStringStream);
         finally
           FreeAndNil(FStringStream);
         end;
      end;
     if Assigned(B) then
     begin
        try
         if DataSets[i].DataSet.BookmarkValid(B) then
          DataSets[i].DataSet.GotoBookmark(B);
        except
        end;
        DataSets[0].DataSet.FreeBookmark(B);
     end;
  end;
end;

procedure TdsdStoredProc.MultiExecute(ExecPack, AnyExecPack: boolean);
begin
  // Заполняем значение Data + 12.07.2016 а если AnyExecPack - то Всегда
  if (not ExecPack) or (AnyExecPack = true) then
     FDataXML := FDataXML + '<dataitem>' + FillParams + '</dataitem>';
  // Увеличиваем счетчик
  CurrentPackSize := CurrentPackSize + 1;
  //
  // Выполняем, ИЛИ всегда при логировании
  if (CurrentPackSize = PackSize) or ExecPack {or Logger.Enabled} then begin
     CurrentPackSize := 0;
     try
       TStorageFactory.GetStorage.ExecuteProc(GetXML);
     finally
       FDataXML := '';
     end;
  end;
end;

procedure TdsdStoredProc.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
  if (Operation = opRemove) then begin
       if Assigned(Params) then begin
          for i := 0 to Params.Count - 1 do
             if Params[i].Component = AComponent then
                Params[i].Component := nil;
       end;
       if (AComponent is TDataSet) and Assigned(DataSets) then
          for i := 0 to DataSets.Count - 1 do
              if DataSets[i].DataSet = AComponent then
                 DataSets[i].DataSet := nil;
       if AComponent = DataSet then
          DataSet := nil;
  end;
end;

function TdsdStoredProc.ParamByName(const Value: string): TdsdParam;
begin
  result := FParams.ParamByName(Value);
  if not Assigned(Result) then
     raise Exception.Create('Параметр ' + Value + ' не найден в компоненте ' + Self.Name);
end;

procedure TdsdStoredProc.ResetData;
var
  I: Integer;
begin
  for I := 0 to Application.ComponentCount - 1 do
  Begin
    if (Application.Components[I] is TParentForm) AND
       (Self.Owner is TParentForm) AND
       (Application.Components[I] <> Self.Owner) AND
       (ParamKeyField <> '') AND
       (Params.ParamByName(ParamKeyField) <> nil) then
    Begin
      if TParentForm(Application.Components[I]).AddOnFormData.AddOnFormRefresh.SelfList =
         TParentForm(Self.Owner).AddOnFormData.AddOnFormRefresh.ParentList then
      Begin
        with TParentForm(Application.Components[I]).AddOnFormData.AddOnFormRefresh do
        Begin
          NeedRefresh := True;
          RefreshID := Self.ParamByName(ParamKeyField).Value;
        End;
      End;
    End;
  End;
end;

{ TdsdParmas }

function TdsdParams.Add: TdsdParam;
begin
  result := TdsdParam(inherited Add);
end;

function TdsdParams.AddParam(AName: string; ADataType: TFieldType;
  AParamType: TParamType; AValue: Variant): TdsdParam;
begin
  result := Add;
  with result do begin
    Name := AName;
    DataType := ADataType;
    ParamType := AParamType;
    Value := AValue;
  end;
end;

procedure TdsdParams.AssignParams(Source: TdsdParams);
var i: integer;
begin
  if Assigned(Source) then
    // не удаляем, а добавляем параметры
    for I := 0 to Source.Count - 1 do
        if ParamByName(Source[i].Name) = nil then begin
           Add.AssignParam(Source[i])
        end
        else begin
           try ParamByName(Source[i].Name).isValueChange:= ParamByName(Source[i].Name).Value <> Source[i].Value;
           except ParamByName(Source[i].Name).isValueChange:= true;
           end;
           ParamByName(Source[i].Name).Value := Source[i].Value
        end;
end;

function TdsdParams.GetItem(Index: Integer): TdsdParam;
begin
  Result := TdsdParam(inherited GetItem(Index));
end;

function TdsdParams.ParamByName(const Value: string): TdsdParam;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := TdsdParam(inherited Items[I]);
    if AnsiCompareText(Result.Name, Value) = 0 then Exit;
  end;
  Result := nil;
end;

procedure TdsdParams.SetItem(Index: Integer; const Value: TdsdParam);
begin
  inherited SetItem(Index, Value);
end;

{ TdsdParam }

function TdsdParam.AsFloat: double;
var Flo : Extended;
begin
  if TryStrToFloat(VarToStr(Value), Flo) then Result := Flo
  else Result := 0;
end;

function TdsdParam.AsInteger: Integer;
var Int: Integer;
begin
  if TryStrToInt(VarToStr(Value), Int) then Result := Int
  else Result := 0;
end;

procedure TdsdParam.Assign(Source: TPersistent);
var Owner: TComponent;
begin
  if Source is TdsdParam then begin
     AssignParam(TdsdParam(Source));
     Owner := TComponent(GetOwner);
     Component := nil;
     // доставляем еще свойств
     if Assigned(TdsdParam(Source).Component) and Assigned(Owner) then
        Component := Owner.FindComponent(TdsdParam(Source).Component.Name);
     ComponentItem := TdsdParam(Source).ComponentItem;
  end
  else
    inherited Assign(Source);
end;

procedure TdsdParam.AssignParam(Param: TdsdParam);
begin
  if Param <> nil then
  begin
    Value := Param.Value;
    Name := Param.Name;
    ParamType := Param.ParamType;
    DataType := Param.DataType;
  end;
end;

function TdsdParam.AsString: string;
var i: Integer;
    Data: Variant;
begin
  Data := Value;
  if VarisNull(Data) then
    case DataType of
      ftDate, ftTime, ftDateTime: Data := StringReplace('01-01-1900', '-', FormatSettings.DateSeparator, [rfReplaceAll])
      else  Data := '';
    end;
  if varType(Data) in [varSingle, varDouble, varCurrency] then
     result := gfFloatToStr(Data)
  else begin
     if (varType(Data) = varString) and (Data = #0) then
        // При пустой строку result = #0
        result := ''
     else
        result := Data;
  end;
  case DataType of
    ftSmallint, ftInteger, ftWord:
           if not TryStrToInt(result, i)
           then
             result := '0';
 {   ftFloat: ;
    ftCurrency: ;
    ftBCD: ;
    ftDate: ;
    ftTime: ;
    ftDateTime: ;
    ftBytes: ;
    ftVarBytes: ;
    ftAutoInc: ;
    ftBlob: ;
    ftMemo: ;
    ftGraphic: ;
    ftFmtMemo: ;
    ftParadoxOle: ;
    ftDBaseOle: ;
    ftTypedBinary: ;
    ftCursor: ;
    ftFixedChar: ;
    ftWideString: ;
    ftLargeint: ;
    ftADT: ;
    ftArray: ;
    ftReference: ;
    ftDataSet: ;
    ftOraBlob: ;
    ftOraClob: ;
    ftVariant: ;
    ftInterface: ;
    ftIDispatch: ;
    ftGuid: ;
    ftTimeStamp: ;
    ftFMTBcd: ;
    ftFixedWideChar: ;
    ftWideMemo: ;
    ftOraTimeStamp: ;
    ftOraInterval: ;
    ftLongWord: ;
    ftShortint: ;
    ftByte: ;
    ftExtended: ;
    ftConnection: ;
    ftParams: ;
    ftStream: ;
    ftTimeStampOffset: ;
    ftObject: ;
    ftSingle: ;}
  end;
end;

constructor TdsdParam.Create;
begin
  inherited Create(nil);
  FValue := Null;
  FParamType := ptOutput;
  FDataType := ftInteger;
  FMultiSelectSeparator := ',';
  FValueChange:= false; // add 22.01.2018
end;

constructor TdsdParam.Create(Collection: TCollection);
begin
  inherited;
  FValue := Null;
  FParamType := ptOutput;
  FDataType := ftInteger;
  FMultiSelectSeparator := ',';
  FValueChange:= false; // add 22.01.2018
end;

function TdsdParam.GetDisplayName: string;
begin
  result := Name
end;

function TdsdParam.GetFromCrossDBViewAddOn: Variant;
var CrossDBViewAddOn: TCrossDBViewAddOn;
begin
  CrossDBViewAddOn := TCrossDBViewAddOn(Component);
  // Ничего лучшего не нашел пока. Если ячейка грида находится в редиме редактирования
  // и выполняется Post, то вот тут данных в датасете еще нифига нет!
  // Поэтому надо дернуть грид и уговорить его поставить
  CrossDBViewAddOn.View.DataController.UpdateData;
  if CrossDBViewAddOn.HeaderDataSet.Active then
     result := GetFromDataSet(CrossDBViewAddOn.DataSet, ComponentItem + IntToStr(CrossDBViewAddOn.HeaderDataSet.RecNo));
end;

function TdsdParam.GetFromDataSet(const DataSet: TDataSet; const FieldName: string): Variant;
begin
  if DataSet.Active then begin
    if FieldName = '' then
       raise Exception.Create('Параметр ' + Name + '. не установлено ComponentItem');
    Result := DataSet.FieldByName(FieldName).Value;
    if VarIsNull(Result) then
    case DataType of
      ftString: Result := '';
      ftInteger: Result := 0;
      ftBoolean: Result := false;
      ftFloat: Result := 0;
      ftDateTime: Result := 'NULL';
    end;
  end;
end;

function TdsdParam.GetOwner: TPersistent;
var Owner: TComponent;
begin
  if Assigned(Collection) then
     Owner := TComponent(Collection.Owner)
  else
     Owner := nil;
  while (Owner <> nil) do
     if Owner is TCustomForm then
        break
     else
        Owner := Owner.Owner;
  result := Owner;
end;

function TdsdParam.GetValue: Variant;
// Если указан Component, то параметры берутся из него
// иначе из значения Value
var
  i: Integer;
  IDs: String;
  Clmn: TcxGridDBColumn;
  Bol : Boolean;
  Flo : Extended;
  DT : TDateTime;
begin
  if Assigned(FComponent) and (not Assigned(FComponent.Owner)
       or (Assigned(FComponent.Owner) and (not (csWriting in (FComponent.Owner).ComponentState)))) then begin
     // В зависимости от типа компонента Value содержится в разных property
     if Component is TCrossDBViewAddOn then
        result := GetFromCrossDBViewAddOn;
     if Component is TPivotAddOn then
        result := (Component as TPivotAddOn).GetCurrentData;
     if Component is TcxTextEdit then
        Result := (Component as TcxTextEdit).Text;
     if Component is TcxDBTextEdit then
        Result := (Component as TcxDBTextEdit).Text;
     if Component is TcxMemo then
        Result := (Component as TcxMemo).Text;
     if Component is TcxMaskEdit then
        Result := (Component as TcxMaskEdit).Text;
     if Component is TcxButtonEdit then
        Result := (Component as TcxButtonEdit).Text;
     if (Component is TDataSet) then
        Result := GetFromDataSet(TDataSet(Component), ComponentItem);
     if Component is TcxComboBox then
        Result := (Component as TcxComboBox).Text;
     if Component is TcxDateNavigator then
        Result := (Component as TcxDateNavigator).Date;
     if (Component is TdsdFormParams) then
        if Assigned((Component as TdsdFormParams).ParamByName(ComponentItem)) then
           Result := (Component as TdsdFormParams).ParamByName(ComponentItem).Value
        else
          case DataType of
            ftInteger: Result := '0';
          end;
     if Component is TcxCurrencyEdit then begin
        with (Component as TcxCurrencyEdit) do
          if Parent.ClassName = 'TPlaceForm' then begin // Если стоим в тулбаре, то приходится брать из текста
             Result := StrToFloatDef(EditingText, 0)
          end
          else
            Result := (Component as TcxCurrencyEdit).Value;
     end;
     if Component is TCustomGuides then begin
        if LowerCase(ComponentItem) = 'textvalue'  then
           Result := (Component as TCustomGuides).TextValue
        else
           Result := (Component as TCustomGuides).Key;
     end;
     if Component is TCheckListBoxAddOn then begin
        Result := (Component as TCheckListBoxAddOn).KeyList;
     end;
     if Component is TcxCheckBox then
        Result := BoolToStr((Component as TcxCheckBox).Checked, true);
     if Component is TcxDateEdit then begin
        if (Component as TcxDateEdit).Date = -700000 then
           (Component as TcxDateEdit).Date := Date;
        Result := (Component as TcxDateEdit).CurrentDate;
     end;
     if Component is TBooleanStoredProcAction then
        Result := (Component as TBooleanStoredProcAction).Value;
     if (Component is TAction) and (Component.ClassName = 'TAction') then
        Result := (Component as TAction).Checked;
     if Component is TEDI then
        result := (Component as TEDI).Directory;
     if Component is TDocument then begin
        if LowerCase(ComponentItem) = 'name' then
           result := TDocument(Component).GetName
        else if LowerCase(ComponentItem) = 'filename' then
           result := TDocument(Component).FileName
        else if LowerCase(ComponentItem) = 'extractfilename' then
           result := TDocument(Component).GetExtractFileName
        else
           result := TDocument(Component).GetData;
     end;
     if Component is TDefaultKey then begin
        if LowerCase(ComponentItem) = 'key' then
           result := TDefaultKey(Component).Key
        else
           result := TDefaultKey(Component).JSONKey;
     end;
     if Component is TcxGridDBTableView then
     Begin
       IDs := '';
       clmn := nil;
       if (Component.Owner.FindComponent(ComponentItem) <> nil) AND
          (Component.Owner.FindComponent(ComponentItem) is TcxGridDBColumn) then
         clmn := TcxGridDBColumn(Component.Owner.FindComponent(ComponentItem));
       if Clmn <> nil then
       Begin
         with TcxGridDBTableView(Component) do
         Begin
           for i := 0 to Controller.SelectedRecordCount - 1 do
           Begin
             if IDs <> '' then
               IDs := IDs + FMultiSelectSeparator;
             IDs := IDs + VarToStr(Controller.SelectedRecords[I].Values[Clmn.Index]);
           End;
         End;
       end;
       Result := IDs;
     End;
     if Component is TdsdPropertiesСhange then
        result := (Component as TdsdPropertiesСhange).IndexProperties;
     if Component is TdsdContinueAction then
        Result := (Component as TdsdContinueAction).Continue.Value;
  end
  else
  Begin
    try
//      if VarIsNull(FValue) AND (DataType = ftDateTime) then
//        Result := 'NULL'
//      else
//
      if not VarIsNull(FValue) AND (DataType = ftDateTime) then
      begin
        if (VarToStr(FValue) = 'NULL') OR (VarToStr(FValue) = '') OR (VarToStr(FValue) = '0') then Result := NULL
        else if VarToStr(FValue) = '-700000' then Result := Date
        else if TryStrToDateTime(VarToStr(FValue), DT) then Result := FValue
        else Result := gfXSStrToDate(FValue)
      end
      else
      if not VarIsNull(FValue) AND (DataType = ftBoolean) then
      begin
        if TryStrToBool(VarToStr(FValue), Bol) then Result := Bol
        else Result := FValue;
      end
      else
      if not VarIsNull(FValue) AND (DataType = ftFloat) then
      begin
        if TryStrToFloat(ReplaceStr(ReplaceStr(VarToStr(FValue), '.', FormatSettings.DecimalSeparator), ',', FormatSettings.DecimalSeparator), Flo) then Result := Flo
        else Result := FValue;
      end
      else
        Result := FValue
    except
      Result := FValue
    end;
  End;
end;

procedure TdsdParam.SetComponent(const Value: TComponent);
begin
  if Value <> FComponent then begin
     if FComponent <> nil then
        ComponentItem := '';
     if Assigned(Collection) and Assigned(Value) then
        Value.FreeNotification(TComponent(Collection.Owner));
     FComponent := Value;
  end
end;

procedure TdsdParam.SetInCrossDBViewAddOn(const Value: Variant);
var CrossDBViewAddOn: TCrossDBViewAddOn;
begin
  CrossDBViewAddOn := TCrossDBViewAddOn(Component);
  if CrossDBViewAddOn.HeaderDataSet.Active then
     SetInDataSet(CrossDBViewAddOn.DataSet, ComponentItem + IntToStr(CrossDBViewAddOn.HeaderDataSet.RecNo), Value);
end;

procedure TdsdParam.SetInDataSet(const DataSet: TDataSet; const FieldName: string; const Value: Variant);
var Field: TField;
    Bol : Boolean;
    DT : TDateTime;
begin
  if DataSet.Active then begin
    if not (DataSet.State in [dsEdit, dsInsert]) then
       DataSet.Edit;
    Field := DataSet.FieldByName(FieldName);
    if Assigned(Field) then begin
         // в случае дробного числа и если строка, то надо конвертить
         if (Field.DataType in [ftFloat, ftInteger]) and (VarType(FValue) in [vtString, vtClass]) then begin
             if VarToStr(FValue) = '' then
                Field.Value := null
             else
                Field.Value := gfStrToFloat(FValue)
         end
         else
           // в случае даты и если строка, то надо конвертить
           if (Field.DataType in [ftDateTime, ftDate, ftTime]) and (VarType(FValue) in [vtString, vtClass]) then begin
              if VarToStr(FValue) = '' then
                Field.Value := null
              else if TryStrToDateTime(VarToStr(FValue), DT) then
                Field.Value := FValue
              else
                Field.Value := gfXSStrToDate(FValue); // convert to TDateTime
           end
           // в случае логического и если строка, то надо конвертить
           else
           if (Field.DataType in [ftBoolean]) and (VarType(FValue) in [vtString, vtClass]) then begin
              if VarToStr(FValue) = '' then
                Field.Value := null
              else
                if TryStrToBool(FValue, Bol) then
                  Field.Value := Bol
                else
                  Field.Value := False;
           end
           else
              Field.Value := FValue;
    end
    else
      raise Exception.Create('У дата сета "' + Component.Name + '" нет поля "' + FieldName + '"');
  end;
end;

procedure TdsdParam.SetValue(const Value: Variant);
var
  FRttiContext: TRttiContext;
  FRttiProperty: TRttiProperty;
  RttiValue : TValue;
  PhotoGUID: TGUID;
  PhotoName: string;
  E : TcxExport;
  I : integer;
  DT : TDateTime;
  Flo : Extended;
begin
  FValue := Value;
  // передаем значение параметра дальше по цепочке
  if Assigned(FComponent) then begin
     if (Component is TCrossDBViewAddOn) then
        SetInCrossDBViewAddOn(FValue);
     if (Component is TDataSet) then
        SetInDataSet(TDataSet(Component), ComponentItem, FValue);
     if Component is TcxTextEdit then
        (Component as TcxTextEdit).Text := FValue;
     if Component is TcxDBTextEdit then
        (Component as TcxDBTextEdit).Text := FValue;
     if Component is TcxMemo then
        (Component as TcxMemo).Text := FValue;
     if Component is TcxMaskEdit then
        (Component as TcxMaskEdit).Text := FValue;
     if Component is TcxComboBox then
        (Component as TcxComboBox).Text := FValue;
     if Component is TcxDateNavigator then
        (Component as TcxDateNavigator).Date := FValue;
     if Component is TcxImage then
     begin
        CreateGUID(PhotoGUID);
        PhotoName := ExtractFilePath(ParamStr(0)) + GUIDToString(PhotoGUID) + '.jpeg';
        FileWriteString(PhotoName, ReConvertConvert(VarToStr(FValue)));
        (Component as TcxImage).Picture.LoadFromFile(PhotoName);
        System.SysUtils.DeleteFile(PhotoName);
     end;
     if Component is TcxButtonEdit then
        (Component as TcxButtonEdit).Text := FValue;
     if Component is TdsdFormParams then
        with (Component as TdsdFormParams) do begin
          if Assigned(ParamByName(FComponentItem)) then
             ParamByName(FComponentItem).Value := FValue
          else
             Params.AddParam(FComponentItem, ftString, ptInput, FValue);
        end;
     if Component is TcxCurrencyEdit_check then
     begin
        if TryStrToFloat(ReplaceStr(ReplaceStr(VarToStr(FValue), '.', FormatSettings.DecimalSeparator), ',', FormatSettings.DecimalSeparator), Flo) then
        begin
          if Round((Component as TcxCurrencyEdit_check).Value * 10000) <> Round(Flo * 10000) then (Component as TcxCurrencyEdit_check).Value := Flo;
        end
        else
          (Component as TcxCurrencyEdit_check).Clear;
     end else if Component is TcxCurrencyEdit then
     begin
        if TryStrToFloat(ReplaceStr(ReplaceStr(VarToStr(FValue), '.', FormatSettings.DecimalSeparator), ',', FormatSettings.DecimalSeparator), Flo) then
          (Component as TcxCurrencyEdit).Value := Flo
        else
          (Component as TcxCurrencyEdit).Clear;
     end;
     if Component is TcxCheckBox then
        (Component as TcxCheckBox).Checked := StrToBool(FValue);
     if Component is TcxDateEdit then
        if TryStrToDateTime(VarToStr(FValue), DT) then (Component as TcxDateEdit).Date := DT
        else
        begin
          if not VarIsNull(FValue) AND (VarToStr(FValue) <> '') AND (VarToStr(FValue) <> '0') AND (VarToStr(FValue) <> 'NULL') then
             (Component as TcxDateEdit).Date := gfXSStrToDate(FValue) // convert to TDateTime
          else
             (Component as TcxDateEdit).Clear;
        end;
     if Component is TEDI then
        (Component as TEDI).Directory := FValue;
     if (Component is TExportGrid)
        AND
        ((LowerCase(ComponentItem) = LowerCase('DefaultFileName'))
         or
         (LowerCase(ComponentItem) = LowerCase('ExportType'))
         or
         (LowerCase(ComponentItem) = LowerCase('DefaultFileExt'))
         or
         (LowerCase(ComponentItem) = LowerCase('EncodingANSI'))) then begin
        if LowerCase(ComponentItem) = LowerCase('DefaultFileName') then
           (Component as TExportGrid).DefaultFileName := FValue;
        if LowerCase(ComponentItem) = LowerCase('ExportType') then
           begin
             if not TryStrToInt(FValue, I) then
             begin
               for E := Low(TcxExport) to High(TcxExport) do
               if AnsiUpperCase(FValue) =  AnsiUpperCase(GetEnumName(TypeInfo(TcxExport), ord(E))) then
               begin
                 (Component as TExportGrid).ExportType := E;
                 Break;
               end;
             end else (Component as TExportGrid).ExportType := FValue;
           end;
        if LowerCase(ComponentItem) = LowerCase('DefaultFileExt') then 
           (Component as TExportGrid).DefaultFileExt := FValue;
        if LowerCase(ComponentItem) = LowerCase('EncodingANSI') then 
           (Component as TExportGrid).EncodingANSI := FValue
     end
     else
     if Component is TBooleanStoredProcAction then
        (Component as TBooleanStoredProcAction).Value := FValue
     else
     if (Component is TAction) and (Component.ClassName = 'TAction') then
        (Component as TAction).Checked := FValue
     else
     if (Component is TDocument) and (LowerCase(ComponentItem) = 'filename') then
        TDocument(Component).FileName := FValue
     else
     if (Component is TADOQueryAction)
        AND
        (
           (LowerCase(ComponentItem) = 'connectionstring')
           or
           (LowerCase(ComponentItem) = 'querytext')
        ) then begin
       if LowerCase(ComponentItem) = 'connectionstring' then begin
          (Component as TADOQueryAction).ConnectionString := FValue;
       end else
         if LowerCase(ComponentItem) = 'querytext' then
           (Component as TADOQueryAction).QueryText := FValue;
     end
     else
     if Component is TMedocAction then
        (Component as TMedocAction).Directory := FValue
     else
     if Component is TdsdSMTPFileAction then
       (Component as TdsdSMTPFileAction).FileName := FValue
     else
     if Component is TShowMessageAction then
       (Component as TShowMessageAction).MessageText := String(FValue)
     else
     if (Component is TCustomAction) AND (ComponentItem <> '') then
     Begin
       FRttiProperty := FRttiContext.GetType(Component.ClassType).GetProperty(ComponentItem);
       if FRttiProperty <> nil then
       Begin
         case FRttiProperty.PropertyType.TypeKind of
           tkInteger: RttiValue := StrToInt(VarToStr(FValue));
           tkFloat: RttiValue := StrToFloat(VarToStr(FValue));
           tkString: RttiValue := VarToStr(FValue);
           tkEnumeration: RttiValue := (FValue = True);
           else RttiValue := VarToStr(FValue);
         end;
         FRttiProperty.SetValue(Component,RttiValue);
       End;
     End;
     if Component is TCustomGuides then
        if LowerCase(ComponentItem) = 'textvalue' then begin
           if VarIsNull(FValue) then
              FValue := '';
           (Component as TCustomGuides).TextValue := FValue;
        end else if LowerCase(ComponentItem) = 'disableguidesopen' then
        begin
           if VarIsNull(FValue) then
              FValue := False;
           (Component as TCustomGuides).DisableGuidesOpen := FValue
        end
        else
          if LowerCase(ComponentItem) = 'parentid' then
             (Component as TCustomGuides).ParentId := FValue
          else begin
             if VarIsNull(FValue) then
                FValue := 0;
             (Component as TCustomGuides).Key := FValue;
          end;
     if Component is TCheckListBoxAddOn then
     begin
        if VarIsNull(FValue) then FValue := '';
        (Component as TCheckListBoxAddOn).KeyList := FValue;
     end;
     if Component is TdsdPropertiesСhange then
        (Component as TdsdPropertiesСhange).IndexProperties := FValue;
     if Component is TcxGridDBTableView then
     begin
       if UpperCase(Name) = UpperCase('GroupByBox') then
       begin
         TcxGridDBTableView(Component).OptionsView.GroupByBox := FValue;
         if not TcxGridDBTableView(Component).OptionsView.GroupByBox then
           TcxGridDBTableView(Component).DataController.Groups.ClearGrouping;
       end;
     end;
     if Component is TdsdContinueAction then
      (Component as TdsdContinueAction).Continue.Value := FValue;
  end;
  if Assigned(FonChange) then
     FonChange(Self);
end;

{ TdsdFormParams }

constructor TdsdFormParams.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(Self, TdsdParam);
end;

destructor TdsdFormParams.Destroy;
begin
  FreeAndNil(FParams);
  inherited;
end;

procedure TdsdFormParams.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
  if (Operation = opRemove) and Assigned(Params) then
     for I := 0 to Params.Count - 1 do
         if Params[i].Component = AComponent then
            Params[i].Component := nil;
end;

function TdsdFormParams.ParamByName(const Value: string): TdsdParam;
begin
  result := FParams.ParamByName(Value);
//  if not Assigned(result) then
//    raise Exception.Create('Параметр "' + Value + '" не найден.');
end;


procedure VerifyBoolStrArray;
begin
  if Length(TrueBoolStrs) = 0 then
  begin
    SetLength(TrueBoolStrs, 2);
    TrueBoolStrs[0] := DefaultTrueBoolStr;
    TrueBoolStrs[1] := 't';
  end;
  if Length(FalseBoolStrs) = 0 then
  begin
    SetLength(FalseBoolStrs, 2);
    FalseBoolStrs[0] := DefaultFalseBoolStr;
    FalseBoolStrs[1] := 'f';
  end;
end;

{ TdsdDataSetLink }

procedure TdsdDataSetLink.Assign(Source: TPersistent);
begin
  if Source is TdsdDataSetLink then
     Self.DataSet := TdsdDataSetLink(Source).DataSet
  else
    inherited; //raises an exception
end;

function TdsdDataSetLink.GetDisplayName: string;
begin
  if Assigned(FDataSet) then
     Result := FDataSet.Name
  else
     Result := inherited;
end;

procedure TdsdDataSetLink.SetDataSet(const Value: TDataSet);
begin
  if FDataSet <> Value then begin
     if Assigned(Collection) and Assigned(Value) then
        Value.FreeNotification(TComponent(Collection.Owner));
     FDataSet := Value;
  end;
end;

{ TSQLStrings }

constructor TSQLStrings.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FStrings := TStringList.Create;
end;

destructor TSQLStrings.Destroy;
begin
  FStrings.Free;
  inherited;
end;

procedure TSQLStrings.Assign(ASource: TPersistent);
begin
  if ASource is TSQLStrings then
    FStrings.Assign(TSQLStrings(ASource).SQL)
  else
    inherited;
end;

procedure TSQLStrings.SetStrings(const Value: TStrings);
begin
  FStrings.Assign(Value);
end;


{ TdsdStoredProcSQLite }

constructor TdsdStoredProcSQLite.Create(AOwner: TComponent);
begin
  inherited;
  FSQLList := TSQLList.Create(Self, TSQLStrings);
end;

destructor TdsdStoredProcSQLite.Destroy;
begin
  FSQLList.Free;
  inherited;
end;

procedure TdsdStoredProcSQLite.DataSetSQLiteRefresh;
var B: TBookMark;
begin
  if (DataSets.Count > 0) and
      Assigned(DataSets[0]) and
      Assigned(DataSets[0].DataSet) then
   begin
     if DataSets[0].DataSet.State in dsEditModes then begin
        DataSets[0].DataSet.Post;
     end;
     if DataSets[0].DataSet.Active and (DataSets[0].DataSet.RecordCount > 0) then
        B := DataSets[0].DataSet.GetBookmark;
     if DataSets[0].DataSet is TClientDataSet then
     begin
       if (SQLList.Count > 0) and Assigned(SQLList.Items[0]) and (TSQLStrings(SQLList.Items[0]).SQL.Text <> '') then
         LoadSQLiteSQL(TClientDataSet(DataSets[0].DataSet), TSQLStrings(SQLList.Items[0]).SQL.Text, Params)
       else ShowMessage('Не определен SQL для выполнения запроса.');
     end;
     if Assigned(B) then
     begin
        try
          if DataSets[0].DataSet.BookmarkValid(B) then
            DataSets[0].DataSet.GotoBookmark(B);
        except
        end;
        DataSets[0].DataSet.FreeBookmark(B);
     end;
   end;
end;

procedure TdsdStoredProcSQLite.MultiDataSetSQLiteRefresh;
var B: TBookMark;
    i: integer;
begin
  for I := 0 to DataSets.Count - 1 do
      if DataSets[i].DataSet.State in [dsEdit, dsInsert] then
         DataSets[i].DataSet.Post;

  for I := 0 to DataSets.Count - 1 do
  begin
      if DataSets[i].DataSet.Active then
        B := DataSets[i].DataSet.GetBookmark;
      if DataSets[i].DataSet is TClientDataSet then
      begin
        if (SQLList.Count > I) and Assigned(SQLList.Items[I]) and (TSQLStrings(SQLList.Items[I]).SQL.Text <> '') then
          LoadSQLiteSQL(TClientDataSet(DataSets[I].DataSet), TSQLStrings(SQLList.Items[I]).SQL.Text)
        else ShowMessage('Не определен SQL для выполнения запроса.');
      end;
      if Assigned(B) then
      begin
        try
          if DataSets[i].DataSet.BookmarkValid(B) then
            DataSets[i].DataSet.GotoBookmark(B);
        except
        end;
        DataSets[0].DataSet.FreeBookmark(B);
      end;
  end;
end;

procedure TdsdStoredProcSQLite.FillOutputParamsSQLite;
  var ClientDataSet: TClientDataSet;
      i: integer;
begin

  if (SQLList.Count = 0) or not Assigned(SQLList.Items[0]) or (TSQLStrings(SQLList.Items[0]).SQL.Text = '') then
  begin
    ShowMessage('Не определен SQL для выполнения запроса.');
    Exit;
  end;

  ClientDataSet := TClientDataSet.Create(Nil);
  try

    LoadSQLiteSQL(ClientDataSet, TSQLStrings(SQLList.Items[0]).SQL.Text, Params);

    for I := 0 to Params.Count - 1 do
      if (Params[i].ParamType in [ptOutput, ptInputOutput])
      then
         if Assigned(ClientDataSet.FindField(Params[i].Name)) then
            Params[i].Value := ClientDataSet.FieldByName(Params[i].Name).AsVariant;
  finally
    ClientDataSet.Free;
  end;
end;

function TdsdStoredProcSQLite.GetFieldSQLite : String;
  var ClientDataSet: TClientDataSet;
      i: integer;
begin

  if (SQLList.Count = 0) or not Assigned(SQLList.Items[0]) or (TSQLStrings(SQLList.Items[0]).SQL.Text = '') then
  begin
    ShowMessage('Не определен SQL для выполнения запроса.');
    Exit;
  end;

  ClientDataSet := TClientDataSet.Create(Nil);
  try

    LoadSQLiteSQL(ClientDataSet, TSQLStrings(SQLList.Items[0]).SQL.Text);

    Result := ClientDataSet.Fields.Fields[0].AsString;

  finally
    ClientDataSet.Free;
  end;
end;

function TdsdStoredProcSQLite.Execute(ExecPack: boolean = false; AnyExecPack: boolean = false; ACursorHourGlass: Boolean = True): string;
begin
  result := '';

  if (gc_User.Local = true) or (StoredProcName = '') then
  begin

    if ACursorHourGlass then
      Screen.Cursor := crHourGlass;
    try
      if (OutputType = otDataSet) then DataSetSQLiteRefresh;
      if (OutputType = otMultiDataSet) then MultiDataSetSQLiteRefresh;
      if (OutputType = otResult) then FillOutputParamsSQLite;
      if (OutputType = otBlob) then result := GetFieldSQLite;
    finally
      if ACursorHourGlass then
        Screen.Cursor := crDefault;
    end;
  end else result := inherited;

end;

initialization

  VerifyBoolStrArray;
  Classes.RegisterClass(TdsdDataSets);

end.
