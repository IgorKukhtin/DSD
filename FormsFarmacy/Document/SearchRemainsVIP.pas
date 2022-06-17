unit SearchRemainsVIP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxBarPainter, dsdAddOn, Vcl.ActnList, dsdAction, Data.DB, Math,
  Datasnap.DBClient, dxBarExtItems, dxBar, cxClasses, dsdDB, cxPropertiesStore,
  Vcl.ExtCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxDBData, cxTextEdit, cxCurrencyEdit, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxLabel, dsdGuides, cxMaskEdit, cxButtonEdit;

type
  TSearchRemainsVIPForm = class(TForm)
    Panel1: TPanel;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    spSelect: TdsdStoredProc;
    DataSource: TDataSource;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbToExcel: TdxBarButton;
    bbStaticText: TdxBarButton;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bb: TdxBarControlContainerItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    ClientDataSet: TClientDataSet;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actExportExel: TdsdGridToExcel;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel2: TPanel;
    Panel3: TPanel;
    edGoodsSearch: TcxTextEdit;
    cxLabel2: TcxLabel;
    edCodeSearch: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colNDS: TcxGridDBColumn;
    colPriceSale: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    AmountReserve: TcxGridDBColumn;
    colMinExpirationDate: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    colColor_calc: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxGridSelected: TcxGrid;
    cxGridDBTableViewSelectedchUnitName: TcxGridDBColumn;
    cxGridDBTableViewSelectedchGoodsCode: TcxGridDBColumn;
    cxGridDBTableViewSelectedchGoodsName: TcxGridDBColumn;
    cxGridDBTableViewSelectedchAmount: TcxGridDBColumn;
    cxGridLevelSelected: TcxGridLevel;
    SelectedDS: TDataSource;
    SelectedCDS: TClientDataSet;
    cxGridDBTableViewSelected: TcxGridDBTableView;
    SelectedCDSId: TIntegerField;
    SelectedCDSGoodsCode: TIntegerField;
    SelectedCDSGoodsName: TStringField;
    SelectedCDSUnitId: TIntegerField;
    SelectedCDSUnitName: TStringField;
    SelectedCDSAmount: TCurrencyField;
    actCreteSend: TAction;
    dxBarButton6: TdxBarButton;
    edUnit: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesUnit: TdsdGuides;
    actOpenChoiceUnitTree: TOpenChoiceForm;
    colAmountSun: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    dsdDBViewAddOnSelected: TdsdDBViewAddOn;
    UnitCDS: TClientDataSet;
    UnitCDSUnitId: TIntegerField;
    UnitCDSMovementId: TIntegerField;
    gpInsertUpdate_SendVIP: TdsdStoredProc;
    gpInsertUpdate_MI_SendVIP: TdsdStoredProc;
    colPriceSaleUnit: TcxGridDBColumn;
    spGet: TdsdStoredProc;
    UnitCDSSumma: TCurrencyField;
    SelectedCDSPrice: TCurrencyField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure edSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBTableViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBTableViewDblClick(Sender: TObject);
    procedure actCreteSendExecute(Sender: TObject);
    procedure SelectedCDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
    function CreteSend : boolean;
  public
    { Public declarations }
  end;

var
  SearchRemainsVIPForm: TSearchRemainsVIPForm;

implementation

{$R *.dfm}

function TSearchRemainsVIPForm.CreteSend : boolean;
  var Urgently : boolean;
