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
    spSelect_ReplObject: TdsdStoredProc;
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
    spSelect_ReplServer_load: TdsdStoredProc;
    ReplServerCDS: TClientDataSet;
    LabelObjectDescId: TLabel;
    PanelInfoObject: TPanel;
    PanelGridObjectString: TPanel;
    DBGridObjectString: TDBGrid;
    PanelInfoObjectString: TPanel;
    LabelObjectString: TLabel;
    PanelGridObjectFloat: TPanel;
    DBGridObjectFloat: TDBGrid;
    PanelInfoObjectFloat: TPanel;
    LabelObjectFloat: TLabel;
    PanelGridObjectDate: TPanel;
    DBGridObjectDate: TDBGrid;
    PanelInfoObjectDate: TPanel;
    LabelObjectDate: TLabel;
    PanelGridObjectBoolean: TPanel;
    DBGridObjectBoolean: TDBGrid;
    PanelInfoObjectBoolean: TPanel;
    LabelObjectBoolean: TLabel;
    PanelGridObjectLink: TPanel;
    DBGridObjectLink: TDBGrid;
    PanelInfoObjectLink: TPanel;
    LabelObjectLink: TLabel;
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
    spInsert_ReplObject: TdsdStoredProc;
    EditCountIterationObject: TEdit;
    cbGUID: TCheckBox;
    cbOnlyOpen: TCheckBox;
    PanelError: TPanel;
    MemoMsg: TMemo;
    fromZConnection: TZConnection;
    fromSqlQuery: TZQuery;
    fromSqlQuery_two: TZQuery;
    fQueryObject: TZQuery;
    fQueryObjectString: TZQuery;
    fQueryObjectFloat: TZQuery;
    fQueryObjectDate: TZQuery;
    fQueryObjectBoolean: TZQuery;
    fQueryObjectLink: TZQuery;
    cbClientDataSet: TCheckBox;
    spSelect_ReplObjectString: TdsdStoredProc;
    spSelect_ReplObjectFloat: TdsdStoredProc;
    spSelect_ReplObjectDate: TdsdStoredProc;
    spSelect_ReplObjectBoolean: TdsdStoredProc;
    spSelect_ReplObjectLink: TdsdStoredProc;
    cbShowGrid: TCheckBox;
    spExecSql_repl_to: TdsdStoredProc;
    cbProc: TCheckBox;
    cbDesc: TCheckBox;
    cbObject: TCheckBox;
    cbObjectHistory: TCheckBox;
    EditMaxIdObject: TEdit;
    EditMinIdObject: TEdit;
    EditCountObject: TEdit;
    EditCountStringObject: TEdit;
    EditCountFloatObject: TEdit;
    EditCountDateObject: TEdit;
    EditCountBooleanObject: TEdit;
    EditCountLinkObject: TEdit;

    procedure OKGuideButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ButtonPanelDblClick(Sender: TObject);
  private
    fBegin_All : Boolean;
    fStop : Boolean;
    gSessionGUID : String;
    outMinId, outMaxId, outCountIteration, outCountPack : Integer;
    outCount, outCountString, outCountFloat, outCountDate, outCountBoolean, outCountLink : Integer;
    outCountHistory, outCountHistoryString, outCountHistoryFloat, outCountHistoryDate, outCountHistoryLink : Integer;

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
    //function fOpenSqToQuery_two (mySql:String):Boolean;
    //function fExecSqToQuery_two (mySql:String):Boolean;

    function fExecSql_repl_to (mySql:String):String;

    procedure CursorGridChange;

    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);

    function gpSelect_ReplServer_load: TArrayReplServer;
    function IniConnectionFrom (isConnected : Boolean): Boolean;
    function IniConnectionTo   (_PropertyName : String; isGetDesc   : Boolean): Boolean;

    function fObject_andProperty_while : Boolean;
    function fObjectLink_while : Boolean;
    function fObjectHistory_while : Boolean;
    function fObjectHistory_Property_while : Boolean;

    function pInsert_ReplObject : Boolean;
    function pSendAllTo_ReplObject  : Boolean;
    function pOpen_ReplObject (isObjectLink : Boolean; Num_main : Integer; StartId, EndId : LongInt; isHistory : Boolean) : Boolean;
    function pSendPackTo_ReplObject(Num_main, CountPack : Integer; isHistory : Boolean) : Boolean;
    function pSendPackTo_ReplObjectProperty(Num_main, CountPack : Integer; CDSData : TClientDataSet; isHistory : Boolean) : Boolean;
    function fMove_ObjectHistory_repl : Boolean;

    procedure AddToLog(S, myFile, myFolder: string; isError : Boolean);
    procedure AddToMemoMsg(S: String; isError : Boolean);

    procedure pSendAllTo_ReplObjectDesc;
    function pSendAllTo_ReplProc : Boolean;

    function pBegin_All : Boolean;

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
function GetIndexParams(execParams:TParams;FindName:String):Integer;//���������� ������ �������� ���������� FindName � TParams
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
    lCDS : TClientDataSet;
begin
    rgReplServer.Items.Clear;
    //
    if cbClientDataSet.Checked = TRUE
    then
      with spSelect_ReplServer_load do
      begin
         // !!!���� ��� - �����������!!!
         if Assigned(ArrayReplServer)
         then ParamByName('gConnectHost').Value := ArrayReplServer[0].HostName
         else ParamByName('gConnectHost').Value := 'integer-srv2.alan.dp.ua';
         Execute;
         lCDS:= TClientDataSet(DataSet);
      end
    else
    begin
         // ������������ � ������� From - �����������
         if not IniConnectionFrom (TRUE) then exit;
         fOpenSqFromQuery ('select * from gpSelect_ReplServer_load (CAST (NULL AS TVarChar), CAST (NULL AS TVarChar))');
         lCDS:= TClientDataSet(fromSqlQuery);
    end;
    //
    with lCDS do
    begin
         First;
         //
         if Assigned (Result) then begin SetLength(Result, 0);Finalize(Result);Result:=nil;end;
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
         ShowMessage('������ ��������� - gpSelect_ReplServer_load');
       end;}
    end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.StopButtonClick(Sender: TObject);
