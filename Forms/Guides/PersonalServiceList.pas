unit PersonalServiceList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, ParentForm, dsdDB, dsdAction, dsdAddOn, dxBarExtItems,
  cxGridBandedTableView, cxGridDBBandedTableView, cxCheckBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxButtonEdit,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxCurrencyEdit, dsdCommon;

type
  TPersonalServiceListForm = class(TParentForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    bbInsert: TdxBarButton;
    dsdStoredProc: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    dsdGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    spErasedUnErased: TdsdStoredProc;
    bbChoice: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actInsert: TdsdInsertUpdateAction;
    JuridicalName: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    PaidKindName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    BankName: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    MemberChoice: TOpenChoiceForm;
    actUpdateMember: TdsdUpdateDataSet;
    spUpdate_Member: TdsdStoredProc;
    MemberHeadManagerChoice: TOpenChoiceForm;
    MemberManagerChoice: TOpenChoiceForm;
    MemberBookkeeperChoice: TOpenChoiceForm;
    isSecond: TcxGridDBColumn;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    Compensation: TcxGridDBColumn;
    CompensationName: TcxGridDBColumn;
    spUpdate_PersonalOut: TdsdStoredProc;
    bbUpdate_PersonalOut: TdxBarButton;
    isPersonalOut: TcxGridDBColumn;
    isBankOut: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    PSLExportKindName: TcxGridDBColumn;
    ContentType: TcxGridDBColumn;
    OnFlowType: TcxGridDBColumn;
    isDetail: TcxGridDBColumn;
    isCompensationNot: TcxGridDBColumn;
    isBankNot: TcxGridDBColumn;
    spUpdate_User: TdsdStoredProc;
    isUser: TcxGridDBColumn;
    bbUpdate_User: TdxBarButton;
    actUpdate_User: TdsdExecStoredProc;
    mactUpdate_User: TMultiAction;
    actUpdate_PersonalOut: TdsdExecStoredProc;
    macUpdate_PersonalOut: TMultiAction;
    actShowAll: TBooleanStoredProcAction;
    bbinIsErased: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPersonalServiceListForm);

end.
