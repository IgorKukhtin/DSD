unit OrderExternal;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dsdInternetAction, dxBarBuiltInMenu, cxNavigator;

type
  TOrderExternalForm = class(TAncestorDocumentForm)
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
    colSumm: TcxGridDBColumn;
    colClientCode: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    colPrice: TcxGridDBColumn;
    colPartionGoodsDate: TcxGridDBColumn;
    actGetDocumentDataForEmail: TdsdExecStoredProc;
    spGetDocumentDataForEmail: TdsdStoredProc;
    mactSMTPSend: TMultiAction;
    bbSendEMail: TdxBarButton;
    cxGridExportDBTableView: TcxGridDBTableView;
    cxGridExportLevel1: TcxGridLevel;
    cxGridExport: TcxGrid;
    spSelectExport: TdsdStoredProc;
    ExportDS: TDataSource;
    actExportStoredproc: TdsdExecStoredProc;
    spGetExportParam: TdsdStoredProc;
    actExportToPartner: TExportGrid;
    colComment: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderExternalForm);

end.