begin
     if MessageDlg('������������� ���������� ��������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
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
       if MessageDlg('������������� ���������� �������� � �����?',mtConfirmation,[mbYes,mbNo],0)=mrYes
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
function TMainForm.fExecSql_repl_to (mySql:String):String;
begin
     Result:= '';
     //
     with spExecSql_repl_to do
     begin
          ParamByName('inSqlText').Value    := mySql;
          ParamByName('gConnectHost').Value := '';
          try Execute;
          except on E:Exception do Result:= E.Message;
          end;
     end;
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
{function TMainForm.fOpenSqToQuery_two (mySql:String):Boolean;
begin
     with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try Open
        except ShowMessage('fOpenSqToQuery'+#10+#13+mySql);Result:=false;exit;
        end;
     end;
     Result:=true;
end;}
//----------------------------------------------------------------------------------------------------------------------------------------------------
{function TMainForm.fExecSqToQuery_two (mySql:String):Boolean;
begin
     with toSqlQuery_two,Sql do begin
        Clear;
        Add(mySql);
        try ExecSql except ShowMessage('fExecSqToQuery'+#10+#13+mySql);Result:=false;exit;end;
     end;
     Result:=true;
end;}
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
     if (PropertyName = 'ObjectString')or(PropertyName = 'ObjectHistoryString')
     then Result:= ConvertFromVarChar(_ValueS)
     else
     if (PropertyName = 'ObjectFloat')or(PropertyName = 'ObjectHistoryFloat')
     then Result:= ConvertFromFloat(_ValueF)
     else
     if (PropertyName = 'ObjectDate')or(PropertyName = 'ObjectHistoryDate')
     then Result:= ConvertFromDateTime(_ValueD, _isNullD)
     else
     if (PropertyName = 'ObjectBoolean')
     then Result:= ConvertFromBoolean(_ValueB, _isNullB)
     else
     if (PropertyName = 'ObjectLink')or(PropertyName = 'ObjectHistoryLink')
     then Result:= ConvertFromInt(ChildObjectId)
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
       //if �bNotVisibleCursor.Checked
       //then DBGrid.DataSource.DataSet.DisableControls
       //else DBGrid.DataSource.DataSet.EnableControls;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.ButtonPanelDblClick(Sender: TObject);
begin
     gc_isDebugMode:=not gc_isDebugMode;
     if gc_isDebugMode = TRUE
     then ShowMessage ('������� - ��������')
     else ShowMessage ('������� - ���������');

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.IniConnectionFrom(isConnected : Boolean): Boolean;
//From: ���������� - ������
begin
     // ���� �� ����������� - �������
     if isConnected = FALSE then begin Result:= true; exit; end;
     //
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
function TMainForm.IniConnectionTo (_PropertyName : String; isGetDesc: Boolean) : Boolean;
//To:   ���������� - ������
var i : Integer;
begin
     Result:= false;
     //
     try
     //
     AddToMemoMsg('----- startConnect To(' + _PropertyName + '):', FALSE);
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

        if Result then rgReplServer.ItemIndex:= 1
        else rgReplServer.ItemIndex:= 0;

     end;
     //
     if (Result = true) and (isGetDesc = true) then
     with toSqlQuery_two,Sql do
     begin
           Clear;
           //
           // ������ - ������������ Desc � ���� TO
           // Object...
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
           // ObjectHistory...
           Add('union all');
           Add('select Code AS DescName, Id from ObjectHistoryDesc');
           Add('union all');
           Add('select Code AS DescName, Id from ObjectHistoryStringDesc');
           Add('union all');
           Add('select Code AS DescName, Id from ObjectHistoryFloatDesc');
           Add('union all');
           Add('select Code AS DescName, Id from ObjectHistoryDateDesc');
           Add('union all');
           Add('select Code AS DescName, Id from ObjectHistoryLinkDesc');
           //
           Open;
           //
           if Assigned (ArrayObjectDesc) then begin SetLength(ArrayObjectDesc, 0);Finalize(ArrayObjectDesc);ArrayObjectDesc:=nil;end;
           SetLength(ArrayObjectDesc,RecordCount);
           i:=0;
           //
           while not EOF do
           begin
                // �������� � ������ - ������������ Desc � ���� TO
                ArrayObjectDesc[i]:=FieldByName('DescName').AsString;
                //
                Next;
                i:=i+1;
           end;
           //
           Close;
     end;
     //
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Connect', FALSE);
     //
     except on E:Exception do
       begin
          // ERROR
          AddToMemoMsg ('', FALSE);
          AddToMemoMsg (' ??? procedure IniConnectionTo ???', TRUE);
          AddToMemoMsg (E.Message, TRUE);
          Result:= false;
          exit;
       end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pInsert_ReplObject : Boolean;
//From: ���������� �� ����� cbClientDataSet - ���� ��� ����� ������
begin
     Result:= false;

     try

     gSessionGUID:= GenerateGUID;
     //
     AddToMemoMsg('----- gSessionGUID:', FALSE);
     AddToMemoMsg(gSessionGUID, FALSE);
     //
     if cbClientDataSet.Checked = TRUE
     then
       with spInsert_ReplObject do
       begin
           ParamByName('inSessionGUID').Value:= gSessionGUID;
           ParamByName('inStartDate').Value  := ArrayReplServer[1].Start_toChild;
           ParamByName('inDescCode').Value   := EditObjectDescId.Text;
           ParamByName('gConnectHost').Value := ArrayReplServer[0].HostName;
           ParamByName('inIsProtocol').Value := cbProtocol.Checked;
           ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
           Execute;
           //
           outCount          :=ParamByName('outCount').Value;
           outCountString    :=ParamByName('outCountString').Value;
           outCountFloat     :=ParamByName('outCountFloat').Value;
           outCountDate      :=ParamByName('outCountDate').Value;
           outCountBoolean   :=ParamByName('outCountBoolean').Value;
           outCountLink      :=ParamByName('outCountLink').Value;

           outCountHistory       :=ParamByName('outCountHistory').Value;
           outCountHistoryString :=ParamByName('outCountHistoryString').Value;
           outCountHistoryFloat  :=ParamByName('outCountHistoryFloat').Value;
           outCountHistoryDate   :=ParamByName('outCountHistoryDate').Value;
           outCountHistoryLink   :=ParamByName('outCountHistoryLink').Value;

           outMinId          :=ParamByName('outMinId').Value;
           outMaxId          :=ParamByName('outMaxId').Value;
           outCountIteration :=ParamByName('outCountIteration').Value;
           outCountPack      :=ParamByName('outCountPack').Value;
       end
     else
       with fromSqlQuery do
       begin
           // ������������ � ������� From - �����������
           if not IniConnectionFrom (TRUE) then exit;
           //
           fOpenSqFromQuery ('select * from gpInsert_ReplObject('+ConvertFromVarChar(gSessionGUID)
                            +',' + FormatFromDateTime(ArrayReplServer[1].Start_toChild)
                            +',' + ConvertFromVarChar(EditObjectDescId.Text)
                            +',' + ConvertFromBoolean(cbProtocol.Checked, FALSE)
                            +',' + IntToStr(ArrayReplServer[0].Id)
                            +', CAST (NULL AS TVarChar) '
                            +', CAST (NULL AS TVarChar) '
                            +')');
           //
           outCount          :=FieldByName('outCount').AsInteger;
           outCountString    :=FieldByName('outCountString').AsInteger;
           outCountFloat     :=FieldByName('outCountFloat').AsInteger;
           outCountDate      :=FieldByName('outCountDate').AsInteger;
           outCountBoolean   :=FieldByName('outCountBoolean').AsInteger;
           outCountLink      :=FieldByName('outCountLink').AsInteger;

           outCountHistory       :=FieldByName('outCountHistory').AsInteger;
           outCountHistoryString :=FieldByName('outCountHistoryString').AsInteger;
           outCountHistoryFloat  :=FieldByName('outCountHistoryFloat').AsInteger;
           outCountHistoryDate   :=FieldByName('outCountHistoryDate').AsInteger;
           outCountHistoryLink   :=FieldByName('outCountHistoryLink').AsInteger;

           outMinId          :=FieldByName('outMinId').AsInteger;
           outMaxId          :=FieldByName('outMaxId').AsInteger;
           outCountIteration :=FieldByName('outCountIteration').AsInteger;
           outCountPack      :=FieldByName('outCountPack').AsInteger;
       end;
     //
     //
     AddToMemoMsg('Count : ' + IntToStr (outCount), FALSE);
     AddToMemoMsg('String : ' + IntToStr (outCountString), FALSE);
     AddToMemoMsg('Float : ' + IntToStr (outCountFloat), FALSE);
     AddToMemoMsg('Date : ' + IntToStr (outCountDate), FALSE);
     AddToMemoMsg('Boolean : ' + IntToStr (outCountBoolean), FALSE);
     AddToMemoMsg('Link : ' + IntToStr (outCountLink), FALSE);
     AddToMemoMsg('-', FALSE);
     AddToMemoMsg('CountHistory : ' + IntToStr (outCountHistory), FALSE);
     AddToMemoMsg('HistoryString : ' + IntToStr (outCountHistoryString), FALSE);
     AddToMemoMsg('HistoryFloat : ' + IntToStr (outCountHistoryFloat), FALSE);
     AddToMemoMsg('HistoryDate : ' + IntToStr (outCountHistoryDate), FALSE);
     AddToMemoMsg('HistoryLink : ' + IntToStr (outCountHistoryLink), FALSE);
     AddToMemoMsg('-', FALSE);
     AddToMemoMsg('MinId : ' + IntToStr (outMinId), FALSE);
     AddToMemoMsg('MaxId : ' + IntToStr (outMaxId), FALSE);
     AddToMemoMsg('CountIteration : ' + IntToStr (outCountIteration), FALSE);
     AddToMemoMsg('CountPack : ' + IntToStr (outCountPack), FALSE);
     AddToMemoMsg('-', FALSE);
     //
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Insert', FALSE);

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
function TMainForm.pOpen_ReplObject (isObjectLink : Boolean; Num_main : Integer; StartId, EndId : LongInt; isHistory : Boolean) : Boolean;
var lObject, lObjectString, lObjectFloat, lObjectDate, lObjectBoolean, lObjectLink : String;

    procedure pExec_Select (spName : String; spSelect : TdsdStoredProc);
    begin
       with spSelect do
       begin
           StoredProcName:= spName;
           //
           ParamByName('inSessionGUID').Value:= gSessionGUID;
           ParamByName('inStartId').Value    := StartId;
           ParamByName('inEndId').Value      := EndId;
           ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
           ParamByName('gConnectHost').Value := ArrayReplServer[0].HostName;
           Execute;
       end;
    end;
    procedure pOpen_Select (spName : String; lQuery : TZQuery);
    begin
       with lQuery, Sql do
       begin
           Clear;
           Add ('SELECT * FROM ' + spName + '(' + ConvertFromVarChar(gSessionGUID)
                                           +',' + IntToStr(StartId)
                                           +',' + IntToStr(EndId)
                                           +',' + IntToStr(ArrayReplServer[0].Id)
                                           +',' + ConvertFromVarChar('')
                                           +',zfCalc_UserAdmin())');
           Open;
       end;
    end;
begin
     Result:= false;
     //
     if isHistory = TRUE then
     begin
          lObject        := 'ObjectHistory';
          lObjectString  := 'ObjectHistoryString';
          lObjectFloat   := 'ObjectHistoryFloat';
          lObjectDate    := 'ObjectHistoryDate';
          lObjectBoolean := '';
          lObjectLink    := 'ObjectHistoryLink';
     end
     else
     begin
          lObject        := 'Object';
          lObjectString  := 'ObjectString';
          lObjectFloat   := 'ObjectFloat';
          lObjectDate    := 'ObjectDate';
          lObjectBoolean := 'ObjectBoolean';
          lObjectLink    := 'ObjectLink';
     end;
     //
     // ������������ � ������� From - ���� ����
     if not IniConnectionFrom (not cbClientDataSet.Checked) then exit;
     //
     // �������
     if isObjectLink = TRUE then AddToMemoMsg(' ...', FALSE);
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
     if cbClientDataSet.Checked = TRUE then
     begin
         if cbShowGrid.Checked = True then
         begin
           //
           ObjectDS.DataSet       := ObjectCDS;
           ObjectStringDS.DataSet := ObjectStringCDS;
           ObjectFloatDS.DataSet  := ObjectFloatCDS;
           ObjectDateDS.DataSet   := ObjectDateCDS;
           ObjectBooleanDS.DataSet:= ObjectBooleanCDS;
           ObjectLinkDS.DataSet   := ObjectLinkCDS;
         end;
         //
         if isObjectLink = FALSE then
         begin
           //
           pExec_Select ('gpSelect_Repl' + lObject, spSelect_ReplObject);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObject, FALSE);
           //
           if isHistory = FALSE
           then begin
             //
             pExec_Select ('gpSelect_Repl' + lObjectString, spSelect_ReplObjectString);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectString, FALSE);
             //
             pExec_Select ('gpSelect_Repl' + lObjectFloat, spSelect_ReplObjectFloat);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectFloat, FALSE);
             //
             pExec_Select ('gpSelect_Repl' + lObjectDate, spSelect_ReplObjectDate);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectDate, FALSE);
             //
             pExec_Select ('gpSelect_Repl' + lObjectBoolean, spSelect_ReplObjectBoolean);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectBoolean, FALSE);
           end;
         end
         else
           //
           if isHistory = TRUE
           then begin
             //
             pExec_Select ('gpSelect_Repl' + lObjectString, spSelect_ReplObjectString);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectString, FALSE);
             //
             pExec_Select ('gpSelect_Repl' + lObjectFloat, spSelect_ReplObjectFloat);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectFloat, FALSE);
             //
             pExec_Select ('gpSelect_Repl' + lObjectDate, spSelect_ReplObjectDate);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectDate, FALSE);
             //
             pExec_Select ('gpSelect_Repl' + lObjectLink, spSelect_ReplObjectLink);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectLink, FALSE);
           end
           else begin
             //
             pExec_Select ('gpSelect_Repl' + lObjectLink, spSelect_ReplObjectLink);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectLink, FALSE);
           end;
     end
     else
     begin
         if cbShowGrid.Checked = True then
         begin
           //
           ObjectDS.DataSet       := fQueryObject;
           ObjectStringDS.DataSet := fQueryObjectString;
           ObjectFloatDS.DataSet  := fQueryObjectFloat;
           ObjectDateDS.DataSet   := fQueryObjectDate;
           ObjectBooleanDS.DataSet:= fQueryObjectBoolean;
           ObjectLinkDS.DataSet   := fQueryObjectLink;
         end;
         //
         if isObjectLink = FALSE then
         begin
           //
           pOpen_Select ('gpSelect_Repl' + lObject, fQueryObject);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObject, FALSE);
           //
           if isHistory = FALSE
           then begin
             //
             pOpen_Select ('gpSelect_Repl' + lObjectString, fQueryObjectString);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectString, FALSE);
             //
             pOpen_Select ('gpSelect_Repl' + lObjectFloat, fQueryObjectFloat);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectFloat, FALSE);
             //
             pOpen_Select ('gpSelect_Repl' + lObjectDate, fQueryObjectDate);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectDate, FALSE);
             //
             pOpen_Select ('gpSelect_Repl' + lObjectBoolean, fQueryObjectBoolean);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectBoolean, FALSE);
           end;

         end
         else
           if isHistory = TRUE
           then begin
             //
             pOpen_Select ('gpSelect_Repl' + lObjectString, fQueryObjectString);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectString, FALSE);
             //
             pOpen_Select ('gpSelect_Repl' + lObjectFloat, fQueryObjectFloat);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectFloat, FALSE);
             //
             pOpen_Select ('gpSelect_Repl' + lObjectDate, fQueryObjectDate);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectDate, FALSE);
             //
             pOpen_Select ('gpSelect_Repl' + lObjectLink, fQueryObjectLink);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectLink, FALSE);
           end
           else begin
             //
             pOpen_Select ('gpSelect_Repl' + lObjectLink, fQueryObjectLink);
             AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lObjectLink, FALSE);
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
function TMainForm.pSendPackTo_ReplObject (Num_main, CountPack : Integer; isHistory : Boolean) : Boolean;
//From: ���������� �� ����� cbClientDataSet - ���� ��� ����� ������ (�����. � �����)
//To:   ���������� - ������ - ��������� ������ StrPack
var sHist : String;
var StrPack, nextL : String;
    i, num  : Integer;
    resStr  : String;
    myCDS : TClientDataSet;
    lObject : String;
