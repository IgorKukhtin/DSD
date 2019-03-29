unit GoodsToExpirationDate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxCurrencyEdit, AncestorBase;

type
  TGoodsToExpirationDateForm = class(TAncestorBaseForm)
    ListGoodsGrid: TcxGrid;
    ListGoodsGridDBTableView: TcxGridDBTableView;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmout: TcxGridDBColumn;
    colExpirationDate: TcxGridDBColumn;
    ListGoodsGridLevel: TcxGridLevel;
    ListGoodsDS: TDataSource;
    ListGoodsCDS: TClientDataSet;
    procedure colGoodsCodeGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
    procedure colGoodsNameGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
  private
    { Private declarations }
    FGoodsCode: Integer;
    FGoodsName: String;
  public
    { Public declarations }
     function GoodsToExpirationDateExecute(AId, AGoodsCode: Integer; AGoodsName: String): boolean;
  end;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;

procedure TGoodsToExpirationDateForm.colGoodsCodeGetDataText(
  Sender: TcxCustomGridTableItem; ARecordIndex: Integer; var AText: string);
begin
  AText := IntToStr(FGoodsCode);
end;

procedure TGoodsToExpirationDateForm.colGoodsNameGetDataText(
  Sender: TcxCustomGridTableItem; ARecordIndex: Integer; var AText: string);
begin
  AText := FGoodsName;
end;

function TGoodsToExpirationDateForm.GoodsToExpirationDateExecute(AId, AGoodsCode: Integer; AGoodsName: String): boolean;
begin
  FGoodsCode := AGoodsCode;
  FGoodsName := AGoodsName;

  WaitForSingleObject(MutexGoodsExpirationDate, INFINITE);
  try
    if FileExists(GoodsExpirationDate_lcl) then LoadLocalData(ListGoodsCDS, GoodsExpirationDate_lcl);
    if not ListGoodsCDS.Active then ListGoodsCDS.Open;
  finally
    ReleaseMutex(MutexGoodsExpirationDate);
  end;

  ListGoodsCDS.Filter := 'Id = ' + IntToStr(AId);
  ListGoodsCDS.Filtered := True;

  Result := ShowModal = mrOK;
end;

end.
