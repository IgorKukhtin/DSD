unit RepriceUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Data.DB,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckListBox, cxDBCheckListBox,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, cxTextEdit, cxCurrencyEdit, cxLabel,
  Bde.DBTables, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, cxDBData, cxMaskEdit, cxButtonEdit, dsdAddOn,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, Vcl.ActnList, dsdAction, dsdGuides,
  Datasnap.Provider, cxImageComboBox, Vcl.ExtCtrls, cxSplitter, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, Vcl.ComCtrls, cxCheckBox, cxCalc,
  Vcl.Buttons, cxPropertiesStore;

type
  TRepriceUnitForm = class(TForm)
    btnReprice: TButton;
    GetUnitsList: TdsdStoredProc;
    CheckListBox: TCheckListBox;
    cePercentDifference: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    AllGoodsPriceGridTableView: TcxGridDBTableView;
    AllGoodsPriceGridLevel: TcxGridLevel;
    AllGoodsPriceGrid: TcxGrid;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    spSelect_AllGoodsPrice: TdsdStoredProc;
    AllGoodsPriceCDS: TClientDataSet;
    dsResult: TDataSource;
    FormParams: TdsdFormParams;
    ActionList1: TActionList;
    actRefresh: TdsdDataSetRefresh;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colOldPrice: TcxGridDBColumn;
    btnSelectNewPrice: TButton;
    colNewPrice: TcxGridDBColumn;
    colPercent: TcxGridDBColumn;
    colRemainsCount: TcxGridDBColumn;
    colNDS: TcxGridDBColumn;
    colReprice: TcxGridDBColumn;
    colExpirationDate: TcxGridDBColumn;
    Panel1: TPanel;
    cxSplitter1: TcxSplitter;
    Panel4: TPanel;
    Panel5: TPanel;
    cdsResult: TClientDataSet;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    UnitsCDS: TClientDataSet;
    spInsertUpdate_MovementItem_Reprice: TdsdStoredProc;
    colMarginPercent: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    lblProggres1: TLabel;
    lblProggres2: TLabel;
    chbVAT20: TcxCheckBox;
    SpeedButton1: TSpeedButton;
    dsdGridToExcel1: TdsdGridToExcel;
    colJuridicalName: TcxGridDBColumn;
    colJuridical_Price: TcxGridDBColumn;
    colJuridical_GoodsName: TcxGridDBColumn;
    colProducerName: TcxGridDBColumn;
    colSumReprice: TcxGridDBColumn;
    colMinExpirationDate: TcxGridDBColumn;
    cdsResultId: TIntegerField;
    cdsResultCode: TIntegerField;
    cdsResultGoodsName: TStringField;
    cdsResultLastPrice: TCurrencyField;
    cdsResultRemainsCount: TCurrencyField;
    cdsResultNDS: TCurrencyField;
    cdsResultExpirationDate: TDateField;
    cdsResultNewPrice: TCurrencyField;
    cdsResultMarginPercent: TCurrencyField;
    cdsResultPriceDiff: TCurrencyField;
    cdsResultReprice: TBooleanField;
    cdsResultUnitId: TIntegerField;
    cdsResultUnitName: TStringField;
    cdsResultJuridicalName: TStringField;
    cdsResultJuridical_Price: TCurrencyField;
    cdsResultJuridical_GoodsName: TStringField;
    cdsResultProducerName: TStringField;
    cdsResultSumReprice: TCurrencyField;
    cdsResultMinExpirationDate: TDateField;
    cdsResultRealSummReprice: TCurrencyField;
    colMinMarginPercent: TcxGridDBColumn;
    cdsResultMinMarginPercent: TCurrencyField;
    colUnitId: TcxGridDBColumn;
    colGoodsId: TcxGridDBColumn;
    cxPropertiesStore: TcxPropertiesStore;
    cdsResultisOneJuridical: TBooleanField;
    colIsOneJuridical: TcxGridDBColumn;
    cdsResultJuridicalId: TIntegerField;
    colJuridicalId: TcxGridDBColumn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cdsResultisPriceFix: TBooleanField;
    colisPriceFix: TcxGridDBColumn;
    cdsResultisIncome: TBooleanField;
    colisIncome: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure btnRepriceClick(Sender: TObject);
    procedure btnSelectNewPriceClick(Sender: TObject);
    procedure cdsResultCalcFields(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FStartReprice: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SimpleGauge, DataModul;

procedure TRepriceUnitForm.btnRepriceClick(Sender: TObject);
var i, LastRecordNo, RecIndex: integer;
  GUID: TGUID;
  GUID_Str: String;
begin
  if not FStartReprice then
  Begin
    if MessageDlg('Начать переоценку выбранных товаров?',mtConfirmation,mbYesNo,0) <> mrYes then exit;
    CreateGUID(GUID);
    GUID_Str := GUIDToString(GUID);
    FStartReprice := True;
    btnSelectNewPrice.Enabled := False;
    btnReprice.Caption := 'Остановить';
    cdsResult.DisableControls;
    if cdsResult.state = dsEdit then
      cdsResult.Post;
    ProgressBar2.Position := 0;
    ProgressBar2.Max := 0;
    lblProggres2.Caption := '0 / 0';
    ProgressBar1.Position := 0;
    ProgressBar1.Max := cdsResult.RecordCount;
    Application.ProcessMessages;
    try
      for I := 0 to AllGoodsPriceGridTableView.DataController.FilteredRecordCount - 1 do
      Begin
        lblProggres1.Caption := IntToStr(I+1)+' / '+IntToStr(AllGoodsPriceGridTableView.DataController.FilteredRecordCount);
        lblProggres1.Repaint;
        ProgressBar1.Position := cdsResult.RecNo;
        ProgressBar1.Repaint;
        RecIndex := AllGoodsPriceGridTableView.DataController.FilteredRecordIndex[I];
        if AllGoodsPriceGridTableView.DataController.Values[RecIndex,colReprice.Index] = True then
        Begin
          spInsertUpdate_MovementItem_Reprice.ParamByName('inGoodsId').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colGoodsId.Index];
          spInsertUpdate_MovementItem_Reprice.ParamByName('inUnitId').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colUnitId.Index];
          spInsertUpdate_MovementItem_Reprice.ParamByName('inJuridicalId').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colJuridicalId.Index];
          spInsertUpdate_MovementItem_Reprice.ParamByName('inMinExpirationDate').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colMinExpirationDate.Index];
          spInsertUpdate_MovementItem_Reprice.ParamByName('inExpirationDate').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colExpirationDate.Index];
          spInsertUpdate_MovementItem_Reprice.ParamByName('inAmount').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colRemainsCount.Index];
          if AllGoodsPriceGridTableView.DataController.Values[RecIndex,colOldPrice.Index] = null then
            spInsertUpdate_MovementItem_Reprice.ParamByName('inPriceOld').Value := 0;
          if AllGoodsPriceGridTableView.DataController.Values[RecIndex,colJuridical_Price.Index] = null then
            spInsertUpdate_MovementItem_Reprice.ParamByName('ininJuridical_PriceOld').Value := 0
          else
            spInsertUpdate_MovementItem_Reprice.ParamByName('inPriceOld').Value :=
              AllGoodsPriceGridTableView.DataController.Values[RecIndex,colOldPrice.Index];
          spInsertUpdate_MovementItem_Reprice.ParamByName('inPriceNew').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colNewPrice.Index];
          spInsertUpdate_MovementItem_Reprice.ParamByName('inJuridical_Price').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colJuridical_Price.Index];
          spInsertUpdate_MovementItem_Reprice.ParamByName('inGUID').Value := GUID_Str;
          spInsertUpdate_MovementItem_Reprice.Execute;
        End;
        Application.ProcessMessages;
        if Not FStartReprice then
          exit;
      end;
      spInsertUpdate_MovementItem_Reprice.Execute(True);
    finally
      //
      for i := 0 to CheckListBox.Items.Count - 1 do
        if CheckListBox.Checked[i] then CheckListBox.Checked[i]:= false;
      cdsResult.EmptyDataSet;
      //
      FStartReprice := False;
      btnSelectNewPrice.Enabled := True;
      btnReprice.Caption := 'Переоценить  >>>';
      cdsResult.EnableControls;
      MessageDlg('ПЕРЕОЦЕНКА ЗАВЕРШЕНА.',mtInformation,[mbOk],0,mbOk);
    end;
  End
  else
  Begin
    FStartReprice := False;
  End;
