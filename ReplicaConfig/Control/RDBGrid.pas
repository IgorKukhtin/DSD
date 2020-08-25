{==============================================================================*
* Copyright © 2020, Pukhkiy Igor                                               *
* All rights reserved.                                                         *
*==============================================================================*
* This Source Code Form is subject to the terms of the Mozilla                 *
* Public License, v. 2.0. If a copy of the MPL was not distributed             *
* with this file, You can obtain one at http://mozilla.org/MPL/2.0/.           *
*==============================================================================*
* The Initial Developer of the Original Code is Pukhkiy Igor (Ukraine).        *
* Contacts: nspytnik-programming@yahoo.com                                     *
*==============================================================================*
* DESCRIPTION:                                                                 *
* RDBGrid.pas - module helper for TDrawGrid                                    *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}

unit RDBGrid;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Grids;
type
  TDrawGridProvider = class;
  TOnGetText = function (Sender: TObject; ACol, ARow: Integer): string of object;

  TGetPickListEvent = procedure(Sender: TObject; ACol, ARow: Integer;
    Values: TStrings) of object;

  TOnValidateEvent = procedure(Sender: TObject; ACol, ARow: Longint;
    const Value: string) of object;
  TOnRowChecked = procedure (Sender: TObject; ACol, ARow: Longint; Checked: Boolean) of object;


  TDrawGrid = class (Vcl.Grids.TDrawGrid)
  private
    FOnGetText: TOnGetText;
    FOnGetHeader: TOnGetText;
    FEditList: TInplaceEditList;
    FOnEditButtonClick: TNotifyEvent;
    FDropDownRows: Integer;
    FOnGetPickList: TGetPickListEvent;
    FOnValidate: TOnValidateEvent;
    FColumnEditStyle: array of TEditStyle;
    FCheckBoxes: Boolean;
    FOnRowChecked: TOnRowChecked;
    FRecordCount: Integer;
    FFieldCount: Integer;
    FProvider: TDrawGridProvider;
    FCkeckedALL: Boolean;
    function GetCell(ACol, ARow: Integer): string;
    procedure EditListGetItems(ACol, ARow: Integer; Items: TStrings);
    procedure SetOnEditButtonClick(const Value: TNotifyEvent);
    procedure SetDropDownRows(const Value: Integer);
    function GetColumnEditStyle(const ACol: Integer): TEditStyle;
    procedure SetColumnEditStyle(const ACol: Integer; const Value: TEditStyle);
    procedure SetCheckBoxes(const Value: Boolean);
    procedure SetRecordCount(const Value: Integer);
    procedure SetFieldCount(const Value: Integer);
    procedure SetProvider(const Value: TDrawGridProvider);
  protected
    procedure DrawCell(ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState); override;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    function GetEditText(ACol, ARow: Integer): string; override;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
    function GetEditStyle(ACol, ARow: Longint): TEditStyle; override;
    function CanEditModify: Boolean; override;
    function CreateEditor: TInplaceEdit; override;
    procedure CreateWnd; override;
    procedure DoExit; override;
    procedure DoOnValidate; virtual;
    procedure SizeChanged(OldColCount, OldRowCount: Longint); override;
    procedure FixedCellClick(ACol, ARow: Longint); override;
  public
    destructor Destroy; override;
    procedure InvalidateRecord(ARow: Integer);
    procedure SetColumnsWidth(const widths: array of Integer);
    property Cells[ACol, ARow: Integer]: string read GetCell;
    property OnGetText: TOnGetText read FOnGetText write FOnGetText;
    property OnGetHeader: TOnGetText read FOnGetHeader write FOnGetHeader;
    property OnEditButtonClick: TNotifyEvent read FOnEditButtonClick
      write SetOnEditButtonClick;
    property OnGetPickList: TGetPickListEvent read FOnGetPickList write FOnGetPickList;
    property OnValidate: TOnValidateEvent read FOnValidate write FOnValidate;
    property DropDownRows: Integer read FDropDownRows write SetDropDownRows default 8;
    property ColumnEditStyle[const ACol: Integer]: TEditStyle read GetColumnEditStyle
                                                              write SetColumnEditStyle;
    property CheckBoxes: Boolean read FCheckBoxes write SetCheckBoxes;
    property OnRowChecked: TOnRowChecked read FOnRowChecked write FOnRowChecked;
    property RecordCount: Integer read FRecordCount write SetRecordCount;
    property FieldCount: Integer read FFieldCount write SetFieldCount;
    property Provider: TDrawGridProvider read FProvider write SetProvider;


  end;

  TDrawGridProvider = class
  private
    FGrid: TDrawGrid;
    procedure SetGrid(const Value: TDrawGrid);
  protected
    function GetChecked(ARow: Integer): Boolean; virtual; abstract;
    procedure SetChecked(ARow: Integer; const Value: Boolean); virtual; abstract;
    procedure InitGrid(const Value: TDrawGrid); virtual;
  public
    destructor Destroy; override;
    procedure PrepareCanvas(Sender: TObject; ACol, ARow: Integer); virtual; abstract;
    function GetText(Sender: TObject; ACol, ARow: Integer; EditText: Boolean): string; virtual; abstract;
    function GetHeaderText(Sender: TObject; ACol: Integer): string; virtual; abstract;
    procedure SetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string); virtual; abstract;
    function CanEdit(Sender: TObject; ACol, ARow: Integer): Boolean; virtual;
    procedure GetPickList (Sender: TObject; ACol, ARow: Integer;
      Values: TStrings); virtual; abstract;
    function Validate(Sender: TObject; ACol, ARow: Longint;
      const Value: string): Boolean; virtual; abstract;
    procedure DrawCell(Canvas: TCanvas; ACol, ARow: Integer;
      ARect: TRect; AState: TGridDrawState; var Processed: Boolean); virtual; abstract;
    function SelectRow(Sender: TObject; ARow: Integer): Boolean; virtual; abstract;
    procedure InvalidateRecord(ARow: Integer);
    property Checked[ARow: Integer]: Boolean read GetChecked write SetChecked;
    property Grid: TDrawGrid read FGrid write SetGrid;
  end;

  TDrawGridProviderClass = class of TDrawGridProvider;
