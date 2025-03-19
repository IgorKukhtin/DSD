unit UtilScale;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,Forms,Vcl.StdCtrls;

const
    fmtWeight:String = ',0.##### кг.';
    fmtFloat:String = ',0.#####';
    fmtFloat_2:String = ',0.##';
    fmtFloat_3:String = ',0.###';
    fmtHead:String = ',0.##### глв.';
    lStickerPackGroupId:Integer = 1;
type
{
  TDBObject = record
    Id:   Integer;
    Code: Integer;
    Name: string;
  end;
 }
  TListItem = record
    Number: Integer;
    Id:     Integer;
    Code:   Integer;
    Name:   string;
    Value:  string;
  end;

  TStickerFileItem = record
    Report:       TStream;
    Report_70_70: TStream;
    Id:           Integer;
    Code:         Integer;
    FileName:     String;
    FileName_70_70:     String;
  end;

  TScaleType = (stBI, stDB, stZeus, stAP);

  TListItemScale = record
    Number   : Integer;
    ScaleType: TScaleType;
    ScaleName: string;
    COMPort  : Integer;
  end;

  {TListItemLight = record
    Number   : Integer;
    LightName: string;
    COMPort  : Integer;
  end;}

  TArrayStickerFileList = array of TStickerFileItem;
  TArrayList = array of TListItem;
  TArrayListScale = array of TListItemScale;
  //TArrayListLight = array of TListItemLight;

  TSettingMain = record
    IP_str       :String;
    isModeSorting:Boolean;  // ScaleCeh - Режим маркировка/сортировка
    isPartionDate:Boolean;  // Scale
    isReason     :Boolean;  // Scale
    isReReturnIn :Boolean;  // Scale
    isAsset      :Boolean;  // Scale

    isSticker:Boolean;        // Scale
    isSticker_Weight:Boolean; // Scale

    isCeh:Boolean;          // ScaleCeh or Scale
    isGoodsComplete:Boolean;// ScaleCeh or Scale - склад ГП/производство/упаковка or обвалка
    isCalc_sht:Boolean;     // ScaleCeh - вес - из него получаем м. или шт.
    isPartionGoods_20103:Boolean;// Scale - автоматом открыть справочник партий - шины, и т.п.
    WeightSkewer1:Double;   // only ScaleCeh
    WeightSkewer2:Double;   // only ScaleCeh
    Exception_WeightDiff:Double; // only Scale

    WeightTare1:Double;   // only Scale
    WeightTare2:Double;   // only Scale
    WeightTare3:Double;   // only Scale
    WeightTare4:Double;   // only Scale
    WeightTare5:Double;   // only Scale
    WeightTare6:Double;   // only Scale
    WeightTare7:Double;   // only Scale
    WeightTare8:Double;   // only Scale
    WeightTare9:Double;   // only Scale
    WeightTare10:Double;  // only Scale

    NameTare1:String;   // only Scale
    NameTare2:String;   // only Scale
    NameTare3:String;   // only Scale
    NameTare4:String;   // only Scale
    NameTare5:String;   // only Scale
    NameTare6:String;   // only Scale
    NameTare7:String;   // only Scale
    NameTare8:String;   // only Scale
    NameTare9:String;   // only Scale
    NameTare10:String;  // only Scale

    TareId_1:Integer;   // only Scale
    TareId_2:Integer;   // only Scale
    TareId_3:Integer;   // only Scale
    TareId_4:Integer;   // only Scale
    TareId_5:Integer;   // only Scale
    TareId_6:Integer;   // only Scale
    TareId_7:Integer;   // only Scale
    TareId_8:Integer;   // only Scale
    TareId_9:Integer;   // only Scale
    TareId_10:Integer;  // only Scale

    Limit_Second_save_MI:Integer;

    isOperDatePartner:Boolean; // only Scale - 301 and 302

    UnitId1, UnitId2, UnitId3, UnitId4, UnitId5:Integer;
    UnitName1, UnitName2, UnitName3, UnitName4, UnitName5 :String;

    UnitId1_sep, UnitId2_sep, UnitId3_sep, UnitId4_sep, UnitId5_sep:Integer;
    UnitName1_sep, UnitName2_sep, UnitName3_sep, UnitName4_sep, UnitName5_sep :String;

    isLightLEFT_123 : Boolean;
    isLightCOMPort : Boolean;
    LightColor_1, LightColor_2, LightColor_3 : Integer;
    Name_Sh, Name_Nom, Name_Ves : String;
    ShName_Sh, ShName_Nom, ShName_Ves : String;

    BranchCode:Integer;
    BranchName:String;
    PlaceNumber:Integer;
    ScaleCount:Integer;
    DefaultCOMPort:Integer;
    LightCOMPort:Integer;
    IndexScale_old:Integer;
  end;

  function gpCheck_BranchCode: Boolean;

  function Recalc_PartionGoods(Edit:TEdit):Boolean;


  function GetArrayStickerFileList_Index_byName       (ArrayList:TArrayStickerFileList;FileName      :String):Integer;
  function GetArrayStickerFileList_Index_byName_70_70 (ArrayList:TArrayStickerFileList;FileName_70_70:String):Integer;

  function GetArrayList_Value_byName   (ArrayList:TArrayList;Name:String):String;
  function GetArrayList_Index_byNumber (ArrayList:TArrayList;Number:Integer):Integer;
  function GetArrayList_Index_byCode   (ArrayList:TArrayList;Code:Integer):Integer;
  function GetArrayList_Index_byName   (ArrayList:TArrayList;Name:String):Integer;
  function GetArrayList_Index_byValue  (ArrayList:TArrayList;Value:String):Integer;

  function GetArrayList_lpIndex_GoodsKind(ArrayList:TArrayList;GoodsKindWeighingGroupId,Code:Integer):Integer;
  function GetArrayList_gpIndex_GoodsKind(ArrayList:TArrayList;GoodsKindWeighingGroupId,lpIndex:Integer):Integer;

  function isEqualFloatValues (Value1,Value2:Double):boolean;

  function _myTrunct_4 (Value:Double):Double;
  function _myTrunct_2 (Value:Double):Double;
  function _myTrunct_3 (Value:Double):Double;
  function _myTrunct_1 (Value:Double):Double;

  procedure MyDelay(mySec:Integer);
  procedure MyDelay_two(mySec:Integer);

  procedure Create_ParamsMovement(var Params:TParams);
  procedure Create_ParamsReason_global(var Params:TParams);
  procedure Create_ParamsMI(var Params:TParams);
  procedure Create_ParamsLight(var Params:TParams);
  procedure Create_ParamsPersonal(var Params:TParams; idx:String);
  procedure Create_ParamsPersonal_Stick(var Params:TParams; idx:String);
  procedure Create_ParamsPersonalComplete(var Params:TParams);
  procedure Create_ParamsPersonalGroup(var Params:TParams);
  procedure Create_ParamsWorkProgress(var Params:TParams);
  procedure Create_ParamsArticleLoss(var Params:TParams);
  procedure Create_ParamsPartionCell(var Params:TParams);
  procedure Create_ParamsAsset(var Params:TParams);
  procedure Create_ParamsGoodsLine(var Params:TParams);
  procedure Create_ParamsSubjectDoc(var Params:TParams);
  procedure Create_ParamsReason(var Params:TParams);
  procedure Create_ParamsUnit_OrderInternal(var Params:TParams);
  procedure Create_ParamsReReturnIn(var Params:TParams);
  procedure Create_ParamsGuide(var Params:TParams);

  // создает TParam с названием поля _Name и типом _DataType и добавляет к TParams
  procedure ParamAdd(var execParams:TParams;_Name:String;_DataType:TFieldType);
  // создает TParam с названием поля _Name и типом _DataType и добавляет к TParams со значением _Value
  procedure ParamAddValue(var execParams: TParams;_Name:String;_DataType:TFieldType;_Value: variant);
  // возвращаят индекс парамтра сназванием FindName в TParams
  function GetIndexParams(execParams:TParams;FindName:String):Integer;
  //
  procedure CopyValuesParamsFrom(var fromParams,toParams:TParams);
  procedure EmptyValuesParams(var execParams:TParams);

  function CheckBarCode(BarCode:String):Boolean;
  function CalcBarCode(BarCode:String):String;
  function myStrToFloat(Value:String):Double;
  function myReplaceStr(const S, Srch, Replace: string): string;

