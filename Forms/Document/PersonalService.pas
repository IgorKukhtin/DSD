unit PersonalService;

interface

uses
  AncestorJournal, DataModul, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxImageComboBox,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, System.Classes, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, Vcl.Controls, cxCheckBox, dsdGuides, cxButtonEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TPersonalServiceForm = class(TAncestorJournalForm)
    colPersonalName: TcxGridDBColumn;
    deServiceDate: TcxDateEdit;
    spInsertUpdate: TdsdStoredProc;
    colComment: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    cePaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    UpdateDataSet: TdsdUpdateDataSet;
    spGet: TdsdStoredProc;
    cxLabel5: TcxLabel;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    edInDescName: TcxTextEdit;
    inServDate: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TPersonalServiceForm);

end.
