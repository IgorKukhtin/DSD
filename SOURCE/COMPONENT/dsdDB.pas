unit dsdDB;

interface

uses Classes, DBClient, DB;

type
  TOutputType = (otResult, otDataSet, otMultiDataSet, otBlob);

  TdsdParam = class(TCollectionItem)
  private
    FComponent: TComponent;
    FDataType: TFieldType;
    FValue: Variant;
    FName: String;
    FComponentItem: String;
    FParamType: TParamType;
    FonChange: TNotifyEvent;
    function GetValue: OleVariant;
    procedure SetValue(const Value: OleVariant);
    procedure SetComponent(const Value: TComponent);
    procedure SetInDataSet(const DataSet: TDataSet; const FieldName: string; const Value: Variant);
    function GetFromDataSet(const DataSet: TDataSet; const FieldName: string): Variant;
    procedure SetInCrossDBViewAddOn(const Value: Variant);
    function GetFromCrossDBViewAddOn: Variant;
  protected
    function GetDisplayName: string; override;
    procedure AssignParam(Param: TdsdParam);
  public
    property onChange: TNotifyEvent read FonChange write FonChange;
    function AsString: string;
    procedure Assign(Source: TPersistent); override;
    constructor Create(Collection: TCollection); override;
  published
    property Name: String read FName write FName;
    property Value: OleVariant read GetValue write SetValue;
    // Откуда считывать значение параметра
    property Component: TComponent read FComponent write SetComponent;
    property ComponentItem: String read FComponentItem write FComponentItem;
    property DataType: TFieldType read FDataType write FDataType default ftInteger;
    property ParamType: TParamType read FParamType write FParamType default ptOutput;
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

  TdsdFormParams = class (TComponent)
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
    FDataSet: TClientDataSet;
    procedure SetDataSet(const Value: TClientDataSet);
  protected
    function GetDisplayName: string; override;
  published
    property DataSet: TClientDataSet read FDataSet write SetDataSet;
  end;

  TdsdDataSets = class (TOwnedCollection)
  private
    function GetItem(Index: Integer): TdsdDataSetLink;
    procedure SetItem(Index: Integer; const Value: TdsdDataSetLink);
  public
    function Add: TdsdDataSetLink;
    property Items[Index: Integer]: TdsdDataSetLink read GetItem write SetItem; default;
  end;

  TdsdStoredProc = class (TComponent)
  private
    FDataSets: TdsdDataSets;
    FParams: TdsdParams;
    FStoredProcName: string;
    FOutputType: TOutputType;
    function GetXML: String;
    function FillParams: String;
    procedure FillOutputParams(XML: String);
    function GetDataSet: TClientDataSet;
    procedure SetDataSet(const Value: TClientDataSet);
    procedure DataSetRefresh;
    procedure MultiDataSetRefresh;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Execute: string;
    function ParamByName(const Value: string): TdsdParam;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // Название процедуры на сервере
    property StoredProcName: String read FStoredProcName write FStoredProcName;
    // ДатаСет с данными. Введен для удобства, так как зачастую DataSet = DataSets[0]
    property DataSet: TClientDataSet read GetDataSet write SetDataSet;
    // Обновляемые ДатаСеты
    property DataSets: TdsdDataSets read FDataSets write FDataSets;
    property OutputType: TOutputType read FOutputType write FOutputType default otDataSet;
    // Параметры процедуры
    property Params: TdsdParams read FParams write FParams;
  end;

  procedure Register;


implementation

uses Storage, CommonData, TypInfo, UtilConvert, SysUtils, cxTextEdit, VCL.Forms,
     XMLDoc, XMLIntf, StrUtils, cxCurrencyEdit, dsdGuides, cxCheckBox, cxCalendar,
     Variants, XSBuiltIns, UITypes, dsdAction, Defaults, UtilConst, Windows, Dialogs,
     dsdAddOn, cxDBData;

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
end;

procedure TdsdStoredProc.DataSetRefresh;
var B: TBookMark;
begin
  if (DataSets.Count > 0) and
      Assigned(DataSets[0]) and
      Assigned(DataSets[0].DataSet) then
   begin
     if DataSets[0].DataSet.Active and (DataSets[0].DataSet.RecordCount > 0) then
        B := DataSets[0].DataSet.GetBookmark;
     DataSets[0].DataSet.XMLData := TStorageFactory.GetStorage.ExecuteProc(GetXML);
     if Assigned(B) then
     begin
        try
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

function TdsdStoredProc.Execute;
var TickCount: cardinal;
begin
  result := '';
  if gc_isShowTimeMode then
     TickCount := GetTickCount;
  Screen.Cursor := crHourGlass;
  try
    if (OutputType = otDataSet) then DataSetRefresh;
    if (OutputType = otMultiDataSet) then MultiDataSetRefresh;
    if (OutputType = otResult) then
       FillOutputParams(TStorageFactory.GetStorage.ExecuteProc(GetXML));
    if (OutputType = otBlob) then
        result := TStorageFactory.GetStorage.ExecuteProc(GetXML)
  finally
    Screen.Cursor := crDefault;
  end;
  if gc_isShowTimeMode then
     ShowMessage('Время выполнения ' + StoredProcName + ' - ' + FloatToStr((GetTickCount - TickCount)/1000) + ' сек ' ); ;
