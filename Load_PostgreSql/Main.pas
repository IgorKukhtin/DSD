unit Main;

interface

uses
  Windows, Forms, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ZAbstractConnection,
  ZConnection, dsdDB, ZAbstractRODataset, ZAbstractDataset, ZDataset, Data.DB,
  Data.Win.ADODB, Vcl.StdCtrls, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.Controls, Vcl.Samples.Gauges, Vcl.ExtCtrls, System.Classes,
  Vcl.Grids, Vcl.DBGrids, DBTables, dxSkinsCore, dxSkinsDefaultPainters,
  IdBaseComponent, IdComponent, IdIPWatch;

type
  TCurrencyItem = record
    Name:   string;
  end;
  TArrayCurrencyList = array of TCurrencyItem;

  TMainForm = class(TForm)
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    OKGuideButton: TButton;
    GuidePanel: TPanel;
    cbGoodsGroup: TCheckBox;
    cbAllGuide: TCheckBox;
    Gauge: TGauge;
    cbGoods: TCheckBox;
    StopButton: TButton;
    CloseButton: TButton;
    cbMeasure: TCheckBox;
    cbGoodsKind: TCheckBox;
    cbPaidKind: TCheckBox;
    cbContractKind: TCheckBox;
    cbContractFl: TCheckBox;
    cbJuridicalBranchNal: TCheckBox;
    cbPartnerBranchNal: TCheckBox;
    cbBusiness: TCheckBox;
    cbBranch: TCheckBox;
    cbUnitGroup: TCheckBox;
    cbUnit: TCheckBox;
    cbPriceList: TCheckBox;
    cbPriceListItems: TCheckBox;
    cbGoodsProperty: TCheckBox;
    cbGoodsPropertyValue: TCheckBox;
    cbSetNull_Id_Postgres: TCheckBox;
    cbOnlyOpen: TCheckBox;
    DocumentPanel: TPanel;
    cbAllDocument: TCheckBox;
    cbIncomeBN: TCheckBox;
    OKDocumentButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    toSqlQuery: TZQuery;
    StartDateEdit: TcxDateEdit;
    EndDateEdit: TcxDateEdit;
    cbInfoMoneyGroup: TCheckBox;
    cbInfoMoneyDestination: TCheckBox;
    cbInfoMoney: TCheckBox;
    cbAccountGroup: TCheckBox;
    cbAccountDirection: TCheckBox;
    cbAccount: TCheckBox;
    cbProfitLoss: TCheckBox;
    cbProfitLossDirection: TCheckBox;
    cbProfitLossGroup: TCheckBox;
    CompleteDocumentPanel: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    cbAllCompleteDocument: TCheckBox;
    cbCompleteIncomeBN: TCheckBox;
    StartDateCompleteEdit: TcxDateEdit;
    EndDateCompleteEdit: TcxDateEdit;
    cbComplete: TCheckBox;
    cbUnComplete: TCheckBox;
    OKCompleteDocumentButton: TButton;
    cbMember_andPersonal_andRoute: TCheckBox;
    cbTradeMark: TCheckBox;
    cbIncomePacker: TCheckBox;
    cbSendUnit: TCheckBox;
    cbSendPersonal: TCheckBox;
    cbSendUnitBranch: TCheckBox;
    cbSaleIntNal: TCheckBox;
    cbReturnOutBN: TCheckBox;
    cbReturnInIntNal: TCheckBox;
    cbProductionUnion: TCheckBox;
    cbProductionSeparate: TCheckBox;
    cbLoss: TCheckBox;
    cbInventory: TCheckBox;
    cbOrderExternal: TCheckBox;
    cbOnlyOpenMI: TCheckBox;
    cbCompleteSend: TCheckBox;
    cbCompleteSendOnPrice: TCheckBox;
    cbInsertHistoryCost: TCheckBox;
    cbCompleteProductionUnion: TCheckBox;
    cbCompleteProductionSeparate: TCheckBox;
    cbRouteSorting: TCheckBox;
    toStoredProc: TdsdStoredProc;
    toStoredProc_two: TdsdStoredProc;
    cbLastComplete: TCheckBox;
    cbCompleteInventory: TCheckBox;
    cbCompleteSaleIntNal: TCheckBox;
    toZConnection: TZConnection;
    cbFuel: TCheckBox;
    cbCar: TCheckBox;
    cbRoute: TCheckBox;
    cbCardFuel: TCheckBox;
    cbTicketFuel: TCheckBox;
    cbModelService: TCheckBox;
    cbStaffList: TCheckBox;
    cbMember_andPersonal_SheetWorkTime: TCheckBox;
    cbCompleteReturnInIntNal: TCheckBox;
    cbOnlyInsertDocument: TCheckBox;
    cbData1CLink: TCheckBox;
    cbCompleteReturnOutBN: TCheckBox;
    cbTaxFl: TCheckBox;
    cbTaxCorrective: TCheckBox;
    cbReturnInInt: TCheckBox;
    cbSaleInt: TCheckBox;
    cbContractInt: TCheckBox;
    cbJuridicalInt: TCheckBox;
    cbPartnerInt: TCheckBox;
    cbCompleteSaleInt: TCheckBox;
    cbCompleteReturnInInt: TCheckBox;
    OKPOEdit: TEdit;
    cbOKPO: TCheckBox;
    cbDeleteFl: TCheckBox;
    cbDeleteInt: TCheckBox;
    cbTaxInt: TCheckBox;
    cbClearDelete: TCheckBox;
    cbOnlyUpdateInt: TCheckBox;
    cbErr: TCheckBox;
    cbTotalTaxCorr: TCheckBox;
    cbCompleteTaxFl: TCheckBox;
    cbCompleteTaxCorrective: TCheckBox;
    cbCompleteTaxInt: TCheckBox;
    cblTaxPF: TCheckBox;
    cbUpdateConrtact: TCheckBox;
    cbBill_List: TCheckBox;
    cbSelectData_afterLoad: TCheckBox;
    cbSelectData_afterLoad_Sale: TCheckBox;
    cbSelectData_afterLoad_Tax: TCheckBox;
    cbSelectData_afterLoad_ReturnIn: TCheckBox;
    UnitIdEdit: TEdit;
    Label5: TLabel;
    cbBeforeSave: TCheckBox;
    Label6: TLabel;
    SessionIdEdit: TEdit;
    cbGoodsProperty_Detail: TCheckBox;
    cbIncomeNal: TCheckBox;
    cbReturnOutNal: TCheckBox;
    cbCompleteIncomeNal: TCheckBox;
    cbCompleteReturnOutNal: TCheckBox;
    toStoredProc_three: TdsdStoredProc;
    cbPartner_Income: TCheckBox;
    toSqlQuery_two: TZQuery;
    cb1Find2InsertPartner1C_BranchNal: TCheckBox;
    cbJuridicalGroup: TCheckBox;
    cbPartner_Sale: TCheckBox;
    cbOrderInternal: TCheckBox;
    cbCompleteOrderExternal: TCheckBox;
    cbCompleteOrderInternal: TCheckBox;
    cbLossDebt: TCheckBox;
    cbCash: TCheckBox;
    cbCompleteCash: TCheckBox;
    cbCompleteLoss: TCheckBox;
    cbLossGuide: TCheckBox;
    cbCompleteLossNotError: TCheckBox;
    cbWeighingPartner: TCheckBox;
    cbWeighingProduction: TCheckBox;
    cbComplete_List: TCheckBox;
    cbBranchSendOnPrice: TCheckBox;
    UnitCodeSendOnPriceEdit: TEdit;
    cbFillSoldTable: TCheckBox;
    cbGoodsQuality: TCheckBox;
    cbQuality: TCheckBox;
    cbReceiptChild: TCheckBox;
    cbReceipt: TCheckBox;
    cbContractConditionDocument: TCheckBox;
    cbGoodsByGoodsKind: TCheckBox;
    cbOrderType: TCheckBox;
    cbPartnerIntUpdate: TCheckBox;
    cbCompleteIncome_UpdateConrtact: TCheckBox;
    cbInsertHistoryCost_andReComplete: TCheckBox;
    cbDocERROR: TCheckBox;
    cbShowContract: TCheckBox;
    cbPrintKindItem: TCheckBox;
    cbShowAll: TCheckBox;
    cbDefroster: TCheckBox;
    cbPack: TCheckBox;
    cbKopchenie: TCheckBox;
    cbPartion: TCheckBox;
    cbHistoryCost_diff: TCheckBox;
    cbLastCost: TCheckBox;
    cb100MSec: TCheckBox;
    cbOnlySale: TCheckBox;
    cbReturnIn_Auto: TCheckBox;
    cbGoodsListSale: TCheckBox;
    cbOnlyTwo: TCheckBox;
    cbPromo: TCheckBox;
    cbFillAuto: TCheckBox;
    cbCurrency: TCheckBox;
    BranchEdit: TEdit;
    LogPanel: TPanel;
    PanelErr: TPanel;
    LogMemo: TMemo;
    zConnection_vacuum: TZConnection;
    Timer: TTimer;
    fromZQuery: TZQuery;
    fromSqlZQuery: TZQuery;
    fromZQuery_two: TZQuery;
    fromZQueryDate_recalc: TZQuery;
    fromZQueryDate: TZQuery;
    fromZConnection: TZConnection;
    ZConnection_test: TZConnection;
    ZQuery_test: TZQuery;
    EditRepl1: TEdit;
    EditRepl2: TEdit;
    LogMemo2: TMemo;
    ZQuery_test2: TZQuery;
    EditRepl3: TEdit;
    cbRepl4: TCheckBox;
    procedure cbAllGuideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure cbAllDocumentClick(Sender: TObject);
    procedure cbAllCompleteDocumentClick(Sender: TObject);
    procedure cbCompleteClick(Sender: TObject);
    procedure cbUnCompleteClick(Sender: TObject);
    procedure cbCompleteIncomeBNClick(Sender: TObject);
    procedure OKCompleteDocumentButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure PanelErrDblClick(Sender: TObject);
    procedure OKDocumentButtonClick(Sender: TObject);
  private
    fStop:Boolean;
    isGlobalLoad,zc_rvYes,zc_rvNo:Integer;
    zc_Enum_PaidKind_FirstForm,zc_Enum_PaidKind_SecondForm:Integer;

    GroupId_branch : Integer;
    beginVACUUM : Integer;
    beginVACUUM_ii : Integer;
    fStartProcess : Boolean;

    ArrayCurrencyList : TArrayCurrencyList;

    procedure AddToLog(num, lMovementId : Integer; S: string);

    procedure EADO_EngineErrorMsg(E:EADOError);
    procedure EDB_EngineErrorMsg(E:EDBEngineError);
    function myExecToStoredProc:Boolean;
    function myExecToStoredProc_two:Boolean;
    function myExecToStoredProc_three:Boolean;

    procedure myShowSql(mySql:TStrings);
    procedure MyDelay(mySec:Integer);

    function myReplaceStr(const S, Srch, Replace: string): string;
    function FormatToVarCharServer_notNULL(_Value:string):string;
    function FormatToVarCharServer_isSpace(_Value:string):string;
    function FormatToDateServer_notNULL(_Date:TDateTime):string;
    function FormatToDateTimeServer(_Date:TDateTime):string;

    function fOpenFromZQuery (mySql:String):Boolean;
    function fOpenSqlFromZQuery (mySql:String):Boolean;
    function fExecSqlFromZQuery (mySql:String):Boolean;

    function fOpenSqToQuery (mySql:String):Boolean;
    function fExecSqToQuery (mySql:String):Boolean;
    function fOpenSqToQuery_two (mySql:String):Boolean;
    function fExecSqToQuery_two (mySql:String):Boolean;
    function fExecSqToQuery_noErr_two (mySql:String):Boolean;



    procedure pInsertHistoryCost(isFirst:Boolean);
    procedure pInsertHistoryCost_Period(StartDate,EndDate:TDateTime;isPeriodTwo:Boolean);
    procedure pSelectData_afterLoad;

    // DocumentsCompelete :
    procedure pCompleteDocument_List(isBefoHistoryCost,isPartion,isDiff:Boolean);
    procedure pCompleteDocument_Defroster;
    procedure pCompleteDocument_Pack;
    procedure pCompleteDocument_Kopchenie;
    procedure pCompleteDocument_Partion;
    procedure pCompleteDocument_Diff;
    procedure pCompleteDocument_ReturnIn_Auto;
    procedure pCompleteDocument_Promo;
    procedure pCompleteDocument_Currency;

    // Documents :

    procedure pLoadFillSoldTable;
    procedure pLoadFillSoldTable_curr;
    procedure pLoadGoodsListSale;
    procedure pLoadFillAuto;

    // Guides :


    procedure pLoad_https_Currency_all;
    procedure pLoad_https_Currency(OperDate : TDateTime);
    function GetArrayCurrencyList_Index_byName (Name:String):Integer;

    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);

    procedure myLogMemo_add(str :String);
    function fBeginVACUUM : Boolean;

    function fBeginPack_oneDay : Boolean;
    function fBeginPartion_Period : Boolean;

  public
    procedure StartProcess;
  end;


