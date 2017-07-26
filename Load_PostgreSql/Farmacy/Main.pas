unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.StdCtrls, Data.DB,
  Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Samples.Gauges,
  dsdDB, dxSkinsCore, dxSkinsDefaultPainters, ZAbstractConnection, ZConnection,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

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
    cbGoodsPartnerCode: TCheckBox;
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
    toTwoStoredProc: TdsdStoredProc;
    cbLinkGoods: TCheckBox;
    cbCashOperation: TCheckBox;
    cbBill: TCheckBox;
    toZConnection: TZConnection;
    Edit1: TEdit;
    procedure OKGuideButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure OKDocumentButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
  private
    fStop:Boolean;
    function FormatToDateServer_notNULL(_Date:TDateTime):string;

    procedure pSetNullGuide_Id_Postgres;
    procedure pSetNullDocument_Id_Postgres;
    function fExecSqFromQuery(mySql: String): Boolean;
    procedure myEnabledCB(cb: TCheckBox);
    function myExecToStoredProc: Boolean;
    procedure myDisabledCB(cb: TCheckBox);
    function GetStringValue(aSQL: string): string;
    function GetRetailId: integer;
    procedure pLoadGuide_Measure;
    procedure pLoadGuide_Goods;
    procedure pLoadGuide_GoodsPartnerCode;
    procedure pLoadGuide_LinkGoods;
    procedure pLoadUnit;

    procedure pLoadDocument_CashOperation;
    procedure pLoadDocument_Bill;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses Authentication, CommonData, Storage, DBClient
   , UtilConst;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc:Boolean;
begin
  result:=false;
  try toStoredProc.Execute; result:=true; except ShowMessage('myExecToStoredProc'); end;
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
procedure TMainForm.pLoadGuide_LinkGoods;
var RetailId: integer;
begin
     if (not cbLinkGoods.Checked)or(not cbLinkGoods.Enabled) then exit;
     RetailId := GetRetailId;
     //
     myEnabledCB(cbLinkGoods);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;

        Add('SELECT ParentGoodsProperty.Code AS ParentCode, ChildGoodsProperty.Code AS ChildCode ');
        Add('FROM "DBA"."GoodsLink" ');
        Add('       JOIN GoodsProperty AS ParentGoodsProperty ON ParentGoodsProperty.GoodsId = GoodsLink.ParentGoodId ');
        Add('       JOIN GoodsProperty AS ChildGoodsProperty ON ChildGoodsProperty.GoodsId = GoodsLink.ChildGoodId ');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_LinkGoodsRetail_Load';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inGoodsMainCode', ftString, ptInput, '');
        toStoredProc.Params.AddParam ('inGoodsCode', ftString, ptInput, '');
        toStoredProc.Params.AddParam ('inRetailId', ftInteger, ptInput, 0);

        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('inGoodsMainCode').Value := FieldByName('ParentCode').AsInteger;
             toStoredProc.Params.ParamByName('inGoodsCode').Value := FieldByName('ChildCode').AsString;
             toStoredProc.Params.ParamByName('inRetailId').Value := RetailId;
             toStoredProc.Execute;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbLinkGoods);
end;

