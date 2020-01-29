unit PlanIventory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dsdAddOn,
  dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxCheckBox,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack,
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
  cxSplitter, cxButtonEdit, cxCurrencyEdit;

type
  TPlanIventoryForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Name: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
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
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    isErased: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    UnitName: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    DateEnd: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    actGridToExcelReport: TdsdGridToExcel;
    actInsertMakerReport: TdsdInsertUpdateAction;
    actUpdateMakerReport: TdsdInsertUpdateAction;
    dsdSetErasedMakerReport: TdsdUpdateErased;
    dsdSetUnErasedMakerReport: TdsdUpdateErased;
    bbInsertMakerReport: TdxBarButton;
    bbUpdateMakerReport: TdxBarButton;
    bbSetErasedMakerReport: TdxBarButton;
    bbSetUnErasedMakerReport: TdxBarButton;
    bbGridToExcelReport: TdxBarButton;
    actUpdateDataSet: TdsdUpdateDataSet;
    actChoiceFormContactPerson: TOpenChoiceForm;
    FormParams: TdsdFormParams;
    ExecuteDialogUpdateSendPlan: TExecuteDialog;
    actUpdateSendPlan: TdsdDataSetRefresh;
    macUpdateSendPlan: TMultiAction;
    macUpdateSendPlanList: TMultiAction;
    bbUpdateSendPlan: TdxBarButton;
    DateStart: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TPlanIventoryForm);
end.
