unit Contract;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorGuides, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, Vcl.Menus,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGrid, cxPC, cxPCdxBarPopupMenu, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxCurrencyEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TContractForm = class(TAncestorGuidesForm)
    Name: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    JuridicalBasisName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    Deferment: TcxGridDBColumn;
    isReport: TcxGridDBColumn;
    spUpdate_Contract_isReport: TdsdStoredProc;
    actUpdateisReport: TdsdExecStoredProc;
    bbUpdateisReport: TdxBarButton;
    GroupMemberSPName: TcxGridDBColumn;
    spUpdate_OrderParam: TdsdStoredProc;
    OrderSumm: TcxGridDBColumn;
    OrderSummComment: TcxGridDBColumn;
    OrderTime: TcxGridDBColumn;
    actUpdateMainDS: TdsdUpdateDataSet;
    spUpdate_isBarCode: TdsdStoredProc;
    spUpdate_isMorionCode: TdsdStoredProc;
    actUpdate_isMorionCode: TdsdExecStoredProc;
    actUpdate_isBarCode: TdsdExecStoredProc;
    bbUpdate_isMorionCode: TdxBarButton;
    bbUpdate_isBarCode: TdxBarButton;
    isPartialPay: TcxGridDBColumn;
    isMorionCodeLoad: TcxGridDBColumn;
    isBarCodeLoad: TcxGridDBColumn;
    spUpdate_isBarCodeLoad: TdsdStoredProc;
    spUpdate_isMorionCodeLoad: TdsdStoredProc;
    actUpdate_isMorionCodeLoad: TdsdExecStoredProc;
    actUpdate_isBarCodeLoad: TdsdExecStoredProc;
    bbUpdate_isMorionCodeLoad: TdxBarButton;
    bbUpdate_isBarCodeLoad: TdxBarButton;
    Code: TcxGridDBColumn;
    isDefermentContract: TcxGridDBColumn;
    actShowErased: TBooleanStoredProcAction;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TContractForm);


end.
