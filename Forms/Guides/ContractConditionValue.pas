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
  dsdAddOn, dxBarExtItems, cxButtonEdit, cxImageComboBox;

type
  TContractConditionValueForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clInvNumber: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
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
    clSigningDate: TcxGridDBColumn;
    clStartDate: TcxGridDBColumn;
    clEndDate: TcxGridDBColumn;
    clContractKindName: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    clJuridicalCode: TcxGridDBColumn;
    clInvNumberArchive: TcxGridDBColumn;
    clPersonalName: TcxGridDBColumn;
    clInfoMoneyGroupCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationCode: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    clInfoMoneyGroupCode_ch: TcxGridDBColumn;
    clInfoMoneyGroupName_ch: TcxGridDBColumn;
    clInfoMoneyDestinationCode_ch: TcxGridDBColumn;
    clInfoMoneyDestinationName_ch: TcxGridDBColumn;
    clInfoMoneyCode_ch: TcxGridDBColumn;
    clInfoMoneyName_ch: TcxGridDBColumn;
    clIsErased: TcxGridDBColumn;
    clPaidKindName: TcxGridDBColumn;
    clAreaName: TcxGridDBColumn;
    clContractArticleName: TcxGridDBColumn;
    clContractStateKindName: TcxGridDBColumn;
    ContractConditionKindChoiceForm: TOpenChoiceForm;
    clOKPO: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    PaidKindChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    ContractKindChoiceForm: TOpenChoiceForm;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    clJuridicalBasisName: TcxGridDBColumn;
    clContractConditionKindName: TcxGridDBColumn;
    clValue: TcxGridDBColumn;
    clCode: TcxGridDBColumn;
    clJuridicalName_find: TcxGridDBColumn;
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
    clContractConditionComment: TcxGridDBColumn;
    clBonusKindName: TcxGridDBColumn;
    clBankName: TcxGridDBColumn;
    clBankAccount: TcxGridDBColumn;
    clisDefault: TcxGridDBColumn;
    clisStandart: TcxGridDBColumn;
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
