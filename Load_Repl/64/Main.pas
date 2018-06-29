unit Main;

interface

uses
  Windows, Forms, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdDB, Data.DB,
  Data.Win.ADODB, Vcl.StdCtrls, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.Controls, Vcl.Samples.Gauges, Vcl.ExtCtrls, System.Classes,
  Vcl.Grids, Vcl.DBGrids, dxSkinsCore, dxSkinsDefaultPainters,
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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  Datasnap.DBClient, cxCurrencyEdit;

type
   TReplServerItem = record
     Id             :Integer;
     Code           :Integer;
     Name           :string;
     HostName       :string;
     Users          :string;
     Passwords      :string;
     Port           :string;
     DataBases      :string;
     Start_toChild  :TDateTime;
     Start_fromChild:TDateTime;
   end;
   TArrayReplServer = array of TReplServerItem;

  TMainForm = class(TForm)
    ObjectDS: TDataSource;
    PanelGrid: TPanel;
    DBGridObject: TDBGrid;
    ButtonPanel: TPanel;
    OKGuideButton: TButton;
    Gauge: TGauge;
    StopButton: TButton;
    CloseButton: TButton;
    spSelect_ObjectGUID: TdsdStoredProc;
    toStoredProc: TdsdStoredProc;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Splitter1: TSplitter;
    PanelReplServer: TPanel;
    rgReplServer: TRadioGroup;
    ObjectCDS: TClientDataSet;
    FormParams: TdsdFormParams;
    PanelCB: TPanel;
    cbProtocol: TCheckBox;
    spSelect_ReplServer_load: TdsdStoredProc;
    ReplServerCDS: TClientDataSet;
    LabelObjectDescId: TLabel;
    PanelInfoObject: TPanel;
    EditRecordObject: TcxCurrencyEdit;
    PanelGridObjectString: TPanel;
    DBGridObjectString: TDBGrid;
    PanelInfoObjectString: TPanel;
    EditRecordObjectString: TcxCurrencyEdit;
    LabelObjectString: TLabel;
    LabelObject: TLabel;
    PanelGridObjectFloat: TPanel;
    DBGridObjectFloat: TDBGrid;
    PanelInfoObjectFloat: TPanel;
    LabelObjectFloat: TLabel;
    EditRecordObjectFloat: TcxCurrencyEdit;
    PanelGridObjectDate: TPanel;
    DBGridObjectDate: TDBGrid;
    PanelInfoObjectDate: TPanel;
    LabelObjectDate: TLabel;
    EditRecordObjectDate: TcxCurrencyEdit;
    PanelGridObjectBoolean: TPanel;
    DBGridObjectBoolean: TDBGrid;
    PanelInfoObjectBoolean: TPanel;
    LabelObjectBoolean: TLabel;
    EditRecordObjectBoolean: TcxCurrencyEdit;
    PanelGridObjectLink: TPanel;
    DBGridObjectLink: TDBGrid;
    PanelInfoObjectLink: TPanel;
    LabelObjectLink: TLabel;
    EditRecordObjectLink: TcxCurrencyEdit;
    ObjectStringCDS: TClientDataSet;
    ObjectStringDS: TDataSource;
    ObjectFloatCDS: TClientDataSet;
    ObjectFloatDS: TDataSource;
    ObjectDateDS: TDataSource;
    ObjectDateCDS: TClientDataSet;
    ObjectBooleanDS: TDataSource;
    ObjectBooleanCDS: TClientDataSet;
    ObjectLinkDS: TDataSource;
    ObjectLinkCDS: TClientDataSet;
    EditObjectDescId: TEdit;

    procedure OKGuideButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ButtonPanelDblClick(Sender: TObject);
  private
    fStop : Boolean;
    beginConnectionTo : Integer;

    procedure EADO_EngineErrorMsg(E:EADOError);
    //procedure EDB_EngineErrorMsg(E:EDBEngineError);
    function myExecToStoredProc_ZConnection:Boolean;
    function myExecToStoredProc:Boolean;

    procedure myShowSql(mySql:TStrings);
    procedure MyDelay(mySec:Integer);

    function myReplaceStr(const S, Srch, Replace: string): string;
    function FormatToVarCharServer_notNULL(_Value:string):string;
    function FormatToVarCharServer_isSpace(_Value:string):string;
    function FormatToDateServer_notNULL(_Date:TDateTime):string;
    function FormatToDatePostgres_notNULL(_Date:TDateTime):string;
    function FormatToDateTimeServer(_Date:TDateTime):string;
    function FormatToDateTimeServerNOSec(_Date:TDateTime):string;

    function fOpenSqFromQuery (mySql:String):Boolean;
    function fExecSqFromQuery (mySql:String):Boolean;
    function fExecSqFromQuery_noErr (mySql:String):Boolean;

    function fOpenSqToQuery (mySql:String):Boolean;
    function fExecSqToQuery (mySql:String):Boolean;
    function fOpenSqToQuery_two (mySql:String):Boolean;
    function fExecSqToQuery_two (mySql:String):Boolean;


    procedure CursorGridChange;

    function IniConnectionTo(NumConnect : Integer) : Boolean;

    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);

    procedure pOpen_ObjectGUID (NumConnect : Integer);
    function gpSelect_ReplServer_load: TArrayReplServer;

  public
  end;

  function GenerateGUID: String;

