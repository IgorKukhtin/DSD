unit StaffListData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter, dsdAddOn,
  dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxCheckBox,
  DataModul, cxButtonEdit, Vcl.Grids, Vcl.DBGrids, cxContainer, dsdGuides,
  cxTextEdit, cxMaskEdit, cxLabel, Vcl.ExtCtrls, cxSplitter, cxCurrencyEdit,
  dsdCommon;

type
  TStaffListDataForm = class(TParentForm)
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    spErasedUnErased: TdsdStoredProc;
    cxGridStaffList: TcxGrid;
    cxGridDBTableViewStaffLis: TcxGridDBTableView;
    clPositionName: TcxGridDBColumn;
    clPositionLevelName: TcxGridDBColumn;
    clHoursPlan: TcxGridDBColumn;
    clPersonalCount: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
    clsfIsErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxGridStaffListCost: TcxGrid;
    cxGridDBTableViewStaffListCost: TcxGridDBTableView;
    clModelServiceName: TcxGridDBColumn;
    clsfcComment: TcxGridDBColumn;
    clPrice: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    StaffListCDS: TClientDataSet;
    StaffListDS: TDataSource;
    spSelectStaffList: TdsdStoredProc;
    spInsertUpdateObject: TdsdStoredProc;
    InsertRecord: TInsertRecord;
    PositionChoiceForm: TOpenChoiceForm;
    actUpdateStaffList: TdsdUpdateDataSet;
    PositionLevelChoiceForm: TOpenChoiceForm;
    StaffListCostCDS: TClientDataSet;
    StaffListCostDS: TDataSource;
    spSelectStaffListCost: TdsdStoredProc;
    spInsertUpdateObjectSLCost: TdsdStoredProc;
    InsertRecordSLC: TInsertRecord;
    ModelServiceChoiceForm: TOpenChoiceForm;
    bbModelServise: TdxBarButton;
    actUpdateStaffListCost: TdsdUpdateDataSet;
    clsfcisErased: TcxGridDBColumn;
    cxGridStaffListSumm: TcxGrid;
    cxGridDBTableStaffListSumm: TcxGridDBTableView;
    clStaffListSummKindName: TcxGridDBColumn;
    clValue: TcxGridDBColumn;
    clslsummComment: TcxGridDBColumn;
    clslsummisErased: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    StaffListSummDS: TDataSource;
    StaffListSummCDS: TClientDataSet;
    spInsertUpdateObjectSLSumm: TdsdStoredProc;
    spSelectStaffListSumm: TdsdStoredProc;
    clStaffListMasterCode: TcxGridDBColumn;
    clslCode: TcxGridDBColumn;
    StaffListChoiceForm: TOpenChoiceForm;
    StaffListSummKindChoiceForm: TOpenChoiceForm;
    InsertRecordSLS: TInsertRecord;
    bbStaffListSummKind: TdxBarButton;
    actStaffListSumm: TdsdUpdateDataSet;
    clUnitName: TcxGridDBColumn;
    GuidesUnit: TdsdGuides;
    actInsert: TdsdInsertUpdateAction;
    bbInsertSL: TdxBarButton;
    Panel1: TPanel;
    ceUnit: TcxButtonEdit;
    actUpdate: TdsdInsertUpdateAction;
    dsdDBViewAddOnStaffListCost: TdsdDBViewAddOn;
    dsdDBViewAddOnStaffListSumm: TdsdDBViewAddOn;
    spErasedUnErasedCost: TdsdStoredProc;
    spErasedUnErasedSumm: TdsdStoredProc;
    dsdSetErasedCost: TdsdUpdateErased;
    dsdSetUnErasedCost: TdsdUpdateErased;
    bbErasedCost: TdxBarButton;
    bbUnErasedCost: TdxBarButton;
    dsdSetErasedSumm: TdsdUpdateErased;
    dsdSetUnErasedSumm: TdsdUpdateErased;
    bbErasedSumm: TdxBarButton;
    bbUnErasedSumm: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    clHoursDay: TcxGridDBColumn;
    clcsummSummKindComment: TcxGridDBColumn;
    cxSplitterBottom: TcxSplitter;
    cxSplitter1: TcxSplitter;
    clisPositionLevel: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    ProtocolOpenFormCost: TdsdOpenForm;
    ProtocolOpenFormSumm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    bbProtocolCost: TdxBarButton;
    bbProtocolSumm: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    spUpdate_HoursPlan: TdsdStoredProc;
    actUpdate_HoursPlan: TdsdUpdateDataSet;
    macUpdate_HoursPlan_list: TMultiAction;
    macUpdate_HoursPlan: TMultiAction;
    actRefreshMain: TdsdDataSetRefresh;
    bbUpdate_HoursPlan: TdxBarButton;
    cxLabel15: TcxLabel;
    edHoursPlan: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    edHoursPlan_new: TcxCurrencyEdit;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    dxBarControlContainerItem4: TdxBarControlContainerItem;
    cxLabel2: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TStaffListDataForm);
end.