var
  MainForm: TMainForm;

implementation
uses Authentication, CommonData, Storage, SysUtils, Dialogs, Graphics, XMLIntf, XMLDoc, IdHTTP
, IdTCPConnection, IdTCPClient, IdSSLOpenSSL;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.GetArrayCurrencyList_Index_byName (Name:String):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayCurrencyList)-1 do
    if ArrayCurrencyList[i].Name = Name then begin Result:=i;break;end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoad_https_Currency_all;
var i,count: Integer;
begin
    if (not cbCurrency.Checked)or(not cbCurrency.Enabled) then exit;
    //
    toStoredProc_two.StoredProcName:='gpInsertUpdate_Movement_Currency_https';
    toStoredProc_two.OutputType := otResult;
    toStoredProc_two.Params.Clear;
    toStoredProc_two.Params.AddParam ('inOperDate',ftDateTime,ptInput, 0);
    toStoredProc_two.Params.AddParam ('inAmount_text',ftString,ptInput, '');
    toStoredProc_two.Params.AddParam ('inInternalName',ftString,ptInput, '');
    //
    count:= 0;
    while StrToDate(StartDateCompleteEdit.Text) + count <= StrToDate(EndDateCompleteEdit.Text)
    do count:= count + 1;
    //
    for i:= 0 to count
    do
       pLoad_https_Currency(StrToDate(StartDateCompleteEdit.Text) + i);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoad_https_Currency(OperDate : TDateTime);
  var XML : IXMLDocument; RootNode, xmlNode: IXMLNode;
      i:Integer;
          function GetHTTPjson(AURL : string) : String;
            var  mStream: TMemoryStream;
                 IdHTTP: TIdHTTP;
                 IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
          begin
            Result := '';

            IdHTTP := TIdHTTP.Create(Nil);
            IdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
            IdHTTP.IOHandler := IdSSLIOHandlerSocketOpenSSL;
            mStream := TMemoryStream.Create;

            try
              IdHTTP.Request.ContentType := 'application/xml';
              IdHTTP.Request.ContentEncoding := 'utf-8';
              IdHTTP.Request.CustomHeaders.FoldLines := False;

              try
                Result := IdHTTP.Get(AURL);
              except
              end;
            finally
              mStream.Free;
              IdHTTP.Free;
              IdSSLIOHandlerSocketOpenSSL.Free;
            end;
          end;
begin
//  Memo1.Lines.Clear;
  XML := TXMLDocument.Create(nil);
  XML.XML.Text := GetHTTPjson('https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?date='
                             + FormatDateTime('YYYYMMDD', OperDate)
                             );
  if XML.XML.Text <> '' then
  begin
    XML.Active := True;
    RootNode := XML.DocumentElement;
    for i :=0 to RootNode.ChildNodes.Count-1 do
    begin
      {if (RootNode.ChildNodes[i].ChildNodes['cc'].Text = 'EUR')
      then begin
          ShowMessage (RootNode.ChildNodes[i].ChildNodes['cc'].Text);
          ShowMessage (RootNode.ChildNodes[i].NodeName);
          ShowMessage (IntToStr(GetArrayCurrencyList_Index_byName (RootNode.ChildNodes[i].ChildNodes['cc'].Text)));
          ShowMessage (ArrayCurrencyList[0].Name);
          ShowMessage (ArrayCurrencyList[1].Name);
      end;}

      if (RootNode.ChildNodes[i].NodeName = 'currency')
      and (GetArrayCurrencyList_Index_byName (RootNode.ChildNodes[i].ChildNodes['cc'].Text) >= 0)
      //and (RootNode.ChildNodes[i].ChildNodes['r030'].Text = '840')
      then begin
               toStoredProc_two.Params.ParamByName('inOperDate').Value:=OperDate;
               toStoredProc_two.Params.ParamByName('inAmount_text').Value:=RootNode.ChildNodes[i].ChildNodes['rate'].Text;
               toStoredProc_two.Params.ParamByName('inInternalName').Value:=RootNode.ChildNodes[i].ChildNodes['cc'].Text;
               if not myExecToStoredProc_two then ;

//        Memo1.Lines.Add(RootNode.ChildNodes[i].ChildNodes['r030'].Text);
//        Memo1.Lines.Add(RootNode.ChildNodes[i].ChildNodes['txt'].Text);
//        Memo1.Lines.Add(RootNode.ChildNodes[i].ChildNodes['rate'].Text);
//        Memo1.Lines.Add(RootNode.ChildNodes[i].ChildNodes['exchangedate'].Text);

      end;
    end;
    XML.Active := False;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StopButtonClick(Sender: TObject);
begin
     if MessageDlg('������������� ���������� ��������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     fStop:=true;
     DBGrid.Enabled:=true;
     //OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
end;
procedure TMainForm.TimerTimer(Sender: TObject);
begin
     if fStartProcess = true then exit;
     try
        Timer.Enabled:= false;
        //
        fBeginVACUUM;
     finally
        Timer.Enabled:= true;
     end;
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
     if not fStop then
       if MessageDlg('������������� ���������� �������� � �����?',mtConfirmation,[mbYes,mbNo],0)=mrYes then fStop:=true;
     //
     if fStop then Close;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenFromZQuery(mySql:String):Boolean;
begin
     //fromZConnection.Connected:=false;
     //
     with fromZQuery,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenFromZQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqlFromZQuery(mySql:String):Boolean;
begin
     //fromZConnection.Connected:=false;
     //
     with fromSqlZQuery,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqlFromZQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqlFromZQuery(mySql:String):Boolean;
begin
     //fromZConnection.Connected:=false;
     //
     with fromSqlZQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqlFromZQuery'+#10+#13+mySql);Result:=false;exit;end;
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
function TMainForm.fExecSqToQuery_noErr_two(mySql:String):Boolean;
begin
     with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except Result:=false;exit;end;
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
     //result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+chr(39);
     result:=chr(39)+IntToStr(Day)+'.'+IntToStr(Month)+'.'+IntToStr(Year)+chr(39);
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
     //else result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+' '+IntToStr(AHour)+':'+IntToStr(AMinute)+':'+IntToStr(ASecond)+chr(39);
     else result:=chr(39)+IntToStr(Day)+'.'+IntToStr(Month)+'.'+IntToStr(Year)+' '+IntToStr(AHour)+':'+IntToStr(AMinute)+':'+IntToStr(ASecond)+chr(39);
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
procedure TMainForm.AddToLog(num, lMovementId : Integer; S: string);
var
  LogFileName: string;
  LogFile: TextFile;
begin
  Application.ProcessMessages;

  LogFileName := ChangeFileExt(Application.ExeName, '') + '\' + FormatDateTime('yyyy-mm-dd', Date) + '-ERR' + '.log';
  ForceDirectories(ChangeFileExt(Application.ExeName, ''));

  AssignFile(LogFile, LogFileName);

  if FileExists(LogFileName) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  WriteLn(LogFile, DateTimeToStr(Now) + ' : ');
  Writeln(LogFile, '� '+IntToStr(num)+' : '+IntToStr(lMovementId));
  Writeln(LogFile, s);
  WriteLn(LogFile, '');
  CloseFile(LogFile);
  Application.ProcessMessages;
  PanelErr.Caption:= '� '+IntToStr(num)+' : '+IntToStr(lMovementId);
  Application.ProcessMessages;
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
     for i:=0 to ComponentCount-1 do
        if (Components[i] is TCheckBox) then
          if Components[i].Tag=30
          then TCheckBox(Components[i]).Checked:=cbAllCompleteDocument.Checked;
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
      cbUnComplete.Checked:=cbComplete.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbUnCompleteClick(Sender: TObject);
begin
      //cbComplete.Checked:=cbUnComplete.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbCompleteIncomeBNClick(Sender: TObject);
begin
     if (not cbComplete.Checked)and(not cbUnComplete.Checked)then cbComplete.Checked:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  i : Integer;
begin
     try if Pos('br-', ParamStr(5)) = 1 then GroupId_branch:= StrToInt(Copy(ParamStr(5), 4, 2));
         BranchEdit.Text:= 'BranchId : ' + IntToStr(GroupId_branch);
     except GroupId_branch:= -1;
            BranchEdit.Text:= '!!!ERROR!!! BranchId : ???';
     end;
     //
     beginVACUUM:=0;
     beginVACUUM_ii:=0;
     Timer.Enabled:= (ParamStr(2)='autoALL') and (BranchEdit.Text = 'BranchId : 0');
     fStartProcess:= false;
     //
     Gauge.Visible:=false;
     Gauge.Progress:=0;
     //
     zc_rvYes:=0;
     zc_rvNo:=1;
     //
     try
         if ParamStr(1)='alan_dp_ua' then
         with toZConnection do begin
            Connected:=false;
            HostName:='integer-srv.alan.dp.ua';
            User:='admin';
            Password:='vas6ok';
            Database:='project';
            Connected:=true;
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
            Database:='project';
            Connected:=true;
            //
            isGlobalLoad:=zc_rvYes;
            if Connected
            then Self.Caption:= Self.Caption + ' : ' + HostName + ' : TRUE'
            else Self.Caption:= Self.Caption + ' : ' + HostName + ' : FALSE';
            Connected:=false;
         end
         else
         //PROJECT-WMS-1
         with toZConnection do begin
            Connected:=false;
            HostName:='192.168.0.194';
            User:='admin';
            Password:='vas6ok';
            Database:='project_master';
            Connected:=true;
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
         fromZConnection.Connected:=false;
         fromZConnection.HostName:=toZConnection.HostName;
         fromZConnection.User:=toZConnection.User;
         fromZConnection.Password:=toZConnection.Password;
         fromZConnection.Database:=toZConnection.Database;
         fromZConnection.Connected:=true;
         fromZConnection.Connected:=false;
     except
          ShowMessage ('not Connected');
     end;
     //
     //cbAllGuide.Checked:=true;
     //
     fStop:=true;
     //
     Present:= Now;
     DecodeDate(Present, Year, Month, Day);
     StartDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year)));
     StartDateCompleteEdit.Text:=StartDateEdit.Text;

     if Month=12 then begin Month:=1;Year:=Year+1;end else Month:=Month+1;
     EndDateEdit.Text:=DateToStr(StrToDate('01.'+IntToStr(Month)+'.'+IntToStr(Year))-1);
     EndDateCompleteEdit.Text:=EndDateEdit.Text;
     //
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', 'qsxqsxw1', gc_User);
     //
     try
         fOpenSqToQuery ('select zc_Enum_PaidKind_FirstForm from zc_Enum_PaidKind_FirstForm()');
         zc_Enum_PaidKind_FirstForm:=toSqlQuery.FieldByName('zc_Enum_PaidKind_FirstForm').AsInteger;
         fOpenSqToQuery ('select zc_Enum_PaidKind_SecondForm from zc_Enum_PaidKind_SecondForm()');
         zc_Enum_PaidKind_SecondForm:=toSqlQuery.FieldByName('zc_Enum_PaidKind_SecondForm').AsInteger;
     except
          ShowMessage ('not zc_Enum_PaidKind_FirstForm + zc_Enum_PaidKind_SecondForm');
     end;
     //
     try
         fOpenSqToQuery ('select * from gpComplete_SelectAll_Sybase_Currency_List()');
         SetLength(ArrayCurrencyList,toSqlQuery.RecordCount);
         toSqlQuery.First;
         i:=0;
         for i:= 0 to toSqlQuery.RecordCount - 1
         do begin
              ArrayCurrencyList[i].Name := toSqlQuery.FieldByName('InternalName').AsString;
              toSqlQuery.Next;
         end;
     except
          ShowMessage ('not gpComplete_SelectAll_Sybase_Currency_List');
     end;
     //
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormShow(Sender: TObject);
begin

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StartProcess;
    procedure autoNal(isOneDay: Boolean);
    begin
    end;
    procedure autoBN (isOneDay: Boolean);
    begin
    end;
    procedure autoGuide;
    begin
    end;

    procedure autoALL (isOneDay: Boolean);
    var Day_ReComplete:Integer;
    begin
               try Day_ReComplete:=StrToInt(ParamStr(3));
               except Day_ReComplete:=10
               end;
               //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthStart('+FormatToDateServer_notNULL(Date-Day_ReComplete)+') as RetV');
               fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(Date-Day_ReComplete)+' AS TDateTime)) as RetV');
               StartDateCompleteEdit.Text:=DateToStr(fromSqlZQuery.FieldByName('RetV').AsDateTime);
               EndDateCompleteEdit.Text:=DateToStr(Date-1);

               myLogMemo_add('autoALL('+IntToStr(Day_ReComplete)+'Day)');
               UnitCodeSendOnPriceEdit.Text:='autoALL('+IntToStr(Day_ReComplete)+'Day)';

               //�������� ��������
               cbReturnIn_Auto.Checked:=true;
               //������ �����
               cbPromo.Checked:=true;
               //������ Currency
               cbCurrency.Checked:=true;

               //��������+�����������
               cbComplete.Checked:=true;
               cbUnComplete.Checked:=true;
               cbLastComplete.Checked:=false;
               //�/�
               cbInsertHistoryCost.Checked:=true;
               //�� ������
               cbComplete_List.Checked:=true;
               //� ���������
               //cb100MSec.Checked:=true;

               OKCompleteDocumentButtonClick(Self);
