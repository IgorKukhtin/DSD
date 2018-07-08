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
    toSqlQuery: TZQuery;
    spSelect_ReplObject: TdsdStoredProc;
    toZConnection: TZConnection;
    toSqlQuery_two: TZQuery;
    DatabaseSybase: TDatabase;
    fromQuery: TQuery;
    fromSqlQuery: TQuery;
    fromQuery_two: TQuery;
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
    spInsert_ReplObject: TdsdStoredProc;
    EditMinIdObject: TcxCurrencyEdit;
    EditMaxIdObject: TcxCurrencyEdit;
    EditCountIterationObject: TEdit;
    cbGUID: TCheckBox;
    cbOnlyOpen: TCheckBox;
    PanelError: TPanel;
    MemoError: TMemo;

    procedure OKGuideButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ButtonPanelDblClick(Sender: TObject);
  private
    fStop : Boolean;
    beginConnectionTo : Integer;

    function EADO_EngineErrorMsg(E:EADOError) : String;
    function EDB_EngineErrorMsg(E:EDBEngineError) : String;

    procedure myShowSql(mySql:TStrings);
    procedure MyDelay(mySec:Integer);

    function myReplaceStr(const S, Srch, Replace: string): string;
    function ConvertFromVarChar_notNULL(_Value:string):string;

    function ConvertValueToVarChar(PropertyName : string;
                                   _ValueS      : string;
                                   _ValueF      : Double;
                                   _ValueD      : TDateTime; _isNullD : Boolean;
                                   _ValueB      : Boolean;   _isNullB : Boolean
                                  ):string;

    function ConvertFromVarChar(_Value:string):string;
    function ConvertFromBoolean(_Value, isNull : Boolean) : string;
    function ConvertFromDate(_Value : TDateTime; isNull : Boolean) : string;
    function ConvertFromInt(_Value:Integer):string;
    function ConvertFromFloat(_Value:Double):string;

    function FormatFromDate(_Date:TDateTime):string;
    function FormatFromDateTime(_Date:TDateTime):string;
    function FormatFromDateTime_folder(_Date:TDateTime):string;

    function fOpenSqFromQuery (mySql:String):Boolean;
    function fExecSqFromQuery (mySql:String):Boolean;
    function fExecSqFromQuery_noErr (mySql:String):Boolean;

    function fOpenSqToQuery (mySql:String):Boolean;
    function fExecSqToQuery (mySql:String):String;
    function fOpenSqToQuery_two (mySql:String):Boolean;
    function fExecSqToQuery_two (mySql:String):Boolean;


    procedure CursorGridChange;

    function IniConnectionTo(NumConnect : Integer) : Boolean;

    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);

    function gpSelect_ReplServer_load: TArrayReplServer;
    procedure pInsert_ReplObject (NumConnect : Integer);
    procedure pSendAllTo_ReplObject ;
    procedure pSendPackTo_ReplObject(Num_main, CountPack : Integer);
    procedure pSendPackTo_ReplObjectProperty(Num_main, CountPack : Integer; PropertyCDS : TClientDataSet);
    procedure pOpen_ReplObject (StartId, EndId : LongInt);

    procedure AddToLog(S, myFile, myFolder: string; isError : Boolean);

  public
  end;

  function GenerateGUID: String;

var
  MainForm: TMainForm;
  ArrayReplServer : TArrayReplServer;

implementation
uses Authentication, CommonData, Storage, SysUtils, Dialogs, Graphics, UtilConst, StrUtils;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
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
        except on E:EDBEngineError do
           begin
              Result:= EDB_EngineErrorMsg(E);
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
                                   _ValueB      : Boolean;   _isNullB : Boolean
                                  ):string;
begin
     if PropertyName = 'ObjectString' then Result:= ConvertFromVarChar(_ValueS)
     else
     if PropertyName = 'ObjectFloat' then Result:= ConvertFromFloat(_ValueF)
     else
     if PropertyName = 'ObjectDate' then Result:= ConvertFromDate(_ValueD, _isNullD)
     else
     if PropertyName = 'ObjectBoolean' then Result:= ConvertFromBoolean(_ValueB, _isNullB)
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromVarChar_notNULL(_Value:string):string;
begin if trim(_Value)='' then Result:=chr(39)+''+chr(39) else Result:=chr(39)+trim(_Value)+chr(39);end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromVarChar(_Value:string):string;
begin Result:=chr(39)+(_Value)+chr(39);end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromBoolean(_Value, isNull:Boolean):string;
begin
     if isNull = TRUE then Result:='NULL'
     else
     if _Value = TRUE then Result:='TRUE' else Result:='FALSE';
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.ConvertFromDate(_Value : TDateTime; isNull : Boolean) : string;
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
function TMainForm.EADO_EngineErrorMsg(E:EADOError) : String;
begin
  // MessageDlg(E.Message,mtError,[mbOK],0);
  Result:= E.Message;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.EDB_EngineErrorMsg(E:EDBEngineError) : String;
