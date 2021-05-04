unit ChoiceHelsiUserName;

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
  cxBlobEdit, cxCheckBox, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, System.Actions,
  dxDateRanges;

type
  TChoiceHelsiUserNameForm = class(TAncestorBaseForm)
    BankPOSTerminalGrid: TcxGrid;
    BankPOSTerminalGridDBTableView: TcxGridDBTableView;
    BankPOSTerminalGridLevel: TcxGridLevel;
    ChoiceHelsiUserNamelDS: TDataSource;
    colName: TcxGridDBColumn;
    Panel1: TPanel;
    bbCancel: TcxButton;
    bbOk: TcxButton;
    procedure BankPOSTerminalGridDBTableViewDblClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  function ChoiceHelsiUserNameExecute(ADS : TClientDataSet) : boolean;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData;


function ChoiceHelsiUserNameExecute(ADS : TClientDataSet) : boolean;
  var ChoiceHelsiUserNameForm : TChoiceHelsiUserNameForm;
begin
  Result := True;

  ChoiceHelsiUserNameForm := TChoiceHelsiUserNameForm.Create(Application);
  With ChoiceHelsiUserNameForm do
  try
    try
      ChoiceHelsiUserNamelDS.DataSet := ADS;
      Result := ShowModal = mrOK;
    Except ON E: Exception DO
      MessageDlg(E.Message,mtError,[mbOk],0);
    end;
  finally
    ChoiceHelsiUserNameForm.Free;
  end;

end;

procedure TChoiceHelsiUserNameForm.BankPOSTerminalGridDBTableViewDblClick(
  Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

End.
