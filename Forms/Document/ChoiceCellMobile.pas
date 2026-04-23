unit ChoiceCellMobile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TChoiceCellMobileForm = class(TAncestorJournalForm)
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    actShowMessage: TShowMessageAction;
    actRefreshStart: TdsdDataSetRefresh;
    ChoiceCellName: TcxGridDBColumn;
    ChoiceCellCode: TcxGridDBColumn;
    actMISetErased: TdsdUpdateErased;
    actMISetUnErased: TdsdUpdateErased;
    bbMISetErased: TdxBarButton;
    bbMISetUnErased: TdxBarButton;
    MIProtocolOpenForm: TdsdOpenForm;
    bbMIProtocolOpenForm: TdxBarButton;
    isErased: TcxGridDBColumn;
    ChoiceCellName_search: TcxGridDBColumn;
    lbSearchName: TcxLabel;
    edSearchName: TcxTextEdit;
    FieldFilter_Name: TdsdFieldFilter;
    ceLimit: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edFilter: TcxTextEdit;
    cxLabel16: TcxLabel;
    cbIsOrderBy: TcxCheckBox;
    cbIsAllUser: TcxCheckBox;
    ErasedCode: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TChoiceCellMobileForm);
end.