var
  MainForm: TMainForm;
  ArrayReplServer : TArrayReplServer;

implementation
uses Authentication, CommonData, Storage, SysUtils, Dialogs, Graphics, UtilConst;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
function GenerateGUID: String;
var
  G: TGUID;
begin
  CreateGUID(G);
  Result := GUIDToString(G);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.gpSelect_ReplServer_load: TArrayReplServer;
var i: integer;
begin
    rgReplServer.Items.Clear;
    //
    with spSelect_ReplServer_load do
    begin
       //try
         Execute;
         DataSet.First;
         SetLength(Result, DataSet.RecordCount);
         for i:= 0 to DataSet.RecordCount-1 do
         begin
          Result[i].Id         := DataSet.FieldByName('Id').asInteger;
          Result[i].Code       := DataSet.FieldByName('Code').asInteger;
          Result[i].Name       := DataSet.FieldByName('Name').asString;
          Result[i].HostName   := DataSet.FieldByName('HostName').asString;
          Result[i].Users      := DataSet.FieldByName('Users').asString;
          Result[i].Passwords  := DataSet.FieldByName('Passwords').asString;
          Result[i].Port       := DataSet.FieldByName('Port').asString;
          Result[i].DataBases  := DataSet.FieldByName('DataBases').asString;
          Result[i].Start_toChild   := DataSet.FieldByName('Start_toChild').asDateTime;
          Result[i].Start_fromChild := DataSet.FieldByName('Start_fromChild').asDateTime;
          //
          rgReplServer.Items.Add (IntToStr(Result[i].Code) + '('+IntToStr(Result[i].Id)+')'
                         + ' '  + Result[i].HostName
                         + ' '  +  '('+Result[i].Port+')'
                         + ' '  + Result[i].Users
                         + ' '  + Result[i].DataBases
                         + ' '  +  '('+DateTimeToStr(Result[i].Start_toChild)+')'
                         + ' '  +  '('+DateTimeToStr(Result[i].Start_fromChild)+')'
                                  );
          //
          DataSet.Next;
         end;
       {except
         SetLength(Result, 0);
         ShowMessage('Ошибка получения - gpSelect_ReplServer_load');
       end;}
    end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StopButtonClick(Sender: TObject);
