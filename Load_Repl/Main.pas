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
     OID_last       : Int64;
   end;
   TArrayReplServer = array of TReplServerItem;
   TArrayObjectDesc = array of string;

  TMainForm = class(TForm)
    ObjectDS: TDataSource;
    PanelGrid: TPanel;
    DBGridObject: TDBGrid;
    ButtonPanel: TPanel;
    OKGuideButton: TButton;
    Gauge: TGauge;
    StopButton: TButton;
    CloseButton: TButton;
    toSqlQuery: TZQuery;
    spSelect_ReplObject_old: TdsdStoredProc;
    toZConnection: TZConnection;
    toSqlQuery_two: TZQuery;
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
    spSelect_ReplServer_load_old: TdsdStoredProc;
    ReplServerCDS: TClientDataSet;
    LabelObjectDescId: TLabel;
    PanelInfoObject: TPanel;
    EditCountObject: TcxCurrencyEdit;
    PanelGridObjectString: TPanel;
    DBGridObjectString: TDBGrid;
    PanelInfoObjectString: TPanel;
    EditCountStringObject: TcxCurrencyEdit;
    LabelObjectString: TLabel;
    LabelObject: TLabel;
    PanelGridObjectFloat: TPanel;
    DBGridObjectFloat: TDBGrid;
    PanelInfoObjectFloat: TPanel;
    LabelObjectFloat: TLabel;
    EditCountFloatObject: TcxCurrencyEdit;
    PanelGridObjectDate: TPanel;
    DBGridObjectDate: TDBGrid;
    PanelInfoObjectDate: TPanel;
    LabelObjectDate: TLabel;
    EditCountDateObject: TcxCurrencyEdit;
    PanelGridObjectBoolean: TPanel;
    DBGridObjectBoolean: TDBGrid;
    PanelInfoObjectBoolean: TPanel;
    LabelObjectBoolean: TLabel;
    EditCountBooleanObject: TcxCurrencyEdit;
    PanelGridObjectLink: TPanel;
    DBGridObjectLink: TDBGrid;
    PanelInfoObjectLink: TPanel;
    LabelObjectLink: TLabel;
    EditCountLinkObject: TcxCurrencyEdit;
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
    spInsert_ReplObject_old: TdsdStoredProc;
    EditMinIdObject: TcxCurrencyEdit;
    EditMaxIdObject: TcxCurrencyEdit;
    EditCountIterationObject: TEdit;
    cbGUID: TCheckBox;
    cbOnlyOpen: TCheckBox;
    PanelError: TPanel;
    MemoMsg: TMemo;
    cbDesc: TCheckBox;
    fromZConnection: TZConnection;
    fromSqlQuery: TZQuery;
    fQueryObject: TZQuery;
    fQueryObjectString: TZQuery;
    fQueryObjectFloat: TZQuery;
    fQueryObjectDate: TZQuery;
    fQueryObjectBoolean: TZQuery;
    fQueryObjectLink: TZQuery;
    cbClientDataSet: TCheckBox;
    spSelect_ReplObjectString_old: TdsdStoredProc;
    spSelect_ReplObjectFloat_old: TdsdStoredProc;
    spSelect_ReplObjectDate_old: TdsdStoredProc;
    spSelect_ReplObjectBoolean_old: TdsdStoredProc;
    spSelect_ReplObjectLink_old: TdsdStoredProc;
    cbShowGrid: TCheckBox;
    tmpCDS: TClientDataSet;
    spExecSql: TdsdStoredProc;
    fromSqlQuery_two: TZQuery;
    cbProc: TCheckBox;

    procedure OKGuideButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ButtonPanelDblClick(Sender: TObject);
  private
    fStop : Boolean;
    gSessionGUID : String;
    outMinId, outCountIteration, outMaxId, outCountPack : Integer;

    procedure myShowSql(mySql:TStrings);
    procedure MyDelay(mySec:Integer);

    function myReplaceStr(const S, Srch, Replace: string): string;

    function ConvertValueToVarChar(PropertyName : string;
                                   _ValueS      : string;
                                   _ValueF      : Double;
                                   _ValueD      : TDateTime; _isNullD : Boolean;
                                   _ValueB      : Boolean;   _isNullB : Boolean;
                                   ChildObjectId: Integer
                                  ):string;

    function ConvertFromVarChar_notNULL(_Value:string):string;
    function ConvertFromVarChar(_Value:string):string;
    function ConvertFromBoolean(_Value, isNull : Boolean) : string;
    function ConvertFromDateTime(_Value : TDateTime; isNull : Boolean) : string;
    function ConvertFromInt(_Value:Integer):string;
    function ConvertFromFloat(_Value:Double):string;

    function FormatFromDate(_Date:TDateTime):string;
    function FormatFromDateTime(_Date:TDateTime):string;
    function FormatFromDateTime_folder(_Date:TDateTime):string;

    function fOpenSqFromQuery (mySql:String):Boolean;
    function fOpenSqFromQuery_two (mySql:String):Boolean;
    function fExecSqFromQuery (mySql:String):Boolean;
    function fExecSqFromQuery_noErr (mySql:String):Boolean;

    function fOpenSqToQuery (mySql:String):Boolean;
    function fExecSqToQuery (mySql:String):String;
    function fOpenSqToQuery_two (mySql:String):Boolean;
    function fExecSqToQuery_two (mySql:String):Boolean;


    procedure CursorGridChange;

    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);

    function gpSelect_ReplServer_load: TArrayReplServer;
    function IniConnectionFrom (isOpen   : Boolean): Boolean;
    function IniConnectionTo   (isGetDesc: Boolean): Boolean;

    function pInsert_ReplObject : Boolean;
    function pSendAllTo_ReplObject  : Boolean;
    function pOpen_ReplObject (isObjectLink : Boolean; Num_main : Integer; StartId, EndId : LongInt) : Boolean;
    function pSendPackTo_ReplObject(Num_main, CountPack : Integer) : Boolean;
    function pSendPackTo_ReplObjectProperty(Num_main, CountPack : Integer; QueryData : TClientDataSet) : Boolean;

    procedure AddToLog(S, myFile, myFolder: string; isError : Boolean);
    procedure AddToMemoMsg(S: String; isError : Boolean);

    procedure pSendAllTo_ReplObjectDesc;
    function pSendAllTo_ReplProc : Boolean;

  public
  end;

  function GenerateGUID: String;

var
  MainForm: TMainForm;
  ArrayReplServer : TArrayReplServer;
  ArrayObjectDesc : TArrayObjectDesc;


implementation
uses Authentication, CommonData, Storage, SysUtils, Dialogs, Graphics, UtilConst, StrUtils;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
function GetArrayList_Index_byValue (ArrayList:TArrayObjectDesc;Value:String):Integer;
var i:Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if (ArrayList[i] = Value)
    then begin Result:=i;break;end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function GetIndexParams(execParams:TParams;FindName:String):Integer;//возвращаят индекс парамтра сназванием FindName в TParams
var i:Integer;
begin
  Result:=-1;
  if not Assigned(execParams) then exit;
  for i:=0 to execParams.Count-1 do
          if UpperCase(execParams[i].Name)=UpperCase(FindName)then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------------}
procedure ParamAdd(var execParams:TParams;_Name:String;_DataType:TFieldType);
begin
     if not Assigned(execParams) then execParams:=TParams.Create
     else
         if GetIndexParams(execParams,_Name)>=0 then exit;

     TParam.Create(execParams,ptUnknown);
     execParams[execParams.Count-1].Name:=_Name;
     execParams[execParams.Count-1].DataType:=_DataType;
end;
{------------------------------------------------------------------------------}
function GenerateGUID: String;
var
  G: TGUID;
begin
  CreateGUID(G);
  Result := MainForm.FormatFromDateTime_folder(now) + ' - ' + GUIDToString(G);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.gpSelect_ReplServer_load: TArrayReplServer;
