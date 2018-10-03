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
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxSplitter,
  ExternalLoad, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TPersonalServiceForm = class(TAncestorDocumentForm)
    INN: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    bbPrint_Bill: TdxBarButton;
    SummCard: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    edServiceDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel12: TcxLabel;
    SummService: TcxGridDBColumn;
    SummMinus: TcxGridDBColumn;
    SummAdd: TcxGridDBColumn;
    edPersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
    cxLabel3: TcxLabel;
    UnitCode: TcxGridDBColumn;
    PersonalCode: TcxGridDBColumn;
    IsMain: TcxGridDBColumn;
    IsOfficial: TcxGridDBColumn;
    AmountCash: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    SummCardRecalc: TcxGridDBColumn;
    SummSocialIn: TcxGridDBColumn;
    SummSocialAdd: TcxGridDBColumn;
    SummChild: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    actMemberChoice: TOpenChoiceForm;
    AmountToPay: TcxGridDBColumn;
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
    PersonalServiceListName: TcxGridDBColumn;
    actPersonalServiceListChoice: TOpenChoiceForm;
    SummTransport: TcxGridDBColumn;
    SummTransportAdd: TcxGridDBColumn;
    SummPhone: TcxGridDBColumn;
    SummTransportAddLong: TcxGridDBColumn;
    SummTransportTaxi: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDs: TDataSource;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxMemberName: TcxGridDBColumn;
    cxAmount: TcxGridDBColumn;
    cxMemberCount: TcxGridDBColumn;
    cxDayCount: TcxGridDBColumn;
    cxWorkTimeHoursOne: TcxGridDBColumn;
    cxWorkTimeHours: TcxGridDBColumn;
    cxPrice: TcxGridDBColumn;
    cxHoursPlan: TcxGridDBColumn;
    cxHoursDay: TcxGridDBColumn;
    cxPersonalCount: TcxGridDBColumn;
    cxGrossOne: TcxGridDBColumn;
    cxModelServiceName: TcxGridDBColumn;
    cxStaffListSummKindName: TcxGridDBColumn;
    cxisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitterChild: TcxSplitter;
    DBViewAddOnChild: TdsdDBViewAddOn;
    spSelectChild: TdsdStoredProc;
    edIsAuto: TcxCheckBox;
    spGetImportSetting: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    actLoadExcel: TMultiAction;
    bbLoadExcel: TdxBarButton;
    SummNalog: TcxGridDBColumn;
    SummNalogRecalc: TcxGridDBColumn;
    spUpdate_SetNULL: TdsdStoredProc;
    PersonalName_to: TcxGridDBColumn;
    PersonalCode_to: TcxGridDBColumn;
    clStorageLineName: TcxGridDBColumn;
    spUpdate_CardSecondCash: TdsdStoredProc;
    actUpdateCardSecondCash: TdsdExecStoredProc;
    bbUpdateCardSecondCash: TdxBarButton;
    macUpdateCardSecondCash: TMultiAction;
    CardSecond: TcxGridDBColumn;
    macUpdateCardSecond: TMultiAction;
    actUpdateCardSecond: TdsdExecStoredProc;
    spUpdate_CardSecond: TdsdStoredProc;
    bbUpdateCardSecond: TdxBarButton;
    spSelectMISign: TdsdStoredProc;
    SignCDS: TClientDataSet;
    SignDS: TDataSource;
    cxLabel21: TcxLabel;
    edstrSign: TcxTextEdit;
    cxLabel22: TcxLabel;
    edstrSignNo: TcxTextEdit;
    actInsertUpdateMISignYes: TdsdExecStoredProc;
    spInsertUpdateMISign_Yes: TdsdStoredProc;
    spInsertUpdateMISign_No: TdsdStoredProc;
    mactInsertUpdateMISignYes: TMultiAction;
    actInsertUpdateMISignNo: TdsdExecStoredProc;
    mactInsertUpdateMISignNo: TMultiAction;
    bbInsertUpdateMISignNo: TdxBarButton;
    bbInsertUpdateMISignYes: TdxBarButton;
    actRefresh_Sign: TdsdDataSetRefresh;
    spSelectPrint_All: TdsdStoredProc;
    actPrint_All: TdsdPrintAction;
    bbPrint_All: TdxBarButton;
    spUpdate_MI_PersonalService_SummNalogRet: TdsdStoredProc;
    actUpdateSummNalogRet: TdsdExecStoredProc;
    macUpdateNalogRetSimpl: TMultiAction;
    macUpdateSummNalogRet: TMultiAction;
    bb: TdxBarButton;
    actRefreshMaster: TdsdDataSetRefresh;
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
