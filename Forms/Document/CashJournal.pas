unit CashJournal;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit, dsdGuides,
  cxButtonEdit;

type
  TCashJournalForm = class(TAncestorJournalForm)
    clAmountOut: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
    clContractInvNumber: TcxGridDBColumn;
    clMoneyPlaceCode: TcxGridDBColumn;
    ceCash: TcxButtonEdit;
    cxLabel3: TcxLabel;
    CashGuides: TdsdGuides;
    clInfoMoneyName_all: TcxGridDBColumn;
    clMemberName: TcxGridDBColumn;
    clPositionName: TcxGridDBColumn;
    clItemName: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    clAmountCurrency: TcxGridDBColumn;
    clAmountSumm: TcxGridDBColumn;
    clCurrencyName: TcxGridDBColumn;
    clCurrencyPartnerValue: TcxGridDBColumn;
    clParPartnerValue: TcxGridDBColumn;
    clCurrencyValue: TcxGridDBColumn;
    clParValue: TcxGridDBColumn;
    isLoad: TcxGridDBColumn;
    actReport_Cash: TdsdOpenForm;
    bbReport_Cash: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCashJournalForm);

end.
