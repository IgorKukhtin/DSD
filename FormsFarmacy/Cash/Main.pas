unit Main;                                 

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  G_111, Wwintl, Wwfltdlg, DBTables, wwstorep, GCtrls, Db, Wwdatsrc,
  Wwquery, Menus, RxMenus, rxPlacemnt, StdCtrls, Wwkeycb, Grids, Wwdbigrd,
  Wwdbgrid, ExtCtrls, rxSpeedBar, RXCtrls, Buttons, Mask, rxToolEdit, rxCurrEdit,
  wwdblook, DMProject, DMMain, Wwtable, DBGrids, ActnList,
  wwDialog, ComCtrls, RxLogin, rxDBFilter, CashInterface, PropFilerEh, ADODB,
  PropStorageEh, Datasnap.Provider, Datasnap.DBClient, QExport4, QExport4XLS,
  QExport4Dialog;
const
  WM_SetActive = WM_User + 1;
type
  TSoldWithCompMainForm = class(TAnsestorGrid_111_Form)
    Panel: TPanel;
    CheckDataSource: TwwDataSource;
    CheckGrid: TwwDBGrid;
    gbSaler: TGroupBox;
    gbDiscount: TGroupBox;
    IncrementalSearchCheck: TwwIncrementalSearch;
    RxLabel3: TRxLabel;
    RxLabel4: TRxLabel;
    ceCode: TCurrencyEdit;
    ceSalerName: TComboEdit;
    spBillCheck: TwwStoredProc;
    RxLabel2: TRxLabel;
    rlSumm: TRxLabel;
    rlDiscountCode: TRxLabel;
    ceDiscountCode: TCurrencyEdit;
    rlDiscountName: TRxLabel;
    ceDiscount: TComboEdit;
    rlDiscountSize: TRxLabel;
    rlSize: TRxLabel;
    Bevel1: TBevel;
    RxLabel1: TRxLabel;
    rlGiveSaler: TRxLabel;
    RxLabel6: TRxLabel;
    rlSdacha: TRxLabel;
    ButtonPanel: TPanel;
    rxCode: TRxLabel;
    rxCount: TRxLabel;
    ceCount: TCurrencyEdit;
    CodeSearchs: TEdit;
    CheckQuery: TwwQuery;
    CheckQuery1Code: TIntegerField;
    CheckQuery1FullName: TStringField;
    CheckQuery1OperCount: TFloatField;
    CheckQuery1OperPrice: TFloatField;
    CheckQuery1OperSumm: TFloatField;
    CheckQuery1ID: TIntegerField;
    CheckQuery1CashName: TStringField;
    CheckQuery1NDS: TFloatField;
    CheckQuery1GoodsPropertyID: TIntegerField;
    SpeedbarSection1: TSpeedbarSection;
    siSold: TSpeedItem;
    miSold: TMenuItem;
    siSoldAll: TSpeedItem;
    siClearAll: TSpeedItem;
    miSoldAll: TMenuItem;
    miClearAll: TMenuItem;
    siAllMoney: TSpeedItem;
    miMoneyinCash: TMenuItem;
    rlMoneyInCash: TRxLabel;
    miMoneyHide: TMenuItem;
    cbQuite: TCheckBox;
    siDiscount: TSpeedItem;
    siSalers: TSpeedItem;
    btCreateBill: TButton;
    siNTS: TSpeedItem;
    rlOplat: TRxLabel;
    Button1: TButton;
    RxLoginDialog: TRxLoginDialog;
    actUsers: TAction;
    btCheck: TButton;
    GuideCheck: TGuide;
    siCashWork: TSpeedItem;
    N1: TMenuItem;
    N2: TMenuItem;
    actRegimVosstanovleniy: TAction;
    N3: TMenuItem;
    spInsertUpdateGoodsPropertyNTZ: TStoredProc;
    lcName: TwwIncrementalSearch;
    DataSetProvider: TDataSetProvider;
    NewQuery: TClientDataSet;
    NewQuerySendCount: TFloatField;
    NewQueryCode: TIntegerField;
    Button2: TButton;
    miPutOff: TMenuItem;
    NewQueryOperCount: TFloatField;
    Button3: TButton;
    cbSpec: TCheckBox;
    Button4: TButton;
    miVIPCheck: TMenuItem;
    AlternativeGrid: TwwDBGrid;
    AlternativeQuery: TwwQuery;
    AlternativeQueryGoodsName: TStringField;
    AlternativeQueryCode: TIntegerField;
    AlternativeQueryGoodsPropertyId: TIntegerField;
    AlternativeDSP: TDataSetProvider;
    AlternativeCDS: TClientDataSet;
    AlternativeCDSCode: TIntegerField;
    AlternativeCDSGoodsName: TStringField;
    AlternativeCDSGoodsPropertyId: TIntegerField;
    AlternativeDS: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CheckQueryBeforeClose(DataSet: TDataSet);
    procedure GuideCheckUserCalcGridTitleAtributes(Sender: TObject;
      AFieldName: String; AFont: TFont; ABrush: TBrush;
      var ATitleAlignment: TAlignment);
    procedure FormCreate(Sender: TObject);
    procedure ceCodeChange(Sender: TObject);
    procedure ceSalerNameButtonClick(Sender: TObject);
    procedure CodeSearchAfterSearch(Sender: TwwIncrementalSearch;
      MatchFound: Boolean);
    procedure FormShow(Sender: TObject);
    procedure CodeSearchsKeyPress(Sender: TObject; var Key: Char);
    procedure GridEnter(Sender: TObject);
    procedure GridExit(Sender: TObject);
    procedure CodeSearchsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CodeSearchsEnter(Sender: TObject);
    procedure ceCountExit(Sender: TObject);
    procedure bbSendCheckClick(Sender: TObject);
    procedure bbClearCheckClick(Sender: TObject);
    procedure GridCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GuideControlUserGridDblCkick(Sender: TObject;
      var AValue: Boolean);
    procedure GuideCheckUserGridDblCkick(Sender: TObject;
      var AValue: Boolean);
    procedure ButtonClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ceDiscountCodeChange(Sender: TObject);
    procedure ceDiscountButtonClick(Sender: TObject);
    procedure NewQueryBeforeClose(DataSet: TDataSet);
    procedure NewQueryAfterOpen(DataSet: TDataSet);
    procedure GuideControlUserGridKeyPress(Sender: TObject; var Key: Char);
    procedure RefreshItemClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miSoldClick(Sender: TObject);
    procedure miMoneyinCashClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure lcNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lcNameChange(Sender: TObject);
    procedure lcNameEnter(Sender: TObject);
    procedure RxLabel2Click(Sender: TObject);
    procedure miMoneyHideClick(Sender: TObject);
    procedure cbQuiteClick(Sender: TObject);
    procedure siDiscountClick(Sender: TObject);
    procedure siSalersClick(Sender: TObject);
    procedure NewQueryCalcFields(DataSet: TDataSet);
    procedure siNTSClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure lcNameKeyPress(Sender: TObject; var Key: Char);
    procedure lcNameExit(Sender: TObject);
    procedure RxLoginDialogCheckUser(Sender: TObject; const UserName,
      Password: String; var AllowLogin: Boolean);
    procedure actUsersExecute(Sender: TObject);
    procedure btCheckClick(Sender: TObject);
    procedure NewQueryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure quStoreRemainsAfterOpen(DataSet: TDataSet);
    procedure siCashWorkClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure actRegimVosstanovleniyExecute(Sender: TObject);
    procedure NewQueryBeforePost(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
    procedure GuideControlUserCalcGridTitleAtributes(Sender: TObject;
      AFieldName: string; AFont: TFont; ABrush: TBrush;
      var ATitleAlignment: TAlignment);
    procedure lcNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure miPutOffClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure GridColEnter(Sender: TObject);
    procedure miVIPCheckClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FTimer, fNameTimer: TTimer;
    OldIndexFieldNames,lastValue, lastGoodsValue: string;
    FirstCheckOpen: boolean;
    SalerID, UnitID: integer;
    PrepareCheckID, CashID: integer;
    isSold: boolean;
    ChildHandle: integer;
    finSoldRegim: boolean;
    SumOfCheck: real;
    fPercent: real;
    fTypePercent,TotalPercent: real;
    Cash: ICash;
    TotalDiscount: real; //Общая сумма скидки
    SoldParallel: boolean;
    SoldEightReg: boolean;
    fShowStoreRemains: boolean;
    FListStoreRemains: TStrings;
    FFilterRemains: TStringList;
    procedure WM_KEYDOWN(var Msg: TWMKEYDOWN); message WM_KEYDOWN;
    procedure UM_SetActive(var Message: TMessage); message WM_SetActive;
    procedure SetShowStoreRemains(Value: boolean);
    procedure UpdateDataSet(DataSet: TDataSet); override;
    procedure TotalPanelCaption;
    procedure SetPercent(AValue: real);
    procedure SetTypePercent(AValue: real);
    procedure SetSoldRegim(AValue: boolean);
    function Execute:boolean; override;
    procedure NewCheck;// процедура обновляет параметры для введения нового чека
    procedure CalcTotalSumm;// Пересчитали значение Суммы в TotalPanel
    function PutCheckToCash(Discount, SalerCash: real; PaidType: TPaidType): boolean;// Отбиваем чек через ЭККА
    procedure pKillDontEnterCheck;//удалить чеки не введенные в программу
    procedure PrepareTable(UnitId,CategoriesID: integer);// вызываем процедуру для записи в таблицу
    property inSoldRegim: boolean read finSoldRegim write SetSoldRegim;
    property Percent: real read fPercent write SetPercent;
    property TypePercent: real read fTypePercent write SetTypePercent;
    property ShowStoreRemains: boolean read fShowStoreRemains write SetShowStoreRemains;
    function CalcTotalDiscount(APercent: real): real;
    procedure OnNameEditTimerEvent(Sender: TObject);
  public
    SendToCashOnly: boolean;
    isStore: boolean;
  end;

var
  SoldWithCompMainForm: TSoldWithCompMainForm;
  SendFile: text;
  pApplicationFactory, pApplication, pSecurityContext: OleVariant;
  pWorkshopConfig: OleVariant;
  pXMLParser: OleVariant;

function MainForm: TSoldWithCompMainForm;

implementation
uses utils_TypeMess, UTILS_CompSave, rxAppUtils, SalerGuide, GCommon, ConstFromServer
     , BookKeeperRound,
     Utils_ConstDef, Utils_DBErrors, GuideUtilites, Utils_DB, CashUtilites, rxvclutils,
     CheckDialog, rxstrUtils, rxBdeUtils, Math, c_MathUtil, DiscountGuide, ComObj,
     VisibleFactoryUnit, Variants, a_GuidesBill, CashFactory, CashWork, CommonDataUnit,
     G_1, VIPDialog;
{$R *.DFM}
function MainForm: TSoldWithCompMainForm;
begin
  result := SoldWithCompMainForm
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.pKillDontEnterCheck;//удалить чеки не введенные в программу
var Params: TParams;
begin
  Params:=TParams.Create;
  ParamAddValue(Params,'@CashID',ftInteger,0);
  ExecStoredProc('MainDb','dba.pKillDontEnterCheck',Params);//удалить чеки не введенные в программу
end;

procedure TSoldWithCompMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  NewQuery.Close;
  CheckQuery.Close;
  inherited;
  pKillDontEnterCheck;//удалить чеки не введенные в программу
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try
    if (CheckQuery.Active) and (CheckQuery.RecordCount>0) then begin TypeShowMessage('Сначала обнулите чек',mtInformation,[],0); CanClose:=false; exit;end;
  except
  end;
  if TypeShowMessage('Вы действительно хотите выйти?',mtInformation,[mbYes,mbCancel], 0) = mrYes then
     CanClose:=true
  else
     CanClose:=false;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.SetShowStoreRemains(Value: boolean);
begin
  fShowStoreRemains:= Value;
  //btCreateBill.Visible:=Value;
  if Value then begin
    {StoreDatabase.AliasName:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'StoreRemainsDS','StoreDS');
    spFillRemains.ParamByName('@Date').asDateTime:=Date;
    spFillRemains.ParamByName('@UnitId').asString:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'StoreRemainsUnit','3');
  }end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.FormCreate(Sender: TObject);
