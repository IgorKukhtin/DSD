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
  cxButtons, cxNavigator, CashInterface, IniFIles, cxImageComboBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter;

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
    btnCheck: TcxButton;
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
    actPutCheckToCash: TAction;
    AlternativeGridColLinkType: TcxGridDBColumn;
    AlternativeCDS: TClientDataSet;
    AlternativeDS: TDataSource;
    spSelect_Alternative: TdsdStoredProc;
    dsdDBViewAddOnAlternative: TdsdDBViewAddOn;
    spComplete_Movement_Check: TdsdStoredProc;
    actSetVIP: TAction;
    VIP1: TMenuItem;
    spUpdateMovementVIP: TdsdStoredProc;
    AlternativeGridColTypeColor: TcxGridDBColumn;
    AlternativeGridDColPrice: TcxGridDBColumn;
    AlternativeGridColRemains: TcxGridDBColumn;
    actDeferrent: TAction;
    N2: TMenuItem;
    btnVIP: TcxButton;
    actOpenCheckVIP: TOpenChoiceForm;
    actLoadVIP: TMultiAction;
    btnLoadDeferred: TcxButton;
    actOpenCheckDeferred: TOpenChoiceForm;
    actLoadDeferred: TMultiAction;
    actUpdateRemains: TAction;
    actCalcTotalSumm: TAction;
    actCashWork: TAction;
    N3: TMenuItem;
    spMovementSetErased: TdsdStoredProc;
    actClearAll: TAction;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    spGet_Object_CashRegister_By_Serial: TdsdStoredProc;
    lblMoneyInCash: TcxLabel;
    actClearMoney: TAction;
    N7: TMenuItem;
    actGetMoneyInCash: TAction;
    N8: TMenuItem;
    spGetMoneyInCash: TdsdStoredProc;
    spGet_Password_MoneyInCash: TdsdStoredProc;
    actSpec: TAction;
    N9: TMenuItem;
    spSelectRemains_Lite: TdsdStoredProc;
    Remains_LiteCDS: TClientDataSet;
    actRefreshLite: TdsdDataSetRefresh;
    spGet_User_IsAdmin: TdsdStoredProc;
    actOpenMCSForm: TdsdOpenForm;
    btnOpenMCSForm: TcxButton;
    chbTracing: TcxCheckBox;
    procedure WM_KEYDOWN(var Msg: TWMKEYDOWN);
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
    procedure actSetVIPExecute(Sender: TObject);
    procedure RemainsCDSAfterScroll(DataSet: TDataSet);
    procedure actDeferrentExecute(Sender: TObject);
    procedure actCalcTotalSummExecute(Sender: TObject);
    procedure MainColReservedGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure actCashWorkExecute(Sender: TObject);
    procedure actClearAllExecute(Sender: TObject);
    procedure actClearMoneyExecute(Sender: TObject);
    procedure actGetMoneyInCashExecute(Sender: TObject);
    procedure actSpecExecute(Sender: TObject);
    procedure ParentFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lcNameExit(Sender: TObject);
    procedure actUpdateRemainsExecute(Sender: TObject);
  private
    FSoldRegim: boolean;
    fShift: Boolean;
    FTotalSumm: Real;
    Cash: ICash;
    SoldParallel: Boolean;
    SourceClientDataSet: TClientDataSet;
    TimeArray: Array [0..29] of TDateTime;
    ASCount: Integer;
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
    procedure UpdateQuantityInQuery(GoodsId: integer); overload;
    procedure UpdateQuantityInQuery(GoodsId: integer; Remains: Real); overload;

    // Обновляет сумму по чеку
    procedure CalcTotalSumm;
    // Пробивает чек через ЭККА
    function PutCheckToCash(SalerCash: real; PaidType: TPaidType): boolean;
    //  обновляет остаток на рабочем датасете
    procedure UpdateRemains;

    procedure ShowTimeTracing;

    property SoldRegim: boolean read FSoldRegim write SetSoldRegim;
  public
    { Public declarations }
  end;

var
  MainCashForm: TMainCashForm;

implementation

{$R *.dfm}

uses CashFactory, IniUtils, CashCloseDialog, VIPDialog, CashWork, MessagesUnit;

procedure TMainCashForm.actCalcTotalSummExecute(Sender: TObject);
begin
  CalcTotalSumm;
end;

procedure TMainCashForm.actCashWorkExecute(Sender: TObject);
begin
  inherited;
  with TCashWorkForm.Create(Cash, RemainsCDS) do begin
    ShowModal;
    Free;
  end;
end;

