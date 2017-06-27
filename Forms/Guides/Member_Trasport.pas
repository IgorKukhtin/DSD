unit Member_Trasport;

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
  DataModul, cxButtonEdit, cxCurrencyEdit;

type
  TMember_TrasportForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    INN: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    isErased: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    DriverCertificate: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    IsOfficial: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    StartSummerDate: TcxGridDBColumn;
    EndSummerDate: TcxGridDBColumn;
    SummerFuel: TcxGridDBColumn;
    WinterFuel: TcxGridDBColumn;
    Reparation: TcxGridDBColumn;
    LimitMoney: TcxGridDBColumn;
    LimitDistance: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    CarModelName: TcxGridDBColumn;
    bbUpdateParams: TdxBarButton;
    spInsertUpdateParam: TdsdStoredProc;
    actDialog: TExecuteDialog;
    actRecalc: TdsdExecStoredProc;
    actStartRecalc: TMultiAction;
    FormParams: TdsdFormParams;
    actRecalcMulti: TMultiAction;
    actDialogDate: TExecuteDialog;
    actRecalcDate: TdsdExecStoredProc;
    spInsertUpdateDate: TdsdStoredProc;
    actRecalcDateMulti: TMultiAction;
    actStartRecalcDate: TMultiAction;
    bbStartRecalcDate: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}

initialization
  RegisterClass(TMember_TrasportForm);

end.