begin
  SendToCashOnly:= false;
  FFilterRemains:=TStringList.Create;
  FListStoreRemains:= TStringList.Create;
  gbSaler.Visible:=GetDefaultValue_fromFile(ifDefaults,'Common','ShowSalerPanel','false')='true';
  gbDiscount.Visible:=GetDefaultValue_fromFile(ifDefaults,'Saler','ShowDiscPanel','false')='true';
  TotalPanel.Visible:=gbDiscount.Visible;
  SpeedBar.Visible:=gbDiscount.Visible;
  SoldParallel:=GetDefaultValue_fromFile(ifDefaults,'Common','SoldParallel','false')='true';
  Application.HelpFile:=GetDefaultValue_fromFile(ifDefaults,'Common','HelpFile','CompToCash.hlp');
  pKillDontEnterCheck;//удалить чеки не введенные в программу
  inherited;
  GuideCheck.IncSearchComponent:=IncrementalSearchCheck;
  fEditFieldList.Add('NTZ');
  fEditFieldList.Add('isReceipt');
//------------------------------------------------------------------------------
//       Установки по умолчанию
  SoldEightReg:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'EightReg','true')='true';

  Cash:=TCashFactory.GetCash(GetDefaultValue_fromFile(ifDefaults, Self.ClassName, 'CashType','FP3530T_NEW'));

  ceCount.Text:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'CheckCount','1');
  PrepareCheckID := 0;
  UnitID := -abs(StrToInt(GetDefaultValue_fromFile(ifDefaults,'Common','CurrentUnit','-2')));
  CashID := StrToInt(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'CashID','0'));
  Grid.Color:=StrToInt(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'GridColor','-2147483644'));
  CheckGrid.Color:=StrToInt(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'GridColor','-2147483644'));
  // Пауза между отпуском одного товара в ms

  isSold:=false;

  AssignFile(SendFile,'###.###');

  with NewQuery do begin
    TFloatField(FieldByName('RemainsCount')).DisplayFormat:=   _fmtCount;
    TFloatField(FieldByName('NTZ')).DisplayFormat:=   ',0.###; ; ';
    TFloatField(FieldByName('OperCount')).DisplayFormat:=   _fmtCountOper;
    TFloatField(FieldByName('LastPrice')).DisplayFormat:=      _fmtPrice;
  end;
  with CheckQuery do begin
    TFloatField(FieldByName('OperCount')).DisplayFormat:= _fmtCountOper;
    TFloatField(FieldByName('OperPrice')).DisplayFormat:= _fmtPrice;
    TFloatField(FieldByName('OperSumm')).DisplayFormat:=  _fmtPrice;
  end;

  Query.ParamByName('@UnitId').AsInteger := abs(UnitId);
  Query.ParamByName('@CategoriesId').AsInteger := StrToInt(GetDefaultValue_fromFile(ifOper,Self.ClassName,'CategoriesID','1'));

  NewCheck;// процедура обновляет параметры для введения нового чека

  FNameTimer:= TTimer.create(self);
  FNameTimer.enabled:= False;
  FNameTimer.Interval:= 333;
  FNameTimer.OnTimer:= OnNameEditTimerEvent;

  FTimer:= TTimer.create(self);
  FTimer.enabled:= False;
  FTimer.Interval:= 333;
