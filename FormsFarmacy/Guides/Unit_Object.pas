unit Unit_Object;

interface

uses
  Winapi.Windows, AncestorEnum, DataModul, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn, dsdDB,
  Datasnap.DBClient, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, Vcl.Controls, cxGrid,
  cxPCdxBarPopupMenu, Vcl.Menus, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxButtonEdit, cxCalendar;

type
  TUnit_ObjectForm = class(TAncestorEnumForm)
    JuridicalName: TcxGridDBColumn;
    ParentName: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    spUpdate_Unit_isOver: TdsdStoredProc;
    isOver: TcxGridDBColumn;
    actUpdateisOver: TdsdExecStoredProc;
    bbUpdateisOver: TdxBarButton;
    spUpdateisOverYes: TdsdExecStoredProc;
    macUpdateisOverYes: TMultiAction;
    bbUpdateisOverList: TdxBarButton;
    spUpdate_Unit_isOver_Yes: TdsdStoredProc;
    spUpdate_Unit_isOver_No: TdsdStoredProc;
    spUpdateisOverNo: TdsdExecStoredProc;
    macUpdateisOverNo: TMultiAction;
    bbUpdateisOverNoList: TdxBarButton;
    isUploadBadm: TcxGridDBColumn;
    spUpdate_Unit_isUploadBadm: TdsdStoredProc;
    actUpdateisUploadBadm: TdsdExecStoredProc;
    bbUpdateisUploadBadm: TdxBarButton;
    isMarginCategory: TcxGridDBColumn;
    spUpdate_Unit_isMarginCategory: TdsdStoredProc;
    actUpdateisMarginCategory: TdsdExecStoredProc;
    bbisMarginCategory: TdxBarButton;
    spUpdate_Unit_isReport: TdsdStoredProc;
    actUpdateisReport: TdsdExecStoredProc;
    bbUpdateisReport: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    Address: TcxGridDBColumn;
    CreateDate: TcxGridDBColumn;
    CloseDate: TcxGridDBColumn;
    UserManagerName: TcxGridDBColumn;
    actOpenUserForm: TOpenChoiceForm;
    spUpdate_Unit_Params: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    AreaName: TcxGridDBColumn;
    actOpenAreaForm: TOpenChoiceForm;
    Phone: TcxGridDBColumn;
    actChoiceUnit: TOpenChoiceForm;
    UnitRePriceName: TcxGridDBColumn;
    PartnerMedicalName: TcxGridDBColumn;
    isGoodsCategory: TcxGridDBColumn;
    spUpdate_GoodsCategory_Yes: TdsdStoredProc;
    spUpdate_GoodsCategory_No: TdsdStoredProc;
    macUpdateisGoodsCategoryNo: TMultiAction;
    macUpdateisGoodsCategoryYes: TMultiAction;
    actUpdateGoodsCategory_No: TdsdExecStoredProc;
    actUpdateGoodsCategory_Yes: TdsdExecStoredProc;
    bbUpdateisGoodsCategoryYes: TdxBarButton;
    bbUpdateisGoodsCategoryNo: TdxBarButton;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    spErasedUnErased: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actOpenUser2Form: TOpenChoiceForm;
    actOpenUser3Form: TOpenChoiceForm;
    spUpdate_Unit_isSUN_Yes: TdsdStoredProc;
    actUpdate_Unit_isSUN_Yes: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN: TdxBarButton;
    isSUN: TcxGridDBColumn;
    spUpdate_Unit_isTopNo: TdsdStoredProc;
    actUpdateisTopNo: TdsdExecStoredProc;
    bbUpdateisTopNo: TdxBarButton;
    ExecuteDialogKoeffSUN: TExecuteDialog;
    actUpdateKoeffSUN: TdsdDataSetRefresh;
    spUpdate_KoeffSUN: TdsdStoredProc;
    macUpdateKoeffSUN: TMultiAction;
    bbUpdateKoeffSUN: TdxBarButton;
    spUpdate_Unit_isSUN_v2_Yes: TdsdStoredProc;
    spUpdate_Unit_isSUN_in_yes: TdsdStoredProc;
    actUpdate_Unit_isSUN_v2_Yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_in_yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_out_yes: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_in: TdxBarButton;
    bbUpdate_Unit_isSUN_out: TdxBarButton;
    bbUpdate_Unit_isSUN_v2: TdxBarButton;
    ListDaySUN: TcxGridDBColumn;
    isNotCashMCS: TcxGridDBColumn;
    isNotCashListDiff: TcxGridDBColumn;
    spUpdate_Unit_isSUN_NotSold_yes: TdsdStoredProc;
    actUpdate_Unit_isSUN_NotSold_yes: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_NotSold: TdxBarButton;
    spUpdate_Unit_isSUN_v2_in_yes: TdsdStoredProc;
    spUpdate_Unit_isSUN_v2_out_yes: TdsdStoredProc;
    actUpdate_Unit_isSUN_v2_out_yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v2_in_yes: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_v2_in: TdxBarButton;
    bbUpdate_Unit_isSUN_v2_out: TdxBarButton;
    TimeWork: TcxGridDBColumn;
    isTechnicalRediscount: TcxGridDBColumn;
    spUpdate_Unit_TechnicalRediscount: TdsdStoredProc;
    actUpdate_Unit_TechnicalRediscount: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    spUpdate_Unit_isSUN_v3_yes: TdsdStoredProc;
    actUpdate_Unit_isSUN_v3_yes: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_v3: TdxBarButton;
    macUpdateKoeffSUNv3: TMultiAction;
    ExecuteDialogKoeffSUNv3: TExecuteDialog;
    actUpdateKoeffSUNv3: TdsdDataSetRefresh;
    spUpdate_KoeffSUNv3: TdsdStoredProc;
    bbUpdateKoeffSUNv3: TdxBarButton;
    spUpdate_Unit_isSUN_v3_in_yes: TdsdStoredProc;
    spUpdate_Unit_isSUN_v3_out_yes: TdsdStoredProc;
    actUpdate_Unit_isSUN_v3_out_no: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v3_in_yes: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_v3_in: TdxBarButton;
    bbUpdate_Unit_isSUN_v3_out: TdxBarButton;
    actUpdate_ListDaySUN: TMultiAction;
    actExecUpdate_ListDaySUN: TdsdExecStoredProc;
    actEDListDaySUN: TExecuteDialog;
    FormParams: TdsdFormParams;
    dxBarButton4: TdxBarButton;
    spUpdate_ListDaySUN: TdsdStoredProc;
    isAlertRecounting: TcxGridDBColumn;
    actUpdate_Unit_AlertRecounting: TdsdExecStoredProc;
    spUpdate_Unit_AlertRecounting: TdsdStoredProc;
    dxBarButton5: TdxBarButton;
    spUpdate_ListDaySUN_pi: TdsdStoredProc;
    actEDListDaySUN_pi: TExecuteDialog;
    actExecUpdate_ListDaySUN_pi: TdsdExecStoredProc;
    macUpdate_ListDaySUN_pi: TMultiAction;
    bbUpdate_ListDaySUN_pi: TdxBarButton;
    actUpdate_Unit_isSUN_v4_out_yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v4_in_yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v4_yes: TdsdExecStoredProc;
    spUpdate_Unit_isSUN_v4_yes: TdsdStoredProc;
    spUpdate_Unit_isSUN_v4_in_yes: TdsdStoredProc;
    spUpdate_Unit_isSUN_v4_out_yes: TdsdStoredProc;
    bbUpdate_Unit_isSUN_v4: TdxBarButton;
    bbUpdate_Unit_isSUN_v4_in: TdxBarButton;
    bbUpdate_Unit_isSUN_v4_out: TdxBarButton;
    ExecuteDialogUnit_T_SUN: TExecuteDialog;
    actUpdate_Unit_T_SUN: TdsdDataSetRefresh;
    macUpdateUnit_T_SUN: TMultiAction;
    spUpdate_Unit_T_SUN: TdsdStoredProc;
    macUpdateUnit_T_SUN_list: TMultiAction;
    Action1: TAction;
    T1_SUN_v2: TcxGridDBColumn;
    bbUpdateUnit_T_SUN: TdxBarButton;
    spUpdate_Unit_SunIncome: TdsdStoredProc;
    ExecuteDialogUnit_SunIncome: TExecuteDialog;
    actUpdate_Unit_SunIncome: TdsdDataSetRefresh;
    macUpdateUnit_SunIncome_list: TMultiAction;
    macUpdateUnit_SunIncome: TMultiAction;
    bbUpdateUnit_SunIncome: TdxBarButton;
    spUpdate_HT_SUN: TdsdStoredProc;
    ExecuteDialogUnit_HT_SUN: TExecuteDialog;
    actUpdate_Unit_HT_SUN: TdsdDataSetRefresh;
    macUpdateUnit_HT_Sun_list: TMultiAction;
    macUpdateUnit_HT_Sun: TMultiAction;
    bbUpdateUnit_HT_Sun: TdxBarButton;
    spUpdate_Unit_LimitSUN_N: TdsdStoredProc;
    ExecuteDialogUnit_LimitSun: TExecuteDialog;
    actUpdate_Unit_LimitSUN: TdsdDataSetRefresh;
    macUpdateUnit_LimitSUN_list: TMultiAction;
    macUpdateUnit_LimitSUN: TMultiAction;
    bbUpdateUnit_LimitSUN: TdxBarButton;
    LimitSUN_N: TcxGridDBColumn;
    spUpdate_SUN_v2_LockSale_Yes: TdsdStoredProc;
    spUpdate_SUN_v2_LockSale_No: TdsdStoredProc;
    actUpdate_SUN_v2_LockSale_No: TdsdExecStoredProc;
    actUpdate_SUN_v2_LockSale_Yes: TdsdExecStoredProc;
    macUpdate_SUN_v2_LockSale_No: TMultiAction;
    macUpdate_SUN_v2_LockSale_Yes: TMultiAction;
    bbUpdate_SUN_v2_LockSale_Yes: TdxBarButton;
    bbUpdate_SUN_v2_LockSale_No: TdxBarButton;
    spUpdate_SUN_Lock: TdsdStoredProc;
    actUpdate_SUN_Lock: TdsdExecStoredProc;
    ExecuteDialog_SUN_Lock: TExecuteDialog;
    macUpdate_SUN_Lock: TMultiAction;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarSeparator2: TdxBarSeparator;
    dxBarSeparator3: TdxBarSeparator;
    bbUpdate_SUN_Lock: TdxBarButton;
    macUpdate_SUN_Lock_list: TMultiAction;
    macUpdate_Unit_isSUN_Yes_list: TMultiAction;
    spUpdate_Unit_isSUN_No: TdsdStoredProc;
    actUpdate_Unit_isSUN_No: TdsdExecStoredProc;
    macUpdate_Unit_isSUN_No_list: TMultiAction;
    bbUpdate_Unit_isSUN_No_list: TdxBarButton;
    dxBarSubItem3: TdxBarSubItem;
    spUpdate_Unit_isSUN_v2_No: TdsdStoredProc;
    actUpdate_Unit_isSUN_v2_No: TdsdExecStoredProc;
    macUpdate_Unit_isSUN_v2_No_list: TMultiAction;
    macUpdate_Unit_isSUN_v2_Yes_list: TMultiAction;
    bbUpdate_Unit_isSUN_v2_No_list: TdxBarButton;
    dxBarSeparator4: TdxBarSeparator;
    spUpdate_Unit_isSUN_v2_in_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_in_no: TdsdExecStoredProc;
    spUpdate_Unit_isSUN_in_no: TdsdStoredProc;
    macUpdate_Unit_isSUN_in_no: TMultiAction;
    macUpdate_Unit_isSUN_out_yes: TMultiAction;
    macUpdate_Unit_isSUN_in_yes: TMultiAction;
    macUpdate_Unit_isSUN_out_no: TMultiAction;
    macUpdate_Unit_isSUN_NotSold_yes: TMultiAction;
    macUpdate_Unit_isSUN_NotSold_no: TMultiAction;
    macUpdate_Unit_isSUN_v2_in_yes: TMultiAction;
    macUpdate_Unit_isSUN_v2_in_no: TMultiAction;
    macUpdate_Unit_isSUN_v2_out_yes: TMultiAction;
    macUpdate_Unit_isSUN_v2_out_no: TMultiAction;
    macUpdate_Unit_isSUN_v3_yes: TMultiAction;
    macUpdate_Unit_isSUN_v3_no: TMultiAction;
    macUpdate_Unit_isSUN_v3_out_yes: TMultiAction;
    macUpdate_Unit_isSUN_v3_out_no: TMultiAction;
    macUpdate_Unit_isSUN_v3_in_no: TMultiAction;
    bbUpdate_Unit_isSUN_in_no: TdxBarButton;
    actUpdate_Unit_isSUN_out_no: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_out_no: TdxBarButton;
    spUpdate_Unit_isSUN_NotSold_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_NotSold_no: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_NotSold_no: TdxBarButton;
    actUpdate_Unit_isSUN_v2_in_no: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_v2_in_no: TdxBarButton;
    spUpdate_Unit_isSUN_v2_out_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_v2_out_no: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_v2_out_no: TdxBarButton;
    spUpdate_Unit_isSUN_v3_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_v3_no: TdsdExecStoredProc;
    spUpdate_Unit_isSUN_v3_out_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_v3_out_yes: TdsdExecStoredProc;
    spUpdate_Unit_isSUN_v3_in_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_v3_in_no: TdsdExecStoredProc;
    macUpdate_Unit_isSUN_v3_in_yes: TMultiAction;
    bbUpdate_Unit_isSUN_v3_no: TdxBarButton;
    bbUpdate_Unit_isSUN_v3_in_no: TdxBarButton;
    dxBarSeparator5: TdxBarSeparator;
    bbUpdate_Unit_isSUN_v3_out_no: TdxBarButton;
    dxBarSeparator6: TdxBarSeparator;
    macUpdate_Unit_isSUN_v4_yes: TMultiAction;
    macUpdate_Unit_isSUN_v4_no: TMultiAction;
    macUpdate_Unit_isSUN_v4_out_yes: TMultiAction;
    macUpdate_Unit_isSUN_v4_out_no: TMultiAction;
    macUpdate_Unit_isSUN_v4_in_yes: TMultiAction;
    macUpdate_Unit_isSUN_v4_in_no: TMultiAction;
    spUpdate_Unit_isSUN_v4_no: TdsdStoredProc;
    spUpdate_Unit_isSUN_v4_in_no: TdsdStoredProc;
    spUpdate_Unit_isSUN_v4_out_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_v4_no: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v4_in_no: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v4_out_no: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_v4_no: TdxBarButton;
    bbUpdate_Unit_isSUN_v4_out_yes: TdxBarButton;
    bbUpdate_Unit_isSUN_v4_in_no: TdxBarButton;
    dxBarSubItem4: TdxBarSubItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    DeySupplSun1: TcxGridDBColumn;
    MonthSupplSun1: TcxGridDBColumn;
    actDeySupplSun1: TMultiAction;
    actExecSPDeySupplSun1: TdsdExecStoredProc;
    actEDDeySupplSun1: TExecuteDialog;
    spUpdate_DeySupplSun1: TdsdStoredProc;
    spUpdate_MonthSupplSun1: TdsdStoredProc;
    actMonthSupplSun1: TMultiAction;
    actExecSPMonthSupplSun1: TdsdExecStoredProc;
    actEDMonthSupplSun1: TExecuteDialog;
    dxBarButton6: TdxBarButton;
    dxBarSeparator7: TdxBarSeparator;
    dxBarButton7: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    HT_SUN_All: TcxGridDBColumn;
    DateCheck: TcxGridDBColumn;
    TypeSAUA: TcxGridDBColumn;
    MasterSAUA: TcxGridDBColumn;
    spUpdate_UnitSAUA: TdsdStoredProc;
    spClear_UnitSAUA: TdsdStoredProc;
    actChoiceUnitSAUA: TOpenChoiceForm;
    actUpdate_UnitSAUA: TdsdExecStoredProc;
    actClear_UnitSAUA: TdsdExecStoredProc;
    PercentSAUA: TcxGridDBColumn;
    actExecutePercentSAUA: TExecuteDialog;
    actUpdate_PercentSAUA: TMultiAction;
    spUpdate_PercentSAUA: TdsdStoredProc;
    actExecUpdate_PercentSAUA: TdsdExecStoredProc;
    dxBarButton8: TdxBarButton;
    actExecuteUpdatePercentSAUA: TExecuteDialog;
    isSUA: TcxGridDBColumn;
    actUpdate_Unit_isSUA_No: TdsdExecStoredProc;
    macUpdate_Unit_isSUA_No_list: TMultiAction;
    actUpdate_Unit_isSUA_Yes: TdsdExecStoredProc;
    macUpdate_Unit_isSUA_Yes_list: TMultiAction;
    spUpdate_Unit_isSUA_No: TdsdStoredProc;
    spUpdate_Unit_isSUA_Yes: TdsdStoredProc;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    isShareFromPrice: TcxGridDBColumn;
    spUpdate_isShareFromPrice: TdsdStoredProc;
    actUpdate_isShareFromPrice: TMultiAction;
    actExecUpdate_isShareFromPrice: TdsdExecStoredProc;
    bbisShareFromPrice: TdxBarButton;
    dxBarStatic2: TdxBarStatic;
    isSUN_Supplement_in: TcxGridDBColumn;
    isSUN_Supplement_out: TcxGridDBColumn;
    spUpdate_Unit_isSUN_Supplement_in_yes: TdsdStoredProc;
    spUpdate_Unit_isSUN_Supplement_in_no: TdsdStoredProc;
    spUpdate_Unit_isSUN_out_no: TdsdStoredProc;
    spUpdate_Unit_isSUN_out_yes: TdsdStoredProc;
    spUpdate_Unit_isSUN_Supplement_out_yes: TdsdStoredProc;
    spUpdate_Unit_isSUN_Supplement_out_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_Supplement_in_yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_Supplement_in_no: TdsdExecStoredProc;
    macUpdate_Unit_isSUN_Supplement_out_yes: TMultiAction;
    macUpdate_Unit_isSUN_Supplement_out_no: TMultiAction;
    macUpdate_Unit_isSUN_Supplement_in_yes: TMultiAction;
    macUpdate_Unit_isSUN_Supplement_in_no: TMultiAction;
    actUpdate_Unit_isSUN_Supplement_out_yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_Supplement_out_no: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_Supplement_in_yes: TdxBarButton;
    bbUpdate_Unit_isSUN_Supplement_out_yes: TdxBarButton;
    bbUpdate_Unit_isSUN_Supplement_in_no: TdxBarButton;
    bbUpdate_Unit_isSUN_Supplement_out_no: TdxBarButton;
    spUpdate_SunAllParam: TdsdStoredProc;
    actOpenChoiceUnitTree: TOpenChoiceForm;
    actUpdate_SunAllParam: TdsdExecStoredProc;
    dxBarButton11: TdxBarButton;
    isOutUKTZED_SUN1: TcxGridDBColumn;
    spUpdate_isOutUKTZED_SUN1_Yes: TdsdStoredProc;
    spUpdate_isOutUKTZED_SUN1_No: TdsdStoredProc;
    actUpdate_isOutUKTZED_SUN1_No: TdsdExecStoredProc;
    actUpdate_isOutUKTZED_SUN1_Yes: TdsdExecStoredProc;
    macUpdate_isOutUKTZED_SUN1_No: TMultiAction;
    macUpdate_isOutUKTZED_SUN1_Yes: TMultiAction;
    dxBarButton12: TdxBarButton;
    dxBarButton13: TdxBarButton;
    isCheckUKTZED: TcxGridDBColumn;
    macExecUpdate_isCheckUKTZED: TMultiAction;
    actExecUpdate_isCheckUKTZED: TdsdExecStoredProc;
    dxBarButton14: TdxBarButton;
    spUpdate_isCheckUKTZED: TdsdStoredProc;
    isGoodsUKTZEDRRO: TcxGridDBColumn;
    macExecUpdate_isGoodsUKTZEDRRO: TMultiAction;
    actExecUpdate_isGoodsUKTZEDRRO: TdsdExecStoredProc;
    spUpdate_isGoodsUKTZEDRRO: TdsdStoredProc;
    dxBarButton15: TdxBarButton;
    isSUN_Supplement_Priority: TcxGridDBColumn;
    spUpdate_Unit_isSUN_Supplement_Priority_yes: TdsdStoredProc;
    spUpdate_Unit_isSUN_Supplement_Priority_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_Supplement_Priority_yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_Supplement_Priority_no: TdsdExecStoredProc;
    macUpdate_Unit_isSUN_Supplement_Priority_yes: TMultiAction;
    macUpdate_Unit_isSUN_Supplement_Priority_no: TMultiAction;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    isMessageByTime: TcxGridDBColumn;
    macExecUpdate_isMessageByTime: TMultiAction;
    actExecUpdate_isMessageByTime: TdsdExecStoredProc;
    dxBarButton18: TdxBarButton;
    spUpdate_isMessageByTime: TdsdStoredProc;
    isMessageByTimePD: TcxGridDBColumn;
    spUpdate_isMessageByTimePD: TdsdStoredProc;
    macExecUpdate_isMessageByTimePD: TMultiAction;
    actExecUpdate_isMessageByTimePD: TdsdExecStoredProc;
    dxBarButton19: TdxBarButton;
    spUnit_isParticipDistribListDiff: TdsdStoredProc;
    spUnit_isPauseDistribListDiff: TdsdStoredProc;
    macactUnit_isParticipDistribListDiff: TMultiAction;
    actUnit_isParticipDistribListDiff: TdsdExecStoredProc;
    macUnit_isPauseDistribListDiff: TMultiAction;
    actUnit_isPauseDistribListDiff: TdsdExecStoredProc;
    dxBarButton20: TdxBarButton;
    dxBarButton21: TdxBarButton;
    isParticipDistribListDiff: TcxGridDBColumn;
    spUnit_isRequestDistribListDiff: TdsdStoredProc;
    macUnit_isRequestDistribListDiff: TMultiAction;
    actUnit_isRequestDistribListDiff: TdsdExecStoredProc;
    dxBarButton22: TdxBarButton;
    isBlockCommentSendTP: TcxGridDBColumn;
    PharmacyManager: TcxGridDBColumn;
    PharmacyManagerPhone: TcxGridDBColumn;
    TelegramId: TcxGridDBColumn;
    actUpdate_TelegramId: TdsdExecStoredProc;
    actTelegramIdDialog: TExecuteDialog;
    spUpdate_TelegramId: TdsdStoredProc;
    dxBarButton23: TdxBarButton;
    actSendTelegramBotName: TdsdSendTelegramBotAction;
    dxBarButton24: TdxBarButton;
    spGet_TelegramBotToken: TdsdStoredProc;
    actGet_TelegramBotToken: TdsdExecStoredProc;
    isOnlyTimingSUN: TcxGridDBColumn;
    mactUpdate_isOnlyTimingSUN: TMultiAction;
    actUpdate_isOnlyTimingSUN: TdsdExecStoredProc;
    spUpdate_isOnlyTimingSUN: TdsdStoredProc;
    dxBarButton25: TdxBarButton;
    isSP1303: TcxGridDBColumn;
    EndDateSP1303: TcxGridDBColumn;
    isErrorRROToVIP: TcxGridDBColumn;
    mspUpdate_isErrorRROToVIP: TMultiAction;
    actUpdate_isErrorRROToVIP: TdsdExecStoredProc;
    spUpdate_isErrorRROToVIP: TdsdStoredProc;
    dxBarButton26: TdxBarButton;
    isSUN_v2_Supplement_in: TcxGridDBColumn;
    isSUN_v2_Supplement_out: TcxGridDBColumn;
    spUpdate_isSUN_v2_Supplement_out_yes: TdsdStoredProc;
    spUpdate_isSUN_v2_Supplement_in_yes: TdsdStoredProc;
    spUpdate_isSUN_v2_Supplement_in_no: TdsdStoredProc;
    spUpdate_isSUN_v2_Supplement_out_no: TdsdStoredProc;
    actUpdate_Unit_isSUN_v2_Supplement_in_yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v2_Supplement_in_no: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v2_Supplement_out_yes: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v2_Supplement_out_no: TdsdExecStoredProc;
    macUpdate_Unit_isSUN_v2_Supplement_out_yes: TMultiAction;
    macUpdate_Unit_isSUN_v2_Supplement_out_no: TMultiAction;
    macUpdate_Unit_isSUN_v2_Supplement_in_yes: TMultiAction;
    macUpdate_Unit_isSUN_v2_Supplement_in_no: TMultiAction;
    dxBarButton27: TdxBarButton;
    dxBarButton28: TdxBarButton;
    dxBarButton29: TdxBarButton;
    dxBarButton30: TdxBarButton;
    spUpdate_ShowMessageSite: TdsdStoredProc;
    isShowMessageSite: TcxGridDBColumn;
    mactUpdate_ShowMessageSite: TMultiAction;
    actUpdate_ShowMessageSite: TdsdExecStoredProc;
    dxBarButton31: TdxBarButton;
    spUpdate_SupplementAddCash: TdsdStoredProc;
    mactUpdate_SupplementAddCash: TMultiAction;
    actUpdate_SupplementAddCash: TdsdExecStoredProc;
    dxBarButton32: TdxBarButton;
    isSupplementAddCash: TcxGridDBColumn;
    isSUN_NotSoldIn: TcxGridDBColumn;
    spUpdate_SUN_NotSoldIn: TdsdStoredProc;
    mactUpdate_SUN_NotSoldIn: TMultiAction;
    actUpdate_SUN_NotSoldIn: TdsdExecStoredProc;
    dxBarButton33: TdxBarButton;
    isSupplementAdd30Cash: TcxGridDBColumn;
    spUpdate_SupplementAdd30Cash: TdsdStoredProc;
    mactUpdate_SupplementAdd30Cash: TMultiAction;
    actUpdate_SupplementAdd30Cash: TdsdExecStoredProc;
    dxBarButton34: TdxBarButton;
    isExpressVIPConfirm: TcxGridDBColumn;
    spUpdate_ExpressVIPConfirm: TdsdStoredProc;
    mactUpdate_ExpressVIPConfirm: TMultiAction;
    actUpdate_ExpressVIPConfirm: TdsdExecStoredProc;
    dxBarButton35: TdxBarButton;
    isShowPlanEmployeeUser: TcxGridDBColumn;
    spUpdate_ShowPlanEmployeeUser: TdsdStoredProc;
    mactUpdate_ShowPlanEmployeeUser: TMultiAction;
    actUpdate_ShowPlanEmployeeUser: TdsdExecStoredProc;
    dxBarButton36: TdxBarButton;
    actShowActive: TBooleanStoredProcAction;
    bbShowActive: TdxBarButton;
    isShowActiveAlerts: TcxGridDBColumn;
    mactUpdate_isShowActiveAlerts: TMultiAction;
    actUpdate_isShowActiveAlerts: TdsdExecStoredProc;
    spUpdate_isShowActiveAlerts: TdsdStoredProc;
    dxBarButton37: TdxBarButton;
    spUpdate_isAutospaceOS: TdsdStoredProc;
    spUpdate_SetDateRRO: TdsdStoredProc;
    mactUpdate_isAutospaceOS: TMultiAction;
    actUpdate_isAutospaceOS: TdsdExecStoredProc;
    dxBarButton38: TdxBarButton;
    actDateRRODialog: TExecuteDialog;
    mactUpdate_SetDateRRO: TMultiAction;
    actUpdate_SetDateRRO: TdsdExecStoredProc;
    dxBarButton39: TdxBarButton;
    SetDateRRO: TcxGridDBColumn;
    isAutospaceOS: TcxGridDBColumn;
    isReplaceSte2ListDif: TcxGridDBColumn;
    spUpdate_isReplaceSte2ListDif: TdsdStoredProc;
    mactUpdate_isReplaceSte2ListDif: TMultiAction;
    actUpdate_isReplaceSte2ListDif: TdsdExecStoredProc;
    dxBarButton40: TdxBarButton;
    isDividePartionDate: TcxGridDBColumn;
    isSendErrorTelegramBot: TcxGridDBColumn;
    spUpdate_SendErrorTelegramBot: TdsdStoredProc;
    mactUpdate_SendErrorTelegramBot: TMultiAction;
    actUpdate_SendErrorTelegramBot: TdsdExecStoredProc;
    dxBarButton41: TdxBarButton;
    isShowPlanMobileAppUser: TcxGridDBColumn;
    mactUpdate_ShowPlanMobileAppUser: TMultiAction;
    actUpdate_ShowPlanMobileAppUser: TdsdExecStoredProc;
    dxBarButton42: TdxBarButton;
    spUpdate_ShowPlanMobileAppUser: TdsdStoredProc;
    spUpdate_ColdOutSUN: TdsdStoredProc;
    mactUpdate_ColdOutSUN: TMultiAction;
    actUpdate_ColdOutSUN: TdsdExecStoredProc;
    isColdOutSUN: TcxGridDBColumn;
    dxBarButton43: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TUnit_ObjectForm);
end.
