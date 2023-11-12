unit dsdExportToXLSAction;

interface

uses Data.DB, System.Classes, System.SysUtils, System.Win.ComObj, System.StrUtils,
     Vcl.Graphics, Vcl.ActnList, Vcl.Dialogs, dsdAction, dsdDB, Variants;

type

  TdsdOrientationType = (orPortrait, orLandscape);
  TdsdCalcColumnType = (ccNone, ccSumma, ccMultiplication, ccDivision, ccPercent, ccMulDiv);
  TdsdKindType = (skNone, skSumma, skMax, skMin, skAverage, skText);
  TdsdFileType = (ftOpenXMLWorkbook, ftExcel8);

  TdsdExportToXLS = class;

  TdsdCalcColumnList = class (TCollectionItem)
  private
    FFieldName: String;
    FColumnPos: Integer;
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property FieldName: String read FFieldName write FFieldName;
  end;

  TdsdCalcColumnLists = class (TOwnedCollection)
  private
    function GetItem(Index: Integer): TdsdCalcColumnList;
    procedure SetItem(Index: Integer; const Value: TdsdCalcColumnList);
  public
    function Add: TdsdCalcColumnList;
    property Items[Index: Integer]: TdsdCalcColumnList read GetItem write SetItem; default;
  end;

  TdsdDetailedText = class (TCollectionItem)
  private
    FFieldName: String;
    FFont: TFont;
    FFieldExists : boolean;
  protected
    procedure SetFont(Value: TFont);
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property FieldName: String read FFieldName write FFieldName;
    property Font: TFont read FFont write SetFont;
  end;

  TdsdDetailedTexts = class (TOwnedCollection)
  private
    function GetItem(Index: Integer): TdsdDetailedText;
    procedure SetItem(Index: Integer; const Value: TdsdDetailedText);
  public
    function Add: TdsdDetailedText;
    property Items[Index: Integer]: TdsdDetailedText read GetItem write SetItem; default;
  end;

  TdsdColumnParam = class (TCollectionItem)
  private
    FCaption: String;
    FFieldName: String;
    FDataType: TFieldType;
    FDecimalPlace : Integer;
    FFont: TFont;
    FWidth : Integer;
    FWrapText : Boolean;
    FCalcColumn : TdsdCalcColumnType;
    FCalcColumnLists : TdsdCalcColumnLists;
    FDetailedTexts : TdsdDetailedTexts;
    FRound : boolean;
    FKind : TdsdKindType;
    FKindText: String;
    FExportToXLSAction : TdsdExportToXLS;
    FFieldExists : boolean;
    FTitleFont: TFont;
  protected
    procedure SetFont(Value: TFont);
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetFormula: string;
  published
    property Caption: String read FCaption write FCaption;
    property FieldName: String read FFieldName write FFieldName;
    property DataType: TFieldType read FDataType write FDataType default ftString;
    property DecimalPlace : Integer read FDecimalPlace write FDecimalPlace;
    property Font: TFont read FFont write SetFont;
    property Width : Integer read FWidth write FWidth default 10;
    property WrapText : Boolean read FWrapText write FWrapText default False;
    property CalcColumn : TdsdCalcColumnType read FCalcColumn write FCalcColumn default ccNone;
    property CalcColumnLists : TdsdCalcColumnLists read FCalcColumnLists write FCalcColumnLists;
    property DetailedTexts : TdsdDetailedTexts read FDetailedTexts write FDetailedTexts;
    property Round : boolean read FRound write FRound default True;
    property Kind : TdsdKindType read FKind write FKind default skNone;
    property KindText: String read FKindText write FKindText;
    property ExportToXLSAction : TdsdExportToXLS read FExportToXLSAction;
  end;

  TdsdColumnParams = class (TOwnedCollection)
  private
    function GetItem(Index: Integer): TdsdColumnParam;
    procedure SetItem(Index: Integer; const Value: TdsdColumnParam);
  public
    function Add: TdsdColumnParam;
    property Items[Index: Integer]: TdsdColumnParam read GetItem write SetItem; default;
  end;

  TdsdExportToXLS = class(TdsdCustomAction)
  private
    FTitleDataSet: TDataSet;
    FItemsDataSet: TDataSet;
    FSignDataSet: TDataSet;
    FOrientation : TdsdOrientationType;
    FTitle: String;
    FFileName: String;
    FFileNameParam: TdsdParam;
    FTitleHeight : Currency;
    FSignHeight : Currency;
    FTitleFont: TFont;
    FHeaderFont: TFont;
    FSignFont: TFont;
    FFooter : boolean;
    FNumberColumn : boolean;
    FColumnParams : TdsdColumnParams;
    FFileType : TdsdFileType;
    FSheetName : string;
    FAccelerateDraw : Boolean;
    procedure SetTitleFont(Value: TFont);
    procedure SetHeaderFont(Value: TFont);
    procedure SetSignFont(Value: TFont);
    procedure SetItemsDataSet(const Value: TDataSet);
    procedure SetTitleDataSet(const Value: TDataSet);
    procedure SetSignDataSet(const Value: TDataSet);
    procedure SetFileName(const Value: string);
    function GetFileName: string;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ColumnNumber(AFieldName : string) : integer;
    function ExistsColumn(AFieldName : string) : Boolean;
  published
    property ItemsDataSet: TDataSet read FItemsDataSet write SetItemsDataSet;
    property TitleDataSet: TDataSet read FTitleDataSet write SetTitleDataSet;
    property SignDataSet: TDataSet read FSignDataSet write SetSignDataSet;
    property Title: String read FTitle write FTitle;
    property FileName: string read GetFileName write SetFileName;
    property FileNameParam: TdsdParam read FFileNameParam write FFileNameParam;
    property TitleHeight : Currency read FTitleHeight write FTitleHeight;
    property SignHeight : Currency read FSignHeight write FSignHeight;
    property Orientation : TdsdOrientationType read FOrientation write FOrientation default orPortrait;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property SignFont: TFont read FSignFont write SetSignFont;
    property Footer : boolean  read FFooter write FFooter default True;
    property ColumnParams : TdsdColumnParams read FColumnParams write FColumnParams;
    property FileType : TdsdFileType read FFileType write FFileType default ftOpenXMLWorkbook;
    property SheetName : string read FSheetName write FSheetName;
    property NumberColumn : boolean read FNumberColumn write FNumberColumn default False;
    property AccelerateDraw : Boolean read FAccelerateDraw write FAccelerateDraw default False;

    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
  end;