begin
     Result:= false;
     //
     //
     if isHistory = TRUE then lObject := 'ObjectHistory' else lObject := 'Object';
     if isHistory = TRUE then sHist   := 'History'       else sHist   := '';

     //
     //if cbClientDataSet.Checked = FALSE then
       // ������������ � ������� To
       if not IniConnectionTo (lObject, FALSE) then exit;
     //
     try
     //
     i:=0;
     num:=0;
     StrPack:= '';
     nextL  := #13;
     //
     // � ����� ������ ��� ������� - ������� ��� �� "��������� �������"
     if (Num_main = 1) and (isHistory = TRUE)
     then begin
         StrPack:= ' DO $$' + nextL
                 + ' BEGIN' + nextL + nextL + nextL
                 + ' IF NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower(' + ConvertFromVarChar('ObjectHistory_repl') + '))) THEN'
                 + nextL
                 + '    CREATE TABLE ObjectHistory_repl (Id BigInt PRIMARY KEY,'
                 +                                     ' DescId Integer NOT NULL,'
                 +                                     ' StartDate TDateTime NOT NULL,'
                 +                                     ' EndDate TDateTime NOT NULL,'
                 +                                     ' ObjectId Integer NOT NULL'
                 +                                     ' );'
                 + nextL
                 + ' END IF;'
                 + nextL
                 + nextL
                 + ' TRUNCATE TABLE ObjectHistory_repl;'
                 + nextL
                 + nextL
                 + ' END $$;'
                 + nextL
                 ;
          //
          // !!!��������� - ������!!!
          resStr:= fExecSqToQuery (StrPack);
          if resStr = ''
          then
              // ��������� = OK
              StrPack:= StrPack + ' ------ Result = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
          else begin
              // ��������� = ERROR
              StrPack:= StrPack + ' ------ Result = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL;
              // !!!��������� - � ����!!!
              AddToLog(StrPack, lObject, gSessionGUID, false);
              //
              // ERROR
              AddToMemoMsg ('', FALSE);
              AddToMemoMsg (lObject + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
              AddToMemoMsg (resStr, TRUE);
              //
              exit;
          end;
          //
          // !!!��������� - � ����!!!
          AddToLog(StrPack, lObject, gSessionGUID, false);
          //
          StrPack:= '';
     end;
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
             //������� "�����"
             if StrPack = ''
             then begin
                  StrPack:= ' DO $$' + nextL
                          + ' DECLARE vbId Integer;' + nextL;
                  //
                  if (isHistory = TRUE)
                  then StrPack:= StrPack + ' DECLARE vbObjectId Integer;' + nextL;
                  //
                  StrPack:= StrPack
                          + ' BEGIN' + nextL + nextL + nextL
                          ;
                  num:= num + 1;
             end;
             //
             // ������� ObjectDesc
             if GetArrayList_Index_byValue(ArrayObjectDesc,FieldByName('DescName').AsString) < 0 then
             begin
                  // �������
                  StrPack:= StrPack + ' -- NEW Desc' + nextL;
                  //
                  StrPack:= StrPack
                          + nextL
                          + '   CREATE OR REPLACE FUNCTION ' + FieldByName('DescName').AsString + '() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + '); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;'
                          + nextL
                          + '   INSERT INTO Object'+sHist+'Desc (Id, Code, ItemName)'
                          + '   SELECT ' + IntToStr(FieldByName('DescId').AsInteger) + ', ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ', ' + ConvertFromVarChar(FieldByName('ItemName').AsString) + ' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ');'
                          + nextL
                          + nextL;
                  //
                  // ��������� � ������ - ������������ Desc � ���� TO
                  SetLength(ArrayObjectDesc,Length(ArrayObjectDesc)+1);
                  ArrayObjectDesc[Length(ArrayObjectDesc)-1]:=FieldByName('DescName').AsString;
             end;
             //
             // �������� Id
             if (isHistory = FALSE)
             then
                 StrPack:= StrPack + ' vbId:= 0;' + nextL;
             // ����� Id
             if (isHistory = TRUE)
             then StrPack:= StrPack
                          + ' vbId:= ' + IntToStr(FieldByName('ObjectHistoryId').AsInteger) + ';'
                          + nextL
             else
             if (cbGUID.Checked = TRUE) and (isHistory = FALSE)
             then StrPack:= StrPack
                          + ' vbId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_ObjectString_GUID());'
                          + nextL
             else StrPack:= StrPack
                          + ' vbId:= (SELECT Id FROM Object WHERE Id = ' + IntToStr(FieldByName('ObjectId').AsInteger) + ');'
                          + nextL
                          + nextL
                          ;
             // ����������� UPDATE
             if (isHistory = FALSE)
             then
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
             // ����� INSERT
             if (isHistory = TRUE) then
             begin
                 // ����� ObjectId - ��� ObjectHistory
                 StrPack:= StrPack
                         + ' vbObjectId:= NULL;'
                         + ' IF ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' <> ' + ConvertFromVarChar('')
                         + ' THEN'
                         +       ' vbObjectId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_ObjectString_GUID());'
                         + ' END IF;'
                         + nextL + nextL;
                 //
                 StrPack:= StrPack
                              + '    INSERT INTO ObjectHistory_repl (Id, DescId, StartDate, EndDate, ObjectId)'
                              + nextL
                              + '    VALUES (vbId'
                              +           ', ' + IntToStr(FieldByName('DescId').AsInteger)
                              +           ', ' + ConvertFromDateTime(FieldByName('StartDate').AsDateTime, FALSE)
                              +           ', ' + ConvertFromDateTime(FieldByName('EndDate').AsDateTime, FALSE)
                              +           ', vbObjectId'
                              +           ');'
                              + nextL
                              + nextL;
             end
             else
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
             //
             if (isHistory = FALSE) then
             begin
               // �������
               StrPack:= StrPack + ' -----' + nextL;
               // ������ - ���������  GUID
               StrPack:= StrPack
                          // ����������� UPDATE
                     +    ' UPDATE ObjectString SET ValueData   = ' + ConvertFromVarChar(FieldByName('GUID').AsString)
                     + nextL
                     +    ' WHERE ObjectId = vbId AND DescId = zc_ObjectString_GUID();'
                     + nextL
                     + nextL
                          // ����� INSERT
                      + ' IF NOT FOUND THEN'
                      + nextL
                      + '    INSERT INTO ObjectString (ObjectId, DescId, ValueData)'
                      + nextL
                      + '    VALUES (vbId, zc_ObjectString_GUID(),' + ConvertFromVarChar(FieldByName('GUID').AsString) + ');'
                      + nextL
                      + ' END IF;'
                      + nextL
                      + nextL;
             end;
             //
             //
             i:= i+1;
             // �������
             StrPack:= StrPack + ' ------ end ' + IntToStr(Num_main) + ':' + IntToStr(num) + '/' + IntToStr(i) +' ----------------------' + nextL + nextL;
             //
             if i = CountPack then
             begin
                  i:= 0;
                  // ����� - ������
                  StrPack:= StrPack + ' END $$;';
                  //
                  //
                  // !!!��������� - ������!!!
                  resStr:= fExecSqToQuery (StrPack);
                  if resStr = ''
                  then
                      // ��������� = OK
                      StrPack:= StrPack + ' ------ Result = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
                  else begin
                      // ��������� = ERROR
                      StrPack:= StrPack + ' ------ Result = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL;
                      // !!!��������� - � ����!!!
                      AddToLog(StrPack, lObject, gSessionGUID, false);
                      //
                      // ERROR
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (lObject + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
                      AddToMemoMsg (resStr, TRUE);
                      //
                      exit;
                  end;
                  //
                  // !!!��������� - � ����!!!
                  //ShowMessage (StrPack);
                  AddToLog(StrPack, lObject, gSessionGUID, false);
                  //
                  // ��������
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
     // ��� ���
     if i > 0 then
     begin
          // ����� - ������
          StrPack:= StrPack + ' END $$;';
          //
          //
          // !!!��������� - ������!!!
          resStr:= fExecSqToQuery (StrPack);
          if resStr = ''
          then
              // ��������� = OK
              StrPack:= StrPack + ' ------ Result = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
          else begin
              // ��������� = ERROR
              StrPack:= StrPack + ' ------ Result = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL;
              // !!!��������� - � ����!!!
              AddToLog(StrPack, lObject, gSessionGUID, false);
              //
              // ERROR
              AddToMemoMsg ('', FALSE);
              AddToMemoMsg (lObject + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
              AddToMemoMsg (resStr, TRUE);
              //
              exit;
          end;
          //
          // !!!��������� - � ����!!!
          AddToLog(StrPack, lObject, gSessionGUID, false);
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
function TMainForm.pSendPackTo_ReplObjectProperty(Num_main, CountPack : Integer; CDSData : TClientDataSet; isHistory : Boolean) : Boolean;
//From: ���������� �� ����� cbClientDataSet - ���� ��� ����� ������ (�����. � �����)
//To:   ���������� - ������ - ��������� ������ StrPack
var sHist : String;
var StrPack, nextL : String;
    i, num  : Integer;
    _PropertyName, _PropertyValue, DescId_ins1,DescId_ins2, Value_upd : String;
    resStr : String;
    lObject, lObjectLink : String;
begin
     Result:= false;
     //
     //
     if isHistory = TRUE then lObject := 'ObjectHistory' else lObject := 'Object';
     if isHistory = TRUE then sHist   := 'History'       else sHist   := '';
     //
     try

     i:=0;
     num:=0;
     StrPack:= '';
     nextL  := #13;
     //
     with CDSData do begin
        //
        if (Name =  'fQueryObjectString')  or (Name =  'ObjectStringCDS')  then _PropertyName:= lObject + 'String';
        if (Name =  'fQueryObjectFloat')   or (Name =  'ObjectFloatCDS')   then _PropertyName:= lObject + 'Float';
        if (Name =  'fQueryObjectDate')    or (Name =  'ObjectDateCDS')    then _PropertyName:= lObject + 'Date';
        if (Name =  'fQueryObjectBoolean') or (Name =  'ObjectBooleanCDS') then _PropertyName:= lObject + 'Boolean';
        if (Name =  'fQueryObjectLink')    or (Name =  'ObjectLinkCDS')    then _PropertyName:= lObject + 'Link';
        lObjectLink := lObject + 'Link';
        //
        //if cbClientDataSet.Checked = FALSE then
          // ������������ � ������� To
          if not IniConnectionTo (_PropertyName, FALSE) then exit;
        //
        //
        First;
        while not EOF  do
        begin
             //!!!
             if fStop then begin exit;end;
             //!!!
             // ��������
             if _PropertyName = lObjectLink
             then
               _PropertyValue:= 'vbObjectId'
             else
               _PropertyValue:= ConvertValueToVarChar(_PropertyName, FieldByName('ValueDataS').AsString
                                                     , FieldByName('ValueDataF').AsFloat
                                                     , FieldByName('ValueDataD').AsDateTime, FieldByName('isValuDNull').AsBoolean
                                                     , FieldByName('ValueDataB').AsBoolean , FieldByName('isValuBNull').AsBoolean
                                                     , 0
                                                      );
             //������� "�����"
             if StrPack = ''
             then begin
                  StrPack:= ' DO $$' + nextL
                          + ' DECLARE vbId Integer;' + nextL
                          ;
                  //
                  if (_PropertyName = lObjectLink)
                  then StrPack:= StrPack + ' DECLARE vbObjectId Integer;' + nextL;
                  //
                  StrPack:= StrPack
                          + ' BEGIN' + nextL + nextL + nextL
                          ;
                  num:= num + 1;
             end;
             //
             // ������� Object...Desc
             if GetArrayList_Index_byValue(ArrayObjectDesc,FieldByName('DescName').AsString) < 0 then
             begin
                   DescId_ins1:= '';
                   DescId_ins2:= '';
                   //
                   if (_PropertyName = lObjectLink) and (isHistory = FALSE)
                   then begin
                            DescId_ins1:= ', ChildObjectDescId';
                            DescId_ins2:= ', ' + ConvertFromInt(FieldByName('ChildObjectDescId').AsInteger);
                   end;
                  // �������
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
                  // ��������� � ������ - ������������ Desc � ���� TO
                  SetLength(ArrayObjectDesc,Length(ArrayObjectDesc)+1);
                  ArrayObjectDesc[Length(ArrayObjectDesc)-1]:=FieldByName('DescName').AsString;
             end;
             //
             // �������� Id
             if (isHistory = FALSE)
             then
                 StrPack:= StrPack + ' vbId:= 0;' + nextL;
             //
             //
             if (_PropertyName = lObjectLink)
             then
                 // ����� ObjectId - ��� Link
                 StrPack:= StrPack
                         + ' vbObjectId:= NULL;'
                         + ' IF ' + ConvertFromVarChar(FieldByName('GUID_child').AsString) + ' <> ' + ConvertFromVarChar('')
                         + ' THEN'
                               + ' vbObjectId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID_child').AsString) + ' and DescId = zc_ObjectString_GUID());'
                         + ' END IF;'
                         + nextL + nextL;
             //
             // ����� Id
             if (isHistory = TRUE)
             then StrPack:= StrPack
                          + ' vbId:= ' + IntToStr(FieldByName('ObjectHistoryId').AsInteger) + ';'
                          + nextL
             else
             if (cbGUID.Checked = TRUE) and (isHistory = FALSE)
             then StrPack:= StrPack
                          + ' vbId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_ObjectString_GUID());'
                          + nextL
             else StrPack:= StrPack
                          + ' vbId:= ' + IntToStr(FieldByName('ObjectId').AsInteger) + ';'
                          + nextL
                          + nextL
                          ;
             //
             if (_PropertyName = lObjectLink) and (isHistory = TRUE)
             then Value_upd := 'ObjectId'
             else
             if (_PropertyName = lObjectLink) and (isHistory = FALSE)
             then Value_upd := 'ChildObjectId'
             else Value_upd := 'ValueData';
             //
             // ����������� UPDATE
             StrPack:= StrPack
                     + '    UPDATE ' + _PropertyName + ' SET ' + Value_upd + ' = ' + _PropertyValue
                     + nextL
                     + '    WHERE Object'+sHist+'Id = vbId and DescId = ' + IntToStr(FieldByName('DescId').AsInteger) + ' ;' + ' -- ' + FieldByName('DescName').AsString
                     + nextL
                     + nextL;
             // ����� INSERT
             StrPack:= StrPack
                    + ' IF NOT FOUND THEN'
                    + nextL
                    + '    INSERT INTO ' + _PropertyName + ' (DescId, Object'+sHist+'Id, ' + Value_upd + ')'
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
             // �������
             StrPack:= StrPack + ' ------ end ' + IntToStr(Num_main) + ':' + IntToStr(num) + '/' + IntToStr(i) +' ----------------------' + nextL + nextL;
             //
             if i = CountPack then
             begin
                  i:= 0;
                  // ����� - ������
                  StrPack:= StrPack + ' END $$;' + nextL + nextL;
                  //
                  // !!!��������� - ������!!!
                  resStr:= fExecSqToQuery (StrPack);
                  if resStr = ''
                  then
                      // ��������� = OK
                      StrPack:= StrPack + ' ------ Result (' + _PropertyName + ') = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
                  else begin
                      // ��������� = ERROR
                      StrPack:= StrPack + ' ------ Result (' + _PropertyName + ') = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + ':' + nextL + resStr + nextL + nextL;
                      // !!!��������� - � ����!!!
                      AddToLog(StrPack, _PropertyName, gSessionGUID, false);
                      //
                      // ERROR
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (_PropertyName + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
                      AddToMemoMsg (resStr, TRUE);
                      //
                      exit;
                  end;
                  //
                  // !!!��������� - � ����!!!
                  AddToLog(StrPack, _PropertyName, gSessionGUID, false);
                  //
                  // ��������
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
     // ��� ���
     if i > 0 then
     begin
          // ����� - ������
          StrPack:= StrPack + ' END $$;' + nextL + nextL;
          //
          //
          // !!!��������� - ������!!!
          resStr:= fExecSqToQuery (StrPack);
          if resStr = ''
          then
              // ��������� = OK
              StrPack:= StrPack + ' ------ Result (' + _PropertyName + ') = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
          else begin
              // ��������� = ERROR
              StrPack:= StrPack + ' ------ Result (' + _PropertyName + ') = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + ':' + nextL + resStr + nextL + nextL;
              // !!!��������� - � ����!!!
              AddToLog(StrPack, _PropertyName, gSessionGUID, false);
              //
              // ERROR
              AddToMemoMsg ('', FALSE);
              AddToMemoMsg (_PropertyName + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
              AddToMemoMsg (resStr, TRUE);
              //
              exit;
          end;
          //
          // !!!��������� - � ����!!!
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
function TMainForm.fMove_ObjectHistory_repl : Boolean;
var StrPack, nextL : String;
    resStr : String;
    minId, maxId, StepId : Integer;
    //
    function fStrDel_ObjectHistory (StartId, EndId : Integer) : String;
    begin
         Result:=
               // ������� - ������� "������" ������ - ObjectHistoryString
               ' -- ������� "������" ������ - ObjectHistoryString'
             + nextL
             + ' DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN'
             + nextL
             + '(SELECT Id FROM ObjectHistory'
             + nextL
             +'  WHERE Id NOT IN (SELECT _repl.Id FROM ObjectHistory_repl AS _repl WHERE _repl.Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId) + ')'
             + nextL
             + '   AND ObjectId IN (SELECT DISTINCT _repl.ObjectId FROM ObjectHistory_repl AS _repl)'
             + nextL
             + '   AND Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId)
             + nextL
             + ');'
             + nextL
             + nextL
               // ������� - ������� "������" ������ - ObjectHistoryFloat
             + ' -- ������� "������" ������ - ObjectHistoryFloat'
             + nextL
             + ' DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN'
             + nextL
             + '(SELECT Id FROM ObjectHistory'
             + nextL
             +'  WHERE Id NOT IN (SELECT _repl.Id FROM ObjectHistory_repl AS _repl WHERE _repl.Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId) + ')'
             + nextL
             + '   AND ObjectId IN (SELECT DISTINCT _repl.ObjectId FROM ObjectHistory_repl AS _repl)'
             + nextL
             + '   AND Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId)
             + nextL
             + ');'
             + nextL
             + nextL
               // ������� - ������� "������" ������ - ObjectHistoryDate
             + ' -- ������� "������" ������ - ObjectHistoryDate'
             + nextL
             + ' DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN'
             + nextL
             + '(SELECT Id FROM ObjectHistory'
             + nextL
             +'  WHERE Id NOT IN (SELECT _repl.Id FROM ObjectHistory_repl AS _repl WHERE _repl.Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId) + ')'
             + nextL
             + '   AND ObjectId IN (SELECT DISTINCT _repl.ObjectId FROM ObjectHistory_repl AS _repl)'
             + nextL
             + '   AND Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId)
             + nextL
             + ');'
             + nextL
             + nextL
               // ������� - ������� "������" ������ - ObjectHistoryLink
             + ' -- ������� "������" ������ - ObjectHistoryLink'
             + nextL
             + ' DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN'
             + nextL
             + '(SELECT Id FROM ObjectHistory'
             + nextL
             +'  WHERE Id NOT IN (SELECT _repl.Id FROM ObjectHistory_repl AS _repl WHERE _repl.Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId) + ')'
             + nextL
             + '   AND ObjectId IN (SELECT DISTINCT _repl.ObjectId FROM ObjectHistory_repl AS _repl)'
             + nextL
             + '   AND Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId)
             + nextL
             + ');'
             + nextL
             + nextL
               // ������� - ������� "������" ������ - ObjectHistory
             + ' -- ������� "������" ������ - ObjectHistory'
             + nextL
             + ' DELETE FROM ObjectHistory'
             + nextL
             +'  WHERE Id NOT IN (SELECT _repl.Id FROM ObjectHistory_repl AS _repl WHERE _repl.Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId) + ')'
             + nextL
             + '   AND ObjectId IN (SELECT DISTINCT _repl.ObjectId FROM ObjectHistory_repl AS _repl)'
             + nextL
             + '   AND Id BETWEEN ' + IntToStr(StartId) + ' AND ' + IntToStr(EndId)
             + ';'
    end;
