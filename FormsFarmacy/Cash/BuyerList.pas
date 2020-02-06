unit BuyerList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, ParentForm,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  dxSkinsdxBarPainter, dxBar, cxSpinEdit, dxBarExtItems, cxBarEditItem,
  cxBlobEdit, cxCheckBox, cxNavigator, MainCash2, DataModul, EnterLoyaltySaveMoney,
  cxDataControllerConditionalFormattingRulesManagerDialog, System.Actions;

type
  TBuyerListForm = class(TForm)
    BuyerListDS: TDataSource;
    BarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarButton1: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    dxBarStatic1: TdxBarStatic;
    dxBarButton3: TdxBarButton;
    ActionList: TActionList;
    actChoice: TAction;
    dxBarButton4: TdxBarButton;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Phone: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    DateBirth: TcxGridDBColumn;
    Sex: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actClose: TAction;
    procedure actChoiceExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  function ShowBuyerList : boolean;

implementation

{$R *.dfm}

uses CommonData;

procedure TBuyerListForm.actChoiceExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TBuyerListForm.actCloseExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function ShowBuyerList : boolean;
  var BuyerListForm : TBuyerListForm;
begin
  BuyerListForm := TBuyerListForm.Create(Screen.ActiveControl);
  try
    Result := BuyerListForm.ShowModal = mrOk;
  finally
    BuyerListForm.Free;
  end;
end;

End.
