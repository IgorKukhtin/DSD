unit FMX.CommonData;

//  В модуле хранятся глобальные переменные ддя приложения
interface
uses FMX.Authentication,
     {$IFDEF MSWINDOWS}
     WinApi.Messages,
     {$ENDIF}
     System.Classes;

const
  gc_ReadOnlyProcsCount = 14;
  gc_ReadOnlyProcs: array[1..gc_ReadOnlyProcsCount] of string = (
    'gpSelectMobile_Object_Contract',
    'gpSelectMobile_Object_Goods',
    'gpSelectMobile_Object_GoodsByGoodsKind',
    'gpSelectMobile_Object_GoodsGroup',
    'gpSelectMobile_Object_GoodsKind',
    'gpSelectMobile_Object_GoodsListSale',
    'gpSelectMobile_Object_Juridical',
    'gpSelectMobile_Object_JuridicalGroup',
    'gpSelectMobile_Object_Measure',
    'gpSelectMobile_Object_Partner',
    'gpSelectMobile_Object_PriceList',
    'gpSelectMobile_Object_PriceListItems',
    'gpSelectMobile_Object_Route',
    'gpSelectMobile_Object_TradeMark'
  );

var
  gc_User: TUser;  // Пользователь, под которым зашли в программу
  gc_ProgramName: String = 'ProjectMobile.exe'; // Название программы
  gc_WebServers: TArray<string>;
  gc_WebServers_r: TArray<string>;
  gc_WebService: String = '';
  gc_allowLocalConnection: Boolean = False;
  gc_StartParams: TStringList;

{$IFDEF MSWINDOWS}
CONST
  UM_THREAD_EXCEPTION = WM_USER + 101;
  UM_LOCAL_CONNECTION = WM_USER + 102;
  UM_INSERTRECORD = WM_USER + 103;
  UM_EDITRECORD = WM_USER + 104;
  UM_DELETERECORD = WM_USER + 105;
  UM_SAVEANDCLOSE = WM_USER + 106;
  UM_CANCEL = WM_USER + 107;
  UM_MDICREATE = WM_USER + 108;
  UM_MDIDESTROY = WM_USER + 109;
  UM_MDIACTIVATE = WM_USER + 110;
  UM_MDIDEACTIVATE = WM_USER + 111;
{$ENDIF}

function CheckReadOnlyProcs(AData: string): Boolean;

implementation

var
  i: Integer;

function CheckReadOnlyProcs(AData: string): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 1 to gc_ReadOnlyProcsCount do
    if Pos(gc_ReadOnlyProcs[I], AData) <> 0 then
    begin
      Result := True;
      Break;
    end;
end;

initialization
   gc_StartParams := TStringList.Create;
   for I := 1 to ParamCount do
     gc_StartParams.Add(ParamStr(I));
finalization
  gc_StartParams.Free;
end.

