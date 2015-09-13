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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

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
    actOpenMCSForm: TdsdOpenForm;
    btnOpenMCSForm: TcxButton;
    spGet_User_IsAdmin: TdsdStoredProc;
    actSetFocus: TAction;
    N10: TMenuItem;
    actRefreshRemains: TAction;
    spDelete_CashSession: TdsdStoredProc;
    DiffCDS: TClientDataSet;
    spSelect_CashRemains_Diff: TdsdStoredProc;
    actExecuteLoadVIP: TAction;
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
    procedure actSetFocusExecute(Sender: TObject);
    procedure actRefreshRemainsExecute(Sender: TObject);
    procedure actExecuteLoadVIPExecute(Sender: TObject);
  private
    FSoldRegim: boolean;
    fShift: Boolean;
    FTotalSumm: Real;
    Cash: ICash;
    SoldParallel: Boolean;
    SourceClientDataSet: TClientDataSet;
    procedure SetSoldRegim(const Value: boolean);
    // возвращает остаток
    function GetGoodsPropertyRemains(GoodsId: integer): real;
    // возвращает кол-во выписанного товарав текущем чеке
    function GetGoodsAmountInCurrenyCheck(GoodsId: Integer): real;
    // процедура обновляет параметры для введения нового чека
    procedure NewCheck(ANeedRemainsRefresh: Boolean = True);
    // Изменение тела чека
    procedure InsertUpdateBillCheckItems;
    // Расчет актуального остатка по позиции
    procedure UpdateQuantityInQuery(GoodsId: integer); overload;
    procedure UpdateQuantityInQuery(GoodsId: integer; Remains: Real); overload;
    //Обновить остаток согласно пришедшей разнице
    procedure UpdateRemainsFromDiff;
    //Возвращает товар в верхний грид
    procedure ReturnRemainsFromCheck;

    // Обновляет сумму по чеку
    procedure CalcTotalSumm;
    // Пробивает чек через ЭККА
    function PutCheckToCash(SalerCash: real; PaidType: TPaidType): boolean;
    //  обновляет остаток на рабочем датасете
    procedure UpdateRemains;

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
  //Вернуть товар в верхний грид
  ReturnRemainsFromCheck;
  //Удалить текущий документ
  spMovementSetErased.Execute;
  //создать новый документ
  NewCheck;
end;

procedure TMainCashForm.actClearMoneyExecute(Sender: TObject);
begin
  lblMoneyInCash.Caption := '0.00';
end;

procedure TMainCashForm.actDeferrentExecute(Sender: TObject);
begin
//  if MessageDlg('Пометить чек отложенным?',mtConfirmation,mbYesNo,0)<>mrYes then exit;
//  With spUpdateMovementVIP do
//  Begin
//    ParamByName('inManagerId').Value := 0;
//    ParamByName('inBayerName').Value := '';
//    execute;
//  End;
//  NewCheck;
end;

procedure TMainCashForm.actExecuteLoadVIPExecute(Sender: TObject);
begin
  inherited;
  if not CheckCDS.IsEmpty then
  Begin
    ShowMessage('Текущий чек не пустой. Сначала очистите чек!');
    exit;
  End;
  actLoadVIP.Execute;
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
        if spGet_Object_CashRegister_By_Serial.ParamByName('outId').AsString <> '' then
          spComplete_Movement_Check.ParamByName('inCashRegisterId').Value :=
            spGet_Object_CashRegister_By_Serial.ParamByName('outId').Value
        ELSE
          spComplete_Movement_Check.ParamByName('inCashRegisterId').Value := 0;
      End
      else
        spComplete_Movement_Check.ParamByName('inCashRegisterId').Value := 0;
    // Проводим чек
      spComplete_Movement_Check.ParamByName('inPaidType').Value := Integer(PaidType);
      DiffCDS.Close;
      spComplete_Movement_Check.Execute;
      //Обновить остаток согласно пришедшей разнице
      UpdateRemainsFromDiff;
      NewCheck(False);// процедура обновляет параметры для введения нового чека
    end;
  end;
end;

procedure TMainCashForm.actRefreshRemainsExecute(Sender: TObject);
begin
  actRefreshLite.Execute;
  UpdateRemainsFromDiff;