var
  UserId_begin : Integer;
  UserName_begin : String;

  SettingMain   : TSettingMain;
  ParamsMovement: TParams;
  ParamsMI: TParams;
  ParamsReason: TParams;
  ParamsLight: TParams;

  StickerFile_Array   :TArrayStickerFileList;
  Scale_Array         :TArrayListScale;
  //Light_Array         :TArrayListLight;

  Default_Array       :TArrayList;
  Service_Array       :TArrayList;

  StickerPack_Array   :TArrayList;
  GoodsKind_Array     :TArrayList;
  TareCount_Array     :TArrayList;
  TareWeight_Array    :TArrayList;
  ChangePercentAmount_Array :TArrayList;
  PriceList_Array     :TArrayList;
  PrinterSticker_Array:TArrayList;
  LanguageSticker_Array:TArrayList;

  zc_Movement_Income: Integer;
  zc_Movement_ReturnOut: Integer;
  zc_Movement_Sale: Integer;
  zc_Movement_ReturnIn: Integer;
  zc_Movement_Send: Integer;
  zc_Movement_SendOnPrice: Integer;

  zc_Movement_Loss: Integer;
  zc_Movement_Inventory: Integer;
  zc_Movement_ProductionUnion: Integer;
  zc_Movement_ProductionSeparate: Integer;

  zc_Movement_OrderExternal: Integer;
  zc_Movement_OrderInternal: Integer;
  zc_Movement_OrderIncome: Integer;

  zc_Enum_InfoMoney_30201: Integer; // Доходы + Мясное сырье + Мясное сырье

  zc_Enum_DocumentKind_CuterWeight: Integer; // Взвешивание п/ф факт куттера
  zc_Enum_DocumentKind_RealWeight : Integer; // Взвешивание п/ф факт сырой
  zc_Enum_DocumentKind_RealDelicShp: Integer; // взвешивание п/ф факт после шприцевания
  zc_Enum_DocumentKind_RealDelicMsg : Integer; // взвешивание п/ф факт после массажера

  zc_Enum_DocumentKind_LakTo  : Integer; // перемещение на лакирование
  zc_Enum_DocumentKind_LakFrom: Integer; // перемещение с лакирования

  zc_Object_Partner    : Integer;
  zc_Object_ArticleLoss: Integer;
  zc_Object_Member     : Integer;
  zc_Object_Unit       : Integer;
  zc_Object_Car        : Integer;

  zc_Measure_Sh: Integer;
  zc_Measure_Kg: Integer;
  zc_Measure_Kgg: Integer;

  zc_Enum_Status_Complete: Integer;
  zc_Enum_Status_UnComplete: Integer;

  zc_BarCodePref_Object  :String;
  zc_BarCodePref_Movement:String;
  zc_BarCodePref_MI      :String;

//const ErrLight : Boolean = true;
//const ErrLight : Boolean = false;

implementation
//uses DMMainScale;
{------------------------------------------------------------------------}
function _myTrunct_4 (Value:Double):Double;
var Value_int : Int64;
begin
    Value_int := trunc(Value * 100000);
    if (Value_int mod 10) >= 5
    then Result:= (trunc(Value_int  / 10) + 1) / 10000
    else Result:= (trunc(Value_int  / 10) + 0) / 10000

end;
{------------------------------------------------------------------------}
function _myTrunct_3 (Value:Double):Double;
var Value_int : Int64;
begin
    Value_int := trunc(Value * 10000);
    if (Value_int mod 10) >= 5
    then Result:= (trunc(Value_int  / 10) + 1) / 1000
    else Result:= (trunc(Value_int  / 10) + 0) / 1000

end;
{------------------------------------------------------------------------}
function _myTrunct_2 (Value:Double):Double;
var Value_int : Int64;
begin
    Value_int := trunc(Value * 1000);
    if (Value_int mod 10) >= 5
    then Result:= (trunc(Value_int  / 10) + 1) / 100
    else Result:= (trunc(Value_int  / 10) + 0) / 100

end;
{------------------------------------------------------------------------}
function _myTrunct_1 (Value:Double):Double;
var Value_int : Int64;
begin
    Value_int := trunc(Value * 100);
    if (Value_int mod 10) >= 5
    then Result:= (trunc(Value_int  / 10) + 1) / 10
    else Result:= (trunc(Value_int  / 10) + 0) / 10

