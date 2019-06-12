unit GridGroupCalculate;

interface

uses
  cxGridDBBandedTableView, cxCustomData, dsdOlap, cxCustomPivotGrid;

type

  TmycxPivotGridController = class(TcxPivotGridController)
  protected
    function CreateFilterPopup: TcxPivotGridFilterPopup; override;
  end;

  TmycxPivotGridFilterPopup = class(TcxPivotGridFilterPopup)
  protected
    procedure InitValues; override;
  end;

  TcxPivotGridVariantValueAccess = class (TcxPivotGridVariantValue);


  ISetValues = interface
    procedure SetValues(i: integer; Value: Variant);
    function GetValues(i: integer): Variant;
    property Values[Index: integer]: Variant read GetValues write SetValues;
  end;

  //  Базовый класс для работы с вариант массивами GroupSummaryValues и FooterSummaryValues
  //  приходится делать классами из-за разной реализации данных массивов
  TSetValues = class(TInterfacedObject, ISetValues)
  private
    FSender: TcxDataSummary;
    procedure SetValues(i: integer; Value: Variant); virtual; abstract;
    function GetValues(i: integer): Variant; virtual; abstract;
  public
    property Values[Index: integer]: Variant read GetValues write SetValues;
    constructor Create(ASender: TcxDataSummary);
  end;

  //  Класс для работы с вариант массивами GroupSummaryValues 
  TSetGroupValues = class(TSetValues)
  private
    FLevel: integer;
    procedure SetValues(i: integer; Value: Variant); override;
    function GetValues(i: integer): Variant; override;
  public
    constructor Create(ALevel: integer; ASender: TcxDataSummary);
  end;

  //  Класс для работы с вариант массивами FooterSummaryValues
  TSetFooterValues = class(TSetValues)
  private
    procedure SetValues(i: integer; Value: Variant); override;
    function GetValues(i: integer): Variant; override;
  end;

  // процедура для расчета значений футеров груп
  TCalculateGroupValues = class
    class procedure CalculateValues(OlapReportOption: TOlapReportOption;
                    ASummaryItems: TcxDataSummaryItems; ASetValues: ISetValues;
                    tvReport: TcxGridDBBandedTableView; isFormat: boolean = true);
  end;


implementation

uses cxGridDBTableView, SysUtils, cxCheckListBox, cxPivotGridStrs, cxDBPivotGrid,
     cxLookAndFeelPainters, cxClasses, dxCore;

{ TSetValues }
constructor TSetValues.Create(ASender: TcxDataSummary);
begin
  inherited Create;
  FSender := ASender;
end;

{ TSetGroupValues }
constructor TSetGroupValues.Create(ALevel: integer;
  ASender: TcxDataSummary);
begin
  inherited Create(ASender);
  FLevel := ALevel
end;

function TSetGroupValues.GetValues(i: integer): Variant;
begin
  result := FSender.GroupSummaryValues[FLevel, i];
end;

procedure TSetGroupValues.SetValues(i: integer; Value: Variant);
begin
  FSender.GroupSummaryValues[FLevel, i] := Value
end;

{ TSetFooterValues }
function TSetFooterValues.GetValues(i: integer): Variant;
begin
  result := FSender.FooterSummaryValues[i]
end;

procedure TSetFooterValues.SetValues(i: integer; Value: Variant);
begin
  FSender.FooterSummaryValues[i] := Value
end;

{ TCalculateGroupValues }
class procedure TCalculateGroupValues.CalculateValues(OlapReportOption: TOlapReportOption;
  ASummaryItems: TcxDataSummaryItems; ASetValues: ISetValues; tvReport: TcxGridDBBandedTableView; isFormat: boolean = true);
var I, J: Integer;
    RealSumm, ChangeSumm: real;
    FieldNumberName: string;
    DataOLAPField: TDataOLAPField;
