unit RepricePromoUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Data.DB,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckListBox, cxDBCheckListBox,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, cxTextEdit, cxCurrencyEdit, cxLabel,
  cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, cxDBData, cxMaskEdit, cxButtonEdit, dsdAddOn,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, Vcl.ActnList, dsdAction, dsdGuides,
  Datasnap.Provider, cxImageComboBox, Vcl.ExtCtrls, cxSplitter, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, Vcl.ComCtrls, cxCheckBox, cxCalc,
  Vcl.Buttons, cxPropertiesStore, cxBlobEdit;

type
  TRepricePromoUnitForm = class(TForm)
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
    colJuridical_Price: TcxGridDBColumn;
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
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cdsResultisPriceFix: TBooleanField;
    colisPriceFix: TcxGridDBColumn;
    cdsResultisIncome: TBooleanField;
    colisIncome: TcxGridDBColumn;
    btnRepriceSelYes: TButton;
    btnRepriceSelNo: TButton;
    colId: TcxGridDBColumn;
    cdsResultisTop: TBooleanField;
    cdsResultisPromo: TBooleanField;
    colisTop: TcxGridDBColumn;
    colisPromo: TcxGridDBColumn;
    cdsResultMidPriceSale: TCurrencyField;
    colMidPriceSale: TcxGridDBColumn;
    cdsResultMidPriceDiff: TCurrencyField;
    colMidPriceDiff: TcxGridDBColumn;
    cdsResultContractName: TStringField;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    cdsResultLastPrice_to: TFloatField;
    cdsResultPriceDiff_to: TFloatField;
    colLastPrice_to: TcxGridDBColumn;
    colPriceDiff_to: TcxGridDBColumn;
    colRemainsCount_to: TcxGridDBColumn;
    cdsResultRemainsCount_to: TCurrencyField;
    cdsResultMinExpirationDate_to: TDateField;
    MinExpirationDate_to: TcxGridDBColumn;
    cdsResultIsTop_Goods: TBooleanField;
    cdsResultPriceFix_Goods: TFloatField;
    colIsTop_Goods: TcxGridDBColumn;
    colPriceFix_Goods: TcxGridDBColumn;
    cdsResultContractId: TIntegerField;
    cdsResultJuridical_Percent: TFloatField;
    cdsResultContract_Percent: TFloatField;
    cdsResultAreaName: TStringField;
    cxLabel2: TcxLabel;
    TaxEdit: TcxCurrencyEdit;
    colNewPrice_to: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    PriceMaxEdit: TcxCurrencyEdit;
    cdsResultNewPrice_to: TCurrencyField;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    BtnUnitsList: TButton;
    actChoiceJuridical: TOpenChoiceForm;
    edProvinceCity: TcxButtonEdit;
    GuidesProvinceCity: TdsdGuides;
    colisResolution_224: TcxGridDBColumn;
    cdsResultisResolution_224: TBooleanField;
    PromoNumber: TcxGridDBColumn;
    JuridicalList: TcxGridDBColumn;
    cdsResultPromoNumber: TStringField;
    cdsResultJuridicalList: TBlobField;
    procedure FormCreate(Sender: TObject);
    procedure btnRepriceClick(Sender: TObject);
    procedure btnSelectNewPriceClick(Sender: TObject);
    procedure cdsResultCalcFields(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnRepriceSelYesClick(Sender: TObject);
    procedure btnRepriceSelNoClick(Sender: TObject);
    procedure BtnUnitsListClick(Sender: TObject);
  private
    FStartReprice: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses SimpleGauge, DataModul;

procedure TRepricePromoUnitForm.btnRepriceClick(Sender: TObject);
var i, LastRecordNo, RecIndex: integer;
  GUID: TGUID;
  GUID_Str: String;
  lTax : Double;
begin
    //
    if edUnit.Text <> ''
    then
        try lTax:= TaxEdit.Value;
        except lTax:= 0;
        end
    else lTax:= 0;

  if not FStartReprice then
  Begin
    if (lTax <> 0 )and (edUnit.Text <> '')
    then
        if (lTax > 0 )
        then if MessageDlg('Начать переоценку выбранных товаров на основаниии Прайса <'+edUnit.Text+'> и <+'+FloatToStr(lTax)+' %> ?',mtConfirmation,mbYesNo,0) <> mrYes then exit
             else
        else
            if MessageDlg('Начать переоценку выбранных товаров на основаниии Прайса <'+edUnit.Text+'> и <'+FloatToStr(lTax)+' %> ?',mtConfirmation,mbYesNo,0) <> mrYes then exit
            else
    else
    if (edUnit.Text <> '')
    then if MessageDlg('Начать переоценку выбранных товаров на основаниии Прайса <'+edUnit.Text+'> ?',mtConfirmation,mbYesNo,0) <> mrYes then exit
         else
    else
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
          try
          spInsertUpdate_MovementItem_Reprice.ParamByName('inGoodsId').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colGoodsId.Index];
          except ShowMessage('1');exit;end;

          try
          spInsertUpdate_MovementItem_Reprice.ParamByName('inUnitId').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colUnitId.Index];
          except ShowMessage('2.1.');exit;end;

          try
          if edUnit.Text <> ''
          then begin
              spInsertUpdate_MovementItem_Reprice.ParamByName('inUnitId_Forwarding').Value :=
                 GuidesUnit.Params.ParamByName('Key').Value;
              //
              spInsertUpdate_MovementItem_Reprice.ParamByName('inTax').Value := lTax;
          end
          else begin
              spInsertUpdate_MovementItem_Reprice.ParamByName('inUnitId_Forwarding').Value := 0;
              spInsertUpdate_MovementItem_Reprice.ParamByName('inTax').Value := 0;
          end;
          except ShowMessage('2.2.');exit;end;

