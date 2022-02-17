unit ChoiceListDiff;

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
  TChoiceListDiffForm = class(TAncestorBaseForm)
    ListDiffGrid: TcxGrid;
    ListDiffGridDBTableView: TcxGridDBTableView;
    ListDiffGridLevel: TcxGridLevel;
    ListDiffDS: TDataSource;
    colMaxOrderAmount: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    Panel1: TPanel;
    bbCancel: TcxButton;
    bbOk: TcxButton;
    Panel2: TPanel;
    Label6: TLabel;
    Label1: TLabel;
    colPackages: TcxGridDBColumn;
    procedure ListDiffGridDBTableViewDblClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  function ChoiceListDiffExecute(ADiffKindCDS: TClientDataSet; var ADiffKindId : integer) : boolean;

  var ChoiceListDiffForm : TChoiceListDiffForm;

implementation

{$R *.dfm}

uses ListDiffAddGoods, CommonData;


function ChoiceListDiffExecute(ADiffKindCDS: TClientDataSet; var ADiffKindId : integer) : boolean;
begin
  Result := False;
  ADiffKindId := 0;
  if not ADiffKindCDS.Active then Exit;
  if ADiffKindCDS.RecordCount < 1 then Exit;

  ChoiceListDiffForm := TChoiceListDiffForm.Create(Application);
  try
    Begin
      try
        ChoiceListDiffForm.ListDiffDS.DataSet := ADiffKindCDS;
        Result := ChoiceListDiffForm.ShowModal = mrOK;
        if Result and (ADiffKindCDS.RecordCount > 0) then
        begin
          ADiffKindId := ADiffKindCDS.FieldByName('Id').AsInteger;
        end else Result := False;
      Except ON E: Exception DO
        MessageDlg(E.Message,mtError,[mbOk],0);
      end;
    End
  finally
    ChoiceListDiffForm.Free;
  end;

end;

procedure TChoiceListDiffForm.ListDiffGridDBTableViewDblClick(
  Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

End.