procedure TMainForm.pLoadGuide_Goods;
var RetailId: integer;
begin
     if (not cbGoods.Checked)or(not cbGoods.Enabled) then exit;
     RetailId := GetRetailId;
     //
     myEnabledCB(cbGoods);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsProperty.Id as ObjectId');
        Add('     , GoodsProperty.Code as ObjectCode');
        Add('     , GoodsProperty.GoodsName as ObjectName');
        Add('     , GoodsProperty.NDS as NDS');
        Add('     , Measure.MeasureName as MeasureName');
        Add('from dba.GoodsProperty');
        Add('     left outer join dba.Measure on Measure.Id = GoodsProperty.MeasureId');
        Add('where GoodsProperty.Id > 0 order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_MainGoodsLoad';
        toStoredProc.OutputType := otMultiExecute;
        toStoredProc.PackSize := 100;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inCode', ftInteger, ptInput, 0);
        toStoredProc.Params.AddParam ('inName', ftString, ptInput, '');
        toStoredProc.Params.AddParam ('inMeasureName', ftString, ptInput, '');
        toStoredProc.Params.AddParam ('inNDS', ftFloat, ptInput, 0);

        toTwoStoredProc.StoredProcName:='gpInsertUpdate_Object_GoodsLoad';
        toTwoStoredProc.OutputType := otMultiExecute;
        toTwoStoredProc.PackSize := toStoredProc.PackSize;
        toTwoStoredProc.Params.Clear;

        toTwoStoredProc.Params.AddParam ('ioId', ftInteger, ptInputOutput, 0);
        toTwoStoredProc.Params.AddParam ('inCode', ftString, ptInput, 0);
        toTwoStoredProc.Params.AddParam ('inMainCode', ftInteger, ptInput, 0);
        toTwoStoredProc.Params.AddParam ('inName', ftString, ptInput, '');
        toTwoStoredProc.Params.AddParam ('inObjectId', ftInteger, ptInput, RetailId);
        toTwoStoredProc.Params.AddParam ('inMeasureName', ftString, ptInput, '');
        toTwoStoredProc.Params.AddParam ('inNDS', ftFloat, ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('inCode').Value := FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value := FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inMeasureName').Value := FieldByName('MeasureName').AsString;
             toStoredProc.Params.ParamByName('inNDS').Value := FieldByName('NDS').AsFloat;
             myExecToStoredProc;

             toTwoStoredProc.Params.ParamByName('ioId').Value := 0;//FieldByName('Id_Postgres').AsInteger;
             toTwoStoredProc.Params.ParamByName('inCode').Value := FieldByName('ObjectCode').AsInteger;
             toTwoStoredProc.Params.ParamByName('inMainCode').Value := FieldByName('ObjectCode').AsInteger;
             toTwoStoredProc.Params.ParamByName('inName').Value := FieldByName('ObjectName').AsString;
             toTwoStoredProc.Params.ParamByName('inMeasureName').Value := FieldByName('MeasureName').AsString;
             toTwoStoredProc.Params.ParamByName('inNDS').Value := FieldByName('NDS').AsFloat;
             toTwoStoredProc.Execute;

             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        toStoredProc.Execute(true);
        toTwoStoredProc.Execute(true);
     end;
     //
     myDisabledCB(cbGoods);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_GoodsPartnerCode;
begin
     if (not cbGoodsPartnerCode.Checked)or(not cbGoodsPartnerCode.Enabled) then exit;
     //
     myEnabledCB(cbGoodsPartnerCode);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('SELECT AlternativeCode, Code, OKPO FROM AlternativeCode');
        Add('     join GoodsProperty on GoodsProperty.Id = AlternativeCode.MasterId');
        Add('     join Client on Client.Id = CategoriesId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_Object_GoodsPartnerCodeLoad';
        toStoredProc.OutputType := otMultiExecute;
        toStoredProc.PackSize := 100;
        toStoredProc.Params.Clear;

        toStoredProc.Params.AddParam ('inOKPO',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inMainCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPartnerCode',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('inOKPO').Value := FieldByName('OKPO').AsString;
             toStoredProc.Params.ParamByName('inMainCode').Value := FieldByName('Code').AsInteger;
             toStoredProc.Params.ParamByName('inPartnerCode').Value := FieldByName('AlternativeCode').AsString;
             if not myExecToStoredProc then ;//exit;
             //
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        toStoredProc.Execute(true);
     end;
     //
     myDisabledCB(cbGoodsPartnerCode);

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

procedure TMainForm.pLoadUnit;
begin
     if (not cbUnit.Checked)or(not cbUnit.Enabled) then exit;
     //
     myEnabledCB(cbUnit);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Unit.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Unit.UnitName as ObjectName');
        Add('     , Unit.Id_Postgres as Id_Postgres');
        Add('     , Unit_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.Unit');
        Add('     left outer join dba.Unit as Unit_parent on Unit_parent.Id = Unit.ParentId');
        Add('order by ObjectId');

        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_unit';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inJuridicalId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
        //EnableControls;
     end;
     //
     myDisabledCB(cbUnit);
end;

procedure TMainForm.OKDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
    myRecordCount1,myRecordCount2:Integer;
begin
     if MessageDlg('Действительно загрузить выбранные документы?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     //
     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     //
     Gauge.Visible:=true;
     //
     tmpDate1:=NOw;
     //
     if not fStop then pLoadDocument_CashOperation;
     if not fStop then pLoadDocument_Bill;
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     //
     tmpDate2:=NOw;
     if (tmpDate2-tmpDate1)>=1
     then StrTime:=DateTimeToStr(tmpDate2-tmpDate1)
     else begin
               DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
               StrTime:=IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
     end;
     if fStop then ShowMessage('Документы НЕ загружены. Time=('+StrTime+').')
     else ShowMessage('Документы загружены. Time=('+StrTime+').');
     //
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
  try
    if cbSetNull_Id_Postgres.Checked then begin if MessageDlg('Действительно set СПРАВОЧНИКИ+ДОКУМЕНТЫ.Sybase.ВСЕМ.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                                               pSetNullGuide_Id_Postgres;
                                               pSetNullDocument_Id_Postgres;
                                         end;

    //
    if not fStop then pLoadGuide_Measure;
    if not fStop then pLoadGuide_Goods;
    if not fStop then pLoadGuide_GoodsPartnerCode;
    if not fStop then pLoadGuide_LinkGoods;
    if not fStop then pLoadUnit;
  finally
    Gauge.Visible:=false;
    DBGrid.Enabled:=true;
    OKGuideButton.Enabled:=true;
    OKDocumentButton.Enabled:=true;
  end;
  //
  if fStop then ShowMessage('Справочники НЕ загружены.') else ShowMessage('Справочники загружены.');
  //
  fStop:=true;
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  Close
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
procedure TMainForm.FormCreate(Sender: TObject);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     Gauge.Visible:=false;
     Gauge.Progress:=0;
     //
     fStop:=true;
     //
     if FindCmdLineSwitch('realfarmacy', true)
     then TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1234', gc_User)
     else TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1111', gc_User);
     //
     with toZConnection do begin
        Connected:=false;//http://91.210.37.210/farmacy/index.php
        HostName:='91.210.37.210';
        User:='postgres';
        Password:='postgres';
        if FindCmdLineSwitch('realfarmacy', true)
        then Database:='farmacy'
        else Database:='farmacy_test';
        try Connected:=true; except ShowMessage ('not Connected');end;
        //
        if Connected
        then Self.Caption:= Self.Caption + ' : ' + HostName + ' : ' + Database + ' : TRUE'
        else Self.Caption:= Self.Caption + ' : ' + HostName + ' : ' + Database + ' : FALSE';
        //
        Connected:=false;
     end;
     //
     Present:= Now;
     DecodeDate(Present, Year, Month, Day);
     StartDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year)));
     if Month=12 then begin Month:=1;Year:=Year+1;end else Month:=Month+1;
     EndDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year))-1);