end;

procedure TMainCashForm.actSetFocusExecute(Sender: TObject);
begin
  ActiveControl := lcName;
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
  UpdateRemainsFromDiff;
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
  CashSessionId: TGUID;
begin
  inherited;
  //сгенерили гуид для определения сессии
  CreateGUID(CashSessionId);
  FormParams.ParamByName('CashSessionId').Value := GUIDToString(CashSessionId);

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
  with spInsertUpdateCheckItems do begin
     ParamByName('inAmount').Value := ceAmount.Value;
     ParamByName('inPrice').Value := SourceClientDataSet.FieldByName('Price').asFloat;
     if ceAmount.Value > 0 then
        ParamByName('inGoodsId').Value := SourceClientDataSet.FieldByName('Id').asInteger
     else
        ParamByName('inGoodsId').Value := CheckCDS.FieldByName('GoodsId').asInteger;
     Execute;
     //обновить данные чека
     try //Если что то пойдет не так - на экране должно быть то что в базе
       if CheckCDS.Locate('Id',ParamByName('outMovementItemId').Value,[]) then
       begin
         CheckCDS.Edit;
         CheckCDS.FieldByName('Amount').AsFloat := ParamByName('outAmount').AsFloat;
         CheckCDS.FieldByName('Summ').AsFloat := ParamByName('outSumm').AsFloat;
         CheckCDS.Post;
       end
       else
       begin
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
       end;
       //обновить остаток в гл. ДС
       //Обновить остаок в альтернативе
       UpdateQuantityInQuery(ParamByName('inGoodsId').Value,
         ParamByName('outRemains').AsFloat);
       //Обновить сумму документа
       FTotalSumm := ParamByName('outTotalSummCheck').AsFloat;
       lblTotalSumm.Caption := FormatFloat(',0.00',ParamByName('outTotalSummCheck').AsFloat);
     Except ON E: Exception DO
       begin
         spSelectCheck.Execute;
         CalcTotalSumm;// Пересчитали значение Суммы в TotalPanel
         UpdateQuantityInQuery(ParamByName('inGoodsId').Value);
         raise Exception.Create(E.Message);
       end;
     end;
  end;
end;

{------------------------------------------------------------------------------}
procedure TMainCashForm.UpdateQuantityInQuery(GoodsId: integer);
begin
  UpdateQuantityInQuery(GoodsId, GetGoodsPropertyRemains(GoodsId));
end;

procedure TMainCashForm.UpdateQuantityInQuery(GoodsId: integer; Remains: Real);
var
  CurrGoodsId: Integer;
  B: TBookmark;
begin
  RemainsCDS.AfterScroll := nil;
  try
    if GoodsId = RemainsCDS.FieldByName('Id').AsInteger then
    Begin
      if (RemainsCDS.FieldByName('Remains').AsFloat <> Remains) then
      Begin
        RemainsCDS.Edit;
        RemainsCDS.FieldByName('Remains').AsFloat := Remains;
        RemainsCDS.Post;
      End;
    End
    else
    Begin
      RemainsCDS.DisableControls;
      B := RemainsCDS.GetBookmark;
      try
        if RemainsCDS.Locate('Id', GoodsId, []) then
        begin
          if (RemainsCDS.FieldByName('Remains').AsFloat <> Remains) then
          Begin
            RemainsCDS.Edit;
            RemainsCDS.FieldByName('Remains').AsFloat := Remains;
            RemainsCDS.Post;
          End;
        end
        else
        Begin
          RemainsCDS.Filtered := False;
          if RemainsCDS.Locate('Id', GoodsId, []) then
          begin
            if (RemainsCDS.FieldByName('Remains').AsFloat <> Remains) then
            Begin
              RemainsCDS.Edit;
              RemainsCDS.FieldByName('Remains').AsFloat := Remains;
              RemainsCDS.Post;
            End;
          end;
          RemainsCDS.Filtered := True;
        End;
        if RemainsCDS.BookmarkValid(B) then
          RemainsCDS.GoToBookmark(B);
      finally
        RemainsCDS.EnableControls;
      end;
    end;
  finally
    RemainsCDS.AfterScroll := RemainsCDSAfterScroll;
  end;
  try
    AlternativeCDS.DisableControls;
    AlternativeCDS.Filter := 'Id = '+intToStr(GoodsId);
    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      AlternativeCDS.Edit;
      AlternativeCDS.FieldByName('Remains').AsFloat := Remains;
      AlternativeCDS.Post;
      AlternativeCDS.Next;
    End;
  finally
    RemainsCDSAfterScroll(RemainsCDS);
    AlternativeCDS.EnableControls;
  end;