begin
     Result:= false;
     //
     // ������������ � ������� To
     if not IniConnectionTo ('on Move_ObjectHistory_repl', FALSE) then exit;
     //
     StrPack:= '';
     nextL  := #13;
     //
     fOpenSqToQuery ('SELECT MIN (Id) AS MinId, MAX(Id) AS MaxId FROM ObjectHistory_repl');
     minId := toSqlQuery.FieldByName('MinId').AsInteger;
     maxId := toSqlQuery.FieldByName('MaxId').AsInteger;
     StepId:= 100000;
     //
     //������� "�����"
     StrPack:= ' DO $$' + nextL
             + ' BEGIN' + nextL + nextL
               ;
     //������� �������, ��� �������
     while minId <= maxId do
     begin
         StrPack:= StrPack
                 + nextL
                 + fStrDel_ObjectHistory (minId, minId + StepId)
                 + nextL
                 + nextL
                  ;
         // ���������
         minId:= minId + StepId + 1;
     end;
     //
     StrPack:= StrPack
             + nextL
             + nextL
               // ������� - �������� ������
             + ' -- �������� ������'
             + nextL
             + ' UPDATE ObjectHistory'
             + nextL
             + ' SET DescId = _repl.DescId'
             +    ', StartDate = _repl.StartDate'
             +    ', EndDate = _repl.EndDate'
             +    ', ObjectId = _repl.ObjectId'
             + ' FROM ObjectHistory_repl AS _repl'
             + ' WHERE ObjectHistory.Id = _repl.Id'
             + ';'
             + nextL
             + nextL
               // ������� - ��������� ����� ������
             + ' -- ��������� ����� ������'
             + nextL
             + ' INSERT INTO ObjectHistory (Id, DescId, StartDate, EndDate, ObjectId)'
             + nextL
             + '    SELECT _repl.Id, _repl.DescId, _repl.StartDate, _repl.EndDate, _repl.ObjectId'
             + nextL
             + '    FROM ObjectHistory_repl AS _repl'
             + nextL
             + '         LEFT JOIN ObjectHistory ON ObjectHistory.Id = _repl.Id'
             + nextL
             + '    WHERE ObjectHistory.Id IS NULL'
             +    ';'
             + nextL
             + nextL
             + ' END $$;'
             + nextL
             ;
     //
     AddToMemoMsg ('...', FALSE);
     AddToMemoMsg ('start exec Move_ObjectHistory_repl', FALSE);
     AddToMemoMsg ('...', FALSE);
     //
     // !!!��������� - � ����!!!
     AddToLog(StrPack, 'ObjectHistory', gSessionGUID, false);
     //
     // !!!��������� - ������!!!
     resStr:= fExecSqToQuery (StrPack);
     //
     if resStr = ''
     then
         // !!!��������� - � ���� - ��������� = OK!!!
         AddToLog(' ------ Result (exec Move_ObjectHistory_repl) = OK : ' + nextL + nextL, 'ObjectHistory', gSessionGUID, false)
     else begin
         // !!!��������� - � ���� - ��������� = ERROR!!!
         AddToLog(' ------ Result (exec Move_ObjectHistory_repl) = ERROR : ' + nextL + nextL, 'ObjectHistory', gSessionGUID, false);
         //
         // ERROR
         AddToMemoMsg ('', FALSE);
         AddToMemoMsg ('ObjectHistory', FALSE);
         AddToMemoMsg (resStr, TRUE);
         //
         exit;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSendAllTo_ReplObjectDesc;