//  FTimer.OnTimer:= OnEditTimerEv11ent;
//  NewQueryRemainsStore.Visible:=ShowStoreRemains;
  NewQuerySendCount.Visible:=false;
  cbQuite.Checked:=false;
  Cash.AlwaysSold:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'AlwaysSold','true')='true';
  Grid.OnKeyDown := GridKeyDown;
  NewQuery.Filtered := true;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.ceCodeChange(Sender: TObject);
begin
  with DataModuleProject.SalersTable do begin
    Refresh;
    if FindKey([round(ceCode.Value)]) then begin
       ceSalerName.Text:=FieldByName('SalerName').Text;
       SalerID:=FieldByName('ID').asInteger;
       try
         Percent:=StrToFloat(GetStringValue('MainDb',ReplaceStr('select DiscountPercent as ReturnValue from dba.Discount where'+
         ' DiscountType=0 and MinValue='+
         '(select max(MinValue) from dba.Discount where DiscountType=0 and MinValue<'+
         FieldByName('SaleSumm').AsString+')',DecimalSeparator,DataBase_DecimalSeparator)));
       except
         Percent:=0;
       end;
       rlSumm.Caption:='Ранее куплено на '+FormatFloat(_fmtBookKeeper,FieldByName('SaleSumm').asFloat)+
       '  Скидка '+FormatFloat(_fmtPercent,Percent);
    end
    else begin
       ceSalerName.Text:='';
       SalerId:=0;
       rlSumm.Caption:='';
       Percent:=0;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.ceSalerNameButtonClick(Sender: TObject);