var
  DBError: TDBError;
begin
  DBError:=E.Errors[1];
  Result:= DBError.Message;
  //MessageDlg(DBError.Message,mtError,[mbOK],0);
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
     with toZConnection do begin
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

     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pInsert_ReplObject (NumConnect : Integer);
begin
     with spInsert_ReplObject do
     begin
       //try
         //
         ParamByName('inSessionGUID').Value:= GenerateGUID;
         ParamByName('inStartDate').Value  := ArrayReplServer[NumConnect-1].Start_toChild;
         ParamByName('inDescCode').Value   := EditObjectDescId.Text;
         ParamByName('inIsProtocol').Value := cbProtocol.Checked;
         //
         Execute;
         //
         EditCountObject.Text          := IntToStr (ParamByName('outCount').Value);
         EditMinIdObject.Text          := IntToStr (ParamByName('outMinId').Value);
         EditMaxIdObject.Text          := IntToStr (ParamByName('outMaxId').Value);
         EditCountIterationObject.Text := IntToStr (ParamByName('outCountIteration').Value) + ' / ' + IntToStr (ParamByName('outCountPack').Value);
         EditCountStringObject.Text    := IntToStr (ParamByName('outCountString').Value);
         EditCountFloatObject.Text     := IntToStr (ParamByName('outCountFloat').Value);
         EditCountDateObject.Text      := IntToStr (ParamByName('outCountDate').Value);
         EditCountBooleanObject.Text   := IntToStr (ParamByName('outCountBoolean').Value);
         EditCountLinkObject.Text      := IntToStr (ParamByName('outCountLink').Value);
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
procedure TMainForm.pOpen_ReplObject (StartId, EndId : LongInt);
begin
     with spSelect_ReplObject do
     begin
       //try
         //
         ParamByName('inSessionGUID').Value:= spInsert_ReplObject.ParamByName('inSessionGUID').Value;
         ParamByName('inStartId').Value    := StartId;
         ParamByName('inEndId').Value      := EndId;
         ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
         //
         Execute;
         //
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
procedure TMainForm.pSendPackTo_ReplObjectProperty(Num_main, CountPack : Integer; PropertyCDS : TClientDataSet);
var StrPack : String;
    i, num  : Integer;
    nextL   : String;
    resStr  : String;
    _PropertyName : String;
    _PropertyValue: String;
