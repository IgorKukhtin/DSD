unit PersonalService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TPersonalServiceForm = class(TAncestorDocumentForm)
    colINN: TcxGridDBColumn;
    colPersonalName: TcxGridDBColumn;
    colPositionName: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    bbPrint_Bill: TdxBarButton;
    colSummCard: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    edServiceDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel12: TcxLabel;
    colSummService: TcxGridDBColumn;
    colSummMinus: TcxGridDBColumn;
    colSummAdd: TcxGridDBColumn;
    edPersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
    cxLabel3: TcxLabel;
    colUnitCode: TcxGridDBColumn;
    colPersonalCode: TcxGridDBColumn;
    colIsMain: TcxGridDBColumn;
    colIsOfficial: TcxGridDBColumn;
    colAmountCash: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    colSummCardRecalc: TcxGridDBColumn;
    colSummSocialIn: TcxGridDBColumn;
    colSummSocialAdd: TcxGridDBColumn;
    colSummChild: TcxGridDBColumn;
    colMemberName: TcxGridDBColumn;
    actMemberChoice: TOpenChoiceForm;
    colAmountToPay: TcxGridDBColumn;
    spUpdateIsMain: TdsdStoredProc;
    actUpdateIsMain: TdsdExecStoredProc;
    bbUpdateIsMain: TdxBarButton;
    bbPersonalServiceList: TdxBarButton;
    mactUpdateMask: TMultiAction;
    actUpdateMask: TdsdExecStoredProc;
    spUpdateMask: TdsdStoredProc;
    actPersonalServiceJournalChoice: TOpenChoiceForm;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    colPersonalServiceListName: TcxGridDBColumn;
    actPersonalServiceListChoice: TOpenChoiceForm;
    SummIncome: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPersonalServiceForm);

end.
