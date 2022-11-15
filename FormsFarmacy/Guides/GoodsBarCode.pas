unit GoodsBarCode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  DataModul, dxSkinsdxBarPainter, dxBar, cxPropertiesStore, Datasnap.DBClient, dxBarExtItems,
  dsdAddOn, dsdDB, ExternalLoad, dsdAction, Vcl.ActnList, dxSkinBlack,
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
  cxContainer, dsdGuides, cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel;

type
  TGoodsBarCodeForm = class(TParentForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    ActionList: TActionList;
    actGetImportSetting: TdsdExecStoredProc;
    actRefresh: TdsdDataSetRefresh;
    dsdGridToExcel: TdsdGridToExcel;
    actUpdateDataSet: TdsdUpdateDataSet;
    actStartLoad: TMultiAction;
    actDoLoad: TExecuteImportSettingsAction;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dxBarButtonRefresh: TdxBarButton;
    dxBarManagerBar1: TdxBar;
    dxBarButtonGridToExcel: TdxBarButton;
    spInsertUpdate: TdsdStoredProc;
    Id: TcxGridDBColumn;
    GoodsId: TcxGridDBColumn;
    GoodsMainId: TcxGridDBColumn;
    GoodsBarCodeId: TcxGridDBColumn;
    GoodsJuridicalId: TcxGridDBColumn;
    JuridicalId: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    ProducerName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    BarCode: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    spGetImportSettingId: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spInsertUpdateLoad: TdsdStoredProc;
    dxBarButtonLoad: TdxBarButton;
    ErrorText: TcxGridDBColumn;
    dxBarStatic1: TdxBarStatic;
    spGetImportSettingId_Price: TdsdStoredProc;
    bbStartLoad2: TdxBarButton;
    cxLabel3: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    spInsertUpdateLoad_Price: TdsdStoredProc;
    actDoLoad_Price: TExecuteImportSettingsAction;
    actGetImportSetting_Price: TdsdExecStoredProc;
    actStartLoad_Price: TMultiAction;
    dsdStoredProc1: TdsdStoredProc;
    actTest: TdsdExecStoredProc;
    CodeUKTZED: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsBarCodeForm);
end.