begin
  if not Assigned(OlapReportOption) then exit;
  for j := 0 to OlapReportOption.FieldCount - 1 do
      if OlapReportOption.Objects[j].Visible then
         if OlapReportOption.Objects[j] is TDataOLAPField then
            if (OlapReportOption.Objects[j] as TDataOLAPField).SummaryType = stPercent then begin
              DataOLAPField := (OlapReportOption.Objects[j] as TDataOLAPField);
              for I := 0 to ASummaryItems.Count - 1 do
              begin
                if pos(DataOLAPField.FieldName, TcxGridDBTableSummaryItem(ASummaryItems[i]).Column.DataBinding.FilterFieldName)<>0 then begin
                  RealSumm := 0; ChangeSumm := 0;
                  FieldNumberName := StringReplace(TcxGridDBTableSummaryItem(ASummaryItems[i]).Column.DataBinding.FilterFieldName, DataOLAPField.FieldName, DataOLAPField.ObligatoryObjects[0].FieldName, [rfReplaceAll, rfIgnoreCase]);
                  try
                    RealSumm := ASetValues.Values[ASummaryItems.IndexOfItemLink(tvReport.GetColumnByFieldName(FieldNumberName))];
                  except end;
                  FieldNumberName := StringReplace(FieldNumberName, DataOLAPField.ObligatoryObjects[0].FieldName, DataOLAPField.ObligatoryObjects[1].FieldName, [rfReplaceAll, rfIgnoreCase]);
                  try
                    ChangeSumm := ASetValues.Values[ASummaryItems.IndexOfItemLink(tvReport.GetColumnByFieldName(FieldNumberName))];
                  except end;
                  if RealSumm <> 0 then
                     ChangeSumm := ChangeSumm / RealSumm * 100;
                  if ChangeSumm <> 0 then
                     if isFormat then
                       ASetValues.Values[I] := FormatFloat(DataOLAPField.DisplayFormat, ChangeSumm)
                     else
                       ASetValues.Values[I] := ChangeSumm;
                end
              end;
            end;
end;

{ TmycxPivotGridController }

function TmycxPivotGridController.CreateFilterPopup: TcxPivotGridFilterPopup;
begin
  Result := TmycxPivotGridFilterPopup.Create(PivotGrid);
  TmycxPivotGridFilterPopup(Result).LookAndFeel.MasterLookAndFeel := PivotGrid.LookAndFeel;
end;

type

  TcxDBPivotGrid = class(cxDBPivotGrid.TcxDBPivotGrid)
  protected
    function CreateController: TcxPivotGridController; override;
  end;

{ TmycxPivotGridFilterPopup }

procedure TmycxPivotGridFilterPopup.InitValues;
var
  I: Integer;
  AShowAllItem: TcxCheckListBoxItem;
begin
  with Values.Items do
  begin
    BeginUpdate;
    TcxDBPivotGrid(PivotGrid).ShowHourglassCursor;
    FLocked := True;
    try
      Clear;
      FShowAllState := cbsUnchecked;
      AShowAllItem := Values.Items.Add;
      AShowAllItem.Text := cxGetResourceString(@scxPivotGridShowAll);
      for I := 0 to Field.GroupValueList.Count - 1 do
        if not TcxPivotGridVariantValueAccess(Field.GroupValueList.Items[I]).FUnUsed then
           AddValue(Field.GroupValueList.Items[I]);
      FShowAllState := GetStateByCount(GetCheckedCount);;
      AShowAllItem.State := FShowAllState;
    finally
      FLocked := False;
      TcxDBPivotGrid(PivotGrid).HideHourglassCursor;
      CheckButtonsEnabled;
      EndUpdate;
    end;
  end;
  FFilterModified := False;
end;

{ TcxDBPivotGrid }

function TcxDBPivotGrid.CreateController: TcxPivotGridController;
begin
  Result := TmycxPivotGridController.Create(Self);
end;

end.
