unit CashCloseReturnDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, dsdAction, cxClasses,
  cxPropertiesStore, dsdAddOn, CashInterface, AncestorBase, dsdDB, dxSkinsCore,
  dxSkinsDefaultPainters, System.Actions, Data.DB, Datasnap.DBClient;

type
  TCashCloseReturnDialogForm = class(TAncestorDialogForm)
    cxGroupBox1: TcxGroupBox;
    edSalerCash: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    lblTotalSumma: TcxLabel;
    lblSdacha: TcxLabel;
    rgPaidType: TcxRadioGroup;
    cxGroupBox2: TcxGroupBox;
    edSalerCashAdd: TcxCurrencyEdit;
    spGet_Movement: TdsdStoredProc;
    actShow: TAction;
    MasterCDS: TClientDataSet;
    spSelect: TdsdStoredProc;
    actPrintReceipt: TAction;
    spComplete_Movement: TdsdStoredProc;
    procedure edSalerCashPropertiesChange(Sender: TObject);
    procedure ParentFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actShowExecute(Sender: TObject);
    procedure actPrintReceiptExecute(Sender: TObject);
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
    function PutCheckToCash(SalerCash, SalerCashAdd: Currency;
      PaidType: TPaidType; out AFiscalNumber, ACheckNumber, ARRN: String;
      out AZReport : Integer;
      APOSTerminalCode: Integer = 0; isFiscal: Boolean = True): Boolean;
    procedure Add_Log_XML(AMessage: String);

    property Cash: ICash read FCash;
  end;

var
  CashCloseReturnDialogForm: TCashCloseReturnDialogForm;

implementation

{$R *.dfm}

uses DataModul, Math, ChoiceBankPOSTerminal, MainCash2, IniUtils, PosInterface,
     PosFactory, PayPosTermProcess;


procedure TCashCloseReturnDialogForm.edSalerCashPropertiesChange(Sender: TObject);
var
  tmpVal: Currency;
begin
  if FPaidTypeTemp <> rgPaidType.ItemIndex then
  begin
    cxGroupBox2.Visible := rgPaidType.ItemIndex = 2;
    edSalerCash.Value := FSummaTotal;
    edSalerCash.Properties.ReadOnly := rgPaidType.ItemIndex = 1;
    edSalerCashAdd.Text := '';
    if rgPaidType.ItemIndex = 0 then
      cxGroupBox1.Caption := '����� �� ����������'
    else cxGroupBox1.Caption := '����� �� ���������� �� �����';
    FPaidTypeTemp := rgPaidType.ItemIndex;
  end;

  if (RoundTo(FSalerCash - edSalerCash.Value, -2) <> 0) and (rgPaidType.ItemIndex = 2) then
  begin
    if FSummaTotal > edSalerCash.Value then
      edSalerCashAdd.Value := FSummaTotal - edSalerCash.Value
    else edSalerCashAdd.Text := '';
  end;

  FSalerCash := edSalerCash.Value;
  tmpVal := edSalerCash.Value + edSalerCashAdd.Value;
  bbOk.Enabled := ((tmpVal - FSummaTotal)>=0) and
    ((rgPaidType.ItemIndex <> 2) or (RoundTo(edSalerCash.Value - FSummaTotal, -2) < 0));
  if FSummaTotal <= tmpVal then
    lblSdacha.Caption := FormatCurr('0.00',tmpVal - FSummaTotal)
  else
    lblSdacha.Caption := '���';
end;

procedure TCashCloseReturnDialogForm.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DIVIDE then
    rgPaidType.ItemIndex := 0
  else
  if Key = VK_MULTIPLY then
  begin
    if rgPaidType.ItemIndex <> 1 then
      rgPaidType.ItemIndex := 1
    else rgPaidType.ItemIndex := 2;
  end;
end;

procedure TCashCloseReturnDialogForm.actPrintReceiptExecute(Sender: TObject);
  var cFiscalNumber, cCheckNumber, cRRN: String; nZReport : Integer;
