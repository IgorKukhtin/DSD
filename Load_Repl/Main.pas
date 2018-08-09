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
    btnOKMain_toChild: TButton;
    Gauge: TGauge;
    btnStop: TButton;
    CloseButton: TButton;
    toSqlQuery: TZQuery;
    spSelect_ReplObject: TdsdStoredProc;
    childZConnection: TZConnection;
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
    mainZConnection: TZConnection;
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
    spSelect_ReplMovement: TdsdStoredProc;
    fQueryMovement: TZQuery;
    MovementCDS: TClientDataSet;
    spInsert_ReplMovement: TdsdStoredProc;
    fQueryMS: TZQuery;
    spSelect_ReplMS: TdsdStoredProc;
    MSCDS: TClientDataSet;
    fQueryMF: TZQuery;
    spSelect_ReplMF: TdsdStoredProc;
    MFCDS: TClientDataSet;
    spSelect_ReplMD: TdsdStoredProc;
    MDCDS: TClientDataSet;
    fQueryMD: TZQuery;
    fQueryMB: TZQuery;
    MBCDS: TClientDataSet;
    spSelect_ReplMB: TdsdStoredProc;
    fQueryMLO: TZQuery;
    spSelect_ReplMLO: TdsdStoredProc;
    MLOCDS: TClientDataSet;
    fQueryMLM: TZQuery;
    spSelect_ReplMLM: TdsdStoredProc;
    MLMCDS: TClientDataSet;
    cbMovement: TCheckBox;
    cbMI: TCheckBox;
    cbForms: TCheckBox;
    spExecForm_repl_to: TdsdStoredProc;
    btnOKChild_toMain: TButton;
    spInsert_ReplMovement_fromChild: TdsdStoredProc;
    spSelect_ReplMovement_Child: TdsdStoredProc;
    Movement_ChildCDS: TClientDataSet;
    spSelect_ReplMS1: TdsdStoredProc;
    MSCDS1: TClientDataSet;
    spSelect_ReplMF1: TdsdStoredProc;
    MFCDS1: TClientDataSet;
    spSelect_ReplMD1: TdsdStoredProc;
    MDCDS1: TClientDataSet;
    spSelect_ReplMB1: TdsdStoredProc;
    MBCDS1: TClientDataSet;
    spSelect_ReplMLO1: TdsdStoredProc;
    MLOCDS1: TClientDataSet;
    spSelect_ReplMLM1: TdsdStoredProc;
    MLMCDS1: TClientDataSet;

    procedure btnOKMain_toChildClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ButtonPanelDblClick(Sender: TObject);
    procedure btnOKChild_toMainClick(Sender: TObject);
  private
    fBegin_All : Boolean;
    fStop : Boolean;
    gSessionGUID : String;
    outMinId, outMaxId, outCountIteration, outCountPack : Integer;
    outCount, outCountString, outCountFloat, outCountDate, outCountBoolean, outCountLink, outCountLinkM : Integer;
    outCountHistory, outCountHistoryString, outCountHistoryFloat, outCountHistoryDate, outCountHistoryBoolean, outCountHistoryLink : Integer;

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
    function fExecSqFromQuery (mySql:String):String;

    function fOpenSqToQuery (mySql:String):Boolean;
    function fExecSqToQuery (mySql:String):String;
    //function fOpenSqToQuery_two (mySql:String):Boolean;
    //function fExecSqToQuery_two (mySql:String):Boolean;

    function fExecSql_repl_to (mySql:String):String;
    function fExecForm_repl_to (FormName, FormData:String):String;

    procedure CursorGridChange;

    procedure myEnabledCB (cb:TCheckBox);
    procedure myDisabledCB (cb:TCheckBox);

    function gpSelect_ReplServer_load: TArrayReplServer;
    function IniConnection_Main (isConnected : Boolean): Boolean;
    function IniConnection_Child(_PropertyName : String; isGetDesc   : Boolean): Boolean;

    //Object
    function pInsert_ReplObject : Boolean;
    function pSendAllTo_ReplObject : Boolean;
    function pOpen_ReplObject (isObjectLink : Boolean; Num_main : Integer; StartId, EndId : LongInt; isHistory : Boolean) : Boolean;
    function pSendPackTo_ReplObject(Num_main, CountPack : Integer; isHistory : Boolean) : Boolean;
    function pSendPackTo_ReplObjectProperty(Num_main, CountPack : Integer; CDSData : TClientDataSet; isHistory : Boolean) : Boolean;
    function fMove_ObjectHistory_repl : Boolean;

    function fObject_andProperty_while : Boolean;
    function fObjectLink_while : Boolean;
    function fObjectHistory_while : Boolean;
    function fObjectHistory_Property_while : Boolean;

    //Movement From Main to Child
    function pInsert_ReplMovement : Boolean;
    function pSendAllTo_ReplMovement : Boolean;
    //Movement From Child to Main
    function pInsert_ReplMovement_fromChild : Boolean;
    function pSendAllTo_ReplMovement_fromChild : Boolean;
    //Movement From All to All
    function pOpen_ReplMovement (isFromMain, isLinkM : Boolean; Num_main : Integer; StartId, EndId : LongInt; isMI : Boolean) : Boolean;
    function pSendPackTo_ReplMovement(isFromMain : Boolean; Num_main, CountPack : Integer; isMI : Boolean) : Boolean;
    function pSendPackTo_ReplMovementProperty(isFromMain : Boolean; Num_main, CountPack : Integer; CDSData : TClientDataSet; isMI : Boolean) : Boolean;
    //Movement From All to All
    function fMovement_andProperty_while (isFromMain : Boolean) : Boolean;
    function fMovementLinkM_while (isFromMain : Boolean) : Boolean;
    function fMovementItem_andProperty_while (isFromMain : Boolean) : Boolean;

    procedure AddToLog(S, myFile, myFolder: string; isError : Boolean);
    procedure AddToMemoMsg(S: String; isError : Boolean);

    procedure pSendAllTo_ReplObjectDesc;
    function pSendAllTo_ReplProc : Boolean;
    function pSendAllTo_Forms : Boolean;

    function pBegin_All (isFromMain, isFromChild: Boolean) : Boolean;

  public
  end;

  function GenerateGUID (isFromMain : Boolean): String;

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
function GenerateGUID (isFromMain : Boolean) : String;
var
  G: TGUID;
begin
  CreateGUID(G);
  //
  if isFromMain = TRUE
  then Result := MainForm.FormatFromDateTime_folder(now) + '-m - ' + GUIDToString(G)
  else Result := MainForm.FormatFromDateTime_folder(now) + '-c - ' + GUIDToString(G);
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
         // ������������ � ������� Main - �����������
         if not IniConnection_Main (TRUE) then exit;
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
procedure TMainForm.btnStopClick(Sender: TObject);
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

     btnOKMain_toChild.Enabled:=true;
     btnOKChild_toMain.Enabled:=true;
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
function TMainForm.fExecSqFromQuery(mySql:String):String;
begin
     //
     with fromSqlQuery,Sql do begin
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
function TMainForm.fExecForm_repl_to (FormName, FormData:String):String;
begin
     Result:= '';
     //
     with spExecForm_repl_to do
     begin
          ParamByName('inFormName').Value   := FormName;
          ParamByName('inFormData').Value   := FormData;
          ParamByName('gConnectHost').Value := '';
          try Execute;
          except on E:Exception do Result:= E.Message;
          end;
     end;
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
      or(PropertyName = 'MovementString')or(PropertyName = 'MovementItemString')
     then Result:= ConvertFromVarChar(_ValueS)
     else
     if (PropertyName = 'ObjectFloat')or(PropertyName = 'ObjectHistoryFloat')
      or(PropertyName = 'MovementFloat')or(PropertyName = 'MovementItemFloat')
     then Result:= ConvertFromFloat(_ValueF)
     else
     if (PropertyName = 'ObjectDate')or(PropertyName = 'ObjectHistoryDate')
      or(PropertyName = 'MovementDate')or(PropertyName = 'MovementItemDate')
     then Result:= ConvertFromDateTime(_ValueD, _isNullD)
     else
     if (PropertyName = 'ObjectBoolean')
      or(PropertyName = 'MovementBoolean')or(PropertyName = 'MovementItemBoolean')
     then Result:= ConvertFromBoolean(_ValueB, _isNullB)
     //else
     //if (PropertyName = 'ObjectLink')or(PropertyName = 'ObjectHistoryLink')
     //then Result:= ConvertFromInt(ChildObjectId)
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
function TMainForm.IniConnection_Main(isConnected : Boolean): Boolean;
//Main: ���������� - ������
begin
     // ���� �� ����������� - �������
     if isConnected = FALSE then begin Result:= true; exit; end;
     //
     //
     AddToMemoMsg('----- startConnect Main:', FALSE);
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now), FALSE);
     //
     with mainZConnection do begin
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
function TMainForm.IniConnection_Child (_PropertyName : String; isGetDesc: Boolean) : Boolean;
//Child: ���������� - ������
var i : Integer;
begin
     Result:= false;
     //
     try
     //
     AddToMemoMsg('----- startConnect Child(' + _PropertyName + '):', FALSE);
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now), FALSE);
     //
     with childZConnection do begin
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
           // Movement...
           Add('union all');
           Add('select Code AS DescName, Id from MovementDesc');
           Add('union all');
           Add('select Code AS DescName, Id from MovementStringDesc');
           Add('union all');
           Add('select Code AS DescName, Id from MovementFloatDesc');
           Add('union all');
           Add('select Code AS DescName, Id from MovementDateDesc');
           Add('union all');
           Add('select Code AS DescName, Id from MovementLinkObjectDesc');
           Add('union all');
           Add('select Code AS DescName, Id from MovementLinkMovementDesc');
           //
           // MovementItem...
           Add('union all');
           Add('select Code AS DescName, Id from MovementItemDesc');
           Add('union all');
           Add('select Code AS DescName, Id from MovementItemStringDesc');
           Add('union all');
           Add('select Code AS DescName, Id from MovementItemFloatDesc');
           Add('union all');
           Add('select Code AS DescName, Id from MovementItemDateDesc');
           Add('union all');
           Add('select Code AS DescName, Id from MovementItemLinkObjectDesc');
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
          AddToMemoMsg (' ??? procedure IniConnection_Child ???', TRUE);
          AddToMemoMsg (E.Message, TRUE);
          Result:= false;
          exit;
       end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pInsert_ReplMovement_fromChild : Boolean;
