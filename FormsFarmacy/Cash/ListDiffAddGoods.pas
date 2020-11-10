unit ListDiffAddGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  System.DateUtils, Dialogs, StdCtrls, Mask, CashInterface, DB, Buttons,
  Gauges, cxGraphics, cxControls, cxLookAndFeels, Math,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit,
  cxClasses, cxPropertiesStore, dsdAddOn, dxSkinsCore, dxSkinsDefaultPainters,
  Datasnap.DBClient, Vcl.Menus, cxButtons, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, cxMaskEdit, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, cxButtonEdit, ChoiceListDiff;

type
  TListDiffAddGoodsForm = class(TForm)
    bbOk: TcxButton;
    bbCancel: TcxButton;
    ListDiffCDS: TClientDataSet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ceAmount: TcxCurrencyEdit;
    meComent: TcxMaskEdit;
    Label4: TLabel;
    DiffKindCDS: TClientDataSet;
    Label5: TLabel;
    ListGoodsCDS: TClientDataSet;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label6: TLabel;
    Label9: TLabel;
    ActionList: TActionList;
    beDiffKind: TcxButtonEdit;
    actShowListDiff: TAction;
    TimerStart: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ceAmountPropertiesChange(Sender: TObject);
    procedure lcbDiffKindPropertiesChange(Sender: TObject);
    procedure actShowListDiffExecute(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
  private
    FDiffKindId : Integer;
    FGoodsCDS : TClientDataSet;
    FAmountDay : Currency;
    FAmountDiffKind, FMaxOrderAmount : Currency;
  public

    property GoodsCDS : TClientDataSet read FGoodsCDS write FGoodsCDS;
  end;

implementation

{$R *.dfm}

uses CommonData, LocalWorkUnit, MainCash2, ListDiff, PUSHMessage;

{ TListDiffAddGoodsForm }

procedure TListDiffAddGoodsForm.actShowListDiffExecute(Sender: TObject);
begin
  if ChoiceListDiffExecute(DiffKindCDS, FDiffKindId) and (FDiffKindId <> 0) then
  begin
    if DiffKindCDS.Locate('Id', FDiffKindId, []) then
    begin
      beDiffKind.Text := DiffKindCDS.FieldByName('Name').AsString;
      if DiffKindCDS.FieldByName('DaysForSale').AsInteger > 0 then
        ShowPUSHMessage('ВНИМАНИЕ -   ВЫ ОБЯЗАНЫ ДОБАВИТЬ В ЛИСТ ОТКАЗА ТОЛЬКО  ТО КОЛ-ВО , КОТОРОЕ ВЫ ДОЛЖНЫ ПРОДАТЬ ЗА ' +
          DiffKindCDS.FieldByName('DaysForSale').AsString + ' ДНЕЙ.'#13#10#13#10 +
          'ЕСЛИ ВЫ ЕГО НЕ ПРОДАДИТЕ ПО ОКОНЧАНИИ ПЕРИОДА - БУДУТ НАЛОЖЕНЫ ШТРАФНЫЕ САНКЦИИ В РАЗМЕРЕ 10% ОТ СУММЫ НЕ ПРОДАННЫХ ПОЗИЦИЙ.', mtWarning);
      ceAmount.SetFocus;
    end else Close;
  end else Close;
end;

procedure TListDiffAddGoodsForm.ceAmountPropertiesChange(Sender: TObject);
  var nAmount : Currency;
begin

  Label8.Visible := False;
  if FMaxOrderAmount = 0 then Exit;

  nAmount := ceAmount.Value;
  if nAmount < 0 then nAmount := 0;

  Label8.Caption := 'Кол-во ' + CurrToStr(nAmount + FAmountDiffKind) + '  ' +
                    'Poзн. цена,грн ' + GoodsCDS.FieldByName('Price').AsString + '  ' +
                    'Сумма,грн ' + CurrToStr(RoundTo((nAmount + FAmountDiffKind) * GoodsCDS.FieldByName('Price').AsCurrency, - 2)) + '  ' +
                    'Макс. Сумма,грн ' + CurrToStr(FMaxOrderAmount);

  Label8.Visible := True;

end;

procedure TListDiffAddGoodsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var nAmount, nAmountDiffKind, nMaxOrderAmount : Currency; bSend : boolean;
begin
  if ModalResult <> mrOk then Exit;

  nAmount := ceAmount.Value;

  if nAmount = 0 then
  begin
    Action := TCloseAction.caNone;
    ShowMessage('Должно быть число не равное 0...');
    ceAmount.SetFocus;
    Exit;
  end;

  // Люба сказала отменить контролт 03.02.2020
//  if (FAmountDay + nAmount) < 0 then
//  begin
//    if FAmountDay = 0 then
//      ShowMessage('Медикамент в течении дня не добавлялся в лист оказов.')
//    else ShowMessage('Вы пытаетест отменить с листа отказов больше чем добавлено.'#13#10 +
//                     'Можно вернуть не более ' + CurrToStr(FAmountDay));
//    ceAmount.SetFocus;
//    Exit;
//  end;

  if FDiffKindId = 0 then
  begin
    Action := TCloseAction.caNone;
    ShowMessage('Вид отказа должен быть выбрано из списка...');
    actShowListDiffExecute(Sender);
    Exit;
  end;

  if not ListGoodsCDS.FieldByName('ExpirationDate').IsNull then
  begin
    if  ListGoodsCDS.FieldByName('ExpirationDate').AsDateTime < IncYear(Date, 1) then
    begin
      if not DiffKindCDS.FieldByName('isLessYear').AsBoolean then
      begin
        Action := TCloseAction.caNone;
        ShowMessage('По виду отказа <' + DiffKindCDS.FieldByName('Name').AsString + '> заказ товара со сроком годности менее года запрещен...');
        ceAmount.SetFocus;
        Exit;
      end;
    end;
  end;

  nMaxOrderAmount := DiffKindCDS.FieldByName('MaxOrderUnitAmount').AsCurrency;

  if (nAmount > 0) and (nMaxOrderAmount > 0) then
  begin

    nAmountDiffKind := 0;
    if not gc_User.Local then
    try
      MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inGoodsId').Value := GoodsCDS.FieldByName('ID').AsInteger;
      MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inDiffKindID').Value := FDiffKindId;
      MainCashForm.spSelect_CashListDiffGoods.Execute;
      if MainCashForm.CashListDiffCDS.Active and (MainCashForm.CashListDiffCDS.RecordCount = 1) then
      begin
        nAmountDiffKind := MainCashForm.CashListDiffCDS.FieldByName('AmountDiffKind').AsCurrency;
      end;
    Except
    end;

    if FileExists(ListDiff_lcl) then
    begin
      WaitForSingleObject(MutexDiffCDS, INFINITE);
      try
        LoadLocalData(ListDiffCDS, ListDiff_lcl);
      finally
        ReleaseMutex(MutexDiffCDS);
      end;
      if not ListDiffCDS.Active then ListDiffCDS.Open;

      ListDiffCDS.First;
      while not ListDiffCDS.Eof do
      begin
        if (ListDiffCDS.FieldByName('ID').AsInteger = GoodsCDS.FieldByName('ID').AsInteger) then
        begin
          if (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) = Date) then
          begin
            if not MainCashForm.CashListDiffCDS.Active or not ListDiffCDS.FieldByName('IsSend').AsBoolean then
            begin
              if (ListDiffCDS.FieldByName('DiffKindId').AsInteger = FDiffKindId)  then
                nAmountDiffKind := nAmountDiffKind + ListDiffCDS.FieldByName('Amount').AsCurrency;
            end;
          end;
        end;
        ListDiffCDS.Next;
      end;
    end;

    if ((nAmountDiffKind + nAmount) > 1) and
      (((nAmountDiffKind + nAmount) * GoodsCDS.FieldByName('Price').AsCurrency) > nMaxOrderAmount) then
    begin
      Action := TCloseAction.caNone;
      ShowMessage('Сумма заказа по позиции :'#13#10 + GoodsCDS.FieldByName('GoodsName').AsString +
        #13#10'С видом отказа "' + DiffKindCDS.FieldByName('Name').AsString +
        '" превышает ' + CurrToStr(nMaxOrderAmount) + ' грн. ...');
      ceAmount.SetFocus;
      Exit;
    end;
  end;

  if GoodsCDS.FieldByName('Id').AsInteger = 0 then
  begin
    ShowMessage('Ошибка Не выбран товар...');
    Exit;
  end;

  bSend := False;
  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    try
      CheckListDiffCDS;
      LoadLocalData(ListDiffCDS, ListDiff_lcl);
      if not ListDiffCDS.Active then ListDiffCDS.Open;
      ListDiffCDS.Append;
      ListDiffCDS.FieldByName('ID').AsInteger := GoodsCDS.FieldByName('ID').AsInteger;
      ListDiffCDS.FieldByName('Amount').AsCurrency := nAmount;
      ListDiffCDS.FieldByName('Code').AsInteger := GoodsCDS.FieldByName('GoodsCode').AsInteger;
      ListDiffCDS.FieldByName('Name').AsString := GoodsCDS.FieldByName('GoodsName').AsString;
      ListDiffCDS.FieldByName('Price').AsCurrency := GoodsCDS.FieldByName('Price').AsCurrency;
      ListDiffCDS.FieldByName('DiffKindId').AsVariant := FDiffKindId;
      ListDiffCDS.FieldByName('Comment').AsString := meComent.Text;
      ListDiffCDS.FieldByName('UserID').AsString := gc_User.Session;
      ListDiffCDS.FieldByName('UserName').AsString := gc_User.Login;
      ListDiffCDS.FieldByName('DateInput').AsDateTime := Now;
      ListDiffCDS.FieldByName('IsSend').AsBoolean := False;
      ListDiffCDS.Post;

      SaveLocalData(ListDiffCDS, ListDiff_lcl);
      bSend := True;
    Except ON E:Exception do
      ShowMessage('Ошибка сохранения листа отказов:'#13#10 + E.Message);
    end;
  finally
    ReleaseMutex(MutexDiffCDS);
      // отправка сообщения о необходимости отправки листа отказов
    if bSend then PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 4);
  end;