var i: integer;
begin
    if not IniConnectionFrom(TRUE) then exit;
    //
    rgReplServer.Items.Clear;
    //
    fOpenSqFromQuery ('select * from gpSelect_ReplServer_load (CAST (NULL AS TVarChar))');
    //
    with fromSqlQuery do
    begin
         First;
         //
         if Assigned (ArrayReplServer) then FreeAndNil (ArrayReplServer);
         SetLength(Result, RecordCount);
         //
         for i:= 0 to RecordCount-1 do
         begin
          Result[i].Id         := FieldByName('Id').asInteger;
          Result[i].Code       := FieldByName('Code').asInteger;
          Result[i].Name       := FieldByName('Name').asString;
          Result[i].HostName   := FieldByName('HostName').asString;
          Result[i].Users      := FieldByName('Users').asString;
          Result[i].Passwords  := FieldByName('Passwords').asString;
          Result[i].Port       := FieldByName('Port').asString;
          Result[i].DataBases  := FieldByName('DataBases').asString;
          Result[i].Start_toChild   := FieldByName('Start_toChild').asDateTime;
          Result[i].Start_fromChild := FieldByName('Start_fromChild').asDateTime;
          Result[i].OID_last   := FieldByName('OID_last').asInteger;
          //
          rgReplServer.Items.Add (IntToStr(Result[i].Code) + ' ('+IntToStr(Result[i].Id)+')'
                         + ' '  + Result[i].HostName
                         + ' '  +  '('+Result[i].Port+')'
                         + ' '  + Result[i].Users
                         + ' '  + Result[i].DataBases
                         + ' '  +  '('+DateTimeToStr(Result[i].Start_toChild)+')'
                         + ' '  +  '('+DateTimeToStr(Result[i].Start_fromChild)+')'
                                  );
          //
          Next;
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

     AddToMemoMsg ('!!!!!!!!!!!!!!!!!!!!', TRUE);
     AddToMemoMsg (' ??? STOP ???', TRUE);
     AddToMemoMsg ('!!!!!!!!!!!!!!!!!!!!', TRUE);

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
       if MessageDlg('Действительно остановить загрузку и выйти?',mtConfirmation,[mbYes,mbNo],0)=mrYes
       then begin
         fStop:=true;
         //
         AddToMemoMsg ('!!!!!!!!!!!!!!!!!!!!', TRUE);
         AddToMemoMsg (' ??? STOP and CLOSE ???', TRUE);
         AddToMemoMsg ('!!!!!!!!!!!!!!!!!!!!', TRUE);
       end;
     //
     if fStop then Close;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqFromQuery(mySql:String):Boolean;
