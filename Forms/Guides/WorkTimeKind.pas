unit WorkTimeKind;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dsdAddOn, dxBarExtItems,
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
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCurrencyEdit, dsdCommon;

type
  TWorkTimeKindForm = class(TParentForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    Name: TcxGridDBColumn;
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
    spSelect: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    isErased: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dxBarStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    spErasedUnErased: TdsdStoredProc;
    bbChoiceGuide: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
    actProtocol: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    ShortName: TcxGridDBColumn;
    Tax: TcxGridDBColumn;
    spUpdateObject: TdsdStoredProc;
    Value: TcxGridDBColumn;
    actUpdateDataSet: TdsdUpdateDataSet;
    EnumName: TcxGridDBColumn;
    spUpdate_Summ: TdsdStoredProc;
    ExecuteDialogSumm: TExecuteDialog;
    actUpdate_Summ: TdsdExecStoredProc;
    macUpdate_Summ: TMultiAction;
    FormParams: TdsdFormParams;
    bbUpdate_Summ: TdxBarButton;
    isNoSheetChoice: TcxGridDBColumn;
    spUpdate_NoSheetChoice: TdsdStoredProc;
    actUpdate_NoSheetChoice: TdsdExecStoredProc;
    bbUpdate_NoSheetChoice: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    actShowErased: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    bbShowErased: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWorkTimeKindForm);

end.