implementation

  { TdsdCalcColumnList }

procedure TdsdCalcColumnList.Assign(Source: TPersistent);
begin
  if Source is TdsdCalcColumnList then
  begin
     Self.FFieldName := TdsdCalcColumnList(Source).FieldName;
  end else
    inherited; //raises an exception
end;

function TdsdCalcColumnList.GetDisplayName: string;
begin
  if FFieldName <> '' then
     Result := FieldName
  else
     Result := inherited;
end;

  { TdsdCalcColumnLists }

function TdsdCalcColumnLists.Add: TdsdCalcColumnList;
begin
  result := TdsdCalcColumnList(inherited Add);
end;

function TdsdCalcColumnLists.GetItem(Index: Integer): TdsdCalcColumnList;
begin
  Result := TdsdCalcColumnList(inherited GetItem(Index));
end;

procedure TdsdCalcColumnLists.SetItem(Index: Integer; const Value: TdsdCalcColumnList);
begin
  inherited SetItem(Index, Value);
end;

  { TdsdDetailedText }

constructor TdsdDetailedText.Create(Collection: TCollection);
begin
  inherited;
  FFont := TFont.Create;
  FFieldExists := True;
end;

destructor TdsdDetailedText.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TdsdDetailedText.Assign(Source: TPersistent);
begin
  if Source is TdsdDetailedText then
  begin
     Self.FFieldName := TdsdDetailedText(Source).FieldName;
  end else
    inherited; //raises an exception
end;

function TdsdDetailedText.GetDisplayName: string;
  var I, J : integer;
begin
  if FFieldName <> '' then
     Result := FieldName
  else
     Result := inherited;
end;

procedure TdsdDetailedText.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

  { TdsdDetailedTexts }

function TdsdDetailedTexts.Add: TdsdDetailedText;
begin
  result := TdsdDetailedText(inherited Add);
end;

function TdsdDetailedTexts.GetItem(Index: Integer): TdsdDetailedText;
begin
  Result := TdsdDetailedText(inherited GetItem(Index));
end;

procedure TdsdDetailedTexts.SetItem(Index: Integer; const Value: TdsdDetailedText);
begin
  inherited SetItem(Index, Value);
end;

  { TdsdColumnParam }

constructor TdsdColumnParam.Create(Collection: TCollection);
begin
  inherited;
  FFont := TFont.Create;
  FCalcColumnLists := TdsdCalcColumnLists.Create(Self, TdsdCalcColumnList);
  FDetailedTexts := TdsdDetailedTexts.Create(Self, TdsdDetailedText);
  FWidth := 10;
  FWrapText := False;
  FFieldExists := True;
  FRound := True;
  FDataType := ftString;
  if Collection.Owner is TdsdExportToXLS then
    FExportToXLSAction := TdsdExportToXLS(Collection.Owner);
end;

destructor TdsdColumnParam.Destroy;
begin
  FFont.Free;
  FDetailedTexts.Free;
  FCalcColumnLists.Free;
  inherited;
end;

procedure TdsdColumnParam.Assign(Source: TPersistent);
begin
  if Source is TdsdColumnParam then
  begin
     Self.FCaption := TdsdColumnParam(Source).Caption;
     Self.FFieldName := TdsdColumnParam(Source).FieldName;
     Self.FDataType := TdsdColumnParam(Source).DataType;
  end else
    inherited; //raises an exception
end;

function TdsdColumnParam.GetDisplayName: string;
  var I, J : integer;
