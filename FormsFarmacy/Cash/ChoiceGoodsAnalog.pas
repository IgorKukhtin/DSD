unit ChoiceGoodsAnalog;

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
  TChoiceGoodsAnalogForm = class(TAncestorBaseForm)
    ChoiceGoodsGrid: TcxGrid;
    ChoiceGoodsDBTableView: TcxGridDBTableView;
    ChoiceGoodsLevel: TcxGridLevel;
    ChoiceGoodsDS: TDataSource;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    Panel1: TPanel;
    bbCancel: TcxButton;
    bbOk: TcxButton;
    ChoiceGoodsCDS: TClientDataSet;
    procedure ChoiceGoodsDBTableViewDblClick(Sender: TObject);
  private
    { Private declarations }
    FLast : Integer;
  public
  end;

  function ChoiceGoodsAnalogExecute(var AGoodsAnalogId : integer; var AGoodsAnalogName : string) : boolean;

  var ChoiceGoodsAnalogForm : TChoiceGoodsAnalogForm;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;


function ChoiceGoodsAnalogExecute(var AGoodsAnalogId : integer; var AGoodsAnalogName : string) : boolean;
begin
  Result := False;
  AGoodsAnalogId := 0;
  AGoodsAnalogName := '';

  if not FileExists(GoodsAnalog_lcl) then
  begin
    ShowMessage('—правочник аналогов не найден обратитесь к администратору...');
    Exit;
  end;

  if NOT Assigned(ChoiceGoodsAnalogForm) then
  begin
    ChoiceGoodsAnalogForm := TChoiceGoodsAnalogForm.Create(Application);
    ChoiceGoodsAnalogForm.FLast := 0;
  end;
  With ChoiceGoodsAnalogForm do
  Begin
    try
      try
        WaitForSingleObject(MutexGoodsAnalog, INFINITE); // только дл€ формы2;  защищаем так как есть в приложениее и сервисе
        try
          LoadLocalData(ChoiceGoodsCDS, GoodsAnalog_lcl);
          if not ChoiceGoodsCDS.Active then ChoiceGoodsCDS.Open;
          if FLast <> 0 then ChoiceGoodsCDS.Locate('Id', FLast, [])
        finally
          ReleaseMutex(MutexGoodsAnalog);
        end;

        if ChoiceGoodsCDS.RecordCount <= 0 then
        begin
          ShowMessage('—правочник аналогов пуст...');
          Exit;
        end;

        Result := ShowModal = mrOK;
        if Result then
        begin
          AGoodsAnalogId := ChoiceGoodsCDS.FieldByName('Id').AsInteger;
          FLast := ChoiceGoodsCDS.FieldByName('Id').AsInteger;
          AGoodsAnalogName := ChoiceGoodsCDS.FieldByName('Name').AsString;
        end;
      Except ON E: Exception DO
        MessageDlg(E.Message,mtError,[mbOk],0);
      end;
    finally
      ChoiceGoodsCDS.Close;
    end;
  End;
end;

procedure TChoiceGoodsAnalogForm.ChoiceGoodsDBTableViewDblClick(
  Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

End.