//          try
//          spInsertUpdate_MovementItem_Reprice.ParamByName('inJuridicalId').Value :=
//            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colJuridicalId.Index];
//          except ShowMessage('3');exit;end;
//
//          try
//          spInsertUpdate_MovementItem_Reprice.ParamByName('inContractId').Value :=
//           AllGoodsPriceGridTableView.DataController.Values[RecIndex,colContractId.Index];
//          except ShowMessage('4');exit;end;

          try
          spInsertUpdate_MovementItem_Reprice.ParamByName('inMinExpirationDate').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colMinExpirationDate.Index];
          except ShowMessage('5');exit;end;

          try
          spInsertUpdate_MovementItem_Reprice.ParamByName('inExpirationDate').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colExpirationDate.Index];
          except ShowMessage('6');exit;end;

          try
          spInsertUpdate_MovementItem_Reprice.ParamByName('inAmount').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colRemainsCount.Index];
          except ShowMessage('7');exit;end;

          try
          if AllGoodsPriceGridTableView.DataController.Values[RecIndex,colOldPrice.Index] = null then
            spInsertUpdate_MovementItem_Reprice.ParamByName('inPriceOld').Value := 0;
          except ShowMessage('8');exit;end;

          try
          if AllGoodsPriceGridTableView.DataController.Values[RecIndex,colJuridical_Price.Index] = null then
            spInsertUpdate_MovementItem_Reprice.ParamByName('inJuridical_PriceOld').Value := 0
          else
            spInsertUpdate_MovementItem_Reprice.ParamByName('inPriceOld').Value :=
              AllGoodsPriceGridTableView.DataController.Values[RecIndex,colOldPrice.Index];
          except ShowMessage('9');exit;end;

          try
          if edUnit.Text <> ''
          then spInsertUpdate_MovementItem_Reprice.ParamByName('inPriceNew').Value :=
                  AllGoodsPriceGridTableView.DataController.Values[RecIndex,colNewPrice_To.Index]
                // * (1 + lTax/100)
          else spInsertUpdate_MovementItem_Reprice.ParamByName('inPriceNew').Value :=
                  AllGoodsPriceGridTableView.DataController.Values[RecIndex,colNewPrice.Index];
          except ShowMessage('10');exit;end;

          try
          spInsertUpdate_MovementItem_Reprice.ParamByName('inJuridical_Price').Value :=
            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colJuridical_Price.Index];
          except ShowMessage('11');exit;end;