var Params: TParams;
begin
  Params:=ExecuteGuide_voNonDeleted(TSalerGuidesGridForm,'ID',IntToStr(SalerID));
  if Params=nil then exit;
  with Params do begin
     SalerID:=ParamByName('ID').asInteger;
     ceCode.Value:=ParamByName('Code').asInteger;
     ceSalerName.Text:=ParamByName('SalerName').Text;
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.CodeSearchAfterSearch(
  Sender: TwwIncrementalSearch; MatchFound: Boolean);
begin
  with NewQuery do begin
    IndexFieldNames:=OldIndexFieldNames;
    EnableControls;
  //  Resync([rmCenter]); // если нашли, то поставаили по центру
  end;
  with Sender do begin
     if trim(Text)='' then begin
        ceCount.Enabled:=false;
        exit;
     end;
     IncrementalSearchCheck.Text:=Text;
     IncrementalSearchCheck.FindValue;
     if inSoldRegim then
        if (Text=DataSource.DataSet.FieldByName(SearchField).Text) then begin
           ceCount.Enabled:=true;
           Grid.Options:=Grid.Options+[wwdbigrd.dgAlwaysShowSelection];
           //Query.Resync([rmCenter]); // если нашли, то поставаили по центру
        end
        else begin
           Grid.Options:=Grid.Options-[wwdbigrd.dgAlwaysShowSelection];
           ceCount.Enabled:=false;
        end
     else
        if (Text=CheckQuery.FieldByName('Code').Text) then begin
           ceCount.Enabled:=true;
           CheckGrid.Options:=CheckGrid.Options+[wwdbigrd.dgAlwaysShowSelection];
           //Query.Resync([rmCenter]); // если нашли, то поставаили по центру
        end
        else begin
           CheckGrid.Options:=CheckGrid.Options-[wwdbigrd.dgAlwaysShowSelection];
           ceCount.Enabled:=false;
        end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.CodeSearchsKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',Char(VK_BACK)]) then Key:=#0
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.GridEnter(Sender: TObject);
begin
  with TwwDBGrid(Sender) do begin
     Color:=clWindow;
     Options:=Options-[wwdbigrd.dgRowSelect];
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.GridExit(Sender: TObject);
begin
  with TwwDBGrid(Sender) do begin
     Color:=StrToInt(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'GridColor','-2147483644'));;
     Options:=Options+[wwdbigrd.dgRowSelect];
     Options:=Options-[wwdbigrd.dgAlwaysShowSelection];
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.CodeSearchsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_Return) and (ceCount.Enabled) then begin
     ceCount.Text:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'CheckCount','1');
     if inSoldRegim then ceCount.Value:=abs(ceCount.Value)
     else ceCount.Value:=-abs(ceCount.Value);
     ActiveControl:=ceCount;
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.TotalPanelCaption;
begin
   TotalDiscount:=CalcTotalDiscount(TotalPercent);
   rlOplat.Caption:='К оплате: '+FormatFloat(_fmtBookKeeper,SumOfCheck-TotalDiscount);
   rlTotalSummCategories.Caption:=
     'Итого: '+FormatFloat(_fmtBookKeeper,SumOfCheck)+
     ';  Скидка: '+FormatFloat(_fmtPercent,TotalPercent)+
     ';  Сумма скидки: '+FormatFloat(_fmtBookKeeper,TotalDiscount)+
     ';  К оплате: '+FormatFloat(_fmtBookKeeper,SumOfCheck-TotalDiscount);
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.CalcTotalSumm;// Пересчитали значение Суммы в TotalPanel
var B: TBookmark;
    Summ: real;
begin
   with CheckQuery do begin
     if not Active then exit;
     try
        DisableControls;
        B:=GetBookmark; First; Summ:=0;
        while not EOF do begin
          Summ:=Summ+FieldByName('OperSumm').asFloat;
          Next;
        end;
        SumOfCheck:=Summ;
     finally
        TotalPanelCaption;
        EnableControls;
        GotoBookmark(B);
        FreeBookmark(B);
     end;
   end;
   TotalDiscount:=CalcTotalDiscount(TotalPercent);
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.SetPercent(AValue: real);
begin
   fPercent:=AValue;
   TotalPercent:=fPercent+TypePercent;
   TotalPanelCaption;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.SetTypePercent(AValue: real);
begin
   fTypePercent:=AValue;
   TotalPercent:=Percent+fTypePercent;
   TotalPanelCaption;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.CodeSearchsEnter(Sender: TObject);
