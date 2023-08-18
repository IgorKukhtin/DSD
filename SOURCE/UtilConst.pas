{$J+} {параметр компилятоcoра, позволяющий менять типизированные константы}
unit UtilConst;
interface
uses Classes, SysUtils;
Type

  TdsdMovementStatus = (mtUncomplete, mtComplete, mtDelete);
  TdsdProject = (prProject, prFarmacy, prBoutique, prBoat);

var
  dsdProject: TdsdProject;
  MovementStatus: Array[TdsdMovementStatus] of string = ('Не проведен', 'Проведен', 'Удален');

  ConnectionPath: string = '..\init\init.php';
  SQLiteFile: string = '';
  LocalFCSStart: string = '';
  isRunReport524: boolean = False;

//  EnumPath: string = '..\DATABASE\COMMON\METADATA\Enum\';
//  ProcedurePath: string = '..\DATABASE\COMMON\PROCEDURE\';
//  LocalProcedurePath: string = '..\DATABASE\COMMON\PROCEDURE\';
//  FunctionPath: string = '..\DATABASE\COMMON\Function\';
//  ReportsPath: string = '..\DATABASE\COMMON\Reports\';
//  ViewPath: string = '..\DATABASE\COMMON\View\';
//  LocalViewPath: string = '..\DATABASE\MEAT\View\';
//  ProcessPath: string = '..\DATABASE\COMMON\PROCESS\';
//  LocalProcessPath: string = '..\DATABASE\COMMON\PROCESS\';
//  gc_AdminPassword: string = 'Admin';


{$IFDEF Boutique}
  EnumPath: string = '..\DATABASE\Boutique\METADATA\Enum\';
  ProcedurePath: string = '..\DATABASE\Boutique\PROCEDURE\';
  LocalProcedurePath: string = '..\DATABASE\Boutique\PROCEDURE\';
  FunctionPath: string = '..\DATABASE\Boutique\Function\';
  ReportsPath: string = '..\DATABASE\Boutique\Reports\';
  ViewPath: string = '..\DATABASE\Boutique\View\';
  LocalViewPath: string = '..\DATABASE\Boutique\View\';
  ProcessPath: string = '..\DATABASE\Boutique\PROCESS\';
  LocalProcessPath: string = '..\DATABASE\Boutique\PROCESS\';
  gc_AdminPassword: string = 'Admin';

{$ELSE}
  EnumPath: string = '..\DATABASE\COMMON\METADATA\Enum\';
  ProcedurePath: string = '..\DATABASE\COMMON\PROCEDURE\';
  LocalProcedurePath: string = '..\DATABASE\COMMON\PROCEDURE\';
  FunctionPath: string = '..\DATABASE\COMMON\Function\';
  ReportsPath: string = '..\DATABASE\COMMON\Reports\';
  ViewPath: string = '..\DATABASE\COMMON\View\';
  LocalViewPath: string = '..\DATABASE\MEAT\View\';
  ProcessPath: string = '..\DATABASE\COMMON\PROCESS\';
  LocalProcessPath: string = '..\DATABASE\COMMON\PROCESS\';
  gc_AdminPassword: string = 'Admin';

{$ENDIF}




  LocalFormatSettings: TFormatSettings;
  {константы времени}
  gc_DateStart: TDateTime;
  gc_DateEnd: TDateTime;

  function ShiftDown : Boolean;
  function CtrlDown : Boolean;
  function AltDown : Boolean;

