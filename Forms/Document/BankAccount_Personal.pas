unit BankAccount_Personal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, Vcl.DBActns;

type
  TBankAccount_PersonalForm = class(TAncestorDocumentForm)
    INN: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    Comment: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    edServiceDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel12: TcxLabel;
    edPersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
    cxLabel3: TcxLabel;
    UnitCode: TcxGridDBColumn;
    PersonalCode: TcxGridDBColumn;
    isMain: TcxGridDBColumn;
    isOfficial: TcxGridDBColumn;
    edDocumentPersonalService: TcxButtonEdit;
    GuidesPersonalServiceJournal: TdsdGuides;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    edBankAccount: TcxButtonEdit;
    GuidesBankAccount: TdsdGuides;
    spInsertUpdateMIAmount: TdsdStoredProc;
    SummCard: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    actRefreshMaster: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccount_PersonalForm);

end.
