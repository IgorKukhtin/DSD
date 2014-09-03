unit LoadSaleFrom1C;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC, DataModul,
  ExternalLoad, ExternalDocumentLoad, dsdGuides, cxButtonEdit, cxCurrencyEdit,
  cxSplitter, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxImageComboBox;

type
  TLoadSaleFrom1CForm = class(TAncestorReportForm)
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colClientName: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colOperCount: TcxGridDBColumn;
    colOperPrice: TcxGridDBColumn;
    colClientINN: TcxGridDBColumn;
    colClientOKPO: TcxGridDBColumn;
    colSuma: TcxGridDBColumn;
    colDeliveryPoint: TcxGridDBColumn;
    colGoodsGoodsKind: TcxGridDBColumn;
    colClientCode: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    actMoveToDoc: TdsdExecStoredProc;
    spMoveSale: TdsdStoredProc;
    bbMoveSale: TdxBarButton;
    actTrancateTable: TdsdExecStoredProc;
    actSale1CLoadAction: TSale1CLoadAction;
    spDelete1CLoad: TdsdStoredProc;
    actLoad1C: TMultiAction;
    bbLoad1c: TdxBarButton;
    colBranch: TcxGridDBColumn;
    colDocType: TcxGridDBColumn;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    colContract: TcxGridDBColumn;
    cxMasterGrid: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    spMasterSelect: TdsdStoredProc;
    colisSync: TcxGridDBColumn;
    spErased: TdsdStoredProc;
    spCheckLoad: TdsdStoredProc;
    actMoveDoc: TMultiAction;
    actMoveAllDoc: TMultiAction;
    actBeforeMove: TdsdExecStoredProc;
    colPaidKindName: TcxGridDBColumn;
    DBViewAddOn1: TdsdDBViewAddOn;
    clItemName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLoadSaleFrom1CForm);


end.
