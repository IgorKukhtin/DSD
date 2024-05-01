unit FMX.dsdDB;

interface

uses Classes, FMX.Types, DBClient, DB, FMX.dsdCommon, FMX.Dialogs;

type
  TOutputType = (otResult, otDataSet, otMultiDataSet, otBlob, otMultiExecute);

  TdsdParam = class(TCollectionItem)
  private
    FComponent: TComponent;
    FDataType: TFieldType;
    FValue: Variant;
    FOldValue: Variant;
    FName: String;
    FComponentItem: String;
    FParamType: TParamType;
    FonChange: TNotifyEvent;
    FMultiSelectSeparator: String;
    FIsFillOutParams: Boolean;
    function GetValue: Variant;
    procedure SetValue(const Value: Variant);
    procedure SetComponent(const Value: TComponent);
    //procedure SetInDataSet(const DataSet: TDataSet; const FieldName: string; const Value: Variant);
    //function GetFromDataSet(const DataSet: TDataSet; const FieldName: string): Variant;
    procedure SetIsFillOutParams(const Value: Boolean);
    function GetisChanged: boolean;
  protected
    function GetDisplayName: string; override;
    procedure AssignParam(Param: TdsdParam);
    function GetOwner: TPersistent; override;
  public
    property onChange: TNotifyEvent read FonChange write FonChange;
    function AsString: string;
    function AsStringDB: string;
    function AsFloat: double;
    procedure FixOldValue;
    procedure Assign(Source: TPersistent); override;
    constructor Create(Collection: TCollection); overload; override;
    constructor Create;  reintroduce; overload;
    property IsFillOutParams: Boolean read FIsFillOutParams write SetIsFillOutParams;
    property isChanged: boolean read GetisChanged;
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

  TdsdFormParams = class (TFmxObject)
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

  TdsdStoredProc = class (TFmxObject)
  private
    FDataSets: TdsdDataSets;
    FParams: TdsdParams;
    FStoredProcName: string;
    FOutputType: TOutputType;
    FPackSize: integer;
    FCurrentPackSize: integer;
    FDataXML: string;
    FAutoWidth: boolean;
    FParamKeyField: String;
    FAfterExecute: TNotifyEvent;
    FisFunction: Boolean;
    // Возвращает XML строку заполненных параметров
    function FillParams: String;
    procedure FillOutputParams(XML: String);
    function GetDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet);
    procedure DataSetRefresh(AMaxAtempt: Byte = 10);
    procedure MultiDataSetRefresh(AMaxAtempt: Byte = 10);
    procedure SetStoredProcName(const Value: String);
    function GetDataSetType: string;
    function getChanged: boolean;
    property CurrentPackSize: integer read FCurrentPackSize write FCurrentPackSize;
    procedure MultiExecute(ExecPack, AnyExecPack: boolean; AMaxAtempt: Byte = 10); //***12.07.2016 add AnyExecPack
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Execute(ExecPack: boolean = false; AnyExecPack: boolean = false; ACursorHourGlass: Boolean = True; AMaxAtempt: Byte = 10): string; //***12.07.2016 add AnyExecPack
    function ParamByName(const Value: string): TdsdParam;
    // XML для вызова на сервере
    function GetXML: String;
    //procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property isChanged: boolean read getChanged;
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
    //Имя параметра, в котором ИД записи (нужно для перечитывания форм)
    property ParamKeyField: String read FParamKeyField write FParamKeyField;
    //процедура, которая вызовется после экзекюта
    property AfterExecute: TNotifyEvent read FAfterExecute write FAfterExecute;
    // Function
    property isFunction: Boolean read FisFunction write FisFunction Default False;
  end;

  procedure Register;


implementation

uses FMX.Storage, TypInfo, FMX.UtilConvert, SysUtils,
     XMLDoc, XMLIntf, StrUtils, FMX.CommonData,
     Variants, UITypes, FMX.Defaults, FMX.UtilConst,
     System.Rtti, FMX.CursorUtils;

