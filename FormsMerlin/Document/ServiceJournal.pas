unit ServiceJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus,
  dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns,
  cxButtonEdit, dsdGuides, ExternalLoad;

type
  TServiceJournalForm = class(TAncestorJournalForm)
    InfoMoneyName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    bbAddBonus: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    bbisCopy: TdxBarButton;
    UnitCode: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    actUpdateDataSet: TdsdUpdateDataSet;
    actRefreshStart: TdsdDataSetRefresh;
    bbUpdateMoneyPlace: TdxBarButton;
    isAuto: TcxGridDBColumn;
    spGetImportSettingId: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    macStartLoad: TMultiAction;
    bbmacStartLoad: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TServiceJournalForm);

end.