end;

var Day_ReComplete:Integer;
begin
  try
     fStartProcess:= TRUE;
     // !!!�����!!!
     cbOnlySale.Checked:=  System.Pos('_SALE',ParamStr(2))>0;

     if (ParamStr(2)='autoPack_oneDay')
     then fBeginPack_oneDay;

     if (ParamStr(2)='autoPartion_period')
     then fBeginPartion_Period;

     if (ParamStr(2)='autoFillSoldTable_curr')
     then pLoadFillSoldTable_curr;


     if (ParamStr(2)='autoFillSoldTable') or (ParamStr(2)='autoFillGoodsList')
     then begin
             //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthStart('+FormatToDateServer_notNULL(Date-28)+') as RetV');
               fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(Date-28)+' AS TDateTime)) as RetV');
               StartDateEdit.Text:=DateToStr(fromSqlZQuery.FieldByName('RetV').AsDateTime);

             //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthEnd('+FormatToDateServer_notNULL(Date-28)+') as RetV');
               fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(Date-28)+' AS TDateTime)) + INTERVAL ' + FormatToVarCharServer_notNULL('1 MONTH') + ' - INTERVAL ' + FormatToVarCharServer_notNULL('1 DAY') + ' as RetV');
               EndDateEdit.Text:=DateToStr(fromSqlZQuery.FieldByName('RetV').AsDateTime);
               //if Date<fromSqlZQuery.FieldByName('RetV').AsDateTime
               //then EndDateEdit.Text:=DateToStr(Date-1)
               //else EndDateEdit.Text:=DateToStr(fromSqlZQuery.FieldByName('RetV').AsDateTime);

               // ������� �����
             //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthEnd('+FormatToDateServer_notNULL(Date-5)+') as RetV');
               fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(Date-5)+' AS TDateTime)) + INTERVAL ' + FormatToVarCharServer_notNULL('1 MONTH') + ' - INTERVAL ' + FormatToVarCharServer_notNULL('1 DAY') + ' as RetV');

               // !!!���� �������� - ������!!!
               cbGoodsListSale.Checked:=true;

               // !!!���� �������� - �����!!!
               if (ParamStr(2)='autoFillSoldTable')
               then cbFillAuto.Checked:=true;

               // !!!�� "�������" - �� ����!!! + ��� ���� ...
               if  ((EndDateEdit.Text <> DateToStr(fromSqlZQuery.FieldByName('RetV').AsDateTime))
                 or (ParamStr(3)='++')
                   )
                and (ParamStr(2)='autoFillSoldTable')
               then begin
                    cbFillSoldTable.Checked:=true;
               end
               else
                    cbFillSoldTable.Checked:=false;
               //���������
               OKDocumentButtonClick(Self);
     end;


     if ((ParamStr(2)='autoALL')or(ParamStr(2)='autoALL_SALE'))
     then begin
              if (BranchEdit.Text = 'BranchId : 0') then
              begin
                 cbPack.Checked:=TRUE;
                 cbKopchenie.Checked:=TRUE;
                 cbPartion.Checked:=TRUE;
              end;
              //
              autoALL(true);
     end;
     if (ParamStr(2)='autoALLLAST')or(ParamStr(2)='autoALLLAST_SALE')
     then begin
               cbLastCost.Checked:=TRUE;
               cbHistoryCost_diff.Checked:=TRUE;
               autoALL(true);
     end;

     if ParamStr(2)='auto'
     then begin
          end;
     if ParamStr(2)='autoReComplete'
     then begin
          end;
  finally
     fStartProcess:= FALSE;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSelectData_afterLoad;
