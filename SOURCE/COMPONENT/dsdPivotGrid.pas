unit dsdPivotGrid;

interface

uses Classes, Vcl.Controls, dsdCommon, cxCustomPivotGrid, cxDBPivotGrid;

type
  TCalcFieldsType = (cfSumma, cfMultiplication, cfDivision, cfPercent, cfMulDiv);

  TdsdPivotGridField = class (TCollectionItem)
  private
    FField: TcxDBPivotGridField;
  protected
    procedure SetField(const Value: TcxDBPivotGridField); virtual;
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Field: TcxDBPivotGridField read FField write SetField;
  end;

  TdsdPivotGridFields = class (TOwnedCollection)
  private
    function GetItem(Index: Integer): TdsdPivotGridField;
    procedure SetItem(Index: Integer; const Value: TdsdPivotGridField);
  public
    function Add: TdsdPivotGridField;
    property Items[Index: Integer]: TdsdPivotGridField read GetItem write SetItem; default;
  end;

  TdsdPivotGridCalcFields = class (TdsdComponent)
  private
    FDBPivotGrid: TcxDBPivotGrid;
    FCalcField: TcxDBPivotGridField;
    FPivotGridFields: TdsdPivotGridFields;
    FCalcFieldsType: TCalcFieldsType;
  protected
    procedure SetPivotGrid(const Value: TcxDBPivotGrid); virtual;
    procedure SetCalcField(const Value: TcxDBPivotGridField); virtual;
    function GetSpecification : string;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure CalculateCustomSummary(
      Sender: TcxPivotGridField; ASummary: TcxPivotGridCrossCellSummary);
  published
    property PivotGrid: TcxDBPivotGrid read FDBPivotGrid write SetPivotGrid;
    property CalcField: TcxDBPivotGridField read FCalcField write SetCalcField;
    property GridFields: TdsdPivotGridFields read FPivotGridFields write FPivotGridFields;
    property CalcFieldsType: TCalcFieldsType  read FCalcFieldsType write FCalcFieldsType default cfSumma;
    property Specification: string read GetSpecification;
  end;

  procedure Register;


implementation

uses Storage, TypInfo, System.SysUtils, cxTextEdit, VCL.Forms,
     XMLDoc, XMLIntf, StrUtils, cxCurrencyEdit, cxCheckBox, cxCalendar,
     Variants, UITypes, Windows, Dialogs;

{ TdsdPivotGridField }

procedure TdsdPivotGridField.Assign(Source: TPersistent);
begin
  if Source is TdsdPivotGridField then
     Self.Field := TdsdPivotGridField(Source).Field
  else
    inherited; //raises an exception
end;

function TdsdPivotGridField.GetDisplayName: string;
begin
  if Assigned(FField) then
     Result := FField.Name
  else
     Result := inherited;
end;

procedure TdsdPivotGridField.SetField(const Value: TcxDBPivotGridField);
begin
  if FField <> Value then
  begin
    if not (csLoading in TdsdPivotGridCalcFields(Collection.Owner).ComponentState) then
    begin
      if not Assigned(TdsdPivotGridCalcFields(Collection.Owner).PivotGrid) then
      begin
        FField := Nil;
        Exit;
      end;

      if TdsdPivotGridCalcFields(Collection.Owner).PivotGrid <> Value.PivotGrid then
      begin
        FField := Nil;
        Exit;
      end;
    end;

    if Assigned(Collection) and Assigned(Value) then
       Value.FreeNotification(TComponent(Collection.Owner));
    FField := Value;
  end;
end;

{ TdsdPivotGridFields }

function TdsdPivotGridFields.Add: TdsdPivotGridField;
begin
  result := TdsdPivotGridField(inherited Add);
end;

function TdsdPivotGridFields.GetItem(Index: Integer): TdsdPivotGridField;
begin
  Result := TdsdPivotGridField(inherited GetItem(Index));
end;

procedure TdsdPivotGridFields.SetItem(Index: Integer; const Value: TdsdPivotGridField);
begin
  inherited SetItem(Index, Value);
end;

{ TdsdPivotGridCalcFields }

constructor TdsdPivotGridCalcFields.Create(AOwner: TComponent);
begin
  inherited;
  FPivotGridFields:= TdsdPivotGridFields.Create(Self, TdsdPivotGridField);
end;

destructor TdsdPivotGridCalcFields.Destroy;
begin
  FreeAndNil(FPivotGridFields);
  inherited;
end;

procedure TdsdPivotGridCalcFields.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if (csDestroying in ComponentState) then
     exit;
  if (Operation = opRemove) then
  begin
       if Assigned(FPivotGridFields) then begin
          for I := FPivotGridFields.Count - 1 downto 0 do
             if FPivotGridFields.Items[i].Field = AComponent then
                FPivotGridFields.Delete(I);
       end;

       if AComponent = PivotGrid then PivotGrid := Nil;
       if AComponent = CalcField then CalcField := nil;
  end;
  if (Operation = opInsert) and (AComponent = CalcField) then
  begin
    CalcField.SummaryType := stCustom;
    CalcField.OnCalculateCustomSummary := CalculateCustomSummary;
  end;
end;

procedure TdsdPivotGridCalcFields.SetPivotGrid(const Value: TcxDBPivotGrid);
begin
  if FDBPivotGrid <> Value  then
  begin
    if not (csLoading in ComponentState) then
    begin
      if Assigned(CalcField) then
      begin
        CalcField.OnCalculateCustomSummary := Nil;
        CalcField := nil;
      end;
      if FPivotGridFields.Count > 0 then FPivotGridFields.Clear;
    end;
    FDBPivotGrid := Value;
  end;