procedure Register;
begin
   RegisterComponents('DSDComponent', [TdsdFormParams]);
   RegisterComponents('DSDComponent', [TdsdStoredProc]);
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
  FParamKeyField := '';
  FisFunction := False;
end;

procedure TdsdStoredProc.DataSetRefresh(AMaxAtempt: Byte = 10);
var B: TBookMark;
    FBytesStream: TBytesStream;
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
         try
           FBytesStream := TBytesStream.Create(TStorageFactory.GetStorage.ExecuteProc(GetXML, False, AMaxAtempt));
           try
             TClientDataSet(DataSets[0].DataSet).LoadFromStream(FBytesStream);
           finally
             FreeAndNil(FBytesStream);
           end;
         except
           on E : Exception do
           begin
             raise Exception.Create(E.Message);
           end;
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

function TdsdStoredProc.Execute(ExecPack: boolean = false; AnyExecPack: boolean = false; ACursorHourGlass: Boolean = True; AMaxAtempt: Byte = 10): string;
begin
  result := '';
  if ACursorHourGlass then
    Screen_Cursor_crHourGlass;
  try
    if (OutputType = otDataSet) then DataSetRefresh(AMaxAtempt);
    if (OutputType = otMultiDataSet) then MultiDataSetRefresh(AMaxAtempt);
    if (OutputType = otResult) then
       FillOutputParams(TStorageFactory.GetStorage.ExecuteProc(GetXML, False, AMaxAtempt));
    if (OutputType = otBlob) then
        result := VarToStr(TStorageFactory.GetStorage.ExecuteProc(GetXML, False, AMaxAtempt));
    if (OutputType = otMultiExecute) then
        MultiExecute(ExecPack, AnyExecPack, AMaxAtempt); //***12.07.2016 add AnyExecPack
  finally
    if ACursorHourGlass then
      Screen_Cursor_crDefault;
  end;
  if assigned(AfterExecute) then
    AfterExecute(self);
end;

procedure TdsdStoredProc.FillOutputParams(XML: String);
var
  XMLDocument: IXMLDocument;
  i: integer;
  tmpStr: String;
begin
  XMLDocument := TXMLDocument.Create(nil);
  XMLDocument.LoadFromXML(XML);
  for I := 0 to Params.Count - 1 do
      if Params[i].ParamType in [ptOutput, ptInputOutput] then
      begin
         if XMLDocument.DocumentElement.HasAttribute(lowercase(Params[i].Name)) then
         begin
            // XMLDocument режет перевод строки!!! приходится делать так
            Params[i].IsFillOutParams := true;
            try
              if (Params[I].DataType = ftDate) or
                 (Params[I].DataType = ftDateTime) then
              begin
                tmpStr := varToStr(XMLDocument.DocumentElement.Attributes[lowercase(Params[i].Name)]);
                if (length(tmpStr) = length('НННН-MM-ВВThh:mm:ss')) and
                   (pos('T', tmpStr) = 11) then
                   tmpStr := StringReplace(tmpStr, 'T', ' ', []);
                try
                  Params[i].Value := VarToDateTime(tmpStr);
                except
                  Params[i].Value := tmpStr;
                end
              end
              else
                Params[i].Value := XMLDocument.DocumentElement.Attributes[lowercase(Params[i].Name)];
            finally
              Params[i].IsFillOutParams := false;
            end;
         end;
      end
      else
        Params[i].FixOldValue;
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
           ParamStr := asStringDB;
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
              Result := Result + '<' + Name +
                   '  DataType="' + GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" '+
                   '  Value="' + gfStrToXmlStr(ParamStr) + '" />';
        end;
end;

function TdsdStoredProc.getChanged: boolean;
var
  p: TdsdParam;
  i: integer;
begin
  for i:= 0 to params.Count - 1 do
  begin
    p:=params.Items[i];
    if p.isChanged then
      exit(true);
  end;
  result := false;
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
{$IFDEF MSWINDOWS}
var
  lDataSet: TClientDataSet;
{$ENDIF}
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
       {$IFDEF MSWINDOWS}
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
       {$ENDIF}
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