procedure TMainCashForm.actChoiceGoodsInRemainsGridExecute(Sender: TObject);
begin
  if MainGrid.IsFocused then
  Begin
    if RemainsCDS.isempty then exit;
    if RemainsCDS.FieldByName('Remains').AsFloat>0 then begin
       SourceClientDataSet := RemainsCDS;
       SoldRegim := true;
       lcName.Text := RemainsCDS.FieldByName('GoodsName').asString;
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
       SourceClientDataSet := AlternativeCDS;
       SoldRegim := true;
       lcName.Text := AlternativeCDS.FieldByName('GoodsName').asString;
       ceAmount.Enabled := true;
       ceAmount.Value := 1;
       ActiveControl := ceAmount;
    end
  End
  else
  Begin
    if CheckCDS.isEmpty then exit;
    if CheckCDS.FieldByName('Amount').AsFloat>0 then begin
       SourceClientDataSet := CheckCDS;
       SoldRegim := False;
       lcName.Text := CheckCDS.FieldByName('GoodsName').asString;
       ceAmount.Enabled := true;
       ceAmount.Value := -1;
       ActiveControl := ceAmount;
    end;
  End;
end;

procedure TMainCashForm.actClearAllExecute(Sender: TObject);
begin
  if CheckCDS.IsEmpty then exit;
  if MessageDlg('Очистить все?',mtConfirmation,mbYesNo,0)<>mrYes then exit;
  spMovementSetErased.Execute;
  NewCheck;
end;

procedure TMainCashForm.actClearMoneyExecute(Sender: TObject);
begin
  lblMoneyInCash.Caption := '0.00';
end;

procedure TMainCashForm.actDeferrentExecute(Sender: TObject);
begin
  if MessageDlg('Пометить чек отложенным?',mtConfirmation,mbYesNo,0)<>mrYes then exit;
  With spUpdateMovementVIP do
  Begin
    ParamByName('inManagerId').Value := 0;
    ParamByName('inBayerName').Value := '';
    execute;
  End;
  NewCheck;
end;

procedure TMainCashForm.actGetMoneyInCashExecute(Sender: TObject);
begin
  spGet_Password_MoneyInCash.Execute;
  if InputBox('Пароль','Введите пароль:','') <> spGet_Password_MoneyInCash.ParamByName('outPassword').AsString then exit;
  spGetMoneyInCash.ParamByName('inDate').Value := Date;
  spGetMoneyInCash.Execute;
  lblMoneyInCash.Caption := FormatFloat(',0.00',spGetMoneyInCash.ParamByName('outTotalSumm').AsFloat);
end;

procedure TMainCashForm.actInsertUpdateCheckItemsExecute(Sender: TObject);
begin
  if ceAmount.Value <> 0 then begin //ЕСЛИ введенное кол-во 0 то просто переходим к следующему коду
    if not Assigned(SourceClientDataSet) then
      SourceClientDataSet := RemainsCDS;

    if SoldRegim AND (SourceClientDataSet.FieldByName('Price').AsFloat = 0) then begin
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
      //Достаем серийник кассового аппарата
      if Assigned(Cash) AND not Cash.AlwaysSold then
      Begin
        spGet_Object_CashRegister_By_Serial.ParamByName('inSerial').Value :=
          Cash.FiscalNumber;
        spGet_Object_CashRegister_By_Serial.Execute;
        spComplete_Movement_Check.ParamByName('inCashRegisterId').Value :=
          spGet_Object_CashRegister_By_Serial.ParamByName('outId').Value
      End
      else
        spComplete_Movement_Check.ParamByName('inCashRegisterId').Value := 0;
    // Проводим чек
      spComplete_Movement_Check.ParamByName('inPaidType').Value := Integer(PaidType);
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

procedure TMainCashForm.actSpecExecute(Sender: TObject);
begin
  if Assigned(Cash) then
    Cash.AlwaysSold := actSpec.Checked;
end;

procedure TMainCashForm.actUpdateRemainsExecute(Sender: TObject);
begin
  UpdateRemains;
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
var
  F: String;
begin
  inherited;
  if NOT GetIniFile(F) then
  Begin
    Application.Terminate;
    exit;
  End;
  UserSettingsStorageAddOn.LoadUserSettings;
  try
    Cash:=TCashFactory.GetCash(iniCashType);
  except
    Begin
      ShowMessage('Внимание! Программа не может подключится к фискальному аппарату.'+#13+
                  'Дальнейшая работа программы возможна только в нефискальном режиме!');
    End;
  end;
  spGet_User_IsAdmin.Execute;
  if spGet_User_IsAdmin.ParamByName('gpGet_User_IsAdmin').Value = True then
    actCheck.FormNameParam.Value := 'TCheckJournalForm'
  Else
    actCheck.FormNameParam.Value := 'TCheckJournalUserForm';

  SoldParallel:=iniSoldParallel;
  NewCheck;
  OnCLoseQuery := ParentFormCloseQuery;
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
var
  I: Integer;
