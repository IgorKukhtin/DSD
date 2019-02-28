unit ChoiceBankPOSTerminal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  dxSkinsdxBarPainter, dxBar, cxSpinEdit, dxBarExtItems, cxBarEditItem,
  cxBlobEdit, cxCheckBox;

type
  TChoiceBankPOSTerminalForm = class(TAncestorBaseForm)
    BankPOSTerminalGrid: TcxGrid;
    BankPOSTerminalGridDBTableView: TcxGridDBTableView;
    BankPOSTerminalGridLevel: TcxGridLevel;
    BankPOSTerminalDS: TDataSource;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    Panel1: TPanel;
    bbCancel: TcxButton;
    bbOk: TcxButton;
    procedure BankPOSTerminalGridDBTableViewDblClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  function ChoiceBankPOSTerminalExecute(var ABankPOSTerminal, APOSTerminalCode : integer) : boolean;

  var ChoiceBankPOSTerminalForm : TChoiceBankPOSTerminalForm;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;


function ChoiceBankPOSTerminalExecute(var ABankPOSTerminal, APOSTerminalCode : integer) : boolean;
begin
  Result := True;
  ABankPOSTerminal := 0;
  APOSTerminalCode := 0;
  if not MainCashForm.BankPOSTerminalCDS.Active then Exit;
  if MainCashForm.BankPOSTerminalCDS.RecordCount < 1 then Exit;
  if MainCashForm.BankPOSTerminalCDS.RecordCount = 1 then
  begin
    ABankPOSTerminal := MainCashForm.BankPOSTerminalCDS.FieldByName('Id').AsInteger;
    APOSTerminalCode := MainCashForm.BankPOSTerminalCDS.FieldByName('Code').AsInteger;
    Exit;
  end;

  if NOT assigned(ChoiceBankPOSTerminalForm) then
    ChoiceBankPOSTerminalForm := TChoiceBankPOSTerminalForm.Create(Application);
  With ChoiceBankPOSTerminalForm do
  Begin
    try
      if BankPOSTerminalDS.DataSet = Nil then BankPOSTerminalDS.DataSet := MainCashForm.BankPOSTerminalCDS;
      Result := ShowModal = mrOK;
      if Result then
      begin
        ABankPOSTerminal := MainCashForm.BankPOSTerminalCDS.FieldByName('Id').AsInteger;
        APOSTerminalCode := MainCashForm.BankPOSTerminalCDS.FieldByName('Code').AsInteger;
      end;
    Except ON E: Exception DO
      MessageDlg(E.Message,mtError,[mbOk],0);
    end;
  End;
end;

procedure TChoiceBankPOSTerminalForm.BankPOSTerminalGridDBTableViewDblClick(
  Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

End.
