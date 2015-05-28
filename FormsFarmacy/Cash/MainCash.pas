unit MainCash;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorBase, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Vcl.ExtCtrls, cxSplitter, dsdDB, Datasnap.DBClient, cxContainer,
  cxTextEdit, cxCurrencyEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, Vcl.Menus, cxCheckBox, Vcl.StdCtrls,
  cxButtons;

type
  TMainCashForm = class(TAncestorBaseForm)
    MainGridDBTableView: TcxGridDBTableView;
    MainGridLevel: TcxGridLevel;
    MainGrid: TcxGrid;
    BottomPanel: TPanel;
    CheckGridDBTableView: TcxGridDBTableView;
    CheckGridLevel: TcxGridLevel;
    CheckGrid: TcxGrid;
    AlternativeGridDBTableView: TcxGridDBTableView;
    AlternativeGridLevel: TcxGridLevel;
    AlternativeGrid: TcxGrid;
    cxSplitter1: TcxSplitter;
    SearchPanel: TPanel;
    cxSplitter2: TcxSplitter;
    MainPanel: TPanel;
    CheckGridColCode: TcxGridDBColumn;
    CheckGridColName: TcxGridDBColumn;
    CheckGridColPrice: TcxGridDBColumn;
    CheckGridColAmount: TcxGridDBColumn;
    CheckGridColSumm: TcxGridDBColumn;
    AlternativeGridColCode: TcxGridDBColumn;
    AlternativeGridColName: TcxGridDBColumn;
    MainColCode: TcxGridDBColumn;
    MainColName: TcxGridDBColumn;
    MainColRemains: TcxGridDBColumn;
    MainColPrice: TcxGridDBColumn;
    MainColReserved: TcxGridDBColumn;
    dsdDBViewAddOnMain: TdsdDBViewAddOn;
    spSelectRemains: TdsdStoredProc;
    RemainsDS: TDataSource;
    RemainsCDS: TClientDataSet;
    ceAmount: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    lcName: TcxLookupComboBox;
    actChoiceGoodsInRemainsGrid: TAction;
    actSold: TAction;
    PopupMenu: TPopupMenu;
    actSold1: TMenuItem;
    N1: TMenuItem;
    spNewCheck: TdsdStoredProc;
    FormParams: TdsdFormParams;
    cbSpec: TcxCheckBox;
    actCheck: TdsdOpenForm;
    cxButton1: TcxButton;
    actInsertUpdateCheckItems: TAction;
    spGoodsRemains: TdsdStoredProc;
    spSelectCheck: TdsdStoredProc;
    CheckDS: TDataSource;
    CheckCDS: TClientDataSet;
    spInsertUpdateCheckItems: TdsdStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure actChoiceGoodsInRemainsGridExecute(Sender: TObject);
    procedure lcNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actSoldExecute(Sender: TObject);
    procedure actInsertUpdateCheckItemsExecute(Sender: TObject);
    procedure ceAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FSoldRegim: boolean;
    procedure SetSoldRegim(const Value: boolean);
    // возвращает остаток
    function GetGoodsPropertyRemains(GoodsId: integer): real;
    // процедура обновляет параметры для введения нового чека
    procedure NewCheck;
    // Изменение тела чека
    procedure InsertUpdateBillCheckItems;
    // Расчет актуального остатка по позиции
    procedure UpdateQuantityInQuery(GoodsId: integer);

    property SoldRegim: boolean read FSoldRegim write SetSoldRegim;
  public
    { Public declarations }
  end;

var
  MainCashForm: TMainCashForm;

implementation

{$R *.dfm}
procedure TMainCashForm.actChoiceGoodsInRemainsGridExecute(Sender: TObject);
begin
  if RemainsCDS.FieldByName('Remains').AsFloat>0 then begin
     lcName.Text := RemainsCDS.FieldByName('GoodsName').Text;
     ceAmount.Enabled := true;
     ceAmount.Value := 1;
     ActiveControl := ceAmount;
  end;
end;