//Child: ���������� - !�� ������! - !������ ��� � �� ������� fQuery!
begin
     Result:= false;
     //
     try

     gSessionGUID:= GenerateGUID (FALSE);
     //
     AddToMemoMsg('----- gSessionGUID (fromChild) :', FALSE);
     AddToMemoMsg(gSessionGUID, FALSE);
     //
     if 1=1 // cbClientDataSet.Checked = TRUE
     then
       with spInsert_ReplMovement_fromChild do
       begin
           ParamByName('inSessionGUID').Value:= gSessionGUID;
           ParamByName('inStartDate').Value  := ArrayReplServer[1].Start_fromChild;
           ParamByName('inDescCode').Value   := EditObjectDescId.Text;
           ParamByName('gConnectHost').Value := ArrayReplServer[1].HostName;
           ParamByName('inDataBaseId').Value := ArrayReplServer[1].Id;
           Execute;
           //
           outCount          :=ParamByName('outCount').Value;
           outCountString    :=ParamByName('outCountString').Value;
           outCountFloat     :=ParamByName('outCountFloat').Value;
           outCountDate      :=ParamByName('outCountDate').Value;
           outCountBoolean   :=ParamByName('outCountBoolean').Value;
           outCountLink      :=ParamByName('outCountLink').Value;
           outCountLinkM     :=ParamByName('outCountLinkM').Value;

           outCountHistory       :=ParamByName('outCountMI').Value;
           outCountHistoryString :=ParamByName('outCountMIString').Value;
           outCountHistoryFloat  :=ParamByName('outCountMIFloat').Value;
           outCountHistoryDate   :=ParamByName('outCountMIDate').Value;
           outCountHistoryBoolean:=ParamByName('outCountMIBoolean').Value;
           outCountHistoryLink   :=ParamByName('outCountMILink').Value;

           outMinId          :=ParamByName('outMinId').Value;
           outMaxId          :=ParamByName('outMaxId').Value;
           outCountIteration :=ParamByName('outCountIteration').Value;
           outCountPack      :=ParamByName('outCountPack').Value;
       end;
     //
     //
     AddToMemoMsg('Count : ' + IntToStr (outCount), FALSE);
     AddToMemoMsg('String : ' + IntToStr (outCountString), FALSE);
     AddToMemoMsg('Float : ' + IntToStr (outCountFloat), FALSE);
     AddToMemoMsg('Date : ' + IntToStr (outCountDate), FALSE);
     AddToMemoMsg('Boolean : ' + IntToStr (outCountBoolean), FALSE);
     AddToMemoMsg('Link : ' + IntToStr (outCountLink), FALSE);
     AddToMemoMsg('LinkM : ' + IntToStr (outCountLinkM), FALSE);
     AddToMemoMsg('-', FALSE);
     AddToMemoMsg('CountMI : ' + IntToStr (outCountHistory), FALSE);
     AddToMemoMsg('MIString : ' + IntToStr (outCountHistoryString), FALSE);
     AddToMemoMsg('MIFloat : ' + IntToStr (outCountHistoryFloat), FALSE);
     AddToMemoMsg('MIDate : ' + IntToStr (outCountHistoryDate), FALSE);
     AddToMemoMsg('MIBoolean : ' + IntToStr (outCountHistoryBoolean), FALSE);
     AddToMemoMsg('MILink : ' + IntToStr (outCountHistoryLink), FALSE);
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
function TMainForm.pInsert_ReplMovement : Boolean;
//Main: ���������� �� ����� cbClientDataSet - ���� ��� ����� ������
begin
     Result:= false;
     //
     try

     gSessionGUID:= GenerateGUID (TRUE);
     //
     AddToMemoMsg('----- gSessionGUID (fromMain) :', FALSE);
     AddToMemoMsg(gSessionGUID, FALSE);
     //
     if cbClientDataSet.Checked = TRUE
     then
       with spInsert_ReplMovement do
       begin
           ParamByName('inSessionGUID').Value:= gSessionGUID;
           ParamByName('inStartDate').Value  := ArrayReplServer[1].Start_toChild;
           ParamByName('inDescCode').Value   := EditObjectDescId.Text;
           ParamByName('gConnectHost').Value := ArrayReplServer[0].HostName;
           ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
           Execute;
           //
           outCount          :=ParamByName('outCount').Value;
           outCountString    :=ParamByName('outCountString').Value;
           outCountFloat     :=ParamByName('outCountFloat').Value;
           outCountDate      :=ParamByName('outCountDate').Value;
           outCountBoolean   :=ParamByName('outCountBoolean').Value;
           outCountLink      :=ParamByName('outCountLink').Value;
           outCountLinkM     :=ParamByName('outCountLinkM').Value;

           outCountHistory       :=ParamByName('outCountMI').Value;
           outCountHistoryString :=ParamByName('outCountMIString').Value;
           outCountHistoryFloat  :=ParamByName('outCountMIFloat').Value;
           outCountHistoryDate   :=ParamByName('outCountMIDate').Value;
           outCountHistoryBoolean:=ParamByName('outCountMIBoolean').Value;
           outCountHistoryLink   :=ParamByName('outCountMILink').Value;

           outMinId          :=ParamByName('outMinId').Value;
           outMaxId          :=ParamByName('outMaxId').Value;
           outCountIteration :=ParamByName('outCountIteration').Value;
           outCountPack      :=ParamByName('outCountPack').Value;
       end
     else
       with fromSqlQuery do
       begin
           // ������������ � ������� Main - �����������
           if not IniConnection_Main (TRUE) then exit;
           //
           fOpenSqFromQuery ('select * from gpInsert_ReplMovement('+ConvertFromVarChar(gSessionGUID)
                            +',' + FormatFromDateTime(ArrayReplServer[1].Start_toChild)
                            +',' + ConvertFromVarChar(EditObjectDescId.Text)
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
           outCountLinkM     :=FieldByName('outCountLinkM').AsInteger;

           outCountHistory       :=ParamByName('outCountMI').Value;
           outCountHistoryString :=ParamByName('outCountMIString').Value;
           outCountHistoryFloat  :=ParamByName('outCountMIFloat').Value;
           outCountHistoryDate   :=ParamByName('outCountMIDate').Value;
           outCountHistoryBoolean:=ParamByName('outCountMIBoolean').Value;
           outCountHistoryLink   :=ParamByName('outCountMILink').Value;

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
     AddToMemoMsg('LinkM : ' + IntToStr (outCountLinkM), FALSE);
     AddToMemoMsg('-', FALSE);
     AddToMemoMsg('CountMI : ' + IntToStr (outCountHistory), FALSE);
     AddToMemoMsg('MIString : ' + IntToStr (outCountHistoryString), FALSE);
     AddToMemoMsg('MIFloat : ' + IntToStr (outCountHistoryFloat), FALSE);
     AddToMemoMsg('MIDate : ' + IntToStr (outCountHistoryDate), FALSE);
     AddToMemoMsg('MIBoolean : ' + IntToStr (outCountHistoryBoolean), FALSE);
     AddToMemoMsg('MILink : ' + IntToStr (outCountHistoryLink), FALSE);
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
function TMainForm.pInsert_ReplObject : Boolean;
//Main: ���������� �� ����� cbClientDataSet - ���� ��� ����� ������
begin
     Result:= false;
     //
     try

     gSessionGUID:= GenerateGUID (TRUE);
     //
     AddToMemoMsg('----- gSessionGUID (fromMain) :', FALSE);
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
           // ������������ � ������� Main - �����������
           if not IniConnection_Main (TRUE) then exit;
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
function TMainForm.pOpen_ReplMovement (isFromMain, isLinkM : Boolean; Num_main : Integer; StartId, EndId : LongInt; isMI : Boolean) : Boolean;
var lMovement, lMovementString, lMovementFloat, lMovementDate, lMovementBoolean, lMovementLinkO, lMovementLinkM : String;

    procedure pExec_Select (spName : String; spSelect : TdsdStoredProc);
    begin
       with spSelect do
       begin
           StoredProcName:= spName;
           //
           ParamByName('inSessionGUID').Value:= gSessionGUID;
           ParamByName('inStartId').Value    := StartId;
           ParamByName('inEndId').Value      := EndId;
           if isFromMain = TRUE then
           begin
             ParamByName('inDataBaseId').Value := ArrayReplServer[0].Id;
             ParamByName('gConnectHost').Value := ArrayReplServer[0].HostName;
           end
           else begin
             ParamByName('inDataBaseId').Value := ArrayReplServer[1].Id;
             ParamByName('gConnectHost').Value := ArrayReplServer[1].HostName;
           end;
           Execute;
       end;
    end;
    procedure pOpen_Select (spName : String; lQuery : TZQuery);
    begin
       if isFromMain = FALSE then ShowMessage('Error - pOpen_Select - isFromMain = FALSE');
       //
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
     if isMI = TRUE then
     begin
          lMovement        := 'MovementItem';
          lMovementString  := 'MovementItemString';
          lMovementFloat   := 'MovementItemFloat';
          lMovementDate    := 'MovementItemDate';
          lMovementBoolean := 'MovementItemBoolean';
          lMovementLinkO   := 'MovementItemLinkObject';
          lMovementLinkM   := '';
     end
     else
     begin
          lMovement        := 'Movement';
          lMovementString  := 'MovementString';
          lMovementFloat   := 'MovementFloat';
          lMovementDate    := 'MovementDate';
          lMovementBoolean := 'MovementBoolean';
          lMovementLinkO   := 'MovementLinkObject';
          lMovementLinkM   := 'MovementLinkMovement';
     end;
     //
     // ������������ � ������� Main - ���� ����
     if isFromMain = TRUE then
       if not IniConnection_Main (not cbClientDataSet.Checked) then exit;
     //
     // �������
     if isLinkM = TRUE then AddToMemoMsg(' ...', FALSE);
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
     if (cbClientDataSet.Checked = TRUE) or (isFromMain = FALSE) then
     begin
         if cbShowGrid.Checked = True then
         begin
           //
           ObjectDS.DataSet       := MovementCDS;
           ObjectStringDS.DataSet := MSCDS;
           ObjectFloatDS.DataSet  := MFCDS;
           ObjectDateDS.DataSet   := MDCDS;
           ObjectBooleanDS.DataSet:= MBCDS;
           ObjectLinkDS.DataSet   := MLOCDS;
         end;
         //
         if isLinkM = FALSE then
         begin
           //
           pExec_Select ('gpSelect_Repl' + lMovement, spSelect_ReplMovement);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovement, FALSE);
           //
           pExec_Select ('gpSelect_Repl' + lMovementString, spSelect_ReplMS);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementString, FALSE);
           //
           pExec_Select ('gpSelect_Repl' + lMovementFloat, spSelect_ReplMF);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementFloat, FALSE);
           //
           pExec_Select ('gpSelect_Repl' + lMovementDate, spSelect_ReplMD);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementDate, FALSE);
           //
           pExec_Select ('gpSelect_Repl' + lMovementBoolean, spSelect_ReplMB);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementBoolean, FALSE);
           //
           pExec_Select ('gpSelect_Repl' + lMovementLinkO, spSelect_ReplMLO);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementLinkO, FALSE);
         end
         else begin
           //
           pExec_Select ('gpSelect_Repl' + lMovementLinkM, spSelect_ReplMLM);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementLinkM, FALSE);
         end;
     end
     else
     begin
         if cbShowGrid.Checked = True then
         begin
           //
           ObjectDS.DataSet       := fQueryMovement;
           ObjectStringDS.DataSet := fQueryMS;
           ObjectFloatDS.DataSet  := fQueryMF;
           ObjectDateDS.DataSet   := fQueryMD;
           ObjectBooleanDS.DataSet:= fQueryMB;
           ObjectLinkDS.DataSet   := fQueryMLO;
         end;
         //
         if isLinkM = FALSE then
         begin
           //
           pOpen_Select ('gpSelect_Repl' + lMovement, fQueryMovement);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovement, FALSE);
           //
           pOpen_Select ('gpSelect_Repl' + lMovementString, fQueryMS);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementString, FALSE);
           //
           pOpen_Select ('gpSelect_Repl' + lMovementFloat, fQueryMF);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementFloat, FALSE);
           //
           pOpen_Select ('gpSelect_Repl' + lMovementDate, fQueryMD);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementDate, FALSE);
           //
           pOpen_Select ('gpSelect_Repl' + lMovementBoolean, fQueryMB);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementBoolean, FALSE);
           //
           pOpen_Select ('gpSelect_Repl' + lMovementLinkO, fQueryMLO);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementLinkO, FALSE);

         end
         else begin
           //
           pOpen_Select ('gpSelect_Repl' + lMovementLinkM, fQueryMLM);
           AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' - end Open ' + lMovementLinkM, FALSE);
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
     // ������������ � ������� Main - ���� ����
     if not IniConnection_Main (not cbClientDataSet.Checked) then exit;
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
function TMainForm.pSendPackTo_ReplMovement (isFromMain : Boolean; Num_main, CountPack : Integer; isMI : Boolean) : Boolean;
//Main:  ���������� �� ����� cbClientDataSet - ���� ��� ����� ������ (�����. � �����)
//Child: ���������� - ������ - ��������� ������ StrPack
var StrPack, nextL : String;
    i, num  : Integer;
    resStr  : String;
    myCDS : TClientDataSet;
    lMovement, zc_Desc_GUID : String;