begin
  if ceAmount.Value = 0 then
     exit;
  if not assigned(SourceClientDataSet) then
    SourceClientDataSet := RemainsCDS;
  if SoldRegim
     and (ceAmount.Value > SourceClientDataSet.FieldByName('Remains').AsFloat) then
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
for I := low(TimeArray) to High(TimeArray) do
  TimeArray[I] := 0;
TimeArray[0] := Now;
  with spInsertUpdateCheckItems do begin
     ParamByName('inAmount').Value := ceAmount.Value;
     ParamByName('inPrice').Value := SourceClientDataSet.FieldByName('Price').asFloat;
     if ceAmount.Value > 0 then
        ParamByName('inGoodsId').Value := SourceClientDataSet.FieldByName('Id').asInteger
     else
        ParamByName('inGoodsId').Value := CheckCDS.FieldByName('GoodsId').asInteger;
TimeArray[1] := Now;
     Execute;
     //обновить данные чека
     try //Если что то пойдет не так - на экране должно быть то что в базе
TimeArray[2] := Now;
       if CheckCDS.Locate('Id',ParamByName('outMovementItemId').Value,[]) then
       begin
TimeArray[3] := Now;
         CheckCDS.Edit;
         CheckCDS.FieldByName('Amount').AsFloat := ParamByName('outAmount').AsFloat;
         CheckCDS.FieldByName('Summ').AsFloat := ParamByName('outSumm').AsFloat;
         CheckCDS.Post;
TimeArray[4] := Now;
       end
       else
       begin
TimeArray[3] := Now;
         CheckCDS.Append;
         CheckCDS.FieldByName('Id').AsInteger := ParamByName('outMovementItemId').Value;
         CheckCDS.FieldByName('GoodsId').AsInteger := SourceClientDataSet.FieldByName('Id').asInteger;
         CheckCDS.FieldByName('GoodsCode').AsInteger := SourceClientDataSet.FieldByName('GoodsCode').asInteger;
         CheckCDS.FieldByName('GoodsName').AsString := SourceClientDataSet.FieldByName('GoodsName').AsString;
         CheckCDS.FieldByName('Amount').AsFloat := ParamByName('outAmount').AsFloat;
         CheckCDS.FieldByName('Price').AsFloat := SourceClientDataSet.FieldByName('Price').asFloat;
         CheckCDS.FieldByName('Summ').AsFloat := ParamByName('outSumm').AsFloat;
         CheckCDS.FieldByName('NDS').AsFloat := ParamByName('outNDS').AsFloat;
         CheckCDS.FieldByName('isErased').AsBoolean := False;
         CheckCDS.Post;
TimeArray[4] := Now;
       end;
       //обновить остаток в гл. ДС
       //Обновить остаок в альтернативе
       UpdateQuantityInQuery(ParamByName('inGoodsId').Value,
         ParamByName('outRemains').AsFloat);
       //Обновить сумму документа
TimeArray[23]:=Now;
       FTotalSumm := ParamByName('outTotalSummCheck').AsFloat;
TimeArray[24]:=Now;
       lblTotalSumm.Caption := FormatFloat(',0.00',ParamByName('outTotalSummCheck').AsFloat);
TimeArray[25]:=Now;
     Except ON E: Exception DO
       begin
TimeArray[26]:=Now;
         spSelectCheck.Execute;
TimeArray[27]:=Now;
         CalcTotalSumm;// Пересчитали значение Суммы в TotalPanel
TimeArray[28]:=Now;
         UpdateQuantityInQuery(ParamByName('inGoodsId').Value);
TimeArray[29]:=Now;
         raise Exception.Create(E.Message);
       end;
     end;
  end;
  if chbTracing.Checked then
    ShowTimeTracing;
end;

{------------------------------------------------------------------------------}
procedure TMainCashForm.UpdateQuantityInQuery(GoodsId: integer);
begin
  UpdateQuantityInQuery(GoodsId, GetGoodsPropertyRemains(GoodsId));
end;

procedure TMainCashForm.UpdateQuantityInQuery(GoodsId: integer; Remains: Real);
var B: TBookmark;
begin
ASCount := 0;
TimeArray[5]:=Now;
  RemainsCDS.DisableControls;
