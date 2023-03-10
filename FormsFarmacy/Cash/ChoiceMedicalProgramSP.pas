unit ChoiceMedicalProgramSP;

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
  cxBlobEdit, cxCheckBox, cxNavigator, dxDateRanges, System.Actions;

type
  TChoiceMedicalProgramSPForm = class(TAncestorBaseForm)
    BankPOSTerminalGrid: TcxGrid;
    BankPOSTerminalGridDBTableView: TcxGridDBTableView;
    BankPOSTerminalGridLevel: TcxGridLevel;
    MedicalProgramSPDS: TDataSource;
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

  function ChoiceMedicalProgramSPExecute : boolean;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;


function ChoiceMedicalProgramSPExecute : boolean;
  var ChoiceMedicalProgramSPForm : TChoiceMedicalProgramSPForm;
begin
  ChoiceMedicalProgramSPForm := TChoiceMedicalProgramSPForm.Create(Application);
  try
    With ChoiceMedicalProgramSPForm do
    Begin
      try
        if MedicalProgramSPDS.DataSet = Nil then MedicalProgramSPDS.DataSet := MainCashForm.MedicalProgramSPCDS;
        Result := ShowModal = mrOK;
      Except ON E: Exception DO
        MessageDlg(E.Message,mtError,[mbOk],0);
      end;
    End;
  finally
    ChoiceMedicalProgramSPForm.Free;
  end;
end;

procedure TChoiceMedicalProgramSPForm.BankPOSTerminalGridDBTableViewDblClick(
  Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

End.