begin
     Result:= false;
     //
     //
     if isMI = TRUE then lMovement := 'MovementItem' else lMovement := 'Movement';
     //
     // ������������ � ������� Child
     if isFromMain = TRUE then
       if not IniConnection_Child (lMovement, FALSE) then exit;
     // ������������ � ������� Main - �����������
     if isFromMain = FALSE then
       if not IniConnection_Main (TRUE) then exit;
     //
     try
     //
     i:=0;
     num:=0;
     StrPack:= '';
     nextL  := #13;
     //
     //
     if (cbClientDataSet.Checked = TRUE) or (isFromMain = FALSE)
     then myCDS:= TClientDataSet(MovementCDS)
     else myCDS:= TClientDataSet(fQueryMovement);
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
                          + ' DECLARE vbId Integer;' + nextL
                          + ' DECLARE vbParentId Integer;' + nextL;
                  //
                  if (isMI = TRUE)
                  then StrPack:= StrPack + ' DECLARE vbMovementId Integer;' + nextL
                                         + ' DECLARE vbObjectId   Integer;' + nextL
                                          ;
                  //
                  StrPack:= StrPack
                          + ' BEGIN' + nextL + nextL + nextL
                          ;
                  num:= num + 1;
             end;
             //
             // ������� Movement...Desc
             if (isFromMain = TRUE) and (GetArrayList_Index_byValue(ArrayObjectDesc,FieldByName('DescName').AsString) < 0) then
             begin
                  // �������
                  StrPack:= StrPack + ' -- NEW Desc' + nextL;
                  //
                  StrPack:= StrPack
                          + nextL
                          + '   CREATE OR REPLACE FUNCTION ' + FieldByName('DescName').AsString + '() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + '); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;'
                          + nextL
                          + '   INSERT INTO '+lMovement+'Desc (Id, Code, ItemName)'
                          + '   SELECT ' + IntToStr(FieldByName('DescId').AsInteger) + ', ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ', ' + ConvertFromVarChar(FieldByName('ItemName').AsString) + ' WHERE NOT EXISTS (SELECT * FROM '+lMovement+'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ');'
                          + nextL
                          + nextL;
                  //
                  // ��������� � ������ - ������������ Desc � ���� Child
                  SetLength(ArrayObjectDesc,Length(ArrayObjectDesc)+1);
                  ArrayObjectDesc[Length(ArrayObjectDesc)-1]:=FieldByName('DescName').AsString;
             end;
             //
             // �������� Id
             StrPack:= StrPack + ' vbId:= 0;' + nextL;
             // ����� Id
             if (isMI = FALSE)
             then //Movement
                  StrPack:= StrPack
                            // ����� Id - ����� ���� NULL
                          + ' vbId:= (SELECT MovementId FROM MovementString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_MovementString_GUID());'
                          + nextL
                            // ����� "��������" Movement
                          + ' vbParentId:= NULL;'
                          + ' IF ' + ConvertFromVarChar(FieldByName('GUID_parent').AsString) + ' <> ' + ConvertFromVarChar('')
                          + ' THEN'
                          + nextL
                          + '     vbParentId:= (SELECT MovementId FROM MovementString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID_parent').AsString) + ' and DescId = zc_MovementString_GUID());'
                          + nextL
                                  // ��������
                          + '     IF COALESCE (vbParentId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID_parent = <'+FieldByName('GUID_parent').AsString+'>')+'; END IF;'
                          + nextL
                          + ' END IF;'
                          + nextL
             else //MovementItem
                  StrPack:= StrPack
                            // ����� Id - ����� ���� NULL
                          + ' vbId:= (SELECT MovementItemId FROM MovementItemString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_MIString_GUID());'
                          + nextL
                            // ����� "��������" MovementItem
                          + ' vbParentId:= NULL;'
                          + ' IF ' + ConvertFromVarChar(FieldByName('GUID_parent').AsString) + ' <> ' + ConvertFromVarChar('')
                          + ' THEN'
                          + nextL
                          + '     vbParentId:= (SELECT MovementItemId FROM MovementItemString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID_parent').AsString) + ' and DescId = zc_MIString_GUID());'
                          + nextL
                                  // ��������
                          + '     IF COALESCE (vbParentId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID_parent = <'+FieldByName('GUID_parent').AsString+'>')+'; END IF;'
                          + nextL
                          + ' END IF;'
                          + nextL
                            // ����� MovementId
                          + ' vbMovementId:= NULL;'
                          + ' vbMovementId:= (SELECT MovementId FROM MovementString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID_movement').AsString) + ' and DescId = zc_MovementString_GUID());'
                          + nextL
                           // ��������
                          + ' IF COALESCE (vbMovementId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID_movement = <'+FieldByName('GUID_movement').AsString+'>')+'; END IF;'
                          + nextL
                            // ����� ObjectId
                         + ' vbObjectId:= NULL;'
                         + ' IF ' + ConvertFromVarChar(FieldByName('GUID_object').AsString) + ' <> ' + ConvertFromVarChar('')
                         + ' THEN'
                         + nextL
                         + '     vbObjectId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID_object').AsString) + ' and DescId = zc_ObjectString_GUID());'
                         + nextL
                                 // ��������
                         + '     IF COALESCE (vbObjectId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID_object = <'+FieldByName('GUID_object').AsString+'>')+'; END IF;'
                         + nextL
                         + ' END IF;'
                         + nextL
                         + nextL;
             // ����������� UPDATE
             if (isMI = FALSE)
             then
               //Movement
               StrPack:= StrPack
                       + ' IF vbId > 0 THEN'
                       + nextL
                       + '    UPDATE Movement SET DescId      = ' + IntToStr(FieldByName('DescId').AsInteger)
                       + nextL
                       + '                      , StatusId    = ' + IntToStr(FieldByName('StatusId').AsInteger)
                       + nextL
                       + '                      , InvNumber   = ' + ConvertFromVarChar(FieldByName('InvNumber').AsString)
                       + nextL
                       + '                      , OperDate    = ' + ConvertFromDateTime(FieldByName('OperDate').AsDateTime, FALSE)
                       + nextL
                       + '                      , ParentId    = vbParentId'
                       + nextL
                       + '                      , AccessKeyId = ' + ConvertFromInt(FieldByName('AccessKeyId').AsInteger)
                       + nextL
                       + '    WHERE Id = vbId;'
                       + nextL
                       + ' END IF;'
                       + nextL
                       + nextL
             else
               //MovementItem
               StrPack:= StrPack
                       + ' IF vbId > 0 THEN'
                       + nextL
                       + '    UPDATE MovementItem SET DescId     = ' + IntToStr(FieldByName('DescId').AsInteger)
                       + nextL
                       + '                          , MovementId = vbMovementId'
                       + nextL
                       + '                          , ObjectId   = vbObjectId'
                       + nextL
                       + '                          , Amount     = ' + ConvertFromFloat(FieldByName('Amount').AsFloat)
                       + nextL
                       + '                          , ParentId   = vbParentId'
                       + nextL
                       + '                          , isErased   = ' + ConvertFromBoolean(FieldByName('isErased').AsBoolean, FALSE)
                       + nextL
                       + '    WHERE Id = vbId;'
                       + nextL
                       + ' END IF;'
                       + nextL
                       + nextL
                        ;
             //
             // ����� INSERT
             if (isMI = FALSE)
             then
                  //Movement
                  StrPack:= StrPack
                          + ' IF NOT FOUND OR COALESCE (vbId, 0) = 0 THEN'
                          + nextL
                          + '    INSERT INTO Movement (DescId, StatusId, InvNumber, OperDate, ParentId, AccessKeyId)'
                          + nextL
                          + '    VALUES (' + IntToStr(FieldByName('DescId').AsInteger)
                          +           ', ' + IntToStr(FieldByName('StatusId').AsInteger)
                          +           ', ' + ConvertFromVarChar(FieldByName('InvNumber').AsString)
                          +           ', ' + ConvertFromDateTime(FieldByName('OperDate').AsDateTime, FALSE)
                          +           ', vbParentId'
                          +           ', ' + ConvertFromInt(FieldByName('AccessKeyId').AsInteger)
                          +           ')'
                          + nextL
                          + '    RETURNING Id INTO vbId;'
                          + nextL
                          + ' END IF;'
                          + nextL
                          + nextL
              else //MovementItem
                   StrPack:= StrPack
                          + ' IF NOT FOUND OR COALESCE (vbId, 0) = 0 THEN'
                          + nextL
                          + '    INSERT INTO MovementItem (DescId, MovementId, ObjectId, Amount, ParentId, isErased)'
                          + nextL
                          + '    VALUES (' + IntToStr(FieldByName('DescId').AsInteger)
                          +           ', vbMovementId'
                          +           ', vbObjectId'
                          +           ', ' + ConvertFromFloat(FieldByName('Amount').AsFloat)
                          +           ', vbParentId'
                          +           ', ' + ConvertFromBoolean(FieldByName('isErased').AsBoolean, FALSE)
                          +           ')'
                          + nextL
                          + '     RETURNING Id INTO vbId;'
                          + nextL
                          + nextL
                          + ' END IF;'
                          + nextL
                          + nextL;
             //
             if (isMI = FALSE) then zc_Desc_GUID:='zc_MovementString_GUID()' else zc_Desc_GUID:='zc_MIString_GUID()';
             // �������
             StrPack:= StrPack + ' -----' + nextL;
             // ������ - ���������  GUID
             StrPack:= StrPack
                      // ����������� UPDATE
                 +    ' UPDATE '+lMovement+'String SET ValueData   = ' + ConvertFromVarChar(FieldByName('GUID').AsString)
                 + nextL
                 +    ' WHERE '+lMovement+'Id = vbId AND DescId = '+zc_Desc_GUID+';'
                 + nextL
                 + nextL
                      // ����� INSERT
                  + ' IF NOT FOUND THEN'
                  + nextL
                  + '    INSERT INTO '+lMovement+'String ('+lMovement+'Id, DescId, ValueData)'
                  + nextL
                  + '    VALUES (vbId, '+zc_Desc_GUID+',' + ConvertFromVarChar(FieldByName('GUID').AsString) + ');'
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
                  StrPack:= StrPack + ' END $$;';
                  //
                  //
                  // !!!��������� - ������!!!
                  if (isFromMain = TRUE)
                  then resStr:= fExecSqToQuery (StrPack)
                  else resStr:= fExecSqFromQuery (StrPack);
                  //
                  if resStr = ''
                  then
                      // ��������� = OK
                      StrPack:= StrPack + ' ------ Result = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
                  else begin
                      // ��������� = ERROR
                      StrPack:= StrPack + ' ------ Result = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL;
                      // !!!��������� - � ����!!!
                      AddToLog(StrPack, lMovement, gSessionGUID, false);
                      //
                      // ERROR
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (lMovement + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
                      AddToMemoMsg (resStr, TRUE);
                      //
                      exit;
                  end;
                  //
                  // !!!��������� - � ����!!!
                  //ShowMessage (StrPack);
                  AddToLog(StrPack, lMovement, gSessionGUID, false);
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
          if (isFromMain = TRUE)
          then resStr:= fExecSqToQuery (StrPack)
          else resStr:= fExecSqFromQuery (StrPack);
          //
          if resStr = ''
          then
              // ��������� = OK
              StrPack:= StrPack + ' ------ Result = OK : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL
          else begin
              // ��������� = ERROR
              StrPack:= StrPack + ' ------ Result = ERROR : ' + IntToStr(Num_main) + ':' + IntToStr(num) + nextL + nextL;
              // !!!��������� - � ����!!!
              AddToLog(StrPack, lMovement, gSessionGUID, false);
              //
              // ERROR
              AddToMemoMsg ('', FALSE);
              AddToMemoMsg (lMovement + ' : ' + IntToStr(Num_main) + ':' + IntToStr(num), FALSE);
              AddToMemoMsg (resStr, TRUE);
              //
              exit;
          end;
          //
          // !!!��������� - � ����!!!
          AddToLog(StrPack, lMovement, gSessionGUID, false);
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
function TMainForm.pSendPackTo_ReplMovementProperty (isFromMain : Boolean; Num_main, CountPack : Integer; CDSData : TClientDataSet; isMI : Boolean) : Boolean;
//Main:  ���������� �� ����� cbClientDataSet - ���� ��� ����� ������ (�����. � �����)
//Child: ���������� - ������ - ��������� ������ StrPack
var StrPack, nextL : String;
    i, num  : Integer;
    _PropertyName, _PropertyValue, Column_upd : String;
    resStr : String;
    lMovement: String;
begin
     Result:= false;
     //
     //
     if isMI = TRUE then lMovement := 'MovementItem' else lMovement := 'Movement';
     //
     try

     i:=0;
     num:=0;
     StrPack:= '';
     nextL  := #13;
     //
     with CDSData do begin
        //
        if (Name =  'fQueryMS')  or (Name =  'MSCDS')  then _PropertyName:= lMovement + 'String';
        if (Name =  'fQueryMF')  or (Name =  'MFCDS')  then _PropertyName:= lMovement + 'Float';
        if (Name =  'fQueryMD')  or (Name =  'MDCDS')  then _PropertyName:= lMovement + 'Date';
        if (Name =  'fQueryMB')  or (Name =  'MBCDS')  then _PropertyName:= lMovement + 'Boolean';
        if (Name =  'fQueryMLO') or (Name =  'MLOCDS') then _PropertyName:= lMovement + 'LinkObject';
        if (Name =  'fQueryMLM') or (Name =  'MLMCDS') then _PropertyName:= lMovement + 'LinkMovement';
        //
        // ������������ � ������� Child
        if isFromMain = TRUE then
          if not IniConnection_Child (_PropertyName, FALSE) then exit;
        // ������������ � ������� Main - �����������
        if isFromMain = FALSE then
          if not IniConnection_Main (TRUE) then exit;
        //
        //
        First;
        while not EOF  do
        begin
             //!!!
             if fStop then begin exit;end;
             //!!!
             // ��������
             if (_PropertyName = 'MovementLinkObject')or(_PropertyName = 'MovementItemLinkObject')
             then
               _PropertyValue:= 'vbObjectId'
             else
             if (_PropertyName = 'MovementLinkMovement')
             then
               _PropertyValue:= 'vbMovementId'
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
                  if (_PropertyName = 'MovementLinkMovement')
                  then StrPack:= StrPack + ' DECLARE vbMovementId Integer;' + nextL;
                  //
                  if (_PropertyName = 'MovementLinkObject')or(_PropertyName = 'MovementItemLinkObject')
                  then StrPack:= StrPack + ' DECLARE vbObjectId Integer;' + nextL;
                  //
                  StrPack:= StrPack
                          + ' BEGIN' + nextL + nextL + nextL
                          ;
                  num:= num + 1;
             end;
             //
             // ������� Movement...Desc
             if GetArrayList_Index_byValue(ArrayObjectDesc,FieldByName('DescName').AsString) < 0 then
             begin
                  // �������
                  StrPack:= StrPack + ' -- NEW ' + _PropertyName + 'Desc' + nextL;
                  //
                  StrPack:= StrPack
                          + nextL
                          + '   CREATE OR REPLACE FUNCTION ' + FieldByName('DescName').AsString + '() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ' + _PropertyName + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + '); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;'
                          + nextL
                          + '   INSERT INTO ' + _PropertyName + 'Desc (Id, Code, ItemName)'
                          + '   SELECT ' + IntToStr(FieldByName('DescId').AsInteger) + ', ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ', ' + ConvertFromVarChar(FieldByName('ItemName').AsString) + ' WHERE NOT EXISTS (SELECT * FROM ' + _PropertyName + 'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ');'
                          + nextL
                          + nextL;
                  //
                  // ��������� � ������ - ������������ Desc � ���� TO
                  SetLength(ArrayObjectDesc,Length(ArrayObjectDesc)+1);
                  ArrayObjectDesc[Length(ArrayObjectDesc)-1]:=FieldByName('DescName').AsString;
             end;
             //
             // �������� Id
             StrPack:= StrPack + ' vbId:= 0;' + nextL;
             //
             //
             if (_PropertyName = 'MovementLinkMovement')
             then
                 // ����� ��� MovementLinkMovement
                 StrPack:= StrPack
                         // ����� ������������ Movement
                         + ' vbMovementId:= NULL;'
                         + ' IF ' + ConvertFromVarChar(FieldByName('GUID_child').AsString) + ' <> ' + ConvertFromVarChar('')
                         + ' THEN'
                         + nextL
                         + '     vbMovementId:= (SELECT MovementId FROM MovementString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID_child').AsString) + ' and DescId = zc_MovementString_GUID());'
                         + nextL
                                 // ��������
                         + '     IF COALESCE (vbMovementId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID_child= <'+FieldByName('GUID_child').AsString+'>')+'; END IF;'
                         + nextL
                         + ' END IF;'
                         + nextL + nextL;
             //
             if (_PropertyName = 'MovementLinkObject')or(_PropertyName = 'MovementItemLinkObject')
             then
                 // ����� ��� Movement...LinkObject
                 StrPack:= StrPack
                         // ����� ������������ Object
                         + ' vbObjectId:= NULL;'
                         + ' IF ' + ConvertFromVarChar(FieldByName('GUID_child').AsString) + ' <> ' + ConvertFromVarChar('')
                         + ' THEN'
                         + nextL
                         + '     vbObjectId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID_child').AsString) + ' and DescId = zc_ObjectString_GUID());'
                         + nextL
                                 // ��������
                         + '     IF COALESCE (vbObjectId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID_child = <'+FieldByName('GUID_child').AsString+'>')+'; END IF;'
                         + nextL
                         + ' END IF;'
                         + nextL + nextL;
             //
             // ����� Id
             if (_PropertyName = 'MovementItemString')or(_PropertyName = 'MovementItemFloat')
              or(_PropertyName = 'MovementItemDate')  or(_PropertyName = 'MovementItemBoolean')
              or(_PropertyName = 'MovementItemLinkObject')
             then
                 StrPack:= StrPack
                         // ����� Id
                         + ' vbId:= (SELECT MovementItemId FROM MovementItemString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_MIString_GUID());'
                         + nextL
                             // ��������
                         + ' IF COALESCE (vbId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID = <'+FieldByName('GUID').AsString+'>')+'; END IF;'
                         + nextL
             else
                 StrPack:= StrPack
                         // ����� Id
                         + ' vbId:= (SELECT MovementId FROM MovementString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_MovementString_GUID());'
                         + nextL
                             // ��������
                         + ' IF COALESCE (vbId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID = <'+FieldByName('GUID').AsString+'>')+'; END IF;'
                         + nextL
                          ;
             //
             if (_PropertyName = 'MovementLinkObject')or(_PropertyName = 'MovementItemLinkObject')
             then Column_upd := 'ObjectId'
             else
             if (_PropertyName = 'MovementLinkMovement')
             then Column_upd := 'MovementChildId'
             else Column_upd := 'ValueData';
             //
             // ����������� UPDATE
             StrPack:= StrPack
                     + '    UPDATE ' + _PropertyName + ' SET ' + Column_upd + ' = ' + _PropertyValue
                     + nextL
                     + '    WHERE '+lMovement+'Id = vbId and DescId = ' + IntToStr(FieldByName('DescId').AsInteger) + ' ;' + ' -- ' + FieldByName('DescName').AsString
                     + nextL
                     + nextL;
             // ����� INSERT
             StrPack:= StrPack
                    + ' IF NOT FOUND THEN'
                    + nextL
                    + '    INSERT INTO ' + _PropertyName + ' (DescId, '+lMovement+'Id, ' + Column_upd + ')'
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
                  if (isFromMain = TRUE)
                  then resStr:= fExecSqToQuery (StrPack)
                  else resStr:= fExecSqFromQuery (StrPack);
                  //
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
          // !!!��������� - ������!!!
          if (isFromMain = TRUE)
          then resStr:= fExecSqToQuery (StrPack)
          else resStr:= fExecSqFromQuery (StrPack);
          //
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
function TMainForm.pSendPackTo_ReplObject (Num_main, CountPack : Integer; isHistory : Boolean) : Boolean;
//Main:  ���������� �� ����� cbClientDataSet - ���� ��� ����� ������ (�����. � �����)
//Child: ���������� - ������ - ��������� ������ StrPack
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
     //if isHistory = TRUE then sHist   := 'History'       else sHist   := '';

     //
     //if cbClientDataSet.Checked = FALSE then
       // ������������ � ������� Child
       if not IniConnection_Child (lObject, FALSE) then exit;
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
                          + '   INSERT INTO '+lObject+'Desc (Id, Code, ItemName)'
                          + '   SELECT ' + IntToStr(FieldByName('DescId').AsInteger) + ', ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ', ' + ConvertFromVarChar(FieldByName('ItemName').AsString) + ' WHERE NOT EXISTS (SELECT * FROM '+lObject+'Desc WHERE Code = ' + ConvertFromVarChar(FieldByName('DescName').AsString) + ');'
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
                          // ����� Id
                          + ' vbId:= ' + IntToStr(FieldByName('ObjectHistoryId').AsInteger) + ';'
                          + nextL
             else
               if (cbGUID.Checked = TRUE) and (isHistory = FALSE)
               then StrPack:= StrPack
                            // ����� Id - ����� ���� NULL
                            + ' vbId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_ObjectString_GUID());'
                            + nextL
               else StrPack:= StrPack
                            // ����� Id - ����� ���� NULL
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
                 // ����� ��� ObjectHistory
                 StrPack:= StrPack
                         // ����� Object
                         + ' vbObjectId:= NULL;'
                         + ' IF ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' <> ' + ConvertFromVarChar('')
                         + ' THEN'
                         + nextL
                         + '     vbObjectId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_ObjectString_GUID());'
                         + nextL
                                 // ��������
                         + '     IF COALESCE (vbObjectId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID = <'+FieldByName('GUID').AsString+'>')+'; END IF;'
                         + nextL
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
//Main:  ���������� �� ����� cbClientDataSet - ���� ��� ����� ������ (�����. � �����)
//Child: ���������� - ������ - ��������� ������ StrPack
var StrPack, nextL : String;
    i, num  : Integer;
    _PropertyName, _PropertyValue, DescId_ins1,DescId_ins2, Column_upd : String;
    resStr : String;
    lObject, lObjectLink : String;