//          try
//          spInsertUpdate_MovementItem_Reprice.ParamByName('inContract_Percent').Value :=
//            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colContract_Percent.Index];
//          except ShowMessage('12');exit;end;
//          try
//          spInsertUpdate_MovementItem_Reprice.ParamByName('inJuridical_Percent').Value :=
//            AllGoodsPriceGridTableView.DataController.Values[RecIndex,colJuridical_Percent.Index];
//          except ShowMessage('13');exit;end;

          try
          spInsertUpdate_MovementItem_Reprice.ParamByName('inGUID').Value := GUID_Str;
          except ShowMessage('14');exit;end;

          try
          spInsertUpdate_MovementItem_Reprice.Execute;
          except
              on E:Exception do
              begin
                 raise Exception.Create(e.Message);
                //ShowMessage('15');
                //ShowMessage('Ошибка выполнения Проц.');
                exit;
              end;
          end;

        End;
        Application.ProcessMessages;
        if Not FStartReprice then
          exit;
      end;

      try
         spInsertUpdate_MovementItem_Reprice.Execute(True);
      except
        on E:Exception do
        begin
           raise Exception.Create(e.Message);
           exit;
          //ShowMessage('Ошибка выполнения Проц.');
        end;
      end;


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

procedure TRepricePromoUnitForm.btnRepriceSelYesClick(Sender: TObject);
var i, RecIndex: integer;
    oldId:String;
begin
      if MessageDlg('Действительно отметить для Переоценки выбранные товары?',mtConfirmation,mbYesNo,0) <> mrYes then exit;

      oldId:=AllGoodsPriceGridTableView.DataController.DataSource.DataSet.FieldByName('Id').AsString;
      AllGoodsPriceGridTableView.DataController.DataSource.DataSet.DisableControls;

      for I := 0 to AllGoodsPriceGridTableView.DataController.FilteredRecordCount - 1 do
      Begin
        RecIndex := AllGoodsPriceGridTableView.DataController.FilteredRecordIndex[I];
        if AllGoodsPriceGridTableView.DataController.Values[RecIndex,colReprice.Index] = false
        then begin
            //AllGoodsPriceGridTableView.DataController.Values[RecIndex,colReprice.Index]:= true;
            AllGoodsPriceGridTableView.DataController.DataSource.DataSet.Locate('Id',AllGoodsPriceGridTableView.DataController.Values[RecIndex,colId.Index],[]);
            AllGoodsPriceGridTableView.DataController.DataSource.DataSet.Edit;
            AllGoodsPriceGridTableView.DataController.DataSource.DataSet.FieldByName('Reprice').AsBoolean:= true;
            AllGoodsPriceGridTableView.DataController.DataSource.DataSet.Post;
            Application.ProcessMessages;
            end;
      End;

      AllGoodsPriceGridTableView.DataController.DataSource.DataSet.Locate('Id',oldId,[]);
      AllGoodsPriceGridTableView.DataController.DataSource.DataSet.EnableControls;
      MessageDlg('Отметка установлена.',mtInformation,[mbOk],0,mbOk);
end;

procedure TRepricePromoUnitForm.btnRepriceSelNoClick(Sender: TObject);
var i, RecIndex: integer;
    oldId:String;
begin
      if MessageDlg('Действительно убрать отметку для Переоценки у выбранных товары?',mtConfirmation,mbYesNo,0) <> mrYes then exit;

      oldId:=AllGoodsPriceGridTableView.DataController.DataSource.DataSet.FieldByName('Id').AsString;
      AllGoodsPriceGridTableView.DataController.DataSource.DataSet.DisableControls;

      for I := 0 to AllGoodsPriceGridTableView.DataController.FilteredRecordCount - 1 do
      Begin
        RecIndex := AllGoodsPriceGridTableView.DataController.FilteredRecordIndex[I];
        if AllGoodsPriceGridTableView.DataController.Values[RecIndex,colReprice.Index] = true
        then begin
            //AllGoodsPriceGridTableView.DataController.Values[RecIndex,colReprice.Index]:= false;
            AllGoodsPriceGridTableView.DataController.DataSource.DataSet.Locate('Id',AllGoodsPriceGridTableView.DataController.Values[RecIndex,colId.Index],[]);
            AllGoodsPriceGridTableView.DataController.DataSource.DataSet.Edit;
            AllGoodsPriceGridTableView.DataController.DataSource.DataSet.FieldByName('Reprice').AsBoolean:= false;
            AllGoodsPriceGridTableView.DataController.DataSource.DataSet.Post;
            end;
            Application.ProcessMessages;
      End;

      AllGoodsPriceGridTableView.DataController.DataSource.DataSet.Locate('Id',oldId,[]);
      AllGoodsPriceGridTableView.DataController.DataSource.DataSet.EnableControls;
      MessageDlg('Отметка убрана.',mtInformation,[mbOk],0,mbOk);