end;

procedure TdsdPivotGridCalcFields.SetCalcField(const Value: TcxDBPivotGridField);
begin
  if FCalcField <> Value  then
  begin
    if not (csLoading in ComponentState) then
    begin
      if not Assigned(FDBPivotGrid) or not Assigned(Value) then
      begin
        FCalcField := Nil;
        Exit;
      end;

      if FDBPivotGrid <> Value.PivotGrid then
      begin
        FCalcField := Nil;
        Exit;
      end;
    end;

    if not (csDesigning in ComponentState) and Assigned(FCalcField) then
      CalcField.OnCalculateCustomSummary := Nil;
    FCalcField := Value;
    if not (csDesigning in ComponentState) and Assigned(FCalcField) then
    begin
      CalcField.SummaryType := stCustom;
      CalcField.OnCalculateCustomSummary := CalculateCustomSummary;
    end;
  end;
end;

function TdsdPivotGridCalcFields.GetSpecification : string;
begin
  case FCalcFieldsType of
    cfSumma : Result := '= F1 + F2 + ... + Fn';
    cfMultiplication : Result := '= F1 * F2 * ... * Fn';
    cfDivision : Result := '= F1 / F2';
    cfPercent : Result := '= F1 / F2 * 100';
    cfMulDiv : Result := '= F1 * F2 / F3';
  end;

end;

procedure TdsdPivotGridCalcFields.CalculateCustomSummary(
  Sender: TcxPivotGridField; ASummary: TcxPivotGridCrossCellSummary);
var
  Value1, Value2, Value3: Variant; I: integer;
begin
  if not Assigned(FDBPivotGrid) then Exit;
  if not Assigned(FDBPivotGrid.DataSource) then Exit;
  if not Assigned(FDBPivotGrid.DataSource.DataSet) then Exit;
  if FDBPivotGrid.DataSource.DataSet.IsEmpty then Exit;
  if FPivotGridFields.Count <= 0 then Exit;

  case FCalcFieldsType of
    cfSumma :
      begin
        Value1 := 0.0;
        for I := 0 to FPivotGridFields.Count - 1 do
          if Assigned(FPivotGridFields.Items[I].Field) and (FPivotGridFields.Items[I].Field.Area = faData) then
          begin
            if ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[I].Field,stSum) <> Null then
            Value1 := Value1 + ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[I].Field,stSum);
          end;
        ASummary.Custom := Value1;
      end;
    cfMultiplication :
      begin
        if Assigned(FPivotGridFields.Items[0].Field) and (FPivotGridFields.Items[0].Field.Area = faData) then
          Value1 := ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[0].Field,stSum)
        else Value1 := 0;
        if Value1 = null then Value1 := 0;
        for I := 1 to FPivotGridFields.Count - 1 do
        begin
          if Assigned(FPivotGridFields.Items[I].Field) and (FPivotGridFields.Items[I].Field.Area = faData) then
            Value2 := ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[I].Field,stSum)
          else Value2 := 0;
          if Value2 = null then Value2 := 0;
          Value1 := Value1 * Value2;
        end;
        ASummary.Custom := Value1;
      end;
    cfDivision : if FPivotGridFields.Count >= 2 then
      begin
        if Assigned(FPivotGridFields.Items[0].Field) and (FPivotGridFields.Items[0].Field.Area = faData) then
          Value1 := ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[0].Field,stSum)
        else Value1 := 0;
        if Assigned(FPivotGridFields.Items[1].Field) and (FPivotGridFields.Items[1].Field.Area = faData) then
          Value2 := ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[1].Field,stSum)
        else Value2 := 0;
        if (Value1 = null) or (Value2 = null) or (Value2 = 0) then Exit;
        ASummary.Custom := Value1 / Value2;
      end;
    cfPercent : if FPivotGridFields.Count >= 2 then
      begin
        if Assigned(FPivotGridFields.Items[0].Field) and (FPivotGridFields.Items[0].Field.Area = faData) then
          Value1 := ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[0].Field,stSum)
        else Value1 := 0;
        if Assigned(FPivotGridFields.Items[1].Field) and (FPivotGridFields.Items[1].Field.Area = faData) then
          Value2 := ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[1].Field,stSum)
        else Value2 := 0;
        if (Value1 = null) or (Value2 = null) or (Value2 = 0) then Exit;
        ASummary.Custom := Value1 / Value2 * 100;
      end;
    cfMulDiv : if FPivotGridFields.Count >= 3 then
      begin
        if Assigned(FPivotGridFields.Items[0].Field) and (FPivotGridFields.Items[0].Field.Area = faData) then
          Value1 := ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[0].Field,stSum)
        else Value1 := 0;
        if Assigned(FPivotGridFields.Items[1].Field) and (FPivotGridFields.Items[1].Field.Area = faData) then
          Value2 := ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[1].Field,stSum)
        else Value2 := 0;
        if Assigned(FPivotGridFields.Items[2].Field) and (FPivotGridFields.Items[2].Field.Area = faData) then
          Value3 := ASummary.Owner.Row.GetCellByCrossItem(ASummary.Owner.Column).GetSummaryByField(FPivotGridFields.Items[2].Field,stSum)
        else Value3 := 0;
        if (Value1 = null) or (Value2 = null) or (Value3 = null) or (Value3 = 0) then Exit;
        ASummary.Custom := Value1 * Value2 / Value3;
      end;
  end;
end;


procedure Register;
begin
   RegisterComponents('DSDComponent', [TdsdPivotGridCalcFields]);
end;

initialization

  Classes.RegisterClass(TdsdPivotGridCalcFields);

end.
