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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, Vcl.ComCtrls, cxCheckBox, cxCalc;

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
    spInsertUpdate_Object_Price: TdsdStoredProc;
    colMarginPercent: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    lblProggres1: TLabel;
    lblProggres2: TLabel;
    chbVAT20: TcxCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnRepriceClick(Sender: TObject);
    procedure btnSelectNewPriceClick(Sender: TObject);
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
var i, LastRecordNo, CurrentPackNo: integer;
begin
  if not FStartReprice then
  Begin
    if MessageDlg('Начать переоценку выбранных товаров?',mtConfirmation,mbYesNo,0) <> mrYes then exit;
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
      cdsResult.Last;
      while not cdsResult.Bof do
      Begin
        if cdsResult.FieldByName('Reprice').AsBoolean then
        Begin
          LastRecordNo := cdsResult.RecNo;
          break;
        End;
        cdsResult.Prior;
      end;
      cdsResult.First;
      CurrentPackNo := 0;
      while not cdsResult.eof do
      Begin
        lblProggres1.Caption := IntToStr(cdsResult.RecNo)+' / '+IntToStr(cdsResult.RecordCount);
        lblProggres1.Repaint;
        ProgressBar1.Position := cdsResult.RecNo;
        ProgressBar1.Repaint;
        if cdsResult.FieldByName('Reprice').AsBoolean then
        Begin
          spInsertUpdate_Object_Price.ParamByName('inUnitId').Value := cdsResult.FieldByName('UnitId').AsInteger;
          spInsertUpdate_Object_Price.ParamByName('inGoodsCode').Value := cdsResult.FieldByName('Code').AsInteger;
          spInsertUpdate_Object_Price.ParamByName('inPriceValue').Value := cdsResult.FieldByName('NewPrice').AsFloat;
          spInsertUpdate_Object_Price.Execute;
          inc(CurrentPackNo);
        End;
        Application.ProcessMessages;
        if Not FStartReprice then
          exit;
        cdsResult.Next;
      end;
      if (CurrentPackNo mod spInsertUpdate_Object_Price.PackSize) <> 0 then
        spInsertUpdate_Object_Price.Execute(True);
    finally
      FStartReprice := False;
      btnSelectNewPrice.Enabled := True;
      btnReprice.Caption := 'Переоценить  >>>';
      cdsResult.EnableControls;
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
          cdsResult.FieldByName('PriceDiff').AsCurrency := AllGoodsPriceCDS.FieldByName('PriceDiff').AsCurrency;
          cdsResult.FieldByName('Reprice').AsBoolean := True;
          cdsResult.FieldByName('UnitId').AsInteger := UnitId;
          cdsResult.FieldByName('UnitName').AsString := CheckListBox.Items[i];
          cdsResult.Post;
          AllGoodsPriceCDS.Next;
        end;
      end;
    End;
  finally
    cdsResult.EnableControls;
  end;
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

end.