begin
     //
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqFromQuery_two(mySql:String):Boolean;
begin
     //
     with fromSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try Open except ShowMessage('fOpenSqFromQuery_two'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqFromQuery(mySql:String):Boolean;
begin
     //
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqFromQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqFromQuery_noErr(mySql:String):Boolean;
begin
     //
     with fromSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql; except Result:=false;exit;end;
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

        {try Open
        except
          on E: Exception do begin
              ShowMessage('fOpenSqToQuery-1'+#10+#13+E.Message+#10+#13+mySql);
              Result:=false;
              exit;
          end;
        end;}
     end;
     Result:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fExecSqToQuery (mySql:String):String;
begin
     with toSqlQuery,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql
        except on E:Exception do
           begin
              Result:= E.Message;
              exit;
           end;
        end;
     end;
     Result:='';
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fOpenSqToQuery_two (mySql:String):Boolean;
begin
     with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try Open
        except ShowMessage('fOpenSqToQuery'+#10+#13+mySql);Result:=false;exit;
        end;
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
function TMainForm.ConvertValueToVarChar(PropertyName : string;
                                   _ValueS      : string;
                                   _ValueF      : Double;
                                   _ValueD      : TDateTime; _isNullD : Boolean;
                                   _ValueB      : Boolean;   _isNullB : Boolean;
                                   ChildObjectId: Integer
                                  ):string;
begin
     if PropertyName = 'ObjectString' then Result:= ConvertFromVarChar(_ValueS)
     else
     if PropertyName = 'ObjectFloat' then Result:= ConvertFromFloat(_ValueF)
     else
     if PropertyName = 'ObjectDate' then Result:= ConvertFromDateTime(_ValueD, _isNullD)
     else
     if PropertyName = 'ObjectBoolean' then Result:= ConvertFromBoolean(_ValueB, _isNullB)
     else
     if PropertyName = 'ObjectLink' then Result:= ConvertFromInt(ChildObjectId)
     else ShowMessage('ConvertValueToVarChar - PropertyName : ' + PropertyName + ' ???')
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromVarChar_notNULL(_Value:string):string;
begin if trim(_Value)='' then Result:=chr(39)+''+chr(39) else Result:=chr(39)+trim(_Value)+chr(39);end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromVarChar(_Value:string):string;
begin Result:=chr(39)+(myReplaceStr(_Value,chr(39),'`'))+chr(39);end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromBoolean(_Value, isNull:Boolean):string;
begin
     if isNull = TRUE then Result:='NULL'
     else
     if _Value = TRUE then Result:='TRUE' else Result:='FALSE';
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromDateTime(_Value : TDateTime; isNull : Boolean) : string;
begin
     if isNull = TRUE then Result:='NULL'
     else
         Result:= FormatFromDateTime(_Value);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromInt(_Value:Integer):string;
begin
     if _Value = 0 then Result:='NULL'
     else
         Result:= IntToStr(_Value);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromFloat(_Value:Double):string;
begin
     Result:=myReplaceStr(FloatToStr(_Value), ',', '.');
end;
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
function TMainForm.FormatFromDate (_Date:TDateTime):string;
var
  Year, Month, Day: Word;
  myMonth, myDay : String;
begin
     DecodeDate(_Date,Year,Month,Day);
     //
     if Month   < 10 then myMonth := '0' else myMonth := '';
     if Day     < 10 then myDay   := '0' else myDay   := '';
     //
     result:=chr(39) + myDay + IntToStr(Day) + '.' + myMonth + IntToStr(Month) + '.' + IntToStr(Year) + chr(39);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatFromDateTime (_Date:TDateTime):string;
var
  Year, Month, Day: Word;
  AHour, AMinute, ASecond, MSec: Word;
  myMonth, myDay, myHour, myMinute, mySecond : String;
begin
     DecodeDate(_Date,Year,Month,Day);
     DecodeTime(_Date,AHour, AMinute, ASecond, MSec);
     //
     if Month   < 10 then myMonth := '0' else myMonth := '';
     if Day     < 10 then myDay   := '0' else myDay   := '';
     if AHour   < 10 then myHour  := '0' else myHour  := '';
     if AMinute < 10 then myMinute:= '0' else myMinute:= '';
     if ASecond < 10 then mySecond:= '0' else mySecond:= '';
     //
     result:=chr(39) + myDay  + IntToStr(Day)   + '.' + myMonth  + IntToStr(Month)   + '.' + IntToStr(Year)
               + ' ' + myHour + IntToStr(AHour) + ':' + myMinute + IntToStr(AMinute) + ':' + mySecond + IntToStr(ASecond)
               + chr(39);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.FormatFromDateTime_folder(_Date:TDateTime):string;
var
  Year, Month, Day: Word;
  AHour, AMinute, ASecond, MSec: Word;
  myMonth, myDay, myHour, myMinute, mySecond : String;
begin
     DecodeDate(_Date,Year,Month,Day);
     DecodeTime(_Date,AHour, AMinute, ASecond, MSec);
     //
     if Month   < 10 then myMonth := '0' else myMonth := '';
     if Day     < 10 then myDay   := '0' else myDay   := '';
     if AHour   < 10 then myHour  := '0' else myHour  := '';
     if AMinute < 10 then myMinute:= '0' else myMinute:= '';
     if ASecond < 10 then mySecond:= '0' else mySecond:= '';
     //
     result:={chr(39) +} IntToStr(Year)  + '-' + myMonth + IntToStr(Month) + '-' + myDay + IntToStr(Day)
                 + ' ' + myHour + IntToStr(AHour) + ':' + myMinute + IntToStr(AMinute) + ':' + mySecond + IntToStr(ASecond)
                {+ chr(39)};
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
function TMainForm.IniConnectionFrom(isOpen : Boolean): Boolean;
begin
     // if isOpen = FALSE then begin Result:= true; exit; end;
     //
     AddToMemoMsg('----- startConnect FROM:', FALSE);
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now), FALSE);
     //
     with fromZConnection do begin
        Connected:=false;
        if not Assigned (ArrayReplServer) then
        begin
            HostName:= 'integer-srv.alan.dp.ua';
            User    := 'admin';
            Password:= 'vas6ok';
            Port    := 5432;
            DataBase:= 'project';
        end
        else
        begin
            HostName:= ArrayReplServer[0].HostName;
            User    := ArrayReplServer[0].Users;
            Password:= ArrayReplServer[0].Passwords;
            Port    := StrToInt(ArrayReplServer[0].Port);
            DataBase:= ArrayReplServer[0].DataBases;
        end;
        //
        try Connected:=true; except AddToMemoMsg(' !!!!! not Connected From!!!!', TRUE);end;
        //
        Result:= Connected;

     end;
     //
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Connect', FALSE);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.IniConnectionTo (isGetDesc: Boolean) : Boolean;
var i : Integer;
begin
     AddToMemoMsg('----- startConnect To:', FALSE);
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now), FALSE);
     //
     with toZConnection do begin
        Connected:=false;
        HostName:= ArrayReplServer[1].HostName;
        User    := ArrayReplServer[1].Users;
        Password:= ArrayReplServer[1].Passwords;
        Port    := StrToInt(ArrayReplServer[1].Port);
        DataBase:= ArrayReplServer[1].DataBases;
        //
        try Connected:=true; except AddToMemoMsg(' !!!!! not Connected To!!!!', TRUE);end;
        //
        Result:= Connected;
        if Result then rgReplServer.ItemIndex:= 2
        else rgReplServer.ItemIndex:= 0;

     end;
     //
     if (Result = true) and (isGetDesc = true) then
     with toSqlQuery_two,Sql do
     begin
           Clear;
           //
           // список - существующие Desc в базе TO
           Add('select Code AS DescName, Id from ObjectDesc');
           Add('union all');
           Add('select Code AS DescName, Id from ObjectStringDesc');
           Add('union all');
           Add('select Code AS DescName, Id from ObjectFloatDesc');
           Add('union all');
           Add('select Code AS DescName, Id from ObjectDateDesc');
           Add('union all');
           Add('select Code AS DescName, Id from ObjectBooleanDesc');
           Add('union all');
           Add('select Code AS DescName, Id from ObjectLinkDesc');
           //
           Open;
           //
           if Assigned (ArrayObjectDesc) then FreeAndNil(ArrayObjectDesc);
           SetLength(ArrayObjectDesc,RecordCount);
           i:=0;
           //
           while not EOF do
           begin
                // заливаем в список - существующие Desc в базе TO
                ArrayObjectDesc[i]:=FieldByName('DescName').AsString;
                //
                Next;
                i:=i+1;
           end;
     end;
     //
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Connect', FALSE);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pInsert_ReplObject : Boolean;
//var tmp : Integer;
begin
     Result:= false;

     try
     gSessionGUID:= GenerateGUID;
     fOpenSqFromQuery ('select * from gpInsert_ReplObject('+ConvertFromVarChar(gSessionGUID)
                      +',' + FormatFromDateTime(ArrayReplServer[1].Start_toChild)
                      +',' + ConvertFromVarChar(EditObjectDescId.Text)
                      +',' + ConvertFromBoolean(cbProtocol.Checked, FALSE)
                      +', CAST (NULL AS TVarChar) '
                      +')');
     //
     with fromSqlQuery do
     begin
         //
         outMinId          :=FieldByName('outMinId').AsInteger;
         outCountIteration :=FieldByName('outCountIteration').AsInteger;
         outMaxId          :=FieldByName('outMaxId').AsInteger;
         outCountPack      :=FieldByName('outCountPack').AsInteger;
         //
         EditCountObject.Text          := IntToStr (FieldByName('outCount').AsInteger);
         EditMinIdObject.Text          := IntToStr (FieldByName('outMinId').AsInteger);
         EditMaxIdObject.Text          := IntToStr (FieldByName('outMaxId').AsInteger);
         EditCountIterationObject.Text := IntToStr (FieldByName('outCountIteration').AsInteger) + ' / ' + IntToStr (FieldByName('outCountPack').AsInteger);
         EditCountStringObject.Text    := IntToStr (FieldByName('outCountString').AsInteger);
         EditCountFloatObject.Text     := IntToStr (FieldByName('outCountFloat').AsInteger);
         EditCountDateObject.Text      := IntToStr (FieldByName('outCountDate').AsInteger);
         EditCountBooleanObject.Text   := IntToStr (FieldByName('outCountBoolean').AsInteger);
         EditCountLinkObject.Text      := IntToStr (FieldByName('outCountLink').AsInteger);
         //
         Gauge.Progress:=
               FieldByName('outCount').AsInteger
             + FieldByName('outCountString').AsInteger
             + FieldByName('outCountFloat').AsInteger
             + FieldByName('outCountDate').AsInteger
             + FieldByName('outCountBoolean').AsInteger
             + FieldByName('outCountLink').AsInteger
              ;
         //
         AddToMemoMsg('----- gSessionGUID:', FALSE);
         //
         AddToMemoMsg('Count : ' + IntToStr (FieldByName('outCount').AsInteger), FALSE);
         AddToMemoMsg('String : ' + IntToStr (FieldByName('outCountString').AsInteger), FALSE);
         AddToMemoMsg('Float : ' + IntToStr (FieldByName('outCountFloat').AsInteger), FALSE);
         AddToMemoMsg('Date : ' + IntToStr (FieldByName('outCountDate').AsInteger), FALSE);
         AddToMemoMsg('Boolean : ' + IntToStr (FieldByName('outCountBoolean').AsInteger), FALSE);
         AddToMemoMsg('Link : ' + IntToStr (FieldByName('outCountLink').AsInteger), FALSE);
         AddToMemoMsg('MinId : ' + IntToStr (FieldByName('outMinId').AsInteger), FALSE);
         AddToMemoMsg('MaxId : ' + IntToStr (FieldByName('outMaxId').AsInteger), FALSE);
         AddToMemoMsg('CountIteration : ' + IntToStr (FieldByName('outCountIteration').AsInteger), FALSE);
         AddToMemoMsg('CountPack : ' + IntToStr (FieldByName('outCountPack').AsInteger), FALSE);
         //
         AddToMemoMsg(gSessionGUID, FALSE);
         AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Insert', FALSE);
     end;

     except on E:Exception do
       begin
          // ERROR
          AddToMemoMsg ('', FALSE);
          AddToMemoMsg (E.Message, TRUE);
          exit;
       end;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pOpen_ReplObject (isObjectLink : Boolean; Num_main : Integer; StartId, EndId : LongInt) : Boolean;