//From: ���������� - ������
//To:   ���������� - ������ - ��������� ������ StrPack
var StrPack, nextL, resStr : String;
    lGUID : String;
    DescId_ins1,DescId_ins2,DescId_upd : String;
begin
     //
     lGUID:= GenerateGUID;
     nextL  := #13;
     //
     // ������������ � ������� From - �����������
     if not IniConnectionFrom (TRUE) then exit;
     // ������������ � ������� To
     if not IniConnectionTo ('ObjectDesc + ObjectHistoryDesc', FALSE)   then exit;
     //
     // ������� ������ �... ��...
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

           Add('union all');
           Add('select 11 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectHistory') + ' as GroupId from ObjectHistoryDesc');
           Add('union all');
           Add('select 12 AS NPP, Id,      DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectHistoryString') + ' as GroupId from ObjectHistoryStringDesc');
           Add('union all');
           Add('select 13 AS NPP, Id,      DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectHistoryFloat') + ' as GroupId from ObjectHistoryFloatDesc');
           Add('union all');
           Add('select 14 AS NPP, Id,      DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectHistoryDate') + ' as GroupId from ObjectHistoryDateDesc');
           Add('union all');
           Add('select 16 AS NPP, Id,      DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('ObjectHistoryLink') + ' as GroupId from ObjectHistoryLinkDesc');

           Add('order by 1, 2');
           //
           Open;
           // ���� ������ �������� - !!!�����!!!
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
             //������� "�����"
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
             if (FieldByName('GroupId').AsString <> 'Object') and (FieldByName('GroupId').AsString <> 'ObjectHistory')
             then begin
                       DescId_ins1:= ', DescId';
                       DescId_ins2:= ', ' + ConvertFromInt(FieldByName('DescId').AsInteger);
                       DescId_upd := ', DescId = '   + ConvertFromInt(FieldByName('DescId').AsInteger);
             end;
                 //������� ������� - "�����" ���� �����
                 {StrPack:= StrPack + nextL
                          + ' IF EXISTS (SELECT Code FROM ' + FieldByName('GroupId').AsString + 'Desc GROUP BY Code HAVING COUNT(*) > 1)'
                           + nextL
                          // �������
                          +' THEN DELETE FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code IN (SELECT Code FROM ' + FieldByName('GroupId').AsString + 'Desc GROUP BY Code HAVING COUNT(*) > 1)'
                          + nextL
                          + ' AND Id NOT IN (SELECT DISTINCT DescId FROM ' + FieldByName('GroupId').AsString +')'
                          + ';' + nextL
                          +' END IF;' + nextL + nextL;}

                 //������� "��������" - ����� ���� �� ��� ������ ����
                 StrPack:= StrPack + nextL
                          + ' IF EXISTS (SELECT * FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('Code').AsString) + ')'
                           + nextL
                          +'  AND ' + IntToStr(FieldByName('Id').AsInteger) + ' <> (SELECT Id FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('Code').AsString) + ')'
                           + nextL
                          // ����� "�����������"
                          +' THEN vbAdd := ' + ConvertFromVarChar('_') + ';' + nextL
                          // ����� "�������"
                          +' ELSE vbAdd := ' + ConvertFromVarChar('') + ';' + nextL
                          +' END IF;' + nextL + nextL
                     //
                     // ����������� "�������" UPDATE
                     + ' UPDATE ' + FieldByName('GroupId').AsString + 'Desc'
                     +                      ' SET Code = '  + ConvertFromVarChar(FieldByName('Code').AsString)
                     +                      ', ItemName = ' + ConvertFromVarChar(FieldByName('ItemName').AsString)
                     +  DescId_upd
                     + ' WHERE Id = ' + IntToStr(FieldByName('Id').AsInteger) + ';'
                     + nextL + nextL
                     // ����� INSERT
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
                     //���� ���� �� ��� ������ ���� - ������ �� �����
                     + ' UPDATE ' + FieldByName('GroupId').AsString + ' SET DescId = ' + IntToStr(FieldByName('Id').AsInteger)
                     + nextL
                     + ' WHERE DescId = (SELECT Id FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('Code').AsString) + ')'
                     + nextL
                     +'  AND vbAdd = ' + ConvertFromVarChar('_') + ';'
                     + nextL
                     + nextL
                     //������� ��� ������ ���� - ������ �� �����
                     + ' DELETE FROM ' + FieldByName('GroupId').AsString + 'Desc'
                     + nextL
                     + ' WHERE Id = (SELECT Id FROM ' + FieldByName('GroupId').AsString + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('Code').AsString) + ')'
                     + nextL
                     +'  AND vbAdd = ' + ConvertFromVarChar('_') + ';'
                     + nextL
                     + nextL
                     // ��� ���, ���� ��� "�����������" - ������ �� ���������� ��������
                     + ' UPDATE ' + FieldByName('GroupId').AsString + 'Desc'
                     +    ' SET Code = ' + ConvertFromVarChar(FieldByName('Code').AsString)
                     + ' WHERE Id = ' + IntToStr(FieldByName('Id').AsInteger)
                     + nextL
                     +'  AND vbAdd = ' + ConvertFromVarChar('_') + ';'
                     + nextL
                     + nextL
                      ;
            //
            // ����� - ������
            StrPack:= StrPack + ' END $$;' + nextL + nextL;
            //
            //
            // !!!��������� - ������!!!
            resStr:= fExecSqToQuery (StrPack);
            if resStr = ''
            then
                // ��������� = OK
                StrPack:= StrPack + ' ------ Result = OK' + nextL + nextL
            else begin
                // ��������� = ERROR
                StrPack:= StrPack + ' ------ Result = ERROR : ' + nextL + nextL;
                // ERROR
                AddToMemoMsg ('', FALSE);
                AddToMemoMsg (FieldByName('GroupId').AsString, FALSE);
                AddToMemoMsg (resStr, TRUE);
            end;
            //
            // !!!��������� - � ����!!!
            AddToLog(StrPack, FieldByName('GroupId').AsString + 'Desc', lGUID, false);
            //
            //
            Next;
            //
            Gauge.Progress:=Gauge.Progress+1;
            Application.ProcessMessages;
            //
           end;
           //
           Close;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pSendAllTo_ReplProc : Boolean;