procedure TdsdStoredProc.MultiDataSetRefresh(AMaxAtempt: Byte = 10);
var B: TBookMark;
    i: integer;
    XMLResult: OleVariant;
    FStringStream: TStringStream;
begin
   for I := 0 to DataSets.Count - 1 do
       if DataSets[i].DataSet.State in [dsEdit, dsInsert] then
          DataSets[i].DataSet.Post;
  XMLResult := TStorageFactory.GetStorage.ExecuteProc(GetXML, False, AMaxAtempt);
  try
    for I := 0 to DataSets.Count - 1 do begin
       if DataSets[i].DataSet.Active then
          B := DataSets[i].DataSet.GetBookmark;
        if DataSets[i].DataSet is TClientDataSet then begin
//          TClientDataSet(DataSets[i].DataSet).XMLData := XMLResult[i];
           FStringStream := TStringStream.Create(String(XMLResult[i]));
           XMLResult[i] := '';
           try
              TClientDataSet(DataSets[i].DataSet).LoadFromStream(FStringStream);
           finally
             FreeAndNil(FStringStream);
           end;
        end;
       if Assigned(B) then
          try
            DataSets[i].DataSet.GotoBookmark(B);
          except
          end;
    end;
  finally
    if Assigned(B) then
       DataSets[0].DataSet.FreeBookmark(B);
  end;
end;

procedure TdsdStoredProc.MultiExecute(ExecPack, AnyExecPack: boolean; AMaxAtempt: Byte = 10);
begin
  // Заполняем значение Data + 12.07.2016 а если AnyExecPack - то Всегда
  if (not ExecPack) or (AnyExecPack = true) then
     FDataXML := FDataXML + '<dataitem>' + FillParams + '</dataitem>';
  // Увеличиваем счетчик
  CurrentPackSize := CurrentPackSize + 1;
  // Выполняем
  if (CurrentPackSize = PackSize) or ExecPack then begin
     CurrentPackSize := 0;
     try
       TStorageFactory.GetStorage.ExecuteProc(GetXML, False, AMaxAtempt);
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
        else
           ParamByName(Source[i].Name).Value := Source[i].Value
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
var D: Variant;
begin
  D := Value;
  case VarType(D) of
    vtExtended: result := D;
    vtString, vtWideString, vtClass: result := gfStrToFloat(D)
    else
    begin
      if not TryStrToFloat(VarToStr(D), Result) then
        Result := 0;
    end;
  end;
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
    Name := Param.Name;
    ParamType := Param.ParamType;
    DataType := Param.DataType;
    Value := Param.Value;
  end;
end;

function TdsdParam.AsString: string;
var i: Integer;
    Data: Variant;
begin

  Data := Value;
  if VarisNull(Data) then
    case DataType of
      ftDate, ftTime, ftDateTime: Data := '01-01-1900'
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
  end;
end;

function TdsdParam.AsStringDB: string;
var i: Integer;
    Data: Variant;
begin

  {$IFDEF ANDROID}
  if not VarisNull(Data) and (DataType in [ftDate, ftTime, ftDateTime]) then
    Data := FormatDateTime('DD.MM.YYYY HH:NN:SS', Value)
  else Data := Value;
  {$ELSE}
  Data := Value;
  {$ENDIF}

  if VarisNull(Data) then
    case DataType of
      ftDate, ftTime, ftDateTime: Data := '01-01-1900'
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
  end;
end;

constructor TdsdParam.Create;
begin
  inherited Create(nil);
  FValue := Null;
  FParamType := ptOutput;
  FDataType := ftInteger;
  FMultiSelectSeparator := ',';
end;

procedure TdsdParam.FixOldValue;
begin
  FOldValue := Value;
end;

constructor TdsdParam.Create(Collection: TCollection);
begin
  inherited;
  FValue := Null;
  FParamType := ptOutput;
  FDataType := ftInteger;
  FMultiSelectSeparator := ',';
end;