TimeArray[6]:=Now;
  RemainsCDS.AfterScroll := nil;
TimeArray[7]:=Now;
  RemainsCDS.Filtered := False;
TimeArray[8]:=Now;
  AlternativeCDS.DisableControls;
TimeArray[9]:=Now;
  AlternativeCDS.Filtered := False;
TimeArray[10]:=Now;
  try
    if RemainsCDS.Locate('Id', GoodsId, []) AND (RemainsCDS.FieldByName('Remains').AsFloat <> Remains) then
    begin
TimeArray[11]:=Now;
       RemainsCDS.Edit;
       RemainsCDS.FieldByName('Remains').AsFloat := Remains;
       RemainsCDS.Post;
TimeArray[12]:=Now;
    end;

    AlternativeCDS.Filter := 'Id = '+CheckCDS.FieldByName('GoodsId').asString;
TimeArray[13]:=Now;
    AlternativeCDS.Filtered := True;
TimeArray[14]:=Now;
    AlternativeCDS.First;
TimeArray[15]:=Now;
    while Not AlternativeCDS.eof do
    Begin
      AlternativeCDS.Edit;
      AlternativeCDS.FieldByName('Remains').AsFloat := Remains;
      AlternativeCDS.Post;
      AlternativeCDS.Next;
    End;
TimeArray[16]:=Now;
  finally
    AlternativeCDS.Filtered := True;
TimeArray[17]:=Now;
    RemainsCDS.Filtered := true;
TimeArray[18]:=Now;
    RemainsCDS.EnableControls;
TimeArray[19]:=Now;
    RemainsCDS.AfterScroll := RemainsCDSAfterScroll;
TimeArray[20]:=Now;
    RemainsCDSAfterScroll(RemainsCDS);
TimeArray[21]:=Now;
    RemainsCDS.Locate('Id', GoodsId, []);
    AlternativeCDS.EnableControls;
TimeArray[22]:=Now;
  end;
end;

procedure TMainCashForm.UpdateRemains;
var
  GoodsId : Integer;
