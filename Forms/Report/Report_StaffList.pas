unit Report_StaffList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxCheckBox, dsdGuides, cxButtonEdit,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TReport_StaffListForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    ceUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    cxLabel3: TcxLabel;
    ceModelService: TcxButtonEdit;
    GuidesModelService: TdsdGuides;
    cxLabel5: TcxLabel;
    cePosition: TcxButtonEdit;
    GuidesPosition: TdsdGuides;
    UnitName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    PositionLevelName: TcxGridDBColumn;
    ServiceModelName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    ModelServiceItemChild_FromName: TcxGridDBColumn;
    ModelServiceItemChild_ToName: TcxGridDBColumn;
    actPrint1: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    actPrint2: TdsdPrintAction;
    dxBarButton2: TdxBarButton;
    StaffListCode: TcxGridDBColumn;
    StaffListName: TcxGridDBColumn;
    PriceName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    spPersonalService: TdsdStoredProc;
    actPersonalService: TdsdExecStoredProc;
    macPersonalService: TMultiAction;
    DocumentKindName: TcxGridDBColumn;
    bbPersonalService: TdxBarButton;
    GoodsKind_FromName: TcxGridDBColumn;
    GoodsKindComplete_FromName: TcxGridDBColumn;
    GoodsKind_ToName: TcxGridDBColumn;
    GoodsKindComplete_ToName: TcxGridDBColumn;
    StorageLineName_From: TcxGridDBColumn;
    StorageLineName_To: TcxGridDBColumn;
    spPersonalServiceErased: TdsdStoredProc;
    macPersonalServiceErased: TMultiAction;
    macPersonalServiceAll: TMultiAction;
    actPersonalServiceErased: TdsdExecStoredProc;
    StaffListSummKindName: TcxGridDBColumn;
    UpdateName_ModelServiceItemChild: TcxGridDBColumn;
    UpdateDate_ModelServiceItemChild: TcxGridDBColumn;
    UpdateName_StaffListCost: TcxGridDBColumn;
    UpdateDate_StaffListCost: TcxGridDBColumn;
    Value_StaffListSummKind: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_StaffListForm);
end.