begin
     Result:= false;
     //
     //
     if isHistory = TRUE then lObject := 'ObjectHistory' else lObject := 'Object';
     //if isHistory = TRUE then sHist   := 'History'       else sHist   := '';
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
          // ������������ � ������� Child
          if not IniConnection_Child (_PropertyName, FALSE) then exit;
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
                 // ����� ������������ Object
                 StrPack:= StrPack
                         // ����� ObjectId
                         + ' vbObjectId:= NULL;'
                         + ' IF ' + ConvertFromVarChar(FieldByName('GUID_child').AsString) + ' <> ' + ConvertFromVarChar('')
                         + ' THEN'
                         + nextL
                         + '     vbObjectId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID_child').AsString) + ' and DescId = zc_ObjectString_GUID());'
                         + nextL
                                 // ��������
                         + '     IF COALESCE (vbObjectId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID_child = <'+FieldByName('GUID_child').AsString+'>')+'; END IF;'
                         + nextL
                         + ' END IF;'
                         + nextL + nextL;
             //
             // ����� Id
             if (isHistory = TRUE)
             then StrPack:= StrPack
                          // ����� Id
                          + ' vbId:= ' + IntToStr(FieldByName('ObjectHistoryId').AsInteger) + ';'
                          + nextL
             else
             if (cbGUID.Checked = TRUE) and (isHistory = FALSE)
             then StrPack:= StrPack
                          // ����� Id
                          + ' vbId:= (SELECT ObjectId FROM ObjectString WHERE ValueData = ' + ConvertFromVarChar(FieldByName('GUID').AsString) + ' and DescId = zc_ObjectString_GUID());'
                          + nextL
                          // ��������
                          + ' IF COALESCE (vbId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID = <'+FieldByName('GUID').AsString+'>')+'; END IF;'
                          + nextL
             else StrPack:= StrPack
                          // ����� Id
                          + ' vbId:= ' + IntToStr(FieldByName('ObjectId').AsInteger) + ';'
                          + nextL
                          // ��������
                          + ' IF COALESCE (vbId, 0) = 0 THEN RAISE EXCEPTION '+ConvertFromVarChar('������.�� ����� GUID = <'+FieldByName('GUID').AsString+'>')+'; END IF;'
                          + nextL
                          + nextL
                          ;
             //
             if (_PropertyName = lObjectLink) and (isHistory = TRUE)
             then Column_upd := 'ObjectId'
             else
             if (_PropertyName = lObjectLink) and (isHistory = FALSE)
             then Column_upd := 'ChildObjectId'
             else Column_upd := 'ValueData';
             //
             // ����������� UPDATE
             StrPack:= StrPack
                     + '    UPDATE ' + _PropertyName + ' SET ' + Column_upd + ' = ' + _PropertyValue
                     + nextL
                     + '    WHERE '+lObject+'Id = vbId and DescId = ' + IntToStr(FieldByName('DescId').AsInteger) + ' ;' + ' -- ' + FieldByName('DescName').AsString
                     + nextL
                     + nextL;
             // ����� INSERT
             StrPack:= StrPack
                    + ' IF NOT FOUND THEN'
                    + nextL
                    + '    INSERT INTO ' + _PropertyName + ' (DescId, '+lObject+'Id, ' + Column_upd + ')'
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
     // ������������ � ������� Child
     if not IniConnection_Child ('on Move_ObjectHistory_repl', FALSE) then exit;
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
//Main:  ���������� - ������
//Child: ���������� - ������ - ��������� ������ StrPack
var StrPack, nextL, resStr : String;
    lGUID : String;
    DescId_ins1,DescId_ins2,DescId_upd : String;