var UnitId_str,DescId_str,SessionId_str:String;
begin
     try StrToInt(SessionIdEdit.Text);SessionId_str:=SessionIdEdit.Text; except SessionId_str:='0';end;
     if SessionId_str='0'
     then SessionId_str:='OperDate BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
     else SessionId_str:='SessionId='+SessionId_str;

     //
     DescId_str:='';
     if cbSelectData_afterLoad_Sale.Checked then DescId_str:='zc_Movement_Sale()';
     if cbSelectData_afterLoad_Tax.Checked then if DescId_str<>'' then DescId_str:=DescId_str+',zc_Movement_Tax()' else DescId_str:='zc_Movement_Tax()';
     if cbSelectData_afterLoad_ReturnIn.Checked then if DescId_str<>'' then DescId_str:=DescId_str+',zc_Movement_ReturnIn()' else DescId_str:='zc_Movement_ReturnIn()';
     DescId_str:='('+DescId_str+')';
     //
     try StrToInt(UnitIdEdit.Text);UnitId_str:=UnitIdEdit.Text; except UnitId_str:='0';end;
     //
     fOpenSqToQuery (
          ' SELECT Count(*) as calcCount, min(MovementItemId)AS minId,max(MovementItemId) AS  maxId'
    +trim('     , (SELECT MAX (SessionId) FROM _testMI_afterLoad WHERE '+SessionId_str+') AS SessionId_max')
    +trim('     , (SELECT MIN (SessionId) FROM _testMI_afterLoad WHERE '+SessionId_str+') AS SessionId_min')
    +     ' FROM'
    +trim('(SELECT tmpAll.MovementId')
    +trim('      , tmpAll.InvNumber')
    +trim('      , tmpAll.OperDate')
    +trim('      , tmpAll.OperDatePartner')
    +trim('      , tmpAll.PaidKindId')
    +trim('      , tmpAll.MovementItemId')
    +trim('      , tmpAll.GoodsId')
    +trim('      , tmpAll.Price')
    +trim('      , tmpAll.OperDate')
    +     ' FROM (SELECT MovementId'
    +trim('            , InvNumber')
    +trim('            , OperDate')
    +trim('            , OperDatePartner')
    +trim('            , PaidKindId')
    +trim('            , MovementItemId')
    +trim('            , GoodsId')
    +trim('            , AmountPartner')
    +trim('            , 0 AS AmountPartnerNew')
    +trim('            , Amount')
    +trim('            , 0 AS AmountNew')
    +trim('            , Price')
    +     '       FROM (SELECT MAX (SessionId) AS Id FROM _testMI_afterLoad WHERE '+SessionId_str+') as tmpSession'
    +     '            INNER JOIN _testMI_afterLoad ON _testMI_afterLoad.SessionId = tmpSession.Id'
    //+     '        WHERE _testMI_afterLoad.OperDate BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +     '        WHERE _testMI_afterLoad.OperDatePartner BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +     '         AND _testMI_afterLoad.DescId IN '+DescId_str
    +     '         AND _testMI_afterLoad.StatusId = zc_Enum_Status_Complete()'
    +     '         AND _testMI_afterLoad.isErased = FALSE'
    +     '         AND _testMI_afterLoad.PaidKindId = zc_Enum_PaidKind_FirstForm()'
    +     '         AND (_testMI_afterLoad.FromId = '+UnitId_str+' or 0='+UnitId_str+')' // 8459-����� ����������
    +     '      UNION ALL'
    +     '       SELECT Movement.Id AS MovementId'
    +trim('            , Movement.InvNumber')
    +trim('            , Movement.OperDate')
    +trim('            , CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MovementDate_OperDatePartner.ValueData ELSE Movement.OperDate END AS OperDatePartner')
    +trim('            , MLO_PaidKind.ObjectId AS PaidKindId')
    +trim('            , MovementItem.Id AS MovementItemId')
    +trim('            , MovementItem.ObjectId AS GoodsId')
    +trim('            , 0 AS AmountPartner')
    +trim('            , COALESCE (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END, 0) AS AmountPartnerNew')
    +trim('            , 0 AS Amount')
    +trim('            , MovementItem.Amount as AmountNew')
    +trim('            , COALESCE (MIFloat_Price.ValueData, 0) AS Price')
    +     '       FROM Movement'
+' '+trim('            LEFT JOIN MovementLinkObject AS MLO_From')
+' '+trim('                                         ON MLO_From.MovementId = Movement.Id')
+' '+trim('                                        AND MLO_From.DescId = zc_MovementLinkObject_From()')
+' '+trim('            LEFT JOIN MovementLinkObject AS MLO_To')
+' '+trim('                                         ON MLO_To.MovementId = Movement.Id')
+' '+trim('                                        AND MLO_To.DescId = zc_MovementLinkObject_To()')
+' '+trim('            LEFT JOIN MovementLinkObject AS MLO_Contract')
+' '+trim('                                         ON MLO_Contract.MovementId = Movement.Id')
+' '+trim('                                        AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()')
+' '+trim('            LEFT JOIN MovementLinkObject AS MLO_PaidKind')
+' '+trim('                                         ON MLO_PaidKind.MovementId = Movement.Id')
+' '+trim('                                        AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()')
+' '+trim('            LEFT JOIN MovementDate AS MovementDate_OperDatePartner')
+' '+trim('                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id')
+' '+trim('                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()')
+' '+trim('            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id')
+' '+trim('                                   AND MovementItem.isErased = FALSE')
+' '+trim('            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner')
+' '+trim('                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id')
+' '+trim('                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()')
+' '+trim('            LEFT JOIN MovementItemFloat AS MIFloat_Price')
+' '+trim('                                        ON MIFloat_Price.MovementItemId = MovementItem.Id')
+' '+trim('                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()')
    +     '       WHERE Movement.DescId IN '+DescId_str
    +     '         AND Movement.StatusId = zc_Enum_Status_Complete()'
    //+     '         AND Movement.OperDate BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +     '         AND MovementDate_OperDatePartner.ValueData BETWEEN '+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+' AND '+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))
    +     '         AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()'
    +     '         AND (MLO_From.ObjectId = '+UnitId_str+' or 0='+UnitId_str+')' // 8459-����� ����������
    +     '      ) AS tmpAll'
    +     ' GROUP BY tmpAll.MovementId'
    +trim('        , tmpAll.InvNumber')
    +trim('        , tmpAll.OperDate')
    +trim('        , tmpAll.OperDatePartner')
    +trim('        , tmpAll.PaidKindId')
    +trim('        , tmpAll.MovementItemId')
    +trim('        , tmpAll.GoodsId')
    +trim('        , tmpAll.Price')
    +trim('        , tmpAll.OperDate')
    +     ' HAVING SUM (tmpAll.AmountPartner) <> SUM (tmpAll.AmountPartnerNew)'
    +     ') AS tmp'
    );

     if toSqlQuery.FieldByName('calcCount').AsInteger=0
     then ShowMessage('������ ���.������ � <'+toSqlQuery.FieldByName('SessionId_max').AsString+'> min('+toSqlQuery.FieldByName('SessionId_min').AsString+')')
     else ShowMessage('������ ����.������ � <'+toSqlQuery.FieldByName('SessionId_max').AsString+'> ���-��=<'+toSqlQuery.FieldByName('calcCount').AsString+'> min=<'+toSqlQuery.FieldByName('minId').AsString+'> max=<'+toSqlQuery.FieldByName('maxId').AsString+'')

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fBeginVACUUM : Boolean;
var Second, MSec: word;
    Hour_calc, Minute_calc: word;
    ZQuery: TZQuery;

          function lVACUUM (lStr : String): Boolean;
          begin
               ZQuery.Sql.Clear;;
               ZQuery.Sql.Add (lStr);
               ZQuery.ExecSql;
               //myLogMemo_add(lStr);
               //Sleep(500);
          end;
          function lVACUUM_all (isVA : Boolean) : Boolean;
          begin
               // System - FULL
               lVACUUM ('VACUUM FULL pg_catalog.pg_statistic');
               lVACUUM ('VACUUM FULL pg_catalog.pg_attribute');
               lVACUUM ('VACUUM FULL pg_catalog.pg_class');
               lVACUUM ('VACUUM FULL pg_catalog.pg_type');
               lVACUUM ('VACUUM FULL pg_catalog.pg_depend');
               lVACUUM ('VACUUM FULL pg_catalog.pg_shdepend');
               lVACUUM ('VACUUM FULL pg_catalog.pg_index');
               lVACUUM ('VACUUM FULL pg_catalog.pg_attrdef');
               lVACUUM ('VACUUM FULL pg_catalog.pg_proc');
               // System - ANALYZE
               lVACUUM ('VACUUM ANALYZE pg_catalog.pg_statistic');
               lVACUUM ('VACUUM ANALYZE pg_catalog.pg_attribute');
               lVACUUM ('VACUUM ANALYZE pg_catalog.pg_class');
               lVACUUM ('VACUUM ANALYZE pg_catalog.pg_type');
               lVACUUM ('VACUUM ANALYZE pg_catalog.pg_depend');
               lVACUUM ('VACUUM ANALYZE pg_catalog.pg_shdepend');
               lVACUUM ('VACUUM ANALYZE pg_catalog.pg_index');
               lVACUUM ('VACUUM ANALYZE pg_catalog.pg_attrdef');
               lVACUUM ('VACUUM ANALYZE pg_catalog.pg_proc');
               //
               MyDelay(1 * 1000);
               //
               if (beginVACUUM = 3) and (isVA = TRUE) then
               begin
                    lVACUUM ('VACUUM ANALYZE');
                    MyDelay(1 * 1000);
               end;
               //
               if beginVACUUM < 3 then
               begin
                   // Container
                   lVACUUM ('VACUUM FULL Container');
                   lVACUUM ('VACUUM ANALYZE Container');
                   lVACUUM ('VACUUM FULL ObjectFloat');
                   lVACUUM ('VACUUM ANALYZE ObjectFloat');
                   //lVACUUM ('VACUUM FULL ContainerLinkObject');
                   //lVACUUM ('VACUUM ANALYZE ContainerLinkObject');
                   lVACUUM ('VACUUM ANALYZE MovementFloat');
                   lVACUUM ('VACUUM ANALYZE MovementDate');
                   lVACUUM ('VACUUM ANALYZE MovementBoolean');
                   lVACUUM ('VACUUM ANALYZE MovementLinkObject');
                   lVACUUM ('VACUUM ANALYZE MovementLinkMovement');
               end;
               //
               MyDelay(500);
          end;
begin
     //������ ��������� ���� + �����
     DecodeTime(NOW, Hour_calc, Minute_calc, Second, MSec);
     //
     if (Hour_calc = 22) and (beginVACUUM > 0) then beginVACUUM:= 0;
     if (Hour_calc = 0) and (beginVACUUM > 0) then beginVACUUM:= 0;
     if (Hour_calc = 6) and (beginVACUUM > 0) then beginVACUUM:= 0;
     //
     if ((Hour_calc = 7) or ((Hour_calc = 21) and (Minute_calc > 20)) or (Hour_calc = 23)
      or ((Hour_calc = 4) and (Minute_calc > 25) {and (Minute_calc < 55)} and ((ParamStr(6)='VAC_5')or(ParamStr(7)='VAC_5')or(ParamStr(8)='VAC_5')))
         )
        and (beginVACUUM < 4) and (ParamStr(2)='autoALL')
     //if (Hour_calc = 14) and (beginVACUUM < 4) and (ParamStr(2)='autoALL')
        and (BranchEdit.Text = 'BranchId : 0')
     then
          try
              if beginVACUUM_ii = 0
              then myLogMemo_add('beginVACUUM_ii = ' + IntToStr(beginVACUUM_ii))
              else beginVACUUM_ii:=0;
              //
              fOpenSqToQuery_two('select pId from pg_stat_activity as a'
                               +' where state = ' + FormatToVarCharServer_notNULL('active')
                               +'   and query ILIKE ' + FormatToVarCharServer_notNULL('%VACUUM%')
                                 );
              myLogMemo_add('rec1 = ' + IntToStr(toSqlQuery_two.RecordCount));
              if toSqlQuery_two.RecordCount > 1 then
              begin
                   myLogMemo_add('rec1 = ' + IntToStr(toSqlQuery_two.RecordCount));
                   MyDelay(1 * 1000);
                   exit;
              end;
              //
              fOpenSqToQuery_two('select pId from pg_stat_activity as a'
                               +' where state = ' + FormatToVarCharServer_notNULL('active')
                                 );
              //myLogMemo_add('rec2 = ' + IntToStr(toSqlQuery_two.RecordCount));
              if toSqlQuery_two.RecordCount > 1 then
              begin
                   MyDelay(1 * 1000);
                   exit;
              end;
              //
              with zConnection_vacuum do
              try
                  Connected:=false;
                  HostName:=toZConnection.HostName;
                  User:=toZConnection.User;
                  Password:=toZConnection.Password;
                  Database:=toZConnection.Database;
                  Connected:=true;
              except
                  myLogMemo_add('!!! err zConnection_vacuum !!!');
                  exit;
              end;
              ZQuery := TZQuery.Create(nil);
              ZQuery.Connection := zConnection_vacuum;
              ZQuery.Sql.Clear;
               //
               myLogMemo_add('('+IntToStr(Hour_calc)+') start all VACUUM ('+IntToStr(beginVACUUM)+')');
               //
               lVACUUM_all ((Hour_calc = 23)or(Hour_calc = 4));
               beginVACUUM:= beginVACUUM + 1;
               //
               myLogMemo_add('end all VACUUM');
          finally
                zConnection_vacuum.Connected := false;
                ZQuery.Free;
          end;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fBeginPack_oneDay : Boolean;
begin
     cbPack.Checked:= true;
     StartDateCompleteEdit.Text:= DateToStr(now-1);
     EndDateCompleteEdit.Text:= DateToStr(now-1);
     pCompleteDocument_Pack;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fBeginPartion_Period : Boolean;
begin
     cbPartion.Checked:= true;
     //
     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     OKCompleteDocumentButton.Enabled:=false;
     cbComplete.Checked:=true;
     cbUnComplete.Checked:=true;
     //
     Gauge.Visible:=true;
     //
     //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthStart('+FormatToDateServer_notNULL(now-1)+') as RetV');
     fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(now-1)+' AS TDateTime)) as RetV');
     StartDateCompleteEdit.Text:=DateToStr(fromSqlZQuery.FieldByName('RetV').AsDateTime);
     EndDateCompleteEdit.Text:=DateToStr(now-1);
     //
     //
     pCompleteDocument_Partion;
     //
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     //OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then fromZConnection.Connected:=false;
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.myLogMemo_add(str :String);
begin
     LogMemo.Lines.Add(DateTimeToStr(now) + ' - ' + trim(str));
     LogMemo.Lines.Add('');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKCompleteDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2,tmpDate3:TDateTime;
    Year, Month, saveMonth, Day, Hour, Min, Sec, MSec: Word;
    Year2, Month2, Day2: Word;
    StrTime:String;
    saveStartDate,saveEndDate:TDateTime;
    calcStartDate,calcEndDate:TDateTime;