end;
{------------------------------------------------------------------------}
function TMainForm.FormatToDateServer_notNULL(_Date:TDateTime):string;
var
  Year, Month, Day: Word;
begin
     DecodeDate(_Date,Year,Month,Day);
     result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+chr(39);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadDocument_CashOperation;
begin
     if (not cbCashOperation.Checked)or(not cbCashOperation.Enabled) then exit;
     //
     myEnabledCB(cbCashOperation);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select CashOperation.*');
        Add('from dba.CashOperation');
        Add('where CashOperation.OperDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        try if StrToInt(Edit1.Text) <> 0 then
            begin
                 Add(' and CashOperation.Id = ' + Edit1.Text);
                 gc_isShowTimeMode:=true;
                 gc_isDebugMode:=true;
            end;
        except
        end;
        Add('order by OperDate,Id');
        Open;
        cbCashOperation.Caption:='1.1. ('+IntToStr(RecordCount)+') CashOperation';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertSybase_CashOperation';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCashID',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inOperDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inClientID',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inSpendingID',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inOperSumm',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inDocumentID',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inRemark',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inisPlat',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPlatNumber',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContragentSumm',ftFloat,ptInput, 0);
        //
        //DisableControls;
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             try toStoredProc.Params.ParamByName('inId').Value            :=FieldByName('Id').AsInteger;           except ShowMessage('Id');end;
             try toStoredProc.Params.ParamByName('inCashID').Value        :=FieldByName('CashID').AsInteger;       except ShowMessage('CashID');end;
             try toStoredProc.Params.ParamByName('inOperDate').Value      :=FieldByName('OperDate').AsDateTime;    except ShowMessage('OperDate');end;
             try toStoredProc.Params.ParamByName('inClientID').Value      :=FieldByName('ClientID').AsInteger;     except ShowMessage('ClientID');end;
             try toStoredProc.Params.ParamByName('inSpendingID').Value    :=FieldByName('SpendingID').AsInteger;   except ShowMessage('SpendingID');end;
             try toStoredProc.Params.ParamByName('inOperSumm').Value      :=FieldByName('OperSumm').AsFloat;       except ShowMessage('OperSumm');end;
             try toStoredProc.Params.ParamByName('inDocumentID').Value    :=FieldByName('DocumentID').AsInteger;   except ShowMessage('DocumentID');end;
             try toStoredProc.Params.ParamByName('inRemark').Value        :=FieldByName('Remark').AsString;        except ShowMessage('Remark');end;
             try toStoredProc.Params.ParamByName('inisPlat').Value        :=FieldByName('isPlat').AsInteger;       except ShowMessage('isPlat');end;
             try toStoredProc.Params.ParamByName('inPlatNumber').Value    :=FieldByName('PlatNumber').AsInteger;   except ShowMessage('PlatNumber');end;
             try toStoredProc.Params.ParamByName('inContragentSumm').Value:=FieldByName('ContragentSumm').AsFloat; except ShowMessage('ContragentSumm');end;
             if not myExecToStoredProc then ShowMessage (FieldByName('Remark').AsString
                                              +#10+#13 + IntToStr(FieldByName('isPlat').AsInteger)
                                              +#10+#13 + IntToStr(FieldByName('PlatNumber').AsInteger)
                                              +#10+#13 + FloatToStr(FieldByName('ContragentSumm').AsFloat));//exit;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCashOperation);
end;
{------------------------------------------------------------------------}
procedure TMainForm.pLoadDocument_Bill;
begin
     if (not cbBill.Checked)or(not cbBill.Enabled) then exit;
     //
     myEnabledCB(cbBill);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select ID,BillDate,BillNumber,BillKind,BillSumm,FromID,ToID,IsNds,Nds,isBlocking');
        Add('      ,case when Bill.isDistribution is null then IntNULL else Bill.isDistribution end as isDistribution');
        Add('      ,ParentId');
        Add('      ,case when Bill.isMark is null then IntNULL else Bill.isMark end as isMark');
        Add('      ,case when Bill.IncomeCheck is null then IntNULL else Bill.IncomeCheck end as IncomeCheck');
        Add('      ,ReturnTypeId');
        Add('      ,ContragentSumm');
        Add('      ,case when Bill.RepriceClosed is null then IntNULL else Bill.RepriceClosed end as RepriceClosed');
        Add('      ,case when Bill.ClientDate is null then DateNULL else Bill.ClientDate end as ClientDate');
        Add('      ,ClientNumber');
        Add('      ,ManagerId');
        Add('      ,cast ('+FormatToDateServer_notNULL(StrToDate('01.01.1990'))+' as date) as DateNULL');
        Add('      ,-12345 AS IntNULL');
        Add('from dba.Bill');

        Add('where Bill.BillDate between '+FormatToDateServer_notNULL(StrToDate(StartDateEdit.Text))+' and '+FormatToDateServer_notNULL(StrToDate(EndDateEdit.Text)));
        Add('order by BillDate,Id');
        Open;
        cbBill.Caption:='1.2. ('+IntToStr(RecordCount)+') Bill';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertSybase_Bill';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inBillDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inBillNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inBillKind',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inBillSumm',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inToId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inisNDS',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inNds',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inisBlocking',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inisDistribution',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inisMark',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inIncomeCheck',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inReturnTypeId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inContragentSumm',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inRepriceClosed',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inClientDate',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inClientNumber',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inManagerId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inDateNULL',ftDateTime,ptInput, '');
        toStoredProc.Params.AddParam ('inIntNULL',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('inId').Value            :=FieldByName('Id').AsInteger;
             toStoredProc.Params.ParamByName('inBillDate').Value      :=FieldByName('BillDate').AsDateTime;
             toStoredProc.Params.ParamByName('inBillNumber').Value    :=FieldByName('BillNumber').AsString;
             toStoredProc.Params.ParamByName('inBillKind').Value      :=FieldByName('BillKind').AsInteger;
             toStoredProc.Params.ParamByName('inBillSumm').Value      :=FieldByName('BillSumm').AsFloat;
             toStoredProc.Params.ParamByName('inFromId').Value        :=FieldByName('FromId').AsInteger;
             toStoredProc.Params.ParamByName('inToId').Value          :=FieldByName('ToId').AsInteger;
             toStoredProc.Params.ParamByName('inisNDS').Value         :=FieldByName('isNDS').AsInteger;
             toStoredProc.Params.ParamByName('inNds').Value           :=FieldByName('Nds').AsFloat;
             toStoredProc.Params.ParamByName('inisBlocking').Value    :=FieldByName('isBlocking').AsInteger;
             toStoredProc.Params.ParamByName('inisDistribution').Value:=FieldByName('isDistribution').AsInteger;
             toStoredProc.Params.ParamByName('inParentId').Value      :=FieldByName('ParentId').AsInteger;
             toStoredProc.Params.ParamByName('inisMark').Value        :=FieldByName('isMark').AsInteger;
             toStoredProc.Params.ParamByName('inIncomeCheck').Value   :=FieldByName('IncomeCheck').AsInteger;
             toStoredProc.Params.ParamByName('inReturnTypeId').Value  :=FieldByName('ReturnTypeId').AsInteger;
             toStoredProc.Params.ParamByName('inContragentSumm').Value:=FieldByName('ContragentSumm').AsFloat;
             toStoredProc.Params.ParamByName('inRepriceClosed').Value :=FieldByName('RepriceClosed').AsInteger;
             toStoredProc.Params.ParamByName('inClientDate').Value    :=FieldByName('ClientDate').AsDateTime;
             toStoredProc.Params.ParamByName('inClientNumber').Value  :=FieldByName('ClientNumber').AsString;
             toStoredProc.Params.ParamByName('inManagerId').Value     :=FieldByName('ManagerId').AsInteger;
             toStoredProc.Params.ParamByName('inDateNULL').Value      :=FieldByName('DateNULL').AsDateTime;
             toStoredProc.Params.ParamByName('inIntNULL').Value       :=FieldByName('IntNULL').AsInteger;
             if not myExecToStoredProc then ;//exit;
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbBill);
end;
{------------------------------------------------------------------------}
function TMainForm.GetRetailId: integer;
var DataSet: TClientDataSet;
begin
  DataSet := TClientDataSet.Create(nil);
  toStoredProc.StoredProcName:='gpSelect_Object_Retail';
  toStoredProc.OutputType := otDataSet;
  toStoredProc.Params.Clear;
  toStoredProc.DataSet := DataSet;
  toStoredProc.Execute;
  if DataSet.Locate('Name', 'Не болей', []) then
     result := DataSet.FieldByName('Id').AsInteger
  else begin
    toStoredProc.StoredProcName:='gpInsertUpdate_Object_Retail';
    toStoredProc.OutputType := otResult;
    toStoredProc.Params.Clear;
    toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
    toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
    toStoredProc.Params.AddParam ('inName',ftString,ptInput, 'Не болей');
    toStoredProc.Execute;
    result := toStoredProc.Params.ParamByName('ioId').Value;
  end;