//From: ���������� - ������
//To:   ���������� - !�� ������! - !����� �-��� ����� ��������� ������ ����� spExecSql!
var lGUID, lProcText, tmp : String;
    resStr : String;
begin
    Result:= false;
    //
    //
    lGUID:= GenerateGUID;
    //
    // ������������ � ������� From - �����������
    if not IniConnectionFrom (TRUE) then exit;
    //
    //
    try
    // ������� ������ �... ��...
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
         // ���� ������ �������� - !!!�����!!!
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
              fOpenSqFromQuery_two ('select * from gpSelect_ReplProc (' + FieldByName('oid').AsString + ', CAST (NULL AS TVarChar), CAST (NULL AS TVarChar))');
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
                  // !!!����� StoredProc!!!
                  resStr:= fExecSql_repl_to (fromSqlQuery_two.FieldByName('ProcText').AsString);
                  if resStr <> '' then
                  begin
                      // ERROR
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (' ..... ERROR .....', FALSE);
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (lProcText, FALSE);
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (FieldByName('ProName').AsString, FALSE);
                      if Pos('zc_', FieldByName('ProName').AsString) = 1
                      then AddToMemoMsg (resStr, TRUE)
                      else AddToMemoMsg (resStr, TRUE);
                      AddToMemoMsg ('', FALSE);
                  end;
                  //
                  // !!!��������� - � ����!!!
                  AddToLog(lProcText, FieldByName('ProName').AsString, lGUID, false);
              end;
              //
              Next;
              //
              Gauge.Progress:=Gauge.Progress+1;
              Application.ProcessMessages;
         end;
         //
         Close;
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

  LogFileName := ChangeFileExt(Application.ExeName, '') + '\' + myFolder + '\' + myFile + '.sql';

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
function TMainForm.fObject_andProperty_while : Boolean;
var StartId, EndId : Integer;
    num : Integer;
