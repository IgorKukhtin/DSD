unit Sale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter;

type
  TSaleForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edUnit: TcxButtonEdit;
    lblJuridical: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesJuridical: TdsdGuides;
    cxLabel3: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel4: TcxLabel;
    edTotalSumm: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edTotalCount: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edTotalSummPrimeCost: TcxCurrencyEdit;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colAmountRemains: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colSumm: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    colRemains: TcxGridDBColumn;
    colPriceWithVAT: TcxGridDBColumn;
    colSummWithVAT: TcxGridDBColumn;
    colSummOut: TcxGridDBColumn;
    colFromName: TcxGridDBColumn;
    colMargin: TcxGridDBColumn;
    colMarginPercent: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MovementItem_SalePartion: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    cxLabel12: TcxLabel;
    edOperDateSP: TcxDateEdit;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    edInvNumberSP: TcxTextEdit;
    cxLabel16: TcxLabel;
    edMedicSP: TcxTextEdit;
    cxLabel8: TcxLabel;
    edMemberSP: TcxTextEdit;
    edPartnerMedical: TcxButtonEdit;
    PartnerMedicalGuides: TdsdGuides;
    coisSP: TcxGridDBColumn;
    cxLabel9: TcxLabel;
    edGroupMemberSP: TcxButtonEdit;
    GroupMemberSPGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSaleForm);

end.
