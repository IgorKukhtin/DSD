unit ListDiffFormVIPSend;

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
  TListDiffFormVIPSendForm = class(TAncestorDBGridForm)
    UnitName: TcxGridDBColumn;
    AmountSend: TcxGridDBColumn;
    UnitGuides: TdsdGuides;
    bbLabel: TdxBarControlContainerItem;
    bbGuides: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    Panel: TPanel;
    cxLabel4: TcxLabel;
    ceUnit: TcxButtonEdit;
    GoodsName: TcxGridDBColumn;
    UnitSendName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    isUrgently: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbInsertUpdate: TdxBarButton;
    FormParams: TdsdFormParams;
    isOrder: TcxGridDBColumn;
    DiffKindName: TcxGridDBColumn;
    actListDiffFormVIPSendRemain: TExecuteDialog;
    actSetDefaultParams: TdsdSetDefaultParams;
    actDataToJsonAction: TdsdDataToJsonAction;
    actExecSPCreateVIPSend: TdsdExecStoredProc;
    spCreateVIPSend: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TListDiffFormVIPSendForm)


end.