begin
     Result:= false;
     //
     // ��������� ������ ��� Id - Object...
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

          // ������� ������ �... ��...
          if not pOpen_ReplObject (FALSE, num, StartId, EndId, FALSE) then exit;
          //
          // ���� ������ �������� - !!!�����!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //������ ������ �� ��������� ������� � ��������� ������ � ����-To
          if not pSendPackTo_ReplObject(num, outCountPack, FALSE)
          then exit;
          //ObjectString - �� ��������� ������� � ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectStringCDS), FALSE) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectString), FALSE) then exit else;
          //ObjectFloat - �� ��������� ������� � ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectFloatCDS), FALSE) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectFloat), FALSE) then exit else;
          //ObjectDate - �� ��������� ������� � ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectDateCDS), FALSE) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectDate), FALSE) then exit else;
          //ObjectBoolean - �� ��������� ������� � ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectBooleanCDS), FALSE) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectBoolean), FALSE) then exit else;
          //
          // ��������� ������ ��� Id
          StartId:= EndId + 1;
          EndId  := StartId + outCountIteration;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fObjectLink_while : Boolean;
var StartId, EndId : Integer;
    num : Integer;
begin
     Result:= false;
     //
     // ��������� ������ ��� Id - ObjectLink
     StartId:= outMinId;
     EndId  := StartId + outCountIteration;
     num    := 0;

     while StartId <= outMaxId do
     begin
          num:= num + 1;

          // ������� ������ �... ��...
          if not pOpen_ReplObject (TRUE, num, StartId, EndId, FALSE) then exit;
          //
          // ���� ������ �������� - !!!�����!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //ObjectLink - �� ��������� ������� � ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectLinkCDS), FALSE) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectLink), FALSE) then exit else;
          //
          // ��������� ������ ��� Id
          StartId:= EndId + 1;
          EndId  := StartId + outCountIteration;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fObjectHistory_while : Boolean;
