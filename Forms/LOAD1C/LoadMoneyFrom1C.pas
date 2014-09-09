unit LoadMoneyFrom1C;

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
  TLoadMoneyFrom1CForm = class(TAncestorReportForm)
    colOperDate: TcxGridDBColumn;
    colClientName: TcxGridDBColumn;
    colClientFindName: TcxGridDBColumn;
    colClientCode: TcxGridDBColumn;
    actMoveToDoc: TdsdExecStoredProc;
    spMoveMoney: TdsdStoredProc;
    bbMoveSale: TdxBarButton;
    actTrancateTable: TdsdExecStoredProc;
    spDelete1CLoad: TdsdStoredProc;
    actLoad1C: TMultiAction;
    bbLoad1c: TdxBarButton;
    colBranch: TcxGridDBColumn;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    colContract: TcxGridDBColumn;
    spErased: TdsdStoredProc;
    spCheckLoad: TdsdStoredProc;
    actMoveDoc: TMultiAction;
    actMoveAllDoc: TMultiAction;
    actBeforeMove: TdsdExecStoredProc;
    colPaidKindName: TcxGridDBColumn;
    colSummIn: TcxGridDBColumn;
    colSummOut: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLoadMoneyFrom1CForm);


end.
