unit OrderInternalZeroingSUA;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxContainer, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxLabel, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.ExtCtrls, dxSkinBlack,
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
  AncestorDBGrid;

type
  TOrderInternalZeroingSUAForm = class(TAncestorDBGridForm)
    Remains: TcxGridDBColumn;
    bbLabel: TdxBarControlContainerItem;
    bbGuides: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbInsertUpdate: TdxBarButton;
    FormParams: TdsdFormParams;
    GoodsCode: TcxGridDBColumn;
    actDataToJsonAction: TdsdDataToJsonAction;
    actExecSPCreateVIPSend: TdsdExecStoredProc;
    spactUpdateZeroingSUA: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    NeedReorder: TcxGridDBColumn;
    MCS: TcxGridDBColumn;
    MCS_isClose: TcxGridDBColumn;
    Amount_Layout: TcxGridDBColumn;
    Amount_OrderInternal: TcxGridDBColumn;
    Amount_Income: TcxGridDBColumn;
    Amount_Send: TcxGridDBColumn;
    Amount_OrderExternal: TcxGridDBColumn;
    Amount_Reserve: TcxGridDBColumn;
    actFormClose: TdsdFormClose;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalZeroingSUAForm)


end.
