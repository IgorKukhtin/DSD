unit MainCash;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorBase, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Vcl.ExtCtrls, cxSplitter, dsdDB, Datasnap.DBClient, cxContainer,
  cxTextEdit, cxCurrencyEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, Vcl.Menus, cxCheckBox, Vcl.StdCtrls,
  cxButtons, cxNavigator, CashInterface, IniFIles;

type
  TMainCashForm = class(TAncestorBaseForm)
    MainGridDBTableView: TcxGridDBTableView;
    MainGridLevel: TcxGridLevel;
    MainGrid: TcxGrid;
    BottomPanel: TPanel;
    CheckGridDBTableView: TcxGridDBTableView;
    CheckGridLevel: TcxGridLevel;
    CheckGrid: TcxGrid;
    AlternativeGridDBTableView: TcxGridDBTableView;
    AlternativeGridLevel: TcxGridLevel;
    AlternativeGrid: TcxGrid;
    cxSplitter1: TcxSplitter;
    SearchPanel: TPanel;
    cxSplitter2: TcxSplitter;
    MainPanel: TPanel;
    CheckGridColCode: TcxGridDBColumn;
    CheckGridColName: TcxGridDBColumn;
    CheckGridColPrice: TcxGridDBColumn;
    CheckGridColAmount: TcxGridDBColumn;
    CheckGridColSumm: TcxGridDBColumn;
    AlternativeGridColGoodsCode: TcxGridDBColumn;
    AlternativeGridColGoodsName: TcxGridDBColumn;
    MainColCode: TcxGridDBColumn;
    MainColName: TcxGridDBColumn;
    MainColRemains: TcxGridDBColumn;
    MainColPrice: TcxGridDBColumn;
    MainColReserved: TcxGridDBColumn;
    dsdDBViewAddOnMain: TdsdDBViewAddOn;
    spSelectRemains: TdsdStoredProc;
    RemainsDS: TDataSource;
    RemainsCDS: TClientDataSet;
    ceAmount: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    lcName: TcxLookupComboBox;
    actChoiceGoodsInRemainsGrid: TAction;
    actSold: TAction;
    PopupMenu: TPopupMenu;
    actSold1: TMenuItem;
    N1: TMenuItem;
    spNewCheck: TdsdStoredProc;
    FormParams: TdsdFormParams;
    cbSpec: TcxCheckBox;
    actCheck: TdsdOpenForm;
    cxButton1: TcxButton;
    actInsertUpdateCheckItems: TAction;
    spGoodsRemains: TdsdStoredProc;
    spSelectCheck: TdsdStoredProc;
    CheckDS: TDataSource;
    CheckCDS: TClientDataSet;
    spInsertUpdateCheckItems: TdsdStoredProc;
    MainColMCSValue: TcxGridDBColumn;
    cxLabel2: TcxLabel;
    lblTotalSumm: TcxLabel;
    dsdDBViewAddOnCheck: TdsdDBViewAddOn;
    lblSoldRegim: TcxLabel;
    actPutCheckToCash: TAction;
    AlternativeGridColPriceAndRemains: TcxGridDBColumn;
    AlternativeGridColLinkType: TcxGridDBColumn;
    AlternativeCDS: TClientDataSet;
    AlternativeDS: TDataSource;
    spSelect_Alternative: TdsdStoredProc;
    dsdDBViewAddOnAlternative: TdsdDBViewAddOn;
    spComplete_Movement_Check: TdsdStoredProc;
    actSetVIP: TAction;
    VIP1: TMenuItem;
    spUpdateMovementVIP: TdsdStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure actChoiceGoodsInRemainsGridExecute(Sender: TObject);
    procedure lcNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actSoldExecute(Sender: TObject);
    procedure actInsertUpdateCheckItemsExecute(Sender: TObject);
    procedure ceAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ceAmountExit(Sender: TObject);
    procedure actPutCheckToCashExecute(Sender: TObject);
    procedure ParentFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbSpecClick(Sender: TObject);
    procedure actSetVIPExecute(Sender: TObject);
  private
    FSoldRegim: boolean;
    fShift: Boolean;
    FTotalSumm: Real;
    Cash: ICash;
    SoldParallel: Boolean;
    procedure SetSoldRegim(const Value: boolean);
    // возвращает остаток
    function GetGoodsPropertyRemains(GoodsId: integer): real;
    // возвращает кол-во выписанного товарав текущем чеке
    function GetGoodsAmountInCurrenyCheck(GoodsId: Integer): real;
    // процедура обновляет параметры для введения нового чека
    procedure NewCheck;
    // Изменение тела чека
    procedure InsertUpdateBillCheckItems;
    // Расчет актуального остатка по позиции
    procedure UpdateQuantityInQuery(GoodsId: integer);
    // Обновляет сумму по чеку
    procedure CalcTotalSumm;
    // Пробивает чек через ЭККА
    function PutCheckToCash(SalerCash: real; PaidType: TPaidType): boolean;

    property SoldRegim: boolean read FSoldRegim write SetSoldRegim;
  public
    { Public declarations }
  end;