function TdsdParam.GetDisplayName: string;
begin
  result := Name
end;

function TdsdParam.GetisChanged: boolean;
begin
  Result := varToStr(FOldValue) <> VarToStr(Value)
end;

function TdsdParam.GetOwner: TPersistent;
var Owner: TComponent;
begin
  if Assigned(Collection) then
     Owner := TComponent(Collection.Owner)
  else
     Owner := nil;
  while (Owner <> nil) do
     { ???
     if Owner is TCustomForm then
        break
     else
     }
        Owner := Owner.Owner;
  result := Owner;
end;

function TdsdParam.GetValue: Variant;
// Если указан Component, то параметры берутся из него
// иначе из значения Value
var
  FRttiContext: TRttiContext;
  FRttiProperty: TRttiProperty;
  FRttiType: TRttiType;
  RttiValue : TValue;
begin
  if Assigned(Component) AND (ComponentItem <> '') and not(csDesigning in Component.ComponentState) then
  begin
    FRttiContext := TRttiContext.Create;
    try
      FRttiType := FRttiContext.GetType(Component.ClassType);
      if FRttiType <> nil then
      begin
        try
          FRttiProperty := FRttiType.GetProperty(ComponentItem);
          if FRttiProperty <> nil then
          Begin
            try
              RttiValue := FRttiProperty.GetValue(Component);
              case FRttiProperty.PropertyType.TypeKind of
                tkInteger: Result := RttiValue.AsInteger;
                tkInt64: Result := RttiValue.AsInt64;
                tkFloat: Result := RttiValue.AsExtended;
                tkString: Result := RttiValue.AsString;
                tkEnumeration: Result := RttiValue.AsType<Boolean>;
              else Result := RttiValue.AsVariant;
              end;
              try
                case DataType of
                  ftSmallint, ftInteger, ftWord, ftShortint, ftByte:
                    Result := VarAsType(Result, varInteger);
                  ftBoolean : if VarIsType(Result, varBoolean) then
                                Result := VarAsType(Result, varBoolean)
                              else if Copy(Result, 1, 1) = 't' then Result := True
                              else if Copy(Result, 1, 1) = 'f' then Result := False
                              else Result := StrToBoolDef(Result, False);
                  ftFloat, ftCurrency, ftBCD, ftFMTBcd, TFieldType.ftExtended, TFieldType.ftSingle:
                    Result := VarAsType(Result, varCurrency);
                  ftDate, ftTime, ftDateTime:
                    Result := VarAsType(Result, varDate);
                  ftLargeint:
                    Result := VarAsType(Result, varInt64);
                end;
              except
                Result := Null;
              end;
            finally
              FRttiProperty.Free;
            end;
          End;
        finally
          FRttiType.Free;
        end;
      end;
    finally
      FRttiContext.Free;
    end;
  end
  else
  Begin
    if VarIsNull(FValue) AND (DataType = ftDateTime) then
      Result := 'NULL'
    else
      Result := FValue
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

procedure TdsdParam.SetIsFillOutParams(const Value: Boolean);
begin
  FIsFillOutParams := Value;
end;

procedure TdsdParam.SetValue(const Value: Variant);
var
  FRttiContext: TRttiContext;
  FRttiProperty: TRttiProperty;
  RttiValue : TValue;
  FRttiType: TRttiType;
  IntValue: Integer;
  Int64Value: Int64;
  FloatValue: Extended;
  //Done: Boolean;
  DateTimeValue: TDateTime;
  function MyStrToDateTime(AStrDate: String): TDateTime;
  begin
    if AStrDate = '' then
      exit(0);
    if (pos('T',AStrDate) = 11) then
      try
        Result := gfXSStrToDate(AStrDate)
      except
        Result := 0;
      end
    else
      try
        Result := VarToDateTime(AStrDate);
      except
        Result := 0;
      end;
  end;