end;
{------------------------------------------------------------------------}
procedure Create_ParamsMovement(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'ColorGridValue',ftInteger);
     ParamAdd(Params,'OperDate',ftDateTime);
     ParamAdd(Params,'OperDatePartner',ftDateTime);
     ParamAdd(Params,'isOperDatePartner',ftBoolean);

     ParamAdd(Params,'MessageText',ftString);


     ParamAdd(Params,'MovementId_begin',ftInteger);//документ который создается после закрытия "документа взвешивания", т.е. после Save_Movement_all
     ParamAdd(Params,'MovementId_begin_next',ftInteger);//документ который создается после закрытия "документа взвешивания", т.е. после Save_Movement_all

     ParamAdd(Params,'MovementId_get',ftInteger);//документ взвешивания определяется при gpGet_Scale_OrderExternal !!!только для заявки!!!, потом переносится в MovementId

     ParamAdd(Params,'MovementId_find',ftInteger);//

     ParamAdd(Params,'MovementId',ftInteger); //документ взвешивания
     ParamAdd(Params,'InvNumber',ftString);
     ParamAdd(Params,'InvNumberPartner',ftString);
     ParamAdd(Params,'OperDate_Movement',ftDateTime);

     // информативное для сообщения
     ParamAdd(Params,'InvNumber_inf',ftString);
     ParamAdd(Params,'OperDate_inf',ftDateTime);
     // информативное для сообщения
     ParamAdd(Params,'GoodsCode_inf',ftInteger);
     ParamAdd(Params,'GoodsName_inf',ftString);
     ParamAdd(Params,'PricePartner_inf',ftFloat);
     ParamAdd(Params,'isPrice_diff_inf',ftBoolean);
     ParamAdd(Params,'isFind_diff_inf',ftBoolean);

     ParamAdd(Params,'MovementDescNumber',ftInteger);

     ParamAdd(Params,'MovementDescId',ftInteger);
     ParamAdd(Params,'MovementDescId_next',ftInteger);
     ParamAdd(Params,'FromId',ftInteger);
     ParamAdd(Params,'FromCode',ftInteger);
     ParamAdd(Params,'FromName',ftString);
     ParamAdd(Params,'ToId',ftInteger);
     ParamAdd(Params,'ToCode',ftInteger);
     ParamAdd(Params,'ToName',ftString);
     ParamAdd(Params,'PaidKindId',ftInteger);
     ParamAdd(Params,'PaidKindName',ftString);

     ParamAdd(Params,'InfoMoneyId',ftInteger);
     ParamAdd(Params,'InfoMoneyCode',ftInteger);
     ParamAdd(Params,'InfoMoneyName',ftString);

     ParamAdd(Params,'isGetPartner',ftBoolean); //локальный параметр
     ParamAdd(Params,'calcPartnerId',ftInteger);
     ParamAdd(Params,'calcPartnerCode',ftInteger);
     ParamAdd(Params,'calcPartnerName',ftString);

     ParamAdd(Params,'ChangePercentAmount',ftFloat); // % скидки для кол-ва - дефолт?
     ParamAdd(Params,'DiscountAmountPartner',ftFloat); // % скидки для кол-ва поставщика
     ParamAdd(Params,'isDiscount_q',ftBoolean); // скидка за несоотвестветствие качеству
     ParamAdd(Params,'isDiscount_t',ftBoolean); // скидка за несоотвестветствие температуры
     ParamAdd(Params,'isOpen_ActDiff',ftBoolean); // скидка за несоотвестветствие температуры

     ParamAdd(Params,'ChangePercent',ftFloat);
     ParamAddValue(Params,'isContractGoods',ftBoolean, FALSE);//

     ParamAdd(Params,'isTransport_link',ftBoolean);
     ParamAdd(Params,'TransportId',ftInteger);
     ParamAdd(Params,'Transport_BarCode',ftString);
     ParamAdd(Params,'Transport_InvNumber',ftString);
     ParamAdd(Params,'PersonalDriverId',ftInteger);
     ParamAdd(Params,'PersonalDriverCode',ftInteger);
     ParamAdd(Params,'PersonalDriverName',ftString);
     ParamAdd(Params,'CarName',ftString);
     ParamAdd(Params,'RouteName',ftString);

     ParamAdd(Params,'isSticker_Ceh',ftBoolean);
     ParamAdd(Params,'isSticker_KVK',ftBoolean);

     ParamAdd(Params,'isOldPeriod',ftBoolean);

     ParamAdd(Params,'isSubjectDoc',ftBoolean);
     ParamAdd(Params,'isComment',ftBoolean);
     ParamAdd(Params,'isInvNumberPartner',ftBoolean);
     ParamAdd(Params,'isInvNumberPartner_check',ftBoolean);
     ParamAdd(Params,'isDocPartner',ftBoolean);
     //ParamAdd(Params,'MovementId_DocPartner',ftInteger);

     ParamAdd(Params,'SubjectDocId',ftInteger);
     ParamAdd(Params,'SubjectDocCode',ftInteger);
     ParamAdd(Params,'SubjectDocName',ftString);
     ParamAdd(Params,'DocumentComment',ftString);

     ParamAdd(Params,'isPersonalGroup',ftBoolean);
     ParamAdd(Params,'PersonalGroupId',ftInteger);
     ParamAdd(Params,'PersonalGroupCode',ftInteger);
     ParamAdd(Params,'PersonalGroupName',ftString);

     ParamAdd(Params,'isKVK',ftBoolean);
     ParamAdd(Params,'PersonalId_KVK',ftInteger);
     ParamAdd(Params,'PersonalCode_KVK',ftInteger);
     ParamAdd(Params,'PersonalName_KVK',ftString);
     ParamAdd(Params,'NumberKVK',ftString);

     ParamAdd(Params,'isEdiOrdspr',ftBoolean); //Подтверждение
     ParamAdd(Params,'isEdiInvoice',ftBoolean);//Счет
     ParamAdd(Params,'isEdiDesadv',ftBoolean); //уведомление

     ParamAdd(Params,'isExportEmail',ftBoolean); //ExportEmail

     ParamAdd(Params,'isMovement',ftBoolean);  //Накладная
     ParamAdd(Params,'isAccount',ftBoolean);   //Счет
     ParamAdd(Params,'isTransport',ftBoolean); //ТТН
     ParamAdd(Params,'isQuality',ftBoolean);   //Качественное
     ParamAdd(Params,'isPack',ftBoolean);      //Упаковочный
     ParamAdd(Params,'isSpec',ftBoolean);      //Спецификация
     ParamAdd(Params,'isTax',ftBoolean);       //Налоговая

     ParamAdd(Params,'CountMovement',ftInteger);  //Накладная
     ParamAdd(Params,'CountAccount',ftInteger);   //Счет
     ParamAdd(Params,'CountTransport',ftInteger); //ТТН
     ParamAdd(Params,'CountQuality',ftInteger);   //Качественное
     ParamAdd(Params,'CountPack',ftInteger);      //Упаковочный
     ParamAdd(Params,'CountSpec',ftInteger);      //Спецификация
     ParamAdd(Params,'CountTax',ftInteger);       //Налоговая

     ParamAdd(Params,'isSendOnPriceIn',ftBoolean);
     ParamAdd(Params,'isPartionGoodsDate',ftBoolean); // Scale + ScaleCeh - для приемки с производства + расходы с РК - показываем контрол с датой для определения партии
     ParamAdd(Params,'isPartionDate_save',ftBoolean); // Scale + ScaleCeh - для приемки с производства + расходы с РК - показываем выбор сохранять да/нет
     ParamAdd(Params,'isStorageLine',ftBoolean);
     ParamAdd(Params,'isArticleLoss',ftBoolean);
     ParamAdd(Params,'isLockStartWeighing',ftBoolean);
     ParamAdd(Params,'isListInventory',ftBoolean);
     ParamAdd(Params,'isCalc_Sh',ftBoolean);

     ParamAdd(Params,'isOperCountPartner',ftBoolean); // Кол-во поставщика
     ParamAdd(Params,'isOperPricePartner',ftBoolean); // цены поставщика
     ParamAdd(Params,'isReturnOut_Date',ftBoolean);   // Дата для цены возврат поставщику
     ParamAdd(Params,'isCalc_PriceVat',ftBoolean);    // Расчет цены с НДС или без

     ParamAdd(Params,'isPartionCell',ftBoolean);
     ParamAdd(Params,'PartionCellId',ftInteger);
     ParamAdd(Params,'PartionCellName',ftString);
     ParamAdd(Params,'PartionCellInvNumber',ftString);

     ParamAdd(Params,'isPartionPassport',ftBoolean);

     ParamAdd(Params,'isAsset',ftBoolean);
     ParamAdd(Params,'AssetId',ftInteger);
     ParamAdd(Params,'AssetCode',ftInteger);
     ParamAdd(Params,'AssetName',ftString);
     ParamAdd(Params,'AssetInvNumber',ftString);

     ParamAdd(Params,'AssetId_two',ftInteger);
     ParamAdd(Params,'AssetCode_two',ftInteger);
     ParamAdd(Params,'AssetName_two',ftString);
     ParamAdd(Params,'AssetInvNumber_two',ftString);

     ParamAdd(Params,'isReReturnIn',ftBoolean);
     ParamAdd(Params,'MovementId_reReturnIn',ftInteger);
     ParamAdd(Params,'InvNumber_reReturnIn',ftString);
     ParamAdd(Params,'OperDate_reReturnIn',ftDateTime);

     ParamAdd(Params,'OrderExternalId',ftInteger);
     ParamAdd(Params,'OrderExternal_DescId',ftInteger);
     ParamAdd(Params,'OrderExternal_BarCode',ftString);
     ParamAdd(Params,'OrderExternal_InvNumber',ftString);
     ParamAdd(Params,'OrderExternalName_master',ftString);

     ParamAdd(Params,'ContractId',ftInteger);
     ParamAdd(Params,'ContractCode',ftInteger);
     ParamAdd(Params,'ContractNumber',ftString);
     ParamAdd(Params,'ContractTagName',ftString);

     ParamAdd(Params,'GoodsPropertyId',ftInteger);
     ParamAdd(Params,'GoodsPropertyCode',ftInteger);
     ParamAdd(Params,'GoodsPropertyName',ftString);

     ParamAdd(Params,'PriceListId',ftInteger);
     ParamAdd(Params,'PriceListCode',ftInteger);
     ParamAdd(Params,'PriceListName',ftString);

     ParamAdd(Params,'DocumentKindId',ftInteger);
     ParamAdd(Params,'DocumentKindName',ftString);

     ParamAdd(Params,'GoodsKindWeighingGroupId',ftInteger);

     ParamAdd(Params,'MovementDescName_master',ftString);

     ParamAdd(Params,'isComlete',ftBoolean);//локальный параметр, режим просмотра накладных
     ParamAdd(Params,'isMovementId_check',ftBoolean);//локальный параметр, Insert или Update в TDialogMovementDescForm

     ParamAdd(Params,'TotalSumm',ftFloat);
     ParamAdd(Params,'TotalSummPartner',ftFloat);

     ParamAddValue(Params,'isDocInsert',ftBoolean,FALSE);

end;
{------------------------------------------------------------------------}
procedure Create_ParamsReason_global(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'ReasonId',ftInteger);
     ParamAdd(Params,'ReasonCode',ftInteger);
     ParamAdd(Params,'ReasonName',ftString);
     ParamAdd(Params,'ReturnKindName',ftString);