var
  MainCashForm: TMainCashForm;

implementation

{$R *.dfm}

uses CashFactory, IniUtils, CashCloseDialog, VIPDialog;

procedure TMainCashForm.actChoiceGoodsInRemainsGridExecute(Sender: TObject);
begin
  if MainGrid.IsFocused then
  Begin
    if RemainsCDS.isempty then exit;
    if RemainsCDS.FieldByName('Remains').AsFloat>0 then begin
       SoldRegim := true;
       lcName.Text := RemainsCDS.FieldByName('GoodsName').Text;
       ceAmount.Enabled := true;
       ceAmount.Value := 1;
       ActiveControl := ceAmount;
    end
  end
  else
  if AlternativeGrid.IsFocused then
  Begin
    if AlternativeCDS.isempty then exit;
    if AlternativeCDS.FieldByName('Remains').AsFloat>0 then begin
       SoldRegim := true;
       lcName.Text := AlternativeCDS.FieldByName('GoodsName').Text;
       ceAmount.Enabled := true;
       ceAmount.Value := 1;
       ActiveControl := ceAmount;
    end
  End
  else
  Begin
    if CheckCDS.isEmpty then exit;
    if CheckCDS.FieldByName('Amount').AsFloat>0 then begin
       SoldRegim := False;
       lcName.Text := CheckCDS.FieldByName('GoodsName').Text;
       ceAmount.Enabled := true;
       ceAmount.Value := -1;
       ActiveControl := ceAmount;
    end;
  End;
end;

procedure TMainCashForm.actInsertUpdateCheckItemsExecute(Sender: TObject);
begin
  if ceAmount.Value <> 0 then begin //ЕСЛИ введенное кол-во 0 то просто переходим к следующему коду
    if SoldRegim AND (RemainsCDS.FieldByName('Price').AsFloat = 0) then begin
       ShowMessage('Нельзя продать товар с 0 ценой! Свяжитесь с менеджером');
       exit;
    end;
    InsertUpdateBillCheckItems;
  end;
  SoldRegim := true;
  ActiveControl := lcName;
end;

procedure TMainCashForm.actPutCheckToCashExecute(Sender: TObject);
var ASalerCash{,ASdacha}: real;
    PaidType: TPaidType;
begin
  PaidType:=ptMoney;
  if (CheckCDS.RecordCount>0) then
  begin
    if not fShift then
    begin// если с Shift, то считаем, что дали без сдачи
      if not CashCloseDialogExecute(FTotalSumm,ASalerCash,PaidType) then
      Begin
        if Self.ActiveControl <> ceAmount then
          Self.ActiveControl := MainGrid;
        exit;
      End;
    end
    else
    begin
      ASalerCash:=FTotalSumm;
//      ASdacha:=0;
    end;