begin
  FValue := Value;
  DateTimeValue := 0;
  if Assigned(Component) AND (ComponentItem <> '') and not(csDesigning in Component.ComponentState) then
  Begin
    FRttiContext := TRttiContext.Create;
    try
      FRttiType := FRttiContext.GetType(Component.ClassType);
      if FRttiType <> nil then
      begin
        try
          FRttiProperty := FRttiType.GetProperty(ComponentItem);
          if FRttiProperty <> nil then
          Begin
            try
              case FRttiProperty.PropertyType.TypeKind of
                tkInteger:
                  begin
                    if (FValue = Null) or not TryStrToInt(VarToStr(FValue), IntValue) then
                      IntValue := 0;
                    RttiValue := IntValue;
                    FValue := IntValue;
                  end;
                tkInt64:
                  begin
                    if (FValue = Null) or not TryStrToInt64(VarToStr(FValue), Int64Value) then
                      Int64Value := 0;
                    RttiValue := Int64Value;
                    FValue := Int64Value;
                  end;
                tkFloat:
                  begin
                    if DataType = ftDate then
                      FloatValue := MyStrToDateTime(VarToStr(FValue))
                    else
                    if (FValue = Null) then
                      FloatValue := 0
                    else
                    if not TryStrToFloat(VarToStr(FValue), FloatValue) then
                      FloatValue := 0;
                    RttiValue := FloatValue;
                    FValue := FloatValue;
                  end;
                tkString, tkUString:
                  begin
                    if (DataType = ftDate) or (DataType = ftDateTime) then
                    Begin
                      if VarType(FValue) <> varDate then
                        DateTimeValue := MyStrToDateTime(VarToStr(FValue));
                      if DateTimeValue = 0 then
                        RttiValue := ''
                      else
                      begin
                        RttiValue := DateTimeToStr(DateTimeValue);
                        FValue := DateTimeValue;
                      end;
                    End
                    else
                    begin
                      RttiValue := VarToStr(FValue);
                      FValue := RttiValue.AsString;
                    end;
                  end;
                tkEnumeration:
                  begin
                    RttiValue := not sameText(varToStr(FValue), 'False') AND
                                 not sameText(varToStr(FValue), '0');
                    FValue := RttiValue.asBoolean;
                  end
              else
                begin
                  if DataType = ftDate then
                  Begin
                    if varIsNull(FValue) or (VarToStr(FValue) = '') then
                    begin
                      FValue := Null;
                      RttiValue := TValue.From(Null)
                    end
                    else
                    begin
                      DateTimeValue := MyStrToDateTime(VarToStr(FValue));
                      RttiValue := DateTimeValue;
                      FValue := DateTimeValue;
                    end;
                  End
                  else
                  begin
                    RttiValue := VarToStr(FValue);
                    FValue := RttiValue.AsString;
                  end;
                end;
              end;
              FRttiProperty.SetValue(Component,RttiValue);
            finally
              FRttiProperty.Free;
            end;
          End;
        finally
          FRttiType.Free;
        end;
      end;
    finally
      FRttiContext.Free;
    end;
  End;
  try
    case DataType of
      ftSmallint, ftInteger, ftWord, ftShortint, ftByte:
        FValue := VarAsType(FValue, varInteger);
      ftBoolean : if VarIsType(FValue, varBoolean) then
                    FValue := VarAsType(FValue, varBoolean)
                  else if Copy(FValue, 1, 1) = 't' then FValue := True
                  else if Copy(FValue, 1, 1) = 'f' then FValue := False
                  else FValue := StrToBoolDef(FValue, False);
      ftFloat, ftCurrency, ftBCD, ftFMTBcd, TFieldType.ftExtended, TFieldType.ftSingle:
        FValue := VarAsType(FValue, varCurrency);
      ftDate, ftTime, ftDateTime:
        FValue := VarAsType(FValue, varDate);
      ftLargeint:
        FValue := VarAsType(FValue, varInt64);
    end;
  except
  end;
  if FIsFillOutParams then
  Begin
    FOldValue := FValue;
  End;
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
  result := FParams.ParamByName(Value)
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

initialization

  VerifyBoolStrArray;
  //RegisterClass(TdsdDataSets);

end.

