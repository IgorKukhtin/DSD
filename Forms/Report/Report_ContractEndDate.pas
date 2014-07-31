unit Report_ContractEndDate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox,
  cxImageComboBox;

type
  TReport_ContractEndDateForm = class(TAncestorReportForm)
    clContractTagName: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clContractKindName: TcxGridDBColumn;
    clContractStateKindCode: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    clPersonalTradeName: TcxGridDBColumn;
    clAreaName: TcxGridDBColumn;
    clCode: TcxGridDBColumn;
    clInfoMoneyGroupCode: TcxGridDBColumn;
    clInvNumberArchive: TcxGridDBColumn;
    clStartDate: TcxGridDBColumn;
    clInvNumber: TcxGridDBColumn;
    clSigningDate: TcxGridDBColumn;
    clInfoMoneyDestinationCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clContractArticleName: TcxGridDBColumn;
    clJuridicalBasisName: TcxGridDBColumn;
    clBankAccountName: TcxGridDBColumn;
    clBankAccountExternal: TcxGridDBColumn;
    clBankName: TcxGridDBColumn;
    clInsertDate: TcxGridDBColumn;
    clUpdateDate: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
    clisStandart: TcxGridDBColumn;
    clisPersonal: TcxGridDBColumn;
    clisDefault: TcxGridDBColumn;
    ceinFlag: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_ContractEndDateForm);

end.