begin
     //
     lGUID:= GenerateGUID (TRUE);
     nextL  := #13;
     //
     // ������������ � ������� Main - �����������
     if not IniConnection_Main (TRUE) then exit;
     // ������������ � ������� Child
     if not IniConnection_Child ('ObjectDesc + ObjectHistoryDesc', FALSE)   then exit;
     //
     // ������� ������ �... ��...
     with fromSqlQuery,Sql do
     begin
           Clear;
           //
           // Object...
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
           // ObjectHistory...
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
           // Movement...
           Add('union all');
           Add('select 21 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('Movement') + ' as GroupId from MovementDesc');
           Add('union all');
           Add('select 22 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementString') + ' as GroupId from MovementStringDesc');
           Add('union all');
           Add('select 23 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementFloat') + ' as GroupId from MovementFloatDesc');
           Add('union all');
           Add('select 24 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementDate') + ' as GroupId from MovementDateDesc');
           Add('union all');
           Add('select 25 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementBoolean') + ' as GroupId from MovementBooleanDesc');
           Add('union all');
           Add('select 26 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementLinkObject') + ' as GroupId from MovementLinkObjectDesc');
           Add('union all');
           Add('select 27 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementLinkMovement') + ' as GroupId from MovementLinkMovementDesc');
           // MovementItem...
           Add('union all');
           Add('select 31 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementItem') + ' as GroupId from MovementItemDesc');
           Add('union all');
           Add('select 32 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementItemString') + ' as GroupId from MovementItemStringDesc');
           Add('union all');
           Add('select 33 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementItemFloat') + ' as GroupId from MovementItemFloatDesc');
           Add('union all');
           Add('select 34 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementItemDate') + ' as GroupId from MovementItemDateDesc');
           Add('union all');
           Add('select 35 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementItemBoolean') + ' as GroupId from MovementItemBooleanDesc');
           Add('union all');
           Add('select 36 AS NPP, Id, 0 AS DescId, 0 AS ChildObjectDescId, Code, ItemName, ' + ConvertFromVarChar('MovementItemLinkObject') + ' as GroupId from MovementItemLinkObjectDesc');
           //
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
             if   (FieldByName('GroupId').AsString <> 'Object')
              and (FieldByName('GroupId').AsString <> 'ObjectHistory')
              and (System.Pos('Movement', FieldByName('GroupId').AsString) <> 1)
              and (System.Pos('MovementItem', FieldByName('GroupId').AsString) <> 1)
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
function TMainForm.pSendAllTo_Forms : Boolean;
//Main:  ���������� - ������
//Child: ���������� - !�� ������! - !����� �-��� ����� ��������� ������ ����� spExecSql!
var lGUID, lFormData, tmp : String;
    resStr : String;