begin
     i:=0;
     num:=0;
     StrPack:= '';
     nextL  := #13;
     //
     with PropertyCDS do begin
        //
        if Name =  'ObjectStringCDS'  then _PropertyName:= 'ObjectString';
        if Name =  'ObjectFloatCDS'   then _PropertyName:= 'ObjectFloat';
        if Name =  'ObjectDateCDS'    then _PropertyName:= 'ObjectDate';
        if Name =  'ObjectBooleanCDS' then _PropertyName:= 'ObjectBoolean';
        //
        First;
        while not EOF  do
        begin
             // ЗНАЧЕНИЕ
             _PropertyValue:= ConvertValueToVarChar(_PropertyName, FieldByName('ValueDataS').AsString
                                                   , FieldByName('ValueDataF').AsFloat
                                                   , FieldByName('ValueDataD').AsDateTime, FieldByName('isValuDNull').AsBoolean
                                                   , FieldByName('ValueDataB').AsBoolean , FieldByName('isValuBNull').AsBoolean
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
             // попробовали UPDATE
             StrPack:= StrPack
                     + '    UPDATE ' + _PropertyName + ' SET ValueData = ' + _PropertyValue
                     + nextL
                     + '    WHERE ObjectId = vbId and DescId = ' + IntToStr(FieldByName('DescId').AsInteger) + ' ;' + ' -- ' + FieldByName('DescName').AsString
                     + nextL
                     + nextL;
             // иначе INSERT
             StrPack:= StrPack
                    + ' IF NOT FOUND THEN'
                    + nextL
                    + '    INSERT INTO ' + _PropertyName + ' (DescId, ValueData)'
                    + nextL
                    + '    VALUES (' + IntToStr(FieldByName('DescId').AsInteger)
                    +           ', ' + _PropertyValue
                    +           ')'
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
                  if resStr <> ''
                  then
                      // результат = OK
                      StrPack:= StrPack + ' ------ Result (' + _PropertyName + ') = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
                  else
                      // результат = ERROR
                      StrPack:= StrPack + ' ------ Result' + _PropertyName + ') = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + ':' + nextL + resStr + nextL + nextL;
                  //
                  // !!!сохранили - в ФАЙЛ!!!
                  //ShowMessage (StrPack);
                  AddToLog(StrPack, _PropertyName, spInsert_ReplObject.ParamByName('inSessionGUID').Value, false);
                  //
                  // обнулили
                  StrPack:= '';
                  //exit;
             end;
             //
             //
             Next;

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
              StrPack:= StrPack + ' ------ Result' + _PropertyName + ') = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
          else
              // результат = ERROR
              StrPack:= StrPack + ' ------ Result' + _PropertyName + ') = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + ':' + nextL + resStr + nextL + nextL;
          //
          // !!!сохранили - в ФАЙЛ!!!
          //ShowMessage (StrPack);
          AddToLog(StrPack, _PropertyName, spInsert_ReplObject.ParamByName('inSessionGUID').Value, false);
          //
          //
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.pSendPackTo_ReplObject (Num_main, CountPack : Integer);
var StrPack : String;
    i, num  : Integer;
    nextL   : String;
begin
     i:=0;
     num:=0;
     StrPack:= '';
     nextL  := #13;
     //
     with ObjectCDS do begin
        First;
        while not EOF  do
        begin
             //сначала "шапка"
             if StrPack = ''
             then begin
                  StrPack:= ' DO $$' + nextL
                          + ' DECLARE vbId Integer;' + nextL
                          + ' BEGIN' + nextL + nextL + nextL
                          ;
                  num:= num + 1;
             end;
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
                  if fExecSqToQuery (StrPack)
                  then
                      // результат = OK
                      StrPack:= StrPack + ' ------ Result = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
                  else
                      // результат = ERROR
                      StrPack:= StrPack + ' ------ Result = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL;
                  //
                  // !!!сохранили - в ФАЙЛ!!!
                  //ShowMessage (StrPack);
                  AddToLog(StrPack, 'Object', spInsert_ReplObject.ParamByName('inSessionGUID').Value, false);
                  //
                  // обнулили
                  StrPack:= '';
                  //exit;
             end;
             //
             //
             Next;

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
          if fExecSqToQuery (StrPack)
          then
              // результат = OK
              StrPack:= StrPack + ' ------ Result = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
          else
              // результат = ERROR
              StrPack:= StrPack + ' ------ Result = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL;
          //
          // !!!сохранили - в ФАЙЛ!!!
          //ShowMessage (StrPack);
          AddToLog(StrPack, 'Object', spInsert_ReplObject.ParamByName('inSessionGUID').Value, false);
          //
          //
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
procedure TMainForm.pSendAllTo_ReplObject ;
var StartId, EndId : Integer;
    num : Integer;
begin
     // стартовый период для Id
     StartId:= spInsert_ReplObject.ParamByName('outMinId').Value;
     EndId  := StartId + spInsert_ReplObject.ParamByName('outCountIteration').Value;
     num    := 0;

     while StartId <= spInsert_ReplObject.ParamByName('outMaxId').Value do
     begin
          num:= num + 1;

          // открыли данные с... по...
          pOpen_ReplObject (StartId, EndId);
          //
          // если только просмотр - !!!ВЫХОД!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //делаем скрипт на НЕСКОЛЬКО пакетов и сохраняем данные в БАЗЕ-To
          pSendPackTo_ReplObject(num, spInsert_ReplObject.ParamByName('outCountPack').Value);
          //ObjectString - на НЕСКОЛЬКО пакетов и ...
          pSendPackTo_ReplObjectProperty(num, spInsert_ReplObject.ParamByName('outCountPack').Value, ObjectStringCDS);
          //ObjectFloat - на НЕСКОЛЬКО пакетов и ...
          pSendPackTo_ReplObjectProperty(num, spInsert_ReplObject.ParamByName('outCountPack').Value, ObjectFloatCDS);
          //ObjectDate - на НЕСКОЛЬКО пакетов и ...
          pSendPackTo_ReplObjectProperty(num, spInsert_ReplObject.ParamByName('outCountPack').Value, ObjectDateCDS);
          //ObjectBoolean - на НЕСКОЛЬКО пакетов и ...
          pSendPackTo_ReplObjectProperty(num, spInsert_ReplObject.ParamByName('outCountPack').Value, ObjectBooleanCDS);
          //
          // следующий период для Id
          StartId:= EndId + 1;
          EndId  := StartId + spInsert_ReplObject.ParamByName('outCountIteration').Value;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
     Gauge.Visible:=false;
     Gauge.Progress:=0;
     //
     MemoError.Clear;
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
     //
     MemoError.Clear;
     MemoError.Lines.Add(spInsert_ReplObject.ParamByName('inSessionGUID').Value + ':');
     //
     if not fStop then pInsert_ReplObject (beginConnectionTo);
     if not fStop then pSendAllTo_ReplObject;
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