implementation
uses
  Vcl.Themes;

{ TDrawGrid }

function TDrawGrid.CanEditModify: Boolean;
begin
  Result := inherited;
  if (Col > 0) and (Row > 0)  then
    Result := Result and Assigned(FProvider) and FProvider.CanEdit (Self, Col-1, Row-1);
end;

function TDrawGrid.CreateEditor: TInplaceEdit;
begin
  FEditList := TInplaceEditList.Create(Self);
  FEditList.DropDownRows := FDropDownRows;
  FEditList.OnEditButtonClick := FOnEditButtonClick;
  FEditList.OnGetPickListitems := EditListGetItems;
  Result := FEditList;
end;

procedure TDrawGrid.CreateWnd;
begin
  inherited;
  SetScrollRange(Handle, SB_VERT, 0, 0, False);
end;

destructor TDrawGrid.Destroy;
begin
  SetProvider(nil);
  inherited;
end;

procedure TDrawGrid.DoExit;
begin
  try
    DoOnValidate;
  except
    SetFocus;
    raise;
  end;
  inherited;
  HideEdit;
end;

procedure TDrawGrid.DoOnValidate;
begin
//  if Assigned(FOnValidate) and (InplaceEditor <> nil) and InplaceEditor.Modified then
//  begin
//    FOnValidate(Self, Col, Row, GetCell(0, Row), GetCell(1, Row)); ///!!!
//  end;
end;

function RectVCenter(var R: TRect; Bounds: TRect): TRect;
begin
  OffsetRect(R, -R.Left, -R.Top);
  OffsetRect(R, 0, (Bounds.Height - R.Height) div 2);
  OffsetRect(R, Bounds.Left, Bounds.Top);
  Result := R;
end;

procedure DrawCheckBoxEx(Canvas: TCanvas; Checked, Pressed: Boolean; Rect: TRect);
var
   Style, h: Integer;
   Details: TThemedElementDetails;
   BoxSize: TSize;
   R: TRect;
begin
   if StyleServices.Available then
    begin
      if Pressed then
        begin
         if Checked then
           Details := StyleServices.GetElementDetails(tbCheckBoxCheckedPressed)
         else
           Details := StyleServices.GetElementDetails(tbCheckBoxUncheckedPressed);
        end
      else
        begin
         if Checked then
           Details := StyleServices.GetElementDetails(tbCheckBoxCheckedNormal)
         else
           Details := StyleServices.GetElementDetails(tbCheckBoxUncheckedNormal);
        end;
    R := System.Classes.Rect(0, 0, 20, 20);
    with StyleServices do
      if not GetElementSize(Canvas.Handle, GetElementDetails(tbCheckBoxCheckedNormal),
         R, esActual, BoxSize) then
      begin
        BoxSize.cx := 13;
        BoxSize.cy := 13;
      end;
    R := System.Classes.Rect(0, 0, BoxSize.cx, BoxSize.cy);
    Rect.Right := Rect.Left +  BoxSize.cx + 2;
    Rect.Left := Rect.Left +   2;
    RectVCenter(R, Rect);

     StyleServices.DrawElement(Canvas.Handle, Details, R);

   end
   else
   begin // with classic theme and flat view
      h := 0;
      if  Rect.Height > 17 then
        h := (Rect.Height - 17) div -2;
      InflateRect(Rect, 0, h);
     if Checked then
       Style := DFCS_CHECKED
     else
       Style := DFCS_BUTTONCHECK;
