unit LoyaltySPList;

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
  TLoyaltySPListForm = class(TForm)
    LoyaltySPListGrid: TcxGrid;
    LoyaltySPListGridDBTableView: TcxGridDBTableView;
    LoyaltySPListGridLevel: TcxGridLevel;
    LoyaltySPListDS: TDataSource;
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
    ActionList: TActionList;
    actClose: TAction;
    dxBarButton4: TdxBarButton;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    procedure LoyaltySPListGridDBTableViewDblClick(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure LoyaltySPListGridDBTableViewKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
  end;

  function ShowLoyaltySPList : boolean;

implementation

{$R *.dfm}

uses CommonData;

procedure TLoyaltySPListForm.actCloseExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TLoyaltySPListForm.LoyaltySPListGridDBTableViewDblClick(
  Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TLoyaltySPListForm.LoyaltySPListGridDBTableViewKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    case Key of
      VK_RETURN : ModalResult := mrOk;
      VK_ESCAPE : ModalResult := mrCancel;
    end;
end;

procedure TLoyaltySPListForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult <> mrOk then Exit;
  if MainCashForm.LoyaltySPCDS.FieldByName('LoyaltySMID').AsInteger > 0 then Exit;

  if MessageDlg('Прикрепить покупателя '#13#10#13#10 + MainCashForm.LoyaltySPCDS.FieldByName('BuyerName').AsString +  '  ' +
                 MainCashForm.LoyaltySPCDS.FieldByName('BuyerPhone').AsString +
                 #13#10#13#10'к акции?', mtConfirmation, mbYesNo, 0) <> mrYes then Exit;

  MainCashForm.spInsertMovementItem.ParamByName('ioId').Value := 0;
  MainCashForm.spInsertMovementItem.ParamByName('inMovementId').Value := MainCashForm.LoyaltySPCDS.FieldByName('Id').AsInteger;
  MainCashForm.spInsertMovementItem.ParamByName('inBuyerID').Value := MainCashForm.LoyaltySPCDS.FieldByName('BuyerID').AsInteger;
  MainCashForm.spInsertMovementItem.Execute;

  if MainCashForm.spInsertMovementItem.ParamByName('ioId').Value <> 0 then
  begin
    MainCashForm.LoyaltySPCDS.Close;
    MainCashForm.LoyaltySPCDS.Open;
    if not MainCashForm.LoyaltySPCDS.Locate('LoyaltySMID', MainCashForm.spInsertMovementItem.ParamByName('ioId').Value, []) or
      (MainCashForm.LoyaltySPCDS.FieldByName('LoyaltySMID').AsInteger <> MainCashForm.spInsertMovementItem.ParamByName('ioId').Value) then
      MainCashForm.LoyaltySPCDS.Close;
  end else ShowMessage('Ошибка прикрепления покупателя к акции.'#13#10#13#10'Повторите попытку.');
end;

function ShowLoyaltySPList : boolean;
  var LoyaltySPListForm : TLoyaltySPListForm;
begin
  LoyaltySPListForm := TLoyaltySPListForm.Create(Screen.ActiveControl);
  try
    Result := LoyaltySPListForm.ShowModal = mrOk;
  finally
    LoyaltySPListForm.Free;
  end;
end;

End.