end;

procedure TListDiffAddGoodsForm.FormDestroy(Sender: TObject);
begin
  if MainCashForm.CashListDiffCDS.Active then MainCashForm.CashListDiffCDS.Close;
end;

procedure TListDiffAddGoodsForm.FormShow(Sender: TObject);
  var AmountDiffUser, AmountDiff, AmountDiffPrev : currency;
      AmountIncome, AmountIncomeSend, PriceSaleIncome, Remains : currency; ListDate : Variant;
      S : string; nID, nGoods : integer;
begin
  if GoodsCDS = Nil then Exit;
  FDiffKindId := 0;
  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    try
      FAmountDay := 0; AmountDiffUser := 0; AmountDiff := 0; AmountDiffPrev := 0;
      AmountIncome := 0; AmountIncomeSend := 0; PriceSaleIncome := 0; ListDate := Null;
      if not gc_User.Local then
      try
        MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inGoodsId').Value := GoodsCDS.FieldByName('ID').AsInteger;
        MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inDiffKindID').Value := 0;
        MainCashForm.spSelect_CashListDiffGoods.Execute;
        if MainCashForm.CashListDiffCDS.Active and (MainCashForm.CashListDiffCDS.RecordCount = 1) then
        begin
          AmountDiffUser := MainCashForm.CashListDiffCDS.FieldByName('AmountDiffUser').AsCurrency;
          AmountDiff := MainCashForm.CashListDiffCDS.FieldByName('AmountDiff').AsCurrency;
          FAmountDay := MainCashForm.CashListDiffCDS.FieldByName('AmountDiff').AsCurrency;
          AmountDiffPrev := MainCashForm.CashListDiffCDS.FieldByName('AmountDiffPrev').AsCurrency;
          AmountIncome := MainCashForm.CashListDiffCDS.FieldByName('AmountIncome').AsCurrency;
          AmountIncomeSend := MainCashForm.CashListDiffCDS.FieldByName('AmountSendIn').AsCurrency;
          PriceSaleIncome := MainCashForm.CashListDiffCDS.FieldByName('PriceSaleIncome').AsCurrency;
          if not MainCashForm.CashListDiffCDS.FieldByName('ListDate').IsNull then
            ListDate := MainCashForm.CashListDiffCDS.FieldByName('ListDate').AsDateTime;
        end;
      Except
      end;

      if FileExists(DiffKind_lcl) then
      begin
        WaitForSingleObject(MutexDiffKind, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          LoadLocalData(DiffKindCDS,DiffKind_lcl);
          if not DiffKindCDS.Active then DiffKindCDS.Open;
          if Assigned(DiffKindCDS.FindField('Name')) then
            DiffKindCDS.FindField('Name').DisplayLabel := 'Вид отказа';
        finally
          ReleaseMutex(MutexDiffKind);
        end;
      end;

      Remains := 0;
      try
        nGoods := GoodsCDS.FieldByName('Id').AsInteger;
        nID := MainCashForm.RemainsCDS.RecNo;
        MainCashForm.RemainsCDS.DisableControls;
        MainCashForm.RemainsCDS.Filtered := False;
        MainCashForm.RemainsCDS.First;
        while not MainCashForm.RemainsCDS.Eof do
        begin
          if MainCashForm.RemainsCDS.FieldByName('Id').AsInteger = nGoods then
          begin
            Remains := Remains + MainCashForm.RemainsCDS.FieldByName('Remains').AsCurrency +
                                 MainCashForm.RemainsCDS.FieldByName('Reserved').AsCurrency +
                                 MainCashForm.RemainsCDS.FieldByName('DeferredSend').AsCurrency;
          end;
          MainCashForm.RemainsCDS.Next;
        end;
      finally
        MainCashForm.RemainsCDS.Filtered := True;
        MainCashForm.RemainsCDS.RecNo := nID;
        MainCashForm.RemainsCDS.EnableControls;
      end;

      if FileExists(ListDiff_lcl) then
      begin
        WaitForSingleObject(MutexDiffCDS, INFINITE);
        try
          LoadLocalData(ListDiffCDS, ListDiff_lcl);
        finally
          ReleaseMutex(MutexDiffCDS);
        end;
        if not ListDiffCDS.Active then ListDiffCDS.Open;

        ListDiffCDS.First;
        while not ListDiffCDS.Eof do
        begin
          if (ListDiffCDS.FieldByName('ID').AsInteger = GoodsCDS.FieldByName('ID').AsInteger) then
          begin
            if (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) = Date) then
            begin
              if not MainCashForm.CashListDiffCDS.Active or not ListDiffCDS.FieldByName('IsSend').AsBoolean then
              begin
                if (ListDiffCDS.FieldByName('UserID').AsString = gc_User.Session) then
                  AmountDiffUser := AmountDiffUser + ListDiffCDS.FieldByName('Amount').AsCurrency;
                AmountDiff := AmountDiff + ListDiffCDS.FieldByName('Amount').AsCurrency;
                FAmountDay := FAmountDay + ListDiffCDS.FieldByName('Amount').AsCurrency;
              end;
            end else if not MainCashForm.CashListDiffCDS.Active then
              AmountDiffPrev := AmountDiffPrev + ListDiffCDS.FieldByName('Amount').AsCurrency;
          end;
          ListDiffCDS.Next;
        end;
      end;

      WaitForSingleObject(MutexGoods, INFINITE);
      try
        if FileExists(Goods_lcl) then LoadLocalData(ListGoodsCDS, Goods_lcl);
        if not ListGoodsCDS.Active then ListGoodsCDS.Open;
      finally
        ReleaseMutex(MutexGoods);
      end;
      if not ListGoodsCDS.Active then
      begin
        ShowMessage('Ошибка открытия прайсов поставщиков.');
        Exit;
      end;

      if not ListGoodsCDS.Locate('Id', GoodsCDS.FieldByName('ID').AsInteger, []) then
      begin
        ListGoodsCDS.Close;
        ShowMessage('Ошибка медикамент не найден в прайсах поставщиков.');
        Exit;
      end;