end;
{------------------------------------------------------------------------}
procedure Create_ParamsLight(var Params:TParams);
begin
     Params:=nil;
     if SettingMain.isModeSorting = TRUE then
     begin
          //Всегда цвет - 1-ая линия
          //ParamAdd(Params,'Color_1',ftInteger);
          //Всегда цвет - 2-ая линия
          //ParamAdd(Params,'Color_2',ftInteger);
          //Всегда цвет - 3-ья линия
          //ParamAdd(Params,'Color_3',ftInteger);
          //
          //
          ParamAdd(Params,'MovementItemId',ftInteger); // Id строки
          //
          ParamAdd(Params,'ResultText',ftString);     // вернули если была ошибка
          ParamAdd(Params,'isErrSave',ftBoolean);     // режим, когда вызываем во второй раз и надо сохранить ошибку

          // локально
          ParamAdd(Params,'Count_box',ftInteger);     // сколько линий для ящиков - 1,2 или 3
          ParamAdd(Params,'LineCode_begin',ftInteger);// вернули № линии, что б подсветить
          //
          ParamAdd(Params,'GoodsId',ftInteger);       // Товар
          ParamAdd(Params,'GoodsCode',ftInteger);     // Товар
          ParamAdd(Params,'GoodsName',ftString);      // Товар
          ParamAdd(Params,'GoodsKindId',ftInteger);   // Вид товара
          ParamAdd(Params,'GoodsKindCode',ftInteger); // Вид товара
          ParamAdd(Params,'GoodsKindName',ftString);  // Вид товара

          //
          ParamAdd(Params,'GoodsId_sh',ftInteger);       // Товар
          ParamAdd(Params,'GoodsCode_sh',ftInteger);     // Товар
          ParamAdd(Params,'GoodsName_sh',ftString);      // Товар
          ParamAdd(Params,'GoodsKindId_sh',ftInteger);   // Вид товара
          ParamAdd(Params,'GoodsKindCode_sh',ftInteger); // Вид товара
          ParamAdd(Params,'GoodsKindName_sh',ftString);  // Вид товара

          ParamAdd(Params,'MeasureId',ftInteger);     // Ед.изм.
          ParamAdd(Params,'MeasureCode',ftInteger);   // Ед.изм.
          ParamAdd(Params,'MeasureName',ftString);    // Ед.изм.

          ParamAdd(Params,'GoodsTypeKindId_Sh',ftInteger); // Id - есть ли ШТ.
          ParamAdd(Params,'GoodsTypeKindId_Nom',ftInteger);// Id - есть ли НОМ.
          ParamAdd(Params,'GoodsTypeKindId_Ves',ftInteger);// Id - есть ли ВЕС
          ParamAdd(Params,'WmsCode_Sh',ftString);          // Код ВМС - ШТ.
          ParamAdd(Params,'WmsCode_Nom',ftString);         // Код ВМС - НОМ.
          ParamAdd(Params,'WmsCode_Ves',ftString);         // Код ВМС - ВЕС

          ParamAdd(Params,'WeightMin',ftFloat);            // минимальный вес 1шт.
          ParamAdd(Params,'WeightMax',ftFloat);            // максимальный вес 1шт.

          ParamAdd(Params,'WeightMin_Sh',ftFloat);         // максимальный вес 1шт.
          ParamAdd(Params,'WeightMin_Nom',ftFloat);        //
          ParamAdd(Params,'WeightMin_Ves',ftFloat);        //
          ParamAdd(Params,'WeightMax_Sh',ftFloat);         // максимальный вес 1шт.
          ParamAdd(Params,'WeightMax_Nom',ftFloat);        //
          ParamAdd(Params,'WeightMax_Ves',ftFloat);        //

          //1-ая линия - Всегда этот цвет
          ParamAdd(Params,'GoodsTypeKindId_1',ftInteger);// выбранный тип для этого ЦВЕТА
          ParamAdd(Params,'BarCodeBoxId_1',ftInteger);   // Id для Ш/К ящика
          ParamAdd(Params,'BoxCode_1',ftInteger);        // код для Ш/К ящика
          ParamAdd(Params,'BoxBarCode_1',ftString);      // Ш/К ящика
          ParamAdd(Params,'WeightOnBoxTotal_1',ftFloat); // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
          ParamAdd(Params,'CountOnBoxTotal_1',ftFloat);  // шт итого накопительно (в незакрытом ящике) - информативно?
          ParamAdd(Params,'WeightTotal_1',ftFloat);      // Вес итого накопительный (в закрытых ящиках) - информативно
          ParamAdd(Params,'CountTotal_1',ftFloat);       // шт итого накопительный (в закрытых ящиках) - информативно
          ParamAdd(Params,'BoxTotal_1',ftFloat);         // ящиков итого (закрытых) - информативно
          ParamAdd(Params,'isFull_1',ftBoolean);         // ящик заполнен - т.е. надо его закрыть (сформировать zc_Movement_WeighingProduction + просканировать новый ящик)

          ParamAdd(Params,'BoxId_1',ftInteger);          // Id ящика
          ParamAdd(Params,'BoxName_1',ftString);         // название ящика Е2 или Е3
          ParamAdd(Params,'BoxWeight_1',ftFloat);        // Вес самого ящика
          ParamAdd(Params,'WeightOnBox_1',ftFloat);      // вложенность - Вес
          ParamAdd(Params,'CountOnBox_1',ftFloat);       // Вложенность - шт (информативно?)

          //2-ая линия - Всегда этот цвет
          ParamAdd(Params,'GoodsTypeKindId_2',ftInteger);// выбранный тип для этого ЦВЕТА
          ParamAdd(Params,'BarCodeBoxId_2',ftInteger);   // Id для Ш/К ящика
          ParamAdd(Params,'BoxCode_2',ftInteger);        // код для Ш/К ящика
          ParamAdd(Params,'BoxBarCode_2',ftString);      // Ш/К ящика
          ParamAdd(Params,'WeightOnBoxTotal_2',ftFloat); // Вес итого накопительный - при достижении будет сброс
          ParamAdd(Params,'CountOnBoxTotal_2',ftFloat);  // шт итого накопительно - информативно?
          ParamAdd(Params,'WeightTotal_2',ftFloat);      // Вес итого накопительный (в закрытых ящиках) - информативно
          ParamAdd(Params,'CountTotal_2',ftFloat);       // шт итого накопительный (в закрытых ящиках) - информативно
          ParamAdd(Params,'BoxTotal_2',ftFloat);         // ящиков итого (закрытых) - информативно
          ParamAdd(Params,'isFull_2',ftBoolean);         // ящик заполнен - т.е. надо его закрыть (сформировать zc_Movement_WeighingProduction + просканировать новый ящик)

          ParamAdd(Params,'BoxId_2',ftInteger);          // Id ящика
          ParamAdd(Params,'BoxName_2',ftString);         // название ящика Е2 или Е3
          ParamAdd(Params,'BoxWeight_2',ftFloat);        // Вес самого ящика
          ParamAdd(Params,'WeightOnBox_2',ftFloat);      // вложенность - Вес
          ParamAdd(Params,'CountOnBox_2',ftFloat);       // Вложенность - шт (информативно?)

          //3-ья линия - Всегда этот цвет
          ParamAdd(Params,'GoodsTypeKindId_3',ftInteger);// выбранный тип для этого ЦВЕТА
          ParamAdd(Params,'BarCodeBoxId_3',ftInteger);   // Id для Ш/К ящика
          ParamAdd(Params,'BoxCode_3',ftInteger);        // код для Ш/К ящика
          ParamAdd(Params,'BoxBarCode_3',ftString);      // Ш/К ящика
          ParamAdd(Params,'WeightOnBoxTotal_3',ftFloat); // Вес итого накопительный - при достижении будет сброс
          ParamAdd(Params,'CountOnBoxTotal_3',ftFloat);  // шт итого накопительно - информативно?
          ParamAdd(Params,'WeightTotal_3',ftFloat);      // Вес итого накопительный (в закрытых ящиках) - информативно
          ParamAdd(Params,'CountTotal_3',ftFloat);       // шт итого накопительный (в закрытых ящиках) - информативно
          ParamAdd(Params,'BoxTotal_3',ftFloat);         // ящиков итого (закрытых) - информативно
          ParamAdd(Params,'isFull_3',ftBoolean);         // ящик заполнен - т.е. надо его закрыть (сформировать zc_Movement_WeighingProduction + просканировать новый ящик)

          ParamAdd(Params,'BoxId_3',ftInteger);          // Id ящика
          ParamAdd(Params,'BoxName_3',ftString);         // название ящика Е2 или Е3
          ParamAdd(Params,'BoxWeight_3',ftFloat);        // Вес самого ящика
          ParamAdd(Params,'WeightOnBox_3',ftFloat);      // вложенность - Вес
          ParamAdd(Params,'CountOnBox_3',ftFloat);       // Вложенность - шт (информативно?)
     end;