end;

procedure TRepricePromoUnitForm.btnSelectNewPriceClick(Sender: TObject);
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
        spSelect_AllGoodsPrice.ParamByName('inUnitId_to').Value := GuidesUnit.Params.ParamByName('Key').Value;
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
          //!!!if AllGoodsPriceCDS.FieldByName('LastPrice').AsCurrency <> 0 then
            cdsResult.FieldByName('LastPrice').AsCurrency := AllGoodsPriceCDS.FieldByName('LastPrice').AsCurrency;
            cdsResult.FieldByName('LastPrice_to').AsCurrency := AllGoodsPriceCDS.FieldByName('LastPrice_to').AsCurrency;
          cdsResult.FieldByName('RemainsCount').AsCurrency := AllGoodsPriceCDS.FieldByName('RemainsCount').AsCurrency;
          cdsResult.FieldByName('RemainsCount_to').AsCurrency := AllGoodsPriceCDS.FieldByName('RemainsCount_to').AsCurrency;
          cdsResult.FieldByName('NDS').AsCurrency := AllGoodsPriceCDS.FieldByName('NDS').AsCurrency;
          if AllGoodsPriceCDS.FieldByName('ExpirationDate').AsDateTime <> 0 then
            cdsResult.FieldByName('ExpirationDate').AsDateTime := AllGoodsPriceCDS.FieldByName('ExpirationDate').AsDateTime;
          cdsResult.FieldByName('NewPrice').AsCurrency := AllGoodsPriceCDS.FieldByName('NewPrice').AsCurrency;
          cdsResult.FieldByName('NewPrice_to').AsCurrency := AllGoodsPriceCDS.FieldByName('NewPrice_to').AsCurrency;
          cdsResult.FieldByName('PriceFix_Goods').AsCurrency := AllGoodsPriceCDS.FieldByName('PriceFix_Goods').AsCurrency;
          cdsResult.FieldByName('MarginPercent').AsCurrency := AllGoodsPriceCDS.FieldByName('MarginPercent').AsCurrency;
          cdsResult.FieldByName('MinMarginPercent').AsCurrency := AllGoodsPriceCDS.FieldByName('MinMarginPercent').AsCurrency;
          cdsResult.FieldByName('PriceDiff').AsCurrency := AllGoodsPriceCDS.FieldByName('PriceDiff').AsCurrency;
          cdsResult.FieldByName('PriceDiff_to').AsCurrency := AllGoodsPriceCDS.FieldByName('PriceDiff_to').AsCurrency;
          cdsResult.FieldByName('Reprice').AsBoolean := AllGoodsPriceCDS.FieldByName('Reprice').AsBoolean;
          cdsResult.FieldByName('UnitId').AsInteger := UnitId;
          cdsResult.FieldByName('UnitName').AsString := CheckListBox.Items[i];
//          cdsResult.FieldByName('JuridicalName').AsString := AllGoodsPriceCDS.FieldByName('JuridicalName').AsString;
          cdsResult.FieldByName('Juridical_Price').AsCurrency := AllGoodsPriceCDS.FieldByName('Juridical_Price').AsCurrency;
//          cdsResult.FieldByName('Juridical_GoodsName').AsString := AllGoodsPriceCDS.FieldByName('Juridical_GoodsName').AsString;
//          cdsResult.FieldByName('ProducerName').AsString := AllGoodsPriceCDS.FieldByName('ProducerName').AsString;
//          cdsResult.FieldByName('ContractName').AsString := AllGoodsPriceCDS.FieldByName('ContractName').AsString;
          cdsResult.FieldByName('SumReprice').AsCurrency := AllGoodsPriceCDS.FieldByName('SumReprice').AsCurrency;
          cdsResult.FieldByName('MinExpirationDate').AsDateTime := AllGoodsPriceCDS.FieldByName('MinExpirationDate').AsDateTime;
          cdsResult.FieldByName('MinExpirationDate_to').AsDateTime := AllGoodsPriceCDS.FieldByName('MinExpirationDate_to').AsDateTime;
          cdsResult.FieldByName('isOneJuridical').AsBoolean := AllGoodsPriceCDS.FieldByName('isOneJuridical').AsBoolean;