const

  gc_isDebugMode: boolean = false; {режим отладки}
  gc_isShowTimeMode: boolean = false; {режим времени}
  gc_isSetDefault: boolean = false;
  gc_Minute : real = (1/24)/60;
  gc_Test : boolean = false; {константа - тест ли это}
  gc_NewFormTest : boolean = false; {вставлять ли формы по новому}
  gc_ShowChangesOnTest: boolean = false;
  {константы для Эдитора}
  {используемые в программе фреймы}
  gc_ftGridFrame     =   'TGridFrame';
  gc_ftPanelFrame    =   'TPanelFrame';
  gc_ftPageControlFrame    =   'TPageControlFrame';
  gc_ftGuideFrame    =   'TGuideFrame';
  gc_ftCycleGuideFrame    =   'CycleGuideTFrame';
  gc_ftFloatFrame    =   'TFloatFrame';
  gc_ftSummaFrame = 'TSummaFrame';
  gc_ftEditFrame    =   'TEditFrame';
  gc_ftCheckBoxFrame    =   'TCheckBoxFrame';
  gc_ftDateFrame    =   'TDateFrame';
  gc_ftPrintDataSetFrame    =   'TPrintDataSetFrame';
  gc_ftDBTreeViewFrame   =   'TDBTreeViewFrame';

  {МОЛОКО}
  gcBasicMilk = 'BasicMilk';
  gcBasicProtein = 'BasicProtein';
  gc_BasicMilk = 3.4;
  gc_BasicProtein = 3;

  {различные константы системы в алфавитном порядке
   на русском языке
  }
  gc_ruFramePaletteName = 'Фрейм';
  gc_ruPaletteFormCaption = 'Палитра компонент';

  gc_ruGridFrame     =   'Таблица';
  gc_ruPanelFrame    =   'Панель';
  gc_ruGuideFrame    =   'Выбор из спр.';
  gc_ruCycleGuideFrame    =   'Циклич. перебор';
  gc_ruFloatFrame    =   'TFloat';
  gc_ruEditFrame    =   'TEdit';
  gc_ruCheckBoxFrame    =   'Флажок';
  gc_ruDateFrame    =   'Дата';
  gc_ruPrintDataSetFrame    =   'Данные для отчета';
  gc_ruDBTreeViewFrame   =   'Дерево';



  {форматы}
//  gc_frmtDateFormat = 'dd.MM.yy';

  {константы базы данных}
  zc_EnumKindStatusProcess = 'KindStatusProcess';
  zc_EnumKindStatusComplete = 'KindStatusComplete';

  zc_EnumKindStatusProcessID = '12';
  zc_EnumKindStatusCompleteID = '13';

  zc_EnumKindStatusProcessName = 'на исполнении';
  zc_EnumKindStatusCompleteName = 'проведен';



  zc_ItemIncomeMilk = '_ItemIncome_Goods';
  zc_ItemTransferMilkIn = '_ItemTransferIn_Goods';
  zc_ItemProductionSeparateIn = '_ItemProductionSeparateIn_Goods';
  zc_ItemProductionUnionIn = '_ItemProductionUnionIn_Goods';


  {временные константы - должны быть обязательно со времеенм удалены}
