unit Cash_Personal;

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
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, Vcl.DBActns,
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
  dxSkinXmas2008Blue, dsdCommon;

type
  TCash_PersonalForm = class(TAncestorDocumentForm)
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
    Comment: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    edServiceDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel12: TcxLabel;
    Amount_avance: TcxGridDBColumn;
    edPersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
    cxLabel3: TcxLabel;
    UnitCode: TcxGridDBColumn;
    PersonalCode: TcxGridDBColumn;
    isMain: TcxGridDBColumn;
    isOfficial: TcxGridDBColumn;
    SummToPay_cash: TcxGridDBColumn;
    edDocumentPersonalService: TcxButtonEdit;
    GuidesPersonalServiceJournal: TdsdGuides;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    edCash: TcxButtonEdit;
    GuidesCash: TdsdGuides;
    cxLabel9: TcxLabel;
    edMember: TcxButtonEdit;
    GuidesMember: TdsdGuides;
    SummService: TcxGridDBColumn;
    SummRemains: TcxGridDBColumn;
    spInsertUpdateMIAmount: TdsdStoredProc;
    bbInsertUpdateMIAmount_One: TdxBarButton;
    bbInsertUpdateMIAmount_All: TdxBarButton;
    SummToPay: TcxGridDBColumn;
    SummCard: TcxGridDBColumn;
    Amount_service: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    spGetMIAmount: TdsdStoredProc;
    actRefreshMaster: TdsdDataSetRefresh;
    mactInsertUpdateMIAmount_AllGrid: TMultiAction;
    actGetMIAmount: TdsdExecStoredProc;
    actInsertUpdateMIAmount_One: TdsdExecStoredProc;
    actInsertUpdateMIAmount_All: TdsdExecStoredProc;
    actMasterPost: TDataSetPost;
    mactInsertUpdateMIAmount_One: TMultiAction;
    mactList: TMultiAction;
    SummMinus: TcxGridDBColumn;
    SummAdd: TcxGridDBColumn;
    SummSocialIn: TcxGridDBColumn;
    SummSocialAdd: TcxGridDBColumn;
    SummChild: TcxGridDBColumn;
    SummTransport: TcxGridDBColumn;
    SummPhone: TcxGridDBColumn;
    SummTransportAddLong: TcxGridDBColumn;
    SummTransportTaxi: TcxGridDBColumn;
    SummHoliday: TcxGridDBColumn;
    SummNalog: TcxGridDBColumn;
    SummCardSecond: TcxGridDBColumn;
    SummMinusExt: TcxGridDBColumn;
    PositionLevelName: TcxGridDBColumn;
    spGetMICardSecondCash: TdsdStoredProc;
    actGetMICardSecondCash: TdsdExecStoredProc;
    mactListCardSecondCash: TMultiAction;
    mactInsertUpdateMICardSecondCash_AllGrid: TMultiAction;
    bbInsertUpdateMICardSecondCash_AllGrid: TdxBarButton;
    isCalculated: TcxGridDBColumn;
    SummCardSecondRemains: TcxGridDBColumn;
    Amount_avance_ret: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    SummAvance: TcxGridDBColumn;
    SummAvCardSecond: TcxGridDBColumn;
    AmountCardSecond_avance: TcxGridDBColumn;
    actReport_Open: TdsdOpenForm;
    bbReport_Open: TdxBarButton;
    MoneyPlaceName: TcxGridDBColumn;
    ServiceDate_mp: TcxGridDBColumn;
    SummCardSecond_all_00807: TcxGridDBColumn;
    SummCardSecond_diff_00807: TcxGridDBColumn;
    SummCardSecond_all_005: TcxGridDBColumn;
    SummCardSecond_diff_005: TcxGridDBColumn;
    AmountService_diff: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCash_PersonalForm);

end.