begin
     Result:= false;
     //
     if not IniConnectionFrom (not cbClientDataSet.Checked) then exit;
     //
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - Start Open ('+IntToStr(Num_main)+') ('+IntToStr(StartId)+')-('+IntToStr(EndId)+')', FALSE);
     //
     try

     if cbShowGrid.Checked = false then
     begin
       //
       ObjectDS.DataSet:= nil;
       ObjectStringDS.DataSet:= nil;
       ObjectFloatDS.DataSet:= nil;
       ObjectDateDS.DataSet:= nil;
       ObjectBooleanDS.DataSet:= nil;
       ObjectLinkDS.DataSet:= nil;
     end;

     //
     {if cbClientDataSet.Checked = TRUE then
     begin
         if cbShowGrid.Checked = True then
         begin
           //
           ObjectDS.DataSet:= ObjectCDS;
           ObjectStringDS.DataSet:= ObjectStringCDS;
           ObjectFloatDS.DataSet:= ObjectFloatCDS;
           ObjectDateDS.DataSet:= ObjectDateCDS;
           ObjectBooleanDS.DataSet:= ObjectBooleanCDS;
           ObjectLinkDS.DataSet:= ObjectLinkCDS;
         end;
         //
         if isObjectLink = FALSE then
         begin
           //
           with spSelect_ReplObject do
           begin
               ParamByName('inSessionGUID').Value:= spInsert_ReplObject.ParamByName('inSessionGUID').Value;
               ParamByName('inStartId').Value    := StartId;
               ParamByName('inEndId').Value      := EndId;
               ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
               Execute;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open Object');
           //
           with spSelect_ReplObjectString do
           begin
               ParamByName('inSessionGUID').Value:= spInsert_ReplObject.ParamByName('inSessionGUID').Value;
               ParamByName('inStartId').Value    := StartId;
               ParamByName('inEndId').Value      := EndId;
               ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
               Execute;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectString');
           //
           with spSelect_ReplObjectFloat do
           begin
               ParamByName('inSessionGUID').Value:= spInsert_ReplObject.ParamByName('inSessionGUID').Value;
               ParamByName('inStartId').Value    := StartId;
               ParamByName('inEndId').Value      := EndId;
               ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
               Execute;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectFloat');
           //
           with spSelect_ReplObjectDate do
           begin
               ParamByName('inSessionGUID').Value:= spInsert_ReplObject.ParamByName('inSessionGUID').Value;
               ParamByName('inStartId').Value    := StartId;
               ParamByName('inEndId').Value      := EndId;
               ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
               Execute;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectDate');
           //
           with spSelect_ReplObjectBoolean do
           begin
               ParamByName('inSessionGUID').Value:= spInsert_ReplObject.ParamByName('inSessionGUID').Value;
               ParamByName('inStartId').Value    := StartId;
               ParamByName('inEndId').Value      := EndId;
               ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
               Execute;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectBoolean');
         end
         else
         begin
           //
           with spSelect_ReplObjectLink do
           begin
               ParamByName('inSessionGUID').Value:= spInsert_ReplObject.ParamByName('inSessionGUID').Value;
               ParamByName('inStartId').Value    := StartId;
               ParamByName('inEndId').Value      := EndId;
               ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
               Execute;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectLink');

         end;
     end
     else}
     begin
         if cbShowGrid.Checked = True then
         begin
           //
           ObjectDS.DataSet:= fQueryObject;
           ObjectLinkDS.DataSet:= ObjectLinkCDS;
           ObjectStringDS.DataSet:= fQueryObjectString;
           ObjectFloatDS.DataSet:= fQueryObjectFloat;
           ObjectDateDS.DataSet:= fQueryObjectDate;
           ObjectBooleanDS.DataSet:= fQueryObjectBoolean;
           ObjectLinkDS.DataSet:= fQueryObjectLink;
         end;
         //
         if isObjectLink = FALSE then
         begin
           //
           with fQueryObject,Sql do
           begin
               Clear;
               Add ('SELECT * FROM gpSelect_ReplObject(' + ConvertFromVarChar(gSessionGUID)
                                                    +',' + IntToStr(StartId)
                                                    +',' + IntToStr(EndId)
                                                    +',' + IntToStr(ArrayReplServer[0].Id)
                                                    +',zfCalc_UserAdmin())');
               Open;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open Object', FALSE);
           //
           with fQueryObjectString,Sql do
           begin
               Clear;
               Add ('SELECT * FROM gpSelect_ReplObjectString(' + ConvertFromVarChar(gSessionGUID)
                                                    +',' + IntToStr(StartId)
                                                    +',' + IntToStr(EndId)
                                                    +',' + IntToStr(ArrayReplServer[0].Id)
                                                    +',zfCalc_UserAdmin())');
               Open;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectString', FALSE);
           //
           with fQueryObjectFloat,Sql do
           begin
               Clear;
               Add ('SELECT * FROM gpSelect_ReplObjectFloat(' + ConvertFromVarChar(gSessionGUID)
                                                    +',' + IntToStr(StartId)
                                                    +',' + IntToStr(EndId)
                                                    +',' + IntToStr(ArrayReplServer[0].Id)
                                                    +',zfCalc_UserAdmin())');
               Open;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectFloat', FALSE);
           //
           with fQueryObjectDate,Sql do
           begin
               Clear;
               Add ('SELECT * FROM gpSelect_ReplObjectDate(' + ConvertFromVarChar(gSessionGUID)
                                                    +',' + IntToStr(StartId)
                                                    +',' + IntToStr(EndId)
                                                    +',' + IntToStr(ArrayReplServer[0].Id)
                                                    +',zfCalc_UserAdmin())');
               Open;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectDate', FALSE);
           //
           with fQueryObjectBoolean,Sql do
           begin
               Clear;
               Add ('SELECT * FROM gpSelect_ReplObjectBoolean(' + ConvertFromVarChar(gSessionGUID)
                                                    +',' + IntToStr(StartId)
                                                    +',' + IntToStr(EndId)
                                                    +',' + IntToStr(ArrayReplServer[0].Id)
                                                    +',zfCalc_UserAdmin())');
               Open;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectBoolean', FALSE);

         end
         else
         begin
           //
           with fQueryObjectLink,Sql do
           begin
               Clear;
               Add ('SELECT * FROM gpSelect_ReplObjectLink(' + ConvertFromVarChar(gSessionGUID)
                                                    +',' + IntToStr(StartId)
                                                    +',' + IntToStr(EndId)
                                                    +',' + IntToStr(ArrayReplServer[0].Id)
                                                    +',zfCalc_UserAdmin())');
               Open;
           end;
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ObjectLink', FALSE);

         end;
     end;

     except on E:Exception do
       begin
          // ERROR
          AddToMemoMsg ('', FALSE);
          AddToMemoMsg (E.Message, TRUE);
          exit;
       end;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pSendPackTo_ReplObject (Num_main, CountPack : Integer) : Boolean;
var StrPack : String;
    i, num  : Integer;
    nextL   : String;
    resStr  : String;
    myCDS : TClientDataSet;