//  gc_delPrefix = 'Prefix';
  gcCurrentObjectName   :string = '';
  gcCurrentComputerName :string = '';
  gcConnectionParam   :string = '';
  gcReportPath: string = '';
  gcisErased = 'isErased';
  gcStatus = 'StatusItemName';
  gc_Yes = 'yes';
  gc_No = 'no';

  gc_clEditColumnColor=$00F0F0F0;
  gc_clCurrentRecordColumnColor=$00FFFCD7;

  {константа нормального выполнения процедуры}
  gc_Ok = 'Ok';

  {текущая сессия}
  gc_CurrentSession : string = '';
  {название группы, в которую входит пользователь}
  gcUserGroup: string = '';
  {имя пользователя}
  gcUser: string = '';


  {константы расположены в алф. порядке}
  gcActiveControl = 'ActiveControl';
  gcAutoCreateForm = 'AutoCreateForm';
  gcButtonAction = 'ButtonAction';
  gcButtonCategory = 'Category';
  gcButtonName = 'ButtonName';
  gcButtons = 'Buttons';
  gcButtonSet = 'ButtonSet';
  gcButtonType = 'ButtonType';
  gcCallForm = 'CallForm';
  gcCallFrame = 'CallFrame';
  gcCaption ='Caption';
  gcCDS = 'CDS';
  gcColor = 'Color';
  gcConstValue = 'ConstantValue';
  gcConditionValue = 'ConditionValue';
  gcControl = 'Control';
  gcCopyRecord = 'CopyRecord';
  gcDataSet = 'DataSet';
  gcDataType = 'DataType';
  gcDeleteProcs = 'DeleteProcs';
  gcDeleteUnerasedProcs = 'DeleteUnerasedProcs';
  gcDefaultValue = 'DefaultValue';
  gcDisplayFormat ='DisplayFormat';
  {хранится формат отображения }
  gcDisplayFormatNumeric = ',0.####;-,0.####; ';
  gcDisplayFormatCount = ',0;-,0; ';
  gcDisplayFormatTwoDitgit = ',0.##;-,0.##; ';
  gcEditFormatNumeric = '#.###########';
  gcEditFormParams = 'EditFormParams';
  gcEmptyGuide = '0';
  gcNotDataComplete = 'Не выбрано значение справочника ';
  gcDisplayFormatDateTime = 'dd.MM.yy hh:mm';
  gcDocument = 'Document';
  gcDocumentName = 'DocumentName';

  gcDriverTypeADO = 'ADO';
  gcDriverTypeBDE = 'BDE';
  gcDriverTypeSQLDirect = 'SQLDIRECT';

  gcDS = 'DS';
  gcEdit = 'Edit';
  gcEditNode = 'EditNode';
  gcEditMode = 'EditMode';
  gcEmptyValue = 'нет данных'; {устанавливается в свойство Guide.Text, когда ID указаан, но небыло обновления данных}
  gcExecuteXMLParamName = 'ExecuteXMLParamName';
  gcFalse = 'false';
  gcFieldName = 'FieldName';
  gcFieldPrefixName = 'FieldPrefixName';
  gcFieldSet = 'FieldSet';
    {цвет отфильтрованного грида}
  gcFilteredGridColor=$00E2E2E2;
  gcForm = 'Form';
  gcFormType = 'FormType';
  gcFrame = 'Frame';
  gcFrameName = 'FrameName';
  gcFrames = 'Frames';
  gcFrameType = 'FrameType';
  gcFrameValueType = 'FrameValueType';
  gcfrDS = 'frDS';
  gcHeight = 'Height';
  gcGetResultSet = 'GetResultSet';
  gcImageIndex = 'ImageIndex';
  gcIsNeedGuideInitialize='IsNeedGuideInitialize';
  gcIsProcedure ='IsProcedure';
  gcIsChoiceForm = 'gcIsChoiceForm'; {была ли форма вызвана для выбора значения}
  gcIsDialog = 'IsDialog';
  gcisSummOnFooter = 'isSummOnFooter';
  gcNeedReturnValue = 'NeedReturnValue';
  gcNeedStrongValue = 'NeedStrongValue';
  gckeyF = 70;
  gcKeyField = 'KeyField';
  gcKeyFieldId = 'Id';
  gcKeyFieldValue = 'KeyFieldValue';
  gcLeft = 'Left';
  gcLastLoginUser = 'LastLoginUser';
  gcLineCaption = '-';
  gcLinkFormSelectSet = 'LinkFormSelectSet';
  gcLinkFrames = 'LinkFrames';
  gcLoginInformation = 'LoginInformation';
  gcLoginUserName = 'LoginUserName';
  gcLookChanges = 'LookChanges';
  gcMainColumn = 'MainColumn';
  gcMainForm = 'MainForm';
  gcMasterName = 'MasterName';
  gcMasterFields = 'MasterFields';
  gcDetailFields = 'DetailFields';
  gcMenu = 'Menu';
  gcMenuPrefix = 'mi';
  gcMultiSelectGrid = 'MultiSelectGrid';
  gcMultiDataSet = 'MultiDataSet';
  gcNil = 'nil';
  gcName = 'Name';
  gcNewEditor: boolean = false;
  gcNoPreview = 'NoPreview';
  gcNotFound = -1;
  gcOnChangeData = 'OnChangeData';
  gcOpenExcel = 'OpenExcel';
  gcOpenForTuning = 'OpenForTuning';
  gcOutputType = 'OutputType';
  gcParams = 'Params';
  gcParamName = 'ParamName';
  gcParamNameInExecuteXML = 'ParamNameInExecuteXML';
  gcParamFrame = 'ParamFrame';
  gcParamField = 'ParamField';
  gcParentIdForInsert = 'ParentIdForInsert';
  gcParamType = 'ParamType';
  gcProcType = 'ProcType';
  gcProcedures = 'Procedures';
  gcQuot = '"';  
  gcOneQuot = char(39);
  gcPrefixSeparator = '_';
  gcReadOnly = 'ReadOnly';
  gcRefreshForm = 'RefreshForm';
  gcResult = 'Result';
  gcTabSetName = 'TabSetName'; 
  gcTemporary = 'Temporary';
  gcText = 'Text';
  gcTop = 'Top';
  gcTrue = 'true';
  gcSavedProp = 'SavedProp';
  gcSendResult = 'SendResult';
  gcSelectable = 'Selectable';
  gcSession = 'Session';
  gcSheets = 'Sheets';
  gcShortCut = 'ShortCut';
  gcSortIndex = 'SortIndex';
  gcSortFields = 'SortFields';
  gcSortMarker = 'SortMarker';
  gcSourceField = 'SourceField';
  gcSplitterSize = 8;
  gcStoredProcExec = 'StoredProcExec';
  gcMessageSeparator = '#$#$';
  gcServerSeparator = '~@~@';
  gcSelected = 'Selected';
  gcStoredProc = 'StoredProc';
  gcStatusLine = 'StatusLine';
  gcSaveResultSet = 'SaveResultSet';
  gcSummFieldName = 'SummFieldName';
  gcValue = 'Value';
  gcValueField = 'ValueField';
  gcValueDelimiter = '/';
  gcVisible = 'Visible';
  gcWidth = 'Width';
  gcWithButton = 'WithButton';
  gcUnknownType = 'UnknownType';
  gcUserGroupName = 'UserGroupName';
  gcUserInfo = 'UserInfo';
  gcUserName = 'UserName';

  {контсатнты для XML}
  gcEmptyXML = '<xml/>';
  gcXMLStart = '<xml>';
  gcXMLEnd = '</xml>';
  gcNodeStart = '<';
  gcNodeClose = '>';
  gcNodeEnd = '/>';
  gcXML = 'xml';
  gcXMLDelimiter = '.';
  gcXMLQuot = '&quot;';

  gctagObject = 'object';
  gctagName = 'name';
  gctagClass = 'class';

  {номера иконок для TreeView}
  gcFolderShut = 31;
  gcFolderOpen = 32;
  gcDeletedFolderShut = 36;
  gcDeletedFolderOpen = 37;

  {Обязательные параметры сторед процедур}
  gc_ListProcedure = '@ioListProcedure';
  gc_ListErrorCode = '@ioListErrorCode';
  gc_Session = '@inSession';

  {типы открытия формы редактирования}
  gcOpenFormType = 'OpenFormType'; {константа типа открытия формы}
  gc_frmInsert = 'frmInsert';
  gc_frmUpdate = 'frmUpdate';
  gc_frmMask = 'frmMask';
  gc_frmDialog = 'frmDialog';

  {типы параметров}
  gc_ptInput = 'ptInput';
  gc_ptInputOutput = 'ptInputOutput';
  gc_ptOutput = 'ptOutput';

  {типы выполнения сторед процедур для получения данных}
  gc_ptInsert = 'ptInsert'; {процедура выполняется при вставке}
  gc_ptUpdate = 'ptUpdate'; {процедура выполняется при редактировании}
  gc_ptMask = 'ptMask'; {процедура выполняется при добавлении по маске}
  gc_ptInsertUpdate = 'ptInsertUpdate'; {процедура выполняется и при редактировании и при вставке}

  gc_resCheckBoxChoiceChecked = 'Значение устанавливается';
  gc_resCheckBoxChoiceUnChecked = 'Значение не устанавливается';

  {названия параметров и полей}
  gcinDocumentName = '@inDocumentName';
  gcNodePath = 'NodePath';
  gcNode = 'Node';
  gcCommonParam ='CommonParam';
  gcUserParam = 'UserParam';



  {ДЛЯ РЕПОРТОВ}
  gc_repStatusProcess = 'StatusProcess';
  gc_repStatusComplete = 'StatusComplete';

  {ФОРМАТЫ}

  gc_frmtFloatCountFormat = gcOneQuot+ ',0.#######;-,0.#######'+gcOneQuot;
  gc_frmtFloatMoneyFormat = gcOneQuot+',0.00####;-,0.00####'+gcOneQuot;
  gc_frmtFloatPrecisionFormat = gcOneQuot+',0.######;-,0.######;'+gcOneQuot;
  gc_frmtFloatCountWithout0Format = gcOneQuot+ ',0.######;-,0.######; '+gcOneQuot;
  gc_frmtFloatMoneyWithout0Format = gcOneQuot+',0.00####;-,0.00####; '+gcOneQuot;
  gc_frmtFloatPrecisionWithout0Format = gcOneQuot+',0.######;-,0.######; '+gcOneQuot;
  gc_frmtFloatTwoDigitsFormat = gcOneQuot+',0.######' + gcOneQuot;
  gc_frmtFloatTwoDigitsWithout0Format = gcOneQuot+',0.######; ; ' + gcOneQuot;

  gc_frmtReportFloatCountWithout0Format = gcOneQuot+ ',0;-,0; '+gcOneQuot;
  gc_frmtReportFloatMoneyWithout0Format = gcOneQuot+',0.00;-,0.00; '+gcOneQuot;
  gc_frmtReportFloatMilkPrice = gcOneQuot+',0.00#'+gcOneQuot;
  gc_frmtReportFloatPrecisionMoney = gcOneQuot+',0.00##;-,0.00##; '+gcOneQuot;
  gc_frmtReportFloatFourWithout0Format = gcOneQuot+',0.####;-,0.####; '+gcOneQuot;
  gc_frmtReportFloatTwoWithout0Format = gcOneQuot+',0.##;-,0.##; '+gcOneQuot;
  gc_frmtReportFloatTwoOneWithout0Format = gcOneQuot+',0.0#;-,0.0#; '+gcOneQuot;

  gc_frmtDateTimeFormat = gcOneQuot+'dd.MM.yy hh:mm'+gcOneQuot;
  gc_frmtDateFormat = gcOneQuot+'dd.MM.yy'+gcOneQuot;
  gc_frmtShortDateFormat = gcOneQuot+'dd.MM'+gcOneQuot;
  gc_frmtTimeFormat = gcOneQuot+'hh:mm'+gcOneQuot;

  gc_fDateTimeFormat = 'dd.MM.yy hh:mm';
  gc_fDateFormat = 'dd.MM.yy';

  gc_FloatCountFormat = 'FloatCountFormat';
  gc_FloatMoneyFormat = 'FloatMoneyFormat';
  gc_FloatPrecisionFormat = 'FloatPrecisionFormat';

  gc_FloatCountWithout0Format = 'FloatCountWithout0Format';
  gc_FloatMoneyWithout0Format = 'FloatMoneyWithout0Format';
  gc_FloatPrecisionWithout0Format = 'FloatPrecisionWithout0Format';
  gc_FloatTwoDigitsFormat = 'FloatTwoDigitsFormat';
  gc_FloatTwoDigitsWithout0Format = 'FloatTwoDigitsWithout0Format';

  gc_ReportFloatCountWithout0Format = 'ReportFloatCountWithout0Format';
  gc_ReportFloatMoneyWithout0Format = 'ReportFloatMoneyWithout0Format';
  gc_ReportFloatFourWithout0Format = 'ReportFloatFourWithout0Format';
  gc_ReportFloatTwoWithout0Format = 'ReportFloatTwoWithout0Format';
  gc_ReportFloatTwoOneWithout0Format = 'ReportFloatTwoOneWithout0Format';
  gc_ReportFloatPrecisionMoney = 'ReportFloatPrecisionMoney';
  gc_ReportFloatMilkPrice = 'ReportFloatMilkPrice';

  gc_DateTimeFormat = 'DateTimeFormat';
  gc_DateFormat = 'DateFormat';
  gc_ShortDateFormat = 'ShortDateFormat';
  gc_TimeFormat = 'TimeFormat';
  gc_PeriodDate = 'PeriodDate';
  gc_PeriodDateTime = 'PeriodDateTime';
  gcSystemDecimalSeparator: string = '';
  {параметры ком. строки}
  gcAll = 'all'; {в лог-файл XMLLog.txt записываются все XML параметры, переданнные на 2-й уровень}
  gcError = 'error';{при возвращении ошибки со второго уровня в лог-файл XMLLog.txt записываются  XML параметры, переданнные на 2-й уровень}
  gcErrorMessage = 'ErrorMessage';
  gcErrorCode = 'ErrorCode';

  gcDefaultPath: string = '';
  gcLogFileName: string = '';
  {в данном листе хранятся те праметры, которые определяют пользовательские настройки}

implementation
uses Windows;

 function ShiftDown : Boolean;
 var
    State : TKeyboardState;
 begin
    GetKeyboardState(State) ;
    Result := ((State[vk_Shift] and 128) <> 0) ;
 end;

 function AltDown : Boolean;
 var
    State : TKeyboardState;
 begin
    GetKeyboardState(State) ;
    Result := ((State[vk_Menu] and 128) <> 0) ;
 end;

 function CtrlDown : Boolean;
 var
    State : TKeyboardState;
 begin
    GetKeyboardState(State) ;
    Result := ((State[vk_Control] and 128) <> 0) ;
 end;

initialization
  with LocalFormatSettings do begin
    DateSeparator:='.';
    ShortDateFormat:='dd.mm.yyyy';
  end;
    {константы времени}
  gc_DateStart:=StrToDate('01.01.1900', LocalFormatSettings);
  gc_DateEnd:=StrToDate('01.01.2500', LocalFormatSettings);
  gc_isShowTimeMode := false;
end.
