unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.StdCtrls, Data.DB,
  Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Samples.Gauges,
  dsdDB;

type
  TMainForm = class(TForm)
    GuidePanel: TPanel;
    cbAllGuide: TCheckBox;
    cbGoods: TCheckBox;
    cbMeasure: TCheckBox;
    cbJuridical: TCheckBox;
    cbUnit: TCheckBox;
    cbPriceList: TCheckBox;
    cbPriceListItems: TCheckBox;
    cbAccountGroup: TCheckBox;
    cbAccountDirection: TCheckBox;
    cbAccount: TCheckBox;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    fromADOConnection: TADOConnection;
    fromSqlQuery: TADOQuery;
    fromQuery: TADOQuery;
    DocumentPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    cbAllDocument: TCheckBox;
    cbIncome: TCheckBox;
    StartDateEdit: TcxDateEdit;
    EndDateEdit: TcxDateEdit;
    cbBank: TCheckBox;
    cbOwnedType: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ButtonPanel: TPanel;
    Gauge: TGauge;
    OKGuideButton: TButton;
    StopButton: TButton;
    CloseButton: TButton;
    cbSetNull_Id_Postgres: TCheckBox;
    cbOnlyOpen: TCheckBox;
    OKDocumentButton: TButton;
    toStoredProc: TdsdStoredProc;
    procedure OKGuideButtonClick(Sender: TObject);
  private
    fStop:Boolean;
    procedure pSetNullGuide_Id_Postgres;
    procedure pSetNullDocument_Id_Postgres;
    function fExecSqFromQuery(mySql: String): Boolean;
    procedure myEnabledCB(cb: TCheckBox);
    procedure pLoadGuide_Measure;
    function myExecToStoredProc: Boolean;
    procedure myDisabledCB(cb: TCheckBox);
    function GetStringValue(aSQL: string): string;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc:Boolean;
begin
  result:=false;
  toStoredProc.Execute;
  result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.myEnabledCB (cb:TCheckBox);
begin
  cb.Font.Style:=[fsBold];
  cb.Font.Color:=clBlue;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.myDisabledCB (cb:TCheckBox);
begin
     cb.Font.Style:=[];
     cb.Font.Color:=clWindowText;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Measure;
begin
     if (not cbMeasure.Checked)or(not cbMeasure.Enabled) then exit;
     //
     myEnabledCB(cbMeasure);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Measure.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Measure.MeasureName as ObjectName');
        Add('     , Measure.Id_Postgres');
        Add('from dba.Measure');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_measure';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsString;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Measure set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbMeasure);
end;


procedure TMainForm.OKGuideButtonClick(Sender: TObject);
begin
  if MessageDlg('Действительно загрузить выбранные справочники?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  fStop:=false;
  DBGrid.Enabled:=false;
  OKGuideButton.Enabled:=false;
  OKDocumentButton.Enabled:=false;
  //
  Gauge.Visible:=true;
  //
  if cbSetNull_Id_Postgres.Checked then begin if MessageDlg('Действительно set СПРАВОЧНИКИ+ДОКУМЕНТЫ.Sybase.ВСЕМ.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                                             pSetNullGuide_Id_Postgres;
                                             pSetNullDocument_Id_Postgres;
                                       end;
  //
  if not fStop then pLoadGuide_Measure;
(*  if not fStop then pLoadGuide_GoodsGroup;
  if not fStop then pLoadGuide_Goods;
  //if not fStop then pLoadGuide_Goods_toZConnection;
  if not fStop then pLoadGuide_GoodsKind;
  if not fStop then pLoadPaidKind;
  if not fStop then pLoadContractKind;
  if not fStop then pLoadJuridicalGroup;
  if not fStop then pLoadJuridical;
  if not fStop then pLoadPartner;
  if not fStop then pLoadUnitGroup;
  if not fStop then pLoadUnit;
  if not fStop then pLoadPriceList;
  if not fStop then pLoadGoodsProperty;
  if not fStop then pLoadGoodsPropertyValue;

  if not fStop then pLoadInfoMoneyGroup;
  if not fStop then pLoadInfoMoneyDestination;
  if not fStop then pLoadInfoMoney;
  if not fStop then pLoadAccountGroup;
  if not fStop then pLoadAccountDirection;
  if not fStop then pLoadAccount;*)
  //
  Gauge.Visible:=false;
  DBGrid.Enabled:=true;
  OKGuideButton.Enabled:=true;
  OKDocumentButton.Enabled:=true;
  //
  if fStop then ShowMessage('Справочники НЕ загружены.') else ShowMessage('Справочники загружены.');
  //
  fStop:=true;
end;

function TMainForm.fExecSqFromQuery(mySql:String):Boolean;
begin
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;

  {------------------------------------------------------------------------}
//функция возвращает строковое значение поля ReturnValue в SQL запросе
function TMainForm.GetStringValue(aSQL: string): string;
begin
  result:='';
  with FromQuery, SQl do begin
     Clear;
     Add(aSQL);
     Open;
     result:=Fields[0].asString;
     Close;
  end;
end;


procedure TMainForm.pSetNullDocument_Id_Postgres;
begin
  if GetStringValue('select COL_LENGTH( ''Measure'', ''id_Postgres'')') = '' then
     fExecSqFromQuery('ALTER TABLE Measure ADD id_Postgres integer');



//  fExecSqFromQuery('update dba.Goods set Id_Postgres = null');
//  fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres = null');
  fExecSqFromQuery('update dba.Measure set Id_Postgres = null');
(*  fExecSqFromQuery('update dba.KindPackage set Id_Postgres = null');
  fExecSqFromQuery('update dba.MoneyKind set Id_Postgres = null');
  fExecSqFromQuery('update dba.ContractKind set Id_Postgres = null');
  fExecSqFromQuery('update dba.Unit set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
  fExecSqFromQuery('update dba.PriceList_byHistory set Id_Postgres = null');
  fExecSqFromQuery('update dba.GoodsProperty_Postgres set Id_Postgres = null');
  fExecSqFromQuery('update dba.GoodsProperty_Detail set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null, Id4_Postgres = null, Id5_Postgres = null, Id6_Postgres = null, Id7_Postgres = null'
                                                   +', Id8_Postgres = null, Id9_Postgres = null, Id10_Postgres = null, Id11_Postgres = null, Id12_Postgres = null, Id13_Postgres = null, Id14_Postgres = null');
  fExecSqFromQuery('update dba._pgInfoMoney set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
  *)
end;

procedure TMainForm.pSetNullGuide_Id_Postgres;
begin
(*
  fExecSqFromQuery('update dba.Bill set Id_Postgres = null where Id_Postgres is not null'); //
  fExecSqFromQuery('update dba.BillItems set Id_Postgres = null where Id_Postgres is not null');
  fExecSqFromQuery('update dba.BillItemsReceipt set Id_Postgres = null where Id_Postgres is not null');
  *)
end;

end.
