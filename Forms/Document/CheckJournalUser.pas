unit CheckJournalUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CheckJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxImageComboBox, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, dsdGuides, dsdDB, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxButtonEdit, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter, cxCheckBox;

type
  TCheckJournalUserForm = class(TCheckJournalForm)
    colTotalSummChangePercent: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckJournalUserForm: TCheckJournalUserForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TCheckJournalUserForm)

end.
