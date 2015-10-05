unit IncomePharmacy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxCurrencyEdit, dsdAddOn,
  dsdAction, cxCheckBox, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxBarBuiltInMenu, cxNavigator;

type
  TIncomePharmacyForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel10: TcxLabel;
    edNDSKind: TcxButtonEdit;
    NDSKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    colExpirationDate: TcxGridDBColumn;
    colPartitionGoods: TcxGridDBColumn;
    colMakerName: TcxGridDBColumn;
    spIncome_GoodsId: TdsdStoredProc;
    colMeasure: TcxGridDBColumn;
    spCalculateSalePrice: TdsdStoredProc;
    colSalePrice: TcxGridDBColumn;
    colSaleSumm: TcxGridDBColumn;
    cxLabel12: TcxLabel;
    cxLabel11: TcxLabel;
    edPointDate: TcxDateEdit;
    cxLabel9: TcxLabel;
    edPointNumber: TcxTextEdit;
    cbFarmacyShow: TcxCheckBox;
    actPrintForManager: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    colSertificatNumber: TcxGridDBColumn;
    colSertificatStart: TcxGridDBColumn;
    colSertificatEnd: TcxGridDBColumn;
    colDublePriceColour: TcxGridDBColumn;
    colWarningColor: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomePharmacyForm);

end.