begin
  lcName.Text:='';
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.ceCountExit(Sender: TObject);
begin
  ceCount.Enabled:=false;
  ceCount.Text:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'CheckCount','1');
end;
{------------------------------------------------------------------------------}
function TSoldWithCompMainForm.PutCheckToCash(Discount, SalerCash: real; PaidType: TPaidType): boolean;// Отбиваем чек через ЭККА
{------------------------------------------------------------------------------}
  function PutOneRecordToCash: boolean; //Продажа одного наименования
  begin
     // посылаем строку в кассу и если все OK, то ставим метку о продаже
     if Cash.AlwaysSold then
        result := true
     else
       if not SoldParallel then
         with CheckQuery do
            result := Cash.SoldFromPC(CheckQuery.FieldByName('Code').asInteger, AnsiUpperCase(CheckQuery.FieldByName('FullName').Text),
                          FieldByName('OperCount').asFloat,
                          f_BookKeeperPercentRound(FieldByName('OperPrice').asFloat,TotalPercent),
                          FieldByName('NDS').asFloat)
       else result:=true;
  end;
{------------------------------------------------------------------------------}
begin
  result:=true;
  try
  ceCode.Enabled:=false;
  ceSalerName.Enabled:=false;
  result := Cash.AlwaysSold or Cash.OpenReceipt;
//  if SalerID<>0 then ExecuteQuery('MainDB','update dba.BillCheck set ToID='+IntTostr(SalerID)+' where ID='+IntToStr(BillCheckID));
  with CheckQuery do begin
       Close;Open;First;
       while not EOF do begin
          if result then begin
             result := PutOneRecordToCash;//послали строку в кассу
          end;
          Next;
       end;
     if not Cash.AlwaysSold then begin
        Cash.SubTotal(true, true, 0, 0);
        Cash.TotalSumm(SalerCash, PaidType);
        result := Cash.CloseReceipt; //Закрыли чек
     end;

  end;
  except
    result := false;
    raise;
  end;
//  if Result then
  //   ExecuteQuery('MainDb', 'update dba.BillCheck set BillTime=now(*) where ID='+IntToStr(BillCheckID));
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.bbSendCheckClick(Sender: TObject);
var ASalerCash,ASdacha: real;
    PaidType: TPaidType;
begin
  PaidType:=ptMoney;
  if (CheckQuery.RecordCount>0)
    //and (TypeShowMessage('Вы уверены в посылке чека?',mtInformation,[mbYes,mbNo],0)=mrYes)
    then begin
    if not fShift then begin// если с Shift, то считаем, что дали без сдачи
       with TCheckDialogForm.Create(nil) do
            if not Execute(PrepareCheckID, SumOfCheck - TotalDiscount, ASalerCash, ASdacha, PaidType) then begin
               if Self.ActiveControl <> Self.ceCount then
                  Self.ActiveControl := Self.Grid;
               exit;
            end;
            Self.ActiveControl := Self.Grid;
    end
    else begin
       ASalerCash:=SumOfCheck-TotalDiscount;ASdacha:=0;
    end;
    rlGiveSaler.Caption:=FormatFloat(_fmtBookKeeper,ASalerCash);
    rlSdacha.Caption:=FormatFloat(_fmtBookKeeper,ASdacha);
    // Отбиваем чек через ЭККА
    if PutCheckToCash(TotalDiscount, ASalerCash, PaidType) then begin
       // Сохраняем чек в базе
       ExecuteQuery('MainDb', 'CALL PrepareCheckToBillCheck(' + IntToStr(PrepareCheckID) + ',' +
          Query.ParamByName('@UnitId').AsString + ', ' + IntToStr(byte(cbSpec.Checked)) + ' )');
       NewCheck;// процедура обновляет параметры для введения нового чека
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.bbClearCheckClick(Sender: TObject);
begin
  NewQuery.DisableControls;
  with CheckQuery do begin
     if RecordCount=0 then exit;
     DisableControls;
     First;
     while not EOF do begin
{       with spInsertUpdate do begin
          ParamByName('@BillCheckID').asInteger:=BillCheckID;
          ParamByName('@OperCount').asFloat:=-abs(CheckQuery.FieldByName('OperCount').asFloat);
          ParamByName('@OperPrice').asFloat:=CheckQuery.FieldByName('OperPrice').asFloat;
          ParamByName('@GoodsCardItemsId').asInteger:=CheckQuery.FieldByName('GoodsCardItemsID').asInteger;
          ParamByName('@GoodsPropertyID').asInteger:=CheckQuery.FieldByName('GoodsPropertyID').asInteger;
          try
            ExecProc;
            UpdateQuantityInQuery(ParamByName('@GoodsCardItemsId').asInteger);
          except
            on E:EDBEngineError do EDB_EngineErrorMsg(E);
          end;
       end; }
       Next;
     end;
     EnableControls;
  end;
  NewCheck;// процедура обновляет параметры для введения нового чека
  NewQuery.EnableControls;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.GridCalcCellColors(Sender: TObject; Field: TField;
  State: TGridDrawState; Highlight: Boolean; AFont: TFont; ABrush: TBrush);
begin
  if (Field.FieldName='RemainsCount') or (Field.FieldName='RemainsStore') then begin
     ABrush.Color:=def_clRemainColumnColor;
     AFont.Style:=AFont.Style+[fsBold];
  end;
  inherited;
end;

