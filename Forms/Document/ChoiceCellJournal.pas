unit ChoiceCellJournal;

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
  TChoiceCellJournalForm = class(TAncestorJournalForm)
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
    actRefreshGet: TdsdDataSetRefresh;
    cxLabel3: TcxLabel;
    GuidesUser: TdsdGuides;
    edUser: TcxButtonEdit;
    spInsertMI_Barcode: TdsdStoredProc;
    edBarCode: TcxTextEdit;
    cxLabel6: TcxLabel;
    EnterMoveNext: TEnterMoveNext;
    actInsertMI_Barcode: TdsdExecStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    spErasedMIMaster: TdsdStoredProc;
    actMISetErased: TdsdUpdateErased;
    actMISetUnErased: TdsdUpdateErased;
    bbMISetErased: TdxBarButton;
    bbMISetUnErased: TdxBarButton;
    MIProtocolOpenForm: TdsdOpenForm;
    bbMIProtocolOpenForm: TdxBarButton;
    spGet_User: TdsdStoredProc;
    spBarcode_null: TdsdStoredProc;
    isErased: TcxGridDBColumn;
    ChoiceCellName_search: TcxGridDBColumn;
    lbSearchName: TcxLabel;
    edSearchName: TcxTextEdit;
    FieldFilter_Name: TdsdFieldFilter;
    isChecked: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TChoiceCellJournalForm);
end.