//    rlGiveSaler.Caption:=FormatFloat(_fmtBookKeeper,ASalerCash);
//    rlSdacha.Caption:=FormatFloat(_fmtBookKeeper,ASdacha);
    // Отбиваем чек через ЭККА
    if PutCheckToCash(ASalerCash, PaidType) then
    begin
    // Проводим чек
      spComplete_Movement_Check.Execute;
       NewCheck;// процедура обновляет параметры для введения нового чека
    end;
  end;
end;

procedure TMainCashForm.actSetVIPExecute(Sender: TObject);
var
  ManagerID:Integer;
  BayerName: String;
begin
  If Not VIPDialogExecute(ManagerID,BayerName) then exit;
  With spUpdateMovementVIP do
  Begin
    ParamByName('inManagerId').Value := ManagerId;
    ParamByName('inBayerName').Value := BayerName;
    execute;
  End;
  NewCheck;
end;

procedure TMainCashForm.actSoldExecute(Sender: TObject);
begin
  SoldRegim:= not SoldRegim;
  ceAmount.Enabled := false;
  lcName.Text := '';
  Activecontrol := lcName;
end;

procedure TMainCashForm.cbSpecClick(Sender: TObject);
begin
  Cash.AlwaysSold := cbSpec.Checked;
end;

procedure TMainCashForm.ceAmountExit(Sender: TObject);
begin
  ceAmount.Enabled := false;
  lcName.Text := '';
end;

procedure TMainCashForm.ceAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then
     actInsertUpdateCheckItems.Execute
end;

procedure TMainCashForm.FormCreate(Sender: TObject);
begin
  inherited;
  UserSettingsStorageAddOn.LoadUserSettings;
  Cash:=TCashFactory.GetCash(iniCashType);
  SoldParallel:=iniSoldParallel;
  NewCheck;

  (*
  SendToCashOnly:= false;
  FFilterRemains:=TStringList.Create;
  FListStoreRemains:= TStringList.Create;
  FFilterCheck:= TStringList.Create;
  gbSaler.Visible:=GetDefaultValue_fromFile(ifDefaults,'Common','ShowSalerPanel','false')='true';
  gbDiscount.Visible:=GetDefaultValue_fromFile(ifDefaults,'Saler','ShowDiscPanel','false')='true';
  TotalPanel.Visible:=gbDiscount.Visible;
  SpeedBar.Visible:=gbDiscount.Visible;
  SoldParallel:=GetDefaultValue_fromFile(ifDefaults,'Common','SoldParallel','false')='true';
  Application.HelpFile:=GetDefaultValue_fromFile(ifDefaults,'Common','HelpFile','CompToCash.hlp');
  pKillDontEnterCheck;//удалить чеки не введенные в программу
  inherited;
  GuideCheck.IncSearchComponent:=IncrementalSearchCheck;
  fEditFieldList.Add('NTZ');
  fEditFieldList.Add('isReceipt');
//------------------------------------------------------------------------------
//       Установки по умолчанию
  SoldEightReg:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'EightReg','true')='true';

  Cash:=TCashFactory.GetCash(GetDefaultValue_fromFile(ifDefaults, Self.ClassName, 'CashType','FP3530T_NEW'));

  ceCount.Text:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'CheckCount','1');
  PrepareCheckID := 0;
  UnitID := -abs(StrToInt(GetDefaultValue_fromFile(ifDefaults,'Common','CurrentUnit','-2')));
  CashID := StrToInt(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'CashID','0'));
  Grid.Color:=StrToInt(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'GridColor','-2147483644'));
  CheckGrid.Color:=StrToInt(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'GridColor','-2147483644'));
  // Пауза между отпуском одного товара в ms

  isSold:=false;

  AssignFile(SendFile,'###.###');

  with NewQuery do begin
    TFloatField(FieldByName('RemainsCount')).DisplayFormat:=   _fmtCount;
    TFloatField(FieldByName('NTZ')).DisplayFormat:=   ',0.###; ; ';
    TFloatField(FieldByName('OperCount')).DisplayFormat:=   _fmtCountOper;
    TFloatField(FieldByName('LastPrice')).DisplayFormat:=      _fmtPrice;
  end;
  with CheckQuery do begin
    TFloatField(FieldByName('OperCount')).DisplayFormat:= _fmtCountOper;
    TFloatField(FieldByName('OperPrice')).DisplayFormat:= _fmtPrice;
    TFloatField(FieldByName('OperSumm')).DisplayFormat:=  _fmtPrice;
  end;

  Query.ParamByName('@UnitId').AsInteger := abs(UnitId);
  Query.ParamByName('@CategoriesId').AsInteger := StrToInt(GetDefaultValue_fromFile(ifOper,Self.ClassName,'CategoriesID','1'));

  NewCheck;// процедура обновляет параметры для введения нового чека

  FNameTimer:= TTimer.create(self);
  FNameTimer.enabled:= False;
  FNameTimer.Interval:= 333;
  FNameTimer.OnTimer:= OnNameEditTimerEvent;

  FTimer:= TTimer.create(self);
  FTimer.enabled:= False;
  FTimer.Interval:= 333;