begin
  Result := False;

  case MessageDlg('Внимание перемещение не созданы'#13#10#13#10 +
        'Yes    - Перемещение с признаком СРОЧНО' + #13#10 +
        'No     - Простое перемещение' + #13#10 +
        'Cancel - Продолжить поиск',
        mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
    mrYes : Urgently := True;
    mrCancel : Exit;
    else Urgently := False;
  end;

  UnitCDS.EmptyDataSet;

  // Создание документов

  SelectedCDS.DisableControls;
  try

    // Считаем суммы по подразделениям
    SelectedCDS.First;
    while not SelectedCDS.EOF do
    begin
      if not UnitCDS.Locate('UnitId', SelectedCDS.FieldByName('UnitId').AsInteger, []) then
      begin
        UnitCDS.Append;
        UnitCDS.FieldByName('UnitId').AsInteger := SelectedCDS.FieldByName('UnitId').AsInteger;
        UnitCDS.FieldByName('Summa').AsCurrency := RoundTo(SelectedCDS.FieldByName('Amount').AsCurrency * SelectedCDS.FieldByName('Price').AsCurrency, - 2);
        UnitCDS.FieldByName('MovementId').AsVariant := Null;
        UnitCDS.Post;
      end else
      begin
        UnitCDS.Edit;
        UnitCDS.FieldByName('Summa').AsCurrency := UnitCDS.FieldByName('Summa').AsCurrency +
          RoundTo(SelectedCDS.FieldByName('Amount').AsCurrency * SelectedCDS.FieldByName('Price').AsCurrency, - 2);
        UnitCDS.Post;
      end;
      SelectedCDS.Next;
    end;

    // Проверяем для срочных сумму
    if Urgently and (spGet.ParamByName('SummaUrgentlySendVIP').AsFloat > 0) then
    begin
      UnitCDS.First;
      while not UnitCDS.EOF do
      begin
        if UnitCDS.FieldByName('Summa').AsCurrency < spGet.ParamByName('SummaUrgentlySendVIP').AsFloat then
        begin
          SelectedCDS.Locate('UnitId', UnitCDS.FieldByName('UnitId').AsInteger, []);
          ShowMessage('Сумма перемещения по подразделению:'#13#10 + SelectedCDS.FieldByName('UnitName').AsString + #13#10 +
            FormatFloat(',0.00', UnitCDS.FieldByName('Summa').AsCurrency) + ' меньше лимита для срочных перемещений ' +
            FormatFloat(',0.00', spGet.ParamByName('SummaUrgentlySendVIP').AsFloat));
          Exit;
        end;
        UnitCDS.Next;
      end;
    end;

    // Проверяем для срочных сумму
    if  (spGet.ParamByName('SummaFormSendVIP').AsFloat > 0) then
    begin
      UnitCDS.First;
      while not UnitCDS.EOF do
      begin
        if UnitCDS.FieldByName('Summa').AsCurrency < spGet.ParamByName('SummaFormSendVIP').AsFloat then
        begin
          SelectedCDS.Locate('UnitId', UnitCDS.FieldByName('UnitId').AsInteger, []);
          ShowMessage('Сумма перемещения по подразделению:'#13#10 + SelectedCDS.FieldByName('UnitName').AsString + #13#10 +
            FormatFloat(',0.00', UnitCDS.FieldByName('Summa').AsCurrency) + ' меньше суммы для формировании перемещений VIP ' +
            FormatFloat(',0.00', spGet.ParamByName('SummaFormSendVIP').AsFloat));
          Exit;
        end;
        UnitCDS.Next;
      end;
    end;

    UnitCDS.EmptyDataSet;
    SelectedCDS.First;
    while not SelectedCDS.EOF do
    begin
      if not UnitCDS.Locate('UnitId', SelectedCDS.FieldByName('UnitId').AsInteger, []) then
      begin
        gpInsertUpdate_SendVIP.ParamByName('ioId').Value := 0;
        gpInsertUpdate_SendVIP.ParamByName('inFromId').Value := SelectedCDS.FieldByName('UnitId').AsInteger;
        gpInsertUpdate_SendVIP.ParamByName('inToId').Value := GuidesUnit.Key;
        gpInsertUpdate_SendVIP.ParamByName('inisUrgently').Value := Urgently;
        gpInsertUpdate_SendVIP.Execute;
        if gpInsertUpdate_SendVIP.ParamByName('ioId').Value = 0 then
        begin
          ShowMessage('Ошибка создания перемещения.');
          Exit;
        end;
        UnitCDS.Append;
        UnitCDS.FieldByName('UnitId').AsInteger := SelectedCDS.FieldByName('UnitId').AsInteger;
        UnitCDS.FieldByName('MovementId').AsInteger := gpInsertUpdate_SendVIP.ParamByName('ioId').Value;
        UnitCDS.Post;
      end;

      gpInsertUpdate_MI_SendVIP.ParamByName('ioId').Value := 0;
      gpInsertUpdate_MI_SendVIP.ParamByName('inMovementId').Value := UnitCDS.FieldByName('MovementId').AsInteger;
      gpInsertUpdate_MI_SendVIP.ParamByName('inGoodsId').Value := SelectedCDS.FieldByName('Id').AsInteger;
      gpInsertUpdate_MI_SendVIP.ParamByName('inAmount').Value := SelectedCDS.FieldByName('Amount').AsCurrency;
      gpInsertUpdate_MI_SendVIP.Execute;

      SelectedCDS.Next;
    end;
  finally
    SelectedCDS.EnableControls;
  end;

  SelectedCDS.EmptyDataSet;
end;

procedure TSearchRemainsVIPForm.actCreteSendExecute(Sender: TObject);
begin
  if (GuidesUnit.Key = '0') OR (GuidesUnit.Key = '') then
  begin
    ShowMessage('Не выбрано подразделение.');
    Exit;
  end;

  if SelectedCDS.RecordCount > 0 then
  begin
    if MessageDlg('Формировать перемещение по выбранному товару',
       mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

    CreteSend
  end else ShowMessage('Не выбраны товары.');
end;

procedure TSearchRemainsVIPForm.cxGridDBTableViewDblClick(Sender: TObject);
  var Key: Word;
begin
  Key := VK_RETURN;
  cxGridDBTableViewKeyDown(Sender, Key, []);
end;

procedure TSearchRemainsVIPForm.cxGridDBTableViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not ClientDataSet.Active then Exit;

  if (Key = VK_RETURN) AND (ClientDataSet.RecordCount > 0) then
  Begin
    if SelectedCDS.Locate('ID;UnitId',
        VarArrayOf([ClientDataSet.FieldByName('Id').AsInteger,
        ClientDataSet.FieldByName('UnitId').AsInteger]), []) then
    begin
      if SelectedCDS.FieldByName('Amount').AsCurrency < ClientDataSet.FieldByName('Amount').AsCurrency then
      begin
        SelectedCDS.Edit;
        SelectedCDS.FieldByName('Amount').AsCurrency    := Min(SelectedCDS.FieldByName('Amount').AsCurrency + 1,
           SelectedCDS.FieldByName('Amount').AsCurrency + ClientDataSet.FieldByName('Amount').AsCurrency);
        SelectedCDS.Post;
      end else ShowMessage('Недостаточно количества для перемещения.');
    end else
    begin
      SelectedCDS.Append;
      SelectedCDS.FieldByName('Id').AsInteger        := ClientDataSet.FieldByName('Id').AsInteger;
      SelectedCDS.FieldByName('GoodsCode').AsInteger := ClientDataSet.FieldByName('GoodsCode').AsInteger;
      SelectedCDS.FieldByName('GoodsName').AsString  := ClientDataSet.FieldByName('GoodsName').AsString;
      SelectedCDS.FieldByName('UnitId').AsInteger    := ClientDataSet.FieldByName('UnitId').AsInteger;
      SelectedCDS.FieldByName('UnitName').AsString   := ClientDataSet.FieldByName('UnitName').AsString;
      SelectedCDS.FieldByName('Amount').AsCurrency   := Min(1, ClientDataSet.FieldByName('Amount').AsCurrency);
      SelectedCDS.FieldByName('Price').AsCurrency    := ClientDataSet.FieldByName('PriceSale').AsCurrency;
      SelectedCDS.Post;
    end;
  End;

end;

procedure TSearchRemainsVIPForm.edSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) AND (edCodeSearch.Focused or edGoodsSearch.Focused) then
  Begin
    if (GuidesUnit.Key = '0') OR (GuidesUnit.Key = '') then
    begin
      ShowMessage('Не выбрано подразделение.');
      Exit;
    end;

    actRefresh.Execute;
    cxGrid.SetFocus;
  End;
end;

procedure TSearchRemainsVIPForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if SelectedCDS.RecordCount > 0 then
  begin

    case MessageDlg('Внимание перемещение не созданы'#13#10#13#10 +
          'Yes    - Создать перемещения и выйти' + #13#10 +
          'No     - Выйти без создания перемещений' + #13#10 +
          'Cancel - Продолжить поиск',
          mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes : if not CreteSend then begin Action := caNone; Exit; end;
      mrCancel : begin Action := caNone; Exit; end;
    end;
  end;
  UserSettingsStorageAddOn.SaveUserSettings;
  Action := caFree;
end;

procedure TSearchRemainsVIPForm.FormCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;
  spGet.Execute;
  if spGet.ParamByName('isBlockVIP').Value then
  begin
     ShowMessage('На данный момент проект приостановлен, по причине загруженности транспортного отдела...но мы обязательно вернёмся!.');
     Close;
  end else
  begin
    edUnit.OnDblClick(Sender);
    if (GuidesUnit.Key = '0') OR (GuidesUnit.Key = '') then
    begin
      ShowMessage('Не выбрано подразделение!.');
      Close;
    end;
  end;
end;

procedure TSearchRemainsVIPForm.SelectedCDSBeforePost(DataSet: TDataSet);
begin
  if ClientDataSet.Locate('ID;UnitId',
      VarArrayOf([DataSet.FieldByName('Id').AsInteger,
      DataSet.FieldByName('UnitId').AsInteger]), []) then
  begin
    if DataSet.FieldByName('Amount').AsCurrency > ClientDataSet.FieldByName('Amount').AsCurrency then
    begin
      raise Exception.Create('Недостаточно количества для перемещения.');
    end;
  end;
end;

initialization
  RegisterClass(TSearchRemainsVIPForm);
end.
