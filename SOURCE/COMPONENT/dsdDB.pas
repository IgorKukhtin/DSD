unit dsdDB;

interface

uses Classes, DBClient, DB;

type
  TOutputType = (otResult, otDataSet, otMultiDataSet, otBlob);

  TdsdParam = class(TCollectionItem)
  private
    FComponent: TComponent;
    FDataType: TFieldType;
    FValue: string;
    FName: String;
    FComponentItem: String;
    FParamType: TParamType;
    function GetValue: String;
    procedure SetValue(const Value: string);
    procedure SetComponent(const Value: TComponent);
  protected
    function GetDisplayName: string; override;
    procedure AssignParam(Param: TdsdParam);
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(Collection: TCollection); override;
  published
    property Name: String read FName write FName;
    // Откуда считывать значение параметра
    property Component: TComponent read FComponent write SetComponent;
    property ComponentItem: String read FComponentItem write FComponentItem;
    property DataType: TFieldType read FDataType write FDataType;
    property ParamType: TParamType read FParamType write FParamType;
    property Value: string read GetValue write SetValue;
  end;

  TdsdParams = class (TCollection)
  private
    function GetItem(Index: Integer): TdsdParam;
    procedure SetItem(Index: Integer; const Value: TdsdParam);
  public
    function ParamByName(const Value: string): TdsdParam;
    function Add: TdsdParam;
    function AddParam(AName: string; ADataType: TFieldType; AParamType: TParamType; AValue: Variant): TdsdParam;
    property Items[Index: Integer]: TdsdParam read GetItem write SetItem; default;
  end;

  TdsdFormParams = class (TComponent)
  private
    FParams: TdsdParams;
  public
    function ParamByName(const Value: string): TdsdParam;
    constructor Create(AOwner: TComponent); override;
  published
    property Params: TdsdParams read FParams write FParams;
  end;

  TdsdDataSetLink = class (TCollectionItem)
  private
    FDataSet: TClientDataSet;
  published
    property DataSet: TClientDataSet read FDataSet write FDataSet;
  end;

  TdsdDataSets = class (TCollection)
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
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Execute: string;
    function ParamByName(const Value: string): TdsdParam;
    constructor Create(AOwner: TComponent); override;
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

uses Storage, CommonData, TypInfo, UtilConvert, SysUtils, cxTextEdit,
     XMLDoc, XMLIntf, StrUtils, cxCurrencyEdit, dsdGuides, cxCheckBox, cxCalendar;

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
  FDataSets := TdsdDataSets.Create(TdsdDataSetLink);
  FParams := TdsdParams.Create(TdsdParam);
  OutputType := otDataSet;
end;

procedure TdsdStoredProc.DataSetRefresh;
var B: TBookMark;
begin
  if (DataSets.Count > 0) and
      Assigned(DataSets[0]) and
      Assigned(DataSets[0].DataSet) then
   begin
     if DataSets[0].DataSet.Active then
        B := DataSets[0].DataSet.GetBookmark;
     DataSets[0].DataSet.XMLData := TStorageFactory.GetStorage.ExecuteProc(GetXML);
     if Assigned(B) then
     begin
        DataSets[0].DataSet.GotoBookmark(B);
        DataSets[0].DataSet.FreeBookmark(B);
     end;
   end;
end;

function TdsdStoredProc.Execute;
begin
  result := '';
  if (OutputType = otDataSet) then DataSetRefresh;
  if (OutputType = otResult) then
     FillOutputParams(TStorageFactory.GetStorage.ExecuteProc(GetXML));
  if (OutputType = otBlob) then
      result := TStorageFactory.GetStorage.ExecuteProc(GetXML)
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
        Result := Result + '<' + Name +
             '  DataType="' + GetEnumName(TypeInfo(TFieldType), ord(DataType)) + '" '+
             '  Value="' + Value + '" />';

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
     Session := '';
  Result :=
           '<xml Session = "' + Session + '" >' +
                '<' + StoredProcName + ' OutputType = "' + GetEnumName(TypeInfo(TOutputType), ord(OutputType)) + '">' +
                   FillParams +
                '</' + StoredProcName + '>' +
           '</xml>';
end;

procedure TdsdStoredProc.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DataSet) then
     DataSet := nil;
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

constructor TdsdParam.Create(Collection: TCollection);
begin
  inherited;
  Value := '';
  FParamType := ptInput;
  FDataType := ftInteger;
end;

function TdsdParam.GetDisplayName: string;
begin
  result := Name
end;

function TdsdParam.GetValue: String;
// Если указан Component, то параметры берутся из него
// иначе из значения Value
var
  i: integer;
  ft: double;
begin
  Result := '';
  if Assigned(FComponent) then begin
     // В зависимости от типа компонента Value содержится в разных property
     if Component is TcxTextEdit then
        Result := (Component as TcxTextEdit).Text;
     if (Component is TDataSet) and (Component as TDataSet).Active then
        Result := (Component as TDataSet).FieldByName(ComponentItem).Value;
     if (Component is TdsdFormParams) then
        if Assigned((Component as TdsdFormParams).ParamByName(ComponentItem)) then
           Result := (Component as TdsdFormParams).ParamByName(ComponentItem).Value
        else
          case DataType of
            ftInteger: Result := '0';
          end;
     if Component is TcxCurrencyEdit then
        Result := (Component as TcxCurrencyEdit).Text;
     if Component is TdsdGuides then
        Result := (Component as TdsdGuides).Key;
     if Component is TcxCheckBox then
        Result := BoolToStr((Component as TcxCheckBox).Checked, true);
     if Component is TcxDateEdit then
        Result := (Component as TcxDateEdit).Text;
  end
  else begin
    case DataType of
      ftInteger: begin
                   if TryStrToInt(FValue, I) then
                      Result := FValue
                   else
                      Result := '0';
                 end;
      ftFloat:   begin
                   if TryStrToFloat(FValue, ft) then
                      Result := ReplaceStr(FValue, ',', '.')
                   else
                      Result := '0';
                 end;
      ftDateTime:begin
                   Result := FValue
                 end;
      ftString, ftBlob: Result := FValue;
      ftBoolean: Result := FValue
    end;
  end;
end;

procedure TdsdParam.SetComponent(const Value: TComponent);
begin
  if Value <> FComponent then begin
     if FComponent <> nil then
        ComponentItem := '';
     FComponent := Value;
  end
end;

procedure TdsdParam.SetValue(const Value: string);
begin
  FValue := Value;
  // передаем значение параметра дальше по цепочке
  if Assigned(FComponent) then begin
     if Component is TcxTextEdit then
        (Component as TcxTextEdit).Text := FValue;
     if Component is TdsdFormParams then
        with (Component as TdsdFormParams) do begin
          ParamByName(FComponentItem).Value := FValue
        end;
     if Component is TcxCurrencyEdit then
        (Component as TcxCurrencyEdit).Value := StrToFloat(FValue);
     if Component is TcxCheckBox then
        (Component as TcxCheckBox).Checked := StrToBool(FValue);
     if Component is TdsdGuides then
        if LowerCase(ComponentItem) = 'name' then
           (Component as TdsdGuides).TextValue := FValue
        else
           (Component as TdsdGuides).Key := FValue;
  end
end;

{ TdsdFormParams }

constructor TdsdFormParams.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(TdsdParam);
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

initialization
  RegisterClass(TdsdDataSets);
  VerifyBoolStrArray;


end.