begin
    Result:= false;
    //
    //
    lGUID:= GenerateGUID (TRUE);
    //
    // ������������ � ������� Main - �����������
    if not IniConnection_Main (TRUE) then exit;
    //
    //
    try
    // ������� ������ �... ��...
    with fromSqlQuery,Sql do
    begin
         Clear;
         //
         if EditObjectDescId.Text <> ''
         then tmp:= ' AND Object.ValueData = ' + EditObjectDescId.Text
         else tmp:= '';
         //
         Add('select Id, ValueData AS FormName FROM Object WHERE Object.DescId = zc_Object_Form() ' + tmp + ' order by Id Desc');
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
         AddToMemoMsg('Form Count : ' + IntToStr (RecordCount), FALSE);
         //
         while not EOF  do
         begin
              //!!!
              if fStop then begin exit;end;
              //
              fOpenSqFromQuery_two ('SELECT gpGet_Object_Form AS FormValue FROM gpGet_Object_Form (' + ConvertFromVarChar(FieldByName('FormName').AsString) + ', CAST (NULL AS TVarChar))');
              //
              lFormData:= fromSqlQuery_two.FieldByName('FormValue').AsString;
              //
              if FieldByName('FormName').AsString <> '' then
              begin
                  // !!!����� StoredProc!!!
                  resStr:= fExecForm_repl_to (FieldByName('FormName').AsString, lFormData);
                  if resStr <> '' then
                  begin
                      // ERROR
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (' ..... ERROR .....', FALSE);
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (FieldByName('FormName').AsString, FALSE);
                      AddToMemoMsg ('', FALSE);
                      AddToMemoMsg (resStr, TRUE);
                      AddToMemoMsg ('', FALSE);
                  end;
                  //
                  // !!!��������� - � ����!!!
                  AddToLog(FieldByName('FormName').AsString, 'FormData', lGUID, false);
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
function TMainForm.pSendAllTo_ReplProc : Boolean;
//Main:  ���������� - ������
//Child: ���������� - !�� ������! - !����� �-��� ����� ��������� ������ ����� spExecSql!
var lGUID, lProcText, tmp : String;
    resStr : String;