//    Style := Style or DFCS_FLAT;
     DrawFrameControl(Canvas.Handle, Rect, DFC_BUTTON, Style);
   end;

end;

procedure TDrawGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  CellText: string;
  Offset: Integer;
  r: TRect;
  BreakDrawText: Boolean;
  Checked: Boolean;
begin
  if StyleServices.Enabled then
    Offset := 4
  else
    Offset := 2;
  if ARow = 0 then
    begin
      CellText := Cells[ACol, ARow];
      Canvas.Font.Style := [fsBold];
      Canvas.TextRect(ARect, CellText, [tfCenter, tfVerticalCenter, tfSingleLine]);
    end else if FRecordCount > 0 then
  case ACol of
    0:
      begin
        CellText := IntToStr(ARow);
        r := ARect;
        Inc(r.Top, 2);
        Dec(r.Right, Offset);
        Canvas.TextRect(R,{ ARect.Left+Offset, ARect.Top+2,} CellText, [tfRight]);
        if FCheckBoxes then
          begin
            Checked := Assigned(FProvider) and FProvider.Checked[ARow-1];
            DrawCheckBoxEx(Canvas, Checked, FHotTrackCell.Pressed, ARect);
          end;
      end;
    else
      begin
        BreakDrawText := false;
        if Assigned(FProvider) then
          FProvider.DrawCell(Canvas, ACol-1, ARow-1, ARect, AState, BreakDrawText);
        if not BreakDrawText then
          begin
             CellText := Cells[ACol, ARow];
             Canvas.TextRect(ARect, ARect.Left+Offset, ARect.Top+2, CellText);
          end;
      end;
  end;
  inherited;
end;

procedure TDrawGrid.EditListGetItems(ACol, ARow: Integer; Items: TStrings);
begin
  if Assigned(FProvider) then
  begin
    Items.BeginUpdate;
    try
      FProvider.GetPickList(Self, ACol-1, ARow-1, Items);
      FEditList.PickListLoaded := Items.Count > 0;
    finally
      Items.EndUpdate;
    end;
  end
  else
    Items.Clear;
end;

procedure TDrawGrid.FixedCellClick(ACol, ARow: Longint);
begin
  inherited;
  if (ACol = 0) and Assigned(FProvider) then
    if  (ARow > 0)  then
      begin
        FProvider.Checked[ARow-1] := not FProvider.Checked[ARow-1]
      end
    else
      begin
        FCkeckedALL := not FCkeckedALL;
        for ARow := 0 to FRecordCount-1  do
          FProvider.Checked[ARow] := FCkeckedALL;
        InvalidateCol(ACol);
      end;
end;

function TDrawGrid.GetCell(ACol, ARow: Integer): string;
begin
  { TODO : Event }
  Result := '';
  if Assigned(FProvider) and (ACol > 0)  then
    begin
      if (ARow > 0) then
        Result := FProvider.GetText(Self, ACol-1, ARow-1, false) else
        Result := FProvider.GetHeaderText(Self, ACol-1);
    end
  else if (ACol = 0) and (ARow = 0) then
    Result := '¹';
end;

function TDrawGrid.GetColumnEditStyle(const ACol: Integer): TEditStyle;
begin
  if Length(FColumnEditStyle) < ColCount then
    Result := esSimple else
  Result := FColumnEditStyle[ACol+1];
end;

function TDrawGrid.GetEditStyle(ACol, ARow: Longint): TEditStyle;
//var
//  ItemProp: TItemProp;
begin
  Result := esSimple;
  if Length(FColumnEditStyle) > ACol then
    Result := FColumnEditStyle[ACol];
//  if (ACol <> 0) then
//  begin
//    ItemProp := FStrings.FindItemProp(ARow-FixedRows);
//    if Assigned(ItemProp) and (ItemProp.EditStyle <> esSimple) then
//      Result := ItemProp.EditStyle
//    else if GetPickList(EditList.PickList.Items) then
//      Result := esPickList;
//  end;
end;

function TDrawGrid.GetEditText(ACol, ARow: Integer): string;
begin
  Result := Cells[ACol, ARow];
  if Assigned(OnGetEditText) then OnGetEditText(Self, ACol, ARow, Result);
