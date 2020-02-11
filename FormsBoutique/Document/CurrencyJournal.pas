unit CurrencyJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCheckBox, cxImageComboBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, ExternalLoad;

type
  TCurrencyJournalForm = class(TAncestorJournalForm)
    clComment: TcxGridDBColumn;
    N13: TMenuItem;
    clParValue: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    actRefreshStart: TdsdDataSetRefresh;
    colEndDate: TcxGridDBColumn;
    spGetImportSettingDopId: TdsdStoredProc;
    actGetImportSettingDop: TdsdExecStoredProc;
    actDoLoadDop: TExecuteImportSettingsAction;
    macStartLoadDop: TMultiAction;
    bbStartLoadDop: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCurrencyJournalForm);

end.