{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key=VK_Tab) and (ActiveControl=CheckGrid) then ActiveControl:=lcName;
  if (Key=VK_ADD) or ((Key=VK_RETURN) and (ssShift in Shift)) then begin
     if ssShift in Shift then fShift:=true;
     bbSendCheckClick(Sender);
     fShift:=false;
     Application.ProcessMessages;
  end;
  if (Key=VK_SUBTRACT) then begin
     if (ssAlt in Shift) then
        bbClearCheckClick(Sender)
//     else
  //      miPutOffClick(Sender);
  end;
end;

{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.GuideCheckUserGridDblCkick(Sender: TObject;
  var AValue: Boolean);
begin
  inherited;
  if CheckQuery.RecordCount>0 then begin
     lcName.Text:=CheckQuery.fieldByName('FullName').Text;
     ceCount.Value:=-CheckQuery.fieldByName('OperCount').asFloat;
     ceCount.Enabled:=true;
     inSoldRegim:=false;
     ActiveControl:=ceCount;
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.ceDiscountCodeChange(Sender: TObject);
begin
  with DataModuleProject.DiscountTable do begin
    Refresh;
    if FindKey([round(ceDiscountCode.Value)]) then begin
       TypePercent:=FieldByName('DiscountPercent').AsFloat;
       ceDiscount.Text:=fieldByName('DiscountName').AsString;
       rlSize.Caption:=FormatFloat(_fmtPercent,TypePercent)
    end
    else begin
       TypePercent:=0;
       ceDiscount.Text:='';
       rlSize.Caption:='';
    end;
  end;
end;
{------------------------------------------------------------------------------}
function  TSoldWithCompMainForm.CalcTotalDiscount(APercent: real): real;
var B: TBookmark;
begin
  with CheckQuery do begin
     if not Active then Exit;
     B:=GetBookmark;
     DisableControls;
     try
       First; Result:=0;
       while not EOF do begin
         Result := Result+FieldbyName('OperCount').AsFloat * FieldByName('OperPrice').AsFloat-FieldbyName('OperCount').AsFloat*f_BookKeeperPercentRound(FieldByName('OperPrice').AsFloat,APercent);
         Next;
       end;
     finally
       GotoBookmark(B);
       FreeBookmark(B);
       EnableControls;
     end;
  end
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.GuideControlUserGridKeyPress(
  Sender: TObject; var Key: Char);
begin
  if (Grid.GetActiveField.FieldName='FullName') and (IncrementalSearch.Text='')
     then key:=Key;//key:=AnsiUpperCase(Key)[1];
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.RefreshItemClick(Sender: TObject);
begin
  if ShowStoreRemains then begin
     {spFillRemains.ExecProc;
     quStoreRemains.Close;
     quStoreRemains.Open;   }
  end;
  CheckQuery.ParamByName('@PrepareCheckID').AsInteger := PrepareCheckID;
  Query.ParamByName('@PrepareCheckID').AsInteger := PrepareCheckID;
  inherited;
  GuideCheck.RefreshQuery(true);
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key=vk_Tab then begin
     PostMessage(Handle,WM_SetActive,0,0);
     Key:=0;
  end;
end;

procedure TSoldWithCompMainForm.miVIPCheckClick(Sender: TObject);
var Params: TParams;
begin
  Params := nil;
  Params := TParams.Create(nil);
  Params.CreateParam(ftInteger, 'ManagerId', ptInput);
  Params.CreateParam(ftString, 'FIO', ptInput);
  with TVIPDialogForm.Create(nil) do
    try
      if Execute(Params) then begin
         ExecSQL('MainDB', 'UPDATE PrepareCheck SET CheckStatus = zc_csPutOff(), isVIP = 1, ' +
                           'ManagerId = ' + IntToStr(Params.ParamByName('ManagerId').AsInteger) + ', ' +
                           'BuyerName = ' + chr(39) + Params.ParamByName('FIO').AsString + chr(39) +
                           'WHERE Id = ' + IntToStr(PrepareCheckID));
         NewCheck;// процедура обновляет параметры для введения нового чека
      end;
    finally
      Free;
    end;
{  if TypeShowMessage('Отложить чек?', mtInformation, [mbYes, mbCancel], 0) = mrYes then begin
     ExecSQL('MainDB', 'UPDATE PrepareCheck SET CheckStatus = zc_csPutOff() WHERE Id = ' + IntToStr(PrepareCheckID));
     NewCheck;// процедура обновляет параметры для введения нового чека
  end;}
end;

{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.miMoneyinCashClick(Sender: TObject);
begin
  try
   rlMoneyInCash.Caption:=FormatFloat(_fmtPrice,
      StrToFloat(GetStringValue('MainDb',
        'select sum(zf_GetSummPlusNDS(Bill.BillSumm,Bill.IsNds,Bill.Nds)) as ReturnValue from dba.Bill where BillDate=Today(*) and BillKind =zc_bkSaleNal(*)'
        ))-StrToFloat(GetStringValue('MainDb',
        'select sum(DiscountSumm) as ReturnValue from dba.BillCheck,dba.Bill where BillDate=Today(*) and Bill.ID=BillCheck.BillWithOutNDSID'
        )));
  except
   rlMoneyInCash.Caption:=FormatFloat(_fmtPrice,0);
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.miPutOffClick(Sender: TObject);
begin
  inherited;
  if TypeShowMessage('Отложить чек?', mtInformation, [mbYes, mbCancel], 0) = mrYes then begin
     ExecSQL('MainDB', 'UPDATE PrepareCheck SET CheckStatus = zc_csPutOff() WHERE Id = ' + IntToStr(PrepareCheckID));
     NewCheck;// процедура обновляет параметры для введения нового чека
  end;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.OnNameEditTimerEvent(Sender: TObject);
{ procedure FindValue;
  begin
    with NewQuery do begin
       OldIndexFieldNames:=IndexFieldNames;
       DisableControls;
       IndexFieldNames:='FullName';
       FindNearest([edName.Text]);
       IndexFieldNames:=OldIndexFieldNames;
       EnableControls;

      with edName do begin
       if trim(Text)='' then begin
          ceCount.Enabled:=false;
          exit;
       end;
       IncrementalSearchCheck.Text:=Text;
       IncrementalSearchCheck.FindValue;
       if inSoldRegim then
          if (edName.Text=FieldByName('FullName').Text) then begin
             ceCount.Enabled:=true;
             Grid.Options:=Grid.Options+[wwdbigrd.dgAlwaysShowSelection];
             //Query.Resync([rmCenter]); // если нашли, то поставаили по центру
          end
          else begin
             Grid.Options:=Grid.Options-[wwdbigrd.dgAlwaysShowSelection];
             ceCount.Enabled:=false;
          end
       else
          if (CodeSearch.Text=CheckQuery.FieldByName('Code').Text) then begin
             ceCount.Enabled:=true;
             CheckGrid.Options:=CheckGrid.Options+[wwdbigrd.dgAlwaysShowSelection];
             //Query.Resync([rmCenter]); // если нашли, то поставаили по центру
          end
          else begin
             CheckGrid.Options:=CheckGrid.Options-[wwdbigrd.dgAlwaysShowSelection];
             ceCount.Enabled:=false;
          end;
      end;
    end;
  end;}
begin
{  if not fNameTimer.enabled then exit;
  fNameTimer.enabled:= False;
  if (edName.text <> lastGoodsValue) and (length(edName.text)>=length(lastGoodsValue))then
  begin
     findValue;
  end;
  lastGoodsValue:= edName.text;}
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.lcNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_Return) and (ceCount.Enabled) then begin
     ceCount.Text:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'CheckCount','1');
     if inSoldRegim then ceCount.Value:=abs(ceCount.Value)
     else ceCount.Value:=-abs(ceCount.Value);
     ActiveControl:=ceCount;
  end;
  if (Key=VK_Tab) then
     ActiveControl:=Grid
