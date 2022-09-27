unit ListDiffAddGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  System.DateUtils, Dialogs, StdCtrls, Mask, CashInterface, DB, Buttons,
  Gauges, cxGraphics, cxControls, cxLookAndFeels, Math, System.StrUtils,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit,
  cxClasses, cxPropertiesStore, dsdAddOn, dxSkinsCore, dxSkinsDefaultPainters,
  Datasnap.DBClient, Vcl.Menus, cxButtons, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, cxMaskEdit, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, cxButtonEdit, ChoiceListDiff, dsdDB, dsdAction;

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
    CheckCDS: TClientDataSet;
    spExistsRemainsGoods: TdsdStoredProc;
    actCustomerThresho_RemainsGoodsCash: TdsdOpenForm;
    DiffKindPriceCDS: TClientDataSet;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ceAmountPropertiesChange(Sender: TObject);
    procedure lcbDiffKindPropertiesChange(Sender: TObject);
    procedure actShowListDiffExecute(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
  private
    FDiffKindId : Integer;
    FAmountDay : Currency;
    FAmountDiffKind, FMaxOrderAmount, FPackages : Currency;

    FPrice, FNDS, FMCSValue : Currency;
    FGoodsId, FGoodsCode, FNDSKindId : Integer;
    FGoodsName : String;

    // Сохранение чека в локальной базе.
    function SaveLocal(AManagerId: Integer; AManagerName, ABayerName: String; AAmount : Currency): Boolean;
  public
    property Price : Currency read FPrice write FPrice;
    property NDS : Currency read FNDS write FNDS;
    property MCSValue : Currency read FMCSValue write FMCSValue;
    property NDSKindId : Integer read FNDSKindId write FNDSKindId;

    property GoodsId : Integer read FGoodsId write FGoodsId;
    property GoodsCode : Integer read FGoodsCode write FGoodsCode;
    property GoodsName : String read FGoodsName write FGoodsName;
  end;

implementation

{$R *.dfm}

uses CommonData, LocalWorkUnit, MainCash2, ListDiff, PUSHMessage, VIPDialog;

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
  if (FMaxOrderAmount = 0) and (FPackages = 0) then Exit;

  nAmount := ceAmount.Value;
  if nAmount < 0 then nAmount := 0;

  Label8.Caption := 'Кол-во ' + CurrToStr(nAmount + FAmountDiffKind) + '  ' +
                    'Poзн. цена,грн ' + CurrToStr(FPrice) + '  ' +
                    'Сумма,грн ' + CurrToStr(RoundTo((nAmount + FAmountDiffKind) * FPrice, - 2)) +
                    IfThen (FMaxOrderAmount = 0, '', '  Макс. Сумма,грн ' + CurrToStr(FMaxOrderAmount)) +
                    IfThen (FPackages = 0, '', '  Макс. кол-во уп. ' + CurrToStr(FMaxOrderAmount));

  Label8.Visible := True;

end;

procedure TListDiffAddGoodsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var nAmount, nAmountDiffKind, nMaxOrderAmount, nPackages : Currency; bSend : boolean;
      ManagerID: Integer; ManagerName, BayerName: String;
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
  nPackages := DiffKindCDS.FieldByName('Packages').AsCurrency;

  if (nAmount > 0) and (nMaxOrderAmount > 0) then
  begin

    nAmountDiffKind := 0;
    if not gc_User.Local then
    try
      MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inGoodsId').Value := FGoodsId;
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
        if not ListDiffCDS.Active then
        begin
          DeleteLocalData(ListDiff_lcl);
          CheckListDiffCDS;
          LoadLocalData(ListDiffCDS, ListDiff_lcl);
        end;
      finally
        ReleaseMutex(MutexDiffCDS);
      end;

      ListDiffCDS.First;
      while not ListDiffCDS.Eof do
      begin
        if (ListDiffCDS.FieldByName('ID').AsInteger = FGoodsId) then
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
      (((nAmountDiffKind + nAmount) * FPrice) > nMaxOrderAmount) then
    begin
      Action := TCloseAction.caNone;
      ShowMessage('Сумма заказа по позиции :'#13#10 + FGoodsName +
        #13#10'С видом отказа "' + DiffKindCDS.FieldByName('Name').AsString +
        '" превышает ' + CurrToStr(nMaxOrderAmount) + ' грн. ...');
      ceAmount.SetFocus;
      Exit;
    end;
  end;

  if (nAmount > 0) and (nPackages > 0) then
  begin

    nAmountDiffKind := 0;
    if not gc_User.Local then
    try
      MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inGoodsId').Value := FGoodsId;
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
        if not ListDiffCDS.Active then
        begin
          DeleteLocalData(ListDiff_lcl);
          CheckListDiffCDS;
          LoadLocalData(ListDiffCDS, ListDiff_lcl);
        end;
      finally
        ReleaseMutex(MutexDiffCDS);
      end;

      ListDiffCDS.First;
      while not ListDiffCDS.Eof do
      begin
        if (ListDiffCDS.FieldByName('ID').AsInteger = FGoodsId) then
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
      ((nAmountDiffKind + nAmount) > nPackages) then
    begin
      Action := TCloseAction.caNone;
      ShowMessage('Количество заказа по позиции :'#13#10 + FGoodsName +
        #13#10'С видом отказа "' + DiffKindCDS.FieldByName('Name').AsString +
        '" превышает ' + CurrToStr(nPackages) + ' уп. ...');
      ceAmount.SetFocus;
      Exit;
    end;
  end;

  if Pos('1303', DiffKindCDS.FieldByName('Name').AsString) > 0 then
  begin
    if MainCashForm.UnitConfigCDS.FieldByName('PartnerMedicalID').IsNull then
    begin
      Action := TCloseAction.caNone;
      ShowMessage('Аптека не подключена к СП по постановлению 1303'#13#10'Использование вида отказа <' + DiffKindCDS.FieldByName('Name').AsString + '> запрещено...');
      beDiffKind.SetFocus;
      Exit;
    end;

    if ListGoodsCDS.FieldByName('PriceOOC1303').AsCurrency = 0 then
    begin
      Action := TCloseAction.caNone;
      ShowMessage('Товар <' + FGoodsName + '> не участвует в СП по постановлению 1303...');
      beDiffKind.SetFocus;
      Exit;
    end;

    if FNDS = 20 then
    begin
      Action := TCloseAction.caNone;
      ShowMessage('Запрещено использовать товар <' + FGoodsName + '> с НДС 20% в СП по постановлению 1303...');
      beDiffKind.SetFocus;
      Exit;
    end;


    if (ListGoodsCDS.FieldByName('PriceOOC1303').AsCurrency < ListGoodsCDS.FieldByName('JuridicalPrice').AsCurrency) and
      ((ListGoodsCDS.FieldByName('JuridicalPrice').AsCurrency / ListGoodsCDS.FieldByName('PriceOOC1303').AsCurrency * 100.0 - 100) >
      MainCashForm.UnitConfigCDS.FindField('DeviationsPrice1303').AsCurrency) then
    begin
      Action := TCloseAction.caNone;
      ShowMessage('Отпускная цена товара <' + FGoodsName + '> выше чем по реестру товаров соц. проекта 1303...');
      beDiffKind.SetFocus;
      Exit;
    end;
  end;

  if DiffKindPriceCDS.Active then
  begin
    try
      DiffKindPriceCDS.Filter := 'DiffKindId = ' + DiffKindCDS.FieldByName('Id').AsString  +
                                 ' and MinPrice <= ' + CurrToStr(FPrice) +
                                 ' and MaxPrice > ' + CurrToStr(FPrice);
      DiffKindPriceCDS.Filtered := True;
      if DiffKindPriceCDS.RecordCount = 1 then
      begin
        if ((nAmountDiffKind + nAmount) > 1) and (DiffKindPriceCDS.FieldByName('Amount').AsCurrency > 0) and
          ((nAmountDiffKind + nAmount) > DiffKindPriceCDS.FieldByName('Amount').AsCurrency) then
        begin
          Action := TCloseAction.caNone;
          ShowMessage('Количество заказа по позиции :'#13#10 + FGoodsName +
            #13#10'С видом отказа "' + DiffKindCDS.FieldByName('Name').AsString +
            ' и ценой ' + CurrToStr(FPrice) +
            ' " превышает ' + CurrToStr(DiffKindPriceCDS.FieldByName('Amount').AsCurrency) + ' уп. ...');
          ceAmount.SetFocus;
          Exit;
        end;

        if ((nAmountDiffKind + nAmount) > 1) and (DiffKindPriceCDS.FieldByName('Summa').AsCurrency > 0) and
          (((nAmountDiffKind + nAmount) * FPrice) > DiffKindPriceCDS.FieldByName('Summa').AsCurrency) then
        begin
          Action := TCloseAction.caNone;
          ShowMessage('Сумма заказа по позиции :'#13#10 + FGoodsName +
            #13#10'С видом отказа "' + DiffKindCDS.FieldByName('Name').AsString +
            ' и ценой ' + CurrToStr(FPrice) +
            '" превышает ' + CurrToStr(DiffKindPriceCDS.FieldByName('Amount').AsCurrency) + ' грн. ...');
          ceAmount.SetFocus;
          Exit;
        end;
      end;
    finally
      DiffKindPriceCDS.Filtered := False;
      DiffKindPriceCDS.Filter := '';
    end;
  end;


  if FGoodsId = 0 then
  begin
    Action := TCloseAction.caNone;
    ShowMessage('Ошибка Не выбран товар...');
    Exit;
  end;

  if DiffKindCDS.FieldByName('isFindLeftovers').AsBoolean and
     (FPrice >= MainCashForm.UnitConfigCDS.FindField('CustomerThreshold').AsCurrency) then
  begin
    if not gc_User.Local then
    begin
      spExistsRemainsGoods.ParamByName('inGoodsId').Value := FGoodsId;
      spExistsRemainsGoods.ParamByName('outThereIs').Value := False;
      spExistsRemainsGoods.Execute;
      if spExistsRemainsGoods.ParamByName('outThereIs').Value then
      begin
        ShowMessage('Заказываемый товар есть в наличии по другим аптекам.'#13#10#13#10 +
                    'Менеджер по возможности создаст на вас перемещение либо разблокирует товар для заказа у поставщика.');
//        actCustomerThresho_RemainsGoodsCash.GuiParams.ParamByName('GoodsId').Value := FGoodsId;
//        actCustomerThresho_RemainsGoodsCash.GuiParams.ParamByName('GoodsCode').Value := GoodsCDS.FieldByName('GoodsCode').AsInteger;
//        actCustomerThresho_RemainsGoodsCash.GuiParams.ParamByName('GoodsName').Value := FGoodsName;
//        actCustomerThresho_RemainsGoodsCash.GuiParams.ParamByName('Amount').Value := nAmount;
//        actCustomerThresho_RemainsGoodsCash.Execute;
      end;
    end;
  end;

  if DiffKindCDS.FieldByName('isFormOrder').AsBoolean then
  begin
    if not VIPDialogExecute(ManagerID, ManagerName, BayerName) then
    begin
      Action := TCloseAction.caNone;
      ceAmount.SetFocus;
      Exit;
    end;
  end;

  bSend := False;
  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    try
      CheckListDiffCDS;
      LoadLocalData(ListDiffCDS, ListDiff_lcl);
      if not ListDiffCDS.Active then
      begin
        DeleteLocalData(ListDiff_lcl);
        CheckListDiffCDS;
        LoadLocalData(ListDiffCDS, ListDiff_lcl);
      end;

      ListDiffCDS.Append;
      ListDiffCDS.FieldByName('ID').AsInteger := FGoodsId;
      ListDiffCDS.FieldByName('Amount').AsCurrency := nAmount;
      ListDiffCDS.FieldByName('Code').AsInteger := FGoodsCode;
      ListDiffCDS.FieldByName('Name').AsString := FGoodsName;
      ListDiffCDS.FieldByName('Price').AsCurrency := FPrice;
      ListDiffCDS.FieldByName('DiffKindId').AsVariant := FDiffKindId;
      ListDiffCDS.FieldByName('Comment').AsString := meComent.Text;
      ListDiffCDS.FieldByName('UserID').AsString := gc_User.Session;
      ListDiffCDS.FieldByName('UserName').AsString := gc_User.Login;
      ListDiffCDS.FieldByName('DateInput').AsDateTime := Now;
      ListDiffCDS.FieldByName('IsSend').AsBoolean := False;
      ListDiffCDS.Post;

      SaveLocalData(ListDiffCDS, ListDiff_lcl);
      if DiffKindCDS.FieldByName('isFormOrder').AsBoolean then SaveLocal(ManagerId, ManagerName, BayerName, nAmount);
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
      S : string; nID : integer;
begin
  if FGoodsId = 0 then Exit;
  FDiffKindId := 0;
  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    try
      FAmountDay := 0; AmountDiffUser := 0; AmountDiff := 0; AmountDiffPrev := 0;
      AmountIncome := 0; AmountIncomeSend := 0; PriceSaleIncome := 0; ListDate := Null;
      if not gc_User.Local then
      try
        MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inGoodsId').Value := FGoodsId;
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

      if FileExists(DiffKindPrice_lcl) then
      begin
        WaitForSingleObject(MutexDiffKind, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          LoadLocalData(DiffKindPriceCDS,DiffKindPrice_lcl);
          if not DiffKindPriceCDS.Active then DiffKindPriceCDS.Open;
        finally
          ReleaseMutex(MutexDiffKind);
        end;
      end;

      Remains := 0;
      try
        nID := MainCashForm.RemainsCDS.RecNo;
        MainCashForm.RemainsCDS.DisableControls;
        MainCashForm.RemainsCDS.Filtered := False;
        MainCashForm.RemainsCDS.First;
        while not MainCashForm.RemainsCDS.Eof do
        begin
          if MainCashForm.RemainsCDS.FieldByName('Id').AsInteger = FGoodsId then
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
        LoadLocalData(ListDiffCDS, ListDiff_lcl);
        if not ListDiffCDS.Active then
        begin
          DeleteLocalData(ListDiff_lcl);
          CheckListDiffCDS;
          LoadLocalData(ListDiffCDS, ListDiff_lcl);
        end;

        ListDiffCDS.First;
        while not ListDiffCDS.Eof do
        begin
          if (ListDiffCDS.FieldByName('ID').AsInteger = FGoodsId) then
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

      if not ListGoodsCDS.Locate('Id', FGoodsId, []) then
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
      S := 'Препарат: '#13#10 + FGoodsName + S;
      Label1.Caption := S;

      S := '';
      if ListGoodsCDS.FieldByName('IsClose').AsBoolean then
      begin
        S := #13#10#13#10'ВНИМАНИЕ! Код  закрыт для заказа МАРКЕТИНГОМ.'#13#10'См. аналог. товар (колонка "Закрыт для заказа")' + S;
        Label7.Font.Size := Label7.Font.Size - 2;
      end;
      if AmountDiffUser <> 0 Then S := #13#10#13#10'ВЫ УЖЕ ПОСТАВИЛИ СЕГОДНЯ - ' + CurrToStr(AmountDiffUser) + ' упк.';
      if (AmountIncome > 0) or (AmountIncomeSend > 0) then
      begin
        S := S +  #13#10#13#10'ТОВАР УЖЕ В ПУТИ: ';
        if AmountIncome > 0  then S := S +  ' от поставщика: ' + CurrToStr(AmountIncome) + 'упк.';
        if (AmountIncome > 0) and (AmountIncomeSend > 0) then S := S + ';';
        if AmountIncomeSend > 0 then S := S + ' внутрен. перещение - ' + CurrToStr(AmountIncomeSend) + 'упк.';
      end;
      S := S + #13#10#13#10'НТЗ = ' + CurrToStr(FMCSValue) + ' упк. ОСТАТОК = ' + CurrToStr(Remains) + ' упк.';
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
  FPackages := 0;
  FAmountDiffKind := 0;
  if FDiffKindId = 0 then Exit;

  if not DiffKindCDS.Locate('Id', FDiffKindId, []) then Exit;

  FMaxOrderAmount := DiffKindCDS.FieldByName('MaxOrderUnitAmount').AsCurrency;
  FPackages := DiffKindCDS.FieldByName('Packages').AsCurrency;

  if (FMaxOrderAmount = 0) and (FPackages = 0) then Exit;

  if not gc_User.Local then
  try
    MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inGoodsId').Value := FGoodsId;
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
      if not ListDiffCDS.Active then
      begin
        DeleteLocalData(ListDiff_lcl);
        CheckListDiffCDS;
        LoadLocalData(ListDiffCDS, ListDiff_lcl);
      end;
    finally
      ReleaseMutex(MutexDiffCDS);
    end;

    ListDiffCDS.First;
    while not ListDiffCDS.Eof do
    begin
      if (ListDiffCDS.FieldByName('ID').AsInteger = FGoodsId) then
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

// Сохранение чека в локальной базе.
function TListDiffAddGoodsForm.SaveLocal(AManagerId: Integer; AManagerName, ABayerName: String; AAmount : Currency): Boolean;
  var UID: String;
begin

  UID := '';
  if CheckCDS.Active then CheckCDS.Close;
  CheckCDS.FieldDefs.Clear;
  CheckCDS.FieldDefs.Assign(MainCashForm.CheckCDS.FieldDefs);
  CheckCDS.CreateDataSet;

  CheckCDS.Append;
  CheckCDS.FieldByName('Id').AsInteger := 0;
  CheckCDS.FieldByName('ParentId').AsInteger := 0;
  CheckCDS.FieldByName('GoodsId').AsInteger := FGoodsId;
  CheckCDS.FieldByName('GoodsCode').AsInteger := FGoodsCode;
  CheckCDS.FieldByName('GoodsName').AsString := FGoodsName;
  CheckCDS.FieldByName('Amount').asCurrency := AAmount;
  CheckCDS.FieldByName('Price').asCurrency := FPrice;
  CheckCDS.FieldByName('Summ').asCurrency := GetSumm(AAmount, FPrice, True);
  CheckCDS.FieldByName('NDS').asCurrency := FNDS;
  CheckCDS.FieldByName('NDSKindId').AsInteger := FNDSKindId;
  CheckCDS.FieldByName('DiscountExternalID').AsVariant := Null;
  CheckCDS.FieldByName('DiscountExternalName').AsVariant := Null;
  CheckCDS.FieldByName('DivisionPartiesID').AsVariant := Null;
  CheckCDS.FieldByName('DivisionPartiesName').AsVariant :=Null;
  CheckCDS.FieldByName('isErased').AsBoolean := false;
  // ***20.07.16
  CheckCDS.FieldByName('PriceSale').asCurrency := FPrice;
  CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
  CheckCDS.FieldByName('SummChangePercent').asCurrency := 0;
  // ***19.08.16
  CheckCDS.FieldByName('AmountOrder').asCurrency := 0;
  // ***10.08.16
  CheckCDS.FieldByName('List_UID').AsString := GenerateGUID;
  // ***04.09.18
  CheckCDS.FieldByName('Remains').asCurrency := 0;
  // ***31.03.19
  CheckCDS.FieldByName('DoesNotShare').AsBoolean := False;
  // ***31.03.19
  CheckCDS.FieldByName('isPresent').AsBoolean := False;

  CheckCDS.Post;

  MainCashForm.SaveLocal(CheckCDS, AManagerId, AManagerName, ABayerName,
    '', 'Не подтвержден', '', '', 0, '', '', 0, '', '', '', '', Date, 0,
    '', 0, 0, 0, 0, 0, 0, 0, 0, True, 0, '', 0, 0, 0, 0, '', '', '', '', '',
    0, 0, False, False, false, false, 0, false, 0, false, false, false, 0, '', 0, UID);

end;


end.
