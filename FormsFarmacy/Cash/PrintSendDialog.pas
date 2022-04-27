unit PrintSendDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, dsdAction, cxClasses,
  cxPropertiesStore, dsdAddOn, dsdDB, dxSkinsCore, CashInterface,
  dxSkinsDefaultPainters, Data.DB, Datasnap.DBClient, System.Actions;

type
  TPrintSendDialogForm = class(TParentForm)
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    ActionList1: TActionList;
    mactPrint: TMultiAction;
    acttRefresh: TdsdDataSetRefresh;
    FormParams: TdsdFormParams;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
  private
    FCash: ICash;
    FSummaTotal: Currency;
    FPaidTypeTemp : integer;
    FSalerCash: Currency;
    FBankPOSTerminal: Integer;
    FPOSTerminalCode: Integer;
    SoldParallel: Boolean;
    { Private declarations }
  public
    { Public declarations }
    function PutSendToCash : boolean;

    property Cash: ICash read FCash;
  end;

implementation

{$R *.dfm}

uses DataModul, Math, UnitGetCash;


procedure TPrintSendDialogForm.TimerTimer(Sender: TObject);
begin
  inherited;
  Timer.Enabled := False;

  try
    FCash := GetCash;

    if not Assigned(FCash) then
    begin
      ShowMessage('�������� ������ �� ���������. ������ ����������.');
      Exit;
    end;

    if PrintItemsCDS.IsEmpty or PrintHeaderCDS.IsEmpty then
    begin
      ShowMessage('��� ������ ��� ������.');
      Exit;
    end;

    if Assigned(Cash) then PutSendToCash;

  finally
    Close;
  end;
end;

function TPrintSendDialogForm.PutSendToCash : boolean;
var
  ACheckNumber: String;

  { ------------------------------------------------------------------------------ }
  function PutOneRecordToCash: Boolean; // ������� ������ ������������
  begin
    // �������� ������ � ����� � ���� ��� OK, �� ������ ����� � �������
    with PrintItemsCDS do
    begin

      Result := Cash.SoldFromPC(FieldByName('GoodsCode').AsInteger,
        FieldByName('GoodsCode').AsString + ' ' + FieldByName('GoodsName').Text, '',
        FieldByName('Amount').asCurrency, 0, 0);
      Cash.PrintFiscalText(FormatDateTime('DD.MM.YYYY', FieldByName('MinExpirationDate').AsDateTime) + '   ' +
        FieldByName('AccommodationName').AsString);
    end;
  end;

{ ------------------------------------------------------------------------------ }
begin
  Result := False;
  try
    try

      // ��������������� ������ ����
      Result := Cash.OpenReceipt(False, False);

      Cash.PrintFiscalText('����������� �' + PrintHeaderCDS.FieldByName('InvNumber').AsString + ' �� ' +
                           FormatDateTime('DD.MM.YYYY', PrintHeaderCDS.FieldByName('OperDate').AsDateTime));
      Cash.PrintFiscalText('�����������: ' + PrintHeaderCDS.FieldByName('FromName').AsString);
      Cash.PrintFiscalText('����������: ' + PrintHeaderCDS.FieldByName('ToName').AsString);

      with PrintItemsCDS do
      begin
        First;
        while not Eof do
        begin
          // ������� ������ � �����
          Result := PutOneRecordToCash;

          Next;
        end;
      end;

      Cash.SoldFromPC(0, '����� ���������� ������:', '',
        PrintHeaderCDS.FieldByName('TotalCount').asCurrency, 0, 0);

      Result := Cash.CloseReceiptEx(ACheckNumber); // ������� ���
    except
      Result := false;
    end;
  finally
    Cash.AlwaysSold := False;
  end;

end;

initialization
  RegisterClass(TPrintSendDialogForm);

end.
