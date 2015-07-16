unit Units;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox,
  dxSkinsdxBarPainter, dsdAddOn, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxSplitter;

type
  TUnitForm = class(TParentForm)
    cxSplitter1: TcxSplitter;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    ceCode: TcxGridDBColumn;
    ceName: TcxGridDBColumn;
    ceBranchName: TcxGridDBColumn;
    ceIsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbChoice: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdSetUnErased: TdsdUpdateErased;
    GridDS: TDataSource;
    ClientDataSet: TClientDataSet;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    ceBusinessName: TcxGridDBColumn;
    ceJuridicalName: TcxGridDBColumn;
    ceAccountDirectionCode: TcxGridDBColumn;
    ceAccountDirectionName: TcxGridDBColumn;
    ceAccountGroupCode: TcxGridDBColumn;
    ceAccountGroupName: TcxGridDBColumn;
    ceProfitLossGroupCode: TcxGridDBColumn;
    ceProfitLossGroupName: TcxGridDBColumn;
    ceProfitLossDirectionCode: TcxGridDBColumn;
    ceProfitLossDirectionName: TcxGridDBColumn;
    ceParentName: TcxGridDBColumn;
    actGridToExcel: TdsdGridToExcel;
    dxBarButton1: TdxBarButton;
    clInvNumber: TcxGridDBColumn;
    clContract_JuridicalName: TcxGridDBColumn;
    clContract_InfomoneyName: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    RouteSortingName: TcxGridDBColumn;
    isPartionDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}
 initialization
  RegisterClass(TUnitForm);
end.
