unit MobileConst_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, ParentForm, dsdDB, dsdAction,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinsdxBarPainter, dxBarExtItems,
  dsdAddOn, cxCheckBox, dxSkinscxPCPainter, cxButtonEdit, cxContainer,
  cxTextEdit, dsdGuides, cxLabel, cxCurrencyEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls;

type
  TMobileConst_ObjectForm = class(TParentForm)
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spSelect: TdsdStoredProc;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    bbChoiceGuides: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    bbJuridicalLabel: TdxBarControlContainerItem;
    bbJuridicalGuides: TdxBarControlContainerItem;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    spGet_Const: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    Panel: TPanel;
    cxLabel1: TcxLabel;
    edPaidKindName_First: TcxButtonEdit;
    edPersonalTrade: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edPaidKindName_Second: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edUnitName: TcxButtonEdit;
    spGet_PersonalTrade: TdsdStoredProc;
    cxLabel6: TcxLabel;
    edStatusName_UnComplete: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edStatusName_Complete: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edStatusName_Erased: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edUnitName_ret: TcxButtonEdit;
    cxLabel10: TcxLabel;
    edMemberName: TcxButtonEdit;
    cxLabel11: TcxLabel;
    edCashName: TcxButtonEdit;
    cxLabel12: TcxLabel;
    edUserLogin: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edOperDate_diff: TcxButtonEdit;
    cxLabel15: TcxLabel;
    edWebService: TcxButtonEdit;
    edPriceList_def: TcxButtonEdit;
    cxLabel2: TcxLabel;
    cxLabel14: TcxLabel;
    edReturnDayCount: TcxButtonEdit;
    PersonalTradeGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMobileConst_ObjectForm);

end.