begin
  inherited;

  if (rgPaidType.ItemIndex > 0) then
  begin
    if not ChoiceBankPOSTerminalExecute(FBankPOSTerminal, FPOSTerminalCode) then Exit;
  end;

  if not PutCheckToCash(FSummaTotal, edSalerCashAdd.Value,
    TPaidType(rgPaidType.ItemIndex), cFiscalNumber, cCheckNumber, cRRN, nZReport, FPOSTerminalCode) then Exit;

  // ���������� ����
  try
    spComplete_Movement.ParamByName('inMovementId').Value := FormParams.ParamByName('Id').Value;
    spComplete_Movement.ParamByName('inPaidType').Value := rgPaidType.ItemIndex;
    if Assigned(FCash) then
    begin
      spComplete_Movement.ParamByName('inCashRegister').Value := cFiscalNumber;
      spComplete_Movement.ParamByName('inZReport').Value := nZReport;
    end else
    begin
      spComplete_Movement.ParamByName('inCashRegister').Value := '';
      spComplete_Movement.ParamByName('inZReport').Value := 0;
    end;
    spComplete_Movement.ParamByName('inFiscalCheckNumber').Value := cCheckNumber;
    if rgPaidType.ItemIndex = 2 then
      spComplete_Movement.ParamByName('inTotalSummPayAdd').Value := edSalerCashAdd.Value
    else spComplete_Movement.ParamByName('inTotalSummPayAdd').Value := 0;
    spComplete_Movement.ParamByName('inRRN').Value := cRRN;
    spComplete_Movement.Execute;
  Except ON E: Exception DO
    MessageDlg(E.Message,mtError,[mbOk],0);
  end;

  ModalResult := mrOk;
end;

procedure TCashCloseReturnDialogForm.actShowExecute(Sender: TObject);
begin
  inherited;
    try
      FSummaTotal := spGet_Movement.ParamByName('outSummaTotal').AsFloat;
      FPaidTypeTemp := -1;
      lblTotalSumma.Caption := FormatCurr('0.00',FSummaTotal);
      edSalerCash.Value := FSummaTotal;
      rgPaidType.ItemIndex := spGet_Movement.ParamByName('outPaidType').Value - 1;
      FBankPOSTerminal:=0;
      FPOSTerminalCode:= 0;
      ActiveControl := edSalerCash;
      edSalerCash.SelectAll;
      SoldParallel := iniSoldParallel;
      FCash := MainCashForm.GetCash;
    Except ON E: Exception DO
      MessageDlg(E.Message,mtError,[mbOk],0);
    end;
end;

// ��� � �������� ������ - ������� � ��� ��� - �� ����� �������� ���� ����� ����
procedure TCashCloseReturnDialogForm.Add_Log_XML(AMessage: String);
var
  F: TextFile;
begin
  try
    AssignFile(F, ChangeFileExt(Application.ExeName, '_log.xml'));
    if not fileExists(ChangeFileExt(Application.ExeName, '_log.xml')) then
    begin
      Rewrite(F);
      Writeln(F, '<?xml version="1.0" encoding="Windows-1251"?>');
    end
    else
      Append(F);
    //
    try
      Writeln(F, AMessage);
    finally
      CloseFile(F);
    end;
  except
  end;
end;

function TCashCloseReturnDialogForm.PutCheckToCash(SalerCash, SalerCashAdd: Currency;
  PaidType: TPaidType; out AFiscalNumber, ACheckNumber, ARRN: String;
  out AZReport : Integer;
  APOSTerminalCode: Integer = 0; isFiscal: Boolean = True): Boolean;
var
  str_log_xml, cTextCheck: String;
  Disc, nSumAll: Currency;
  I, PosDisc: Integer;
  pPosTerm: IPos;
  { ------------------------------------------------------------------------------ }
  function PutOneRecordToCash: Boolean; // ������� ������ ������������
  var
    �AccommodationName: string;
  begin
    // �������� ������ � ����� � ���� ��� OK, �� ������ ����� � �������
    if not Assigned(Cash) or Cash.AlwaysSold then
      Result := True
    else if not SoldParallel then
      with MasterCDS do
      begin
        if isFiscal or FieldByName('AccommodationName').IsNull then
          �AccommodationName := ''
        else
          �AccommodationName := ' ' + FieldByName('AccommodationName').Text;

        Result := Cash.SoldFromPC(FieldByName('GoodsCode').AsInteger,
          AnsiUpperCase(FieldByName('GoodsName').Text + �AccommodationName),
          FieldByName('UKTZED').AsString,
          FieldByName('Amount').asCurrency, FieldByName('Price').asCurrency,
          FieldByName('NDS').asCurrency);
      end
    else
      Result := True;
  end;