end;

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
end;

procedure TMainForm.pSetNullGuide_Id_Postgres;
begin
  if GetStringValue('select COL_LENGTH( ''Measure'', ''id_Postgres'')') = '' then
     fExecSqFromQuery('ALTER TABLE Measure ADD id_Postgres integer');
  if GetStringValue('select COL_LENGTH( ''ExtraChargeCategories'', ''id_Postgres'')') = '' then
     fExecSqFromQuery('ALTER TABLE ExtraChargeCategories ADD id_Postgres integer');
  if GetStringValue('select COL_LENGTH( ''GoodsProperty'', ''id_Postgres'')') = '' then
     fExecSqFromQuery('ALTER TABLE GoodsProperty ADD id_Postgres integer');
  if GetStringValue('select COL_LENGTH( ''Unit'', ''id_Postgres'')') = '' then
     fExecSqFromQuery('ALTER TABLE Unit ADD id_Postgres integer');


  fExecSqFromQuery('update dba.Measure set Id_Postgres = null');
  fExecSqFromQuery('update dba.ExtraChargeCategories set Id_Postgres = null');
  fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres = null');
  fExecSqFromQuery('update dba.Unit set Id_Postgres = null');
end;

procedure TMainForm.StopButtonClick(Sender: TObject);
begin
     if MessageDlg('Действительно остановить загрузку?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     fStop:=true;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
end;

end.
