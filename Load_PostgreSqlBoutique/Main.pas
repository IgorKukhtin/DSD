unit Main;

interface

uses
  Windows, Forms, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ZAbstractConnection,
  ZConnection, dsdDB, ZAbstractRODataset, ZAbstractDataset, ZDataset, Data.DB,
  Data.Win.ADODB, Vcl.StdCtrls, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.Controls, Vcl.Samples.Gauges, Vcl.ExtCtrls, System.Classes,
  Vcl.Grids, Vcl.DBGrids, DBTables, dxSkinsCore, dxSkinsDefaultPainters,
  IdBaseComponent, IdComponent, IdIPWatch, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TMainForm = class(TForm)
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    OKGuideButton: TButton;
    GuidePanel: TPanel;
    cbAllGuide: TCheckBox;
    Gauge: TGauge;
    fromADOConnection: TADOConnection;
    fromQuery: TADOQuery;
    fromSqlQuery: TADOQuery;
    StopButton: TButton;
    CloseButton: TButton;
    cbMeasure: TCheckBox;
    cbOnlyOpen: TCheckBox;
    DocumentPanel: TPanel;
    cbAllDocument: TCheckBox;
    OKDocumentButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    toSqlQuery: TZQuery;
    StartDateEdit: TcxDateEdit;
    EndDateEdit: TcxDateEdit;
    OKCompleteDocumentButton: TButton;
    toStoredProc: TdsdStoredProc;
    toStoredProc_two: TdsdStoredProc;
    fromQuery_two: TADOQuery;
    toZConnection: TZConnection;
    fromFlADOConnection: TADOConnection;
    fromFlQuery: TADOQuery;
    fromFlSqlQuery: TADOQuery;
    toStoredProc_three: TdsdStoredProc;
    toSqlQuery_two: TZQuery;
    fromQueryDate: TADOQuery;
    fromQueryDate_recalc: TADOQuery;
    cbCompositionGroup: TCheckBox;
    cbId_Postgres: TCheckBox;
    cbNullId_Postgres: TCheckBox;
    cbComposition: TCheckBox;
    cbCountryBrand: TCheckBox;
    cbBrand: TCheckBox;
    cbFabrika: TCheckBox;
    cbLineFabrica: TCheckBox;
    cbGoodsInfo: TCheckBox;
    cbGoodsSize: TCheckBox;
    cbKassa: TCheckBox;
    cbValuta: TCheckBox;
    cbPeriod: TCheckBox;
    cbGoodsGroup: TCheckBox;
    cbDiscount: TCheckBox;
    cbDiscountTools: TCheckBox;
    cbPartner: TCheckBox;
    procedure OKGuideButtonClick(Sender: TObject);
    procedure cbAllGuideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure cbAllDocumentClick(Sender: TObject);
    procedure OKDocumentButtonClick(Sender: TObject);
    procedure cbAllCompleteDocumentClick(Sender: TObject);
    procedure cbCompleteClick(Sender: TObject);
    procedure cbUnCompleteClick(Sender: TObject);
    procedure OKCompleteDocumentButtonClick(Sender: TObject);
    procedure cbTaxIntClick(Sender: TObject);
    procedure DocumentPanelClick(Sender: TObject);
    procedure toZConnectionAfterConnect(Sender: TObject);
  private
    fStop:Boolean;
    isGlobalLoad,zc_rvYes,zc_rvNo:Integer;
    zc_Enum_PaidKind_FirstForm,zc_Enum_PaidKind_SecondForm:Integer;

    procedure EADO_EngineErrorMsg(E:EADOError);
    procedure EDB_EngineErrorMsg(E:EDBEngineError);
    function myExecToStoredProc_ZConnection:Boolean;
    function myExecToStoredProc:Boolean;
    function myExecToStoredProc_two:Boolean;
    function myExecToStoredProc_three:Boolean;
    function myExecSqlUpdateErased(ObjectId:Integer;Erased,Erased_del:byte):Boolean;

    procedure myShowSql(mySql:TStrings);
    procedure MyDelay(mySec:Integer);

    function myReplaceStr(const S, Srch, Replace: string): string;
    function FormatToVarCharServer_notNULL(_Value:string):string;
    function FormatToVarCharServer_isSpace(_Value:string):string;
    function FormatToDateServer_notNULL(_Date:TDateTime):string;
    function FormatToDateTimeServer(_Date:TDateTime):string;

    function fOpenSqFromQuery (mySql:String):Boolean;
    function fExecSqFromQuery (mySql:String):Boolean;
    function fExecFlSqFromQuery (mySql:String):Boolean;

    function fGetSession:String;
    function fOpenSqToQuery (mySql:String):Boolean;
    function fExecSqToQuery (mySql:String):Boolean;
    function fOpenSqToQuery_two (mySql:String):Boolean;
    function fExecSqToQuery_two (mySql:String):Boolean;


    procedure pSetNullGuide_Id_Postgres;
    procedure pSetNullDocument_Id_Postgres;



    // Guides :
    procedure pLoadGuide_Measure;
    procedure pLoadGuide_CompositionGroup;
    procedure pLoadGuide_Composition;
    procedure pLoadGuide_CountryBrand;
    procedure pLoadGuide_Brand;
    procedure pLoadGuide_Fabrika;
    procedure pLoadGuide_LineFabrica;
    procedure pLoadGuide_GoodsInfo;
    procedure pLoadGuide_GoodsSize;
    procedure pLoadGuide_Kassa;
    procedure pLoadGuide_Valuta;
    procedure pLoadGuide_Period;
    procedure pLoadGuide_GoodsGroup;
    procedure pLoadGuide_Discount;
    procedure pLoadGuide_DiscountTools;
    procedure pLoadGuide_Partner;



    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);
  public
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, CommonData, Storage, SysUtils, Dialogs, Graphics;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StopButtonClick(Sender: TObject);
begin
     if MessageDlg('Действительно остановить загрузку?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     fStop:=true;
     DBGrid.Enabled:=true;
     //OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
end;
procedure TMainForm.toZConnectionAfterConnect(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
     if not fStop then
       if MessageDlg('Действительно остановить загрузку и выйти?',mtConfirmation,[mbYes,mbNo],0)=mrYes then fStop:=true;
     //
     if fStop then Close;
end;
procedure TMainForm.DocumentPanelClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fGetSession:String;
begin Result:='1005'; end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqFromQuery(mySql:String):Boolean;
begin
     //fromADOConnection.Connected:=false;
     //
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqFromQuery(mySql:String):Boolean;
begin
     //fromADOConnection.Connected:=false;
     //
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecFlSqFromQuery(mySql:String):Boolean;
begin
     with fromFlSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecFlSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqToQuery (mySql:String):Boolean;
begin
     with toSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqToQuery (mySql:String):Boolean;
begin
     with toSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqToQuery_two (mySql:String):Boolean;
begin
     with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqToQuery_two (mySql:String):Boolean;
begin
     with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.MyDelay(mySec:Integer);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  calcSec,calcSec2:LongInt;
begin
     Present:=Now;
     DecodeDate(Present, Year, Month, Day);
     DecodeTime(Present, Hour, Min, Sec, MSec);
     //calcSec:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     calcSec:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     while abs(calcSec-calcSec2)<mySec do
     begin
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Present:=Now;
          DecodeDate(Present, Year, Month, Day);
          DecodeTime(Present, Hour, Min, Sec, MSec);
          //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
          calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
     end;
end;
{------------------------------------------------------------------------------}
procedure TMainForm.myShowSql(mySql:TStrings);
var
  I: Integer;
  Str: string;
begin
     Str:='';
     for i:= 0 to mySql.Count-1 do
     if i=mySql.Count-1
     then Str:=Str+mySql[i]
     else Str:=Str+mySql[i]+#10+#13;
     ShowMessage('Error.OpenSql'+#10+#13+Str);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToVarCharServer_notNULL(_Value:string):string;
begin if trim(_Value)='' then Result:=chr(39)+''+chr(39) else Result:=chr(39)+trim(_Value)+chr(39);end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToVarCharServer_isSpace(_Value:string):string;
begin Result:=chr(39)+(_Value)+chr(39);end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myReplaceStr(const S, Srch, Replace: string): string;
var
  I: Integer;
  Source: string;
begin
  Source := S;
  Result := '';
  repeat
    I := Pos(Srch, Source);
    if I > 0 then begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + Length(Srch), MaxInt);
    end
    else Result := Result + Source;
  until I <= 0;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToDateServer_notNULL(_Date:TDateTime):string;
var
  Year, Month, Day: Word;
begin
     DecodeDate(_Date,Year,Month,Day);
     result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+chr(39);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToDateTimeServer(_Date:TDateTime):string;
var
  Year, Month, Day: Word;
  AHour, AMinute, ASecond, MSec: Word;
begin
     DecodeDate(_Date,Year,Month,Day);
     DecodeTime(_Date,AHour, AMinute, ASecond, MSec);
//     result:=chr(39)+GetStringValue('select zf_FormatToDateServer('+IntToStr(Year)+','+IntToStr(Month)+','+IntToStr(Day)+')as RetV')+chr(39);
     if Year <= 1900
     then result:='null'
     else result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+' '+IntToStr(AHour)+':'+IntToStr(AMinute)+':'+IntToStr(ASecond)+chr(39);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc_ZConnection:Boolean;
begin
    result:=false;
    ShowMessage ('ERROR - toStoredProc_ZConnection on myExecToStoredProc_ZConnection')
    {toStoredProc_ZConnection.Prepared:=true;
     try toStoredProc_ZConnection.ExecProc;
     except
           //on E:EDBEngineError do begin EDB_EngineErrorMsg(E);exit;end;
           on E:EADOError do begin EADO_EngineErrorMsg(E);exit;end;

     end;
     result:=true;}
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc:Boolean;
begin
    result:=false;
     // toStoredProc.Prepared:=true;
     //try
     toStoredProc.Execute;
     //except
           //on E:EDBEngineError do begin EDB_EngineErrorMsg(E);exit;end;
           //on E:EADOError do begin EADO_EngineErrorMsg(E);exit;end;
           //exit;
     //end;
     result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc_two:Boolean;
begin
    result:=false;
     // toStoredProc_two.Prepared:=true;
     // try
     toStoredProc_two.Execute;
     //except
           //on E:EDBEngineError do begin EDB_EngineErrorMsg(E);exit;end;
           //on E:EADOError do begin EADO_EngineErrorMsg(E);exit;end;
           //exit;
     //end;
     result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecToStoredProc_three:Boolean;
begin
    result:=false;
     // toStoredProc_three.Prepared:=true;
     // try
     toStoredProc_three.Execute;
     //except
           //on E:EDBEngineError do begin EDB_EngineErrorMsg(E);exit;end;
           //on E:EADOError do begin EADO_EngineErrorMsg(E);exit;end;
           //exit;
     //end;
     result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.myExecSqlUpdateErased(ObjectId:Integer;Erased,Erased_del:byte):Boolean;
begin
     if Erased=Erased_del
     then fOpenSqToQuery ('select * from lfExecSql('+FormatToVarCharServer_notNULL('update Object set isErased = true where Id = '+IntToStr(ObjectId))+')')
     else fOpenSqToQuery ('select * from lfExecSql('+FormatToVarCharServer_notNULL('update Object set isErased = false where Id = '+IntToStr(ObjectId))+')');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.EADO_EngineErrorMsg(E:EADOError);
begin
  MessageDlg(E.Message,mtError,[mbOK],0);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.EDB_EngineErrorMsg(E:EDBEngineError);
var
  DBError: TDBError;
begin
  DBError:=E.Errors[1];
  MessageDlg(DBError.Message,mtError,[mbOK],0);
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
procedure TMainForm.cbAllGuideClick(Sender: TObject);
var i:Integer;
begin
     for i:=0 to ComponentCount-1 do
        if (Components[i] is TCheckBox) then
          if Components[i].Tag=10
          then TCheckBox(Components[i]).Checked:=cbAllGuide.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbAllCompleteDocumentClick(Sender: TObject);
var i:Integer;
begin
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbAllDocumentClick(Sender: TObject);
var i:Integer;
begin
     for i:=0 to ComponentCount-1 do
        if (Components[i] is TCheckBox) then
          if Components[i].Tag=20
          then TCheckBox(Components[i]).Checked:=cbAllDocument.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbCompleteClick(Sender: TObject);
begin
      //cbUnComplete.Checked:=not cbComplete.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbUnCompleteClick(Sender: TObject);
begin
      //cbComplete.Checked:=not cbUnComplete.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbTaxIntClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     Gauge.Visible:=false;
     Gauge.Progress:=0;
     //
     zc_rvYes:=0;
     zc_rvNo:=1;
     //
     if ParamStr(1)='alan_dp_ua' then
     with toZConnection do begin
        Connected:=false;
        HostName:='integer-srv.alan.dp.ua';
        User:='admin';
        Password:='vas6ok';
        try Connected:=true; except ShowMessage ('not Connected');end;
        //
        isGlobalLoad:=zc_rvYes;
        if Connected
        then Self.Caption:= Self.Caption + ' : ' + HostName + ' : TRUE'
        else Self.Caption:= Self.Caption + ' : ' + HostName + ' : FALSE';
        Connected:=false;
     end
     else
     if ParamStr(1)='alan_dp_ua_test' then
     with toZConnection do begin
        Connected:=false;
        HostName:='integer-srv-r.alan.dp.ua';
        User:='admin';
        Password:='vas6ok';
        try Connected:=true; except ShowMessage ('not Connected');end;
        //
        isGlobalLoad:=zc_rvYes;
        if Connected
        then Self.Caption:= Self.Caption + ' : ' + HostName + ' : TRUE'
        else Self.Caption:= Self.Caption + ' : ' + HostName + ' : FALSE';
        Connected:=false;
     end
     else
     with toZConnection do begin
        Connected:=false;
        HostName:='localhost';
        User:='postgres';
        Password:='plans';
        try Connected:=true; except ShowMessage ('not Connected');end;
        //
        //if ParamCount = 2 then isGlobalLoad:=zc_rvYes else isGlobalLoad:=zc_rvNo;
        isGlobalLoad:=zc_rvNo;
        if Connected
        then Self.Caption:= Self.Caption + ' : ' + HostName + ' : TRUE'
        else Self.Caption:= Self.Caption + ' : ' + HostName + ' : FALSE';
        //
        Connected:=false;
     end;
     //
     //cbAllGuide.Checked:=true;
     //
     fStop:=true;
     //
     Present:= Now;
     DecodeDate(Present, Year, Month, Day);
     StartDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year)));