begin
     LogMemo.Clear;
     {if (cbSelectData_afterLoad.Checked)
     then begin
               pSelectData_afterLoad;
               exit;
     end;}
     //
     //
     if System.Pos('auto',ParamStr(2))<=0
     then begin
               if (cbInsertHistoryCost.Checked)
               then if MessageDlg('������������� ��������� <������������� �� �������> �� ������ � <'+DateToStr(StrToDate(StartDateCompleteEdit.Text))+'> �� <'+DateToStr(StrToDate(EndDateCompleteEdit.Text))+'> ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
               else
                   if (cbComplete.Checked)and(cbUnComplete.Checked)
                   then if MessageDlg('������������� �����������/�������� ��������� ���������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
                   else
                       if cbUnComplete.Checked
                       then if MessageDlg('������������� ������ ����������� ��������� ���������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
                       else
                           if cbComplete.Checked then if MessageDlg('������������� ������ �������� ��������� ���������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
                           else if cbBeforeSave.Checked
                                then if MessageDlg('������������� ������ ����������� ������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit else
                                else begin ShowMessage('������.�� ������� ����������� ��� �������� ��� ����������.'); end;

               //!!!
               if (not cbBeforeSave.Checked)and(cbUnComplete.Checked)and(not cbInsertHistoryCost.Checked)
               then begin
                         if MessageDlg('���������� ���������.����������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
                    end;
               //!!!��������� ��� ������!!!
               if cbBeforeSave.Checked
               then begin
                         fExecSqToQuery ('select * from _lpSaveData_beforeLoad('+FormatToDateServer_notNULL(StrToDate(StartDateCompleteEdit.Text))+','+FormatToDateServer_notNULL(StrToDate(EndDateCompleteEdit.Text))+')');
                         if (not cbComplete.Checked)and(not cbUnComplete.Checked)
                         then begin ShowMessage('���������� ������ �� ������ � <'+StartDateCompleteEdit.Text+'> �� <'+EndDateCompleteEdit.Text+'> ���������.');
                                    exit;
                         end;
               end;
     end;
     //
     //
     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     OKCompleteDocumentButton.Enabled:=false;
     if cbComplete_List.Checked then cbUnComplete.Checked:=cbComplete.Checked;
     //
     Gauge.Visible:=true;
     //
     tmpDate1:=NOw;
     //
     saveStartDate:=StrToDate(StartDateCompleteEdit.Text);
     saveEndDate:=StrToDate(EndDateCompleteEdit.Text);
     DecodeDate(saveStartDate, Year, Month, Day);
     DecodeDate(saveEndDate, Year2, Month2, Day2);
     saveMonth:=Month;
     //
     //
     calcStartDate:=saveStartDate;
     if saveMonth <> Month2
     then begin
               if Month=12 then begin Year:=Year+1;Month:=0;end;
               calcEndDate:=EncodeDate(Year, Month+1, 1)-1;
          end
     else calcEndDate:= saveEndDate;
     //
     if (cbOKPO.Checked)and(OKPOEdit.Text='123')
     then pInsertHistoryCost_Period(saveStartDate,saveEndDate,FALSE)
     else pInsertHistoryCost_Period(calcStartDate,calcEndDate,FALSE);
     //
     //
     tmpDate2:=NOw;
     if (tmpDate2-tmpDate1)>=1
     then StrTime:=DateTimeToStr(tmpDate2-tmpDate1)
     else begin
               DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
               StrTime:=IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
     end;
     //
     //
     if (saveMonth <> Month2) and ((ParamStr(6)<>'next-')) then begin
       pInsertHistoryCost_Period(calcEndDate+1,saveEndDate,TRUE);
       //
       tmpDate3:=NOw;
       if (tmpDate3-tmpDate2)>=1
       then StrTime:='(1):'+StrTime + '   (2):' + DateTimeToStr(tmpDate3-tmpDate2)
       else begin
                 DecodeTime(tmpDate3-tmpDate2, Hour, Min, Sec, MSec);
                 StrTime:='(1):'+StrTime + '   (2):' + IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
       end;
     end;
     //
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     //OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then fromZConnection.Connected:=false;

     if System.Pos('auto',ParamStr(2))<=0
     then begin
               if (fStop)and(cbInsertHistoryCost.Checked) then ShowMessage('������������� �� ������� ��������� �� ���������. Time=('+StrTime+').')
               else if fStop then ShowMessage('��������� �� ������������ �(���) �� ���������. Time=('+StrTime+').')
               else if cbInsertHistoryCost.Checked then ShowMessage('������������� �� ������� ��������� ���������. Time=('+StrTime+').')
                    else ShowMessage('��������� ������������ �(���) ���������. Time=('+StrTime+').');
     end
     else begin myLogMemo_add(StrTime+':Compl');
                OKPOEdit.Text:=StrTime+':Compl' + ' ' + OKPOEdit.Text;
          end;
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKDocumentButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
begin
     if System.Pos('auto',ParamStr(2))<=0
     then
     if MessageDlg('������������� ��������� ��������� ���������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     {if not cbBeforeSave.Checked
     then begin
               if MessageDlg('���������� ���������.����������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          end
     else fExecSqToQuery (' select * from _lpSaveData_beforeLoad('+StartDateEdit.Text+','+EndDateEdit.Text+')');}


     if cbShowContract.Checked then cbOnlyOpen.Checked:=true;

     fStop:=false;
     DBGrid.Enabled:=false;
     OKGuideButton.Enabled:=false;
     OKDocumentButton.Enabled:=false;
     OKCompleteDocumentButton.Enabled:=false;
     //
     Gauge.Visible:=true;
     //
     //
     tmpDate1:=NOw;
     //
     //
     if not fStop then pLoadGoodsListSale;
     //
     if not fStop then pLoadFillSoldTable;
     //
     if not fStop then pLoadFillAuto;
     //
     Gauge.Visible:=false;
     DBGrid.Enabled:=true;
     //OKGuideButton.Enabled:=true;
     OKDocumentButton.Enabled:=true;
     OKCompleteDocumentButton.Enabled:=true;
     //
     //
     toZConnection.Connected:=false;
     if not cbOnlyOpen.Checked then fromZConnection.Connected:=false;
     //
     tmpDate2:=NOw;
     if (tmpDate2-tmpDate1)>=1
     then StrTime:=DateTimeToStr(tmpDate2-tmpDate1)
     else begin
               DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
               StrTime:=IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec);
     end;

     if fStop then ShowMessage('��������� �� ���������. Time=('+StrTime+').')
     else
         if System.Pos('auto',ParamStr(2))<=0
         then ShowMessage('��������� ���������. Time=('+StrTime+').')
         else begin myLogMemo_add(StrTime+':Doc');
                    OKPOEdit.Text:=StrTime+':Doc' + ' ' + OKPOEdit.Text;
              end;
     //
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.PanelErrDblClick(Sender: TObject);
var i : Integer;
begin
     if not EditRepl1.Visible then
     begin
          EditRepl1.Visible:= true;
          EditRepl2.Visible:= true;
          EditRepl3.Visible:= true;
          cbRepl4.Visible:= true;
          //
          DBGrid.Visible:= false;
          DocumentPanel.Visible:= false;
          CompleteDocumentPanel.Visible:= false;
          LogPanel.Align:= alClient;
          //
          exit;
     end;
     //
     if EditRepl3.Text = 'Project_master'
     then
       with ZConnection_test do begin
          Connected:=false;
          HostName:='192.168.0.194';
          User:='admin';
          Password:='vas6ok';
          Database:='project_master';
          Connected:=true;
       end
     else
       with ZConnection_test do begin
          Connected:=false;
          HostName:='project-vds.vds.colocall.com';
          User:='admin';
          Password:='vas6ok';
          Database:='pod_test_ok';
          Connected:=true;
       end;
     //
     LogMemo.Clear;
     LogMemo2.Clear;
     LogMemo2.Visible:= true;
     //
     ZQuery_test2.Close;
     ZQuery_test2.Sql.Clear;
     //
      with ZQuery_test do begin
        close;
        Sql.Clear;
        Sql.Add('SELECT * FROM _replica.gpSelect_Replica_union (' + EditRepl1.Text+ ' , ' +EditRepl2.Text+')');
        Open;
        while not eof do
         begin
         ZQuery_test2.Sql.Add(FieldByName('Value').AsString);
         //
         LogMemo.Lines.Add(FieldByName('Value').AsString);
         LogMemo.Lines.Add('');
         next;
        end;
        close;
      end;
     //
     //
     if cbRepl4.Checked = true
     then
      with ZQuery_test2 do begin
        //
        for i:=0 to Sql.Count-1 do LogMemo2.Lines.Add(Sql[i]);
        //
        Open;
        //
        LogMemo2.Clear;
        while not eof do
         begin
         LogMemo2.Lines.Add('-- Id = ' + FieldByName('Id').AsString);
         LogMemo2.Lines.Add('-- Transaction_Id =' + FieldByName('Transaction_Id').AsString);
         LogMemo2.Lines.Add('-- table_name =' + FieldByName('table_name').AsString);
         LogMemo2.Lines.Add(FieldByName('Result').AsString+';');
         LogMemo2.Lines.Add('');
         LogMemo2.Lines.Add('');
         next;
        end;
        close;
      end;
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pInsertHistoryCost(isFirst:Boolean);
var calcStartDate,calcEndDate:TDateTime;
    saveStartDate,saveEndDate:TDateTime;
    Year, Month, Day: Word;
    myComponent:TZQuery;
    ii : Integer;
begin
     if (not cbInsertHistoryCost.Checked)or(not cbInsertHistoryCost.Enabled) then exit;
     //
     myEnabledCB(cbInsertHistoryCost);
     //
     saveStartDate:=StrToDate(StartDateCompleteEdit.Text);
     saveEndDate:=StrToDate(EndDateCompleteEdit.Text);
     //
     if cbInsertHistoryCost_andReComplete.Checked
     then myComponent:=fromZQueryDate
     else myComponent:=fromZQuery;
     //
     fromZConnection.Connected:=false;
     with myComponent,Sql do begin
        Close;
        Clear;
        //
        calcStartDate:=StrToDate(StartDateCompleteEdit.Text);
        DecodeDate(calcStartDate, Year, Month, Day);
        if Month=12 then begin Year:=Year+1;Month:=0;end;
        calcEndDate:=EncodeDate(Year, Month+1, 1)-1;
        while calcStartDate <= StrToDate(EndDateCompleteEdit.Text) do
        begin
             if calcStartDate=StrToDate(StartDateCompleteEdit.Text)
             then if (cbLastCost.Checked)
                  then Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate, -1 as BranchId, 0 as BranchCode, null as BranchName')
                  else Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate, 0 as BranchId, 0 as BranchCode, null as BranchName')
             else if (cbLastCost.Checked)
                  then Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate, -1 as BranchId, 0 as BranchCode, null as BranchName')
                  else Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcEndDate)+' as date) as EndDate, 0 as BranchId, 0 as BranchCode, null as BranchName');
             //
             //
             if (isFirst = FALSE){and(cbOnlySale.Checked=TRUE)***} then
             begin
                   Add('  union all'
                      +' select StartDate, EndDate, BranchId, BranchCode, BranchName'
                      +' from gpSelect_HistoryCost_Branch ('+FormatToDateServer_notNULL(calcStartDate)
                +trim ('                                  ,'+FormatToDateServer_notNULL(calcEndDate))
                +trim ('                                  ,zfCalc_UserAdmin()')
                +trim ('                                  )'));
                   {while not toSqlQuery.EOF do
                   begin
                        Add(' union all select cast('+FormatToDateServer_notNULL(toSqlQuery.FieldByName('StartDate').AsDatetime)+' as date) as StartDate'
                           +'                , cast('+FormatToDateServer_notNULL(toSqlQuery.FieldByName('EndDate').AsDatetime)+' as date) as EndDate'
                           +'                , '+IntToStr(toSqlQuery.FieldByName('BranchId').AsInteger)+' as BranchId'
                           +'                , '+IntToStr(toSqlQuery.FieldByName('BranchCode').AsInteger)+' as BranchCode'
                           +'                , '+FormatToVarCharServer_notNULL(toSqlQuery.FieldByName('BranchName').AsString)+' as BranchName');
                        toSqlQuery.Next;
                   end;}
             end;
             //
             //
             calcStartDate:=calcEndDate+1;
             DecodeDate(calcStartDate, Year, Month, Day);
             if Month=12 then begin Year:=Year+1;Month:=0;end;
             calcEndDate:=EncodeDate(Year, Month+1, 1)-1;
        end;
        Add('order by StartDate, BranchCode, EndDate');
        Open;
        //
        Application.ProcessMessages;
        Application.ProcessMessages;
        Application.ProcessMessages;
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc.StoredProcName:='gpInsertUpdate_HistoryCost';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc.Params.AddParam ('inBranchId',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inItearationCount',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inInsert',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inDiffSumm',ftFloat,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             StartDateCompleteEdit.Text:=DateToStr(FieldByName('StartDate').AsDateTime);
             EndDateCompleteEdit.Text:=DateToStr(FieldByName('EndDate').AsDateTime);
             //
             //
             //
             if cbInsertHistoryCost_andReComplete.Checked
             then begin
                       cbComplete_List.Checked:=true;
                       pCompleteDocument_List(true, FALSE, FALSE);
                      //ShowMessage('pCompleteDocument_List-1');
                  end;
             //
             //
             //
             myLogMemo_add('HistoryCost:BranchId='+FieldByName('BranchId').AsString);
             //
             toStoredProc.Params.ParamByName('inStartDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc.Params.ParamByName('inEndDate').Value:=FieldByName('EndDate').AsDateTime;
             toStoredProc.Params.ParamByName('inBranchId').Value:=FieldByName('BranchId').AsInteger;
             toStoredProc.Params.ParamByName('inItearationCount').Value:=800;
             toStoredProc.Params.ParamByName('inInsert').Value:=12345;//�����������
             toStoredProc.Params.ParamByName('inDiffSumm').Value:=0.009;
             //ShowMessage('pInsertHistoryCost');
             if not myExecToStoredProc then exit;
             //
             //
             MyDelay(5 * 1000);
             //
             // vacuum
             for ii:= 0 to 1000 do begin fBeginVACUUM;end;
             //
             //
             if cbInsertHistoryCost_andReComplete.Checked
             then begin
                       cbComplete_List.Checked:=true;
                       pCompleteDocument_List(false, FALSE, FALSE);
                       //ShowMessage('pCompleteDocument_List-2');
                  end;
             //
             //
             //
             Next;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     StartDateCompleteEdit.Text:=DateToStr(saveStartDate);
     EndDateCompleteEdit.Text:=DateToStr(saveEndDate);
     //
     myDisabledCB(cbInsertHistoryCost);
     myLogMemo_add('end cbInsertHistoryCost');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pInsertHistoryCost_Period(StartDate,EndDate:TDateTime;isPeriodTwo:Boolean);
var cbLastCost_save,cbOnlySale_save:Boolean;
begin
     StartDateCompleteEdit.Text:=DateToStr(StartDate);
     EndDateCompleteEdit.Text:=DateToStr(EndDate);

     cbLastCost_save:=cbLastCost.Checked;
     if isPeriodTwo = TRUE then cbLastCost.Checked:=false;
     cbOnlySale_save:=cbOnlySale.Checked;
     if isPeriodTwo = TRUE then cbOnlySale.Checked:=false;
     //
     //
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Defroster;
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Pack;
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Partion;
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Kopchenie;
     //
     //
     if {(cbOnlySale.Checked = FALSE)and***}(cbInsertHistoryCost.Checked)and(cbInsertHistoryCost.Enabled)
         // � - ���� ���������� 2 ����
         and (cbOnlyTwo.Checked = FALSE)
     then begin
           // ��� ������ �/� - 1-�� - ������ ������������
           if (not fStop)and(GroupId_branch <= 0) then pInsertHistoryCost(TRUE);
           //
           // ��������������
           if (not fStop)and(GroupId_branch <= 0) then pCompleteDocument_List(TRUE, FALSE, FALSE);
     end;
     //
     // ��� ������ �/� - 2-�� - ������������ + �������
     if (not fStop)and(GroupId_branch <= 0) then pInsertHistoryCost(FALSE);
     //
     // ������ - ������ �����
     if (not fStop)and(GroupId_branch <= 0) then pCompleteDocument_Promo;
     // ������ - �������� ������
     if (not fStop)and(GroupId_branch <= 0) then pLoad_https_Currency_all;
     // ������ - ������ ���� ����.
     if (not fStop)and(GroupId_branch <= 0) then pCompleteDocument_Currency;
     // ������ - �������� ��������
     if (not fStop)and(GroupId_branch <= 0) {and ((ParamStr(4) <> '-') or (isPeriodTwo = true))} then pCompleteDocument_ReturnIn_Auto;
     //
     //
     // ��������������
     if not fStop then pCompleteDocument_List(FALSE, FALSE, FALSE);
     //
     if (not fStop) and (isPeriodTwo = FALSE) then pCompleteDocument_Diff;
     //
     //
     if isPeriodTwo = TRUE then cbLastCost.Checked:=cbLastCost_save;
     if isPeriodTwo = TRUE then cbOnlySale.Checked:=cbOnlySale_save;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadGoodsListSale;
var mySql:String;
begin
     if (not cbGoodsListSale.Checked)or(not cbGoodsListSale.Enabled) then exit;
     //
     //      'select * from gpInsertUpdate_Object_GoodsListSale_byReport(inPeriod_1:= 12, inPeriod_2:= 3, inPeriod_3:= 6, inInfoMoneyId_1:= 8963, inInfoMoneyDestinationId_1:= 0, inInfoMoneyId_2:= 0, inInfoMoneyDestinationId_2:= 8879, inSession:= ' + chr(39) + '5' + chr(39) + ')';
     mySql:= 'select * from gpInsertUpdate_Object_GoodsListSale_byReport(             12,              3,              6,                   8963,                              0,                   0,                              8879,             ' + chr(39) + '5' + chr(39) + ')';
     try
     fOpenSqToQuery (mySql);
     except ShowMessage('Err - ' + mySql);
     end;
     //
     //
     mySql:= 'select * from gpInsertUpdate_Object_GoodsListIncome_byReport (12, 0, zc_Enum_InfoMoneyDestination_10200(), ' + chr(39) + '5' + chr(39) + ')';
     try
     fOpenSqToQuery (mySql);
     except ShowMessage('Err - ' + mySql);
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadFillSoldTable_curr;
var Date1, Date2 : TDateTime;
    tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     tmpDate1:=NOw;

   //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthStart('+FormatToDateServer_notNULL(Date-1)+') as RetV');
     fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(Date-1)+' AS TDateTime)) as RetV');
     Date1:= fromSqlZQuery.FieldByName('RetV').AsDateTime;

     //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthEnd('+FormatToDateServer_notNULL(Date-1)+') as RetV');
     Date2:=Date-1;

     StartDateEdit.Text:=DateToStr(Date1);
     EndDateEdit.Text:=DateToStr(Date2);
     cbFillSoldTable.Checked:= true;
     //
     fOpenSqToQuery ('select * from FillSoldTable('+FormatToVarCharServer_isSpace(DateToStr(Date1))
                                               +','+FormatToVarCharServer_isSpace(DateToStr(Date2))
                                               +',zfCalc_UserAdmin())');
     //
     //
     tmpDate2:=NOw;
     DecodeTime(tmpDate2-tmpDate1, Hour, Min, Sec, MSec);
     //
     myLogMemo_add(IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec)+':Doc' + '  ' + ParamStr(2) + ' ' + DateToStr(Date1) + ' - ' + DateToStr(Date2));
     OKPOEdit.Text:= IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec)+':Doc' + '  ' + ParamStr(2) + ' ' + DateToStr(Date1) + ' - ' + DateToStr(Date2);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadFillSoldTable;
var Date1, Date2 : TDateTime;
begin
     if (not cbFillSoldTable.Checked)or(not cbFillSoldTable.Enabled) then exit;
     //
     if (ParamStr(2)='autoFillSoldTable') then
     begin
        //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthStart('+FormatToDateServer_notNULL(Date-28)+') as RetV');
          fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(Date-28)+' AS TDateTime)) as RetV');
          Date1:=fromSqlZQuery.FieldByName('RetV').AsDateTime;

        //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthEnd('+FormatToDateServer_notNULL(Date-28)+') as RetV');
          fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(Date-28)+' AS TDateTime)) + INTERVAL ' + FormatToVarCharServer_notNULL('1 MONTH') + ' - INTERVAL ' + FormatToVarCharServer_notNULL('1 DAY') + ' as RetV');
          Date2:=fromSqlZQuery.FieldByName('RetV').AsDateTime;
          // ������� �����
        //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthEnd('+FormatToDateServer_notNULL(Date-2)+') as RetV');
          fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(Date-2)+' AS TDateTime)) + INTERVAL ' + FormatToVarCharServer_notNULL('1 MONTH') + ' - INTERVAL ' + FormatToVarCharServer_notNULL('1 DAY') + ' as RetV');
          // !!!�� "�������" - ����!!! -2 ���
          if Date2 = fromSqlZQuery.FieldByName('RetV').AsDateTime
          then Date2:= Date-2;
          //
          myLogMemo_add(trim(ParamStr(2) + ' ' + DateToStr(Date1) + ' - ' + DateToStr(Date2)));
          OKPOEdit.Text:= trim(OKPOEdit.Text + ' ' + ParamStr(2) + ' ' + DateToStr(Date1) + ' - ' + DateToStr(Date2));
     end
     else
     begin
          Date1:= StrToDate (StartDateEdit.Text);
          Date2:= StrToDate (EndDateEdit.Text);
          //
          myLogMemo_add(trim('pLoadFillSoldTable' + ' ' + DateToStr(Date1) + ' - ' + DateToStr(Date2)));
          OKPOEdit.Text:= trim(OKPOEdit.Text + ' ' + 'pLoadFillSoldTable' + ' ' + DateToStr(Date1) + ' - ' + DateToStr(Date2));
     end;
     //
     fOpenSqToQuery ('select * from FillSoldTable('+FormatToVarCharServer_isSpace(DateToStr(Date1))
                                               +','+FormatToVarCharServer_isSpace(DateToStr(Date2))
                                               +',zfCalc_UserAdmin())');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pLoadFillAuto;
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  calcSec,calcSec2:LongInt;
begin
     if (not cbFillAuto.Checked)or(not cbFillAuto.Enabled) then exit;
     //
     // 15 MONTH
     fOpenSqToQuery ('select * from gpUpdate_Object_Goods_In (DATE_TRUNC (' + chr(39) + 'MONTH' + chr(39) + ', CURRENT_DATE - INTERVAL' +  chr(39) + '15 MONTH' + chr(39) + ')'
                                                         + ', CURRENT_DATE'
                                                         + ', zfCalc_UserAdmin())');
     //
     // 15 MONTH
     fOpenSqToQuery ('select * from gpUpdate_Object_ReportCollation_RemainsCalc'
                                                         + ' (DATE_TRUNC (' + chr(39) + 'MONTH' + chr(39) + ', CURRENT_DATE - INTERVAL ' + chr(39) + '15 MONTH' + chr(39) + ')'
                                                         + ', CURRENT_DATE'
                                                         + ', 0' // inJuridicalId
                                                         + ', 0' // inPartnerId
                                                         + ', 0' // inContractId
                                                         + ', 0' // inPaidKindId
                                                         + ', 0' // inInfoMoneyId
                                                         + ', zfCalc_UserAdmin())');
     //
     //
     Present:=Now;
     DecodeDate(Present, Year, Month, Day);
     if Day < 15 then
     // 15 DAY
     fOpenSqToQuery ('select * from gpInsertUpdate_ObjectHistory_PriceListItem_Separate'
                                                         + ' (CURRENT_DATE -INTERVAL ' + chr(39) + '15 DAY' + chr(39)
                                                         + ', zfCalc_UserAdmin())');
     //CURRENT_DATE
     fOpenSqToQuery ('select * from gpInsertUpdate_ObjectHistory_PriceListItem_Separate'
                                                         + ' (CURRENT_DATE'
                                                         + ', zfCalc_UserAdmin())');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_List(isBefoHistoryCost,isPartion,isDiff:Boolean);
  function myAdd :String;
  begin
       result:='';
       if not toSqlQuery.EOF then
       with toSqlQuery do
       result:=' select ' + FieldByName('MovementId').AsString
              +'       ,' + FormatToDateServer_notNULL(FieldByName('OperDate').AsDateTime)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('InvNumber').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('Code').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(myReplaceStr(FieldByName('ItemName').AsString,chr(39),'`'));
       Gauge.Progress:=Gauge.Progress+1;
  end;