//  FTimer.OnTimer:= OnEditTimerEv11ent;
//  NewQueryRemainsStore.Visible:=ShowStoreRemains;
  NewQuerySendCount.Visible:=false;
  cbQuite.Checked:=false;
  Cash.AlwaysSold:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'AlwaysSold','true')='true';
  Grid.OnKeyDown := GridKeyDown;
  NewQuery.Filtered := true;

  *)
end;

function TMainCashForm.GetGoodsPropertyRemains(GoodsId: integer): real;
begin
  spGoodsRemains.ParamByName('inGoodsId').Value := GoodsId;
  spGoodsRemains.Execute;
  result := spGoodsRemains.ParamByName('outRemains').asFloat - GetGoodsAmountInCurrenyCheck(GoodsId);
end;

function TMainCashForm.GetGoodsAmountInCurrenyCheck(GoodsId: Integer): real;
var
  B:TBookmark;
Begin
  Result := 0;
  WITH CheckCDS DO
  Begin
    if IsEmpty then
      exit;
    B:= GetBookmark;
    DisableControls;
    try
      First;
      while Not Eof do
      Begin
        if (FieldByName('goodsid').asInteger = goodsid) then
          Result := Result + FieldByName('amount').AsFloat;
        Next;
      End;
      GotoBookmark(B);
      FreeBookmark(B);
    finally
      EnableControls;
    end;
  End;
End;

procedure TMainCashForm.InsertUpdateBillCheckItems;
begin
  if ceAmount.Value = 0 then
     exit;
  if SoldRegim
     and (ceAmount.Value > GetGoodsPropertyRemains(RemainsCDS.FieldByName('Id').asInteger)) then
  begin
    ShowMessage('Не хватает количества для продажи!');
    exit;
  end;
  if (not SoldRegim) and
     (abs(ceAmount.Value) > abs(CheckCDS.FieldByName('Amount').asFloat)) then
  begin
      ShowMessage('Не хватает количества для возврата!');
      exit;
  end;
  with spInsertUpdateCheckItems do begin
     ParamByName('inAmount').Value := ceAmount.Value;
     ParamByName('inPrice').Value := RemainsCDS.FieldByName('Price').asFloat;
     if ceAmount.Value > 0 then
        ParamByName('inGoodsId').Value := RemainsCDS.FieldByName('Id').asInteger
     else
        ParamByName('inGoodsId').Value := CheckCDS.FieldByName('GoodsId').asInteger;
     Execute;
     spSelectCheck.Execute;
     CalcTotalSumm;// Пересчитали значение Суммы в TotalPanel
     UpdateQuantityInQuery(ParamByName('inGoodsId').Value);
  end;
end;