//          cdsResult.FieldByName('JuridicalId').AsInteger := AllGoodsPriceCDS.FieldByName('JuridicalId').AsInteger;
//          cdsResult.FieldByName('ContractId').AsInteger := AllGoodsPriceCDS.FieldByName('ContractId').AsInteger;
          cdsResult.FieldByName('isPriceFix').AsBoolean := AllGoodsPriceCDS.FieldByName('isPriceFix').AsBoolean;
          cdsResult.FieldByName('isIncome').AsBoolean := AllGoodsPriceCDS.FieldByName('isIncome').AsBoolean;
          cdsResult.FieldByName('isTop').AsBoolean := AllGoodsPriceCDS.FieldByName('isTop').AsBoolean;
          cdsResult.FieldByName('isTop_Goods').AsBoolean := AllGoodsPriceCDS.FieldByName('isTop_Goods').AsBoolean;
          cdsResult.FieldByName('isPromo').AsBoolean := AllGoodsPriceCDS.FieldByName('isPromo').AsBoolean;
          cdsResult.FieldByName('isResolution_224').AsBoolean := AllGoodsPriceCDS.FieldByName('isResolution_224').AsBoolean;
          cdsResult.FieldByName('MidPriceDiff').AsCurrency := AllGoodsPriceCDS.FieldByName('MidPriceDiff').AsCurrency;
          cdsResult.FieldByName('MidPriceSale').AsCurrency := AllGoodsPriceCDS.FieldByName('MidPriceSale').AsCurrency;
//          cdsResult.FieldByName('Juridical_Percent').AsCurrency := AllGoodsPriceCDS.FieldByName('Juridical_Percent').AsCurrency;
//          cdsResult.FieldByName('Contract_Percent').AsCurrency := AllGoodsPriceCDS.FieldByName('Contract_Percent').AsCurrency;
//          cdsResult.FieldByName('AreaName').AsString := AllGoodsPriceCDS.FieldByName('AreaName').AsString;
          cdsResult.FieldByName('PromoNumber').AsVariant := AllGoodsPriceCDS.FieldByName('PromoNumber').AsVariant;
          cdsResult.FieldByName('JuridicalList').AsVariant := AllGoodsPriceCDS.FieldByName('JuridicalList').AsVariant;
          cdsResult.Post;
          AllGoodsPriceCDS.Next;
        end;
      end;
    End;
  finally
    cdsResult.EnableControls;
  end;
end;


procedure TRepricePromoUnitForm.BtnUnitsListClick(Sender: TObject);
begin
    //if actChoiceJuridical.Execute then
    //begin
          GetUnitsList.Execute;
          UnitsCDS.First;
          CheckListBox.Items.Clear;
          while not UnitsCDS.Eof do
          begin
            CheckListBox.Items.AddObject(UnitsCDS.FieldByName('UnitName').asString,TObject(UnitsCDS.FieldByName('Id').AsInteger));
            UnitsCDS.Next;
          end;
    //end;
end;

procedure TRepricePromoUnitForm.cdsResultCalcFields(DataSet: TDataSet);
begin
  if cdsResultReprice.AsBoolean then
    cdsResultRealSummReprice.AsCurrency := cdsResultSumReprice.AsCurrency
  else
    cdsResultRealSummReprice.AsCurrency := 0;
end;

procedure TRepricePromoUnitForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dsdUserSettingsStorageAddOn.SaveUserSettings;
  Action:=caFree;
end;

procedure TRepricePromoUnitForm.FormCreate(Sender: TObject);
begin
  FStartReprice := False;
  GetUnitsList.Execute;
  UnitsCDS.First;
  while not UnitsCDS.Eof do
  begin
    CheckListBox.Items.AddObject(UnitsCDS.FieldByName('UnitName').asString,TObject(UnitsCDS.FieldByName('Id').AsInteger));
    UnitsCDS.Next;
  end;
  CheckListBox.Font.Size := dmMain.cxContentStyle.Font.Size;
end;

procedure TRepricePromoUnitForm.FormShow(Sender: TObject);
begin
  dsdUserSettingsStorageAddOn.LoadUserSettings
end;

end.