procedure TMainCashForm.actInsertUpdateCheckItemsExecute(Sender: TObject);
begin
  if ceAmount.Value <> 0 then begin //ЕСЛИ введенное кол-во 0 то просто переходим к следующему коду
    if RemainsCDS.FieldByName('Price').AsFloat = 0 then begin
       ShowMessage('Нельзя продать товар с 0 ценой! Свяжитесь с менеджером');
       exit;
    end;
    InsertUpdateBillCheckItems;
  end;
  SoldRegim := true;
  ActiveControl := lcName;
end;

procedure TMainCashForm.actSoldExecute(Sender: TObject);
begin
  SoldRegim:= not SoldRegim;
  ceAmount.Enabled := false;
  lcName.Text := '';
  Activecontrol := lcName;
end;

procedure TMainCashForm.ceAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then
     actInsertUpdateCheckItems.Execute
end;

procedure TMainCashForm.FormCreate(Sender: TObject);
begin
  inherited;
  UserSettingsStorageAddOn.LoadUserSettings;
  NewCheck;
end;

function TMainCashForm.GetGoodsPropertyRemains(GoodsId: integer): real;
begin
  spGoodsRemains.ParamByName('inGoodsId').Value := GoodsId;
  spGoodsRemains.Execute;
  result := spGoodsRemains.ParamByName('outRemains').asFloat;
end;

procedure TMainCashForm.InsertUpdateBillCheckItems;
begin
  if ceAmount.Value = 0 then
     exit;
  if SoldRegim
     and (ceAmount.Value > GetGoodsPropertyRemains(RemainsCDS.FieldByName('Id').asInteger)) then
  begin
    ShowMessage('Не хватает количества для продажи!');
    exit;
  end;
  if (not SoldRegim) and
     (abs(ceAmount.Value) > abs(CheckCDS.FieldByName('Amount').asFloat)) then
  begin
      ShowMessage('Не хватает количества для возврата!');
  end;
  with spInsertUpdateCheckItems do begin
     ParamByName('inAmount').Value := ceAmount.Value;
     ParamByName('inPrice').Value := RemainsCDS.FieldByName('Price').asFloat;
     if ceAmount.Value > 0 then
        ParamByName('inGoodsId').Value := RemainsCDS.FieldByName('Id').asInteger
     else
        ParamByName('inGoodsId').Value := CheckCDS.FieldByName('GoodsId').asInteger;
     Execute;
     spSelectCheck.Execute;
//     CalcTotalSumm;// Пересчитали значение Суммы в TotalPanel
     UpdateQuantityInQuery(ParamByName('inGoodsId').Value);
  end;
end;

{------------------------------------------------------------------------------}
procedure TMainCashForm.UpdateQuantityInQuery(GoodsId: integer);
begin
  if RemainsCDS.Locate('Id', GoodsId, []) then begin
     RemainsCDS.Edit;
     RemainsCDS.FieldByName('Remains').AsFloat := GetGoodsPropertyRemains(GoodsId);
     RemainsCDS.Post;
  end;
end;

procedure TMainCashForm.lcNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_Return) and (ceAmount.Enabled) then begin
     if SoldRegim then
        ceAmount.Value := 1
     else
        ceAmount.Value := - 1;
     ActiveControl := ceAmount;
  end;
  if (Key=VK_Tab) then
     ActiveControl := MainGrid
end;

// процедура обновляет параметры для введения нового чека
procedure TMainCashForm.NewCheck;
begin
  SoldRegim := true;
  cbSpec.Checked := false;
  spNewCheck.Execute;
  actRefresh.Execute;
  ceAmount.Value := 0;
  ceAmount.Enabled := true;
end;

procedure TMainCashForm.SetSoldRegim(const Value: boolean);
begin
  FSoldRegim := Value;
  if SoldRegim then begin
     actSold.Caption := 'Продажа';
     ceAmount.Value := 1;
  end
  else begin
     actSold.Caption := 'Возврат';
     ceAmount.Value := -1;
  end;
end;

initialization
  RegisterClass(TMainCashForm)

end.