{------------------------------------------------------------------------------}
procedure TMainCashForm.UpdateQuantityInQuery(GoodsId: integer);
begin
  if RemainsCDS.Locate('Id', GoodsId, []) then begin
     RemainsCDS.Edit;
     RemainsCDS.FieldByName('Remains').AsFloat := GetGoodsPropertyRemains(GoodsId);
     RemainsCDS.Post;
  end;
end;

procedure TMainCashForm.CalcTotalSumm;
var
  B:TBookmark;
Begin
  FTotalSumm := 0;
  WITH CheckCDS DO
  Begin
    B:= GetBookmark;
    DisableControls;
    try
      First;
      while Not Eof do
      Begin
        FTotalSumm := FTotalSumm + FieldByName('Summ').AsFloat;
        Next;
      End;
      GotoBookmark(B);
      FreeBookmark(B);
    finally
      EnableControls;
    end;
  End;
  lblTotalSumm.Caption := FormatFloat(',0.00',FTotalSumm);
End;

procedure TMainCashForm.lcNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_Return)
     and
     (
       (
         SoldRegim
         AND
         (lcName.Text = RemainsCDS.FieldByName('GoodsName').AsString)
       )
       or
       (
         not SoldRegim
         AND
         (lcName.Text = CheckCDS.FieldByName('GoodsName').AsString)
       )
     ) then begin
     ceAmount.Enabled := true;
     if SoldRegim then
        ceAmount.Value := 1
     else
        ceAmount.Value := - 1;
     ActiveControl := ceAmount;
  end;
  if (Key=VK_Tab) then
     ActiveControl := MainGrid
end;

// процедура обновляет параметры для введения нового чека
procedure TMainCashForm.NewCheck;
begin
  SoldRegim := true;
  cbSpec.Checked := false;
  spNewCheck.Execute;
  actRefresh.Execute;
  ceAmount.Value := 0;
  ceAmount.Enabled := true;
end;

procedure TMainCashForm.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ADD) or ((Key = VK_Return) AND (ssShift in Shift)) then
  Begin
    fShift := ssShift in Shift;
    actPutCheckToCashExecute(nil);
    Key := 0;
  End;
end;

function TMainCashForm.PutCheckToCash(SalerCash: real;
  PaidType: TPaidType): boolean;
{------------------------------------------------------------------------------}
  function PutOneRecordToCash: boolean; //Продажа одного наименования
  begin
     // посылаем строку в кассу и если все OK, то ставим метку о продаже
     if Cash.AlwaysSold then
        result := true
     else
       if not SoldParallel then
         with CheckCDS do
            result := Cash.SoldFromPC(FieldByName('GoodsCode').asInteger,
                                      AnsiUpperCase(FieldByName('GoodsName').Text),
                                      FieldByName('Amount').asFloat,
                                      FieldByName('Price').asFloat,
                                      FieldByName('NDS').asFloat)
       else result:=true;
  end;
{------------------------------------------------------------------------------}
begin
  try
    result := Cash.AlwaysSold or Cash.OpenReceipt;
    with CheckCDS do
    begin
      First;
      while not EOF do
      begin
        if result then
          result := PutOneRecordToCash;//послали строку в кассу
        Next;
      end;
      if not Cash.AlwaysSold then
      begin
        Cash.SubTotal(true, true, 0, 0);
        Cash.TotalSumm(SalerCash, PaidType);
        result := Cash.CloseReceipt; //Закрыли чек
      end;
    end;
  except
    result := false;
    raise;
  end;
end;

procedure TMainCashForm.SetSoldRegim(const Value: boolean);
begin
  FSoldRegim := Value;
  if SoldRegim then begin
     actSold.Caption := 'Продажа';
     ceAmount.Value := 1;
     lblSoldRegim.Caption := '\/';
  end
  else begin
     actSold.Caption := 'Возврат';
     ceAmount.Value := -1;
     lblSoldRegim.Caption := '/\';
  end;
end;

initialization
  RegisterClass(TMainCashForm)

end.