begin
    Result:= false;
    //
    //
    lGUID:= GenerateGUID (TRUE);
    //
    // ������������ � ������� Main - �����������
    if not IniConnection_Main (TRUE) then exit;
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
         Add('select p.oid, p.ProName from pg_proc AS p join pg_namespace AS n on n.oid = p.pronamespace where n.nspname = ' + ConvertFromVarChar('public') + ' and p.oid > ' + IntToStr(ArrayReplServer[1].OID_last) + tmp + ' order by p.oid desc');
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
                  //resStr:= fExecSql_repl_to (lProcText);
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
function TMainForm.fMovement_andProperty_while (isFromMain : Boolean) : Boolean;
var StartId, EndId : Integer;
    num : Integer;
begin
     Result:= false;
     //
     // ��������� ������ ��� Id - Movement...
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
          if not pOpen_ReplMovement (isFromMain, FALSE, num, StartId, EndId, FALSE) then exit;
          //
          // ���� ������ �������� - !!!�����!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //������ ������ �� ��������� ������� � ��������� ������ � ����-To
          if not pSendPackTo_ReplMovement(isFromMain, num, outCountPack, FALSE)
          then exit;
          //MovementString - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) or (isFromMain = FALSE)
          then if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(MSCDS), FALSE) then exit else
          else if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(fQueryMS), FALSE) then exit else;
          //MovementFloat - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) or (isFromMain = FALSE)
          then if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(MFCDS), FALSE) then exit else
          else if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(fQueryMF), FALSE) then exit else;
          //MovementDate - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) or (isFromMain = FALSE)
          then if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(MDCDS), FALSE) then exit else
          else if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(fQueryMD), FALSE) then exit else;
          //MovementBoolean - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) or (isFromMain = FALSE)
          then if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(MBCDS), FALSE) then exit else
          else if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(fQueryMB), FALSE) then exit else;
          //MovementLinkObject - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) or (isFromMain = FALSE)
          then if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(MLOCDS), FALSE) then exit else
          else if not pSendPackTo_ReplMovementProperty(isFromMain, num, outCountPack, TClientDataSet(fQueryMLO), FALSE) then exit else;
          //
          // ��������� ������ ��� Id
          StartId:= EndId + 1;
          EndId  := StartId + outCountIteration;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fMovementLinkM_while (isFromMain : Boolean) : Boolean;
var StartId, EndId : Integer;
    num : Integer;
begin
     Result:= false;
     //
     // ��������� ������ ��� Id - Movement...
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
          if not pOpen_ReplMovement (isFromMain, TRUE, num, StartId, EndId, FALSE) then exit;
          //
          // ���� ������ �������� - !!!�����!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //MovementLinkMovement - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) or (isFromMain = FALSE)
          then if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(MLMCDS), FALSE) then exit else
          else if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(fQueryMLM), FALSE) then exit else;
          //
          // ��������� ������ ��� Id
          StartId:= EndId + 1;
          EndId  := StartId + outCountIteration;
     end;
     //
     Result:= true;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fMovementItem_andProperty_while (isFromMain : Boolean) : Boolean;
var StartId, EndId : Integer;
    num : Integer;
begin
     Result:= false;
     //
     // ��������� ������ ��� Id - Movement...
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
          if not pOpen_ReplMovement (isFromMain, FALSE, num, StartId, EndId, TRUE) then exit;
          //
          // ���� ������ �������� - !!!�����!!!
          if cbOnlyOpen.Checked = TRUE then exit;
          //
          //������ ������ �� ��������� ������� � ��������� ������ � ����-To
          if not pSendPackTo_ReplMovement(isFromMain, num, outCountPack, TRUE)
          then exit;
          //MovementItemString - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) OR (isFromMain= FALSE)
          then if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(MSCDS), TRUE) then exit else
          else if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(fQueryMS), TRUE) then exit else;
          //MovementItemFloat - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) OR (isFromMain= FALSE)
          then if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(MFCDS), TRUE) then exit else
          else if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(fQueryMF), TRUE) then exit else;
          //MovementItemDate - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) OR (isFromMain= FALSE)
          then if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(MDCDS), TRUE) then exit else
          else if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(fQueryMD), TRUE) then exit else;
          //MovementItemBoolean - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) OR (isFromMain= FALSE)
          then if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(MBCDS), TRUE) then exit else
          else if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(fQueryMB), TRUE) then exit else;
          //MovementItemLinkObject - �� ��������� ������� � ...
          if (cbClientDataSet.Checked = TRUE) OR (isFromMain= FALSE)
          then if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(MLOCDS), TRUE) then exit else
          else if not pSendPackTo_ReplMovementProperty (isFromMain, num, outCountPack, TClientDataSet(fQueryMLO), TRUE) then exit else;
          //
          // ��������� ������ ��� Id
          StartId:= EndId + 1;
          EndId  := StartId + outCountIteration;
     end;
     //
     Result:= true;
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
function TMainForm.pSendAllTo_ReplMovement_fromChild : Boolean;
//Main: ���������� - ������
begin
  //
  try
     Result:= false;
     //
     // ������������� ��� ������ �� ������� From
     if not pInsert_ReplMovement_fromChild then exit;
     //
     //
     // �������� �����
     EditCountObject.Text          := IntToStr(outCount)       + ' / ' + IntToStr(outCountHistory);
     EditCountStringObject.Text    := IntToStr(outCountString) + ' / ' + IntToStr(outCountHistoryString);
     EditCountFloatObject.Text     := IntToStr(outCountFloat)  + ' / ' + IntToStr(outCountHistoryFloat);
     EditCountDateObject.Text      := IntToStr(outCountDate)   + ' / ' + IntToStr(outCountHistoryDate);
     EditCountBooleanObject.Text   := IntToStr(outCountBoolean)+ ' / ' + IntToStr(outCountHistoryBoolean);
     EditCountLinkObject.Text      := IntToStr(outCountLink)   + ' * ' + IntToStr(outCountLinkM) + ' / ' + IntToStr(outCountHistoryLink);

     EditMinIdObject.Text          := IntToStr(outMinId);
     EditMaxIdObject.Text          := IntToStr(outMaxId);
     EditCountIterationObject.Text := IntToStr(outCountIteration) + ' / ' + IntToStr(outCountPack);

     Gauge.Progress:=0;
     Gauge.MaxValue:= 0;
     Gauge.MaxValue:= Gauge.MaxValue + outCount + outCountString + outCountFloat
                                     + outCountDate + outCountBoolean + outCountLink + outCountLinkM
                                     + outCountHistory + outCountHistoryString + outCountHistoryFloat
                                     + outCountHistoryDate + outCountHistoryBoolean + outCountHistoryLink
                                     ;
     //
     if cbMovement.Checked = TRUE then
     begin
         // ��������� �� Child ��� Movement + Property
         if not fMovement_andProperty_while (FALSE) then exit;
         //
         // ��������� �� Child ��� MovementLinkMovement
         if not fMovementLinkM_while (FALSE) then exit;
     end;
     //
     if cbMI.Checked = TRUE then
     begin
         // ��������� �� Child ��� MovementItem + Property
         if not fMovementItem_andProperty_while (FALSE) then exit;
     end;
     //
     //
     AddToMemoMsg(' ....................', FALSE);
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' ... end Movement', FALSE);
     //
     Result:= true;

  finally
      if (cbOnlyOpen.Checked = FALSE) and (fStop = FALSE) then
      begin
         fQueryMovement.Close;
         fQueryMS.Close;
         fQueryMF.Close;
         fQueryMD.Close;
         fQueryMB.Close;
         fQueryMLO.Close;
         fQueryMLM.Close;
         //
         MovementCDS.Close;
         MSCDS.Close;
         MFCDS.Close;
         MDCDS.Close;
         MBCDS.Close;
         MLOCDS.Close;
         MLMCDS.Close;
      end;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pSendAllTo_ReplMovement : Boolean;