begin
  if FCalcColumn <> ccNone then
  begin
    Result := '='; J := 0;

    for I := 0 to FCalcColumnLists.Count - 1 do
    begin
      if FCalcColumnLists.Items[I].DisplayName <> '' then
      begin
        if J = 0 then Result := Result + FCalcColumnLists.Items[I].DisplayName
        else case FCalcColumn of
          ccSumma : Result := Result + ' + ' + FCalcColumnLists.Items[I].DisplayName;
          ccMultiplication : Result := Result + ' * ' + FCalcColumnLists.Items[I].DisplayName;
          ccDivision : Result := Result + ' / ' + FCalcColumnLists.Items[I].DisplayName;
          ccPercent : begin
                        Result := Result + ' + ' + FCalcColumnLists.Items[I].DisplayName + ' * 100';
                        Break;
                      end;
          ccMulDiv : begin
                       case J of
                         1 : Result := Result + ' * ' + FCalcColumnLists.Items[I].DisplayName;
                         2 : Result := Result + ' / ' + FCalcColumnLists.Items[I].DisplayName;
                         else Break;
                       end;
                     end;
        end;
        Inc(J);
      end;
    end;
  end else if FFieldName <> '' then
     Result := FieldName
  else
     Result := inherited;
end;

procedure TdsdColumnParam.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

function TdsdColumnParam.GetFormula: string;
  var I, J, C : integer; S, P : string;
begin
  Result := ''; S := ''; J := 0;
  if not Assigned(FExportToXLSAction) then Exit;

  for I := 0 to FCalcColumnLists.Count - 1 do
  begin
    if (FCalcColumnLists.Items[I].DisplayName <> '') and
      FExportToXLSAction.ExistsColumn(FCalcColumnLists.Items[I].DisplayName) then
    begin
      C := FExportToXLSAction.ColumnNumber(FCalcColumnLists.Items[I].DisplayName);
      if C = Index then Continue;

      P := IntToStr(C - Index);

      if FCalcColumn = ccSumma then P := 'IF(ISNUMBER(RC[' + P + ']),RC[' + P + '],0)'
      else P := 'IF(ISNUMBER(RC[' + P + ']),RC[' + P + '],1)';

      if J = 0 then S := S + P
      else case FCalcColumn of
        ccSumma : S := S + ' + ' + P;
        ccMultiplication : S := S + ' * ' + P;
        ccDivision : S := S + ' / ' + P;
        ccPercent : begin
                      S := S + ' / ' + P + ' * 100';
                      Break;
                    end;
        ccMulDiv : begin
                     case J of
                       1 : S := S + ' * ' + P;
                       2 : S := S + ' / ' + P;
                       else Break;
                     end;
                   end;
      end;
      Inc(J);
    end;
  end;

  if S <> '' then
  begin
    if FRound then
      Result := '=ROUND(' + S + ',' + IntToStr(FDecimalPlace) + ')'
    else Result := '=' + S;
  end;
end;

  { TdsdColumnParams }

function TdsdColumnParams.Add: TdsdColumnParam;
begin
  result := TdsdColumnParam(inherited Add);
end;

function TdsdColumnParams.GetItem(Index: Integer): TdsdColumnParam;
begin
  Result := TdsdColumnParam(inherited GetItem(Index));
end;

procedure TdsdColumnParams.SetItem(Index: Integer; const Value: TdsdColumnParam);
begin
  inherited SetItem(Index, Value);
end;

  {TdsdExportToXLS}

constructor TdsdExportToXLS.Create(AOwner: TComponent);
begin
  inherited;
  FColumnParams := TdsdColumnParams.Create(Self, TdsdColumnParam);
  FTitleFont := TFont.Create;
  FHeaderFont := TFont.Create;
  FSignFont := TFont.Create;
  FFileNameParam := TdsdParam.Create(nil);
  FFileNameParam.DataType := ftString;
  FFileNameParam.Value := '';
  FFileName := '';
  FTitleHeight := 1;
  FSignHeight := 1;
  FFooter := True;
  FFileType := ftOpenXMLWorkbook;
  FSheetName := '';
  FNumberColumn := False;
  FAccelerateDraw := False;
end;

destructor TdsdExportToXLS.Destroy;
begin
  FTitleFont.Free;
  FHeaderFont.Free;
  FSignFont.Free;
  FColumnParams.Free;
  FFileNameParam.Free;
  inherited;
end;

procedure TdsdExportToXLS.SetItemsDataSet(const Value: TDataSet);
begin
  FItemsDataSet := Value;
end;

procedure TdsdExportToXLS.SetTitleDataSet(const Value: TDataSet);
begin
  FTitleDataSet := Value;
end;

procedure TdsdExportToXLS.SetSignDataSet(const Value: TDataSet);
begin
  FSignDataSet := Value;
end;

procedure TdsdExportToXLS.SetTitleFont(Value: TFont);
begin
  FTitleFont.Assign(Value);
end;

procedure TdsdExportToXLS.SetHeaderFont(Value: TFont);
begin
  FHeaderFont.Assign(Value);
end;

procedure TdsdExportToXLS.SetSignFont(Value: TFont);
begin
  FSignFont.Assign(Value);
end;

procedure TdsdExportToXLS.SetFileName(const Value: string);
begin
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) then
    ShowMessage('Используйте FormNameParam')
  else
    FFileName := Value;
end;

function TdsdExportToXLS.GetFileName: string;
begin
  result := FFileNameParam.AsString;
  if result = '' then
    result := FFileName
end;


function TdsdExportToXLS.ColumnNumber(AFieldName : string) : integer;
  var I : integer;
begin
  Result := -1;

  for I := 0 to FColumnParams.Count - 1 do
    if LowerCase(FColumnParams.Items[I].DisplayName) = LowerCase(AFieldName) then
  begin
    Result := I;
    Break;
  end;
end;