end;

procedure TMainCashForm.UpdateRemains;
var
  GoodsId : Integer;
begin
  if not RemainsCDS.Active or not Remains_LiteCDS.Active  then exit;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.DisableControls;
  AlternativeCDS.Filtered := False;
  Remains_LiteCDS.DisableControls;
  try
    RemainsCDS.First;
    Remains_LiteCDS.First;
    while not RemainsCDS.eof do
    begin
      if RemainsCDS.fieldByName('Id').AsInteger = Remains_LiteCDS.fieldByName('Id').AsInteger then
      Begin
        if (RemainsCDS.FieldByName('Remains').AsFloat <> Remains_LiteCDS.FieldByName('Remains').AsFloat) or
           (RemainsCDS.FieldByName('Reserved').AsFloat <> Remains_LiteCDS.FieldByName('Reserve_Amount').AsFloat) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Remains').AsFloat := Remains_LiteCDS.FieldByName('Remains').AsFloat;
          RemainsCDS.FieldByName('Reserved').AsFloat := Remains_LiteCDS.FieldByName('Reserve_Amount').AsFloat;
          RemainsCDS.Post;
        End;
        RemainsCDS.Next;
        Remains_LiteCDS.Next;
      End
      else
      if RemainsCDS.fieldByName('Id').AsInteger > Remains_LiteCDS.fieldByName('Id').AsInteger then
        Remains_LiteCDS.Next
      else
      if RemainsCDS.fieldByName('Id').AsInteger < Remains_LiteCDS.fieldByName('Id').AsInteger then
      Begin
        if (RemainsCDS.FieldByName('Remains').AsFloat <> 0) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Remains').AsFloat := 0;
          RemainsCDS.Post;
        End;
        RemainsCDS.Next;
      End;
    end;

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
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id',GoodsId,[]);
    RemainsCDS.EnableControls;
    RemainsCDS.AfterScroll := RemainsCDSAfterScroll;
    AlternativeCDS.Filtered := true;
    RemainsCDSAfterScroll(RemainsCDS);
    AlternativeCDS.EnableControls;
    //Remains_LiteCDS.EnableControls;
  end;
end;

procedure TMainCashForm.UpdateRemainsFromDiff;
var
  GoodsId: Integer;