end;

procedure TSoldWithCompMainForm.lcNameChange(Sender: TObject);
begin
  if lcName.Text=NewQuery.FieldByName('FullName').asString then
    ceCount.Enabled:=true
  else
    ceCount.Enabled:=false;
end;

procedure TSoldWithCompMainForm.lcNameEnter(Sender: TObject);
begin
  lcName.Text:='';
end;

procedure TSoldWithCompMainForm.RxLabel2Click(Sender: TObject);
begin
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.miMoneyHideClick(Sender: TObject);
begin
  inherited;
  rlMoneyInCash.Caption:=' '+FormatFloat(_fmtPrice,0);
end;
{------------------------------------------------------------------------------}
procedure TSoldWithCompMainForm.cbQuiteClick(Sender: TObject);
begin
  inherited;
  if cbQuite.Checked then begin
//     cbQuite.Caption:='Тихо';
     Cash.AlwaysSold:=true;
  end
  else begin
  //   cbQuite.Caption:='Громко';
     Cash.AlwaysSold:=false;
  end;
end;

procedure TSoldWithCompMainForm.siDiscountClick(Sender: TObject);
begin
  inherited;
  {Скидки}
  ExecuteGuide_voAll(TDiscountGridForm);
end;

procedure TSoldWithCompMainForm.siSalersClick(Sender: TObject);
begin
  inherited;
  {Покупатели}
  ExecuteGuide_voAll(TSalerGuidesGridForm);
end;

procedure TSoldWithCompMainForm.NewQueryCalcFields(DataSet: TDataSet);
begin
  inherited;
{  if ShowStoreRemains then
     if FListStoreRemains.Values[NewQueryCode.AsString]<>'' then
        NewQueryRemainsStore.AsFloat:=StrToFloat(FListStoreRemains.Values[NewQueryCode.AsString])}
end;

procedure TSoldWithCompMainForm.siNTSClick(Sender: TObject);
begin
  inherited;
  TAnsestorGrid_111_Form(FindCreateForm(TFormClass(GetClass('TGoodsPropertyNtsForm')))).Execute;
end;

procedure TSoldWithCompMainForm.Button1Click(Sender: TObject);
begin
  inherited;
  TAnsestorGrid_111_Form(FindCreateForm(TFormClass(GetClass('TGoodsPropertyNtsForm')))).Execute;
end;

procedure TSoldWithCompMainForm.Button2Click(Sender: TObject);
begin
  inherited;
  TAnsestorGrid_111_Form(FindCreateForm(TFormClass(GetClass('TShortageItemForm')))).Execute;
end;

procedure TSoldWithCompMainForm.Button3Click(Sender: TObject);
begin
  inherited;
  with TAnsestorGrid_1_Form(FindCreateForm(TFormClass(GetClass('TPreparedCheckForm')))) do begin
    if Execute then begin
       PrepareCheckID := Query.FieldByName('Id').AsInteger;
    end;
  end;
  // В любом случае перечитываем
  RefreshItemClick(Sender);
  CalcTotalSumm;// Пересчитали значение Суммы в TotalPanel
