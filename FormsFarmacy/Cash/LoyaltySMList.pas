unit LoyaltySMList;

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
  cxBlobEdit, cxCheckBox, cxNavigator, MainCash2, DataModul,
  cxDataControllerConditionalFormattingRulesManagerDialog, System.Actions;

type
  TLoyaltySMListForm = class(TForm)
    LoyaltySMListGrid: TcxGrid;
    LoyaltySMListGridDBTableView: TcxGridDBTableView;
    LoyaltySMListGridLevel: TcxGridLevel;
    LoyaltySMListDS: TDataSource;
    Coment: TcxGridDBColumn;
    EndSale: TcxGridDBColumn;
    BarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarButton1: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    dxBarStatic1: TdxBarStatic;
    SummaRemainder: TcxGridDBColumn;
    EndPromo: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ActionList: TActionList;
    actChoice: TAction;
    actClose: TAction;
    procedure LoyaltySMListGridDBTableViewDblClick(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actChoiceExecute(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  function ShowLoyaltySMList : boolean;

implementation

{$R *.dfm}

uses CommonData;

procedure TLoyaltySMListForm.actChoiceExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TLoyaltySMListForm.actCloseExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TLoyaltySMListForm.LoyaltySMListGridDBTableViewDblClick(
  Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TLoyaltySMListForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult <> mrOk then Exit;
  if MainCashForm.LoyaltySMCDS.FieldByName('LoyaltySMID').AsInteger > 0 then Exit;

  if MessageDlg('Прикрепить покупателя '#13#10#13#10 + MainCashForm.LoyaltySMCDS.FieldByName('BuyerName').AsString +  '  ' +
                 MainCashForm.LoyaltySMCDS.FieldByName('BuyerPhone').AsString +
                 #13#10#13#10'к акции?', mtConfirmation, mbYesNo, 0) <> mrYes then Exit;

  MainCashForm.spInsertMovementItem.ParamByName('ioId').Value := 0;
  MainCashForm.spInsertMovementItem.ParamByName('inMovementId').Value := MainCashForm.LoyaltySMCDS.FieldByName('Id').AsInteger;
  MainCashForm.spInsertMovementItem.ParamByName('inBuyerID').Value := MainCashForm.LoyaltySMCDS.FieldByName('BuyerID').AsInteger;
  MainCashForm.spInsertMovementItem.Execute;

  if MainCashForm.spInsertMovementItem.ParamByName('ioId').Value <> 0 then
  begin
    MainCashForm.spLoyaltySM.ParamByName('inBuyerID').Value :=  MainCashForm.LoyaltySMCDS.FieldByName('BuyerID').AsInteger;
    MainCashForm.spLoyaltySM.Execute;
    if not MainCashForm.LoyaltySMCDS.Locate('LoyaltySMID', MainCashForm.spInsertMovementItem.ParamByName('ioId').Value, []) or
      (MainCashForm.LoyaltySMCDS.FieldByName('LoyaltySMID').AsInteger <> MainCashForm.spInsertMovementItem.ParamByName('ioId').Value) then
      MainCashForm.LoyaltySMCDS.Close;
  end else ShowMessage('Ошибка прикрепления покупателя к акции.'#13#10#13#10'Повторите попытку.');
end;

function ShowLoyaltySMList : boolean;
  var LoyaltySMListForm : TLoyaltySMListForm;
begin
  LoyaltySMListForm := TLoyaltySMListForm.Create(Screen.ActiveControl);
  try
    Result := LoyaltySMListForm.ShowModal = mrOk;
  finally
    LoyaltySMListForm.Free;
  end;
end;

End.
