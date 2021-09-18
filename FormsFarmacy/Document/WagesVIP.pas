unit WagesVIP;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad;

type
  TWagesVIPForm = class(TAncestorDocumentForm)
    MemberCode: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    HoursWork: TcxGridDBColumn;
    DateIssuedBy: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    bbactStartLoad: TdxBarButton;
    AmountAccrued: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    ceTotalSummPhone: TcxCurrencyEdit;
    ceTotalSummSale: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceHoursWork: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    deDateCalculation: TcxDateEdit;
    cxLabel6: TcxLabel;
    actCalculationAll: TMultiAction;
    actExecCalculationAll: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    spCalculationAll: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWagesVIPForm);

end.