//      if ListGoodsCDS.FieldByName('isResolution_224').AsBoolean and
//        (Now < EncodeDateTime(2020, 04, 20, 16, 0, 0, 0)) then
//      begin
//        ListGoodsCDS.Close;
//        ShowMessage('Временная блокировка товара.');
//        Exit;
//      end;

      S := '';
      if AmountDiff <> 0 Then S := S +  #13#10'Отказы сегодня: ' + CurrToStr(AmountDiff);
      if AmountDiffPrev <> 0 Then S := S +  #13#10'Отказы вчера: ' + CurrToStr(AmountDiffPrev);
      if S = '' then S := #13#10'За последнии два дня отказы не найдены';
      if ListDate <> Null then S := S +  #13#10'Последний раз менеджер забрал заказ: ' + FormatDateTime('DD.mm.yyyy HH:NN', ListDate);
      if not MainCashForm.CashListDiffCDS.Active then S := #13#10'Работа автономно (Данные по кассе)' + S;
      S := 'Препарат: '#13#10 + GoodsCDS.FieldByName('GoodsName').AsString + S;
      Label1.Caption := S;

      S := '';
      if AmountDiffUser <> 0 Then S := #13#10#13#10'ВЫ УЖЕ ПОСТАВИЛИ СЕГОДНЯ - ' + CurrToStr(AmountDiffUser) + ' упк.';
      if (AmountIncome > 0) or (AmountIncomeSend > 0) then
      begin
        S := S +  #13#10#13#10'ТОВАР УЖЕ В ПУТИ: ';
        if AmountIncome > 0  then S := S +  ' от поставщика: ' + CurrToStr(AmountIncome) + 'упк.';
        if (AmountIncome > 0) and (AmountIncomeSend > 0) then S := S + ';';
        if AmountIncomeSend > 0 then S := S + ' внутрен. перещение - ' + CurrToStr(AmountIncomeSend) + 'упк.';
      end;
      S := S + #13#10#13#10'НТЗ = ' + CurrToStr(GoodsCDS.FieldByName('MCSValue').AsCurrency) + ' упк. ОСТАТОК = ' + CurrToStr(Remains) + ' упк.';