end;
{------------------------------------------------------------------------}
procedure Create_ParamsMI(var Params:TParams);
begin
     Params:=nil;
     if SettingMain.isCeh = FALSE then
     begin
         ParamAdd(Params,'MovementItemId',ftInteger);    // Id строки
         ParamAdd(Params,'GoodsId',ftInteger);           // Товары
         ParamAdd(Params,'GoodsCode',ftInteger);         // Товары
         ParamAdd(Params,'GoodsName',ftString);          // Товары
         ParamAdd(Params,'GoodsKindId',ftInteger);       // Виды товаров
         ParamAdd(Params,'GoodsKindCode',ftInteger);     // Виды товаров
         ParamAdd(Params,'GoodsKindName',ftString);      // Виды товаров
         ParamAdd(Params,'StorageLineId',ftInteger);     // Линия пр-ва
         ParamAdd(Params,'StorageLineCode',ftInteger);   // Линия пр-ва
         ParamAdd(Params,'StorageLineName',ftString);    // Линия пр-ва
         ParamAdd(Params,'RealWeight_Get',ftFloat);      //
         ParamAdd(Params,'RealWeight',ftFloat);          // Реальный вес (без учета: минус тара и % скидки для кол-ва)
         ParamAdd(Params,'CountTare',ftFloat);           // Количество тары
         ParamAdd(Params,'WeightTare',ftFloat);          // Вес 1-ой тары
         ParamAdd(Params,'ChangePercentAmount',ftFloat); // % скидки для кол-ва
         ParamAdd(Params,'Price',ftFloat);               //
         ParamAdd(Params,'Price_Return',ftFloat);        //
         ParamAdd(Params,'CountForPrice',ftFloat);       //
         ParamAdd(Params,'CountForPrice_Return',ftFloat);//
         ParamAdd(Params,'Count',ftFloat);               // Количество пакетов или Количество батонов
         ParamAdd(Params,'HeadCount',ftFloat);           // Количество голов
         ParamAdd(Params,'BoxCount',ftFloat);            //
         ParamAdd(Params,'BoxCode',ftInteger);           //
         ParamAdd(Params,'PartionGoods',ftString);       //

         ParamAdd(Params,'PartionGoodsDate',ftDateTime);  // Дата партия
         ParamAdd(Params,'isPartionDate_save',ftBoolean); // выбрали сохранять Дату партия да/нет

         ParamAdd(Params,'isBarCode',ftBoolean);         //
         ParamAdd(Params,'MovementId_Promo',ftInteger);  //

         ParamAdd(Params,'CountTare1',ftFloat);          // Количество тары вида1
         ParamAdd(Params,'CountTare2',ftFloat);          // Количество тары вида2
         ParamAdd(Params,'CountTare3',ftFloat);          // Количество тары вида3
         ParamAdd(Params,'CountTare4',ftFloat);          // Количество тары вида4
         ParamAdd(Params,'CountTare5',ftFloat);          // Количество тары вида5
         ParamAdd(Params,'CountTare6',ftFloat);          // Количество тары вида6
         ParamAdd(Params,'CountTare7',ftFloat);          // Количество тары вида7
         ParamAdd(Params,'CountTare8',ftFloat);          // Количество тары вида8
         ParamAdd(Params,'CountTare9',ftFloat);          // Количество тары вида9
         ParamAdd(Params,'CountTare10',ftFloat);         // Количество тары вида10

         ParamAdd(Params,'CountPack',ftFloat);           // Количество упаковок - Флоупак +  Нар.180 + Нар. 200
         ParamAdd(Params,'WeightPack_gd',ftFloat);       // Вес 1-ой упаковки
         ParamAdd(Params,'WeightPack',ftFloat);          // Вес 1-ой упаковки - Флоупак +  Нар.180 + Нар. 200
         ParamAdd(Params,'NamePack',ftString);           // Название 1-ой упаковки - Флоупак +  Нар.180 + Нар. 200
         ParamAdd(Params,'Weight_gd',ftFloat);           // Вес шт. товара

         ParamAdd(Params,'Amount_Goods',ftFloat);        //

         ParamAdd(Params,'PartionCellId',ftInteger);       //
         ParamAdd(Params,'PartionCellName',ftString);      //

         ParamAdd(Params,'isAmountPartnerSecond',ftBoolean); // без оплаты да/нет - Кол-во поставщика
         ParamAdd(Params,'isPriceWithVAT',ftBoolean);     // Цена с НДС да/нет - для цена поставщика
         ParamAdd(Params,'OperDate_ReturnOut',ftDateTime);// Дата для цены возврат поставщику
         ParamAdd(Params,'PricePartner',ftFloat);         // цена поставщика - ввод в контроле
         ParamAdd(Params,'SummPartner',ftFloat);         // цена поставщика - ввод в контроле
         ParamAdd(Params,'PriceIncome',ftFloat);          // цена по спецификации
         ParamAdd(Params,'AmountPartnerSecond',ftFloat);  // Кол-во поставщика

     end
     else
     begin
         ParamAdd(Params,'MovementItemId',ftInteger);    // Id строки
         ParamAdd(Params,'GoodsId',ftInteger);           // Товары
         ParamAdd(Params,'GoodsCode',ftInteger);         // Товары
         ParamAdd(Params,'GoodsName',ftString);          // Товары
         ParamAdd(Params,'GoodsKindId',ftInteger);       // Виды товаров
         ParamAdd(Params,'GoodsKindCode',ftInteger);     // Виды товаров
         ParamAdd(Params,'GoodsKindName',ftString);      // Виды товаров
         ParamAdd(Params,'StorageLineId',ftInteger);     // Линия пр-ва
         ParamAdd(Params,'StorageLineCode',ftInteger);   // Линия пр-ва
         ParamAdd(Params,'StorageLineName',ftString);    // Линия пр-ва

         ParamAdd(Params,'GoodsKindId_list',ftString);   // Виды товаров
         ParamAdd(Params,'GoodsKindName_List',ftString); // Виды товаров

         ParamAdd(Params,'GoodsKindId_max',ftInteger);   // Виды товаров
         ParamAdd(Params,'GoodsKindCode_max',ftInteger); // Виды товаров
         ParamAdd(Params,'GoodsKindName_max',ftString);  // Виды товаров

         ParamAdd(Params,'MeasureId',ftInteger);         // Единица измерения
         ParamAdd(Params,'MeasureCode',ftInteger);       // Единица измерения
         ParamAdd(Params,'MeasureName',ftString);        // Единица измерения

         ParamAdd(Params,'isWeight_gd',ftBoolean);       // Схема - втулки
         ParamAdd(Params,'Weight_gd',ftFloat);           // Вес товара
         ParamAdd(Params,'WeightTare_gd',ftFloat);       // Вес втулки
         ParamAdd(Params,'CountForWeight_gd',ftFloat);   // Кол. для Веса
         ParamAdd(Params,'WeightPackageSticker_gd',ftFloat);//  вес 1-ого пакета -  Вес пакета для печ.ЭТИКЕТКИ

         ParamAdd(Params,'OperCount',ftFloat);           // Количество (с учетом: минус тара и прочее)
         ParamAdd(Params,'RealWeight_Get',ftFloat);      //
         ParamAdd(Params,'RealWeight',ftFloat);          // Реальный вес (без учета: минус тара и прочее)
         ParamAdd(Params,'WeightTare',ftFloat);          // Вес тары
         ParamAdd(Params,'WeightOther',ftFloat);         // Вес, прочее
         ParamAdd(Params,'CountSkewer1',ftFloat);        // Количество шпажек/крючков вида1
         ParamAdd(Params,'CountSkewer2',ftFloat);        // Количество шпажек/крючков вида2
         ParamAdd(Params,'Count',ftFloat);               // Количество батонов

         ParamAdd(Params,'CountPack',ftFloat);           // Количество упаковок - Флоупак +  Нар.180 + Нар. 200
         ParamAdd(Params,'WeightPack',ftFloat);          // Вес 1-ой упаковки - Флоупак +  Нар.180 + Нар. 200
         ParamAdd(Params,'NamePack',ftString);           // Название 1-ой упаковки - Флоупак +  Нар.180 + Нар. 200

         ParamAdd(Params,'HeadCount',ftFloat);           // Количество голов
         ParamAdd(Params,'LiveWeight',ftFloat);          // Живой вес
         ParamAdd(Params,'PartionGoods',ftString);       //
         ParamAdd(Params,'PartionGoodsDate',ftDateTime); //
         ParamAdd(Params,'isStartWeighing',ftBoolean);   //локальный параметр
         ParamAdd(Params,'isEnterCount',ftBoolean);      //всегда ввод кол-ва - надо для тары

         ParamAdd(Params,'CountTare1',ftFloat);          // Количество тары вида1
         ParamAdd(Params,'CountTare2',ftFloat);          // Количество тары вида2
         ParamAdd(Params,'CountTare3',ftFloat);          // Количество тары вида3
         ParamAdd(Params,'CountTare4',ftFloat);          // Количество тары вида4
         ParamAdd(Params,'CountTare5',ftFloat);          // Количество тары вида5
         ParamAdd(Params,'CountTare6',ftFloat);          // Количество тары вида6
         ParamAdd(Params,'CountTare7',ftFloat);          // Количество тары вида6
         ParamAdd(Params,'CountTare8',ftFloat);          // Количество тары вида6
         ParamAdd(Params,'CountTare9',ftFloat);          // Количество тары вида6
         ParamAdd(Params,'CountTare10',ftFloat);          // Количество тары вида6

         ParamAdd(Params,'Amount_Goods',ftFloat);        //

         ParamAdd(Params,'PartionCellId',ftInteger);       //
         ParamAdd(Params,'PartionCellName',ftString);      //

     end;
     //
     if SettingMain.isSticker = TRUE then
     begin
          ParamAdd(Params,'isStartEnd_Sticker',ftBoolean);       //1 - печатать дату нач/конечн произв-ва на этикетке
          ParamAdd(Params,'isTare_Sticker',ftBoolean);           //2 - печатать для ТАРЫ
          ParamAdd(Params,'isPartion_Sticker',ftBoolean);        //3 - печатать ПАРТИЮ для тары
          ParamAdd(Params,'isGoodsName_Sticker',ftBoolean);      //печатать название тов. (для режим 2,3)
          ParamAdd(Params,'DateStart_Sticker',ftDateTime);       //нач. дата (для режим 1)
          ParamAdd(Params,'DateTare_Sticker',ftDateTime);        //дата для тары  (для режим 2)
          ParamAdd(Params,'DatePack_Sticker',ftDateTime);        //дата упаковки  (для режим 3)
          ParamAdd(Params,'DateProduction_Sticker',ftDateTime);  //дата произв-ва (для режим 3)
          ParamAdd(Params,'NumPack_Sticker',ftFloat);            // № партии  упаковки, по умолчанию = 1 (для режим 3)
          ParamAdd(Params,'NumTech_Sticker',ftFloat);            // № смены технологов, по умолчанию = 1 (для режим 3)
     end;