begin
     if MessageDlg('Действительно остановить загрузку?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     fStop:=true;

     DBGridObject.Enabled:=true;
     DBGridObjectString.Enabled:=true;
     DBGridObjectFloat.Enabled:=true;
     DBGridObjectDate.Enabled:=true;
     DBGridObjectBoolean.Enabled:=true;
     DBGridObjectLink.Enabled:=true;

     OKGuideButton.Enabled:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
     if not fStop then
       if MessageDlg('Действительно остановить загрузку и выйти?',mtConfirmation,[mbYes,mbNo],0)=mrYes then fStop:=true;
     //
     if fStop then Close;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqFromQuery(mySql:String):Boolean;
begin
     //
{     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;}
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqFromQuery(mySql:String):Boolean;
begin
     //
     {with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;}
     Result:=true;
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqFromQuery_noErr(mySql:String):Boolean;
begin
     //
     {with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql; except Result:=false;exit;end;
     end;}
     Result:=true;
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqToQuery (mySql:String):Boolean;
begin
{     with toSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqToQuery'+#10+#13+mySql);Result:=false;exit;end;

        try Open
        except
          on E: Exception do begin
              ShowMessage('fOpenSqToQuery-1'+#10+#13+E.Message+#10+#13+mySql);
              Result:=false;
              exit;
          end;
        end;
     end;         }
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqToQuery (mySql:String):Boolean;
begin
     {with toSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;}
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqToQuery_two (mySql:String):Boolean;
begin
     {with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;}
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqToQuery_two (mySql:String):Boolean;
begin
     {with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;}
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
function TMainForm.FormatToDatePostgres_notNULL(_Date:TDateTime):string;
var
  Year, Month, Day: Word;
begin
     DecodeDate(_Date,Year,Month,Day);
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
     else result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+' '+IntToStr(AHour)+':'+IntToStr(AMinute)+':'+IntToStr(ASecond)+chr(39);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatToDateTimeServerNOSec(_Date:TDateTime):string;
var
  Year, Month, Day: Word;
  AHour, AMinute, ASecond, MSec: Word;
begin
     DecodeDate(_Date,Year,Month,Day);
     DecodeTime(_Date,AHour, AMinute, ASecond, MSec);
//     result:=chr(39)+GetStringValue('select zf_FormatToDateServer('+IntToStr(Year)+','+IntToStr(Month)+','+IntToStr(Day)+')as RetV')+chr(39);
     if Year <= 1900
     then result:='null'
     else result:=chr(39)+IntToStr(Year)+'-'+IntToStr(Month)+'-'+IntToStr(Day)+' '+IntToStr(AHour)+':'+IntToStr(AMinute)+':0'+chr(39);
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
procedure TMainForm.EADO_EngineErrorMsg(E:EADOError);
begin
  MessageDlg(E.Message,mtError,[mbOK],0);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
{procedure TMainForm.EDB_EngineErrorMsg(E:EDBEngineError);
var
  DBError: TDBError;
begin
  DBError:=E.Errors[1];
  MessageDlg(DBError.Message,mtError,[mbOK],0);
end;}
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
procedure TMainForm.CursorGridChange;
begin
     //if Assigned (DBGrid.DataSource.DataSet)
     //then
       //if сbNotVisibleCursor.Checked
       //then DBGrid.DataSource.DataSet.DisableControls
       //else DBGrid.DataSource.DataSet.EnableControls;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.ButtonPanelDblClick(Sender: TObject);
begin
     gc_isDebugMode:=not gc_isDebugMode;
     if gc_isDebugMode = TRUE
     then ShowMessage ('Отладка - Включена')
     else ShowMessage ('Отладка - Выключена');

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function myGetWord(myStr : String; NumWord : Integer) : String;
begin
     if Pos (' ', trim (myStr)) > 0
     then if NumWord = 1
          then Result:= trim (Copy (myStr, 1, Pos (' ', trim (myStr)) - 1))
          else Result:= myGetWord (Copy (myStr
                                       , Pos (' ', trim (myStr)) + 1
                                       , Length(myStr) - Pos (' ', trim (myStr))
                                        )
                                 , NumWord - 1)
     else Result:= trim (myStr);

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.IniConnectionTo(NumConnect : Integer) : Boolean;
begin
     {with toZConnection do begin
        Connected:=false;
        HostName:= ArrayReplServer[NumConnect-1].HostName;
        User    := ArrayReplServer[NumConnect-1].Users;
        Password:= ArrayReplServer[NumConnect-1].Passwords;
        Port    := StrToInt(ArrayReplServer[NumConnect-1].Port);
        DataBase:= ArrayReplServer[NumConnect-1].DataBases;
        //
        try Connected:=true; except ShowMessage ('not Connected');end;
        //
        Result:= Connected;
        if Result then rgReplServer.ItemIndex:= NumConnect - 1
        else rgReplServer.ItemIndex:= 0;

     end;}
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pOpen_ObjectGUID (NumConnect : Integer);
begin
     with spSelect_ObjectGUID do
     begin
       //try
         //
         ParamByName('inStartDate').Value  := ArrayReplServer[NumConnect-1].Start_toChild;
         ParamByName('inDataBaseId').Value := ArrayReplServer[NumConnect-1].Id;
         ParamByName('inDescCode').Value   := EditObjectDescId.Text;
         ParamByName('inIsProtocol').Value := cbProtocol.Checked;
         ParamByName('inIsGUID_null').Value:= false;
         //
         Execute;
         //
         EditRecordObject.Text:= IntToStr (ObjectCDS.RecordCount);
         EditRecordObjectString.Text:= IntToStr (ObjectStringCDS.RecordCount);
         EditRecordObjectFloat.Text:= IntToStr (ObjectFloatCDS.RecordCount);
         EditRecordObjectDate.Text:= IntToStr (ObjectDateCDS.RecordCount);
         EditRecordObjectBoolean.Text:= IntToStr (ObjectBooleanCDS.RecordCount);
         EditRecordObjectLink.Text:= IntToStr (ObjectLinkCDS.RecordCount);
         //
         //Dataset.
         //
       {except
         SetLength(Result, 0);
         ShowMessage('Ошибка получения - gpSelect_Scale_GoodsKindWeighing');
       end;}
     end;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
     Gauge.Visible:=false;
     Gauge.Progress:=0;
     //
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'qsxqsxw1', gc_User);
     if not Assigned (gc_User) then ShowMessage ('not Assigned (gc_User)');
     //
     ArrayReplServer:= gpSelect_ReplServer_load;
     //
     fStop:=true;
     //
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKGuideButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
begin
     //
     if MessageDlg('Действительно загрузить выбранные справочники?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     //
     fStop:=false;

     //DBGrid.Enabled:=false;

     OKGuideButton.Enabled:=false;
     //
     Gauge.Visible:=true;
     //
     tmpDate1:=NOw;


     CursorGridChange;

     //
     //
     beginConnectionTo:= 2;
     IniConnectionTo(beginConnectionTo);
     if not fStop then pOpen_ObjectGUID (beginConnectionTo);
     //
     //
     Gauge.Visible:=false;
     //DBGrid.Enabled:=true;
     OKGuideButton.Enabled:=true;
     //
     //toZConnection.Connected:=false;
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

{procedure TMainForm.pLoadGuide_Valuta;
begin
     if (not cbValuta.Checked)or(not cbValuta.Enabled) then exit;
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
        toStoredProc.StoredProcName:='gpinsertupdate_object_Currency';
        toStoredProc.OutputType := otResult;
        toStoredProc.Params.Clear;
        toStoredProc.Params.AddParam ('ioId',ftInteger,ptInputOutput, 0);
        toStoredProc.Params.AddParam ('inCode',ftInteger,ptInput, 0);
        toStoredProc.Params.AddParam ('inName',ftString,ptInput, '');
        //

        while not EOF do
        begin
             //!!!
             if fStop then begin   exit; end;
             //
             toStoredProc.Params.ParamByName('ioId').Value:=FieldByName('Id_Postgres').AsInteger;
             toStoredProc.Params.ParamByName('inCode').Value:=FieldByName('ObjectCode').AsInteger;
             toStoredProc.Params.ParamByName('inName').Value:=FieldByName('ObjectName').AsString;
             if not myExecToStoredProc then ;//exit;
             if not myExecSqlUpdateErased(toStoredProc.Params.ParamByName('ioId').Value,FieldByName('Erased').AsInteger,FieldByName('zc_erasedDel').AsInteger) then ;//exit;
             //
             if (1=0)or(FieldByName('Id_Postgres').AsInteger=0)
             then fExecSqFromQuery('update dba.Valuta set Id_Postgres='+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+' where Id = '+FieldByName('ObjectId').AsString);

             if FieldByName('ObjectId').AsInteger=1 // Грн - Basis
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Currency_Basis() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             if FieldByName('ObjectId').AsInteger=1 // Грн
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Currency_GRN() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             if FieldByName('ObjectId').AsInteger=2 // EUR
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Currency_EUR() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
             if FieldByName('ObjectId').AsInteger=5 // $
             then fExecSqToQuery ('CREATE OR REPLACE FUNCTION zc_Currency_USD() RETURNS Integer AS $BODY$BEGIN RETURN ('+IntToStr(toStoredProc.Params.ParamByName('ioId').Value)+'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;');
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
}


end.


