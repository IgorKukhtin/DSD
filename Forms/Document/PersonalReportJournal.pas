unit PersonalReportJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCheckBox, cxImageComboBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit, dsdGuides,
  cxButtonEdit;

type
  TPersonalReportJournalForm = class(TAncestorJournalForm)
    AmountOut: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    MoneyPlaceName: TcxGridDBColumn;
    MemberCode: TcxGridDBColumn;
    N13: TMenuItem;
    CarName: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    edMember: TcxButtonEdit;
    GuidesMember: TdsdGuides;
    MovementDescName: TcxGridDBColumn;
    ItemName: TcxGridDBColumn;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    MoneyPlaceCode: TcxGridDBColumn;
    ContractInvNumber: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    spInsert_byReport: TdsdStoredProc;
    ExecuteDialog_Data: TExecuteDialog;
    actInsert_byReport: TdsdExecStoredProc;
    macInsert_byReport: TMultiAction;
    bbInsert_byReport: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPersonalReportJournalForm);

end.