//Child: ���������� - ������ - ����� load-Desc-list
begin
  //
  try
     Result:= false;
     //
     // ������������� ��� ������ �� ������� Main
     if not pInsert_ReplMovement then exit;
     //
     // ������������ � ������� Child + ������� - �������� ��� Desc-�� (����� ������ ���)
     if not IniConnection_Child ('load-Desc-list', TRUE) then exit;
     //
     // �������� �����
     EditCountObject.Text          := IntToStr(outCount)       + ' / ' + IntToStr(outCountHistory);
     EditCountStringObject.Text    := IntToStr(outCountString) + ' / ' + IntToStr(outCountHistoryString);
     EditCountFloatObject.Text     := IntToStr(outCountFloat)  + ' / ' + IntToStr(outCountHistoryFloat);
     EditCountDateObject.Text      := IntToStr(outCountDate)   + ' / ' + IntToStr(outCountHistoryDate);
     EditCountBooleanObject.Text   := IntToStr(outCountBoolean)+ ' / ' + IntToStr(outCountHistoryBoolean);
     EditCountLinkObject.Text      := IntToStr(outCountLink)   + ' * ' + IntToStr(outCountLinkM) + ' / ' + IntToStr(outCountHistoryLink);

     EditMinIdObject.Text          := IntToStr(outMinId);
     EditMaxIdObject.Text          := IntToStr(outMaxId);
     EditCountIterationObject.Text := IntToStr(outCountIteration) + ' / ' + IntToStr(outCountPack);

     Gauge.Progress:=0;
     Gauge.MaxValue:= 0;
     Gauge.MaxValue:= Gauge.MaxValue + outCount + outCountString + outCountFloat
                                     + outCountDate + outCountBoolean + outCountLink + outCountLinkM
                                     + outCountHistory + outCountHistoryString + outCountHistoryFloat
                                     + outCountHistoryDate + outCountHistoryBoolean + outCountHistoryLink
                                     ;
     //
     if cbMovement.Checked = TRUE then
     begin
         // ��������� �� Main ��� Movement + Property
         if not fMovement_andProperty_while (TRUE) then exit;
         //
         // ��������� �� Main ��� MovementLinkMovement
         if not fMovementLinkM_while (TRUE) then exit;
     end;
     //
     if cbMI.Checked = TRUE then
     begin
         // ��������� �� Main ��� MovementItem + Property
         if not fMovementItem_andProperty_while (TRUE) then exit;
     end;
     //
     //
     AddToMemoMsg(' ....................', FALSE);
     AddToMemoMsg(MainForm.FormatFromDateTime_folder(now) + ' ... end Movement', FALSE);
     //
     Result:= true;

  finally
      if (cbOnlyOpen.Checked = FALSE) and (fStop = FALSE) then
      begin
         fQueryMovement.Close;
         fQueryMS.Close;
         fQueryMF.Close;
         fQueryMD.Close;
         fQueryMB.Close;
         fQueryMLO.Close;
         fQueryMLM.Close;
         //
         MovementCDS.Close;
         MSCDS.Close;
         MFCDS.Close;
         MDCDS.Close;
         MBCDS.Close;
         MLOCDS.Close;
         MLMCDS.Close;
      end;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.pSendAllTo_ReplObject : Boolean;
//Child: ���������� - ������ - ����� load-Desc-list
begin
  try
     Result:= false;
     //
     // ������������� ��� ������ �� ������� Main
     if not pInsert_ReplObject then exit;
     //
     // ������������ � ������� Child + ������� - �������� ��� Desc-�� (����� ������ ���)
     if not IniConnection_Child ('load-Desc-list', TRUE) then exit;
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
function TMainForm.pBegin_All (isFromMain, isFromChild: Boolean) : Boolean;
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
         btnOKMain_toChild.Enabled:=false;
         btnOKChild_toMain.Enabled:=false;
         Gauge.Visible:=true;
         Gauge.Progress:= 0;
         //
         CursorGridChange;
         //
         MemoMsg.Lines.Clear;
         //
         if (cbForms.Checked = TRUE) and (isFromMain = TRUE)
         then
             // ��������� Forms
             pSendAllTo_Forms;
         //
         if (cbProc.Checked = TRUE) and (isFromMain = TRUE)
         then
             // ��������� Proc
             pSendAllTo_ReplProc;
         //
         if (cbDesc.Checked = TRUE) and (isFromMain = TRUE)
         then
             // ��������� Desc
             pSendAllTo_ReplObjectDesc;

         //
         if ((cbObject.Checked = TRUE) or (cbObjectHistory.Checked = TRUE)) and (isFromMain = TRUE)
         then
             // ��������� Object - Data
             pSendAllTo_ReplObject;

         if ((cbMovement.Checked = TRUE) or (cbMI.Checked = TRUE)) and (isFromMain = TRUE)
         then
             // ��������� Movement - Data
             pSendAllTo_ReplMovement;

         if ((cbMovement.Checked = TRUE) or (cbMI.Checked = TRUE)) and (isFromChild = TRUE)
         then
             // ��������� Movement - Data
             pSendAllTo_ReplMovement_fromChild;

     finally
           Result:= fStop;
           //
           fBegin_All := FALSE;
           //
           fStop:=true;
           //
           btnOKMain_toChild.Enabled:=true;
           btnOKChild_toMain.Enabled:=true;
           Gauge.Visible:=false;
           //
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.btnOKChild_toMainClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
    lResStop: Boolean;
begin
     if MessageDlg('������������� ��������� ������ � Main?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     //
     //
     tmpDate1:=NOw;
     //
     //
     lResStop:= pBegin_All(FALSE, TRUE);
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
         then ShowMessage('������ � Main �� ���������. Time = ('+StrTime+').')
         else ShowMessage('������ � Main ���������. Time = ('+StrTime+').') ;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.btnOKMain_toChildClick(Sender: TObject);
var tmpDate1,tmpDate2:TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    StrTime:String;
    lResStop: Boolean;
begin
     if MessageDlg('������������� ��������� ������ � Child?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
     //
     //
     tmpDate1:=NOw;
     //
     //
     lResStop:= pBegin_All(TRUE,FALSE);
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
         then ShowMessage('������ � Child �� ���������. Time = ('+StrTime+').')
         else ShowMessage('������ � Child ���������. Time = ('+StrTime+').') ;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

end.