var ExecStr1,ExecStr2,ExecStr3,ExecStr4,addStr:String;
    i,SaveRecord:Integer;
    MSec_complete:Integer;
    isSale_str:String;
    strErr:String;
    strExec:String;
    execStoredProc:String;
begin
     if (isPartion = FALSE) and (isDiff = FALSE) then if (not cbComplete_List.Checked)or(not cbComplete_List.Enabled) then exit;
     //
     myEnabledCB(cbComplete_List);
     //
     myLogMemo_add('start cbComplete_List');
     //
     if cbOnlySale.Checked = true then isSale_str:=',TRUE' else isSale_str:=',FALSE';
     //
     // !!!������� � ������!!!

     // Get Data
     if (ParamStr(2)='autoReComplete') and (isBefoHistoryCost = TRUE)
     then execStoredProc:= 'gpComplete_SelectAllBranch_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',TRUE)'
     else
     if (ParamStr(2)='autoReComplete') and (isBefoHistoryCost = FALSE)
     then execStoredProc:= 'gpComplete_SelectAllBranch_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',FALSE)'
     else

     //
     if (isDiff = TRUE)
     then execStoredProc:= 'gpComplete_SelectAll_Sybase_diff('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+',NULL)'
     else
     if (isPartion = TRUE)
     then execStoredProc:= 'gpComplete_SelectAll_Sybase_CEH('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+',TRUE)'
     else
         if (isBefoHistoryCost = TRUE)and(cbInsertHistoryCost_andReComplete.Checked)
         then execStoredProc:= 'gpComplete_SelectHistoryCost_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+',TRUE)'
         else if (isBefoHistoryCost = FALSE)and(cbInsertHistoryCost_andReComplete.Checked)
              then execStoredProc:= 'gpComplete_SelectHistoryCost_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',FALSE)'
              else
                  if isBefoHistoryCost = TRUE
                  then execStoredProc:= 'gpComplete_SelectAll_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',TRUE, -1)'
                  else execStoredProc:= 'gpComplete_SelectAll_Sybase('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+isSale_str+',FALSE,' + IntToStr(GroupId_branch) + ')';

     //
     fromZConnection.Connected:=false;
     // �������
     fOpenFromZQuery ('select case when Code = ' + FormatToVarCharServer_notNULL('zc_Movement_IncomeCost')
                     +'                 then 0'
                     +'            when Code = ' + FormatToVarCharServer_notNULL('zc_Movement_Inventory')
                     +'                 then 1'
                     +'            else -1'
                     +'       end as Order_master'
                     +'    , tmp.*'
                     +' from ' + execStoredProc + ' as tmp '
                     +' order by Order_master,OperDate,MovementId,InvNumber');
     SaveRecord:=fromZQuery.RecordCount;
     Gauge.Progress:=0;
     Gauge.MaxValue:=SaveRecord;
     cbComplete_List.Caption:='('+IntToStr(SaveRecord)+') !!!C����� ���������!!!';

     //
     with fromZQuery,Sql do begin

        cbComplete_List.Caption:='('+IntToStr(SaveRecord)+')('+IntToStr(RecordCount)+') !!!C����� ���������!!!';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        {toStoredProc.StoredProcName:='';//gpUnComplete_Movement
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);}
        //
        toStoredProc_two.StoredProcName:='gpComplete_All_Sybase';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsNoHistoryCost',ftBoolean,ptInput, true);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             {if cbUnComplete.Checked then
             begin
                  toStoredProc.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
                  if not myExecToStoredProc then ;//exit;
             end;}
             if cbComplete.Checked then
             begin
                  begin
                       beginVACUUM_ii:= beginVACUUM_ii + 1;
                       if beginVACUUM_ii > 50 then fBeginVACUUM;
                       //
                       toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
                       toStoredProc_two.Params.ParamByName('inIsNoHistoryCost').Value:=cbLastComplete.Checked;

                       // 1-�� �������
                       try
                          strErr:= '';
                          if not myExecToStoredProc_two then ;//exit;
                       except on E:Exception do
                              strErr:= E.Message;
                       end;
                       // ���������
                       if strErr <> '' then begin AddToLog(1, FieldByName('MovementId').AsInteger, strErr); MyDelay(3 * 1000); end;

                       //
                       // 2-�� �������
                       if strErr <> ''
                       then
                       try
                          strErr:= '';
                          if not myExecToStoredProc_two then ;//exit;
                       except on E:Exception do
                              strErr:= E.Message;
                       end;
                       // ���������
                       if strErr <> '' then begin AddToLog(2, FieldByName('MovementId').AsInteger, strErr); MyDelay(3 * 1000); end;
                       //
                       // 3-�� �������
                       if strErr <> ''
                       then
                       try
                          strErr:= '';
                          if not myExecToStoredProc_two then ;//exit;
                       except on E:Exception do
                              strErr:= E.Message;
                       end;
                       // ���������
                       if strErr <> '' then AddToLog(3, FieldByName('MovementId').AsInteger, strErr);
                       //
                       // 4-�� �������
                       if strErr <> ''
                       then
                       try
                          strErr:= '';
                          if not myExecToStoredProc_two then ;//exit;
                       except on E:Exception do
                              strErr:= E.Message;
                       end;
                       // ���������
                       if strErr <> '' then AddToLog(4, FieldByName('MovementId').AsInteger, strErr);
                       //
                       // ��������� �������
                       if strErr <> ''
                       then
                       try
                          strErr:= '';
                          if not myExecToStoredProc_two then ;//exit;
                       except on E:Exception do
                              strErr:= E.Message;
                       end;
                       // ���������
                       if strErr <> '' then
                       begin
                            AddToLog(5, FieldByName('MovementId').AsInteger, strErr);
                            //
                            // ��������� ����, ����� �������� ������
                            strExec:= 'insert into HistoryCost_err(InsertDate,MovementId)'
                                     +'  select CURRENT_TIMESTAMP, ' + IntToStr(FieldByName('MovementId').AsInteger);
                            if not fExecSqToQuery_noErr_two(strExec)
                            then
                                AddToLog(55, FieldByName('MovementId').AsInteger, strExec);

                       end;
                  end;
             end;
             //
             try MSec_complete:=StrToInt(SessionIdEdit.Text);if MSec_complete<=0 then MSec_complete:=100;except MSec_complete:=100;end;
             if cb100MSec.Checked then begin SessionIdEdit.Text:=IntToStr(MSec_complete); MyDelay(MSec_complete);end;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     //if fromZQuery.Active = true
     //then myLogMemo_add('fromZQuery.Active = true')
     //else myLogMemo_add('fromZQuery.Active = false');
     //
     myDisabledCB(cbComplete_List);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Defroster;