function TdsdExportToXLS.ExistsColumn(AFieldName : string) : Boolean;
  var I : integer;
begin
  Result := False;

  for I := 0 to FColumnParams.Count - 1 do
    if LowerCase(FColumnParams.Items[I].DisplayName) = LowerCase(AFieldName) then
  begin
    Result := True;
    Break;
  end;
end;

function TdsdExportToXLS.LocalExecute: Boolean;
 var xlApp, xlBook, xlSheet, xlRange: OLEVariant;
     nTitleCount,  // Строк заголовка отчета
     nHeadGrid,    // Начало шапки грида
     nHeadCount,   // Строк шапки грида
     nDataStart,   // Начало данных
     nDataCount,   // Количество строк данных
     nColumnCount, // Количество колонок
     nSignCount,   // Количество строк подписи
     I, J, L, P : Integer;
     nCurr : Extended;
     cFileName, S : string;
     i64 : Currency;
     aData: Variant;

 const xlLeft = - 4131;
       xlRight = -4152;
       xlCenter = -4108;
       xlTop = -4160;
       xlBottom = -4107;
       xlEdgeLeft = 7;
       xlEdgeTop = 8;
       xlEdgeBottom = 9;
       xlEdgeRight = 10;
       xlInsideVertical = 11;
       xlInsideHorizontal = 12;
       xlThin = 2;
       xlMedium = -4138;
       xlLandscape = 2;
       xlPortrait = 1;
       xlMaximized = -4137;
       xlMinimized = -4140;
       xlNormal = -4143;
       xlExcel8	= 56;
       xlOpenXMLWorkbook = 51;

  function GetThousandSeparator : string;
  begin
    if FormatSettings.ThousandSeparator = #160 then Result :=  ' '
    else Result := FormatSettings.ThousandSeparator;
  end;

  function CharReplay(AChar : Char; ACount : Integer) : string;
    var I : integer;
  begin
    Result := '';
    for I := 1 to ACount do Result := Result + AChar;
  end;

begin
  inherited;
  Result := False;

  if FItemsDataSet = Nil then
  begin
    raise Exception.Create('Не определен ItemsDataSet..');
    Exit;
  end;

  if not FItemsDataSet.Active then
  begin
    raise Exception.Create('ItemsDataSet не открыт..');
    Exit;
  end;

  try
     xlApp := GetActiveOleObject('Excel.Application');
  except
    try
      xlApp:=CreateOleObject('Excel.Application');
    except
      raise Exception.Create('Ошибка подключения к Excel.Application! Убедитесь, что на компьютере установлен Excel..');
      Exit;
    end;
  end;

  try
    xlApp.Application.ScreenUpdating := false;
    xlApp.DisplayAlerts := false;
    xlBook := xlApp.WorkBooks.Add;
    xlSheet := xlBook.ActiveSheet;

    try
      case FOrientation of
        orPortrait : xlSheet.PageSetup.Orientation := xlPortrait;
        orLandscape : xlSheet.PageSetup.Orientation := xlLandscape;
      end;
    except
    end;


