unit ContractConditionValue;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, DataModul, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, ParentForm, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dsdAddOn, dxBarExtItems, cxButtonEdit, cxImageComboBox, cxContainer,
  dsdGuides, cxTextEdit, cxLabel;

type
  TContractConditionValueForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    InvNumber: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    SigningDate: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    ContractKindName: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    JuridicalCode: TcxGridDBColumn;
    InvNumberArchive: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    InfoMoneyGroupCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationCode: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyGroupCode_ch: TcxGridDBColumn;
    InfoMoneyGroupName_ch: TcxGridDBColumn;
    InfoMoneyDestinationCode_ch: TcxGridDBColumn;
    InfoMoneyDestinationName_ch: TcxGridDBColumn;
    InfoMoneyCode_ch: TcxGridDBColumn;
    InfoMoneyName_ch: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    ContractArticleName: TcxGridDBColumn;
    ContractStateKindCode: TcxGridDBColumn;
    ContractConditionKindChoiceForm: TOpenChoiceForm;
    OKPO: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    PaidKindChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    ContractKindChoiceForm: TOpenChoiceForm;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    JuridicalBasisName: TcxGridDBColumn;
    ContractConditionKindName: TcxGridDBColumn;
    Value: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    actInsertJuridical: TdsdInsertUpdateAction;
    bbInsertJuridical: TdxBarButton;
    actMultiInsertJuridical: TMultiAction;
    actUpdateJuridical: TdsdInsertUpdateAction;
    bbUpdateJuridical: TdxBarButton;
    actContractUnRead: TdsdExecStoredProc;
    actContractInPartner: TdsdExecStoredProc;
    actContractRead: TdsdExecStoredProc;
    actContractClose: TdsdExecStoredProc;
    bbUnSigned: TdxBarButton;
    bbInPartner: TdxBarButton;
    bbSigned: TdxBarButton;
    bbClose: TdxBarButton;
    spContractUnRead: TdsdStoredProc;
    spContractRead: TdsdStoredProc;
    spContractPartner: TdsdStoredProc;
    spContractClose: TdsdStoredProc;
    ContractConditionComment: TcxGridDBColumn;
    BonusKindName: TcxGridDBColumn;
    BankName: TcxGridDBColumn;
    BankAccountExternal: TcxGridDBColumn;
    IsDefault: TcxGridDBColumn;
    IsStandart: TcxGridDBColumn;
    IsUnique: TcxGridDBColumn;
    IsPersonal: TcxGridDBColumn;
    ContractSendName: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    RefreshDispatcher: TRefreshDispatcher;
    PaidKindName_Condition: TcxGridDBColumn;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TContractConditionValueForm);

end.
