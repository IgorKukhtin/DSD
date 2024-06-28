unit PartionCell;

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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCurrencyEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, ExternalLoad, dsdCommon;

type
  TPartionCellForm = class(TParentForm)
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
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    dsdStoredProc: TdsdStoredProc;
    actUpdate1: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    dsdGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    spErasedUnErased: TdsdStoredProc;
    bbChoice: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actOpenPartionCell_list: TdsdOpenForm;
    bbOpenPartionCell_list: TdxBarButton;
    actUpdate2: TdsdInsertUpdateAction;
    actUpdate3: TdsdInsertUpdateAction;
    actUpdate4: TdsdInsertUpdateAction;
    actUpdate5: TdsdInsertUpdateAction;
    actUpdate6: TdsdInsertUpdateAction;
    bbUpdate2: TdxBarButton;
    bbUpdate3: TdxBarButton;
    bbUpdate4: TdxBarButton;
    bbUpdate5: TdxBarButton;
    bbUpdate6: TdxBarButton;
    spGetImportSettingId: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actDoLoad: TExecuteImportSettingsAction;
    macStartLoad: TMultiAction;
    actGetImportSetting: TdsdExecStoredProc;
    bbStartLoad: TdxBarButton;
    spUpdateParams: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actProtocol1: TdsdOpenForm;
    actProtocol2: TdsdOpenForm;
    actProtocol3: TdsdOpenForm;
    actProtocol4: TdsdOpenForm;
    actProtocol5: TdsdOpenForm;
    actProtocol6: TdsdOpenForm;
    bbProtocol1: TdxBarButton;
    bbProtocol2: TdxBarButton;
    bbProtocol3: TdxBarButton;
    bbProtocol4: TdxBarButton;
    bbProtocol5: TdxBarButton;
    bbProtocol6: TdxBarButton;
    Code_l1: TcxGridDBColumn;
    spGetImportSettingIdBox: TdsdStoredProc;
    actGetImportSettingIdBox: TdsdExecStoredProc;
    macStartLoadBox: TMultiAction;
    bbStartLoadBox: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPartionCellForm);

end.