begin
     Result:= false;
     //
     if not IniConnectionTo (false) then exit;
     //
     try
     //
     i:=0;
     num:=0;
     StrPack:= '';
     nextL  := #13;
     //
     if cbClientDataSet.Checked = TRUE
     then myCDS:= TClientDataSet(ObjectCDS)
     else myCDS:= TClientDataSet(fQueryObject);
     //
     with myCDS do begin
        First;
        while not EOF  do
        begin
             //!!!
             if fStop then begin exit;end;
             //!!!
             //сначала "шапка"
             if StrPack = ''
             then begin
                  StrPack:= ' DO $$' + nextL
                          + ' DECLARE vbId Integer;' + nextL
                          + ' BEGIN' + nextL + nextL + nextL
                          ;
                  num:= num + 1;
             end;
             //
             // сначала ObjectDesc
             if GetArrayList_Index_byValue(ArrayObjectDesc,FieldByName('DescName').AsString) < 0 then
             begin
                  // коммент
                  StrPack:= StrPack + ' -- NEW Desc' + nextL;
                  //
                  StrPack:= StrPack
                          + nextL
                          + '   CREATE OR REPLACE FUNCTION ' + FieldByName('DescName').AsString + '() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + '); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;'
                          + nextL
                          + '   INSERT INTO ObjectDesc (Id, Code, ItemName)'
                          + '   SELECT ' + IntToStr(FieldByName('DescId').AsInteger) + ', ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ', ' + ConvertFromVarChar(FieldByName('ItemName').AsString) + ' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ');'
                          + nextL
                          + nextL;
                  //
                  // добавляем в список - существующие Desc в базе TO
                  SetLength(ArrayObjectDesc,Length(ArrayObjectDesc)+1);
                  ArrayObjectDesc[Length(ArrayObjectDesc)-1]:=FieldByName('DescName').AsString;
             end;
             //
             // обнулили Id
             StrPack:= StrPack + ' vbId:= 0;' + nextL;
             // Нашли Id
             if cbGUID.Checked = TRUE
             then StrPack:= StrPack
                          + ' vbId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_ObjectString_GUID());'
                          + nextL
             else StrPack:= StrPack
                          + ' vbId:= (SELECT Id FROM Object WHERE Id = ' + IntToStr(FieldByName('ObjectId').AsInteger) + ');'
                          + nextL
                          + nextL
                          ;
             // попробовали UPDATE
             StrPack:= StrPack
                     + ' IF vbId > 0 THEN'
                     + nextL
                     + '    UPDATE Object SET DescId      = ' + IntToStr(FieldByName('DescId').AsInteger)
                     + nextL
                     + '                    , ObjectCode  = ' + IntToStr(FieldByName('ObjectCode').AsInteger)
                     + nextL
                     + '                    , ValueData   = ' + ConvertFromVarChar(FieldByName('ValueData').AsString)
                     + nextL
                     + '                    , isErased    = ' + ConvertFromBoolean(FieldByName('isErased').AsBoolean, FALSE)
                     + nextL
                     + '                    , AccessKeyId = ' + ConvertFromInt(FieldByName('AccessKeyId').AsInteger)
                     + nextL
                     + '    WHERE Id = vbId;'
                     + nextL
                     + ' END IF;'
                     + nextL
                     + nextL;
             // иначе INSERT
             if cbGUID.Checked = TRUE
             then StrPack:= StrPack
                          + ' IF NOT FOUND OR COALESCE (vbId, 0) = 0 THEN'
                          + nextL
                          + '    INSERT INTO Object (DescId, ObjectCode, ValueData, AccessKeyId)'
                          + nextL
                          + '    VALUES (' + IntToStr(FieldByName('DescId').AsInteger)
                          +           ', ' + IntToStr(FieldByName('ObjectCode').AsInteger)
                          +           ', ' + ConvertFromVarChar(FieldByName('ValueData').AsString)
                          +           ', ' + ConvertFromInt(FieldByName('AccessKeyId').AsInteger)
                          +           ')'
                          + nextL
                          + '    RETURNING Id INTO vbId;'
                          + nextL
                          + ' END IF;'
                          + nextL
                          + nextL
              else StrPack:= StrPack
                          + ' IF NOT FOUND OR COALESCE (vbId, 0) = 0 THEN'
                          + nextL
                          + '    INSERT INTO Object (Id, DescId, ObjectCode, ValueData, AccessKeyId)'
                          + nextL
                          + '    VALUES (' + IntToStr(FieldByName('ObjectId').AsInteger)
                          +           ', ' + IntToStr(FieldByName('DescId').AsInteger)
                          +           ', ' + IntToStr(FieldByName('ObjectCode').AsInteger)
                          +           ', ' + ConvertFromVarChar(FieldByName('ValueData').AsString)
                          +           ', ' + ConvertFromInt(FieldByName('AccessKeyId').AsInteger)
                          +           ')'
                          + nextL
                          + '     RETURNING Id INTO vbId;'
                          + nextL
                          + nextL
                          + ' END IF;'
                          + nextL
                          + nextL;
             // коммент
             StrPack:= StrPack + ' -----' + nextL;
             // всегда - сохранили  GUID
             StrPack:= StrPack
                        // попробовали UPDATE
                   +    ' UPDATE ObjectString SET ValueData   = ' + ConvertFromVarChar(FieldByName('GUID').AsString)
                   + nextL
                   +    ' WHERE ObjectId = vbId AND DescId = zc_ObjectString_GUID();'
                   + nextL
                   + nextL
                        // иначе INSERT
                    + ' IF NOT FOUND THEN'
                    + nextL
                    + '    INSERT INTO ObjectString (ObjectId, DescId, ValueData)'
                    + nextL
                    + '    VALUES (vbId, zc_ObjectString_GUID(),' + ConvertFromVarChar(FieldByName('GUID').AsString) + ');'
                    + nextL
                    + ' END IF;'
                    + nextL
                    + nextL;
             //
             //
             i:= i+1;
             // коммент
             StrPack:= StrPack + ' ------ end ' + IntToStr(Num_main) + ':' + IntToStr(num) + '/' + IntToStr(i) +' ----------------------' + nextL + nextL;
             //
             if i = CountPack then
             begin
                  i:= 0;
                  // финиш - СКРИПТ
                  StrPack:= StrPack + ' END $$;';
                  //
                  //
                  // !!!сохранили - СКРИПТ!!!
                  resStr:= fExecSqToQuery (StrPack);
                  if resStr = ''
                  then
                      // результат = OK
                      StrPack:= StrPack + ' ------ Result = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
                  else begin
                      // результат = ERROR
                      StrPack:= StrPack + ' ------ Result = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL;
                      // ERROR
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg ('Object' + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
                      AddToMemoMsg (resStr, TRUE);
                      //
                      exit;
                  end;
                  //
                  // !!!сохранили - в ФАЙЛ!!!
                  //ShowMessage (StrPack);
                  AddToLog(StrPack, 'Object', gSessionGUID, false);
                  //
                  // обнулили
                  StrPack:= '';
                  //exit;
             end;
             //
             //
             Next;
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     // еще РАЗ
     if i > 0 then
     begin
          // финиш - СКРИПТ
          StrPack:= StrPack + ' END $$;';
          //
          //
          // !!!сохранили - СКРИПТ!!!
          resStr:= fExecSqToQuery (StrPack);
          if resStr = ''
          then
              // результат = OK
              StrPack:= StrPack + ' ------ Result = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
          else begin
              // результат = ERROR
              StrPack:= StrPack + ' ------ Result = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL;
              // ERROR
              AddToMemoMsg ('', FALSE);
              AddToMemoMsg ('Object' + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
              AddToMemoMsg (resStr, TRUE);
              //
              exit;
          end;
          //
          // !!!сохранили - в ФАЙЛ!!!
          //ShowMessage (StrPack);
          AddToLog(StrPack, 'Object', gSessionGUID, false);
          //
          //
     end;

     except on E:Exception do
       begin
          // ERROR
          AddToMemoMsg ('', FALSE);
          AddToMemoMsg (E.Message, TRUE);
          exit;
       end;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pSendPackTo_ReplObjectProperty(Num_main, CountPack : Integer; QueryData : TClientDataSet) : Boolean;
var StrPack : String;
    i, num  : Integer;
    nextL   : String;
    resStr  : String;
    _PropertyName : String;
    _PropertyValue: String;
    DescId_ins1,DescId_ins2, Value_upd : String;
begin
     Result:= false;
     //
     if not IniConnectionTo (false) then exit;
     //
     try

     i:=0;
     num:=0;
     StrPack:= '';
     nextL  := #13;
     //
     with QueryData do begin
        //
        if (Name =  'fQueryObjectString')  or (Name =  'ObjectStringCDS')  then _PropertyName:= 'ObjectString';
        if (Name =  'fQueryObjectFloat')   or (Name =  'ObjectFloatCDS')   then _PropertyName:= 'ObjectFloat';
        if (Name =  'fQueryObjectDate')    or (Name =  'ObjectDateCDS')    then _PropertyName:= 'ObjectDate';
        if (Name =  'fQueryObjectBoolean') or (Name =  'ObjectBooleanCDS') then _PropertyName:= 'ObjectBoolean';
        if (Name =  'fQueryObjectLink')    or (Name =  'ObjectLinkCDS')    then _PropertyName:= 'ObjectLink';
        //
        First;
        while not EOF  do
        begin
             //!!!
             if fStop then begin exit;end;
             //!!!
             // ЗНАЧЕНИЕ
             if _PropertyName = 'ObjectLink'
             then
             _PropertyValue:= ConvertValueToVarChar(_PropertyName, ''
                                                   , 0
                                                   , StrToDate('01.01.2000'), FALSE
                                                   , FALSE , FALSE
                                                   , FieldByName('ChildObjectId').AsInteger
                                                    )
             else
             _PropertyValue:= ConvertValueToVarChar(_PropertyName, FieldByName('ValueDataS').AsString
                                                   , FieldByName('ValueDataF').AsFloat
                                                   , FieldByName('ValueDataD').AsDateTime, FieldByName('isValuDNull').AsBoolean
                                                   , FieldByName('ValueDataB').AsBoolean , FieldByName('isValuBNull').AsBoolean
                                                   , 0
                                                    );
             //сначала "шапка"
             if StrPack = ''
             then begin
                  StrPack:= ' DO $$' + nextL
                          + ' DECLARE vbId Integer;' + nextL
                          + ' BEGIN' + nextL + nextL + nextL
                          ;
                  num:= num + 1;
             end;
             //
             // сначала Object...Desc
             if GetArrayList_Index_byValue(ArrayObjectDesc,FieldByName('DescName').AsString) < 0 then
             begin
                   DescId_ins1:= '';
                   DescId_ins2:= '';
                   //
                   if _PropertyName = 'ObjectLink'
                   then begin
                            DescId_ins1:= ', ChildObjectDescId';
                            DescId_ins2:= ', ' + ConvertFromInt(FieldByName('ChildObjectDescId').AsInteger);
                   end;
                  // коммент
                  StrPack:= StrPack + ' -- NEW ' + _PropertyName + 'Desc' + nextL;
                  //
                  StrPack:= StrPack
                          + nextL
                          + '   CREATE OR REPLACE FUNCTION ' + FieldByName('DescName').AsString + '() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ' + _PropertyName + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + '); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;'
                          + nextL
                          + '   INSERT INTO ' + _PropertyName + 'Desc (Id, Code, DescId' + DescId_ins1+ ', ItemName)'
                          + '   SELECT ' + IntToStr(FieldByName('DescId').AsInteger) + ', ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ', ' + IntToStr(FieldByName('ObjectDescId').AsInteger) + DescId_ins2 + ',' + ConvertFromVarChar(FieldByName('ItemName').AsString) + ' WHERE NOT EXISTS (SELECT * FROM ' + _PropertyName + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ');'
                          + nextL
                          + nextL;
                  //
                  // добавляем в список - существующие Desc в базе TO
                  SetLength(ArrayObjectDesc,Length(ArrayObjectDesc)+1);
                  ArrayObjectDesc[Length(ArrayObjectDesc)-1]:=FieldByName('DescName').AsString;
             end;
             //
             // обнулили Id
             StrPack:= StrPack + ' vbId:= 0;' + nextL;
             // Нашли Id
             if cbGUID.Checked = TRUE
             then StrPack:= StrPack
                          + ' vbId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_ObjectString_GUID());'
                          + nextL
             else StrPack:= StrPack
                          + ' vbId:= ' + IntToStr(FieldByName('ObjectId').AsInteger) + ';'
                          + nextL
                          + nextL
                          ;
             //
             if _PropertyName = 'ObjectLink'
             then Value_upd := 'ChildObjectId'
             else Value_upd := 'ValueData';
             //
             // попробовали UPDATE
             StrPack:= StrPack
                     + '    UPDATE ' + _PropertyName + ' SET ' + Value_upd + ' = ' + _PropertyValue
                     + nextL
                     + '    WHERE ObjectId = vbId and DescId = ' + IntToStr(FieldByName('DescId').AsInteger) + ' ;' + ' -- ' + FieldByName('DescName').AsString
                     + nextL
                     + nextL;
             // иначе INSERT
             StrPack:= StrPack
                    + ' IF NOT FOUND THEN'
                    + nextL
                    + '    INSERT INTO ' + _PropertyName + ' (DescId, ObjectId, ' + Value_upd + ')'
                    + nextL
                    + '    VALUES (' + IntToStr(FieldByName('DescId').AsInteger)
                    +           ', vbId'
                    +           ', ' + _PropertyValue
                    +           ');'
                    + nextL
                    + ' END IF;'
                    + nextL
                    + nextL;
             //
             //
             i:= i+1;
             // коммент
             StrPack:= StrPack + ' ------ end ' + IntToStr(Num_main) + ':' + IntToStr(num) + '/' + IntToStr(i) +' ----------------------' + nextL + nextL;
             //
             if i = CountPack then
             begin
                  i:= 0;
                  // финиш - СКРИПТ
                  StrPack:= StrPack + ' END $$;' + nextL + nextL;
                  //
                  //
                  // !!!сохранили - СКРИПТ!!!
                  resStr:= fExecSqToQuery (StrPack);
                  if resStr = ''
                  then
                      // результат = OK
                      StrPack:= StrPack + ' ------ Result (' + _PropertyName + ') = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
                  else begin
                      // результат = ERROR
                      StrPack:= StrPack + ' ------ Result (' + _PropertyName + ') = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + ':' + nextL + resStr + nextL + nextL;
                      // ERROR
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (_PropertyName + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
                      AddToMemoMsg (resStr, TRUE);
                      //
                      exit;
                  end;
                  //
                  // !!!сохранили - в ФАЙЛ!!!
                  AddToLog(StrPack, _PropertyName, gSessionGUID, false);
                  //
                  // обнулили
                  StrPack:= '';
                  //exit;
             end;
             //
             //
             Next;
             //
             Gauge.Progress:=Gauge.Progress+1;
             Application.ProcessMessages;
        end;
     end;
     //
     // еще РАЗ
     if i > 0 then
     begin
          // финиш - СКРИПТ
          StrPack:= StrPack + ' END $$;' + nextL + nextL;
          //
          //
          // !!!сохранили - СКРИПТ!!!
          resStr:= fExecSqToQuery (StrPack);
          if resStr = ''
          then
              // результат = OK
              StrPack:= StrPack + ' ------ Result (' + _PropertyName + ') = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
          else begin
              // результат = ERROR
              StrPack:= StrPack + ' ------ Result (' + _PropertyName + ') = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + ':' + nextL + resStr + nextL + nextL;
              // ERROR
              AddToMemoMsg ('', FALSE);
              AddToMemoMsg (_PropertyName + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
              AddToMemoMsg (resStr, TRUE);
              //
              exit;
          end;
          //
          // !!!сохранили - в ФАЙЛ!!!
          //ShowMessage (StrPack);
          AddToLog(StrPack, _PropertyName, gSessionGUID, false);
          //
          //
     end;

     except on E:Exception do
       begin
          // ERROR
          AddToMemoMsg ('', FALSE);
          AddToMemoMsg (E.Message, TRUE);
          exit;
       end;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSendAllTo_ReplObjectDesc;
var StrPack, nextL, resStr : String;
    lGUID : String;
    DescId_ins1,DescId_ins2,DescId_upd : String;
begin
     MemoMsg.Lines.Clear;
     //
     //
     nextL  := #13;
     lGUID:= GenerateGUID;
     //
     // Подключились к серверу From
     if not IniConnectionFrom (TRUE) then exit;
     // Подключились к серверу To
     if not IniConnectionTo (FALSE)   then exit;
     //
     // открыли данные с... по...
     with fromSqlQuery,Sql do
     begin
           Clear;
           //
           Add('select 1 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('Object') + ' as GroupId from ObjectDesc');
           Add('union all');
           Add('select 2 AS NPP, Id,      DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectString') + ' as GroupId from ObjectStringDesc');
           Add('union all');
           Add('select 3 AS NPP, Id,      DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectFloat') + ' as GroupId from ObjectFloatDesc');
           Add('union all');
           Add('select 4 AS NPP, Id,      DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectDate') + ' as GroupId from ObjectDateDesc');
           Add('union all');
           Add('select 5 AS NPP, Id,      DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectBoolean') + ' as GroupId from ObjectBooleanDesc');
           Add('union all');
           Add('select 6 AS NPP, Id,      DescId,      ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectLink') + ' as GroupId from ObjectLinkDesc');
           Add('order by 1, 2');
           //
           Open;
           // если только просмотр - !!!ВЫХОД!!!
           if cbOnlyOpen.Checked = TRUE then exit;
           //
           Gauge.Progress:= 0;
           Gauge.MaxValue:= RecordCount;
           AddToMemoMsg('Desc Count : ' + IntToStr (RecordCount), FALSE);
           //
           while not EOF do
           begin
             //!!!
             if fStop then begin exit;end;
             //!!!
             //сначала "шапка"
             StrPack:= ' DO $$' + nextL
                     + ' DECLARE vbAdd TVarChar;' + nextL
                     + ' BEGIN' + nextL + nextL;
             //
             StrPack:= StrPack
                     + ' CREATE OR REPLACE FUNCTION ' + FieldByName('Code').AsString + '() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('Code').AsString) + '); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;'
                     + nextL;
             //
             //
             DescId_ins1:= '';
             DescId_ins2:= '';
             DescId_upd := '';
             //
             if FieldByName('GroupId').AsString = 'ObjectLink'
             then begin
                       DescId_ins1:= ', DescId, ChildObjectDescId';
                       DescId_ins2:= ', ' + ConvertFromInt(FieldByName('DescId').AsInteger)
                                    + ',' + ConvertFromInt(FieldByName('ChildObjectDescId').AsInteger);
                       DescId_upd := ', DescId = '   + ConvertFromInt(FieldByName('DescId').AsInteger)
                                   + ', ChildObjectDescId = '   + ConvertFromInt(FieldByName('ChildObjectDescId').AsInteger);
             end else
             if FieldByName('GroupId').AsString <> 'Object'
             then begin
                       DescId_ins1:= ', DescId';
                       DescId_ins2:= ', ' + ConvertFromInt(FieldByName('DescId').AsInteger);
                       DescId_upd := ', DescId = '   + ConvertFromInt(FieldByName('DescId').AsInteger);
             end;
                 //сначала УДАЛИЛИ - "ВДРУГ" есть дубли
                 {StrPack:= StrPack + nextL
                          + ' IF EXISTS (SELECT Code FROM ' + FieldByName('GroupId').AsString + 'Desc GROUP BY Code HAVING COUNT(*) > 1)'
                           + nextL
                          // УДАЛИЛИ
                          +' THEN DELETE FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code IN (SELECT Code FROM ' + FieldByName('GroupId').AsString + 'Desc GROUP BY Code HAVING COUNT(*) > 1)'
                          + nextL
                          + ' AND Id NOT IN (SELECT DISTINCT DescId FROM ' + FieldByName('GroupId').AsString +')'
                          + ';' + nextL
                          +' END IF;' + nextL + nextL;}

                 //сначала "проверка" - вдруг есть но под другим АЙДИ
                 StrPack:= StrPack + nextL
                          + ' IF EXISTS (SELECT * FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('Code').AsString) + ')'
                           + nextL
                          +'  AND ' + IntToStr(FieldByName('Id').AsInteger) + ' <> (SELECT Id FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('Code').AsString) + ')'
                           + nextL
                          // будет "виртуальный"
                          +' THEN vbAdd := ' + ConvertFromVarChar('_') + ';' + nextL
                          // будет "обычный"
                          +' ELSE vbAdd := ' + ConvertFromVarChar('') + ';' + nextL
                          +' END IF;' + nextL + nextL
                     //
                     // попробовали "главный" UPDATE
                     + ' UPDATE ' + FieldByName('GroupId').AsString + 'Desc'
                     +                      ' SET Code = '  + ConvertFromVarChar(FieldByName('Code').AsString)
                     +                      ', ItemName = ' + ConvertFromVarChar(FieldByName('ItemName').AsString)
                     +  DescId_upd
                     + ' WHERE Id = ' + IntToStr(FieldByName('Id').AsInteger) + ';'
                     + nextL + nextL
                     // иначе INSERT
                     + ' IF NOT FOUND THEN'
                     + nextL
                     + '    INSERT INTO ' + FieldByName('GroupId').AsString + 'Desc (Id, Code, ItemName' + DescId_ins1 + ')'
                     + nextL
                     + '    VALUES (' + IntToStr(FieldByName('Id').AsInteger)
                     +           ', ' + ConvertFromVarChar(FieldByName('Code').AsString) + ' || vbAdd'
                     +           ', ' + ConvertFromVarChar(FieldByName('ItemName').AsString)
                     + DescId_ins2
                     +           ');'
                     + nextL
                     + ' END IF;'
                     + nextL
                     + nextL
                     //если есть но под другим АЙДИ - меняем на НОВОЕ
                     + ' UPDATE ' + FieldByName('GroupId').AsString + ' SET DescId = ' + IntToStr(FieldByName('Id').AsInteger)
                     + nextL
                     + ' WHERE DescId = (SELECT Id FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('Code').AsString) + ')'
                     + nextL
                     +'  AND vbAdd = ' + ConvertFromVarChar('_') + ';'
                     + nextL
                     + nextL
                     //УДАЛЯЕМ под другим АЙДИ - меняем на НОВОЕ
                     + ' DELETE FROM ' + FieldByName('GroupId').AsString + 'Desc'
                     + nextL
                     + ' WHERE Id = (SELECT Id FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('Code').AsString) + ')'
                     + nextL
                     +'  AND vbAdd = ' + ConvertFromVarChar('_') + ';'
                     + nextL
                     + nextL
                     // еще раз, если был "виртуальный" - меняем на НОРМАЛЬНОЕ значение
                     + ' UPDATE ' + FieldByName('GroupId').AsString + 'Desc'
                     +    ' SET Code = ' + ConvertFromVarChar(FieldByName('Code').AsString)
                     + ' WHERE Id = ' + IntToStr(FieldByName('Id').AsInteger)
                     + nextL
                     +'  AND vbAdd = ' + ConvertFromVarChar('_') + ';'
                     + nextL
                     + nextL
                      ;
            //
            // финиш - СКРИПТ
            StrPack:= StrPack + ' END $$;' + nextL + nextL;
            //
            //
            // !!!сохранили - СКРИПТ!!!
            resStr:= fExecSqToQuery (StrPack);
            if resStr = ''
            then
                // результат = OK
                StrPack:= StrPack + ' ------ Result = OK' + nextL + nextL
            else begin
                // результат = ERROR
                StrPack:= StrPack + ' ------ Result = ERROR : ' + nextL + nextL;
                // ERROR
                AddToMemoMsg ('', FALSE);
                AddToMemoMsg (FieldByName('GroupId').AsString, FALSE);
                AddToMemoMsg (resStr, TRUE);
            end;
            //
            // !!!сохранили - в ФАЙЛ!!!
            AddToLog(StrPack, 'ObjectDesc', lGUID, false);
            //
            //
            Next;
            //
            Gauge.Progress:=Gauge.Progress+1;
            Application.ProcessMessages;
            //
           end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pSendAllTo_ReplProc : Boolean;