{ ------------------------------------------------------------------------------ }
begin
  ACheckNumber := '';
  cTextCheck := '';
  AZReport := 0;
  ARRN := '';

  try
    try
      if Assigned(Cash) AND NOT Cash.AlwaysSold and isFiscal then
        AFiscalNumber := Cash.FiscalNumber
      else
        AFiscalNumber := '';
      Disc := 0;
      PosDisc := 0;

      if not isFiscal and Assigned(Cash) then
        Cash.AlwaysSold := false;

      // �������� ���� �� ������
      nSumAll := 0;
      with MasterCDS do
      begin
        // ��������� ����� ����
        First;
        while not Eof do
        begin
          Disc := Disc + (FieldByName('Summ').asCurrency -
            GetSummFull(FieldByName('Amount').asCurrency,
            FieldByName('Price').asCurrency));
          nSumAll := nSumAll + FieldByName('Summ').asCurrency;
          Next;
        end;

        // ���� ���� ������ ������� ����� � ������ ������ ������
        if Disc < 0 then
        begin
          Last;
          while not BOF do
          begin
            if (GetSummFull(FieldByName('Amount').asCurrency,
              FieldByName('Price').asCurrency) + Disc) > 0 then
            begin
              PosDisc := RecNo;
              Break;
            end;
            Prior;
          end;

          // ���� ���� ������ � ��� ������ � ������ ������ ������ �� ���� ����� ������ ������
          if (Disc < 0) and (PosDisc = 0) then
          begin
            Last;
            while not BOF do
            begin
              if (GetSummFull(FieldByName('Amount').asCurrency,
                FieldByName('Price').asCurrency) + Disc) >= 0 then
              begin
                PosDisc := RecNo;
                Break;
              end;
              Prior;
            end;
          end;
        end
        else if Disc > 0 then
        begin
          Last;
          while not BOF do
          begin
            if GetSummFull(FieldByName('Amount').asCurrency,
              FieldByName('Price').asCurrency) > Disc then
            begin
              PosDisc := RecNo;
              Break;
            end;
            Prior;
          end;
        end;

        if (Disc <> 0) and (PosDisc = 0) then
        begin
          ShowMessage('����� ������ (�������) �� ����:' + FormatCurr('0.00',
            Disc) + #13#10 +
            '� ���� �� ������ ����� �� ������� ����� ��������� ������ (�������) �� ���������� ������...');
          exit;
        end;

      end;

      if nSumAll <> FSummaTotal then
      begin
        ShowMessage ('��������� ����� �� ��������.');
        exit;
      end;


      // ������������ � POS-���������
      if (PaidType <> ptMoney) and (APOSTerminalCode <> 0) and
        (iniPosType(APOSTerminalCode) <> '') then
      begin
        try
          Add_Log('����������� � POS ���������');
          try
            pPosTerm := TPosFactory.GetPos(APOSTerminalCode);
          except
            ON E: Exception do
              Add_Log('Exception: ' + E.Message);
          end;

          if pPosTerm = Nil then
          begin
            ShowMessage
              ('��������! ��������� �� ����� ������������ � POS-���������.' +
              #13 + '��������� ����������� � ��������� ������� ������!');
            exit;
          end;

          if not PayPosTerminal(pPosTerm, SalerCash - SalerCashAdd, True, spGet_Movement.ParamByName('outRRN').Value) then
            exit;
          cTextCheck := pPosTerm.TextCheck;
          ARRN := pPosTerm.RRN;
        finally
          if pPosTerm <> Nil then
            pPosTerm := Nil;
        end;
      end;

//      if isFiscal then
//        Add_Check_History;
//      if isFiscal then
//        Start_Check_History(FSummaTotal, SalerCashAdd, PaidType);

      // ��������������� ������ ����
      str_log_xml := '';
      I := 0;
      Result := not Assigned(Cash) or Cash.AlwaysSold or
        Cash.OpenReceipt(isFiscal, False {actSpec.Checked}, True);
      with MasterCDS do
      begin
        First;
        while not Eof do
        begin
          if Result then
          begin
            if MasterCDS.FieldByName('Amount').asCurrency >= 0.001 then
            begin
              // ������� ������ � �����
              Result := PutOneRecordToCash;
              // ��������� ������ � ���
              I := I + 1;
              if str_log_xml <> '' then
                str_log_xml := str_log_xml + #10 + #13;
              try
                str_log_xml := str_log_xml + '<Items num="' + IntToStr(I) + '">'
                  + '<GoodsCode>"' + FieldByName('GoodsCode').AsString +
                  '"</GoodsCode>' + '<GoodsName>"' +
                  AnsiUpperCase(FieldByName('GoodsName').Text) + '"</GoodsName>'
                  + '<Amount>"' + FloatToStr(FieldByName('Amount').asCurrency) +
                  '"</Amount>' + '<Price>"' +
                  FloatToStr(FieldByName('Price').asCurrency) + '"</Price>' +
                  '<List_UID>"' + FieldByName('List_UID').AsString +
                  '"</List_UID>' + '<Discount>"' +
                  CurrToStr(FieldByName('Summ').asCurrency -
                  GetSummFull(FieldByName('Amount').asCurrency,
                  FieldByName('Price').asCurrency)) + '"</Discount>' +
                  '</Items>';
              except
                str_log_xml := str_log_xml + '<Items="' + IntToStr(I) + '">' +
                  '<GoodsCode>"' + FieldByName('GoodsCode').AsString +
                  '"</GoodsCode>' + '<GoodsName>"???"</GoodsName>' +
                  '<List_UID>"' + FieldByName('List_UID').AsString +
                  '"</List_UID>' + '<Discount>"' +
                  CurrToStr(FieldByName('Summ').asCurrency -
                  GetSummFull(FieldByName('Amount').asCurrency,
                  FieldByName('Price').asCurrency)) + '"</Discount>' +
                  '</Items>';
              end;
              if (Disc <> 0) and (PosDisc = RecNo) then
              begin
                if Assigned(Cash) and not Cash.AlwaysSold then
                  Cash.DiscountGoods(Disc);
                Disc := 0;
              end;
            end;
          end;
          Next;
        end;
        if Result and Assigned(Cash) AND not Cash.AlwaysSold then
        begin
          if (Disc <> 0) and (PosDisc = 0) then
            Result := Cash.DiscountGoods(Disc);
          if not isFiscal or
            ((Round(FSummaTotal * 100) + Round(Cash.SummaReceipt * 100)) = 0) then
          begin
            if Result then
              Result := Cash.SubTotal(True, True, 0, 0);
            if cTextCheck <> '' then Cash.PrintFiscalText(cTextCheck);
            if Result then
              Result := Cash.TotalSumm(SalerCash, SalerCashAdd, PaidType);
            if Result then
              Result := Cash.CloseReceiptEx(ACheckNumber); // ������� ���
            if Result then AZReport := Cash.ZReport;
//            if Result and isFiscal then
//              Finish_Check_History(FSummaTotal);
          end
          else
          begin
            Result := false;
            ShowMessage('������. ����� ���� ' + CurrToStr(FSummaTotal) +
              ' �� ����� ����� ������ � ���������� ���� ' +
              CurrToStr(Cash.SummaReceipt) + '.'#13#10 +
              '��� ����������...'#13#10'(������������� ���� �������� ������� � ����������� � ���������)');
            Cash.Anulirovt;
          end
        end
        else if not Result and Assigned(Cash) AND not Cash.AlwaysSold then
        begin
          ShowMessage('������ ������ ����������� ����.'#13#10 +
            '��� ����������...');
          Cash.Anulirovt;
        end;
      end;
    except
      Result := false;
      raise;
    end;
  finally
    if Assigned(Cash) then
      Cash.AlwaysSold := False {actSpecCorr.Checked or actSpec.Checked};
  end;

  //
  // ��� � �������� ������ - ������� � ��� ��� - �� ����� �������� ���� ����� ����
  Add_Log_XML('<Head now="' + FormatDateTime('YYYY.MM.DD hh:mm:ss', Now) + '">'
    + #10 + #13 + '<CheckNumber>"' + ACheckNumber + '"</CheckNumber>' +
    '<FiscalNumber>"' + AFiscalNumber + '"</FiscalNumber>' + '<Summa>"' +
    FloatToStr(SalerCash) + '"</Summa>' + #10 + #13 + str_log_xml + #10 + #13 +
    '</Head>');
end;

initialization
  RegisterClass(TCashCloseReturnDialogForm);

end.
