unit Report_OrderExternal_MIChild_Detail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  dsdGuides, cxButtonEdit;

type
  TReport_OrderExternal_MIChild_DetailForm = class(TAncestorJournalForm)
    FromName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCountSh: TcxGridDBColumn;
    TotalCountKg: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    bbSelect: TdxBarButton;
    cxLabel6: TcxLabel;
    edTo: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    Comment: TcxGridDBColumn;
    OperDate_CarInfo: TcxGridDBColumn;
    DayOfWeekName: TcxGridDBColumn;
    DayOfWeekName_Partner: TcxGridDBColumn;
    DayOfWeekName_CarInfo: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    cxLabel4: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    GuidesGoodsKind: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_OrderExternal_MIChild_DetailForm: TReport_OrderExternal_MIChild_DetailForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_OrderExternal_MIChild_DetailForm);
end.