begin
     if (not cbDefroster.Checked)or(not cbDefroster.Enabled) then exit;
     //
     myEnabledCB(cbDefroster);
     //
        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ProductionUnion_Defroster';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);

             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inUnitId').Value:=8440;//���������
             if not myExecToStoredProc_two then ;//exit;
             //
     //
     myDisabledCB(cbDefroster);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Pack;
var calcStartDate:TDateTime;
    MSec_complete:Integer;
begin
  try
     if (not cbPack.Checked)or(not cbPack.Enabled) then exit;
     //
     myEnabledCB(cbPack);
     //
     myLogMemo_add('start cbPack');
     //
     DBGrid.DataSource.DataSet:=fromZQueryDate_recalc;
     //
     fromZConnection.Connected:=false;
     with fromZQueryDate_recalc,Sql do begin
        Close;
        Clear;
        //
        calcStartDate:=StrToDate(StartDateCompleteEdit.Text);
        while calcStartDate <= StrToDate(EndDateCompleteEdit.Text) do
        begin
             if calcStartDate=StrToDate(StartDateCompleteEdit.Text)
             then Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as EndDate')
             else Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as EndDate');
             //
             calcStartDate:=calcStartDate+1;
        end;
        Add('order by StartDate, EndDate');
        Open;

        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;

        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ProductionUnion_Pack';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);

        while not EOF do
        begin
             //!!!
             if fStop then exit;
             //
             //
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inUnitId').Value:=8451;//��� ��������
             if not myExecToStoredProc_two then ;//exit;
             //
             if cb100MSec.Checked
             then begin
                  try MSec_complete:=StrToInt(SessionIdEdit.Text);if MSec_complete<=0 then MSec_complete:=100;except MSec_complete:=100;end;
                  if cb100MSec.Checked then begin SessionIdEdit.Text:=IntToStr(MSec_complete); MyDelay(MSec_complete);end;
             end
             else MyDelay(8 * 1000);
             //
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inUnitId').Value:=951601;//��� �������� ����
             if not myExecToStoredProc_two then ;//exit;
             //
             if cb100MSec.Checked
             then begin
                  try MSec_complete:=StrToInt(SessionIdEdit.Text);if MSec_complete<=0 then MSec_complete:=100;except MSec_complete:=100;end;
                  if cb100MSec.Checked then begin SessionIdEdit.Text:=IntToStr(MSec_complete); MyDelay(MSec_complete);end;
             end
             else MyDelay(4 * 1000);
             //
             //
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbPack);
     //
     myLogMemo_add('end cbPack');
     //
  finally
     DBGrid.DataSource.DataSet:=fromZQuery;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Kopchenie;