begin
  //Если нет расхождений - ничего не делаем
  if DiffCDS.IsEmpty then exit;
  //открючаем реакции
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.DisableControls;
  AlternativeCDS.Filtered := False;
  DIffCDS.DisableControls;
  try
    DiffCDS.First;
    while not DiffCDS.eof do
    begin
      if DiffCDS.FieldByName('NewRow').AsBoolean then
      Begin
        RemainsCDS.Append;
        RemainsCDS.FieldByName('Id').AsInteger := DiffCDS.FieldByName('Id').AsInteger;
        RemainsCDS.FieldByName('GoodsCode').AsInteger := DiffCDS.FieldByName('GoodsCode').AsInteger;
        RemainsCDS.FieldByName('GoodsName').AsString := DiffCDS.FieldByName('GoodsName').AsString;
        RemainsCDS.FieldByName('Price').AsFloat := DiffCDS.FieldByName('Price').AsFloat;
        RemainsCDS.FieldByName('Remains').AsFloat := DiffCDS.FieldByName('Remains').AsFloat;
        RemainsCDS.FieldByName('MCSValue').AsFloat := DiffCDS.FieldByName('MCSValue').AsFloat;
        RemainsCDS.FieldByName('Reserved').AsFloat := DiffCDS.FieldByName('Reserved').AsFloat;
        RemainsCDS.Post;
      End
      else
      Begin
        if RemainsCDS.Locate('Id',DiffCDS.FieldByName('Id').AsInteger,[]) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Price').AsFloat := DiffCDS.FieldByName('Price').AsFloat;
          RemainsCDS.FieldByName('Remains').AsFloat := DiffCDS.FieldByName('Remains').AsFloat;
          RemainsCDS.FieldByName('MCSValue').AsFloat := DiffCDS.FieldByName('MCSValue').AsFloat;
          RemainsCDS.FieldByName('Reserved').AsFloat := DiffCDS.FieldByName('Reserved').AsFloat;
          RemainsCDS.Post;
        End;
      End;
      DiffCDS.Next;
    end;

    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      if DiffCDS.locate('Id',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
      Begin
        if AlternativeCDS.FieldByName('Remains').AsFloat <> DiffCDS.FieldByName('Remains').AsFloat then
        Begin
          AlternativeCDS.Edit;
          AlternativeCDS.FieldByName('Remains').AsFloat := DiffCDS.FieldByName('Remains').AsFloat;
          AlternativeCDS.Post;
        End;
      End;
      AlternativeCDS.Next;
    End;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id',GoodsId,[]);
    RemainsCDS.EnableControls;
    RemainsCDS.AfterScroll := RemainsCDSAfterScroll;
    AlternativeCDS.Filtered := true;
    RemainsCDSAfterScroll(RemainsCDS);
    AlternativeCDS.EnableControls;
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
procedure TMainCashForm.NewCheck(ANeedRemainsRefresh: Boolean = True);
begin
  SoldRegim := true;
  actSpec.Checked := false;
  if Assigned(Cash) then
    Cash.AlwaysSold := False;
  spNewCheck.Execute;
  if Self.Visible then
  Begin
    if ANeedRemainsRefresh then
    Begin
      actRefreshLite.Execute;
      UpdateRemainsFromDiff;
    End
    else
      spSelectCheck.Execute;
  End
  else
    actRefresh.Execute;
  CalcTotalSumm;
  ceAmount.Value := 0;
  ceAmount.Enabled := true;
  ActiveControl := lcName;
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
  Begin
    spMovementSetErased.Execute;
    spDelete_CashSession.Execute;
  End;
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
  if RemainsCDS.FieldByName('AlternativeGroupId').AsInteger = 0 then
    AlternativeCDS.Filter := 'Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString
  else
    AlternativeCDS.Filter := '(Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString +
      ') or (Remains > 0 AND AlternativeGroupId='+RemainsCDS.FieldByName('AlternativeGroupId').AsString+
           ' AND Id <> '+RemainsCDS.FieldByName('Id').AsString+')';
end;

procedure TMainCashForm.ReturnRemainsFromCheck;
var
  GoodsId: Integer;
begin
  //Если нет расхождений - ничего не делаем
  if CheckCDS.IsEmpty then exit;
  //открючаем реакции
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.DisableControls;
  AlternativeCDS.Filtered := False;
  CheckCDS.DisableControls;
  try
    CheckCDS.First;
    while not CheckCDS.eof do
    begin
      if RemainsCDS.Locate('Id',CheckCDS.FieldByName('GoodsId').AsInteger,[]) then
      Begin
        RemainsCDS.Edit;
        RemainsCDS.FieldByName('Remains').AsFloat := RemainsCDS.FieldByName('Remains').AsFloat
          + CheckCDS.FieldByName('Amount').AsFloat;
        RemainsCDS.Post;
      End;
      CheckCDS.Next;
    end;

    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      if CheckCDS.locate('GoodsId',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
      Begin
        AlternativeCDS.Edit;
        AlternativeCDS.FieldByName('Remains').AsFloat := AlternativeCDS.FieldByName('Remains').AsFloat
          + CheckCDS.FieldByName('Amount').AsFloat;
        AlternativeCDS.Post;
      End;
      AlternativeCDS.Next;
    End;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id',GoodsId,[]);
    RemainsCDS.EnableControls;
    RemainsCDS.AfterScroll := RemainsCDSAfterScroll;
    AlternativeCDS.Filtered := true;
    RemainsCDSAfterScroll(RemainsCDS);
    AlternativeCDS.EnableControls;
    CheckCDS.EnableControls;
  end;
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

initialization
  RegisterClass(TMainCashForm)

end.