//     StartDateCompleteEdit.Text:=StartDateEdit.Text;

     if Month=12 then begin Month:=1;Year:=Year+1;end else Month:=Month+1;
     EndDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year))-1);
//     EndDateCompleteEdit.Text:=EndDateEdit.Text;
     //
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
     //

     //
end;



//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKGuideButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
begin
     if   System.Pos('auto',ParamStr(2))<=0
     then
     if MessageDlg('Действительно загрузить выбранные справочники?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;

     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     OKCompleteDocumentButton.Enabled:=false;
     //
     Gauge.Visible:=true;
     //
     if cbNullId_Postgres.Checked then begin if MessageDlg('Действительно set СПРАВОЧНИКИ+ДОКУМЕНТЫ.Sybase.ВСЕМ.Id_Postgres = null?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                                                 pSetNullGuide_Id_Postgres;
                                                 pSetNullDocument_Id_Postgres;
                                           end;
     //
     tmpDate1:=NOw;

     //!!!FLOAT!!!
     DataSource.DataSet:=fromFlQuery;

     if not fStop then DataSource.DataSet:=fromQuery;
     //!!!end FLOAT!!!
     //


     //!!!Integer!!!
     if not fStop then pLoadGuide_Measure;
     if not fStop then pLoadGuide_CompositionGroup;
     if not fStop then pLoadGuide_Composition;
     if not fStop then pLoadGuide_CountryBrand;
     if not fStop then pLoadGuide_Brand;
     if not fStop then pLoadGuide_Fabrika;
     if not fStop then pLoadGuide_LineFabrica;
     if not fStop then pLoadGuide_GoodsInfo;
     if not fStop then pLoadGuide_GoodsSize;
     if not fStop then pLoadGuide_Kassa;
     if not fStop then pLoadGuide_Valuta;
     if not fStop then pLoadGuide_Period;
     if not fStop then
     Begin
      pLoadGuide_GoodsGroup;
      cbId_Postgres.Enabled:=False;
      pLoadGuide_GoodsGroup;
      cbId_Postgres.Enabled:=True;
     End;
     if not fStop then pLoadGuide_Discount;
     if not fStop then pLoadGuide_DiscountTools;
     if not fStop then pLoadGuide_Partner;




     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then fromADOConnection.Connected:=false;
     //
     tmpDate2:=NOw;
     if (tmpDate2-tmpDate1)>=1
     then StrTime:=DateTimeToStr(tmpDate2-tmpDate1)
     else begin
               DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
               StrTime:=IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
     end;

     if System.Pos('auto',ParamStr(2))<=0
     then
         if fStop then ShowMessage('Справочники НЕ загружены. Time=('+StrTime+').')
                  else ShowMessage('Справочники загружены. Time=('+StrTime+').') ;
//     else OKPOEdit.Text:=OKPOEdit.Text + ' Guide:'+StrTime;
     //
     fStop:=true;
end;


//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
    myRecordCount1,myRecordCount2:Integer;
begin
 
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKCompleteDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2,tmpDate3:TDateTime;
    Year, Month, saveMonth, Day, Hour, Min, Sec, MSec: Word;
    Year2, Month2, Day2: Word;
    StrTime:String;
    saveStartDate,saveEndDate:TDateTime;
    calcStartDate,calcEndDate:TDateTime;
begin

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSetNullGuide_Id_Postgres;
begin
      fExecSqFromQuery('update dba.Measure set Id_Postgres = null');
      fExecSqFromQuery('update dba.CompositionGroup set Id_Postgres = null');
      fExecSqFromQuery('update dba.Composition set Id_Postgres = null');
      fExecSqFromQuery('update dba.CountryBrand set Id_Postgres = null');
      fExecSqFromQuery('update dba.Brand set Id_Postgres = null');
      fExecSqFromQuery('update dba.Fabrika set Id_Postgres = null');
      fExecSqFromQuery('update dba.LineFabrica set Id_Postgres = null');
      fExecSqFromQuery('update dba.GoodsInfo set Id_Postgres = null');
      fExecSqFromQuery('update dba.GoodsSize set Id_Postgres = null');
      fExecSqFromQuery('update dba.Kassa set Id_Postgres = null');
      fExecSqFromQuery('update dba.Valuta set Id_Postgres = null');
      fExecSqFromQuery('update dba.Period set Id_Postgres = null');
      fExecSqFromQuery('update dba.Goods set Id_Postgres = null');
      fExecSqFromQuery('update dba.Discount set Id_Postgres = null');
      fExecSqFromQuery('update dba.DiscountTools set Id_Postgres = null');
      fExecSqFromQuery('update dba.Unit set Id_Postgres = null');




//      fExecSqFromQuery('update dba. set Id_Postgres = null');
//     if not fStop then pLoadGuide_DiscountTools;


//     fExecSqFromQuery('update dba.Goods set Id_Postgres = null,Id_Postgres_Fuel = null,Id_Postgres_TicketFuel = null');
//     fExecSqFromQuery('update dba.GoodsProperty set Id_Postgres = null');
//     fExecSqFromQuery('update dba.Measure set Id_Postgres = null');
//     fExecSqFromQuery('update dba.CompositionGroup set Id_Postgres = null');
//     fExecSqFromQuery('update dba.KindPackage set Id_Postgres = null');
//     fExecSqFromQuery('update dba.MoneyKind set Id_Postgres = null');
//     fExecSqFromQuery('update dba.ContractKind set Id_Postgres = null');
//     //  !!! Unit.PersonalId_Postgres and Unit.pgUnitId - is by User !!!
//     fExecSqFromQuery('update dba.Unit set Id_Postgres_RouteSorting=null,Id_Postgres_Business = null, Id_Postgres_Business_TWO = null, Id_Postgres_Business_Chapli = null, Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
//     fExecSqFromQuery('update dba._pgPersonal set Id_Postgres = null');
//     fExecSqFromQuery('update dba.PriceList_byHistory set Id_Postgres = null');
//     fExecSqFromQuery('update dba.PriceListItems_byHistory set Id_Postgres = null');
//     fExecSqFromQuery('update dba.GoodsProperty_Postgres set Id_Postgres = null');
//     fExecSqFromQuery('update dba.GoodsProperty_Detail set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null, Id4_Postgres = null, Id5_Postgres = null, Id6_Postgres = null, Id7_Postgres = null'
//                                                       +', Id8_Postgres = null, Id9_Postgres = null, Id10_Postgres = null, Id11_Postgres = null, Id12_Postgres = null, Id13_Postgres = null, Id14_Postgres = null');
//     fExecSqFromQuery('update dba._pgInfoMoney set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
//     fExecSqFromQuery('update dba._pgAccount set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
//     fExecSqFromQuery('update dba._pgProfitLoss set Id1_Postgres = null, Id2_Postgres = null, Id3_Postgres = null');
//     fExecSqFromQuery('update dba._pgUnit set Id_Postgres = null, Id_Postgres_Branch = null');
//
//     fExecSqFromQuery('update dba._pgRoute set RouteId_pg = null, FreightId_pg = null');
//     fExecSqFromQuery('update dba._pgMember set GroupId_pg = null, MemberId_pg = null, PersonalId_pg = null, PositionId_pg = null');
//     fExecSqFromQuery('update dba._pgCar set ModelId_pg = null, CarId_pg = null, MovementId_pg=null');
//     fExecSqFromQuery('update dba._pgCardFuel set CardFuelId_pg = null');
//
//     fExecSqFromQuery('update dba._pgMemberSWT set GroupId_pg = null,MemberId_pg = null,PersonalId_pg = null,PositionId_pg = null,PositionLevelId_pg = null');
//     fExecSqFromQuery('update dba._pgModelService set ModelServiceId_pg = null,ModelServiceItemMasterId_pg = null,ModelServiceItemChildId_pg = null');
//     fExecSqFromQuery('update dba._pgStaffList set PositionId_pg = null,PositionLevelId_pg = null,StaffListSumm_MonthId_pg = null,StaffListSumm_DayId_pg = null,'+'StaffListSumm_PersonalId_pg = null, StaffListSumm_HoursPlanId_pg = null, StaffListSumm_HoursDayId_pg = null, StaffListSumm_HoursPlanConstId_pg = null, StaffListSumm_HoursDayConstId_pg = null, StaffListSumm_HoursOnDayId_pg = null, StaffListId_pg = null');
//     fExecSqFromQuery('update dba._pgStaffListCost set ModelServiceId_pg = null,StaffListId_pg = null,StaffListCostId_pg = null');

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSetNullDocument_Id_Postgres;
begin
//     fExecSqFromQuery('update dba.Bill set Id_Postgres = null where Id_Postgres is not null'); //
//     fExecSqFromQuery('update dba.BillItems set Id_Postgres = null where Id_Postgres is not null');
//     fExecSqFromQuery('update dba.BillItemsReceipt set Id_Postgres = null where Id_Postgres is not null');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGuide_Brand;
begin
    if (not cbBrand.Checked)or(not cbBrand.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.Brand add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbBrand);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Brand.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Brand.BrandName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Brand.Erased as Erased');
        Add('     , Brand.Id_Postgres');
        Add('from dba.Brand');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Brand';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Brand set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbBrand);
end;

procedure TMainForm.pLoadGuide_Composition;
begin
     if (not cbComposition.Checked)or(not cbComposition.Enabled) then exit;
     try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.Composition add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbComposition);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Composition.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Composition.CompositionName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Composition.Erased as Erased');
        Add('     , Composition.Id_Postgres');
        Add('     , Composition_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.Composition');
        Add('     left outer join dba.CompositionGroup as Composition_parent on Composition_parent.Id = Composition.CompositionGroupId');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Composition';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inCompositionGroupId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inCompositionGroupId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             //toStoredProc.Params.ParamByName('inSession').Value:=fGetSession;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Composition set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbComposition);
end;

procedure TMainForm.pLoadGuide_CompositionGroup;
begin
    if (not cbCompositionGroup.Checked)or(not cbCompositionGroup.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.CompositionGroup add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbCompositionGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select CompositionGroup.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , CompositionGroup.CompositionGroupName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , CompositionGroup.Erased as Erased');
        Add('     , CompositionGroup.Id_Postgres');
        Add('from dba.CompositionGroup');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_CompositionGroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
//        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.CompositionGroup set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCompositionGroup);
end;

procedure TMainForm.pLoadGuide_CountryBrand;
begin
   if (not cbCountryBrand.Checked)or(not cbCountryBrand.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.CountryBrand add Id_Postgres integer null;');
    finally

    end;
    if (not cbCountryBrand.Checked)or(not cbCountryBrand.Enabled) then exit;
     //
     myEnabledCB(cbCountryBrand);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select CountryBrand.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , CountryBrand.CountryBrandName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , CountryBrand.Erased as Erased');
        Add('     , CountryBrand.Id_Postgres');
        Add('from dba.CountryBrand');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_CountryBrand';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.CountryBrand set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCountryBrand);
end;

procedure TMainForm.pLoadGuide_Discount;
begin
if (not cbDiscount.Checked)or(not cbDiscount.Enabled) then exit;

  try
   if cbId_Postgres.Checked then
     fExecSqFromQuery('alter table dba.Discount add Id_Postgres integer null;');
  finally

  end;
     //
     myEnabledCB(cbDiscount);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Discount.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Discount.DiscountName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Discount.isErased as Erased');
        Add('     , Discount.Id_Postgres');
        Add('     , KindDiscount');
        Add('from dba.Discount');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Discount';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inKindDiscount',ftFloat,ptInput, 0);

        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //

             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsString;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsString;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inKindDiscount').Value:=FieldByName('KindDiscount').AsInteger;


             if not myExecToStoredProc then;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Discount set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbDiscount);
end;

procedure TMainForm.pLoadGuide_DiscountTools;
begin
     if (not cbDiscountTools.Checked)or(not cbDiscountTools.Enabled) then exit;
     try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.DiscountTools add Id_Postgres integer null;');
    finally

    end;
     //
     myEnabledCB(cbDiscountTools);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select DiscountTools.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     --, DiscountTools.DiscountName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , DiscountTools.isErased as Erased');
        Add('     , DiscountTools.Id_Postgres');
        Add('     , DiscountTools_parent.Id_Postgres as ParentId_Postgres');
        Add('     , DiscountTools.DiscountId as DiscountId');
        Add('     , DiscountTools.StartSumm as StartSumm');
        Add('     , DiscountTools.EndSumm as EndSumm');
        Add('     , DiscountTools.DiscountTax as DiscountTax');
        Add('from dba.DiscountTools');
        Add('     left outer join dba.Discount as DiscountTools_parent on DiscountTools_parent.Id = DiscountTools.DiscountId');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_DiscountTools';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
//        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
//        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inStartSumm',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inEndSumm',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inDiscountTax',ftFloat,ptInput, 0);
        toStoredProc.Params.AddParam ('inDiscountId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin

             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
//             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
//             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inStartSumm').Value:=FieldByName('StartSumm').AsFloat;
             toStoredProc.Params.ParamByName('inEndSumm').Value:=FieldByName('EndSumm').AsFloat;
             toStoredProc.Params.ParamByName('inDiscountTax').Value:=FieldByName('DiscountTax').AsFloat;
             toStoredProc.Params.ParamByName('inDiscountId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.DiscountTools set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbDiscountTools);
end;

procedure TMainForm.pLoadGuide_Fabrika;
begin
    if (not cbFabrika.Checked)or(not cbFabrika.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.Fabrika add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbFabrika);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Fabrika.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Fabrika.FabrikaName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Fabrika.Erased as Erased');
        Add('     , Fabrika.Id_Postgres');
        Add('from dba.Fabrika');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Fabrika';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Fabrika set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbFabrika);
end;

procedure TMainForm.pLoadGuide_GoodsGroup;
begin
    if (not cbGoodsGroup.Checked)or(not cbGoodsGroup.Enabled) then exit;
    try
     if cbId_Postgres.Checked and cbId_Postgres.Enabled then
      fExecSqFromQuery('alter table dba.Goods add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbGoodsGroup);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Goods.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Goods.GoodsName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Goods.Erased as Erased');
        Add('     , Goods.Id_Postgres');
        Add('     , Goods_parent.Id_Postgres as ParentId_Postgres');
        Add('from dba.Goods');
        Add('     left outer join dba.Goods as Goods_parent on Goods_parent.Id = Goods.ParentId');
        Add('where Goods.HasChildren <> zc_hsLeaf()');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_goodsgroup';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inParentId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inParentId').Value:=FieldByName('ParentId_Postgres').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Goods set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoodsGroup);
end;

procedure TMainForm.pLoadGuide_GoodsInfo;
begin
    if (not cbGoodsInfo.Checked)or(not cbGoodsInfo.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.GoodsInfo add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbGoodsInfo);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsInfo.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , GoodsInfo.GoodsInfoName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , GoodsInfo.Erased as Erased');
        Add('     , GoodsInfo.Id_Postgres');
        Add('from dba.GoodsInfo');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_GoodsInfo';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsInfo set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoodsInfo);
end;

procedure TMainForm.pLoadGuide_GoodsSize;
begin
    if (not cbGoodsSize.Checked)or(not cbGoodsSize.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.GoodsSize add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbGoodsSize);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select GoodsSize.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , GoodsSize.GoodsSizeName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , GoodsSize.Erased as Erased');
        Add('     , GoodsSize.Id_Postgres');
        Add('from dba.GoodsSize');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_GoodsSize';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.GoodsSize set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbGoodsSize);
end;

procedure TMainForm.pLoadGuide_Kassa;
begin
    if (not cbKassa.Checked)or(not cbKassa.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.Kassa add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbKassa);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Kassa.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Kassa.KassaName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Kassa.Erased as Erased');
        Add('     , Kassa.Id_Postgres');
        Add('from dba.Kassa');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Kassa';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Kassa set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbKassa);
end;

procedure TMainForm.pLoadGuide_LineFabrica;
begin
    if (not cbLineFabrica.Checked)or(not cbLineFabrica.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.LineFabrica add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbLineFabrica);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select LineFabrica.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , LineFabrica.LineFabricaName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , LineFabrica.Erased as Erased');
        Add('     , LineFabrica.Id_Postgres');
        Add('from dba.LineFabrica');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_LineFabrica';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.LineFabrica set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbLineFabrica);
end;

procedure TMainForm.pLoadGuide_Measure;
var
    InternalCode_pg:String;
    InternalName_pg:String;
begin
  if (not cbMeasure.Checked)or(not cbMeasure.Enabled) then exit;

  try
   if cbId_Postgres.Checked then
     fExecSqFromQuery('alter table dba.Measure add Id_Postgres integer null;');
  finally

  end;
     //
     myEnabledCB(cbMeasure);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Measure.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Measure.MeasureName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Measure.Erased as Erased');
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
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInternalCode',ftString,ptInput, '');
        toStoredProc.Params.AddParam ('inInternalName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //

             fOpenSqToQuery (' select OS_Measure_InternalCode.ValueData  AS InternalCode'
                           +'       , OS_Measure_InternalName.ValueData  AS InternalName'
                           +' from Object'
                           +'         LEFT JOIN ObjectString AS OS_Measure_InternalName'
                           +'                  ON OS_Measure_InternalName.ObjectId = Object.Id'
                           +'                 AND OS_Measure_InternalName.DescId = zc_ObjectString_Measure_InternalName()'
                           +'         LEFT JOIN ObjectString AS OS_Measure_InternalCode'
                           +'                  ON OS_Measure_InternalCode.ObjectId = Object.Id'
                           +'                 AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()'
                           +' where Object.Id='+inttostr(FieldByName('Id_Postgres').AsInteger));



             InternalCode_pg:=toSqlQuery.FieldByName('InternalCode').AsString;
             InternalName_pg:=toSqlQuery.FieldByName('InternalName').AsString;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsString;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsString;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             toStoredProc.Params.ParamByName('inInternalCode').Value:=InternalCode_pg;
             toStoredProc.Params.ParamByName('inInternalName').Value:=InternalName_pg;

             if not myExecToStoredProc then;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Measure set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
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
procedure TMainForm.pLoadGuide_Partner;
begin
if (not cbPartner.Checked)or(not cbPartner.Enabled) then exit;
     try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.Unit add Id_Postgres integer null;');
    finally

    end;
     //
     myEnabledCB(cbPartner);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Partner.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Partner.Erased as Erased');
        Add('     , Partner.Id_Postgres');
        Add('     , Partner.BrandID');
        Add('     , Partner.FabrikaID');
        Add('     , Partner.PeriodID');
        Add('     , Partner.PeriodYear');
        Add('     , Partner_parent_brand.Id_Postgres as ParentId_Postgres_brand');
        Add('     , Partner_parent_fabrika.Id_Postgres as ParentId_Postgres_fabrika');
        Add('     , Partner_parent_Period.Id_Postgres as ParentId_Postgres_Period');
        Add('from dba.Unit as    Partner');
        Add(' left outer join dba.Brand as Partner_parent_brand on Partner_parent_brand.Id =  Partner.BrandID');
        Add(' left outer join dba.Fabrika as Partner_parent_fabrika on Partner_parent_fabrika.Id =  Partner.FabrikaID');
        Add(' left outer join dba.Period as Partner_parent_Period on Partner_parent_Period.Id =  Partner.PeriodID');
        Add('where KindUnit = zc_kuIncome()');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Partner';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inBrandId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inFabrikaId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPeriodId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inPeriodYear',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin

             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inBrandId').Value:=FieldByName('ParentId_Postgres_brand').AsFloat;
             toStoredProc.Params.ParamByName('inFabrikaId').Value:=FieldByName('ParentId_Postgres_fabrika').AsFloat;
             toStoredProc.Params.ParamByName('inPeriodId').Value:=FieldByName('ParentId_Postgres_Period').AsFloat;
             toStoredProc.Params.ParamByName('inPeriodYear').Value:=FieldByName('PeriodYear').AsInteger;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Unit set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbPartner);
end;

procedure TMainForm.pLoadGuide_Period;
begin
    if (not cbPeriod.Checked)or(not cbPeriod.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.Period add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbPeriod);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Period.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Period.PeriodName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Period.Erased as Erased');
        Add('     , Period.Id_Postgres');
        Add('from dba.Period');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Period';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Period set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbPeriod);
end;

procedure TMainForm.pLoadGuide_Valuta;
begin
    if (not cbValuta.Checked)or(not cbValuta.Enabled) then exit;
    try
     if cbId_Postgres.Checked then
      fExecSqFromQuery('alter table dba.Valuta add Id_Postgres integer null;');
    finally

    end;

     //
     myEnabledCB(cbValuta);
     //
     with fromQuery,Sql do begin
        Close;
        Clear;
        Add('select Valuta.Id as ObjectId');
        Add('     , 0 as ObjectCode');
        Add('     , Valuta.ValutaName as ObjectName');
        Add('     , zc_erasedDel() as zc_erasedDel');
        Add('     , Valuta.Erased as Erased');
        Add('     , Valuta.Id_Postgres');
        Add('from dba.Valuta');
        Add('order by ObjectId');
        Open;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpinsertupdate_object_Valuta';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin {EnableControls;}exit;end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Valuta set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbValuta);
end;


end.


{
-- dblog -t D:\Database\Alan\v9ProfiMeating_log D:\Database\Alan\v9ProfiMeating.db
--
-- !!!! в базе сибасе надо создать ключи !!!
--
alter table dba.GoodsProperty_Detail add Id1_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id2_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id3_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id4_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id5_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id6_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id7_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id8_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id9_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id10_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id11_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id12_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id13_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id14_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id15_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id16_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id17_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id18_Postgres integer null;
alter table dba.GoodsProperty_Detail add Id19_pg integer null;
alter table dba.GoodsProperty_Detail add Id20_pg integer null;
alter table dba.GoodsProperty_Detail add Id21_Postgres integer null;

create table dba.GoodsProperty_Postgres (Id integer not null, Name_PG TVarCharMedium not null, Id_Postgres integer null);
insert into dba.GoodsProperty_Postgres (Id, Name_PG)
  select 1, 'АТБ' union all       // +fIsClient_ATB *** GoodsCodeScaner
  select 2, 'Киев ОК' union all   // +fIsClient_OK  *** GoodsCodeScaner_byKievOK
  select 3, 'Метро' union all     // +fIsClient_Metro  fIsClient_MetroTwo *** GoodsCodeScaner_byMetro
  select 4, 'Алан' union all      //                  *** GoodsCodeScaner_byMain
  select 5, 'Фоззи' union all     // +fIsClient_Fozzi fIsClient_FozziM  *** GoodsCodeScaner_byFozzi
  select 6, 'Кишени' union all    // +fIsClient_Kisheni *** GoodsCodeScaner_byKisheni
  select 7, 'Виват' union all     // +fIsClient_Vivat *** GoodsCodeScaner_byVivat
  select 8, 'Билла' union all     // +fIsClient_Billa *** GoodsCodeScaner_byBilla
  select 9, 'Билла-2' union all   // fIsClient_BillaTwo *** Code_byBillaTwo
  select 10, 'Амстор' union all     // +fIsClient_Amstor *** GoodsCodeScaner_byAmstor
  select 11, 'Омега' union all     // ***fIsClient_Omega *** GoodsCodeScaner_byOmega
  select 12, 'Восторг' union all   // ***fIsClient_Vostorg *** GoodsCodeScaner_byVostorg
  select 13, 'Ашан' union all      // +fIsClient_Ashan *** GoodsCodeScaner_byAshan
  select 14, 'Реал' union all      // +fIsClient_Real  *** GoodsCodeScaner_byReal
  select 15, 'ЖД' union all        // ***fIsClient_GD  *** GoodsName_GD
  -- select 16, 'Таврия' union all    // fIsClient_Tavriya *** Code_byTavriya
  select 17, 'Адвентис' union all  // fIsClient_Adventis *** GoodsCodeScaner_byAdventis
  select 18, 'Край'               // fIsClient_Kray *** Code_byKray
  ;                               // ------
                                  // fIsClient_Furshet
                                  // fIsClient_Obgora

insert into dba.GoodsProperty_Postgres (Id, Name_PG,Id_Postgres)
  select 19, 'ВЭД Eng', 300422

insert into dba.GoodsProperty_Postgres (Id, Name_PG,Id_Postgres)
  select 20, 'ВЭД Рус', 300423

insert into dba.GoodsProperty_Postgres (Id, Name_PG,Id_Postgres)
  select 21, 'Кишени-Кулинария', 420377 // +fIsClient_KisheniContract *** GoodsCodeScaner_byKisheni



update dba.GoodsProperty_Postgres set Id = 21 where Id_Postgres = 420377

alter table dba.GoodsProperty_Kachestvo add Id_pg1 integer null;
alter table dba.GoodsProperty_Kachestvo add Id_pg2 integer null;

alter table dba.Receipt_byHistory add Id_pg integer null;
alter table dba.ReceiptItem_byHistory add Id_pg integer null;


alter table dba.Goods add Id_Postgres integer null;
alter table dba.Goods add Id_Postgres_Fuel integer null;
alter table dba.Goods add Id_Postgres_TicketFuel integer null;
alter table dba.GoodsProperty add Id_Postgres integer null;
alter table dba.Measure add Id_Postgres integer null;
alter table dba.KindPackage add Id_Postgres integer null;

alter table dba.MoneyKind add Id_Postgres integer null;
alter table dba.ContractKind add Id_Postgres integer null;

alter table dba.Unit add Id1_Postgres integer null;
alter table dba.Unit add Id2_Postgres integer null;
alter table dba.Unit add Id3_Postgres integer null;
alter table dba.Unit add Id_Postgres_Business integer null;
alter table dba.Unit add Id_Postgres_Business_TWO integer null;
alter table dba.Unit add Id_Postgres_Business_Chapli integer null;
alter table dba.Unit add PersonalId_Postgres integer null;
alter table dba.Unit add pgUnitId integer null;
alter table dba.Unit add Id_Postgres_RouteSorting integer null;

alter table dba._pgUnit add Id_Postgres_Branch integer null;

alter table dba.PriceList_byHistory add Id_Postgres integer null;
alter table dba.PriceListItems_byHistory add Id_Postgres integer null;

alter table dba.Bill add Id_Postgres integer null;
alter table dba.BillItems add Id_Postgres integer null;
alter table dba.BillItemsReceipt add Id_Postgres integer null;
ok

}


{
select 1 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_ATB(Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 2 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_OK(Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 3 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where (fIsClient_Metro(Unit .Id) = zc_rvYes() or fIsClient_MetroTwo(Unit .Id) = zc_rvYes()) and OKPO <> ''
group by OKPO

union all
select 4 as myId -- Алан
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where (fIsClient_Furshet(Unit .Id) = zc_rvYes() or fIsClient_Obgora(Unit .Id) = zc_rvYes()or fIsClient_Tavriya(Unit .Id) = zc_rvYes()) and OKPO <> ''
group by OKPO

union all
select 5 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where (fIsClient_Fozzi(Unit .Id) = zc_rvYes() or fIsClient_FozziM(Unit .Id) = zc_rvYes()) and OKPO <> ''
group by OKPO

union all

select 6 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Kisheni(Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 7 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Vivat (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO


union all
select 8 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Billa (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO


union all
select 10 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Amstor (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO


union all
select 11 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Omega (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO


union all
select 12 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Vostorg (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 13 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Ashan (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 14 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Real (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 15 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_GD (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

-- union all select 16 as myId fIsClient_Tavriya

union all
select 17 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Adventis (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

union all
select 18 as myId
     , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) as OKPO
     , (select Id_Postgres from GoodsProperty_Postgres where Id = myId) as Id_pg
from Unit
     left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                          and Information1.OKPO <> ''
     left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
where fIsClient_Kray (Unit .Id) = zc_rvYes() and OKPO <> ''
group by OKPO

order by 1
}