var calcStartDate:TDateTime;
begin
  try
     if (not cbKopchenie.Checked)or(not cbKopchenie.Enabled) then exit;
     //
     myEnabledCB(cbKopchenie);
     //
     myLogMemo_add('start cbKopchenie');
     //
     DBGrid.DataSource.DataSet:=fromZQueryDate_recalc;
     //
     fromZConnection.Connected:=false;
     with fromZQueryDate_recalc,Sql do begin
        Close;
        Clear;
        //
        calcStartDate:=StrToDate(StartDateCompleteEdit.Text);
        while calcStartDate <= StrToDate(EndDateCompleteEdit.Text) do
        begin
             if calcStartDate=StrToDate(StartDateCompleteEdit.Text)
             then Add('          select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as EndDate')
             else Add('union all select cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as StartDate, cast('+FormatToDateServer_notNULL(calcStartDate)+' as date) as EndDate');
             //
             calcStartDate:=calcStartDate+1;
        end;
        Add('order by StartDate, EndDate');
        Open;

        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;

        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ProductionUnion_Kopchenie';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inUnitId',ftInteger,ptInput, 0);

        while not EOF do
        begin
             //!!!
             if fStop then exit;
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=FieldByName('StartDate').AsDateTime;
             toStoredProc_two.Params.ParamByName('inUnitId').Value:=8450;//��� ��������
             if not myExecToStoredProc_two then ;//exit;
             //
             MyDelay(5 * 1000);
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbKopchenie);
     //
     myLogMemo_add('end cbKopchenie');
     //
  finally
     DBGrid.DataSource.DataSet:=fromZQuery;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Diff;
begin
     if (not cbHistoryCost_diff.Checked)or(not cbHistoryCost_diff.Enabled) then exit;
     //
     myEnabledCB(cbHistoryCost_diff);
     //
        toStoredProc_two.StoredProcName:='gpUpdate_HistoryCost_diff';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inIsUpdate',ftBoolean,ptInput, TRUE);

        Gauge.Progress:=0;
        Gauge.MaxValue:=1;

             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inIsUpdate').Value:= TRUE;
             if not cbOnlyOpen.Checked then if not myExecToStoredProc_two then ;//exit;
        Gauge.Progress:=1;
        MyDelay(3 * 1000);
     //
     pCompleteDocument_List(false, FALSE, TRUE);
     //
     myDisabledCB(cbHistoryCost_diff);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_ReturnIn_Auto;
  function myAdd :String;
  begin
       result:='';
       if not toSqlQuery.EOF then
       with toSqlQuery do
       result:=' select ' + FieldByName('MovementId').AsString
              +'       ,' + FormatToDateServer_notNULL(FieldByName('OperDate').AsDateTime)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('InvNumber').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('Code').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(myReplaceStr(FieldByName('ItemName').AsString,chr(39),'`'));
       Gauge.Progress:=Gauge.Progress+1;
  end;
var ExecStr1,ExecStr2,ExecStr3,ExecStr4,addStr:String;
    i,SaveRecord:Integer;
    MSec_complete:Integer;
    isSale_str:String;
    strErr:String;
begin
     // "�������" �����
   //fOpenSqlFromZQuery ('select zf_CalcDate_onMonthStart('+FormatToDateServer_notNULL(Date-2)+') as RetV');
     fOpenSqlFromZQuery ('select DATE_TRUNC (' + FormatToVarCharServer_notNULL('MONTH') + ', CAST ('+FormatToDateServer_notNULL(Date-2)+' AS TDateTime)) as RetV');
     //
     if  (StrToDate (EndDateCompleteEdit.Text) < fromSqlZQuery.FieldByName('RetV').AsDateTime)
        and (ParamStr(2) <> '') and (ParamStr(4) <> '+')
     then cbReturnIn_Auto.Checked:= false // !!!�� "����������" - �� ����!!!
     else if ParamStr(2) <> ''
          then cbReturnIn_Auto.Checked:= true; // !!!����!!!

     if (not cbReturnIn_Auto.Checked)or(not cbReturnIn_Auto.Enabled) then exit;
     //
     myEnabledCB(cbReturnIn_Auto);
     //
     //
     fromZConnection.Connected:=false;
     with fromZQuery,Sql do begin
        Close;
        Clear;
        Add('select * from gpComplete_SelectAll_Sybase_ReturnIn_Auto('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+')');
        Add('order by OperDate,MovementId,InvNumber');
        Open;

        cbReturnIn_Auto.Caption:='('+IntToStr(RecordCount)+') �������� ��������';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ReturnIn_isError';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;

                       // ���� �������
                       try
                          strErr:= '';
                          if not myExecToStoredProc_two then ;//exit;
                       except on E:Exception do
                              strErr:= E.Message;
                       end;
                       // ���������
                       if strErr <> '' then begin AddToLog(0, FieldByName('MovementId').AsInteger, strErr); MyDelay(1 * 1000); end;


             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbReturnIn_Auto);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Currency;
  function myAdd :String;
  begin
       result:='';
       if not toSqlQuery.EOF then
       with toSqlQuery do
       result:=' select ' + FieldByName('MovementId').AsString
              +'       ,' + FormatToDateServer_notNULL(FieldByName('OperDate').AsDateTime)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('InvNumber').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(FieldByName('Code').AsString)
              +'       ,' + FormatToVarCharServer_isSpace(myReplaceStr(FieldByName('ItemName').AsString,chr(39),'`'));
       Gauge.Progress:=Gauge.Progress+1;
  end;
var ExecStr1,ExecStr2,ExecStr3,ExecStr4,addStr:String;
    i,SaveRecord:Integer;
    MSec_complete:Integer;
    isSale_str:String;
begin
     if (not cbCurrency.Checked)or(not cbCurrency.Enabled) then exit;
     //
     myEnabledCB(cbCurrency);
     //
     cbCurrency.Caption:='('+IntToStr(SaveRecord)+') !!!������ �������� ����.!!!';

     //
     fromZConnection.Connected:=false;
     with fromZQuery,Sql do begin
        Close;
        Clear;
        Add('select * from gpComplete_SelectAll_Sybase_Currency_Auto('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+')');
        Add('order by OperDate,MovementId,InvNumber');
        Open;

        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;

        cbCurrency.Caption:='('+IntToStr(RecordCount)+') ������ ����. ����.';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc_two.StoredProcName:='gpReComplete_Movement_Currency';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             if not myExecToStoredProc_two then ;//exit;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbCurrency);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Promo;
var i,SaveRecord:Integer;
    MSec_complete:Integer;
    isSale_str:String;
begin
     if (not cbPromo.Checked)or(not cbPromo.Enabled) then exit;
     //
     myEnabledCB(cbPromo);
     //
     // !!!������� � ������!!!
     fromZConnection.Connected:=false;
     with fromZQuery,Sql do begin
        fOpenFromZQuery ('select * from gpComplete_SelectAll_Sybase_Promo_Auto('+FormatToVarCharServer_isSpace(StartDateCompleteEdit.Text)+','+FormatToVarCharServer_isSpace(EndDateCompleteEdit.Text)+')'
                       +' order by OperDate,MovementId,InvNumber');
        //
        cbPromo.Caption:='('+IntToStr(RecordCount)+') ������ �����';
        //
        fStop:=cbOnlyOpen.Checked;
        if cbOnlyOpen.Checked then exit;
        //
        Gauge.Progress:=0;
        Gauge.MaxValue:=RecordCount;
        //
        toStoredProc_two.StoredProcName:='gpInsertUpdate_MI_Promo_Param';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inMovementId',ftInteger,ptInput, 0);
        //
        while not EOF do
        begin
             //!!!
             if fStop then begin exit;end;
             //
             toStoredProc_two.Params.ParamByName('inMovementId').Value:=FieldByName('MovementId').AsInteger;
             if not myExecToStoredProc_two then ;//exit;
             //
             Next;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
             Application.ProcessMessages;
             Application.ProcessMessages;
        end;
     end;
     //
     myDisabledCB(cbPromo);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pCompleteDocument_Partion;
begin
     if (not cbPartion.Checked)or(not cbPartion.Enabled) then exit;
     //
     myLogMemo_add('start cbPartion');
     //
     myEnabledCB(cbPartion);
     //
        toStoredProc_two.StoredProcName:='gpUpdate_Movement_ProductionUnion_Partion';
        toStoredProc_two.OutputType := otResult;
        toStoredProc_two.Params.Clear;
        toStoredProc_two.Params.AddParam ('inStartDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inEndDate',ftDateTime,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inFromId',ftInteger,ptInput, 0);
        toStoredProc_two.Params.AddParam ('inToId',ftInteger,ptInput, 0);

        Gauge.Progress:=0;
        Gauge.MaxValue:=5;

             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inFromId').Value:=8448;//��� �����������
             toStoredProc_two.Params.ParamByName('inToId').Value:=8458;//����� ���� ��
             if not myExecToStoredProc_two then ;//exit;

        Gauge.Progress:= Gauge.Progress + 1;
        MyDelay(3 * 1000);
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inFromId').Value:=8447;//��� ���������
             toStoredProc_two.Params.ParamByName('inToId').Value:=8458;//����� ���� ��
             if not myExecToStoredProc_two then ;//exit;
        Gauge.Progress:= Gauge.Progress + 1;
        MyDelay(1 * 1000);
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inFromId').Value:=8449;//��� �/�
             toStoredProc_two.Params.ParamByName('inToId').Value:=8458;//����� ���� ��
             if not myExecToStoredProc_two then ;//exit;
        Gauge.Progress:= Gauge.Progress + 1;
        MyDelay(1 * 1000);
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inFromId').Value:=951601; //��� �������� ����
             toStoredProc_two.Params.ParamByName('inToId').Value:=8439; //������� ������� �����
             if not myExecToStoredProc_two then ;//exit;
        Gauge.Progress:= Gauge.Progress + 1;
        MyDelay(1 * 1000);
             //
             toStoredProc_two.Params.ParamByName('inStartDate').Value:=StrToDate(StartDateCompleteEdit.Text);
             toStoredProc_two.Params.ParamByName('inEndDate').Value:=StrToDate(EndDateCompleteEdit.Text) ;
             toStoredProc_two.Params.ParamByName('inFromId').Value:=981821; //��� �����. ����
             toStoredProc_two.Params.ParamByName('inToId').Value:=951601; //��� �������� ����
             if not myExecToStoredProc_two then ;//exit;
        Gauge.Progress:= Gauge.Progress + 1;
        MyDelay(1 * 1000);
     //
     pCompleteDocument_List(false,true, FALSE);
     //
     myDisabledCB(cbPartion);
     //
     DBGrid.DataSource.DataSet:=fromZQuery;
     //
     myLogMemo_add('end cbPartion');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

end.


