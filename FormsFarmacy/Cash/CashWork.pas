unit CashWork;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, CashInterface, DB, Buttons,
  Gauges, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit,
  cxClasses, cxPropertiesStore, dsdAddOn, dxSkinsCore, dxSkinsDefaultPainters;

type
  TCashWorkForm = class(TForm)
    ceInputOutput: TcxCurrencyEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    BitBtn1: TBitBtn;
    laRest: TLabel;
    Button5: TButton;
    btDeleteAllArticul: TButton;
    Gauge: TGauge;
    Button6: TButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button5Click(Sender: TObject);
    procedure btDeleteAllArticulClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    m_Cash: ICash;
    m_DataSet: TDataSet;
  public
    constructor Create(Cash: ICash; DataSet: TDataSet);
  end;

implementation

{$R *.dfm}

{ TCashWorkForm }

constructor TCashWorkForm.Create(Cash: ICash; DataSet: TDataSet);
begin
  inherited Create(nil);
  m_Cash:= Cash;
  m_DataSet:= DataSet;
end;

procedure TCashWorkForm.Button1Click(Sender: TObject);
begin
  if ceInputOutput.Value <= 0 then
  begin
    ShowMessage('Сумма должна быть больше нуля...');
    Exit;
  end;

  if TButton(Sender).Tag = 0 then
    m_Cash.CashInputOutput(ceInputOutput.Value)
  else m_Cash.CashInputOutput(- ceInputOutput.Value);
end;

procedure TCashWorkForm.Button2Click(Sender: TObject);
begin
  if MessageDlg('Вы уверены в снятии Z-отчета?', mtInformation, mbOKCancel, 0) = mrOk then
     m_Cash.ClosureFiscal;
end;

procedure TCashWorkForm.Button3Click(Sender: TObject);
begin
  m_Cash.OpenReceipt;
  m_Cash.SubTotal(true, true, 0, 0);
  m_Cash.TotalSumm(0, 0, ptMoney);
  m_Cash.CloseReceipt;
end;

procedure TCashWorkForm.Button4Click(Sender: TObject);
var i: integer;
    RecordCountStr: string;
    CategoriesId: string;
begin
  with m_DataSet do
  begin
    First;
    i:=1;
    RecordCountStr:= IntToStr(RecordCount);
    while not EOF do
    begin
      try
        m_Cash.DeleteArticules(FieldByName('Code').AsInteger);
      except
      end;
      m_Cash.ProgrammingGoods(FieldByName('Code').AsInteger, FieldByName('FullName').asString,
                              FieldByName('LastPrice').asFloat, FieldByName('NDS').asFloat);
      Application.ProcessMessages;
      laRest.Caption:=IntToStr(i)+' из '+RecordCountStr;
      inc(i);
      Next;
    end;
  end;
end;

procedure TCashWorkForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree
end;

procedure TCashWorkForm.Button5Click(Sender: TObject);
begin
  if MessageDlg('Вы уверены в снятии X-отчета?', mtInformation, mbOKCancel, 0) = mrOk then
     m_Cash.XReport;
end;

procedure TCashWorkForm.Button6Click(Sender: TObject);
begin
  m_Cash.SetTime
end;

procedure TCashWorkForm.btDeleteAllArticulClick(Sender: TObject);
var i: integer;
begin
   m_Cash.DeleteArticules(0);
{   Gauge.MinValue:=1;
   Gauge.MaxValue:=14000;
   for i:=1 to 14000 do begin
     Gauge.Progress:=i;
   end;}
   m_Cash.ClearArticulAttachment;
   ShowMessage('Артикулы удалены')
  {}
end;

end.
