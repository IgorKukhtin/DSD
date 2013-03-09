unit dsdDataSetWrapperUnit;

interface

uses Classes, DBClient, UtilType, DB;

type

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
  protected
    function GetDisplayName: string; override;
    procedure AssignParam(Param: TdsdParam);
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(Collection: TCollection); override;
  published
    property Name: String read FName write FName;
    // ќткуда считывать значение параметра
    property Component: TComponent read FComponent write FComponent;
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
    function AddParam(AName: string; ADataType: TFieldType; AParamType: TParamType; AValue: Variant): TParam;
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
  public
    procedure Execute;
    function ParamByName(const Value: string): TdsdParam;
    constructor Create(AOwner: TComponent); override;
  published
    property StoredProcName: String read FStoredProcName write FStoredProcName;
    property DataSets: TdsdDataSets read FDataSets write FDataSets;
    property OutputType: TOutputType read FOutputType write FOutputType default otDataSet;
    property Params: TdsdParams read FParams write FParams;
  end;

  procedure Register;


implementation

uses StorageUnit, CommonDataUnit, TypInfo, UtilConvert, SysUtils, cxTextEdit,
     XMLDoc, XMLIntf;

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

procedure TdsdStoredProc.Execute;
begin
  if (OutputType = otDataSet) and (DataSets.Count > 0) and
      Assigned(DataSets[0]) and Assigned(DataSets[0].DataSet) then
         DataSets[0].DataSet.XMLData := TStorageFactory.GetStorage.ExecuteProc(GetXML);
  if (OutputType = otResult) then
     FillOutputParams(TStorageFactory.GetStorage.ExecuteProc(GetXML));
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

function TdsdStoredProc.GetXML: String;
var
  Session, ParamValue: string;
  i: integer;
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
  AParamType: TParamType; AValue: Variant): TParam;
begin
  with Add do begin
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
// ≈сли указан Component, то параметры берутс€ из него
// иначе из значени€ Value
var
  i: integer;
begin
  if Assigned(Component) then begin
     // ¬ зависимости от типа компонента Value содержитс€ в разных property
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
          end
  end
  else begin
    case DataType of
      ftInteger: begin
                   if TryStrToInt(FValue, I) then
                      Result := FValue
                   else
                      Result := '0';
                 end;
      ftString, ftBlob: Result := FValue;
    end;
  end;
end;

procedure TdsdParam.SetValue(const Value: string);
begin
  FValue := Value;
  if Assigned(Component) then begin
     if Component is TcxTextEdit then
        (Component as TcxTextEdit).Text := FValue;
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

initialization
  RegisterClass(TdsdDataSets);

end.