//      if ListGoodsCDS.FieldByName('isResolution_224').AsBoolean then
//      begin
//        S := S + #13#10#13#10'ВНИМАНИЕ!!!! позиция из пост 224 - '#13#10'                СТАВИТЬ в ЗАКАЗ из рассчета на 1день продаж!';
//        Label7.Font.Size := Label7.Font.Size - 2;
//      end;
      S := S + #13#10#13#10'ВАМ ДЕЙСТВИТЕЛЬНО НУЖНО БОЛЬШЕ ?!';
      Label7.Caption := S;
      Label7.Visible := Label7.Caption <> '';

      if not ListGoodsCDS.FieldByName('ExpirationDate').IsNull then
      begin
        if  ListGoodsCDS.FieldByName('ExpirationDate').AsDateTime < IncYear(Date, 1) then
        begin
          Label5.Caption := 'СРОК ГОДНОСТИ МЕНЕЕ ГОДА - ' + ListGoodsCDS.FieldByName('ExpirationDate').AsString;
          Label5.Font.Color := clRed;
        end else
        begin
          Label5.Caption := 'Срок годности - ' + ListGoodsCDS.FieldByName('ExpirationDate').AsString;
          Label5.Font.Color := clWindowText
        end;
      end else
      begin
        Label5.Caption := 'СРОК ГОДНОСТИ НЕ НАЙДЕН';
        Label5.Font.Color := clRed;
      end;

      TimerStart.Enabled := True;
    Except ON E:Exception do
      ShowMessage('Ошибка открытия листа отказов:'#13#10 + E.Message);
    end;
  finally
    ReleaseMutex(MutexDiffCDS);
    if not ListGoodsCDS.Active then PostMessage(Handle, WM_CLOSE, 0, 0);
  end;
end;

procedure TListDiffAddGoodsForm.lcbDiffKindPropertiesChange(Sender: TObject);
begin

  Label8.Visible := False;

  FMaxOrderAmount := 0;
  FAmountDiffKind := 0;
  if FDiffKindId = 0 then Exit;

  if not DiffKindCDS.Locate('Id', FDiffKindId, []) then Exit;

  FMaxOrderAmount := DiffKindCDS.FieldByName('MaxOrderUnitAmount').AsCurrency;

  if FMaxOrderAmount = 0 then Exit;

  if not gc_User.Local then
  try
    MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inGoodsId').Value := GoodsCDS.FieldByName('ID').AsInteger;
    MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inDiffKindID').Value := FDiffKindId;
    MainCashForm.spSelect_CashListDiffGoods.Execute;
    if MainCashForm.CashListDiffCDS.Active and (MainCashForm.CashListDiffCDS.RecordCount = 1) then
    begin
      FAmountDiffKind := MainCashForm.CashListDiffCDS.FieldByName('AmountDiffKind').AsCurrency;
    end;
  Except
  end;

  if FileExists(ListDiff_lcl) then
  begin
    WaitForSingleObject(MutexDiffCDS, INFINITE);
    try
      LoadLocalData(ListDiffCDS, ListDiff_lcl);
    finally
      ReleaseMutex(MutexDiffCDS);
    end;
    if not ListDiffCDS.Active then ListDiffCDS.Open;

    ListDiffCDS.First;
    while not ListDiffCDS.Eof do
    begin
      if (ListDiffCDS.FieldByName('ID').AsInteger = GoodsCDS.FieldByName('ID').AsInteger) then
      begin
        if (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) = Date) then
        begin
          if not MainCashForm.CashListDiffCDS.Active or not ListDiffCDS.FieldByName('IsSend').AsBoolean then
          begin
            if (ListDiffCDS.FieldByName('DiffKindId').AsInteger = FDiffKindId)  then
              FAmountDiffKind := FAmountDiffKind + ListDiffCDS.FieldByName('Amount').AsCurrency;
          end;
        end;
      end;
      ListDiffCDS.Next;
    end;
  end;

  ceAmountPropertiesChange(Sender);

end;

procedure TListDiffAddGoodsForm.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := False;
  actShowListDiffExecute(Sender);
end;

end.