end;

procedure TDrawGrid.InvalidateRecord(ARow: Integer);
begin
  InvalidateRow(ARow+1);
end;

function TDrawGrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  Result := inherited;
  if Result and (Row <> ARow) and Assigned(FProvider) then
    Result := FProvider.SelectRow(Self, ARow-1)
end;

procedure TDrawGrid.SetCheckBoxes(const Value: Boolean);
begin
  FCheckBoxes := Value;
end;

procedure TDrawGrid.SetColumnEditStyle(const ACol: Integer;
  const Value: TEditStyle);
begin
  if Length(FColumnEditStyle) < ColCount then
    begin
      SetLength(FColumnEditStyle, ColCount);
//      FillChar();
    end;
  FColumnEditStyle[ACol+1] := Value;
end;

procedure TDrawGrid.SetColumnsWidth(const widths: array of Integer);
var
  i: Integer;
begin
  i := Length(widths);
  if i = 0 then
    ColCount := 2 else
    ColCount := i + 1;
  for I := 0 to Length(widths)-1 do
    ColWidths[i + 1] := widths[i];
  ColWidths[0] := 55;
  //Value.ClientWidth := 675 + GetSystemMetrics(SM_CXVSCROLL)+4;
end;

procedure TDrawGrid.SetDropDownRows(const Value: Integer);
begin
  FDropDownRows := Value;
  if Assigned(FEditList) then
    FEditList.DropDownRows := Value;
end;

procedure TDrawGrid.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  inherited;
  if Assigned(FProvider) then
    FProvider.SetEditText(Self, ACol-1, ARow-1, Value);
end;

procedure TDrawGrid.SetFieldCount(const Value: Integer);
begin
  if FFieldCount <> Value then
    begin
      FFieldCount := Value;
      if FFieldCount  > 0 then
        ColCount := Value + 1 else
        ColCount := 2;
    end;
end;

procedure TDrawGrid.SetOnEditButtonClick(const Value: TNotifyEvent);
begin
  FOnEditButtonClick := Value;
  if Assigned(FEditList) then
    FEditList.OnEditButtonClick := FOnEditButtonClick;
end;

procedure TDrawGrid.SetProvider(const Value: TDrawGridProvider);
var
  p: TDrawGridProvider;
begin
  if FProvider <> Value then
    begin
      p := FProvider;
      FProvider := nil;
      if Assigned(p) then
        p.SetGrid(nil);
      FProvider := Value;
      if Assigned(FProvider) then
        FProvider.SetGrid(Self);
    end;
end;

procedure TDrawGrid.SetRecordCount(const Value: Integer);
begin
  if FRecordCount <> Value then
    begin
      FRecordCount := Value;
      if FRecordCount = 0 then
        RowCount := 2 else
        begin
          RowCount := FRecordCount + 1;
          Row := 1;
        end;
    end;
end;

procedure TDrawGrid.SizeChanged(OldColCount, OldRowCount: Longint);
var
  DrawInfo: TGridDrawInfo;
  sum, lastw,  i: Integer;
begin
  inherited;     exit;

  CalcDrawInfo(DrawInfo);

  if DrawInfo.Horz.GridBoundary < DrawInfo.Horz.GridExtent then
    lastw := ColWidths[ColCount-1] +  DrawInfo.Horz.GridExtent - DrawInfo.Horz.GridBoundary
  else
    lastw :=  DrawInfo.Horz.GridBoundary - DrawInfo.Horz.FullVisBoundary;
  if (lastw <> 0)   then
    ColWidths[ColCount-1] := lastw;
end;

{ TDrawGridExProvider }

function TDrawGridProvider.CanEdit(Sender: TObject; ACol,
  ARow: Integer): Boolean;
begin
  Result := false;
end;

destructor TDrawGridProvider.Destroy;
begin
  SetGrid(nil);
  inherited;
end;

procedure TDrawGridProvider.InitGrid(const Value: TDrawGrid);
begin
  Value.CheckBoxes := true;
end;

procedure TDrawGridProvider.InvalidateRecord(ARow: Integer);
begin
  grid.InvalidateRecord(ARow);
end;

procedure TDrawGridProvider.SetGrid(const Value: TDrawGrid);
var
  g: TDrawGrid;
begin
  if FGrid <> Value then
    begin
      g := FGrid;
      FGrid := nil;
      if Assigned(g) then
        g.SetProvider(nil);
      FGrid := Value;
      if Assigned(FGrid) then
        begin
          FGrid.SetProvider(Self);
          InitGrid(FGrid);
        end;
    end;
end;

end.