end;

procedure TRepriceUnitForm.btnSelectNewPriceClick(Sender: TObject);
var i, UnitId: integer;
begin
  cdsResult.DisableControls;
  try
    cdsResult.EmptyDataSet;
    ProgressBar1.Position := 0;
    ProgressBar2.Position := 0;
    ProgressBar1.Max := CheckListBox.Items.Count;
    ProgressBar2.Max := 0;

    for i := 0 to CheckListBox.Items.Count - 1 do
    Begin
      lblProggres1.Caption := IntToStr(I+1)+' / '+IntToStr(CheckListBox.Items.Count);
      lblProggres1.Repaint;
      ProgressBar1.Position := I+1;
      ProgressBar1.Repaint;
      Application.ProcessMessages;
      if CheckListBox.Checked[i] then
      begin
        UnitId := Integer(CheckListBox.Items.Objects[I]);
        spSelect_AllGoodsPrice.ParamByName('inUnitId').Value := UnitId;
        spSelect_AllGoodsPrice.Execute;
        ProgressBar2.Position := 0;
        ProgressBar2.Max := AllGoodsPriceCDS.RecordCount;
        AllGoodsPriceCDS.First;
        while not AllGoodsPriceCDS.eof do
        Begin
          lblProggres2.Caption := IntToStr(AllGoodsPriceCDS.RecNo)+' / '+IntToStr(AllGoodsPriceCDS.RecordCount);
          lblProggres2.Repaint;
          ProgressBar2.Position := AllGoodsPriceCDS.RecNo;
          ProgressBar2.Repaint;
          cdsResult.Append;
          cdsResult.FieldByName('Id').AsInteger := AllGoodsPriceCDS.FieldByName('Id').AsInteger;
          cdsResult.FieldByName('Code').AsInteger := AllGoodsPriceCDS.FieldByName('Code').AsInteger;
          cdsResult.FieldByName('GoodsName').AsString := AllGoodsPriceCDS.FieldByName('GoodsName').AsString;
          if AllGoodsPriceCDS.FieldByName('LastPrice').AsCurrency <> 0 then
            cdsResult.FieldByName('LastPrice').AsCurrency := AllGoodsPriceCDS.FieldByName('LastPrice').AsCurrency;
          cdsResult.FieldByName('RemainsCount').AsCurrency := AllGoodsPriceCDS.FieldByName('RemainsCount').AsCurrency;
          cdsResult.FieldByName('NDS').AsCurrency := AllGoodsPriceCDS.FieldByName('NDS').AsCurrency;
          if AllGoodsPriceCDS.FieldByName('ExpirationDate').AsDateTime <> 0 then
            cdsResult.FieldByName('ExpirationDate').AsDateTime := AllGoodsPriceCDS.FieldByName('ExpirationDate').AsDateTime;
          cdsResult.FieldByName('NewPrice').AsCurrency := AllGoodsPriceCDS.FieldByName('NewPrice').AsCurrency;
          cdsResult.FieldByName('MarginPercent').AsCurrency := AllGoodsPriceCDS.FieldByName('MarginPercent').AsCurrency;
          cdsResult.FieldByName('MinMarginPercent').AsCurrency := AllGoodsPriceCDS.FieldByName('MinMarginPercent').AsCurrency;
          cdsResult.FieldByName('PriceDiff').AsCurrency := AllGoodsPriceCDS.FieldByName('PriceDiff').AsCurrency;
          cdsResult.FieldByName('Reprice').AsBoolean := True;
          cdsResult.FieldByName('UnitId').AsInteger := UnitId;
          cdsResult.FieldByName('UnitName').AsString := CheckListBox.Items[i];
          cdsResult.FieldByName('JuridicalName').AsString := AllGoodsPriceCDS.FieldByName('JuridicalName').AsString;
          cdsResult.FieldByName('Juridical_Price').AsCurrency := AllGoodsPriceCDS.FieldByName('Juridical_Price').AsCurrency;
          cdsResult.FieldByName('Juridical_GoodsName').AsString := AllGoodsPriceCDS.FieldByName('Juridical_GoodsName').AsString;
          cdsResult.FieldByName('ProducerName').AsString := AllGoodsPriceCDS.FieldByName('ProducerName').AsString;
          cdsResult.FieldByName('SumReprice').AsCurrency := AllGoodsPriceCDS.FieldByName('SumReprice').AsCurrency;
          cdsResult.FieldByName('MinExpirationDate').AsString := AllGoodsPriceCDS.FieldByName('MinExpirationDate').AsString;
          cdsResult.FieldByName('isOneJuridical').AsBoolean := AllGoodsPriceCDS.FieldByName('isOneJuridical').AsBoolean;
          cdsResult.FieldByName('JuridicalId').AsInteger := AllGoodsPriceCDS.FieldByName('JuridicalId').AsInteger;
          cdsResult.FieldByName('isPriceFix').AsBoolean := AllGoodsPriceCDS.FieldByName('isPriceFix').AsBoolean;
          cdsResult.FieldByName('isIncome').AsBoolean := AllGoodsPriceCDS.FieldByName('isIncome').AsBoolean;
          cdsResult.Post;
          AllGoodsPriceCDS.Next;
        end;
      end;
    End;
  finally
    cdsResult.EnableControls;
  end;
end;

procedure TRepriceUnitForm.cdsResultCalcFields(DataSet: TDataSet);
begin
  if cdsResultReprice.AsBoolean then
    cdsResultRealSummReprice.AsCurrency := cdsResultSumReprice.AsCurrency
  else
    cdsResultRealSummReprice.AsCurrency := 0;
end;

procedure TRepriceUnitForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dsdUserSettingsStorageAddOn.SaveUserSettings;
  Action:=caFree;
end;

procedure TRepriceUnitForm.FormCreate(Sender: TObject);
begin
  FStartReprice := False;
  GetUnitsList.Execute;
  UnitsCDS.First;
  while not UnitsCDS.Eof do
  begin
    CheckListBox.Items.AddObject(UnitsCDS.FieldByName('UnitName').asString,TObject(UnitsCDS.FieldByName('Id').AsInteger));
    UnitsCDS.Next;
  end;
end;

procedure TRepriceUnitForm.FormShow(Sender: TObject);
begin
  dsdUserSettingsStorageAddOn.LoadUserSettings
end;

end.