end;

procedure TSoldWithCompMainForm.Button4Click(Sender: TObject);
begin
  inherited;
  with TAnsestorGrid_1_Form(FindCreateForm(TFormClass(GetClass('TPreparedCheckVIPForm')))) do begin
    if Execute then begin
       PrepareCheckID := Query.FieldByName('Id').AsInteger;
    end;
  end;
  // В любом случае перечитываем
  RefreshItemClick(Sender);
  CalcTotalSumm;// Пересчитали значение Суммы в TotalPanel
end;

procedure TSoldWithCompMainForm.UM_SetActive(var Message: TMessage);
begin
   ActiveControl:=lcName;
end;

procedure TSoldWithCompMainForm.lcNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key=char(VK_Tab) then
     ActiveControl:=Grid
end;

procedure TSoldWithCompMainForm.lcNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
{  if trim(lcName.Text) <> '' then
     NewQuery.Filter := 'FullName=' + chr(39) + lcName.Text + chr(39)
  else
     NewQuery.Filter := '';}
end;

procedure TSoldWithCompMainForm.WM_KEYDOWN(var Msg: TWMKEYDOWN);
begin
  if (Msg.charcode = VK_TAB) and (ActiveControl=lcName) then
     ActiveControl:=Grid;
end;

procedure TSoldWithCompMainForm.lcNameExit(Sender: TObject);
begin
  inherited;
  if (GetKeyState(VK_TAB)<0) and (GetKeyState(VK_CONTROL)<0) then begin
     ActiveControl:=CheckGrid;
     exit
  end;
  if GetKeyState(VK_TAB)<0 then
     ActiveControl:=Grid;
end;

procedure TSoldWithCompMainForm.RxLoginDialogCheckUser(Sender: TObject;
  const UserName, Password: String; var AllowLogin: Boolean);
begin
 { AllowLogin:=false;
  pApplication:=pApplicationFactory.CreateApplication(UserName, Password, pWorkshopConfig);
  pSecurityContext:=pApplication.SecurityContext;
  }
  AllowLogin:=true
end;

procedure TSoldWithCompMainForm.actUsersExecute(Sender: TObject);
begin
  inherited;
{  TExecuteControlFactory.GetExecuteControl('TObjectForm').Execute(
     VarArrayOf([1003,'Пользователи',pApplication.DomainFactory.User, pApplication.DataStorage.User]));
}
end;

procedure TSoldWithCompMainForm.btCheckClick(Sender: TObject);
begin
  inherited;
  TAnsestorGuidesBillForm(FindCreateForm(TFormClass(GetClass('TCheckBillGuidesForm')))).Execute('','');
end;

procedure TSoldWithCompMainForm.NewQueryFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var Index: integer;
begin
  inherited;
  Accept := (DataSet.FieldByName('RemainsCount').AsFloat > 0.01) or (DataSet.FieldByName('OperCount').AsFloat > 0.01);
end;

procedure TSoldWithCompMainForm.quStoreRemainsAfterOpen(DataSet: TDataSet);
begin
  inherited;
  FListStoreRemains.Clear;
  FFilterRemains.Clear;
  with DataSet do begin
    First;
    while not EOF do begin
      FListStoreRemains.Values[FieldByName('Code').asString]:=FloatToStr(FieldByName('Remains').asFloat);
      FFilterRemains.Add(FieldByName('Code').asString);
      Next;
    end
  end;
  FFilterRemains.Sort;
  TStringList(FListStoreRemains).Sort;
end;

procedure TSoldWithCompMainForm.siCashWorkClick(Sender: TObject);
begin
  inherited;
  with TCashWorkForm.Create(Cash, NewQuery) do begin
    ShowModal;
    Free;
  end;
end;

procedure TSoldWithCompMainForm.N2Click(Sender: TObject);
begin
  inherited;
  cbQuite.Checked:=not cbQuite.Checked;
  {}
end;

procedure TSoldWithCompMainForm.actRegimVosstanovleniyExecute(
  Sender: TObject);
begin
  inherited;
  SendToCashOnly:=true;
  TFormFactory.GetVCLForm('TRegimForm').Show;
end;

procedure TSoldWithCompMainForm.NewQueryBeforePost(DataSet: TDataSet);
begin
  inherited;
{  with spInsertUpdateGoodsPropertyNTZ do begin
    Prepare;
    ParamByName('@GoodsPropertyID').AsInteger:=DataSet.FieldByName('GoodsPropertyID').AsInteger;
    ParamByName('@UnitID').AsInteger:=abs(UnitId);
    ParamByName('@NtsCount').AsFloat:=DataSet.FieldByName('NTZ').Value;
    ExecProc
  end;
  with DataModuleMain.CommonQuery do begin
    SQL.Text:='update GoodsProperty set isReceiptNeed = '+DataSet.FieldByName('isReceipt').asString+' where Id = '+DataSet.FieldByName('GoodsPropertyID').AsString;
    ExecSQL
  end;}
end;

initialization

  RegisterClass(TSmallIntField);
{  pXMLParser:=CreateOleObject('IAXMLConfiguration.XMLParser');
  pWorkshopConfig := pXMLParser.parse('config.xml');
  pApplicationFactory:=CreateOleObject('dsdDstoreClientCore.ClientApplicationFactory');
 }
end.