var StartId, EndId : Integer;
    num : Integer;
begin
     Result:= false;
     //
     // ��������� ������ ��� Id - Object...
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

          // ������� ������ �... ��...
          if not pOpen_ReplObject (FALSE, num, StartId, EndId, TRUE) then exit;
          //
          // ���� ������ �������� - !!!�����!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //������ ������ �� ��������� ������� � ��������� ������ � ����-To
          if not pSendPackTo_ReplObject(num, outCountPack, TRUE)
          then exit;
          //
          // ��������� ������ ��� Id
          StartId:= EndId + 1;
          EndId  := StartId + outCountIteration;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fObjectHistory_Property_while : Boolean;
var StartId, EndId : Integer;
    num : Integer;
begin
     Result:= false;
     //
     // ��������� ������ ��� Id - Object...
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

          // ������� ������ �... ��...
          if not pOpen_ReplObject (TRUE, num, StartId, EndId, TRUE) then exit;
          //
          // ���� ������ �������� - !!!�����!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //ObjectHistoryString - �� ��������� ������� � ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectStringCDS), TRUE) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectString), TRUE) then exit else;
          //ObjectHistoryFloat - �� ��������� ������� � ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectFloatCDS), TRUE) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectFloat), TRUE) then exit else;
          //ObjectHistoryDate - �� ��������� ������� � ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectDateCDS), TRUE) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectDate), TRUE) then exit else;
          //ObjectHistoryLink - �� ��������� ������� � ...
          if cbClientDataSet.Checked = TRUE
          then if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(ObjectLinkCDS), TRUE) then exit else
          else if not pSendPackTo_ReplObjectProperty(num, outCountPack, TClientDataSet(fQueryObjectLink), TRUE) then exit else;
          //
          // ��������� ������ ��� Id
          StartId:= EndId + 1;
          EndId  := StartId + outCountIteration;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pSendAllTo_ReplObject : Boolean;
//To: ���������� - ������ - ����� load-Desc-list
begin
  try
     Result:= false;
     //
     // ������������� ��� ������ �� ������� From
     if not pInsert_ReplObject then exit;
     //
     // ������������ � ������� To + ������� - �������� ��� Desc-�� (����� ������ ���)
     if not IniConnectionTo ('load-Desc-list', TRUE) then exit;
     //
     // �������� �����
     EditCountObject.Text          := IntToStr(outCount)       +  ' / ' + IntToStr(outCountHistory);
     EditCountStringObject.Text    := IntToStr(outCountString) +  ' / ' + IntToStr(outCountHistoryString);
     EditCountFloatObject.Text     := IntToStr(outCountFloat)  +  ' / ' + IntToStr(outCountHistoryFloat);
     EditCountDateObject.Text      := IntToStr(outCountDate)   +  ' / ' + IntToStr(outCountHistoryDate);
     EditCountBooleanObject.Text   := IntToStr(outCountBoolean)+  ' / 0';
     EditCountLinkObject.Text      := IntToStr(outCountLink)   + ' / ' + IntToStr(outCountHistoryLink);

     EditMinIdObject.Text          := IntToStr(outMinId);
     EditMaxIdObject.Text          := IntToStr(outMaxId);
     EditCountIterationObject.Text := IntToStr(outCountIteration) + ' / ' + IntToStr(outCountPack);

     Gauge.Progress:=0;
     Gauge.MaxValue:= 0;
     if cbObject.Checked = TRUE
     then
       Gauge.MaxValue:= Gauge.MaxValue + outCount + outCountString + outCountFloat
                                       + outCountDate + outCountBoolean + outCountLink
                                       ;
     if cbObjectHistory.Checked = TRUE
     then
       Gauge.MaxValue:= Gauge.MaxValue + outCountHistory + outCountHistoryString + outCountHistoryFloat
                                       + outCountHistoryDate + outCountHistoryLink
                                       ;
     //
     if cbObject.Checked = TRUE then
     begin
          // ��������� ��� Object + Property
          if not fObject_andProperty_while then exit;
          //
          // ��������� ��� ObjectLink
          if not fObjectLink_while then exit;
     end;
     //
     if cbObjectHistory.Checked = TRUE then
     begin
          // ��������� ��� ������ ObjectHistory - �� ��������� ObjectHistory_repl
          if not fObjectHistory_while then exit;
          // ��������� �� ��������� ObjectHistory_repl -> ObjectHistory
          if not fMove_ObjectHistory_repl then exit;
          // ��������� ��� �������� ObjectHistory
          if not fObjectHistory_Property_while then exit;
     end;
     //
     //
     AddToMemoMsg(' ....................', FALSE);
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' ... end Guide', FALSE);
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
     fBegin_All:= FALSE;
     //
     fStop:= true;
     //
     Gauge.Visible:=false;
     Gauge.Progress:=0;
     //
     MemoMsg.Clear;
     //
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', 'qsxqsxw1', gc_User);
     if not Assigned (gc_User) then ShowMessage ('not Assigned (gc_User)');
     //
     //
     ArrayReplServer:= gpSelect_ReplServer_load;
     //
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pBegin_All : Boolean;
begin
     Result:= TRUE;
     //
     if fBegin_All = TRUE then exit;
     //
     try
         fBegin_All := TRUE;
         //
         fStop:=false;
         //
         OKGuideButton.Enabled:=false;
         Gauge.Visible:=true;
         Gauge.Progress:= 0;
         //
         CursorGridChange;
         //
         MemoMsg.Lines.Clear;
         //
         if cbProc.Checked = TRUE
         then
             // ��������� Proc
             pSendAllTo_ReplProc;
         //
         if cbDesc.Checked = TRUE
         then
             // ��������� Desc
             pSendAllTo_ReplObjectDesc;

         //
         if (cbObject.Checked = TRUE) or (cbObjectHistory.Checked = TRUE)
         then
             // ��������� Object - Data
             pSendAllTo_ReplObject;

     finally
           Result:= fStop;
           //
           fBegin_All := FALSE;
           //
           fStop:=true;
           //
           OKGuideButton.Enabled:=true;
           Gauge.Visible:=false;
           //
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.OKGuideButtonClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
    lResStop: Boolean;
begin
     if MessageDlg('������������� ��������� ������?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     //
     //
     tmpDate1:=NOw;
     //
     //
     lResStop:= pBegin_All;
     //
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
         if lResStop = TRUE
         then ShowMessage('������ �� ���������. Time=('+StrTime+').')
         else ShowMessage('������ ���������. Time=('+StrTime+').') ;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

end.