var lGUID : String;
    tmp : String;
    lProcText : String;
begin
    Result:= false;
    //
    MemoMsg.Lines.Clear;
    //
    //
    lGUID:= GenerateGUID;
    //
    // Подключились к серверу From
    if not IniConnectionFrom (TRUE) then exit;
    //
    try
    // открыли данные с... по...
    with fromSqlQuery,Sql do
    begin
         Clear;
         //
         if EditObjectDescId.Text <> ''
         then tmp:= ' AND p.oid = ' + EditObjectDescId.Text
         else tmp:= '';
         //
         Add('select p.oid, p.ProName from pg_proc AS p join pg_namespace AS n on n.oid = p.pronamespace where n.nspname = ' + ConvertFromVarChar('public') + ' and p.oid > ' + IntToStr(ArrayReplServer[1].OID_last) + tmp + ' order by p.oid');
         //
         Open;
         //
         ObjectDS.DataSet:=fromSqlQuery;
         //
         // если только просмотр - !!!ВЫХОД!!!
         if cbOnlyOpen.Checked = TRUE then exit;
         //
         Gauge.Progress:= 0;
         Gauge.MaxValue:= RecordCount;
         AddToMemoMsg('Proc Count : ' + IntToStr (RecordCount), FALSE);
         //
         while not EOF  do
         begin
              //!!!
              if fStop then begin exit;end;
              //
              fOpenSqFromQuery_two ('select * from gpSelect_ReplProc (' + FieldByName('oid').AsString + ', CAST (NULL AS TVarChar))');
              //
              lProcText:= fromSqlQuery_two.FieldByName('ProcText').AsString;
              if System.Pos(AnsiUpperCase('CREATE OR REPLACE'),AnsiUpperCase(lProcText)) > 0
              then
                if System.Pos(AnsiUpperCase('begin'),AnsiUpperCase(lProcText)) > 0
                then System.Insert(#10+#13 + ' --- replicate --- ' +#10+#13, lProcText, System.Pos(AnsiUpperCase('begin'),AnsiUpperCase(lProcText)))
                else ShowMessage ('not find - begin : ' + FieldByName('ProName').AsString);
              //
              if lProcText <> '' then
              begin
                  spExecSql.ParamByName('inSqlText').Value  := fromSqlQuery_two.FieldByName('ProcText').AsString;
                  try spExecSql.Execute;
                      //
                      MemoMsg.Lines.Add(FieldByName('ProName').AsString);
                  except on E:Exception do
                     begin
                        // ERROR
                        AddToMemoMsg ('', FALSE);
                        AddToMemoMsg (' ..... ERROR .....', FALSE);
                        AddToMemoMsg ('', FALSE);
                        AddToMemoMsg (lProcText, FALSE);
                        AddToMemoMsg ('', FALSE);
                        AddToMemoMsg (FieldByName('ProName').AsString, FALSE);
                        if Pos('zc_', FieldByName('ProName').AsString) = 1
                        then AddToMemoMsg (E.Message, TRUE)
                        else AddToMemoMsg (E.Message, TRUE);
                        AddToMemoMsg ('', FALSE);
                     end;
                  end;
                  //
                  // !!!сохранили - в ФАЙЛ!!!
                  AddToLog(lProcText, FieldByName('ProName').AsString, lGUID, false);
              end;
              //
              Next;
              //
              Gauge.Progress:=Gauge.Progress+1;
              Application.ProcessMessages;
         end;
    end;
     except on E:Exception do
       begin
          // ERROR
          AddToMemoMsg ('', FALSE);
          AddToMemoMsg (E.Message, TRUE);
          exit;
       end;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.AddToMemoMsg(S : String; isError : Boolean);
var
  LogStr: string;
  LogFileName: string;
  LogFile: TextFile;
  LogFileName_err: string;
  LogFile_err: TextFile;
begin
    MemoMsg.Lines.Add(S);
    //
    Application.ProcessMessages;
    // LogStr := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + S;
    LogStr := S;
    LogFileName := ChangeFileExt(Application.ExeName, '') + '\' + FormatDateTime('yyyy-mm-dd', Date) + '.log';

    AssignFile(LogFile, LogFileName);

    if FileExists(LogFileName) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    Writeln(LogFile, LogStr);
    CloseFile(LogFile);
    Application.ProcessMessages;
    //
    if isError = TRUE then
    begin
        LogFileName_err := ChangeFileExt(Application.ExeName, '') + '\' + FormatDateTime('yyyy-mm-dd', Date) + '-ERR' + '.log';
        AssignFile(LogFile_err, LogFileName_err);
        if FileExists(LogFileName_err) then
          Append(LogFile_err)
        else
          Rewrite(LogFile_err);
        //
        Writeln(LogFile_err, '---------------------------');
        Writeln(LogFile_err, DateTimeToStr(now));
        Writeln(LogFile_err, LogStr);
        CloseFile(LogFile_err);
        Application.ProcessMessages;
    end;

end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.AddToLog(S, myFile, myFolder: string; isError : Boolean);
var
  LogFileName: string;
  LogFile: TextFile;
begin
  Application.ProcessMessages;

  myFolder:= ReplaceStr(myFolder, ':', '_');

  ForceDirectories(ChangeFileExt(Application.ExeName, '') + '\' + myFolder);

  LogFileName := ChangeFileExt(Application.ExeName, '') + '\' + myFolder + '\' + myFile + '.log';

  AssignFile(LogFile, LogFileName);

  if FileExists(LogFileName) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  Writeln(LogFile, s);
  CloseFile(LogFile);
  Application.ProcessMessages;
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pSendAllTo_ReplObject : Boolean;
var StartId, EndId : Integer;
    num : Integer;
begin
  try
     Result:= false;
     //
     MemoMsg.Lines.Clear;
     //
     // Подключились к серверу From
     // --- if not IniConnectionFrom(not cbClientDataSet.Checked) then exit;
     // Подключились к серверу To
     // --- if not IniConnectionTo (TRUE) then exit;
     //
     // Зафиксировали ВСЕ данные на сервере From
     if not pInsert_ReplObject then exit;
     //
     // стартовый период для Id
     StartId:= outMinId;
     EndId  := StartId + outCountIteration;
     num    := 0;

     while StartId <= outMaxId do
     begin
          AddToMemoMsg(' ....................', FALSE);
          //!!!
          Application.ProcessMessages;
          if fStop then begin exit;end;
          //!!!
          num:= num + 1;

          // открыли данные с... по...
          if not pOpen_ReplObject (FALSE, num, StartId, EndId) then exit;
          //
          // если только просмотр - !!!ВЫХОД!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //делаем скрипт на НЕСКОЛЬКО пакетов и сохраняем данные в БАЗЕ-To
          if not pSendPackTo_ReplObject(num, outCountPack)
          then exit;
          //ObjectString - на НЕСКОЛЬКО пакетов и ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectStringCDS)) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectString)) then exit else;
          //ObjectFloat - на НЕСКОЛЬКО пакетов и ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectFloatCDS)) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectFloat)) then exit else;
          //ObjectDate - на НЕСКОЛЬКО пакетов и ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectDateCDS)) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectDate)) then exit else;
          //ObjectBoolean - на НЕСКОЛЬКО пакетов и ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectBooleanCDS)) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectBoolean)) then exit else;
          //
          // следующий период для Id
          StartId:= EndId + 1;
          EndId  := StartId + outCountIteration;
     end;
     //


     // стартовый период для Id
     StartId:= outMinId;
     EndId  := StartId + outCountIteration;
     num    := 0;

     while StartId <= outMaxId do
     begin
          num:= num + 1;

          // открыли данные с... по...
          if not pOpen_ReplObject (TRUE, num, StartId, EndId) then exit;
          //
          // если только просмотр - !!!ВЫХОД!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //ObjectLink - на НЕСКОЛЬКО пакетов и ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectLinkCDS)) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectLink)) then exit else;
          //
          // следующий период для Id
          StartId:= EndId + 1;
          EndId  := StartId + outCountIteration;
     end;
     //
     //
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' ..... end Guide', FALSE);
     //
     Result:= true;

  finally
      if (cbOnlyOpen.Checked = FALSE) and (fStop = FALSE) then
      begin
         fQueryObject.Close;
         fQueryObjectString.Close;
         fQueryObjectFloat.Close;
         fQueryObjectDate.Close;
         fQueryObjectBoolean.Close;
         fQueryObjectLink.Close;
         //
         ObjectCDS.Close;
         ObjectStringCDS.Close;
         ObjectFloatCDS.Close;
         ObjectDateCDS.Close;
         ObjectBooleanCDS.Close;
         ObjectLinkCDS.Close;
      end;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
     Gauge.Visible:=false;
     Gauge.Progress:=0;
     //
     MemoMsg.Clear;
     //
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'qsxqsxw1', gc_User);
     if not Assigned (gc_User) then ShowMessage ('not Assigned (gc_User)');
     //
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
     if MessageDlg('Действительно загрузить данные?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
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
     //
     if cbProc.Checked = TRUE then
     begin
          pSendAllTo_ReplProc;
     end
     else if cbDesc.Checked = TRUE then
     begin
          pSendAllTo_ReplObjectDesc;
     end
     else begin
          pSendAllTo_ReplObject;
     end;
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
         if fStop then if cbProc.Checked = TRUE
                       then ShowMessage('CREATE OR REPLACE FUNCTION НЕ загружены. Time=('+StrTime+').')
                       else
                       if cbDesc.Checked = TRUE
                       then ShowMessage('ObjectDesc + MovementDesc + zc_ObjectString_Enum НЕ загружены. Time=('+StrTime+').')
                       else ShowMessage('Данные НЕ загружены. Time=('+StrTime+').')
                  else if cbProc.Checked = TRUE
                       then ShowMessage('CREATE OR REPLACE FUNCTION загружены. Time=('+StrTime+').')
                       else
                       if cbDesc.Checked = TRUE
                       then ShowMessage('ObjectDesc + MovementDesc + zc_ObjectString_Enum загружены. Time=('+StrTime+').')
                       else ShowMessage('Данные загружены. Time=('+StrTime+').') ;
//     else OKPOEdit.Text:=OKPOEdit.Text + ' Guide:'+StrTime;
     //
     fStop:=true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

end.