end;
{------------------------------------------------------------------------}
procedure Create_ParamsAsset(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'MovementItemId', ftInteger);   //
     ParamAdd(Params,'Id', ftInteger);   //
     ParamAdd(Params,'Code', ftInteger); //
     ParamAdd(Params,'Name', ftString);  //
     ParamAdd(Params,'InvNumber', ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsArticleLoss(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'MovementId', ftInteger);   //
     ParamAdd(Params,'ArticleLossId', ftInteger);   //
     ParamAdd(Params,'ArticleLossCode', ftInteger); //
     ParamAdd(Params,'ArticleLossName', ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsPartionCell(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'PartionCellId', ftInteger);   //
     ParamAdd(Params,'PartionCellCode', ftInteger); //
     ParamAdd(Params,'PartionCellName', ftString);  //
     ParamAdd(Params,'InvNumber', ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsPersonal(var Params:TParams;idx:String);
begin
     if (idx = '') or (idx = '1') then Params:=nil;

     ParamAdd(Params,'PersonalId'+idx, ftInteger);   //
     ParamAdd(Params,'PersonalCode'+idx, ftInteger); //
     ParamAdd(Params,'PersonalName'+idx, ftString);  //
     ParamAdd(Params,'PositionId'+idx, ftInteger);   //
     ParamAdd(Params,'PositionCode'+idx, ftInteger); //
     ParamAdd(Params,'PositionName'+idx, ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsPersonal_Stick(var Params:TParams;idx:String);
begin
     //if (idx = '') or (idx = '1') then Params:=nil;

     ParamAdd(Params,'PersonalId'+idx+'_Stick', ftInteger);   //
     ParamAdd(Params,'PersonalCode'+idx+'_Stick', ftInteger); //
     ParamAdd(Params,'PersonalName'+idx+'_Stick', ftString);  //
     ParamAdd(Params,'PositionId'+idx+'_Stick', ftInteger);   //
     ParamAdd(Params,'PositionCode'+idx+'_Stick', ftInteger); //
     ParamAdd(Params,'PositionName'+idx+'_Stick', ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsPersonalComplete(var Params:TParams);
begin
     Create_ParamsPersonal(Params, '1');
     Create_ParamsPersonal(Params, '2');
     Create_ParamsPersonal(Params, '3');
     Create_ParamsPersonal(Params, '4');
     Create_ParamsPersonal(Params, '5');
     Create_ParamsPersonal_Stick(Params, '1');
     ParamAdd(Params,'MovementId', ftInteger);
     ParamAdd(Params,'InvNumber',ftString);
     ParamAdd(Params,'OperDate',ftDateTime);
     ParamAdd(Params,'OperDatePartner',ftDateTime);
     ParamAdd(Params,'MovementDescId',ftInteger);
     ParamAdd(Params,'FromName',ftString);
     ParamAdd(Params,'ToName',ftString);
end;
{------------------------------------------------------------------------}
procedure Create_ParamsWorkProgress(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'OperDate',ftDateTime);         //
     ParamAdd(Params,'UnitId',ftInteger);            //
     ParamAdd(Params,'DocumentKindId',ftInteger);    //
     ParamAdd(Params,'GoodsId',ftInteger);           // Товары
     ParamAdd(Params,'GoodsCode',ftInteger);         // Товары
     ParamAdd(Params,'GoodsName',ftString);          // Товары
     ParamAdd(Params,'MeasureId',ftInteger);         //
     ParamAdd(Params,'MeasureCode',ftInteger);       //
     ParamAdd(Params,'MeasureName',ftString);        //
     ParamAdd(Params,'MovementItemId',ftInteger);    //
     ParamAdd(Params,'MovementInfo',ftString);       //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsGoodsLine(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'GoodsId',ftInteger);           // Товары
     ParamAdd(Params,'GoodsCode',ftInteger);         // Товары
     ParamAdd(Params,'GoodsName',ftString);          // Товары
     ParamAdd(Params,'GoodsKindId',ftInteger);       //
     ParamAdd(Params,'GoodsKindCode',ftInteger);     //
     ParamAdd(Params,'GoodsKindName',ftString);      //
     ParamAdd(Params,'PartionGoodsId',ftInteger);    //
     ParamAdd(Params,'PartionGoodsName',ftString);   //
     ParamAdd(Params,'MeasureId',ftInteger);         //
     ParamAdd(Params,'MeasureCode',ftInteger);       //
     ParamAdd(Params,'MeasureName',ftString);        //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsReason(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'Id', ftInteger);   //
     ParamAdd(Params,'Code', ftInteger); //
     ParamAdd(Params,'Name', ftString);  //
     ParamAdd(Params,'ReturnKindName', ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsReReturnIn(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'MovementId', ftInteger);   //
     ParamAdd(Params,'InvNumber', ftString); //
     ParamAdd(Params,'OperDate', ftDate);  //
     ParamAdd(Params,'PartnerName', ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsSubjectDoc(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'SubjectDocId', ftInteger);   //
     ParamAdd(Params,'SubjectDocCode', ftInteger); //
     ParamAdd(Params,'SubjectDocName', ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsGuide(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'GuideId', ftInteger);   //
     ParamAdd(Params,'GuideCode', ftInteger); //
     ParamAdd(Params,'GuideName', ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsPersonalGroup(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'UnitId', ftInteger);   //
     ParamAdd(Params,'PersonalGroupId', ftInteger);   //
     ParamAdd(Params,'PersonalGroupCode', ftInteger); //
     ParamAdd(Params,'PersonalGroupName', ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsUnit_OrderInternal(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'UnitId', ftInteger);   //
     ParamAdd(Params,'UnitCode', ftInteger); //
     ParamAdd(Params,'UnitName', ftString);  //
     ParamAdd(Params,'UnitId_to', ftInteger);   //
     ParamAdd(Params,'UnitCode_to', ftInteger); //
     ParamAdd(Params,'UnitName_to', ftString);  //
     ParamAdd(Params,'BarCode', ftString);  //
end;
{------------------------------------------------------------------------}
{------------------------------------------------------------------------}
{------------------------------------------------------------------------}
{------------------------------------------------------------------------}
function GetArrayList_Value_byName(ArrayList:TArrayList;Name:String):String;
var i: Integer;
begin
  Result:='';
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Name = Name then begin Result:=AnsiUpperCase(ArrayList[i].Value);break;end;
end;
{------------------------------------------------------------------------}
function GetArrayStickerFileList_Index_byName (ArrayList:TArrayStickerFileList;FileName:String):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].FileName = FileName then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayStickerFileList_Index_byName_70_70 (ArrayList:TArrayStickerFileList;FileName_70_70:String):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].FileName_70_70 = FileName_70_70 then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_Index_byNumber(ArrayList:TArrayList;Number:Integer):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Number = Number then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_Index_byCode(ArrayList:TArrayList;Code:Integer):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Code = Code then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_Index_byName(ArrayList:TArrayList;Name:String):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Name = Name then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_Index_byValue(ArrayList:TArrayList;Value:String):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if (ArrayList[i].Value = Value)
       or ((myStrToFloat(ArrayList[i].Value) = myStrToFloat(Value))
           and (myStrToFloat(Value) <> 0))
    then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_lpIndex_GoodsKind(ArrayList:TArrayList;GoodsKindWeighingGroupId,Code:Integer):Integer;
var i,ii: Integer;
begin
  Result:=-1;
  ii:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Number = GoodsKindWeighingGroupId
    then begin
              ii:=ii+1;
              if (ArrayList[i].Code = Code)or(Code<=0) then begin Result:=ii;break;end;
         end;
end;
{------------------------------------------------------------------------}
function GetArrayList_gpIndex_GoodsKind(ArrayList:TArrayList;GoodsKindWeighingGroupId,lpIndex:Integer):Integer;
var i,ii: Integer;
begin
  Result:=-1;
  ii:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Number = GoodsKindWeighingGroupId
    then begin
              ii:=ii+1;
              if (ii = lpIndex)or(lpIndex<0) then begin Result:=i;break;end;
         end;
end;
{------------------------------------------------------------------------}
function isEqualFloatValues(Value1,Value2:Double):boolean;
begin
     Result:=abs(Value1-Value2)<0.0001;
end;
{------------------------------------------------------------------------}
procedure MyDelay(mySec:Integer);
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
//     calcSec:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
//     calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec:=Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec2:=Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
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
//          calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
          calcSec2:=Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
     end;
end;
{------------------------------------------------------------------------------}
procedure MyDelay_two(mySec:Integer);
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
//     calcSec:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
//     calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec:=Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec2:=Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     while abs(calcSec-calcSec2)<mySec do
     begin
          Present:=Now;
          DecodeDate(Present, Year, Month, Day);
          DecodeTime(Present, Hour, Min, Sec, MSec);
          //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
//          calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
          calcSec2:=Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     end;
end;
{------------------------------------------------------------------------------}
// создает TParam с названием поля _Name и типом _DataType и добавляет к TParams
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
// создает TParam с названием поля _Name и типом _DataType и добавляет к TParams со значением _Value
procedure ParamAddValue(var execParams: TParams;_Name:String;_DataType:TFieldType;_Value: variant);
begin
  if not Assigned(execParams) then execParams:=TParams.Create;
  ParamAdd(execParams,_Name,_DataType);
  execParams.Items[GetIndexParams(execParams,_Name)].Value:=_Value;
end;
{------------------------------------------------------------------------------}
function GetIndexParams(execParams:TParams;FindName:String):Integer;//возвращаят индекс парамтра сназванием FindName в TParams
var i:Integer;
begin
  Result:=-1;
  if not Assigned(execParams) then exit;
  for i:=0 to execParams.Count-1 do
          if UpperCase(execParams[i].Name)=UpperCase(FindName)then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------------}
procedure CopyValuesParamsFrom(var fromParams,toParams:TParams);
var i:Integer;
begin
   if not Assigned(fromParams)then exit;
   with fromParams do
    for i:=0 to Count-1 do toParams.ParamValues[Items[i].Name]:=ParamValues[Items[i].Name];
end;
{------------------------------------------------------------------------------}
procedure EmptyValuesParams(var execParams:TParams);
var i:Integer;
begin
   if not Assigned(execParams)then exit;
   with execParams do
    for i:=0 to Count-1 do
    begin
         if execParams[i].DataType=ftBoolean
         then execParams.ParamByName(Items[i].Name).AsBoolean:=false
         else
             if execParams[i].DataType=ftInteger
             then execParams.ParamByName(Items[i].Name).AsInteger:=0
             else
                 if execParams[i].DataType=ftFloat
                 then execParams.ParamByName(Items[i].Name).AsFloat:=0
                 else
                    if (execParams[i].DataType<>ftDate) and (execParams[i].DataType<>ftDateTime)
                    then execParams.ParamByName(Items[i].Name).AsString:='';
    end;
end;
{------------------------------------------------------------------------------}
function CheckBarCode(BarCode:String):Boolean;
var Summ:String;
    Summ_show:String;
begin
     Summ:=CalcBarCode(BarCode);
     Result:=(Summ<>'')and(LengTh(BarCode)=13);
     if not Result then exit;
     //
     Result:=BarCode[13]=Summ;

     if UserId_begin = 5
     then Summ_show:='('+Summ+')'
     else Summ_show:='';

     if not Result then ShowMessage('Ошибка в значении <Штрих код> = <'+BarCode+'>.'+Summ_show);
end;
{------------------------------------------------------------------------------}
function CalcBarCode(BarCode:String):String;
var Summ:Integer;
begin
     if LengTh(BarCode)>=12
     then
     try Summ:=   StrToInt(BarCode[1])+StrToInt(BarCode[3])+StrToInt(BarCode[5])+StrToInt(BarCode[7])+StrToInt(BarCode[9])+StrToInt(BarCode[11])
              +3*(StrToInt(BarCode[2])+StrToInt(BarCode[4])+StrToInt(BarCode[6])+StrToInt(BarCode[8])+StrToInt(BarCode[10])+StrToInt(BarCode[12]));
     except Summ:=-1;end
     else Summ:=-1;
     //
     if Summ>0 then
     begin
          Summ:=Summ mod 10;
          if Summ<>0 then Summ:=10-Summ;
     end
     else Summ:=-1;
     //
     if Summ <> -1
     then Result:=IntToStr(Summ)
     else Result:='';
end;
{------------------------------------------------------------------------------}
function myStrToFloat(Value:String):Double;
begin
     Value:=trim(Value);
     //
     try
         if (System.Pos('.',Value)>0)and(DecimalSeparator<>'.')
         then Result:=StrToFloat(myReplaceStr(Value,'.',DecimalSeparator))
         else if (System.Pos(',',Value)>0)and(DecimalSeparator<>',')
              then Result:=StrToFloat(myReplaceStr(Value,',',DecimalSeparator))
              else Result:=StrToFloat(Value);
     except
            Result:=0;
     end;
end;
{------------------------------------------------------------------------------}
function myReplaceStr(const S, Srch, Replace: string): string;
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
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
function zf_Calc_Word_bySeparate(myStr,Sep1,Sep2:String;myWordNumber:smallint):String;
var i,finSeparate:Integer;
    findIndex,findIndex_next:Integer;
begin
     if myWordNumber<=0 then begin Result:='';exit;end;
     //
     finSeparate:=0;
     findIndex:=0;
     findIndex_next:=0;
     for i:=1 to LengTh(myStr) do begin
        if (myStr[i]=Sep1)or(myStr[i]=Sep2) then finSeparate:=finSeparate+1;
        if (finSeparate=myWordNumber-1)and(findIndex=0) then findIndex:=i;
        if (finSeparate=myWordNumber)and(findIndex_next=0) then findIndex_next:=i;
     end;
     try
        if myWordNumber=1 then if findIndex_next=0 then Result:=myStr else Result:=System.Copy(myStr,findIndex,findIndex_next-1)
        else if (myWordNumber>finSeparate+1) then Result:=''
             else if findIndex_next=0 then Result:=System.Copy(myStr,findIndex+1,LengTh(myStr)-findIndex)
                  else Result:=System.Copy(myStr,findIndex+1,findIndex_next-findIndex-1);
        except ShowMessage('zf_Calc_Word_bySeparate<'+myStr+'><'+IntToStr(myWordNumber)+'>');
               Result:='';
     end;
end;
{------------------------------------------------------------------------------}
function zf_Calc_WordCount_bySeparate(myStr,Sep1,Sep2:String):smallint;
var i:Integer;
begin
     Result:=0;
     for i:=1 to LengTh(myStr) do
        if (myStr[i]=Sep1)or(myStr[i]=Sep2) then Result:=Result+1;
     //
     if trim(myStr)<>'' then Result:=Result+1;
end;
{------------------------------------------------------------------------------}
function myCalcPartionGoods(PartionStr:String):String;
var myPartionDate,myClientStr,myGoodsMainStr,myOperInfoStr:String;
    myDay_str,myMonth_str,myYear_str:String;
    myDay,myMonth,myYear:Word;
    myBillDate:TDateTime;
    Year, Month, Day: Word;
    myWordCount,myWordCountD:smallint;
begin
     PartionStr:=trim(PartionStr);
     //
     myWordCountD:=zf_Calc_WordCount_bySeparate(PartionStr,'.','xxxxxxxxx');
     if myWordCountD=1 then
     try
         myWordCountD:=zf_Calc_WordCount_bySeparate(PartionStr,'-','xxxxxxxxx');
         myMonth:=StrToInt(zf_Calc_Word_bySeparate(PartionStr,'-','.',myWordCountD));
         myBillDate:=ParamsMovement.ParamByName('OperDate').AsDateTime;
         DecodeDate(myBillDate, Year, Month, Day);
         if Month>=myMonth then myYear:=Year else myYear:=Year-1;
         PartionStr:=PartionStr+'-'+IntToStr(myYear)
     except
     end;
     //
     myWordCount:=zf_Calc_WordCount_bySeparate(PartionStr,'-','.');
     //
     myClientStr:=zf_Calc_Word_bySeparate(PartionStr,'-','.',myWordCount-3);//System.Copy(PartionStr,1,3);

     myOperInfoStr:='';
     if myWordCount=4
     then myGoodsMainStr:=''
     else if myWordCount=5
          then myGoodsMainStr:=zf_Calc_Word_bySeparate(PartionStr,'-','.',1)
          else if myWordCount=6
               then begin myGoodsMainStr:=zf_Calc_Word_bySeparate(PartionStr,'-','.',2);
                          myOperInfoStr:=zf_Calc_Word_bySeparate(PartionStr,'-','.',1);
                    end
          else begin Result:='';exit;end;
     //
     try
         myDay:=StrToInt(zf_Calc_Word_bySeparate(PartionStr,'-','.',myWordCount-2));//StrToInt(System.Copy(PartionStr,5,2));
         myMonth:=StrToInt(zf_Calc_Word_bySeparate(PartionStr,'-','.',myWordCount-1));//StrToInt(System.Copy(PartionStr,8,2));
         myBillDate:=ParamsMovement.ParamByName('OperDate').AsDateTime;
         DecodeDate(myBillDate, Year, Month, Day);
         if Month>=myMonth then myYear:=Year else myYear:=Year-1;
     except
           myBillDate:=StrToDate('01.01.2000');
           myMonth:=0;
           myYear:=0;
     end;
     //
     if myDay  <10  then myDay_str:=  '0'  +IntToStr(myDay)   else myDay_str:=   IntToStr(myDay);
     if myMonth<10  then myMonth_str:='0'  +IntToStr(myMonth) else myMonth_str:= IntToStr(myMonth);
     if myYear <100 then myYear_str:= '20' +IntToStr(myYear)  else myYear_str:=  IntToStr(myYear);
     if myYear <10  then myYear_str:= '200'+IntToStr(myYear)  else myYear_str:=  IntToStr(myYear);

     myPartionDate:=myDay_str+'.'+myMonth_str+'.'+myYear_str;
     //
     try if (StrToDate(myPartionDate)>myBillDate)//or(abs(StrToDate(myPartionDate)-myBillDate)>31)
         then Result:=''
         else if myOperInfoStr<>'' then Result:=myOperInfoStr+'-'+myGoodsMainStr+'-'+myClientStr+'-'+myPartionDate
              else if myGoodsMainStr<>'' then Result:=myGoodsMainStr+'-'+myClientStr+'-'+myPartionDate
                   else Result:=myClientStr+'-'+myPartionDate;//ReplaceStr(myPartionDate,'.','.')
     except Result:=''
     end;
end;
//------------------------------------------------------------------------------------------------
function Recalc_PartionGoods(Edit:TEdit):Boolean;
var PartionGoods:String;
begin
        if ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
        //and(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Income)
        //and (Pos('.',Edit.Text) = 0)
        //and (Pos('-',Edit.Text) = 0)

        then Result:=true

        else
        if  (trim(Edit.Text)<>'')
        and((ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Sale)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_ReturnIn)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Loss)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Inventory)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Send)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_ProductionUnion)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_ProductionSeparate)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_ReturnOut)
           )
        and(SettingMain.isPartionDate = FALSE)
        //and((SettingMain.BranchCode < 301) or (SettingMain.BranchCode > 310))
        then begin
                  PartionGoods:=myCalcPartionGoods(Edit.Text);
                  Result:=PartionGoods<>'';
                  if Result then Edit.Text:=PartionGoods;
        end
        else begin
                  Result:=true;
                  if SettingMain.isPartionDate = FALSE then Edit.Text:='';
             end;
end;
{------------------------------------------------------------------------------}
function gpCheck_BranchCode: Boolean;
begin
    Result:=((SettingMain.isCeh = FALSE) and (((SettingMain.BranchCode >= 201) and (SettingMain.BranchCode <= 210))
                                           or ((SettingMain.BranchCode >= 301) and (SettingMain.BranchCode <= 310))
                                           or (SettingMain.BranchCode < 100)
                                           or ((SettingMain.BranchCode >= 101) and (SettingMain.BranchCode <= 330))
                                             ))
          or((SettingMain.isCeh = TRUE) and ((SettingMain.BranchCode = 1) or ((SettingMain.BranchCode > 100) and (SettingMain.BranchCode < 1000))))
          or((SettingMain.isSticker = TRUE) and (SettingMain.BranchCode > 1000))
          ;
    //
    if not Result
    then ShowMessage('Ошибка.Запуск программы для филиала <'+IntToStr(SettingMain.BranchCode)+'> не предусмотрен.');
end;
{------------------------------------------------------------------------}
end.