end;

procedure TdsdStoredProc.FillOutputParams(XML: String);
var
  XMLDocument: IXMLDocument;
  i: integer;
begin
  XMLDocument := TXMLDocument.Create(nil);
  XMLDocument.LoadFromXML(XML);
  for I := 0 to Params.Count - 1 do
      if Params[i].ParamType in [ptOutput, ptInputOutput] then
         if XMLDocument.DocumentElement.HasAttribute(LowerCase(Params[i].Name)) then
            Params[i].Value := XMLDocument.DocumentElement.Attributes[LowerCase(Params[i].Name)];
end;

function TdsdStoredProc.FillParams: String;
var
  i: integer;
begin
  Result := '';
  for I := 0 to Params.Count - 1 do
      with Params[i] do
        if ParamType in [ptInput, ptInputOutput] then
           if DataType = ftBlob then
              Result := Result + '<' + Name +
                   '  DataType="' + GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" '+
                   '  Value="' + (asString) + '" />'
           else
              Result := Result + '<' + Name +
                   '  DataType="' + GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" '+
                   '  Value="' + gfStrToXmlStr(asString) + '" />';

end;

function TdsdStoredProc.GetDataSet: TClientDataSet;
begin
  if DataSets.Count > 0 then
     result := DataSets[0].DataSet
  else
     result := nil
end;

procedure TdsdStoredProc.SetDataSet(const Value: TClientDataSet);
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


function TdsdStoredProc.GetXML: String;
var
  Session: string;
begin
  if Assigned(gc_User) then
     Session := gc_User.Session
  else
     raise Exception.Create('Пользователь не установлен');
  if trim(StoredProcName) = '' then
     raise Exception.Create('Не указано название процедуры в объекте типа TdsdStoredProc');
  Result :=
           '<xml Session = "' + Session + '" >' +
                '<' + StoredProcName + ' OutputType = "' + GetEnumName(TypeInfo(TOutputType), ord(OutputType)) + '">' +
                   FillParams +
                '</' + StoredProcName + '>' +
           '</xml>';
end;

procedure TdsdStoredProc.MultiDataSetRefresh;
var B: TBookMark;
    i: integer;
    XMLResult: OleVariant;
begin
  XMLResult := TStorageFactory.GetStorage.ExecuteProc(GetXML);
  try
    for I := 0 to DataSets.Count - 1 do begin
       if DataSets[i].DataSet.Active then
          B := DataSets[i].DataSet.GetBookmark;
       DataSets[i].DataSet.XMLData := XMLResult[i];
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

procedure TdsdStoredProc.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) then
       try
         if Assigned(Params) then
            for i := 0 to Params.Count - 1 do
               if Params[i].Component = AComponent then
                  Params[i].Component := nil;
         if (AComponent is TDataSet) and Assigned(DataSets) then
            for i := 0 to DataSets.Count - 1 do
                if DataSets[i].DataSet = AComponent then
                   DataSets[i].DataSet := nil;
         if AComponent = DataSet then
            DataSet := nil;
       except
         // запинали ухо!
       end;
end;

function TdsdStoredProc.ParamByName(const Value: string): TdsdParam;
begin
  result := FParams.ParamByName(Value)
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
        if ParamByName(Source[i].Name) = nil then
           Add.AssignParam(Source[i])
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

procedure TdsdParam.Assign(Source: TPersistent);
begin
  if Source is TdsdParam then
     AssignParam(TdsdParam(Source))
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
    Data: OleVariant;
begin
  Data := Value;
  if VarisNull(Data) then
     Data := '';
  if varType(Data) in [varSingle, varDouble, varCurrency] then
     result := gfFloatToStr(Data)
  else
     result := Data;
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

constructor TdsdParam.Create(Collection: TCollection);
begin
  inherited;
  FValue := Null;
  FParamType := ptOutput;
  FDataType := ftInteger;
end;

function TdsdParam.GetDisplayName: string;
begin
  result := Name
end;

function TdsdParam.GetFromCrossDBViewAddOn: Variant;
var CrossDBViewAddOn: TCrossDBViewAddOn;
begin
  CrossDBViewAddOn := TCrossDBViewAddOn(Component);
  if CrossDBViewAddOn.HeaderDataSet.Active then
     result := GetFromDataSet(TcxDBDataController(CrossDBViewAddOn.View.DataController).DataSet, ComponentItem + IntToStr(CrossDBViewAddOn.HeaderDataSet.RecNo));
end;

function TdsdParam.GetFromDataSet(const DataSet: TDataSet; const FieldName: string): Variant;
begin
  if DataSet.Active then begin
    Result := DataSet.FieldByName(FieldName).Value;
    if VarIsNull(Result) then
    case DataType of
      ftString: Result := '';
      ftInteger: Result := 0;
      ftBoolean: Result := false;
      ftFloat: Result := 0;
      ftDateTime: Result := Now;
    end;
  end;