begin
  if not RemainsCDS.Active or not Remains_LiteCDS.Active  then exit;

  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  RemainsCDS.DisableControls;
  RemainsCDS.Filtered := False;
  RemainsCDS.AfterScroll := Nil;
  AlternativeCDS.DisableControls;
  AlternativeCDS.Filtered := False;
  Remains_LiteCDS.DisableControls;
  try
    RemainsCDS.First;
    while Not RemainsCDS.eof do
    Begin
      if Remains_LiteCDS.locate('Id',RemainsCDS.fieldByName('Id').AsInteger,[]) then
      Begin
        if (RemainsCDS.FieldByName('Remains').AsFloat <> Remains_LiteCDS.FieldByName('Remains').AsFloat) or
           (RemainsCDS.FieldByName('Reserved').AsFloat <> Remains_LiteCDS.FieldByName('Reserve_Amount').AsFloat) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Remains').AsFloat := Remains_LiteCDS.FieldByName('Remains').AsFloat;
          RemainsCDS.FieldByName('Reserved').AsFloat := Remains_LiteCDS.FieldByName('Reserve_Amount').AsFloat;
          RemainsCDS.Post;
        End;
      End
      else
      if RemainsCDS.FieldByName('Remains').AsFloat <> 0 then
      Begin
        RemainsCDS.Edit;
        RemainsCDS.FieldByName('Remains').AsFloat := 0;
        RemainsCDS.Post;
      End;
      RemainsCDS.Next;
    End;

    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      if Remains_LiteCDS.locate('Id',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
      Begin
        if AlternativeCDS.FieldByName('Remains').AsFloat <> Remains_LiteCDS.FieldByName('Remains').AsFloat then
        Begin
          AlternativeCDS.Edit;
          AlternativeCDS.FieldByName('Remains').AsFloat := Remains_LiteCDS.FieldByName('Remains').AsFloat;
          AlternativeCDS.Post;
        End;
      End
      else
      if AlternativeCDS.FieldByName('Remains').AsFloat <> 0 then
      Begin
        AlternativeCDS.Edit;
        AlternativeCDS.FieldByName('Remains').AsFloat := 0;
        AlternativeCDS.Post;
      End;
      AlternativeCDS.Next;
    End;
    RemainsCDS.Locate('Id',GoodsId,[]);
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.EnableControls;
    RemainsCDS.AfterScroll := RemainsCDSAfterScroll;
    RemainsCDSAfterScroll(RemainsCDS);
    AlternativeCDS.Filtered := true;
    AlternativeCDS.EnableControls;
    Remains_LiteCDS.EnableControls;
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

procedure TMainCashForm.WM_KEYDOWN(var Msg: TWMKEYDOWN);
begin
  if (Msg.charcode = VK_TAB) and (ActiveControl=lcName) then
     ActiveControl:=MainGrid;
end;

procedure TMainCashForm.lcNameExit(Sender: TObject);
begin
  inherited;
  if (GetKeyState(VK_TAB)<0) and (GetKeyState(VK_CONTROL)<0) then begin
     ActiveControl:=CheckGrid;
     exit
  end;
  if GetKeyState(VK_TAB)<0 then
     ActiveControl:=MainGrid;
end;

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
  if Key = VK_TAB then
    ActiveControl:=MainGrid;
end;

procedure TMainCashForm.MainColReservedGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if AText = '0' then
    AText := '';
end;

// процедура обновляет параметры для введения нового чека
procedure TMainCashForm.NewCheck;
begin
  SoldRegim := true;
  actSpec.Checked := false;
  if Assigned(Cash) then
    Cash.AlwaysSold := False;
  spNewCheck.Execute;
  if Self.Visible then
  Begin
    actRefreshLite.Execute;
    UpdateRemains;
  End
  else
    actRefresh.Execute;
  CalcTotalSumm;
  ceAmount.Value := 0;
  ceAmount.Enabled := true;
end;

procedure TMainCashForm.ParentFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if not CheckCDS.IsEmpty then
  Begin
    CanClose := False;
    ShowMessage('Сначала обнулите чек.');
  End
  else
    CanClose := MessageDlg('Вы действительно хотите выйти?',mtConfirmation,[mbYes,mbCancel], 0) = mrYes;
  if CanClose then
    spMovementSetErased.Execute;
end;

procedure TMainCashForm.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_Tab) and (CheckGrid.IsFocused) then ActiveControl:=lcName;
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
     if not Assigned(Cash) or Cash.AlwaysSold then
        result := true
     else
       if not SoldParallel then
         with CheckCDS do begin
            result := Cash.SoldFromPC(FieldByName('GoodsCode').asInteger,
                                      AnsiUpperCase(FieldByName('GoodsName').Text),
                                      FieldByName('Amount').asFloat,
                                      FieldByName('Price').asFloat,
                                      FieldByName('NDS').asFloat)
         end
       else result:=true;
  end;
{------------------------------------------------------------------------------}
begin
  try
    result := not Assigned(Cash) or Cash.AlwaysSold or Cash.OpenReceipt;
    with CheckCDS do
    begin
      First;
      while not EOF do
      begin
        if result then
           begin
             if CheckCDS.FieldByName('Amount').asFloat >= 0.001 then
                result := PutOneRecordToCash;//послали строку в кассу
           end;
        Next;
      end;
      if Assigned(Cash) AND not Cash.AlwaysSold then
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

procedure TMainCashForm.RemainsCDSAfterScroll(DataSet: TDataSet);
begin
inc(ASCount);
  if RemainsCDS.FieldByName('AlternativeGroupId').AsInteger = 0 then
    AlternativeCDS.Filter := 'Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString
  else
    AlternativeCDS.Filter := '(Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString +
      ') or (Remains > 0 AND AlternativeGroupId='+RemainsCDS.FieldByName('AlternativeGroupId').AsString+
           ' AND Id <> '+RemainsCDS.FieldByName('Id').AsString+')';
end;

procedure TMainCashForm.SetSoldRegim(const Value: boolean);
begin
  FSoldRegim := Value;
  if SoldRegim then begin
     actSold.Caption := 'Продажа';
     ceAmount.Value := 1;
  end
  else begin
     actSold.Caption := 'Возврат';
     ceAmount.Value := -1;
  end;
end;


procedure TMainCashForm.ShowTimeTracing;
var
  I: Integer;
  S: String;
begin
  S:= '';
  for I := Low(TimeArray) to High(TimeArray) do
  Begin
    if I = Low(TimeArray) then
      S:=S+IntToStr(I)+':   '+
        FormatDateTime('hh:mm:ss:zzz',TimeArray[I])+#13
    else
      S:=S+IntToStr(I)+':   '+
        FormatDateTime('hh:mm:ss:zzz',TimeArray[I])+#9+
        FormatDateTime('hh:mm:ss:zzz',TimeArray[I]-TimeArray[I-1])+#9+
        FormatDateTime('hh:mm:ss:zzz',TimeArray[I]-TimeArray[Low(TimeArray)])+#13;
  End;
  ShowMessage(S+IntToSTr(ASCount));
end;

initialization
  RegisterClass(TMainCashForm)

end.