{    xlApp.ActiveWindow.SplitColumn := 2;
    xlApp.ActiveWindow.SplitRow := 1;
    xlApp.ActiveWindow.FreezePanes := true;}

    nTitleCount := 0;
    nHeadGrid := 1;
    nHeadCount := 1;
    nDataStart := 1;
    nDataCount := 0;
    nSignCount := 0;

    if FColumnParams.Count > 0 then
      nColumnCount := FColumnParams.Count
    else nColumnCount := FItemsDataSet.FieldCount;

      // Заголовок отчета
    if Assigned(FTitleDataSet) and FTitleDataSet.Active and (FTitleDataSet.RecordCount > 0) then
    begin
      FTitleDataSet.First;
      while not FTitleDataSet.Eof do
      begin
        Inc(nTitleCount);
        Inc(nHeadGrid);
        Inc(nDataStart);

        xlSheet.Rows[nTitleCount].RowHeight := xlSheet.Rows[nTitleCount].RowHeight * FTitleHeight;
        xlRange := xlSheet.Range[xlSheet.Cells[nTitleCount, 1], xlSheet.Cells[nTitleCount, nColumnCount]];
        xlRange.Merge;
        xlRange := xlSheet.Cells[nTitleCount, 1];
        xlRange.Value := FTitleDataSet.Fields.Fields[0].AsString;
        // для проекта Project
        if Self.name = 'actExportToXLS_project'
        then if nTitleCount = 1
             then xlRange.HorizontalAlignment := xlCenter
             else xlRange.HorizontalAlignment := xlLeft
        else xlRange.HorizontalAlignment := xlCenter;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Name := FTitleFont.Name;
        xlRange.Font.Size := FTitleFont.Size;
        xlRange.Font.Color := FTitleFont.Color;
        xlRange.Font.Bold := fsBold in FTitleFont.Style;
        xlRange.Font.Italic := fsItalic in FTitleFont.Style;
        xlRange.Font.Underline := fsUnderline in FTitleFont.Style;

        FTitleDataSet.Next;
      end;
    end else If Trim(FTitle) <> '' then
    begin
      Inc(nTitleCount);
      Inc(nHeadGrid);
      Inc(nDataStart);

      xlSheet.Rows[nTitleCount].RowHeight := xlSheet.Rows[nTitleCount].RowHeight * FTitleHeight;
      xlRange := xlSheet.Range[xlSheet.Cells[nTitleCount, 1], xlSheet.Cells[nTitleCount, nColumnCount]];
      xlRange.Merge;
      xlRange := xlSheet.Cells[nTitleCount, 1];
      xlRange.Value := FTitle;
      xlRange.HorizontalAlignment := xlCenter;
      xlRange.VerticalAlignment := xlCenter;
      xlRange.WrapText:=true;
      xlRange.Font.Name := FTitleFont.Name;
      xlRange.Font.Size := FTitleFont.Size;
      xlRange.Font.Color := FTitleFont.Color;
      xlRange.Font.Bold := fsBold in FTitleFont.Style;
      xlRange.Font.Italic := fsItalic in FTitleFont.Style;
      xlRange.Font.Underline := fsUnderline in FTitleFont.Style;
    end;

      // Заголовки столбцов
    if FColumnParams.Count > 0 then
    begin
      for I := 0 to nColumnCount - 1 do
      begin
        xlSheet.Columns[I + 1].ColumnWidth := FColumnParams.Items[I].Width;

        xlRange := xlSheet.Cells[nDataStart, I + 1];
        xlRange.Value := FColumnParams.Items[I].Caption;
        xlRange.HorizontalAlignment := xlCenter;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Name := FHeaderFont.Name;
        xlRange.Font.Size := FHeaderFont.Size;
        xlRange.Font.Color := FHeaderFont.Color;
        xlRange.Font.Bold := fsBold in FHeaderFont.Style;
        xlRange.Font.Italic := fsItalic in FHeaderFont.Style;
        xlRange.Font.Underline := fsUnderline in FHeaderFont.Style;

        if FColumnParams.Items[I].FieldName <> '' then
          FColumnParams.Items[I].FFieldExists := Assigned(FItemsDataSet.FindField(FColumnParams.Items[I].FieldName))
        else FColumnParams.Items[I].FFieldExists := False;
        for J := 0 to FColumnParams.Items[I].DetailedTexts.Count - 1 do
          if FColumnParams.Items[I].DetailedTexts.Items[L].FieldName <> '' then
            FColumnParams.Items[I].DetailedTexts.Items[L].FFieldExists := Assigned(FItemsDataSet.FindField(FColumnParams.Items[I].DetailedTexts.Items[L].FieldName))
          else FColumnParams.Items[I].DetailedTexts.Items[L].FFieldExists := False;
      end;
    end else
    begin
      for I := 0 to nColumnCount - 1 do
      begin
        xlRange := xlSheet.Cells[nDataStart, I + 1];
        xlRange.Value := FItemsDataSet.Fields.Fields[I].DisplayName;
        xlRange.HorizontalAlignment := xlCenter;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Name := FHeaderFont.Name;
        xlRange.Font.Size := FHeaderFont.Size;
        xlRange.Font.Color := FHeaderFont.Color;
        xlRange.Font.Bold := fsBold in FHeaderFont.Style;
        xlRange.Font.Italic := fsItalic in FHeaderFont.Style;
        xlRange.Font.Underline := fsUnderline in FHeaderFont.Style;
      end;
    end;
    Inc(nDataStart);

      // Номерация столбцов
    if FNumberColumn then
    begin
      for I := 0 to nColumnCount - 1 do
      begin
        xlRange := xlSheet.Cells[nDataStart, I + 1];
        xlRange.Value := IntToStr(I + 1);
        xlRange.HorizontalAlignment := xlCenter;
        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Name := FHeaderFont.Name;
        xlRange.Font.Size := FHeaderFont.Size;
        xlRange.Font.Color := FHeaderFont.Color;
        xlRange.Font.Bold := fsBold in FHeaderFont.Style;
        xlRange.Font.Italic := fsItalic in FHeaderFont.Style;
        xlRange.Font.Underline := fsUnderline in FHeaderFont.Style;
      end;
      Inc(nDataStart);
      Inc(nHeadCount);
    end;

      // Данные
    aData := VarArrayCreate([1, FItemsDataSet.RecordCount, 1, nColumnCount], varVariant);
    FItemsDataSet.First;
    while not FItemsDataSet.Eof do
    begin

      if FAccelerateDraw then
      begin
        if FColumnParams.Count > 0 then
        begin
          for I := 0 to nColumnCount - 1 do
          begin
            if (FColumnParams.Items[I].FCalcColumn = ccNone) and FColumnParams.Items[I].FFieldExists then
            begin
              if not FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).IsNull then
                case FColumnParams.Items[I].DataType of
                  ftAutoInc, ftLargeint : aData[FItemsDataSet.RecNo, I + 1] := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsExtended;
                  ftSmallint, ftInteger, ftWord, ftBytes : aData[FItemsDataSet.RecNo, I + 1] := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsInteger;
                  ftDate, ftTime, ftDateTime : aData[FItemsDataSet.RecNo, I + 1] := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsDateTime;
                  ftFloat, ftCurrency, ftBCD : if FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).DataType in [ftFloat, ftCurrency, ftBCD] then
                                                 aData[FItemsDataSet.RecNo, I + 1] := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsExtended
                                               else if TryStrToFloat(StringReplace(FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsString, '.',
                                                      FormatSettings.DecimalSeparator, [rfReplaceAll]), nCurr) then aData[FItemsDataSet.RecNo, I + 1] := nCurr
                                                    else aData[FItemsDataSet.RecNo, I + 1] := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsString;
                  ftBoolean : aData[FItemsDataSet.RecNo, I + 1] := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsBoolean;
                  else
                  begin
                    aData[FItemsDataSet.RecNo, I + 1] := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsString;
                  end;
                end;
            end;
          end;
        end else
        begin
          for I := 0 to nColumnCount - 1 do
          begin
            xlRange := xlSheet.Cells[nDataStart + nDataCount, I + 1];
            if FItemsDataSet.Fields.Fields[I].DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint, ftBytes, ftFloat, ftCurrency, ftBCD] then
               xlRange.HorizontalAlignment := xlRight
            else xlRange.HorizontalAlignment := xlLeft;
            if not FItemsDataSet.Fields.Fields[I].IsNull then
              case FItemsDataSet.Fields.Fields[I].DataType of
                ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint, ftBytes : xlRange.Value := FItemsDataSet.Fields.Fields[I].AsLargeInt;
                ftDate, ftTime, ftDateTime : xlRange.Value := FItemsDataSet.Fields.Fields[I].AsDateTime;
                ftFloat, ftCurrency, ftBCD : xlRange.Value := FItemsDataSet.Fields.Fields[I].AsExtended;
                ftBoolean : xlRange.Value := FItemsDataSet.Fields.Fields[I].AsBoolean;
                else
                begin
                  xlRange.NumberFormat := AnsiChar(64);
                  xlRange.Value := FItemsDataSet.Fields.Fields[I].AsString;
                  xlRange.NumberFormat := '';
                end;
              end;
          end;
        end;
      end else
      begin
        if FColumnParams.Count > 0 then
        begin
          for I := 0 to nColumnCount - 1 do
          begin
            xlRange := xlSheet.Cells[nDataStart + nDataCount, I + 1];
            if (FColumnParams.Items[I].FCalcColumn = ccNone) and FColumnParams.Items[I].FFieldExists then
            begin
              if not FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).IsNull then
                case FColumnParams.Items[I].DataType of
                  ftAutoInc, ftLargeint : xlRange.Value := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsExtended;
                  ftSmallint, ftInteger, ftWord, ftBytes : xlRange.Value := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsInteger;
                  ftDate, ftTime, ftDateTime : xlRange.Value := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsDateTime;
                  ftFloat, ftCurrency, ftBCD : if FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).DataType in [ftFloat, ftCurrency, ftBCD] then
                                                 xlRange.Value := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsExtended
                                               else if TryStrToFloat(StringReplace(FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsString, '.',
                                                      FormatSettings.DecimalSeparator, [rfReplaceAll]), nCurr) then xlRange.Value := nCurr
                                                    else xlRange.Value := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsString;
                  ftBoolean : xlRange.Value := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsBoolean;
                  else
                  begin
                    xlRange.NumberFormat := AnsiChar(64);
                    xlRange.FormulaR1C1 := FItemsDataSet.FieldByName(FColumnParams.Items[I].FieldName).AsString;
                    xlRange.NumberFormat := '';
                  end;
                end;
            end;
          end;
        end else
        begin
          for I := 0 to nColumnCount - 1 do
          begin
            xlRange := xlSheet.Cells[nDataStart + nDataCount, I + 1];
            if FItemsDataSet.Fields.Fields[I].DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint, ftBytes, ftFloat, ftCurrency, ftBCD] then
               xlRange.HorizontalAlignment := xlRight
            else xlRange.HorizontalAlignment := xlLeft;
            if not FItemsDataSet.Fields.Fields[I].IsNull then
              case FItemsDataSet.Fields.Fields[I].DataType of
                ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint, ftBytes : xlRange.Value := FItemsDataSet.Fields.Fields[I].AsLargeInt;
                ftDate, ftTime, ftDateTime : xlRange.Value := FItemsDataSet.Fields.Fields[I].AsDateTime;
                ftFloat, ftCurrency, ftBCD : xlRange.Value := FItemsDataSet.Fields.Fields[I].AsExtended;
                ftBoolean : xlRange.Value := FItemsDataSet.Fields.Fields[I].AsBoolean;
                else
                begin
                  xlRange.NumberFormat := AnsiChar(64);
                  xlRange.Value := FItemsDataSet.Fields.Fields[I].AsString;
                  xlRange.NumberFormat := '';
                end;
              end;
          end;
        end;
      end;

      Inc(nDataCount);
      FItemsDataSet.Next;
    end;

    if FAccelerateDraw then
    begin
      //выделяем диапазон для вставки данных
      xlRange := xlSheet.Range[xlSheet.Cells[nDataStart, 1], xlSheet.Cells[nDataStart + nDataCount - 1, nColumnCount]];
      //вставляем данные
      xlRange.Value := aData;
    end;

      // Рисуем рамку вокруг шапки
    xlRange := xlSheet.Range[xlSheet.Cells[nHeadGrid, 1], xlSheet.Cells[nHeadGrid + nHeadCount - 1, nColumnCount]];
    xlRange.Borders[xlEdgeLeft].Weight := xlMedium;
    xlRange.Borders[xlEdgeTop].Weight := xlMedium;
    xlRange.Borders[xlEdgeRight].Weight := xlMedium;
    xlRange.Borders[xlEdgeBottom].Weight := xlMedium;
    xlRange.Borders[xlInsideVertical].Weight := xlThin;
    xlRange.Borders[xlInsideHorizontal].Weight := xlThin;

      // Рисуем рамку вокруг данных
    xlRange := xlSheet.Range[xlSheet.Cells[nDataStart, 1], xlSheet.Cells[nDataStart + nDataCount - 1, nColumnCount]];
    xlRange.Borders[xlEdgeLeft].Weight := xlMedium;
    xlRange.Borders[xlEdgeTop].Weight := xlMedium;
    xlRange.Borders[xlEdgeRight].Weight := xlMedium;
    xlRange.Borders[xlEdgeBottom].Weight := xlMedium;
    xlRange.Borders[xlInsideVertical].Weight := xlThin;
    xlRange.Borders[xlInsideHorizontal].Weight := xlThin;


    // НЕ для проекта Project
    if Self.name <> 'actExportToXLS_project'
    then begin
      // Форматируем данные
      if FColumnParams.Count > 0 then
        begin
          J := 1;
          for I := 0 to nColumnCount - 1 do
          begin
            xlRange := xlSheet.Range[xlSheet.Cells[nDataStart, I + 1], xlSheet.Cells[nDataStart + nDataCount - 1, I + 1]];

            case FColumnParams.Items[I].DataType of
              ftDate, ftTime, ftDateTime : xlRange.Value := '';
              ftFloat, ftCurrency, ftBCD : if FColumnParams.Items[I].DecimalPlace > 0 then
                                              xlRange.NumberFormat := '#' + GetThousandSeparator + '##0' + FormatSettings.DecimalSeparator +
                                                                   CharReplay('0', FColumnParams.Items[I].DecimalPlace)
                                           else xlRange.NumberFormat := 'General';
            end;

            if FColumnParams.Items[I].CalcColumn <> ccNone then
              xlRange.FormulaR1C1 := FColumnParams.Items[I].GetFormula;

            if FColumnParams.Items[I].WrapText then xlRange.WrapText:=true;
            if FColumnParams.Items[I].DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint, ftBytes, ftFloat, ftCurrency, ftBCD] then
               xlRange.HorizontalAlignment := xlRight
            else xlRange.HorizontalAlignment := xlLeft;
            xlRange.VerticalAlignment := xlCenter;

            xlRange.Font.Name := FColumnParams.Items[I].Font.Name;
            xlRange.Font.Size := FColumnParams.Items[I].Font.Size;
            xlRange.Font.Color := FColumnParams.Items[I].Font.Color;
            xlRange.Font.Bold := fsBold in FColumnParams.Items[I].Font.Style;
            xlRange.Font.Italic := fsItalic in FColumnParams.Items[I].Font.Style;
            xlRange.Font.Underline := fsUnderline in FColumnParams.Items[I].Font.Style;

            if FFooter and (FColumnParams.Items[I].FKind <> skNone) then
            begin
              xlRange := xlSheet.Range[xlSheet.Cells[nDataStart + nDataCount, J], xlSheet.Cells[nDataStart + nDataCount, I + 1]];
              xlRange.Merge;
              xlRange.VerticalAlignment := xlCenter;
              xlRange.HorizontalAlignment := xlRight;
              if FColumnParams.Items[I].DataType in [ftFloat, ftCurrency, ftBCD] then
              begin
                if FColumnParams.Items[I].DecimalPlace > 0 then
                   xlRange.NumberFormat := '#' + GetThousandSeparator + '##0' + FormatSettings.DecimalSeparator +
                                        CharReplay('0', FColumnParams.Items[I].DecimalPlace)
                else xlRange.NumberFormat := 'General';
              end;
              case FColumnParams.Items[I].Kind of
                skSumma : xlRange.FormulaR1C1 := '=SUM(R[-' + IntToStr(nDataCount) + ']C[' + IntToStr(I - J + 1) + ']:R[-1]C[' + IntToStr(I - J + 1) + '])';
                skMax : xlRange.FormulaR1C1 := '=MAX(R[-' + IntToStr(nDataCount) + ']C[' + IntToStr(I - J + 1) + ']:R[-1]C[' + IntToStr(I - J + 1) + '])';
                skMin : xlRange.FormulaR1C1 := '=MIN(R[-' + IntToStr(nDataCount) + ']C[' + IntToStr(I - J + 1) + ']:R[-1]C[' + IntToStr(I - J + 1) + '])';
                skAverage : xlRange.FormulaR1C1 := '=AVERAGE(R[-' + IntToStr(nDataCount) + ']C[' + IntToStr(I - J + 1) + ']:R[-1]C[' + IntToStr(I - J + 1) + '])';
                skText : xlRange.Value := FColumnParams.Items[I].KindText;
              end;
              xlRange.Font.Name := FColumnParams.Items[I].Font.Name;
              xlRange.Font.Size := FColumnParams.Items[I].Font.Size;
              xlRange.Font.Color := FColumnParams.Items[I].Font.Color;
              xlRange.Font.Bold := True;
              xlRange.Font.Italic := fsItalic in FColumnParams.Items[I].Font.Style;
              xlRange.Font.Underline := fsUnderline in FColumnParams.Items[I].Font.Style;
              J := I + 2;
            end;
          end;
        end;
    end;


      // Выделенный текс
    if FColumnParams.Count > 0 then
    begin
      for I := 0 to nColumnCount - 1 do if FColumnParams.Items[I].FDetailedTexts.Count > 0 then
      begin
        for L := 0 to FColumnParams.Items[I].FDetailedTexts.Count - 1 do
          if FColumnParams.Items[I].FDetailedTexts.Items[L].FFieldExists then
        begin
          for J := 0 to nDataCount - 1 do
          begin
            FItemsDataSet.RecNo := J + 1;
            S := FItemsDataSet.FieldByName(FColumnParams.Items[I].FDetailedTexts.Items[L].FieldName).AsString;
            if Trim(S) <> '' then
            begin
              xlRange := xlSheet.Cells[nDataStart + J, I + 1];
              P := PosEx(S, xlRange.FormulaR1C1, 1);
              while P > 0 do
              begin
                xlRange.Characters(P, Length(S)).Font.Name := FColumnParams.Items[I].FDetailedTexts.Items[L].Font.Name;
                xlRange.Characters(P, Length(S)).Font.Size := FColumnParams.Items[I].FDetailedTexts.Items[L].Font.Size;
                xlRange.Characters(P, Length(S)).Font.Color := FColumnParams.Items[I].FDetailedTexts.Items[L].Font.Color;
                xlRange.Characters(P, Length(S)).Font.Bold := fsBold in FColumnParams.Items[I].FDetailedTexts.Items[L].Font.Style;;
                xlRange.Characters(P, Length(S)).Font.Italic := fsItalic in FColumnParams.Items[I].FDetailedTexts.Items[L].Font.Style;
                xlRange.Characters(P, Length(S)).Font.Underline := fsUnderline in FColumnParams.Items[I].FDetailedTexts.Items[L].Font.Style;
                P := PosEx(S, xlRange.FormulaR1C1, P + 1);
              end;
            end;
          end;
        end;
      end;
    end;

      // Рисуем рамку вокруг итогов
    if FFooter then
    begin
      xlRange := xlSheet.Range[xlSheet.Cells[nDataStart + nDataCount, 1], xlSheet.Cells[nDataStart + nDataCount, nColumnCount]];
      xlRange.Borders[xlEdgeLeft].Weight := xlMedium;
      xlRange.Borders[xlEdgeTop].Weight := xlMedium;
      xlRange.Borders[xlEdgeRight].Weight := xlMedium;
      xlRange.Borders[xlEdgeBottom].Weight := xlMedium;
      xlRange.Borders[xlInsideVertical].Weight := xlThin;
      xlRange.Borders[xlInsideHorizontal].Weight := xlThin;
    end;

      // Подпись отчета
    if Assigned(FSignDataSet) and FSignDataSet.Active and (FSignDataSet.RecordCount > 0) then
    begin
      FSignDataSet.First;
      while not FSignDataSet.Eof do
      begin
        Inc(nSignCount);

        xlSheet.Rows[nDataStart + nDataCount + nSignCount].RowHeight := xlSheet.Rows[nDataStart + nDataCount + nSignCount].RowHeight * FSignHeight;
        xlRange := xlSheet.Range[xlSheet.Cells[nDataStart + nDataCount + nSignCount, 1], xlSheet.Cells[nDataStart + nDataCount + nSignCount, nColumnCount]];
        xlRange.Merge;
        xlRange := xlSheet.Cells[nDataStart + nDataCount + nSignCount, 1];
        xlRange.Value := FSignDataSet.Fields.Fields[0].AsString;

        if Self.name = 'actExportToXLS_project'
        then if (nSignCount >= 1) and (nSignCount <= 3)
             then xlRange.HorizontalAlignment := xlRight
             else xlRange.HorizontalAlignment := xlLeft
        else xlRange.HorizontalAlignment := xlCenter;

        xlRange.VerticalAlignment := xlCenter;
        xlRange.WrapText:=true;
        xlRange.Font.Name := FSignFont.Name;
        xlRange.Font.Size := FSignFont.Size;
        xlRange.Font.Color := FSignFont.Color;
        xlRange.Font.Bold := fsBold in FSignFont.Style;
        xlRange.Font.Italic := fsItalic in FSignFont.Style;
        xlRange.Font.Underline := fsUnderline in FSignFont.Style;

        FSignDataSet.Next;
      end;
    end;

     // Переименовываем лист
    if FSheetName <> '' then xlSheet.Name := FSheetName;

    if FileName <> '' then cFileName := FileName else FileName := 'ExportToXLS';

    case FFileType of
      ftExcel8 :  xlBook.SaveAs(ExtractFilePath(ParamStr(0)) + FileName, xlExcel8);
      else xlBook.SaveAs(ExtractFilePath(ParamStr(0)) + FileName)
    end;

    // для проекта Project
    if Self.name = 'actExportToXLS_project'
    then xlApp.Application.Quit
    else begin
      // для других проектов
      xlApp.Application.ScreenUpdating := true;
      xlApp.WindowState := xlMinimized;
      xlApp.WindowState := xlMaximized or xlNormal;
      xlApp.Visible := True;
    end;
  finally

  end;
  Result := true;
end;

end.
