unit ListDiffAddGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  System.DateUtils, Dialogs, StdCtrls, Mask, CashInterface, DB, Buttons,
  Gauges, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit,
  cxClasses, cxPropertiesStore, dsdAddOn, dxSkinsCore, dxSkinsDefaultPainters,
  Datasnap.DBClient, Vcl.Menus, cxButtons, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, cxMaskEdit;

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
    lcbDiffKind: TcxLookupComboBox;
    DiffKindCDS: TClientDataSet;
    DiffKindDS: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FListGoodsCDS : TClientDataSet;
    FAmountDay : Currency;
  public

    property ListGoodsCDS : TClientDataSet read FListGoodsCDS write FListGoodsCDS;
  end;

implementation

{$R *.dfm}

uses CommonData, LocalWorkUnit, MainCash2, ListDiff;

var MutexDiffCDS, MutexDiffKind: THandle;

{ TListDiffAddGoodsForm }

procedure TListDiffAddGoodsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var nAmount : Currency; bSend : boolean;
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

  if (FAmountDay + nAmount) < 0 then
  begin
    if FAmountDay = 0 then
      ShowMessage('Медикамент в течении дня не добавлялся в лист оказов.')
    else ShowMessage('Вы пытаетест отменить с листа отказов больше чем добавлено.'#13#10 +
                     'Можно вернуть не более ' + CurrToStr(FAmountDay));
    ceAmount.SetFocus;
    Exit;
  end;

  if lcbDiffKind.EditValue = Null then
  begin
    Action := TCloseAction.caNone;
    ShowMessage('Вид отказа должен быть выбрано из списка...');
    lcbDiffKind.SetFocus;
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
      ListDiffCDS.FieldByName('ID').AsInteger := ListGoodsCDS.FieldByName('ID').AsInteger;
      ListDiffCDS.FieldByName('Amount').AsCurrency := nAmount;
      ListDiffCDS.FieldByName('Code').AsInteger := ListGoodsCDS.FieldByName('GoodsCode').AsInteger;
      ListDiffCDS.FieldByName('Name').AsString := ListGoodsCDS.FieldByName('GoodsName').AsString;
      ListDiffCDS.FieldByName('Price').AsCurrency := ListGoodsCDS.FieldByName('Price').AsCurrency;
      ListDiffCDS.FieldByName('DiffKindId').AsVariant := lcbDiffKind.EditValue;
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

procedure TListDiffAddGoodsForm.FormShow(Sender: TObject);
  var AmountDiffUser, AmountDiff, AmountDiffPrev : currency;
      S : string;
begin
  if ListGoodsCDS = Nil then Exit;
  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    try
      FAmountDay := 0; AmountDiffUser := 0; AmountDiff := 0; AmountDiffPrev := 0;
      if not gc_User.Local then
      try
        MainCashForm.spSelect_CashListDiffGoods.Params.ParamByName('inGoodsId').Value := ListGoodsCDS.FieldByName('ID').AsInteger;
        MainCashForm.spSelect_CashListDiffGoods.Execute;
        if MainCashForm.CashListDiffCDS.Active and (MainCashForm.CashListDiffCDS.RecordCount = 1) then
        begin
          AmountDiffUser := MainCashForm.CashListDiffCDS.FieldByName('AmountDiffUser').AsCurrency;
          AmountDiff := MainCashForm.CashListDiffCDS.FieldByName('AmountDiff').AsCurrency;
          FAmountDay := MainCashForm.CashListDiffCDS.FieldByName('AmountDiff').AsCurrency;
          AmountDiffPrev := MainCashForm.CashListDiffCDS.FieldByName('AmountDiffPrev').AsCurrency;
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
          if (ListDiffCDS.FieldByName('ID').AsInteger = ListGoodsCDS.FieldByName('ID').AsInteger) then
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

      S := '';
      if AmountDiff <> 0 Then S := S +  #13#10'Отказы сегодня: ' + FormatCurr(',0.000', AmountDiff);
      if AmountDiffUser <> 0 Then S := S +  #13#10'  в том числе вами: ' + FormatCurr(',0.000', AmountDiffUser);
      if AmountDiffPrev <> 0 Then S := S +  #13#10'Отказы вчера: ' + FormatCurr(',0.000', AmountDiffPrev);
      if S = '' then S := #13#10'За последнии два дня отказы не найдены';
      if not MainCashForm.CashListDiffCDS.Active then S := #13#10'Работа автономно (Данные по кассе)' + S;
      S := 'Препарат: '#13#10 + ListGoodsCDS.FieldByName('GoodsName').AsString + S;
      Label1.Caption := S;

    Except ON E:Exception do
      ShowMessage('Ошибка открытия листа отказов:'#13#10 + E.Message);
    end;
  finally
    ReleaseMutex(MutexDiffCDS);
    if MainCashForm.CashListDiffCDS.Active then MainCashForm.CashListDiffCDS.Close;
  end;
end;

end.
