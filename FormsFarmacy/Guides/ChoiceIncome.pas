unit ChoiceIncome;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxContainer, cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel,
  dsdGuides, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit;

type
  TChoiceIncomeForm = class(TAncestorEnumForm)
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSummMVAT: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    actUpdate: TdsdInsertUpdateAction;
    dxBarButton1: TdxBarButton;
    TotalSumm: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    Panel: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    ExecuteDialog: TExecuteDialog;
    dxBarButton2: TdxBarButton;
    FromName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TChoiceIncomeForm);

end.