end;

function TdsdParam.GetValue: OleVariant;
// Если указан Component, то параметры берутся из него
// иначе из значения Value
var DateTime: TDateTime;
begin
  if Assigned(FComponent) then begin
     // В зависимости от типа компонента Value содержится в разных property
     if Component is TCrossDBViewAddOn then
        result := GetFromCrossDBViewAddOn;
     if Component is TcxTextEdit then
        Result := (Component as TcxTextEdit).Text;
     if (Component is TDataSet) then
        Result := GetFromDataSet(TDataSet(Component), ComponentItem);
     if (Component is TdsdFormParams) then
        if Assigned((Component as TdsdFormParams).ParamByName(ComponentItem)) then
           Result := (Component as TdsdFormParams).ParamByName(ComponentItem).Value
        else
          case DataType of
            ftInteger: Result := '0';
          end;
     if Component is TcxCurrencyEdit then
        Result := (Component as TcxCurrencyEdit).Value;
     if Component is TCustomGuides then begin
        if LowerCase(ComponentItem) = 'textvalue'  then
           Result := (Component as TCustomGuides).TextValue
        else
           Result := (Component as TCustomGuides).Key;
     end;
     if Component is TcxCheckBox then
        Result := BoolToStr((Component as TcxCheckBox).Checked, true);
     if Component is TcxDateEdit then begin
        DateTime := (Component as TcxDateEdit).Date;
        if DateTime = -700000 then
           DateTime := 0;
        Result := DateTime;
     end;
     if Component is TBooleanStoredProcAction then
        Result := (Component as TBooleanStoredProcAction).Value;
     if Component is TDefaultKey then
        Result := (Component as TDefaultKey).Key;
  end
  else
    Result := FValue
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
     SetInDataSet(TcxDBDataController(CrossDBViewAddOn.View.DataController).DataSet, ComponentItem + IntToStr(CrossDBViewAddOn.HeaderDataSet.RecNo), Value);
end;

procedure TdsdParam.SetInDataSet(const DataSet: TDataSet; const FieldName: string; const Value: Variant);
var Field: TField;
begin
  if DataSet.Active then begin
    if DataSet.State <> dsEdit then
       DataSet.Edit;
    Field := DataSet.FieldByName(FieldName);
    if Assigned(Field) then begin
       // в случае дробного числа и если строка, то надо конвертить
       if (Field.DataType in [ftFloat]) and (VarType(FValue) in [vtString, vtClass]) then
           Field.Value := gfStrToFloat(FValue)
       else
         // в случае даты и если строка, то надо конвертить
         if (Field.DataType in [ftDateTime, ftDate, ftTime]) and (VarType(FValue) in [vtString, vtClass]) then begin
            with TXSDateTime.Create() do
            try
              XSToNative(FValue); // convert from WideString
              Field.Value := AsDateTime;//AsDateTime; // convert to TDateTime
            finally
              Free;
            end;
         end
         else
            Field.Value := FValue;
    end
    else
      raise Exception.Create('У дата сета "' + Component.Name + '" нет поля "' + FieldName + '"');
  end;
end;

procedure TdsdParam.SetValue(const Value: OleVariant);
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
     if Component is TdsdFormParams then
        with (Component as TdsdFormParams) do begin
          if Assigned(ParamByName(FComponentItem)) then
             ParamByName(FComponentItem).Value := FValue
          else
             Params.AddParam(FComponentItem, ftString, ptInput, FValue);
        end;
     if Component is TcxCurrencyEdit then
        (Component as TcxCurrencyEdit).Value := gfStrToFloat(FValue);
     if Component is TcxCheckBox then
        (Component as TcxCheckBox).Checked := StrToBool(FValue);
     if Component is TcxDateEdit then
        if VarType(FValue) = vtObject then
          (Component as TcxDateEdit).Date := FValue
        else
          with TXSDateTime.Create() do
          try
            XSToNative(FValue); // convert from WideString
            (Component as TcxDateEdit).EditValue := AsDateTime;//AsDateTime; // convert to TDateTime
          finally
            Free;
          end;
     if Component is TCustomGuides then
        if LowerCase(ComponentItem) = 'textvalue' then begin
           (Component as TCustomGuides).TextValue := FValue
        end else
          if LowerCase(ComponentItem) = 'parentid' then
             (Component as TCustomGuides).ParentId := FValue
          else
             (Component as TCustomGuides).Key := FValue;
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
  FParams.Free;
  FParams := nil;
  inherited;
end;

procedure TdsdFormParams.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
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

function TdsdDataSetLink.GetDisplayName: string;
begin
  if Assigned(FDataSet) then
     Result := FDataSet.Name
  else
     Result := inherited;
end;

procedure TdsdDataSetLink.SetDataSet(const Value: TClientDataSet);
begin
  if FDataSet <> Value then begin
     if Assigned(Collection) and Assigned(Value) then
        Value.FreeNotification(TComponent(Collection.Owner));
     FDataSet := Value;
  end;
end;

initialization
  Classes.RegisterClass(TdsdDataSets);
  VerifyBoolStrArray;

end.
