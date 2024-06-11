unit dsdAddOn;

{$I ..\dsdVer.inc}

interface

uses Windows, Winapi.Messages, Classes, cxDBTL, cxTL, Vcl.ImgList, cxGridDBTableView,
     cxTextEdit, DB, dsdAction, cxGridTableView, Dialogs, ComCtrls, cxDateNavigator,
     VCL.Graphics, cxGraphics, cxStyles, cxCalendar, Forms, Controls, DBClient,
     SysUtils, dsdDB, Contnrs, cxGridCustomView, cxGridCustomTableView, dsdGuides,
     VCL.ActnList, cxCustomPivotGrid, cxDBPivotGrid, cxEdit, cxCustomData, cxPC,
     GMClasses, GMMap, GMMapVCL, GMGeoCode, GMConstants, GMMarkerVCL, SHDocVw, ExtCtrls,
     Winapi.ShellAPI, System.StrUtils, GMDirection, GMDirectionVCL, cxCheckBox, cxImage,
     cxGridChartView, cxGridDBChartView, cxDropDownEdit, cxCheckListBox, cxCurrencyEdit,
     PdfiumCtrl, dxBar, dxBarExtItems, cxBarEditItem, cxSpinEdit, cxRadioGroup, dsdCommon
     {$IFDEF DELPHI103RIO}, Actions {$ENDIF};

const
  WM_SETFLAG = WM_USER + 2;
  WM_SETFLAGHeaderSaver = WM_USER + 3;
  CUSTOM_FILTER = -1;
  CUSTOM_FILTERLOAD = -2;
  MY_CUST_FILTER = '(Отметить все)';
  MY_CUST_FILTERLOAD = '(Загрузить из файла)';

type
  TMultiplyType = (mtRight, mtBottom, mtLeft, mtTop);


  // 1. Обработка признака isErased
  TCustomDBControlAddOn = class(TdsdComponent)
  private
    FImages: TImageList;
    FOnDblClickActionList: TActionItemList;
    FActionItemList: TActionItemList;
    FOnKeyDown: TKeyEvent;
    FOnDblClick: TNotifyEvent;
    FErasedFieldName: string;
    FAfterInsert: TDataSetNotifyEvent;
    procedure OnAfterInsert(DataSet: TDataSet);
    procedure OnDblClick(Sender: TObject);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
  protected
    property OnDblClickActionList: TActionItemList read FOnDblClickActionList write FOnDblClickActionList;
    property ActionItemList: TActionItemList read FActionItemList write FActionItemList;
    property SortImages: TImageList read FImages write FImages;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    // Имя поля отвечающее за отображение признака Удален
    property ErasedFieldName: string read FErasedFieldName write FErasedFieldName;
  end;

  TdsdDBTreeAddOn = class(TCustomDBControlAddOn)
  private
    FDBTreeList: TcxDBTreeList;
    procedure SetDBTreeList(const Value: TcxDBTreeList);
    // сотируем при нажатых Ctrl, Shift или Alt
    procedure onColumnHeaderClick(Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn);
    // рисуем свои иконки
    procedure onCustomDrawHeaderCell(Sender: TcxCustomTreeList;
       ACanvas: TcxCanvas; AViewInfo: TcxTreeListHeaderCellViewInfo;
       var ADone: Boolean);
    // рисуем свой цвет у выделенной ячейки
    procedure onCustomDrawDataCell(Sender: TcxCustomTreeList;
       ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
       var ADone: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure onGetNodeImageIndex(Sender: TcxCustomTreeList; ANode: TcxTreeListNode;
              AIndexType: TcxTreeListImageIndexType; var AIndex: TImageIndex);
  published
    property OnDblClickActionList;
    property ActionItemList;
    property SortImages;
    property DBTreeList: TcxDBTreeList read FDBTreeList write SetDBTreeList;
  end;

  // Управление цветами

  // Значение цвета
  TColorValue = class(TCollectionItem)
  private
    FColor: TColor;
    FValue: Variant;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Color: TColor read FColor write FColor;
    property Value: Variant read FValue write FValue;
  end;

  // Правило управления цветом
  TColorRule = class(TCollectionItem)
  private
    FColorColumn: TcxGridColumn;
    FValueColumn: TcxGridColumn;
    FValueBoldColumn: TcxGridColumn;
    FColorInValueColumn: boolean;
    FColorValueList: TCollection;
    FStyle: TcxStyle;
    FBackGroundValueColumn: TcxGridColumn;
//    FRectangleColorColumn: TcxGridColumn;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    // Какую ячейку раскрашивать. Если ColorColumn не указан, то будет меняться цвет у всей строки
    property ColorColumn: TcxGridColumn read FColorColumn write FColorColumn;
    // Откуда брать значение для определения цвета
    property ValueColumn: TcxGridColumn read FValueColumn write FValueColumn;
    // Откуда брать значение для определения цвета BackGround
    property BackGroundValueColumn: TcxGridColumn read FBackGroundValueColumn write FBackGroundValueColumn;
    // Указан ли цвет непосредственно в ValueColumn;
    property ColorInValueColumn: boolean read FColorInValueColumn write FColorInValueColumn default true;
    // Значения для цветов
    property ColorValueList: TCollection read FColorValueList write FColorValueList;
    // Откуда брать значение для определения Bold
    property ValueBoldColumn: TcxGridColumn read FValueBoldColumn write FValueBoldColumn;
    // Откуда брать значение для цвета рамки
//    property RectangleColorColumn: TcxGridColumn read FRectangleColorColumn write FRectangleColorColumn;
  end;

  // Правило управления цветом
  TColorRulePivot = class(TCollectionItem)
  private
    FColorColumn: TcxPivotGridField;
    FValueColumn: TcxPivotGridField;
    FValueBoldColumn: TcxPivotGridField;
    FColorInValueColumn: boolean;
    FColorValueList: TCollection;
    FStyle: TcxStyle;
    FBackGroundValueColumn: TcxPivotGridField;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    // Какую ячейку раскрашивать. Если ColorColumn не указан, то будет меняться цвет у всей строки
    property ColorColumn: TcxPivotGridField read FColorColumn write FColorColumn;
    // Откуда брать значение для определения цвета
    property ValueColumn: TcxPivotGridField read FValueColumn write FValueColumn;
    // Откуда брать значение для определения цвета BackGround
    property BackGroundValueColumn: TcxPivotGridField read FBackGroundValueColumn write FBackGroundValueColumn;
    // Указан ли цвет непосредственно в ValueColumn;
    property ColorInValueColumn: boolean read FColorInValueColumn write FColorInValueColumn default true;
    // Значения для цветов
    property ColorValueList: TCollection read FColorValueList write FColorValueList;
    // Откуда брать значение для определения Bold
    property ValueBoldColumn: TcxPivotGridField read FValueBoldColumn write FValueBoldColumn;
  end;

	TPivotSummartType = (psNone, psCount, psSum, psMin, psMax, psAverage,
    psStdDev, psStdDevP, psVariance, psVarianceP, psAveragePrice);

  // Правило подсчета итогов по ячейкам пивота
  TSummaryFieldPivot = class(TCollectionItem)
  private
    FAddColumn: TcxPivotGridField;
    FSummaryColumn: TcxPivotGridField;
    FTypeColumn: TcxPivotGridField;
    FIfDifferent: TPivotSummartType;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    // Для какой ячейку применять расчет
    property SummaryColumn: TcxPivotGridField read FSummaryColumn write FSummaryColumn;
    // Откуда брать значение для типа суммирования
    property AddColumn: TcxPivotGridField read FAddColumn write FAddColumn;
    // Откуда брать значение для типа суммирования
    property TypeColumn: TcxPivotGridField read FTypeColumn write FTypeColumn;
    // Если разные типа суммирования
    property IfDifferent: TPivotSummartType read FIfDifferent write FIfDifferent default psNone;
  end;

  TColumnActionOptions = class(TPersistent)
  private
    FAfterEmptyValue: boolean;
    FActive: boolean;
    FAction: TCustomAction;
  published
    property Active: boolean read FActive write FActive;
    //  только если пустое значение было
    property AfterEmptyValue: boolean read FAfterEmptyValue write FAfterEmptyValue;
    property Action: TCustomAction read FAction write FAction;
  end;

  TColumnCollectionItem = class(TCollectionItem)
    FColumn: TcxGridColumn;
  protected
    function GetDisplayName: string; override;
  published
    property Column: TcxGridColumn read FColumn write FColumn;
  end;

  TColumnAddOn = class(TColumnCollectionItem)
  private
    FAction: TCustomAction;
    FonExitColumn: TColumnActionOptions;
    FFindByFullValue: boolean;
  public
    constructor Create(Collection: TCollection); override;
    procedure Init;
  published
    property FindByFullValue: boolean read FFindByFullValue write FFindByFullValue default false;
    property Action: TCustomAction read FAction write FAction;
    property onExitColumn: TColumnActionOptions read FonExitColumn write FonExitColumn;
  end;

  TSummaryItemAddOn = class(TCollectionItem)
  private
    FDataSummaryItemIndex: Integer;
    FParam: TdsdParam;
    procedure SetDataSummaryItemIndex(const Value: Integer);
    procedure onGetText(Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean; var AText: string);
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Param: TdsdParam read FParam write FParam;
    property DataSummaryItemIndex: Integer read FDataSummaryItemIndex write SetDataSummaryItemIndex;
  end;

  // Правило управления свойствами ячейки грида
  TPropertiesCell = class(TCollectionItem)
  private
    FColumn: TcxGridColumn;
    FValueColumn: TcxGridColumn;
    FEditRepository: TcxEditRepository;
    FOnGetProperties: TcxGridGetPropertiesEvent;
    procedure SetColumn(const Value: TcxGridColumn);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure GetProperties(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
                        var AProperties: TcxCustomEditProperties);
  published
    // Какую ячейку раскрашивать. Если ColorColumn не указан, то будет меняться цвет у всей строки
    property Column: TcxGridColumn read FColumn write SetColumn;
    // Откуда брать значение для определения Properties
    property ValueColumn: TcxGridColumn read FValueColumn write FValueColumn;
    // Коллекция Properties
    property EditRepository: TcxEditRepository read FEditRepository write FEditRepository;
  end;

  // Отображение изображений в TcxImage
  TShowFieldImage = class(TCollectionItem)
  private
    FFieldName : String;
    FImage: TcxImage;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    // Имя поля с данными
    property FieldName: string read FFieldName write FFieldName;
    property Image: TcxImage read FImage write FImage;
  end;

  TViewDocumentParam = class(TPersistent)
  private
     FPDFScaleMode : TPdfControlScaleMode;
     FPDFZoomPercentage  : Integer;
  public
    procedure Assign(Source: TPersistent); override;
  published
    // Имя поля с данными
    property PDFScaleMode: TPdfControlScaleMode read FPDFScaleMode write FPDFScaleMode default smFitAuto;
    property PDFZoomPercentage: Integer read FPDFZoomPercentage write FPDFZoomPercentage default 100;
  end;

  // Отображение документ на указаном контроле
  TViewDocument = class(TCollectionItem)
  private
    FFieldName : String;
    FControl: TWinControl;
    FPdfCtrl: TPdfControl;
    FImage: TcxImage;
    FisFocused: Boolean;

    FBarManager: TdxBarManager;
    FBarManagerBar: TdxBar;
    FBarStatic: TdxBarStatic;
    FBarButtonPrev: TdxBarButton;
    FBarButtonNext: TdxBarButton;
    FBarButtonPrint: TdxBarButton;
    FBarRadioGroup: TcxBarEditItem;
    FBarSpinEdit: TcxBarEditItem;

    procedure OnPrevClick(Sender: TObject);
    procedure OnNextClick(Sender: TObject);
    procedure OnPrintDocumentClick(Sender: TObject);
    procedure OnPageChange(Sender: TObject);
    procedure OnScaleChange(Sender: TObject);
    procedure OnPaint(Sender: TObject);
    procedure OnZoomChange(Sender: TObject);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure ShowPDF(AMemoryStream: TMemoryStream);
    procedure ShowGraphic(AGraphicClass: TGraphicClass; AMemoryStream: TMemoryStream);
    procedure Clear;
  published
    // Имя поля с данными
    property FieldName: string read FFieldName write FFieldName;
    property Control: TWinControl read FControl write FControl;
    property isFocused: Boolean read FisFocused write FisFocused default False;
  end;

  // Поля для отрисовки графика при движении по гриду
  TdsdChartColumn = class(TCollectionItem)
  private
    FColumn: TcxGridColumn;
    FTitle: String;
  public
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
  published
    // Какую ячейку раскрашивать. Если ColorColumn не указан, то будет меняться цвет у всей строки
    property Column: TcxGridColumn read FColumn write FColumn;
    // Название позиции
    property Title: String read FTitle write FTitle;
  end;

  // Series вариантов отрисовки графика при движении по гриду
  TdsdChartSeries = class(TCollectionItem)
  private
    FChartColumnList: TCollection;
    FSeriesName: String;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
  published
    property ColumnList: TCollection read FChartColumnList write FChartColumnList;
    // Поле в FChartDataSet с названиями колонок Series
    property SeriesName: String read FSeriesName write FSeriesName;
  end;

  // Вариант отрисовки графика при движении по гриду
  TdsdChartVariant = class(TCollectionItem)
  private
    FChartSeriesList: TOwnedCollection;
    FHeaderName: String;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
  published
    property Series: TOwnedCollection read FChartSeriesList write FChartSeriesList;
    // Название колонок DataGroups
    property HeaderName: String read FHeaderName write FHeaderName;
  end;

  // Отрисовка графика при движении по гриду
  TdsdChartView = class(TCollectionItem)
  private
    FChartView: TcxGridDBChartView;
    FDisplayedDataComboBox : TcxComboBox;
    FChartVariantList: TOwnedCollection;

    FChartCDS : TClientDataSet;
    FChartDS: TDataSource;
    FDisplayedIndex : Integer;
    FisShowTitle: boolean;

    FOnChange: TNotifyEvent;
    procedure SetDisplayedDataComboBox(Value : TcxComboBox);
    procedure OnChangeDisplayedData(Sender: TObject);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    function GetDisplayName: string; override;
    // ChartView графика
    property ChartView: TcxGridDBChartView read FChartView write FChartView;
    // Данные для формирования графика.
    property VariantList: TOwnedCollection read FChartVariantList write FChartVariantList;
    // ComboBox c выбором набора отображаемых данных
    property DisplayedDataComboBox : TcxComboBox read FDisplayedDataComboBox write SetDisplayedDataComboBox;
    // Скрыть заголовок диаграммы
    property isShowTitle: boolean read FisShowTitle write FisShowTitle default True;
  end;


  // Добавляет ряд функционала на GridView
  // 1. Быстрая установка фильтров
  // 2. Рисование иконок сортировки
  // 3. Обработка признака isErased
  // 4. Изменение Properties ячейки
  TdsdDBViewAddOn = class(TCustomDBControlAddOn)
  private
    FDateEdit: TcxDateEdit;
    FView: TcxGridTableView;
    FBackGroundStyle: TcxStyle;
    FonExit: TNotifyEvent;
    // контрол для ввода условия фильтра
    edFilter: TcxTextEdit;
    FOnlyEditingCellOnEnter: boolean;
    FGridEditKeyEvent: TcxGridEditKeyEvent;
    FOnGetContentStyleEvent : TcxGridGetCellStyleEvent;
    FErasedStyle: TcxStyle;
    FBeforeOpen: TDataSetNotifyEvent;
    FAfterOpen: TDataSetNotifyEvent;
    FColorRuleList: TCollection;
    FColumnAddOnList: TCollection;
    FColumnEnterList: TCollection;
    FPropertiesCellList: TCollection;
    FSummaryItemList: TOwnedCollection;
    FShowFieldImageList: TOwnedCollection;
    FViewDocumentList: TOwnedCollection;
    FChartList: TOwnedCollection;
    FGridFocusedItemChangedEvent: TcxGridFocusedItemChangedEvent;
    FSearchAsFilter: boolean;
    FKeepSelectColor: boolean;
    FGroupByBox: boolean;
    FGroupIndex: integer;
    FAfterScroll: TDataSetNotifyEvent;
    FMemoryStream: TMemoryStream;
    FFilterSelectAll: boolean;
    FFilterLoadFile: boolean;
    FOnGetFilterValues : TcxGridGetFilterValuesEvent;
    FOnUserFiltering : TcxGridUserFilteringEvent;
    FViewDocumentParam : TViewDocumentParam;

    procedure TableViewFocusedItemChanged(Sender: TcxCustomGridTableView;
                        APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
    procedure OnBeforeOpen(ADataSet: TDataSet);
    procedure OnAfterOpen(ADataSet: TDataSet);
    function inColumnEnterList(Column: TcxGridColumn): boolean;
    procedure ActionOnlyEditingCellOnEnter;
    procedure GridEditKeyEvent(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
                                AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure OnAfterScroll(DataSet: TDataSet); virtual;
    procedure SetView(const Value: TcxGridTableView); virtual;
    function GetView : TcxGridTableView; virtual;
    procedure SetDateEdit(const Value: TcxDateEdit); virtual;
    procedure edFilterExit(Sender: TObject);
    procedure edFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    // процедура устанавливает контрол для внесения значения фильтра и позиционируется на заголовке колонки
    procedure lpSetEdFilterPos(inKey: Char);
    //процедура устанавливает фильтр и убирает видимость у контрола
    procedure lpSetFilter;
    // сотируем при нажатых Ctrl, Shift или Alt
    procedure OnColumnHeaderClick(Sender: TcxGridTableView; AColumn: TcxGridColumn);
    // рисуем свои иконки
    procedure OnCustomDrawColumnHeader(Sender: TcxGridTableView;
     ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo;
     var ADone: Boolean);
    // рисуем свой цвет у выделенной ячейки в гриде
    procedure OnCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    // рисуем свой цвет у выделенной ячейки при выгрузке в Excel, например, или печати
    procedure OnGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; {$IFDEF DELPHI103RIO} var {$ELSE} out {$ENDIF} AStyle: TcxStyle);
    // поменять цвет грида в случае установки фильтра
    procedure onFilterChanged(Sender: TObject);
    // если при выходе из грида ДатаСет в Edit mode, то делаем Post
    procedure OnExit(Sender: TObject);
    procedure OnGetFilterValues(Sender: TcxCustomGridTableItem; AValueList: TcxDataFilterValueList);
    procedure OnUserFiltering(Sender: TcxCustomGridTableItem; const AValue: Variant;
      const ADisplayText: string);
    procedure SetOnlyEditingCellOnEnter(const Value: boolean);
    function GetErasedColumn(Sender: TObject): TcxGridColumn;
    procedure SetSearchAsFilter(const Value: boolean);
    function GetColumnAddOn(FindColumn: TcxGridColumn): TColumnAddOn;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // процедура ищет дубликаты заначений по активному столбику и если есть устанавливает фильтр
    procedure ActionDuplicateSearch;
    procedure ClearDuplicateSearch;
  published
    // Ссылка на контрол с датой, если надо при создании показать текущую дату/время
    property DateEdit: TcxDateEdit read FDateEdit write SetDateEdit;
    // Ссылка ссылка на элемент отображающий список
    property View: TcxGridTableView read GetView write SetView;
    // список событий на DblClick
    property OnDblClickActionList;
    // список событий, реагирующих на нажатие клавиш в гриде
    property ActionItemList;
    // картинки для сортировки
    property SortImages;
    // Перемещаться только по редактируемым ячейкам по Enter
    // В случае достижения конца колонок и наличия следующей записи перейти на нее и cпозиционироваться на редактируемой ячейке
    property OnlyEditingCellOnEnter: boolean read FOnlyEditingCellOnEnter write SetOnlyEditingCellOnEnter;
    // Правила разукрашивания грида
    property ChartList: TOwnedCollection read FChartList write FChartList;
    // Правила разукрашивания грида
    property ColorRuleList: TCollection read FColorRuleList write FColorRuleList;
    // Дополнительные установки для колонок
    property ColumnAddOnList: TCollection read FColumnAddOnList write FColumnAddOnList;
    // Переход по данным колонка по Enter
    property ColumnEnterList: TCollection read FColumnEnterList write FColumnEnterList;
    // Отображение элементов на футерах
    property SummaryItemList: TOwnedCollection read FSummaryItemList write FSummaryItemList;
    // Отображение изображений в TcxImage
    property ShowFieldImageList: TOwnedCollection read FShowFieldImageList write FShowFieldImageList;
    // Отображение содержимое документа на контроле
    property ViewDocumentList: TOwnedCollection read FViewDocumentList write FViewDocumentList;
    // Параметры для отображения содержимое документа на контроле
    property ViewDocumentParam : TViewDocumentParam read FViewDocumentParam write FViewDocumentParam;
    // Поиск как фильтр
    property SearchAsFilter: boolean read FSearchAsFilter write SetSearchAsFilter default true;
    // При установке в True сохраняется цвет шрифта и фон для выделенной строчки
    property KeepSelectColor: boolean read FKeepSelectColor write FKeepSelectColor default false;
    // Правила Properties ячейки
    property PropertiesCellList: TCollection read FPropertiesCellList write FPropertiesCellList;
    // В автофильтре кнопка "Отметить все"
    property FilterSelectAll: boolean read FFilterSelectAll write FFilterSelectAll default False;
    // В автофильтре кнопка "Отметить все"
    property FilterLoadFile: boolean read FFilterLoadFile write FFilterLoadFile default False;

  end;

  TCrossDBViewAddOn = class(TdsdDBViewAddOn)
  private
    FHeaderDataSet: TDataSet;
    FTemplateColumn: TcxGridColumn;
    FHeaderColumnName: String;
    FBeforeOpen: TDataSetNotifyEvent;
    FAfterClose: TDataSetNotifyEvent;
    FEditing: TcxGridEditingEvent;
    FFocusedItemChanged: TcxGridFocusedItemChangedEvent;
    FDataSet: TDataSet;
    FCreateColumnList: TList;
    FCreateColorRuleList: TList;
    FNoCrossColorColumn : boolean;
    procedure onEditing(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
         var AAllow: Boolean);
    procedure onBeforeOpen(DataSet: TDataSet);
    procedure onAfterClose(DataSet: TDataSet);
    procedure onCustomDrawHeader900(
      Sender: TcxGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure SetView(const Value: TcxGridTableView); override;
    procedure FocusedItemChanged(Sender: TcxCustomGridTableView;
                                 APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property DataSet: TDataSet read FDataSet;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CreateColumnList: TList read FCreateColumnList;
    property CreateColorRuleList: TList read FCreateColorRuleList;
  published
    // Дата сет с названием колонок и другой необходимой для работы информацией.
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    // Поле в HeaderDataSet с названиями колонок кроса
    property HeaderColumnName: String read FHeaderColumnName write FHeaderColumnName;
    // Шаблон для Cross колонок
    property TemplateColumn: TcxGridColumn read FTemplateColumn write FTemplateColumn;
    // Колонки цвета не размножать (один цвет на все колонки)
    property NoCrossColorColumn : boolean read FNoCrossColorColumn write FNoCrossColorColumn default False;
  end;

  // Кросс для нескольких полей
  TTemplateColumn = class(TCollectionItem)
  private
    FTemplateColumn: TcxGridColumn;
    FHeaderColumnName: String;
    FColIndex : Integer;
    FRowIndex : Integer;
    FIsCrossParam: TdsdParam;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    function GetDisplayName: string; override;
    // Поле в HeaderDataSet с названиями колонок кроса
    property HeaderColumnName: String read FHeaderColumnName write FHeaderColumnName;
    // Шаблон для Cross колонок
    property TemplateColumn: TcxGridColumn read FTemplateColumn write FTemplateColumn;
    // Кросит столбик
    property IsCross: TdsdParam read FIsCrossParam write FIsCrossParam;
  end;

  // Размножение колонок перед кросом
  TMultiplyColumn = class(TCollectionItem)
  private
    FColumn: TcxGridColumn;
    FFieldName: String;
    FHeaderFieldName: String;
    FColorColumnName: String;
    FBackGroundColumnName: String;
  public
    procedure Assign(Source: TPersistent); override;
  published
    function GetDisplayName: string; override;
    // Поле в HeaderDataSet с названиями колонок кроса
    property FieldName: String read FFieldName write FFieldName;
    // Поле в HeaderDataSet с названиями колонок кроса
    property HeaderFieldName: String read FHeaderFieldName write FHeaderFieldName;
    // Шаблон для Cross колонок
    property Column: TcxGridColumn read FColumn write FColumn;
    // Цвет шрифта колонки
    property ColorColumnName: String read FColorColumnName write FColorColumnName;
    // Цвет фона колонки
    property BackGroundColumnName: String read FBackGroundColumnName write FBackGroundColumnName;
  end;

  // Формирование графика
  TChart = class(TCollectionItem)
  private
    FChartView: TcxGridDBChartView;
    FChartDataSet: TDataSet;
    FDisplayedDataComboBox : TcxComboBox;
    FDataGroupsFielddName: String;
    FHeaderName: String;
    FHeaderFieldName: String;
    FSeriesName: String;
    FSeriesFieldName: String;
    FNameDisplayedDataFieldName: String;
    FisShowTitle: boolean;

    FChartCDS : TClientDataSet;
    FChartDS: TDataSource;
    FDisplayedDataName : String;

    FOnChange: TNotifyEvent;
    procedure SetDisplayedDataComboBox(Value : TcxComboBox);
    procedure OnChangeDisplayedData(Sender: TObject);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    function GetDisplayName: string; override;
    // ChartView графика
    property ChartView: TcxGridDBChartView read FChartView write FChartView;
    // Поле в FChartDataSet с названиями колонок DataGroups
    property DataGroupsFielddName: String read FDataGroupsFielddName write FDataGroupsFielddName;
    // Название колонок DataGroups
    property HeaderName: String read FHeaderName write FHeaderName;
    // Поле в HeaderDataSet с названиями колонок DataGroups
    property HeaderFieldName: String read FHeaderFieldName write FHeaderFieldName;
    // Дата сет c данными для формирования графика.
    property ChartDataSet: TDataSet read FChartDataSet write FChartDataSet;
    // Поле в FChartDataSet с названиями колонок Series
    property SeriesName: String read FSeriesName write FSeriesName;
    // Поле в FChartDataSet с названиями колонок в данных для отображения
    property SeriesFieldName: String read FSeriesFieldName write FSeriesFieldName;
    // ComboBox c выбором набора отображаемых данных
    property DisplayedDataComboBox : TcxComboBox read FDisplayedDataComboBox write SetDisplayedDataComboBox;
    // Номер набора отображаемых данных в ChartDataSet
    property NameDisplayedDataFieldName: String read FNameDisplayedDataFieldName write FNameDisplayedDataFieldName;
    // Скрыть заголовок диаграммы
    property isShowTitle: boolean read FisShowTitle write FisShowTitle default True;
  end;

  // Кросс для отчетов

  TCrossDBViewReportAddOn = class(TdsdDBViewAddOn)
  private
    FHeaderDataSet: TDataSet;
    FMultiplyDataSet: TDataSet;
    FBаndColumnName: String;
    FBeforeOpen: TDataSetNotifyEvent;
    FAfterClose: TDataSetNotifyEvent;
    FAfterOpen: TDataSetNotifyEvent;
    FEditing: TcxGridEditingEvent;
    FFocusedItemChanged: TcxGridFocusedItemChangedEvent;
    FDataSet: TDataSet;
    FCreateColumnList: TList;
    FCreateColorRuleList: TList;
    FCreateBаndList: TList;
    FCreateTemplateColumn: TList;
    FNoCrossColorColumn : boolean;
    FTemplateColumnList: TCollection;
    FMultiplyColumnList: TCollection;
    FChartList: TOwnedCollection;
    FActionExpand: TBooleanStoredProcAction;
    FMultiplyType : TMultiplyType;
    isExpand : boolean;
    procedure onBeforeOpen(DataSet: TDataSet);
    procedure onAfterOpen(DataSet: TDataSet);
    procedure onAfterClose(DataSet: TDataSet);
    procedure SetView(const Value: TcxGridTableView); override;
    procedure FocusedItemChanged(Sender: TcxCustomGridTableView;
                                 APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
    procedure OnAfterScroll(DataSet: TDataSet); override;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ChangingTheSequence;
    procedure ExpandExecute;
  public
    property DataSet: TDataSet read FDataSet;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CreateColumnList: TList read FCreateColumnList;
    property CreateColorRuleList: TList read FCreateColorRuleList;
    property CreateBаndList: TList read FCreateBаndList;
    property CreateTemplateColumn: TList read FCreateTemplateColumn;
  published
    // Данные для построения графиков
    property ChartList: TOwnedCollection read FChartList write FChartList;
    // Размножение колонок перед кросом
    property MultiplyColumnList: TCollection read FMultiplyColumnList write FMultiplyColumnList;
    // Как размножать колонки
    property MultiplyType : TMultiplyType read FMultiplyType write FMultiplyType default mtRight;
    // Кросс для нескольких полей
    property TemplateColumnList: TCollection read FTemplateColumnList write FTemplateColumnList;
    // Дата сет с названием колонок и другой необходимой для работы информацией.
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    // Дата сет с параметрамы для размножения столбиков.
    property MultiplyDataSet: TDataSet read FMultiplyDataSet write FMultiplyDataSet;
    // Поле в HeaderDataSet с названиями Band для TcxGridDBBandedTableView
    property BаndColumnName: String read FBаndColumnName write FBаndColumnName;
    // Колонки цвета не размножать (один цвет на все колонки)
    property NoCrossColorColumn : boolean read FNoCrossColorColumn write FNoCrossColorColumn default False;
    // CheckBox для разворота блока данных для TcxGridDBBandedTableView
    property ActionExpand: TBooleanStoredProcAction read FActionExpand write FActionExpand;
  end;


  TPivotAddOn = class(TCustomDBControlAddOn)
  private
    FPivotGrid: TcxDBPivotGrid;
    FAfterOpen: TDataSetNotifyEvent;
    FOnGetContentStyleEvent : TcxPivotGridGetContentStyleEvent;
    FExpandRow : Integer;
    FExpandColumn : Integer;
    FColorRuleList: TCollection;
    FSummaryFieldList: TCollection;

    procedure SetPivotGrid(const Value: TcxDBPivotGrid);
    procedure OnAfterOpen(ADataSet: TDataSet);
    // рисуем свой цвет у выделенной ячейки при выгрузке в Excel, например, или печати
    procedure OnGetContentStyle(Sender: TcxCustomPivotGrid;
      ACell: TcxPivotGridDataCellViewInfo; var AStyle: TcxStyle);
    // расчет сумирования по ячейкам
    procedure OnCalculateCustomSummary(
      Sender: TcxPivotGridField; ASummary: TcxPivotGridCrossCellSummary);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetCurrentData: string;
  published
    property PivotGrid: TcxDBPivotGrid read FPivotGrid write SetPivotGrid;
    // список событий на DblClick
    property OnDblClickActionList;
    // список событий, реагирующих на нажатие клавиш в гриде
    property ActionItemList;
    // Вложеномть разворачивания строк
    property ExpandRow : Integer read FExpandRow write FExpandRow default 0;
    // Вложеномть разворачивания столбцов
    property ExpandColumn : Integer read FExpandColumn write FExpandColumn default 0;
    // Правила разукрашивания грида
    property ColorRuleList: TCollection read FColorRuleList write FColorRuleList;
    // Правила сумирования по ячейкам
    property SummaryList: TCollection read FSummaryFieldList write FSummaryFieldList;
  end;

  TCrossDBViewSetTypeId = class(TdsdCustomAction)
  private
    FCrossDBViewAddOn : TCrossDBViewAddOn;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property CrossDBViewAddOn : TCrossDBViewAddOn read FCrossDBViewAddOn write FCrossDBViewAddOn;
  end;

  TdsdUserSettingsStorageAddOn = class(TdsdComponent)
  private
    FOnDestroy: TNotifyEvent;
    FActive: boolean;
    procedure OnDestroy(Sender: TObject);
  public
    procedure LoadUserSettingsData(Data: String);
    procedure SaveUserSettings;
    procedure SaveUserSettingsBack;
    procedure LoadUserSettings;
    procedure LoadUserSettingsBack;
    constructor Create(AOwner: TComponent); override;
  published
    property Active: boolean read FActive write FActive default true;
  end;

  TControlListItem = class(TCollectionItem)
  private
    FControl: TControl;
    procedure SetControl(const Value: TControl);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Control: TControl read FControl write SetControl;
  end;

  THeaderSaver = class;

  TControlList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TControlListItem;
    procedure SetItem(Index: Integer; const Value: TControlListItem);
  public
    function Add: TControlListItem;
    property Items[Index: Integer]: TControlListItem read GetItem write SetItem; default;
  end;

  // Вызывает процедуру сохранения для СОХРАНЕННОГО документа в случае изменения значений
  THeaderSaver = class(TdsdComponent)
  private
    { field to store the window handle }
    FHWnd: HWND;
    FNotSave: boolean;
    FControlList: TControlList;
    FStoredProc: TdsdStoredProc;
    FEnterValue: TStringList;
    FOnAfterShow: TNotifyEvent;
    FParam: TdsdParam;
    FGetStoredProc: TdsdStoredProc;
    FAfterExecute: TNotifyEvent;
    FAction: TCustomAction;
    procedure OnEnter(Sender: TObject);
    procedure OnExit(Sender: TObject);
    // процедура вызывается после открытия формы и заполняет FEnterValue начальными параметрами
    procedure OnAfterShow(Sender: TObject);
    procedure WndMethod(var Msg: TMessage);
    procedure SetGetStoredProc(Value: TdsdStoredProc);
    procedure AfterGetExecute(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Эмулирует заход во все контролы, чтобы установить текущие значения
    procedure EnterAll;
  published
    property IdParam: TdsdParam read FParam write FParam;
    property StoredProc: TdsdStoredProc read FStoredProc write FStoredProc;
    property ControlList: TControlList read FControlList write FControlList;
    property GetStoredProc: TdsdStoredProc read FGetStoredProc write SetGetStoredProc;
    property ActionAfterExecute: TCustomAction read FAction write FAction;
  end;

  TChangerListItem = class(TCollectionItem)
  private
    FControl: TControl;
    procedure SetControl(const Value: TControl);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Control: TControl read FControl write SetControl;
  end;

  TChangerList = class(TOwnedCollection)
  private
    function GetChangerListItem(Index: Integer): TChangerListItem;
    procedure SetChangerListItem(Index: Integer; const Value: TChangerListItem);
  public
    function Add: TChangerListItem;
    property Items[Index: Integer]: TChangerListItem read GetChangerListItem write SetChangerListItem; default;
  end;

  THeaderChanger = class(TdsdComponent)
  private
    FParam: TdsdParam;
    FChangerList: TChangerList;
    FAction: TCustomAction;
    procedure OnChange(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property IdParam: TdsdParam read FParam write FParam;
    property ChangerList: TChangerList read FChangerList write FChangerList;
    property Action: TCustomAction read FAction write FAction;
  end;

  TExitListItem = class(TCollectionItem)
  private
    FControl: TWinControl;
    FOnExit: TNotifyEvent;
    FOnEnter: TNotifyEvent;
    FValue: Variant;

    procedure SetControl(const Value: TWinControl);
    procedure OnExit(Sender: TObject);
    procedure OnEnter(Sender: TObject);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Control: TWinControl read FControl write SetControl;
  end;

  TExitList = class(TOwnedCollection)
  private
    function GetExitListItem(Index: Integer): TExitListItem;
    procedure SetExitListItem(Index: Integer; const Value: TExitListItem);
  public
    function Add: TExitListItem;
    property Items[Index: Integer]: TExitListItem read GetExitListItem write SetExitListItem; default;
  end;

  // Вызывает Акшин при уходе с компонента если изменилось значение
  THeaderExit = class(TdsdComponent)
  private
    FExitList: TExitList;
    FAction: TCustomAction;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ExitList: TExitList read FExitList write FExitList;
    property Action: TCustomAction read FAction write FAction;
  end;

  TEnterMoveNextListItem = class(TCollectionItem)
  private
    FControl: TWinControl;
    FEnterAction: TCustomAction;
    FExitAction: TCustomAction;

    procedure SetControl(const Value: TWinControl);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Control: TWinControl read FControl write SetControl;
    property EnterAction: TCustomAction read FEnterAction write FEnterAction;
    property ExitAction: TCustomAction read FExitAction write FExitAction;
  end;

  TEnterMoveNextList = class(TOwnedCollection)
  private
    function GetEnterMoveNextListItem(Index: Integer): TEnterMoveNextListItem;
    procedure SetEnterMoveNextListItem(Index: Integer; const Value: TEnterMoveNextListItem);
  public
    function Add: TEnterMoveNextListItem;
    property Items[Index: Integer]: TEnterMoveNextListItem read GetEnterMoveNextListItem write SetEnterMoveNextListItem; default;
  end;

  // Реакция на Enter и переход на следующий контрол
  TEnterMoveNext = class(TdsdComponent)
  private
    FEnterMoveNextList: TEnterMoveNextList;
    FOnFormKeyDown : TKeyEvent;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure OnFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property EnterMoveNextList: TEnterMoveNextList read FEnterMoveNextList write FEnterMoveNextList;
  end;

  TRefreshAddOn = class(TdsdComponent)
  private
    FFormName: string;
    FDataSet: string;
    FOnClose: TCloseEvent;
    FRefreshAction: string;
    FFormParams: string;
    FKeyField: string;
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FormName: string read FFormName write FFormName;
    property DataSet: string read FDataSet write FDataSet;
    property KeyField: string read FKeyField write FKeyField;
    property RefreshAction: string read FRefreshAction write FRefreshAction;
    property FormParams: string read FFormParams write FFormParams;
  end;

  TComponentListItem = class(TCollectionItem)
  private
    FComponent: TComponent;
    FOnChange: TNotifyEvent;
    procedure SetComponent(const Value: TComponent);
    procedure OnChange(Sender: TObject);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Component: TComponent read FComponent write SetComponent;
  end;

  TExecuteDialog = class;

  TRefreshDispatcher = class(TdsdComponent)
  private
    { field to store the window handle }
    FHWnd: HWND;
    FNotRefresh: boolean;
    FRefreshAction: TdsdDataSetRefresh;
    FComponentList: TCollection;
    FShowDialogAction: TExecuteDialog;
    FIdParam: TdsdParam;
    FCheckIdParam: boolean;
    procedure SetShowDialogAction(const Value: TExecuteDialog);
    procedure WndMethod(var Msg: TMessage);
    procedure SetFlag;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure OnComponentChange(Sender: TObject);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CheckIdParam: boolean read FCheckIdParam write FCheckIdParam default false;
    property IdParam: TdsdParam read FIdParam write FIdParam;
    property RefreshAction: TdsdDataSetRefresh read FRefreshAction write FRefreshAction;
    property ShowDialogAction: TExecuteDialog read FShowDialogAction write SetShowDialogAction;
    property ComponentList: TCollection read FComponentList write FComponentList;
  end;

  // событие работы с диалогами установки параметров
  TExecuteDialog = class (TdsdOpenForm)
  private
    FRefreshDispatcher: TRefreshDispatcher;
    FOpenBeforeShow: boolean;
    // Прячем свойство модальности - она всегда модальна
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    // данное свойство нужно только в случае открытия диалога ДО формы. Что бы не быдо 2-х перечитываний запроса
    RefreshAllow: boolean;
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  published
    property RefreshDispatcher: TRefreshDispatcher read FRefreshDispatcher write FRefreshDispatcher;
    property OpenBeforeShow: boolean read FOpenBeforeShow write FOpenBeforeShow;
  end;

  TAddOnFormRefresh = Class(TPersistent)
  private
    FParentList: String;
    FSelfList: String;
    FDataSet: TDataSet;
    FKeyField: String;
    FKeyParam: String;
    FNeedRefresh: Boolean;
    FRefreshID: Variant;
    FGetStoredProc: TdsdStoredProc;

    function GetDataSet: TDataSet;
    procedure SetDatSet(Value: TDataSet);

    function GetGetStoredProc: TdsdStoredProc;
    procedure SetGetStoredProc(Value: TdsdStoredProc);
  public
    constructor Create;
    destructor Destroy; override;
    //процедура обновления записи
    procedure RefreshRecord;

    property NeedRefresh: Boolean read FNeedRefresh write FNeedRefresh;
    property RefreshID: Variant read FRefreshID write FRefreshID;
  published
    // Идентификатор списка родительской формы
    property ParentList: String read FParentList write FParentList;
    // Идентификатор списка собственной формы
    property SelfList: String read FSelfList write FSelfList;
    // Рабочий ДатаСет
    property DataSet: TDataSet read GetDataSet write SetDatSet;
    //Имя ключевого поля
    property KeyField: String read FKeyField write FKeyField;
    //Имя ключевого параметра
    property KeyParam: String read FKeyParam write FKeyParam;
    //Процедура получения рекорда
    property GetStoredProc: TdsdStoredProc read GetGetStoredProc write SetGetStoredProc;
  End;

  TAddOnFormData = class(TPersistent)
  private
    FChoiceAction: TdsdChoiceGuides;
    FParams: TdsdFormParams;
    FExecuteDialogAction: TExecuteDialog;
    FRefreshAction: TdsdDataSetRefresh;
    FisSingle: boolean;
    FisAlwaysRefresh: boolean;
    FisFreeAtClosing: boolean;
    FOnLoadAction: TdsdCustomAction;
    FAddOnFormRefresh: TAddOnFormRefresh;
    FPUSHMessage: TdsdShowPUSHMessage;
    FClosePUSHMessage: TdsdShowPUSHMessage;
    FSetFocusedAction: TdsdSetFocusedAction;
  public
    constructor Create;
    destructor Destroy; override;
  published
    // Всегда перечитываем форму
    property isAlwaysRefresh: boolean read FisAlwaysRefresh write FisAlwaysRefresh default true;
    // Событие вызываемое после загрузки формы.
    property OnLoadAction: TdsdCustomAction read FOnLoadAction write FOnLoadAction;
    // Событие вызываемое для перечитывания формы
    property RefreshAction: TdsdDataSetRefresh read FRefreshAction write FRefreshAction;
    // Данная форма создается в единственном экземпляре. Актуально, например, для справочников
    property isSingle: boolean read FisSingle write FisSingle default true;
    // Данная форма после закрытия унечтожаеться
    property isFreeAtClosing: boolean read FisFreeAtClosing write FisFreeAtClosing default false;
    // Событие вызываемое для выбора значения
    property ChoiceAction: TdsdChoiceGuides read FChoiceAction write FChoiceAction;
    // Событие открытия диалога
    property ExecuteDialogAction: TExecuteDialog read FExecuteDialogAction write FExecuteDialogAction;
    // Параметры формы
    property Params: TdsdFormParams read FParams write FParams;
    // Параметры для перечитывания формы
    property AddOnFormRefresh: TAddOnFormRefresh Read FAddOnFormRefresh Write FAddOnFormRefresh;
    // Событие вызываемое для выыода PUSH сообщений при открытии окна
    property PUSHMessage: TdsdShowPUSHMessage Read FPUSHMessage Write FPUSHMessage;
    // Событие вызываемое для выыода PUSH сообщений при закрытии окна
    property ClosePUSHMessage: TdsdShowPUSHMessage Read FClosePUSHMessage Write FClosePUSHMessage;
    // Событие вызываемое для выыода PUSH сообщений при закрытии окна
    property SetFocusedAction: TdsdSetFocusedAction Read FSetFocusedAction Write FSetFocusedAction;
  end;

  TdsdGMMap = class(TGMMap)
  private
    FMapType: TMapAcionType;
    FDataSet: TDataSet;
    FMapLoad: Boolean;
    FGPSNField: string;
    FGPSEField: string;
    FAddressField: string;
    FInsertDateField: string;
    FIsShowRoute: Boolean;

    procedure LoadDefaultWebBrowser;
    procedure DoAfterPageLoaded(Sender: TObject; First: Boolean);
  public
    constructor Create(AOwner: TComponent); override;

    procedure SetDocLoaded;

    property MapType: TMapAcionType read FMapType write FMapType default acShowOne;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property MapLoad: Boolean read FMapLoad write FMapLoad;
    property GPSNField: string read FGPSNField write FGPSNField;
    property GPSEField: string read FGPSEField write FGPSEField;
    property AddressField: string read FAddressField write FAddressField;
    property InsertDateField: string read FInsertDateField write FInsertDateField;
    property IsShowRoute: Boolean read FIsShowRoute write FIsShowRoute default False;
  end;

  TdsdWebBrowser = class(TWebBrowser)
  private
    FTimer: TTimer;
    FGeoCode: TGMGeoCode;
    FDirection: TGMDirection;

    procedure DoDownloadComplete(Sender: TObject);
    procedure OnTimerNotifyEvent(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TWinControlListItem = class(TCollectionItem)
  private
    FControl: TWinControl;
    FStoredProc: TdsdStoredProc;
    FGotoControl: TWinControl;
    FAction: TCustomAction;
    FKeyDown : TKeyEvent;
    procedure SetControl(const Value: TWinControl);
    procedure SetGotoControl(const Value: TWinControl);
    procedure edKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Action: TCustomAction read FAction write FAction;
    property Control: TWinControl read FControl write SetControl;
    property GotoControl: TWinControl read FGotoControl write SetGotoControl;
    property StoredProc: TdsdStoredProc read FStoredProc write FStoredProc;
  end;

  TTabSheetListItem = class(TCollectionItem)
  private
    FTabSheet: TcxTabSheet;
    FControl: TWinControl;
    FKeyDown : TKeyEvent;
    procedure SetTabSheet(const Value: TcxTabSheet);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property TabSheet: TcxTabSheet read FTabSheet write FTabSheet;
    property Control: TWinControl read FControl write FControl;
  end;

  TdsdEnterManager = class(TdsdComponent)
  private
    FControlList: TCollection;
    FTabSheetList: TCollection;
    FPageControl: TcxPageControl;

    FOnChange: TNotifyEvent;
    procedure SetPageControl(const Value: TcxPageControl);
    procedure PageControl1Change(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ControlList: TCollection read FControlList write FControlList;
    property TabSheetList: TCollection read FTabSheetList write FTabSheetList;
    property PageControl: TcxPageControl read FPageControl write SetPageControl;
  end;

  TdsdFileToBase64 = class(TdsdComponent)
  private
    FLookupControl: TWinControl;
    FFileOpenDialog: TFileOpenDialog;

    procedure OpenFile;
    procedure SetLookupControl(const Value: TWinControl); virtual;
    procedure OnDblClick(Sender: TObject);
    procedure OnButtonClick(Sender: TObject; AButtonIndex: Integer);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // визуальный компонент
    property LookupControl: TWinControl read FLookupControl write SetLookupControl;
  end;

  // Установка фильтров по галочкам
  TCheckBoxItem = class(TCollectionItem)
  private
    FValues: String;
    FCheckBox: TcxCheckBox;
    FOnCheckChange: TNotifyEvent;
    procedure SetCheckBox(const Value: TcxCheckBox);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    // Значения для фильтра
    property Value: String read FValues write FValues;
    // Откуда брать значение для определения Bold
    property CheckBox: TcxCheckBox read FCheckBox write SetCheckBox;
  end;

  TColumnFieldFilterItem = class(TColumnCollectionItem)
  private
    FTextEdit: TcxTextEdit;

    FOldStr : string;

    FTimer: TTimer;
    FProgressBar: TProgressBar;
    FOnEditChange: TNotifyEvent;
    FOnEditExit: TNotifyEvent;
    FOnKeyDown: TKeyEvent;

    procedure OnEditChange(Sender: TObject);
    procedure OnEditExit(Sender: TObject);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure SetTextEdit(const Value: TcxTextEdit);
    procedure TimerTimer(Sender: TObject);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    // Edit - для ввода текста фильтра
    property TextEdit: TcxTextEdit read FTextEdit write SetTextEdit;
  end;

  // Установка фильтра на поле
  TdsdFieldFilter = class(TdsdComponent)
  private
    FTextEdit: TcxTextEdit;
    FDataSet: TDataSet;
    FColumn: TcxGridColumn;
    FColumnList: TOwnedCollection;

    FCheckColumn: TcxGridColumn;

    FTimer: TTimer;
    FProgressBar: TProgressBar;
    FOnEditChange: TNotifyEvent;
    FOnEditExit: TNotifyEvent;
    FOnKeyDown: TKeyEvent;


    FOldStr : string;

    FFilterRecord: TFilterRecordEvent;
    FFiltered: Boolean;

    FCheckBoxList: TOwnedCollection;

    FActionNumber1: TCustomAction;

    procedure OnEditChange(Sender: TObject);
    procedure OnEditExit(Sender: TObject);
    procedure OnCheckChange(Sender: TObject);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure SetTextEdit(const Value: TcxTextEdit);
    procedure SetDataSet(const Value: TDataSet);
    function GetColumn: TcxGridColumn;
    procedure SetColumn(const Value: TcxGridColumn);
    procedure TimerTimer(Sender: TObject);
  protected
    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckSelected : Boolean;
  published
    // Edit - для ввода текста фильтра
    property TextEdit: TcxTextEdit read FTextEdit write SetTextEdit;
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property Column: TcxGridColumn read GetColumn write SetColumn;
    // Коллекция столюбиков для фильтра
    property ColumnList: TOwnedCollection read FColumnList write FColumnList;
    property CheckColumn: TcxGridColumn read FCheckColumn write FCheckColumn;
    // Если под фильтром 1 запись
    property ActionNumber1: TCustomAction read FActionNumber1 write FActionNumber1;
    // Массив CheckBox для установки фильта
    property CheckBoxList: TOwnedCollection read FCheckBoxList write FCheckBoxList;
  end;

  // Установка проперти на едит
  TdsdPropertiesСhange = class(TdsdComponent)
  private
    FComponent: TComponent;
    FEditRepository: TcxEditRepository;
    FIndexProperties : Integer;
    procedure SetComponent(const Value: TComponent);
    procedure SetIndexProperties(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    // Установить Properties
    property IndexProperties : Integer read FIndexProperties write SetIndexProperties;
  published
    // Какую ячейку раскрашивать. Если ColorColumn не указан, то будет меняться цвет у всей строки
    property Component: TComponent read FComponent write SetComponent;
    // Коллекция Properties
    property EditRepository: TcxEditRepository read FEditRepository write FEditRepository;
  end;

  // Формирование графика
  TChartAddOn = class(TdsdComponent)
  private
    FChartView: TcxGridDBChartView;

    FSeriesDataSet: TDataSet;
    FSeriesFieldName: String;
    FSeriesDisplayText: String;

    FBeforeOpen: TDataSetNotifyEvent;
    FAfterOpen: TDataSetNotifyEvent;

    FOnChange: TNotifyEvent;
    procedure SetView(const Value: TcxGridDBChartView); virtual;
    procedure OnBeforeOpen(ADataSet: TDataSet);
    procedure OnAfterOpen(ADataSet: TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    // ChartView графика
    property ChartView: TcxGridDBChartView read FChartView write SetView;
    // Дата сет c данными для формирования графика.
    property SeriesDataSet: TDataSet read FSeriesDataSet write FSeriesDataSet;
    // Поле в FSeriesDataSet с названиями колонок Series
    property SeriesDisplayText: String read FSeriesDisplayText write FSeriesDisplayText;
    // Поле в FSeriesDataSet с названиями колонок в данных для отображения
    property SeriesFieldName: String read FSeriesFieldName write FSeriesFieldName;
  end;

  TPositionCellData = class(TPersistent)
  private
    FLeftParam: TdsdParam;
    FTopParam: TdsdParam;
    FWidthParam: TdsdParam;
    FHeightParam: TdsdParam;
  public
    constructor Create; virtual;
    destructor Destroy; override;

  published

    property LeftParam: TdsdParam  read FLeftParam write FLeftParam;
    property TopParam: TdsdParam  read FTopParam write FTopParam;
    property WidthParam: TdsdParam  read FWidthParam write FWidthParam;
    property HeightParam: TdsdParam  read FHeightParam write FHeightParam;
  end;

  TFieldParamsData = class(TPersistent)
  private
    FFieldIdParam: TdsdParam;
    FFieldParentIdParam: TdsdParam;

    FFieldPositionFixedParam: TdsdParam;
    FFieldLeftParam: TdsdParam;
    FFieldTopParam: TdsdParam;
    FFieldWidthParam: TdsdParam;
    FFieldHeightParam: TdsdParam;

    FFieldRootTreeParam: TdsdParam;
    FFieldLetterTreeParam: TdsdParam;

    FFieldTextParam: TdsdParam;
    FFieldColorParam: TdsdParam;
    FFieldTextColorParam: TdsdParam;
  public
    constructor Create; virtual;
    destructor Destroy; override;

  published

    property FieldIdParam: TdsdParam  read FFieldIdParam write FFieldIdParam;
    property FieldParentIdParam: TdsdParam  read FFieldParentIdParam write FFieldParentIdParam;
    property FieldPositionFixedParam: TdsdParam  read FFieldPositionFixedParam write FFieldPositionFixedParam;
    property FieldLeftParam: TdsdParam  read FFieldLeftParam write FFieldLeftParam;
    property FieldTopParam: TdsdParam  read FFieldTopParam write FFieldTopParam;
    property FieldWidthParam: TdsdParam  read FFieldWidthParam write FFieldWidthParam;
    property FieldHeightParam: TdsdParam  read FFieldHeightParam write FFieldHeightParam;
    property FieldRootTreeParam: TdsdParam  read FFieldRootTreeParam write FFieldRootTreeParam;
    property FieldLetterTreeParam: TdsdParam  read FFieldLetterTreeParam write FFieldLetterTreeParam;
    property FieldTextParam: TdsdParam  read FFieldTextParam write FFieldTextParam;
    property FieldColorParam: TdsdParam  read FFieldColorParam write FFieldColorParam;
    property FieldTextColorParam: TdsdParam  read FFieldTextColorParam write FFieldTextColorParam;
  end;

  TCheckerboardAddOn = class(TdsdComponent)
  private
    FControl: TWinControl;

    FDataSet: TDataSet;

    FSeriesFieldName: String;
    FSeriesDisplayText: String;

    FAfterOpen: TDataSetNotifyEvent;
    FBeforeClose: TDataSetNotifyEvent;
    FAfterClose: TDataSetNotifyEvent;
    FOnDblClick: TNotifyEvent;

    FCreatePanelList: TList;

    FGap: Integer;
    FHeight: Integer;
    FWidth: Integer;

    FMouseDownSpot : TPoint;
    FCapturing : Boolean;
    FSizing : Boolean;
    FControlDown: TWinControl;

    FFocusedIdParam: TdsdParam;

    FDblClickAction: TCustomAction;
    FUpdatePositionAction: TCustomAction;
    FRunUpdateAllPositionAction : TCustomAction;
    FPriorAction: TCustomAction;

    FPositionCellData: TPositionCellData;
    FFieldParamsData: TFieldParamsData;
    FPosCellData: TRect;

    FTimer: TTimer;
    FTimerProcess : Integer;
    FFocusID : Integer;
    FFocusSetID : Integer;

    FStyle : TcxEditStyle;
    FStyleFocused : TcxEditStyle;

    FMinWidth: Integer;
    FMinHeight: Integer;

    procedure SetDataSet(const Value: TDataSet);
    procedure SetRunUpdateAllPositionAction(const Value: TCustomAction);

    procedure OnAfterOpen(ADataSet: TDataSet);
    procedure OnBeforeClose(ADataSet: TDataSet);
    procedure OnAfterClose(ADataSet: TDataSet);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnDblClick(Sender: TObject);
    procedure OnEnter(Sender: TObject);
    procedure OnTimer(Sender: TObject);

    procedure OnRunTask(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    // Панель для размещения
    property Panel: TWinControl read FControl write FControl;
    // Дата сет с данными
    property DataSet: TDataSet read FDataSet write SetDataSet;
    // Поле в FSeriesDataSet с названиями колонок Series
    property SeriesDisplayText: String read FSeriesDisplayText write FSeriesDisplayText;
    // Поле в FSeriesDataSet с названиями колонок в данных для отображения
    property SeriesFieldName: String read FSeriesFieldName write FSeriesFieldName;
    // Промежутки между панелями
    property Gap: Integer read FGap write FGap default 5;
    // Высота панели
    property Height: Integer read FHeight write FHeight default 137;
    // Ширина панели
    property Width: Integer read FWidth write FWidth default 105;
    // Id активной записи
    property FocusedIdParam: TdsdParam  read FFocusedIdParam write FFocusedIdParam;
    // Акция по DblClick
    property DblClickAction: TCustomAction  read FDblClickAction write FDblClickAction;
    // Акция по ищменению позиции и размера
    property UpdatePositionAction: TCustomAction  read FUpdatePositionAction write FUpdatePositionAction;
    // Обновить все по кнопке
    property RunUpdateAllPositionAction : TCustomAction read FRunUpdateAllPositionAction write SetRunUpdateAllPositionAction;
    // Новые координаты для сохранения в базу
    property PositionCellData: TPositionCellData  read FPositionCellData write FPositionCellData;
    // Служебные поля
    property FieldParams: TFieldParamsData  read FFieldParamsData write FFieldParamsData;
    // Стиль простого текста
    property Style: TcxEditStyle read FStyle write FStyle;
    // Стиль выбранного текста
    property StyleFocused: TcxEditStyle read FStyleFocused write FStyleFocused;
    // минимальная ширина
    property MinWidth: Integer read FMinWidth write FMinWidth default 20;
    // минимальная высота
    property MinHeight: Integer read FMinHeight write FMinHeight default 30;
    // Акция отобразить предыдущее значение только для запрета
    property PriorAction: TCustomAction read FPriorAction write FPriorAction;
  end;

  TCheckListBoxAddOn = class(TdsdComponent)
  private
    FCheckListBox: TcxCheckListBox;

    FIdParam: TdsdParam;
    FNameParam: TdsdParam;

    FAfterOpen: TDataSetNotifyEvent;
    FDataSet: TDataSet;

    FKeyList : String;

    function GetKeyList: String;
    procedure SetKeyList(const Value: String);
    procedure OnAfterOpen(ADataSet: TDataSet);
    procedure SetDataSet(const Value: TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // ID записсей
    property KeyList: String read GetKeyList write SetKeyList;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    // Панель для размещения
    property CheckListBox: TcxCheckListBox read FCheckListBox write FCheckListBox;
    // Дата сет с данными
    property DataSet: TDataSet read FDataSet write SetDataSet;
    // ID данных
    property IdParam: TdsdParam  read FIdParam write FIdParam;
    // Name строк
    property NameParam: TdsdParam  read FNameParam write FNameParam;
  end;

  TcxCurrencyEdit_check = class(TcxCurrencyEdit)
  public
  private
    procedure SetButtons(Value: TcxEditButtons);
    function GetButtons: TcxEditButtons;
    procedure SetImages(Value: TCustomImageList);
    function GetImages: TCustomImageList;
  published
    property Buttons: TcxEditButtons read GetButtons write SetButtons;
    property Images: TCustomImageList read GetImages write SetImages;
  end;

  procedure Register;

implementation

uses utilConvert, FormStorage, Xml.XMLDoc, XMLIntf, ADODB, RegularExpressions,
     dxCore, cxFilter, cxClasses, cxLookAndFeelPainters,
     cxGridCommon, math, cxPropertiesStore, UtilConst, cxStorage,
     cxGeometry, cxButtonEdit, cxDBEdit,
     VCL.Menus, ParentForm, ChoicePeriod, cxGrid, cxDBData, Variants,
     cxGridDBBandedTableView, cxGridDBDataDefinitions,cxGridBandedTableView,
     cxMemo, cxMaskEdit, dsdException, Soap.EncdDecd, SimpleGauge;

type

  TcxGridColumnHeaderViewInfoAccess = class(TcxGridColumnHeaderViewInfo);

procedure Register;
begin
  RegisterComponents('DSDComponent', [
    TCrossDBViewAddOn,
    TCrossDBViewReportAddOn,
    THeaderSaver,
    THeaderChanger,
    TdsdDBTreeAddOn,
    TdsdDBViewAddOn,
    TdsdUserSettingsStorageAddOn,
    TRefreshAddOn,
    TRefreshDispatcher,
    TPivotAddOn,
    TdsdGMMap,
    TdsdWebBrowser,
    TdsdEnterManager,
    TdsdFileToBase64,
    TdsdFieldFilter,
    TdsdPropertiesСhange,
    THeaderExit,
    TEnterMoveNext,
    TChartAddOn,
    TCheckerboardAddOn,
    TCheckListBoxAddOn,
    TcxCurrencyEdit_check
  ]);

  RegisterActions('DSDLib', [TExecuteDialog], TExecuteDialog);
end;

{ TdsdDBTreeAddOn }

procedure TdsdDBTreeAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (AComponent = DBTreeList) then
     DBTreeList := nil;
end;

procedure TdsdDBTreeAddOn.onColumnHeaderClick(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
begin
  // сотируем при нажатых Ctrl, Shift или Alt
  if not (ShiftDown or CtrlDown or AltDown) then
     raise ESortException.Create('');
end;

procedure TdsdDBTreeAddOn.onCustomDrawDataCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
  var ADone: Boolean);
begin
  if AViewInfo.Focused then begin
     ACanvas.Brush.Color := clHighlight;
     ACanvas.Font.Color := clHighlightText;
  end;
end;

procedure TdsdDBTreeAddOn.onCustomDrawHeaderCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListHeaderCellViewInfo;
  var ADone: Boolean);
var
  R: TRect;
  ASortingImageSize: Integer;
  ASortingImageIndex: Integer;
begin
   with AViewInfo do begin
    Painter.DrawHeaderBorder(ACanvas,
      cxRectInflate(AViewInfo.BoundsRect, -1, -1),
      AViewInfo.Neighbors, AViewInfo.Borders);

    Painter.DrawHeaderEx(ACanvas,
      BoundsRect, TextBounds, Neighbors, Borders, State, AlignHorz, AlignVert,
      MultiLine, ShowEndEllipsis, Text, ViewParams.Font, ViewParams.TextColor,
      ViewParams.Color, nil);
   end;

   ASortingImageSize := 0;
   if Assigned(SortImages) then
      ASortingImageSize := SortImages.Width;

    R := AViewInfo.BoundsRect;
    R.Left := R.Right - ASortingImageSize - 3;
    InflateRect(R, -1, -1);
    if AViewInfo.SortOrder <> soNone then
    begin
      //ACanvas.Brush.Color := AViewInfo. Color;
      ACanvas.Brush.Style := bsClear;
      if AViewInfo.SortOrder = soAscending then
         ASortingImageIndex := min(0, 11)
      else
         ASortingImageIndex := 11 + min(0, 11);
      if Assigned(SortImages) then
         ACanvas.DrawImage(SortImages, R.Left, R.Top, ASortingImageIndex);
    end;

  ADone := true
end;

procedure TdsdDBTreeAddOn.onGetNodeImageIndex(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; AIndexType: TcxTreeListImageIndexType;
  var AIndex: TImageIndex);
begin
  // Устанавливаем индексы картинок
  if Assigned(FDBTreeList) then
    // Если раскрыта, то всегда изображение раскрытой папки!
    if ANode.Expanded then
       AIndex := 1
    else
       AIndex := 0;
end;

procedure TdsdDBTreeAddOn.SetDBTreeList(const Value: TcxDBTreeList);
begin
  FDBTreeList := Value;
  if Assigned(FDBTreeList) then begin
     FDBTreeList.OnKeyDown := OnKeyDown;
     FDBTreeList.OnDblClick := OnDblClick;
     FDBTreeList.onCustomDrawDataCell := onCustomDrawDataCell;
     FDBTreeList.OnGetNodeImageIndex := OnGetNodeImageIndex;
     FDBTreeList.OnColumnHeaderClick := OnColumnHeaderClick;
     FDBTreeList.OnCustomDrawHeaderCell := OnCustomDrawHeaderCell;
  end;
end;


procedure TdsdDBViewAddOn.ActionOnlyEditingCellOnEnter;
var i: integer;
    NextFocusIndex: integer;
begin
  if ColumnEnterList.Count <> 0 then begin
    // 1. Идем от текущей колонки вправо
    for i := View.Controller.FocusedColumnIndex + 1 to View.VisibleColumnCount - 1 do
        if inColumnEnterList(View.VisibleColumns[i]) then begin
           View.Controller.FocusedColumnIndex := View.VisibleColumns[i].VisibleIndex;
           if (not View.VisibleColumns[i].Editing) and (TcxDBDataController(FView.DataController).DataSource.State in dsEditModes) then
               TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
           if (ColumnEnterList.Count = 1) then View.VisibleColumns[i].Editing:=true;
           exit;
        end;

    for i := 0 to View.Controller.FocusedColumnIndex do
        if inColumnEnterList(View.VisibleColumns[i]) then
        begin
           View.Controller.FocusedColumnIndex := View.VisibleColumns[i].VisibleIndex;
           if  ((ColumnEnterList.Count = 1) and (TcxDBDataController(FView.DataController).DataSource.State in dsEditModes))
            or ((not View.VisibleColumns[i].Editing) and (TcxDBDataController(FView.DataController).DataSource.State in dsEditModes))
           then
               TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
           if (ColumnEnterList.Count = 1) then View.VisibleColumns[i].Editing:=true;
           exit;
        end;
  end
  else begin
    // 1. Смотрим куда может идти
    NextFocusIndex := -1;
    for I := View.Controller.FocusedColumnIndex + 1 to View.VisibleColumnCount - 1 do
        if View.VisibleColumns[i].Editable then begin
           NextFocusIndex := i;
           break;
        end;
    // 2. Если есть куда на этой строчке, то идем на этой строчке
    if NextFocusIndex > -1 then begin
       View.Controller.FocusedColumnIndex := NextFocusIndex;
       View.Controller.FocusedItem.Editing := true;
    end;
    // 3. Если на этой строчке некуда и находимся в состоянии редактирования, то Post
    if (NextFocusIndex = -1) and (TcxDBDataController(FView.DataController).DataSource.State in [dsEdit, dsInsert]) then
       TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
    // 4. Если есть куда на следующей, то идем на следующую
  end
end;

constructor TdsdDBViewAddOn.Create(AOwner: TComponent);
begin
  inherited;
  edFilter := TcxTextEdit.Create(Self);
  edFilter.OnKeyDown := edFilterKeyDown;
  edFilter.Visible := false;

  edFilter.OnExit := edFilterExit;
  FBackGroundStyle := TcxStyle.Create(nil);
  FBackGroundStyle.Color := $00E4E4E4;
  FErasedStyle := TcxStyle.Create(nil);
  FErasedStyle.TextColor := clRed;

  FMemoryStream := TMemoryStream.Create;
  FColorRuleList := TCollection.Create(TColorRule);
  FColumnAddOnList := TCollection.Create(TColumnAddOn);
  FColumnEnterList := TCollection.Create(TColumnCollectionItem);
  FPropertiesCellList := TCollection.Create(TPropertiesCell);
  FSummaryItemList := TOwnedCollection.Create(Self, TSummaryItemAddOn);
  FShowFieldImageList := TOwnedCollection.Create(Self, TShowFieldImage);
  FViewDocumentList := TOwnedCollection.Create(Self, TViewDocument);
  FChartList := TOwnedCollection.Create(Self, TdsdChartView);

  SearchAsFilter := true;
  FKeepSelectColor := false;

  FGroupByBox := False;
  FGroupIndex := -1;
  FFilterSelectAll := False;
  FFilterLoadFile := False;

  FViewDocumentParam := TViewDocumentParam.Create;
  FViewDocumentParam.PDFScaleMode := TPdfControlScaleMode.smFitAuto;
  FViewDocumentParam.PDFZoomPercentage := 100;
end;

procedure TdsdDBViewAddOn.OnAfterOpen(ADataSet: TDataSet);
  var I, J : Integer;
begin
  if Assigned(Self.View) then
     if Assigned(Self.View.Control) then
        TcxGrid(Self.View.Control).EndUpdate;
  if Assigned(FAfterOpen) then
     FAfterOpen(ADataSet);

   // Пересоздаем диаграммы диаграммы
   for i := 0 to FChartList.Count - 1 do
   begin
     if Assigned(TdsdChartView(FChartList.Items[I]).FChartView) then
     with TdsdChartView(FChartList.Items[I]) do
     begin

       FChartView.BeginUpdate;

       //  Очтстием перед перестроеемем
       if FChartCDS.Active then
       begin
         FChartView.DataController.DataSource := Nil;
         FChartView.ClearSeries;
         FChartView.ClearDataGroups;
         if FChartCDS.Active then FChartCDS.Close;
         FChartCDS.FieldDefs.Clear;
         if Assigned(FDisplayedDataComboBox) then
         begin
           try
             DisplayedDataComboBox.Properties.OnChange := Nil;
             FDisplayedDataComboBox.Properties.Items.Clear;
             FDisplayedDataComboBox.Text := '';
           finally
             FDisplayedDataComboBox.Properties.OnChange := OnChangeDisplayedData;
           end;
         end;
       end;

       if Assigned(DisplayedDataComboBox) and (FChartVariantList.Count > 0) and Assigned(View) and
          Assigned(TcxDBDataController(View.DataController).DataSource) then
       begin
         try
           DisplayedDataComboBox.Properties.OnChange := Nil;


           for J := 0 to FChartVariantList.Count - 1 do
           begin
             DisplayedDataComboBox.Properties.Items.Add(TdsdChartVariant(FChartVariantList.Items[J]).HeaderName);
           end;

           if FDisplayedIndex < 0 then FDisplayedIndex := 0;

           DisplayedDataComboBox.ItemIndex := FDisplayedIndex;

           if FisShowTitle then FChartView.Title.Text := DisplayedDataComboBox.Properties.Items[FDisplayedIndex]
           else FChartView.Title.Text := '';
         finally
           FDisplayedDataComboBox.Properties.OnChange := OnChangeDisplayedData;
         end;
       end else
       begin
         FDisplayedIndex := -1;
         FChartView.Title.Text := '';
       end;

       FChartView.DataController.DataSource := FChartDS;
       if FDisplayedIndex >= 0 then  with TdsdChartVariant(FChartVariantList.Items[FDisplayedIndex]) do
       try

         // Добавляем поля
         FChartCDS.FieldDefs.Add('GroupsFielddName',      ftString, 20);

         // Строим диограмму
         with FChartView.CreateDataGroup do
         begin
           DisplayText := ''; //HeaderName;
           DataBinding.FieldName := 'GroupsFielddName';
         end;

         for J := 0 to FChartSeriesList.Count - 1 do
         begin

           with FChartView.CreateSeries do
           begin
             if TdsdChartSeries(FChartSeriesList.Items[J]).ColumnList.Count > 0 then
             begin

               DisplayText := TdsdChartSeries(FChartSeriesList.Items[J]).SeriesName;
               DataBinding.FieldName := 'SeriesList_' + IntToStr(J);

               if (TdsdChartSeries(FChartSeriesList.Items[J]).ColumnList.Count > 0) and
                 Assigned(TdsdChartColumn(TdsdChartSeries(FChartSeriesList.Items[J]).ColumnList.Items[0]).Column)  then
               begin
                 case TcxDBDataController(View.DataController).DataSource.DataSet.FindField(TcxGridDBBandedColumn(
                   TdsdChartColumn(TdsdChartSeries(FChartSeriesList.Items[J]).ColumnList.Items[0]).Column).DataBinding.FieldName).DataType of
                   ftInteger : FChartCDS.FieldDefs.Add('SeriesList_' + IntToStr(J), ftInteger, 0);
                   else FChartCDS.FieldDefs.Add('SeriesList_' + IntToStr(J), ftFloat, 0);
                 end;
               end else FChartCDS.FieldDefs.Add('SeriesList_' + IntToStr(J), ftFloat, 0);
             end;
           end;
         end;


         if FChartCDS.FieldDefs.Count > 1 then FChartCDS.CreateDataSet;

           // Строки в FChartCDS диаграмму
         if FChartCDS.Active then
         begin

           for J := 0 to TdsdChartSeries(FChartSeriesList.Items[0]).ColumnList.Count - 1 do
           begin
             FChartCDS.Last;
             FChartCDS.Append;
             FChartCDS.FieldByName('GroupsFielddName').AsString := TdsdChartColumn(TdsdChartSeries(FChartSeriesList.Items[0]).ColumnList.Items[j]).FTitle;
             FChartCDS.Post;
           end;
         end;
       finally
         FChartView.EndUpdate;
       end;
     end;
   end;

   if FChartList.Count > 0 then OnAfterScroll(ADataSet);
end;

procedure TdsdDBViewAddOn.OnBeforeOpen(ADataSet: TDataSet);
var Item: TCollectionItem;
begin
  if Assigned(FBeforeOpen) then
     FBeforeOpen(ADataSet);
  if Assigned(Self.View) then
     if Assigned(Self.View.Control) then
        TcxGrid(Self.View.Control).BeginUpdate;
  for Item in ShowFieldImageList do
    if Assigned(TShowFieldImage(Item).Image) then TShowFieldImage(Item).Image.Clear;

  for Item in ViewDocumentList do TViewDocument(Item).Clear;
end;

procedure TdsdDBViewAddOn.OnColumnHeaderClick(Sender: TcxGridTableView;
  AColumn: TcxGridColumn);
begin
  // сотируем при нажатых Ctrl, Shift или Alt
  if not (ShiftDown or CtrlDown or AltDown) then
     Abort;
end;

function TdsdDBViewAddOn.GetColumnAddOn(FindColumn: TcxGridColumn): TColumnAddOn;
var Item: TCollectionItem;
begin
  result := nil;
  for Item in ColumnAddOnList do
      if TColumnAddOn(Item).Column = FindColumn then
      begin
        result := TColumnAddOn(Item);
        break;
      end;
end;

function TdsdDBViewAddOn.GetErasedColumn(Sender: TObject): TcxGridColumn;
begin
  result := nil;
  if (Sender is TcxGridDBTableView) then
      result := TcxGridDBTableView(Sender).GetColumnByFieldName(FErasedFieldName);
  if (Sender is TcxGridDBBandedTableView) then
      result := TcxGridDBBandedTableView(Sender).GetColumnByFieldName(FErasedFieldName);
end;

procedure TdsdDBViewAddOn.OnCustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
  var ADone: Boolean);
var Column: TcxGridColumn; i, j : integer; bManual : boolean;
begin

  bManual := False;
//  ACanvas.Font.Color := clWindowText;

  if FKeepSelectColor and (AViewInfo.Selected or AViewInfo.Focused) then begin
    // Работаем с условиями
    try
      for i := 0 to ColorRuleList.Count - 1 do
        with TColorRule(ColorRuleList.Items[i]) do begin
          if Assigned(ColorColumn) then
          begin
            if TcxGridDBTableView(Sender).Columns[AViewInfo.Item.Index] = ColorColumn then begin
             //сначала Bold, !!!но так не работает, поэтому - отключил!!!!
//             if Assigned(ValueBoldColumn) then
//                if not VarIsNull(AViewInfo.GridRecord.Values[ValueBoldColumn.Index]) then
//                begin
//                  if AnsiUpperCase(AViewInfo.GridRecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true') then
//                    ACanvas.Font.Style:= ACanvas.Font.Style + [fsBold]
//                  else ACanvas.Font.Style:= ACanvas.Font.Style - [fsBold];
//                end;

             if Assigned(ValueColumn) and (AViewInfo.GridRecord.ValueCount > ValueColumn.Index) then
                if not VarIsNull(AViewInfo.GridRecord.Values[ValueColumn.Index]) then
                begin
                   // иначе надо оставить цвет без изменения
                   if AViewInfo.GridRecord.Values[ValueColumn.Index] >= 0
                   then ACanvas.Font.Color := AViewInfo.GridRecord.Values[ValueColumn.Index];

                   bManual := True;
                end;
             if Assigned(BackGroundValueColumn) and (AViewInfo.GridRecord.ValueCount > BackGroundValueColumn.Index) then
                if not VarIsNull(AViewInfo.GridRecord.Values[BackGroundValueColumn.Index]) then
                begin
                  begin
                    j := BackGroundValueColumn.Index;

                    // иначе надо оставить цвет без изменения
                    if AViewInfo.GridRecord.Values[BackGroundValueColumn.Index] >= 0
                    then ACanvas.Brush.Color := AViewInfo.GridRecord.Values[BackGroundValueColumn.Index];

                    bManual := True;
                  end;
                end;
             end;
          end
          else begin
             //сначала Bold, !!!но так не работает, поэтому - отключил!!!!
//             if Assigned(ValueBoldColumn) then
//                if not VarIsNull(AViewInfo.GridRecord.Values[ValueBoldColumn.Index]) then
//                begin
//                  if AnsiUpperCase(AViewInfo.GridRecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true') then
//                    ACanvas.Font.Style:= ACanvas.Font.Style + [fsBold]
//                  else ACanvas.Font.Style:= ACanvas.Font.Style - [fsBold];
//                end;

             //
             if Assigned(ValueColumn) then
                if not VarIsNull(AViewInfo.GridRecord.Values[ValueColumn.Index]) then begin
                   ACanvas.Font.Color := AViewInfo.GridRecord.Values[ValueColumn.Index];
                   bManual := True;
                end;
             if Assigned(BackGroundValueColumn) then
                if not VarIsNull(AViewInfo.GridRecord.Values[BackGroundValueColumn.Index]) then begin
                   ACanvas.Brush.Color := AViewInfo.GridRecord.Values[BackGroundValueColumn.Index];
                   ACanvas.Font.Color := clWindowText;
                   bManual := True;
                end;
          end;
        end;
    except
      on E: Exception do ShowMessage(E.Message + ' ' +IntToStr(AViewInfo.GridRecord.ValueCount)  + ' ' +  IntToStr(J));
    end;
  end;

  // РРисуем прямоугольник
//  try
//    for i := 0 to ColorRuleList.Count - 1 do
//      with TColorRule(ColorRuleList.Items[i]) do begin
//        if Assigned(ColorColumn) then
//        begin
//           if TcxGridDBTableView(Sender).Columns[AViewInfo.Item.Index] = ColorColumn then begin
//           if Assigned(FRectangleColorColumn) and (AViewInfo.GridRecord.ValueCount > FRectangleColorColumn.Index) then
//              if not VarIsNull(AViewInfo.GridRecord.Values[FRectangleColorColumn.Index]) then begin
//                 ACanvas.Pen.Color := AViewInfo.GridRecord.Values[FRectangleColorColumn.Index];
//                 ACanvas.Rectangle(Rect(AViewInfo.Bounds.Left + 1, AViewInfo.Bounds.Top + 1,
//                   AViewInfo.Bounds.Right - 1, AViewInfo.Bounds.Bottom - 2));
//                 bManual := True;
//              end;
//            end;
//        end
//        else begin
//           if Assigned(FRectangleColorColumn) then
//              if not VarIsNull(AViewInfo.GridRecord.Values[FRectangleColorColumn.Index]) then begin
//                 ACanvas.Pen.Color := AViewInfo.GridRecord.Values[FRectangleColorColumn.Index];
//                 ACanvas.Rectangle(Rect(AViewInfo.Bounds.Left + 1, AViewInfo.Bounds.Top + 1,
//                   AViewInfo.Bounds.Right - 1, AViewInfo.Bounds.Bottom - 2));
//                 bManual := True;
//                 AViewInfo.Bounds.Left := AViewInfo.Bounds.Left + 1;
//              end;
//        end;
//      end;
//  except
//    on E: Exception do ShowMessage(E.Message + ' ' +IntToStr(AViewInfo.GridRecord.ValueCount)  + ' ' +  IntToStr(J));
//  end;


  // Работаем с условиями  Bold
  try
    for i := 0 to ColorRuleList.Count - 1 do
      with TColorRule(ColorRuleList.Items[i]) do begin
        if Assigned(ColorColumn) then
        begin
          if TcxGridDBTableView(Sender).Columns[AViewInfo.Item.Index] = ColorColumn then begin

           if Assigned(ValueBoldColumn) then
              if not VarIsNull(AViewInfo.GridRecord.Values[ValueBoldColumn.Index]) then
              begin
                if AnsiUpperCase(AViewInfo.GridRecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true') then
                  ACanvas.Font.Style:= ACanvas.Font.Style + [fsBold]
                else ACanvas.Font.Style:= ACanvas.Font.Style - [fsBold];
              end;


          end;
        end
        else begin

           if Assigned(ValueBoldColumn) then
              if not VarIsNull(AViewInfo.GridRecord.Values[ValueBoldColumn.Index]) then
              begin
                if AnsiUpperCase(AViewInfo.GridRecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true') then
                  ACanvas.Font.Style:= ACanvas.Font.Style + [fsBold]
                else ACanvas.Font.Style:= ACanvas.Font.Style - [fsBold];
              end;

        end;
      end;
  except
    on E: Exception do ShowMessage(E.Message + ' ' +IntToStr(AViewInfo.GridRecord.ValueCount)  + ' ' +  IntToStr(J));
  end;

  if not bManual and AViewInfo.Focused then begin
     ACanvas.Brush.Color := clHighlight;
     if SearchAsFilter then
        ACanvas.Font.Color := clHighlightText
     else
        ACanvas.Font.Color := clYellow;
  end;

  // работаем со свойством Удален
  Column := GetErasedColumn(Sender);
  if Assigned(Column) then
     if not VarIsNull(AViewInfo.GridRecord.Values[Column.Index])
        and AViewInfo.GridRecord.Values[Column.Index] then
            ACanvas.Font.Color := FErasedStyle.TextColor;
end;

procedure TdsdDBViewAddOn.OnGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem;
  {$IFDEF DELPHI103RIO} var {$ELSE} out {$ENDIF} AStyle: TcxStyle);
var Column: TcxGridColumn;
    i, j: integer;
begin
  if Assigned(FOnGetContentStyleEvent) then
     FOnGetContentStyleEvent(Sender, ARecord, AItem, AStyle);

  if ARecord = nil then exit;
  // Если это сгруппированная строка, то выходим
  if not ARecord.IsData then exit;

  // работаем со свойством Удален
  Column := GetErasedColumn(Sender);
  if Assigned(Column) then
     if not VarIsNull(ARecord.Values[Column.Index])
        and ARecord.Values[Column.Index] then
            AStyle := FErasedStyle;

  // Работаем с условиями
  try
    for i := 0 to ColorRuleList.Count - 1 do
      with TColorRule(ColorRuleList.Items[i]) do begin
        if Assigned(ColorColumn) then
        begin
          if AItem = ColorColumn then begin
           //сначала Bold, !!!но так не работает, поэтому - отключил!!!!
//           if Assigned(ValueBoldColumn) then
//              if not VarIsNull(ARecord.Values[ValueBoldColumn.Index])  then
//              begin
//                if Assigned(AStyle) and Assigned(AStyle.Font) then
//                  FStyle.Font.Style := AStyle.Font.Style
//                else FStyle.Font.Style := [];
//
//                if AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true') then
//                  FStyle.Font.Style:= FStyle.Font.Style + [fsBold]
//                else FStyle.Font.Style:= FStyle.Font.Style - [fsBold];
//                AStyle := FStyle;
//              end;

           if Assigned(AStyle) and Assigned(AStyle.Font) then
             FStyle.Font.Style := AStyle.Font.Style
           else FStyle.RestoreDefaults;

           if Assigned(ValueColumn) and (ARecord.ValueCount > ValueColumn.Index) then
              if not VarIsNull(ARecord.Values[ValueColumn.Index]) then begin
                 FStyle.TextColor := ARecord.Values[ValueColumn.Index];

                 //
                 if Assigned(AStyle) then FStyle.Color:= AStyle.Color;
                 // иначе надо оставить стиль без изменения
                 if ARecord.Values[ValueColumn.Index] >= 0
                 then AStyle := FStyle;

              end;
           if Assigned(BackGroundValueColumn) and (ARecord.ValueCount > BackGroundValueColumn.Index) then
              if not VarIsNull(ARecord.Values[BackGroundValueColumn.Index]) then
              begin
                begin
                  j := BackGroundValueColumn.Index;
                  FStyle.Color := ARecord.Values[BackGroundValueColumn.Index];
                end;
                //
                if Assigned(AStyle) then FStyle.TextColor:= AStyle.TextColor;
                // иначе надо оставить стиль без изменения
                if ARecord.Values[BackGroundValueColumn.Index] >= 0
                then AStyle := FStyle;

              end;
           end;
        end
        else begin

           //сначала Bold, !!!но так не работает, поэтому - отключил!!!!
//           if Assigned(ValueBoldColumn) then
//              if not VarIsNull(ARecord.Values[ValueBoldColumn.Index]) then
//              begin
//                if Assigned(AStyle) and Assigned(AStyle.Font) then
//                  FStyle.Font.Style := AStyle.Font.Style
//                else FStyle.Font.Style := [];
//
//                if AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true') then
//                  FStyle.Font.Style:= FStyle.Font.Style + [fsBold]
//                else FStyle.Font.Style:= FStyle.Font.Style - [fsBold];
//                AStyle := FStyle;
//              end;

           if Assigned(AStyle) and Assigned(AStyle.Font) then
             FStyle.Font.Style := AStyle.Font.Style
           else FStyle.RestoreDefaults;

           if Assigned(ValueColumn) then
              if not VarIsNull(ARecord.Values[ValueColumn.Index]) then begin
                 FStyle.TextColor := ARecord.Values[ValueColumn.Index];

                 // иначе надо оставить стиль без изменения
                 if ARecord.Values[ValueColumn.Index] >= 0
                 then AStyle := FStyle;

              end;
           if Assigned(BackGroundValueColumn) then
              if not VarIsNull(ARecord.Values[BackGroundValueColumn.Index]) then begin
                 FStyle.Color := ARecord.Values[BackGroundValueColumn.Index];
                 // иначе надо оставить стиль без изменения
                 if ARecord.Values[BackGroundValueColumn.Index] >= 0
                 then AStyle := FStyle;

              end;

        end;
      end;
  except
    on E: Exception do ShowMessage(E.Message + ' ' +IntToStr(ARecord.ValueCount)  + ' ' +  IntToStr(J));
  end;

end;


procedure TdsdDBViewAddOn.OnCustomDrawColumnHeader(
  Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  I: Integer;
  R: TRect;
  ASortingImageSize: Integer;
  ASortingImageIndex: Integer;
begin
  // вот так останется "нужный" рисунок - 10.04.2016
  if not AViewInfo.Column.HeaderGlyph.Empty then exit;

  ASortingImageSize := 0;
  if Assigned(SortImages) then
     ASortingImageSize := SortImages.Width;
  with AViewInfo do
  begin
    Sender.Painter.LookAndFeelPainter.DrawHeader(ACanvas, Bounds, TextAreaBounds, Neighbors,
      Borders, ButtonState, AlignmentHorz, AlignmentVert, MultiLinePainting, TcxGridColumnHeaderViewInfoAccess(AViewinfo).ShowEndEllipsis,
      Text, Params.Font, Params.TextColor, Params.Color,
      nil, Column.IsMostRight,
      Container.Kind = ckGroupByBox);
    R := AViewInfo.ContentBounds;
    R.Left := R.Right - ASortingImageSize - 3;
    InflateRect(R, -1, -1);
    with TcxGridColumnHeaderViewInfoAccess(AViewinfo) do
      for I := 0 to AreaViewInfoCount - 1 do
        if AreaViewInfos[I] is TcxGridColumnHeaderFilterButtonViewInfo then
        begin
          if AViewInfo.ButtonState = cxbsHot then
          begin
            Sender.Painter.LookAndFeelPainter.DrawFilterDropDownButton(Canvas, AreaViewInfos[I].Bounds,
              GridCellStateToButtonState(AreaViewInfos[I].State), TcxGridColumnHeaderFilterButtonViewInfo(AreaViewInfos[I]).Active);
            R.Right := AreaViewInfos[I].Bounds.Left - 3;
            R.Left := R.Right - ASortingImageSize;
          end;
        end;
    if AViewInfo.Column.SortOrder <> soNone then
    begin
      ACanvas.Brush.Color := AViewInfo.Params.Color;
      ACanvas.Brush.Style := bsClear;
      if AViewInfo.Column.SortOrder = soAscending then
         ASortingImageIndex := min(AViewInfo.Column.SortIndex, 11)
      else
         ASortingImageIndex := 11 + min(AViewInfo.Column.SortIndex, 11);
      if Assigned(SortImages) then
         ACanvas.DrawImage(SortImages, R.Left, R.Top, ASortingImageIndex);
    end;
    ADone := True;
  end;
end;

procedure TdsdDBViewAddOn.OnExit(Sender: TObject);
begin
  if Assigned(FonExit) then
     FOnExit(Sender);
  if Assigned(View) then
     if Assigned(TcxDBDataController(View.DataController).DataSource) then
        if TcxDBDataController(View.DataController).DataSource.State in dsEditModes then
           try
             TcxDBDataController(View.DataController).DataSource.DataSet.Post;
             // В случае ошибки оставляем фокус
           except
             on E: Exception do begin
               View.Control.SetFocus;
               raise;
             end;
           end;
end;

procedure TdsdDBViewAddOn.onFilterChanged(Sender: TObject);
begin
  if View.DataController.Filter.Root.Count > 0 then
     View.Styles.Background := FBackGroundStyle
  else
     View.Styles.Background := nil
end;

destructor TdsdDBViewAddOn.Destroy;
begin
  if Assigned(FView) then begin
    FView.OnKeyDown := nil;
    FView.OnKeyPress := nil;
    FView.OnCustomDrawColumnHeader := nil;
    FView.DataController.Filter.OnChanged := nil;
    FView.OnColumnHeaderClick := nil;
    FView.OnDblClick := nil;
    FView.OnCustomDrawCell := nil;
    if Assigned(TcxDBDataController(FView.DataController).DataSource) then
       if Assigned(TcxDBDataController(FView.DataController).DataSource.DataSet) then
    begin
       TcxDBDataController(FView.DataController).DataSource.DataSet.AfterInsert := nil;
       TcxDBDataController(FView.DataController).DataSource.DataSet.AfterScroll := FAfterScroll;
    end;
  end;
  FErasedStyle.Free;
  FreeAndNil(FColumnAddOnList);
  FreeAndNil(FColumnEnterList);
  FreeAndNil(FPropertiesCellList);
  FreeAndNil(FSummaryItemList);
  FreeAndNil(FShowFieldImageList);
  FreeAndNil(FChartList);
  FreeAndNil(FViewDocumentList);
  FreeAndNil(FViewDocumentParam);
  FMemoryStream.Free;
  inherited;
end;

procedure TdsdDBViewAddOn.edFilterExit(Sender: TObject);
begin
  edFilter.Visible:=false;
  TWinControl(View.GetParentComponent).SetFocus;
  View.Focused := true;
end;

procedure TdsdDBViewAddOn.edFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: begin lpSetFilter; Key := 0; end;
    VK_ESCAPE: edFilterExit(Sender);
  end;
end;

procedure TdsdDBViewAddOn.GridEditKeyEvent(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(FGridEditKeyEvent) then
     FGridEditKeyEvent(Sender, AItem, AEdit, Key, Shift);
  // Если нажат ТОЛЬКО Enter и OnlyEditingCellOnEnter
  if (Key = VK_RETURN) and (Shift = []) and OnlyEditingCellOnEnter then begin
     ActionOnlyEditingCellOnEnter;
     Key := 0;
  end;
end;

function TdsdDBViewAddOn.inColumnEnterList(Column: TcxGridColumn): boolean;
var i: integer;
begin
  result := false; //ColumnEnterList.Count = 1;
  for i := 0 to ColumnEnterList.Count - 1  do
      if Column = TColumnCollectionItem(ColumnEnterList.Items[i]).Column then begin
         result := true;
         break;
      end;
end;

procedure TdsdDBViewAddOn.Loaded;
var i: integer;
begin
  inherited;
  // обработаем список ColumnAddOnList
  for I := 0 to ColumnAddOnList.Count - 1 do
      TColumnAddOn(ColumnAddOnList.Items[i]).Init;
  for I := 0 to SummaryItemList.Count - 1 do
      TSummaryItemAddOn(SummaryItemList.Items[i]).DataSummaryItemIndex := TSummaryItemAddOn(SummaryItemList.Items[i]).DataSummaryItemIndex
end;

procedure TdsdDBViewAddOn.lpSetEdFilterPos(inKey: Char);
// процедура устанавливает контрол для внесения значения фильтра и позиционируется на заголовке колонки
var pRect:TRect;
begin
 if (not edFilter.Visible) and (Pos('Grid', Screen.ActiveControl.ClassName) > 0) then
   with View.Controller do begin
     // позиционируем контрол на место заголовка
     try
       edFilter.Visible := true;
       edFilter.Parent := TWinControl(Screen.ActiveControl);
       pRect := View.ViewInfo.HeaderViewInfo.Items[FocusedItemIndex].Bounds;
       edFilter.Left := pRect.Left;
       edFilter.Top := pRect.Top;
       edFilter.Width := pRect.Right - pRect.Left + 1;
       edFilter.Height := pRect.Bottom - pRect.Top;
       edFilter.SetFocus;
       edFilter.Text := inKey;
       edFilter.SelStart := 1;
       edFilter.SelLength := 0;
     except
        edFilterExit(Nil);
     end;
   end;
end;

procedure TdsdDBViewAddOn.lpSetFilter;
   function GetFilterItem(ItemLink: TObject): TcxFilterCriteriaItem;
   var i: integer;
   begin
     result := nil;
     with View.DataController.Filter.Root do
       for i := 0 to Count - 1 do
           if Items[i] is TcxFilterCriteriaItem then
              if TcxFilterCriteriaItem(Items[i]).ItemLink = ItemLink then begin
                 result := TcxFilterCriteriaItem(Items[i]);
                 exit;
              end;
   end;
var
  FilterCriteriaItem: TcxFilterCriteriaItem;
  vbValue: string;
  CurrentColumn: TcxGridColumn;
  ColumnAddOn: TColumnAddOn;
begin
  CurrentColumn := View.VisibleColumns[TcxGridDBDataController(View.DataController).Controller.FocusedItemIndex];
  ColumnAddOn := GetColumnAddOn(CurrentColumn);

  if Assigned(ColumnAddOn) and ColumnAddOn.FindByFullValue then
  begin
    if ShiftDown then
       vbValue := '%' + edFilter.Text + '%'
    else
       vbValue := edFilter.Text;
  end
  else begin
    if (length(edFilter.Text) = 1) and (not CharInSet(edFilter.Text[1], ['0'..'9'])) then
       vbValue := edFilter.Text + '%'
    else begin
       if ShiftDown then
          vbValue := edFilter.Text
       else
          vbValue := '%' + edFilter.Text + '%';
    end;
  end;
  edFilter.Visible := false;
  with TcxGridDBDataController(View.DataController), Filter.Root do begin
    FilterCriteriaItem := GetFilterItem(GetItem(CurrentColumn.Index));
    if Assigned(FilterCriteriaItem) then begin
       FilterCriteriaItem.Value := vbValue;
       FilterCriteriaItem.DisplayValue := '"' + edFilter.Text + '"';
    end
    else
       AddItem(GetItem(CurrentColumn.Index), foLike, vbValue, '"' + edFilter.Text + '"');
  end;
  edFilter.Text := '';
  View.DataController.Filter.Active := True;
  if View.DataController.FilteredRecordCount > 0 then
     View.DataController.FocusedRecordIndex := View.DataController.FilteredRecordIndex[0];
end;

procedure TdsdDBViewAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (AComponent = FView) then begin
     FView := nil;
  end;
end;

procedure TdsdDBViewAddOn.ClearDuplicateSearch;
begin
  if not Assigned(View) then Exit;

  if FGroupIndex >= 0 then
  begin
    View.DataController.Filter.Clear;
    View.Columns[FGroupIndex].GroupIndex := -1;
    if not FGroupByBox then View.OptionsView.GroupByBox := False;
    FGroupIndex := -1;
  end;
end;


procedure TdsdDBViewAddOn.ActionDuplicateSearch;
  var I, J : Integer; lOne, lFilter : TStringList;
begin
  if not Assigned(View) then Exit;

  if FGroupIndex >= 0 then
  begin
    ClearDuplicateSearch;
    Exit;
  end;

  if not Assigned(View.Controller.FocusedColumn) then Exit;

  lOne := TStringList.Create;
  lOne.Sorted := True;
  lFilter := TStringList.Create;
  lFilter.Sorted := True;
  try
    for i := 0 to View.DataController.FilteredRecordCount - 1 do
    begin
      if (View.DataController.Values[I, View.Controller.FocusedColumnIndex] <> Null) and
        (VarToStr(View.DataController.Values[I, View.Controller.FocusedColumnIndex]) <> '') then
         if lOne.Find(VarToStr(View.DataController.Values[I, View.Controller.FocusedColumnIndex]), J) then
         begin
           if not lFilter.Find(VarToStr(View.DataController.Values[I, View.Controller.FocusedColumnIndex]), J) then
             lFilter.Add(VarToStr(View.DataController.Values[I, View.Controller.FocusedColumnIndex]));
         end else lOne.Add(VarToStr(View.DataController.Values[I, View.Controller.FocusedColumnIndex]));
    end;

    if lFilter.Count < 1 then
    begin
      ShowMessage('По столбику <' + View.Controller.FocusedColumn.Caption + '>'#13#10'повторяющихся не пустых значений не найдено.');
      Exit;
    end;

    with View.DataController.Filter do
    begin
      BeginUpdate;
      try
        Clear;
        root.BoolOperatorKind := TcxFilterBoolOperatorKind.fboOr;
        for I := 0 to lFilter.Count - 1 do
        begin
          root.AddItem(View.Controller.FocusedColumn, TcxFilterOperatorKind.foEqual, lFilter.Strings[I], lFilter.Strings[I]);
        end;
        Active := true;
        View.OptionsView.GroupByBox := True;
        FGroupIndex := View.Controller.FocusedColumnIndex;
        if View.OptionsView.GroupByBox then View.Controller.FocusedColumn.GroupIndex := 0;
      finally
        EndUpdate;
      end;
    end;

  finally
    lOne.Free;
    lFilter.Free;
  end;
end;

procedure TdsdDBViewAddOn.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and (View.DataController.Filter.Active) then begin
      View.DataController.Filter.Clear;
      View.DataController.Filter.Active := false;
  end;
  if (Key = VK_RETURN) and (Shift = []) and OnlyEditingCellOnEnter then begin
     ActionOnlyEditingCellOnEnter;
     Key := 0;
  end;
  if Key = VK_F11 then
     SearchAsFilter := not SearchAsFilter;
  if (Key = 68) and (ssCtrl in Shift) then
  begin
    ActionDuplicateSearch;
    Key := 0;
  end;
  inherited;
end;

procedure TdsdDBViewAddOn.OnAfterScroll(DataSet: TDataSet);
  var Item: TCollectionItem;
      Data : AnsiString; Len, I, J : Integer;
      Graphic: TGraphic; Ext, FieldName: string;
      GraphicClass: TGraphicClass;
begin
  if Assigned(FAfterScroll) then FAfterScroll(DataSet);
  if DataSet.IsEmpty then Exit;
  if View.DataController.IsDataLoading then Exit;

  for Item in ShowFieldImageList do
  begin
    if Assigned(TShowFieldImage(Item).Image) then TShowFieldImage(Item).Image.Clear;
    if (TShowFieldImage(Item).FieldName <> '') and Assigned(TShowFieldImage(Item).Image)  and
       Assigned(DataSet.FindField(TShowFieldImage(Item).FieldName)) then
    try
      try
        if Length(DataSet.FieldByName(TShowFieldImage(Item).FieldName).AsString) <= 4 then Continue;

        Data := ReConvertConvert(DataSet.FieldByName(TShowFieldImage(Item).FieldName).AsString);
        Ext := trim(Copy(Data, 1, 255));
        Ext := AnsiLowerCase(ExtractFileExt(Ext));
        Delete(Ext, 1, 1);

        if 'wmf' = Ext then GraphicClass := TMetafile;
        if 'emf' =  Ext then GraphicClass := TMetafile;
        if 'ico' =  Ext then GraphicClass := TIcon;
        if 'tiff' = Ext then GraphicClass := TWICImage;
        if 'tif' = Ext then GraphicClass := TWICImage;
        if 'png' = Ext then GraphicClass := TWICImage;
        if 'gif' = Ext then GraphicClass := TWICImage;
        if 'jpeg' = Ext then GraphicClass := TWICImage;
        if 'jpg' = Ext then GraphicClass := TWICImage;
        if 'bmp' = Ext then GraphicClass := TBitmap;
        if GraphicClass = nil then Continue;

        Data := Copy(Data, 256, maxint);
        Len := Length(Data);
        FMemoryStream.WriteBuffer(Data[1],  Len);
        FMemoryStream.Position := 0;

        Graphic := TGraphicClass(GraphicClass).Create;
        try
          Graphic.LoadFromStream(FMemoryStream);
          TShowFieldImage(Item).Image.Picture.Graphic := Graphic;
        finally
          Graphic.Free;
        end;
      finally
        FMemoryStream.Clear;
      end;
    except
    end;
  end;

  for Item in ViewDocumentList do
  begin
    TViewDocument(Item).Clear;
    if (TViewDocument(Item).FieldName <> '') and Assigned(TViewDocument(Item).Control)  and
       Assigned(DataSet.FindField(TViewDocument(Item).FieldName)) then
    try
      try
        if Assigned(TViewDocument(Item).FPdfCtrl) then FreeAndNil(TViewDocument(Item).FPdfCtrl);
        if Assigned(TViewDocument(Item).FImage) then FreeAndNil(TViewDocument(Item).FImage);
        if Length(DataSet.FieldByName(TViewDocument(Item).FieldName).AsString) <= 4 then Continue;

        Data := ReConvertConvert(DataSet.FieldByName(TViewDocument(Item).FieldName).AsString);
        Ext := trim(Copy(Data, 1, 255));
        Ext := AnsiLowerCase(ExtractFileExt(Ext));
        Delete(Ext, 1, 1);

        if 'pdf' = Ext then
        begin
          Data := Copy(Data, 256, maxint);
          Len := Length(Data);
          FMemoryStream.WriteBuffer(Data[1],  Len);
          FMemoryStream.Position := 0;

          TViewDocument(Item).ShowPDF(FMemoryStream);

        end else
        begin

          if 'wmf' = Ext then GraphicClass := TMetafile
          else if 'emf' =  Ext then GraphicClass := TMetafile
          else if 'ico' =  Ext then GraphicClass := TIcon
          else if 'tiff' = Ext then GraphicClass := TWICImage
          else if 'tif' = Ext then GraphicClass := TWICImage
          else if 'png' = Ext then GraphicClass := TWICImage
          else if 'gif' = Ext then GraphicClass := TWICImage
          else if 'jpeg' = Ext then GraphicClass := TWICImage
          else if 'jpg' = Ext then GraphicClass := TWICImage
          else if 'bmp' = Ext then GraphicClass := TBitmap
          else GraphicClass := nil;

          if Assigned(GraphicClass) then
          begin
            Data := Copy(Data, 256, maxint);
            Len := Length(Data);
            FMemoryStream.WriteBuffer(Data[1],  Len);
            FMemoryStream.Position := 0;

            TViewDocument(Item).ShowGraphic(GraphicClass, FMemoryStream)
          end;
        end;

      finally
        FMemoryStream.Clear;
      end;
    except
    end;
  end;

  for i := 0 to FChartList.Count - 1 do
    if TdsdChartView(FChartList.Items[I]).FChartCDS.Active then
  with TdsdChartView(FChartList.Items[I]) do
  begin

   if FDisplayedIndex >= 0 then  with TdsdChartVariant(FChartVariantList.Items[FDisplayedIndex]) do
   begin
      FChartView.BeginUpdate;
      try
        FChartCDS.First;
        while not FChartCDS.Eof do
        begin
          FChartCDS.Edit;

          for J := 0 to FChartSeriesList.Count - 1 do
          if (TdsdChartSeries(FChartSeriesList.Items[J]).ColumnList.Count >= FChartCDS.RecNo) and
             Assigned(TdsdChartColumn(TdsdChartSeries(FChartSeriesList.Items[J]).ColumnList.Items[FChartCDS.RecNo - 1]).Column) then
          begin

            FieldName := TcxGridDBBandedColumn(TdsdChartColumn(TdsdChartSeries(FChartSeriesList.Items[J]).ColumnList.Items[FChartCDS.RecNo - 1]).Column).DataBinding.FieldName;

            if Assigned(DataSet) and Assigned(DataSet.FindField(FieldName)) then
              FChartCDS.FindField('SeriesList_' + IntToStr(J)).AsVariant := DataSet.FieldByName(FieldName).AsVariant
            else FChartCDS.FindField('SeriesList_' + IntToStr(J)).AsVariant := 0;
          end;

          FChartCDS.Post;
          FChartCDS.Next;
        end;
      finally
        FChartView.EndUpdate;
      end;
   end;
  end;
end;

procedure TdsdDBViewAddOn.OnKeyPress(Sender: TObject; var Key: Char);
var isReadOnly: boolean;
begin
  isReadOnly := false;

  if Assigned(View.Controller) then
  begin
     if Assigned(TcxGridDBColumn(View.Controller.FocusedColumn).Properties) then
       isReadOnly := TcxGridDBColumn(View.Controller.FocusedColumn).Properties.ReadOnly;
    // если колонка не редактируема и введена буква или BackSpace то обрабатываем установку фильтра
    if SearchAsFilter and (isReadOnly or (not TcxGridDBColumn(View.Controller.FocusedColumn).Editable)) and (Key > #31) then
    begin
       lpSetEdFilterPos(Char(Key));
       Key := #0;
    end;
  end;
end;

procedure TdsdDBViewAddOn.SetOnlyEditingCellOnEnter(const Value: boolean);
begin
  FOnlyEditingCellOnEnter := Value;
end;

procedure TdsdDBViewAddOn.SetSearchAsFilter(const Value: boolean);
begin
  FSearchAsFilter := Value;
  if Assigned(View) then
     View.OptionsBehavior.IncSearch := not FSearchAsFilter;
end;

procedure TdsdDBViewAddOn.SetDateEdit(const Value: TcxDateEdit);
begin
  FDateEdit := Value;
  if csDesigning  in ComponentState then Exit;
  if Assigned(FDateEdit) then begin
    FDateEdit.Date:=Now;
  end;
end;

procedure TdsdDBViewAddOn.SetView(const Value: TcxGridTableView);
  var I : Integer;
begin

  if FView = Value then Exit;

  if Assigned(FView) and not (csDesigning  in ComponentState) then
  begin
    for I := 0 to FView.ColumnCount - 1 do
    begin
      FView.Columns[I].OnGetFilterValues := FOnGetFilterValues;
      FView.Columns[I].OnUserFiltering := FOnUserFiltering;
    end;
  end;

  FView := Value;
  if csDesigning  in ComponentState then Exit;
  if Assigned(FView) then begin
    if FView.Control is TcxGrid then begin
       FOnExit := TcxGrid(FView.Control).OnExit;
       TcxGrid(FView.Control).OnExit := OnExit;
    end;
    FGridFocusedItemChangedEvent := FView.OnFocusedItemChanged;
    FView.OnFocusedItemChanged := TableViewFocusedItemChanged;
    FOnKeyDown := FView.OnKeyDown;
    FView.OnKeyDown := OnKeyDown;
    FView.OnKeyPress := OnKeyPress;
    FView.OnCustomDrawColumnHeader := OnCustomDrawColumnHeader;
    FView.DataController.Filter.OnChanged := onFilterChanged;
    FView.OnColumnHeaderClick := OnColumnHeaderClick;
    FOnDblClick := FView.OnDblClick;
    FView.OnDblClick := OnDblClick;
    FView.OnCustomDrawCell := OnCustomDrawCell;
    FGridEditKeyEvent := FView.OnEditKeyDown;
    FView.OnEditKeyDown := GridEditKeyEvent;
    FOnGetContentStyleEvent := FView.Styles.OnGetContentStyle;
    FView.Styles.OnGetContentStyle := Nil;
    FView.Styles.OnGetContentStyle := OnGetContentStyle;

    if Assigned(TcxDBDataController(FView.DataController).DataSource) then
       if Assigned(TcxDBDataController(FView.DataController).DataSource.DataSet) then begin
          FAfterInsert := TcxDBDataController(FView.DataController).DataSource.DataSet.AfterInsert;
          TcxDBDataController(FView.DataController).DataSource.DataSet.AfterInsert := OnAfterInsert;
          FBeforeOpen := TcxDBDataController(FView.DataController).DataSource.DataSet.BeforeOpen;
          TcxDBDataController(FView.DataController).DataSource.DataSet.BeforeOpen := OnBeforeOpen;
          FAfterOpen := TcxDBDataController(FView.DataController).DataSource.DataSet.AfterOpen;
          TcxDBDataController(FView.DataController).DataSource.DataSet.AfterOpen := OnAfterOpen;
          FAfterScroll := TcxDBDataController(FView.DataController).DataSource.DataSet.AfterScroll;
          TcxDBDataController(FView.DataController).DataSource.DataSet.AfterScroll := OnAfterScroll;
     end;
     FGroupByBox := FView.OptionsView.GroupByBox;
     FGroupIndex := -1;

     for I := 0 to FView.ColumnCount - 1 do
     begin
       FOnGetFilterValues := FView.Columns[I].OnGetFilterValues;
       FOnUserFiltering := FView.Columns[I].OnUserFiltering;
       FView.Columns[I].OnGetFilterValues := OnGetFilterValues;
       FView.Columns[I].OnUserFiltering := OnUserFiltering;
     end
  end;
end;

function TdsdDBViewAddOn.GetView : TcxGridTableView;
begin
  if Assigned(FView) and (FView.Control.ClassName = 'TcxGrid') then
    Result := TcxGridTableView(TcxGrid(FView.Control).FocusedView)
  else Result := FView;
end;

procedure TdsdDBViewAddOn.TableViewFocusedItemChanged(
  Sender: TcxCustomGridTableView; APrevFocusedItem,
  AFocusedItem: TcxCustomGridTableItem);
var i: integer;
begin
  if Assigned(FGridFocusedItemChangedEvent) then
     FGridFocusedItemChangedEvent(Sender, APrevFocusedItem, AFocusedItem);
  for i := 0 to ColumnAddOnList.Count - 1 do
      with TColumnAddOn(ColumnAddOnList.Items[i]) do
         if onExitColumn.Active then begin
            if Column = APrevFocusedItem then
                onExitColumn.Action.Execute;
         end;
end;

procedure TdsdDBViewAddOn.OnGetFilterValues(Sender: TcxCustomGridTableItem; AValueList: TcxDataFilterValueList);
begin
  if FilterSelectAll then
  begin
    if (Sender is TcxGridDBBandedColumn) and Assigned(TcxGridDBBandedColumn(Sender).DataBinding.Field) and
       (TcxGridDBBandedColumn(Sender).DataBinding.Field.DataType in [ftString, ftWideString]) then
      AValueList.Add(fviUser, CUSTOM_FILTER, MY_CUST_FILTER, True);
    if (Sender is TcxGridDBColumn) and Assigned(TcxGridDBColumn(Sender).DataBinding.Field) and
       (TcxGridDBColumn(Sender).DataBinding.Field.DataType in [ftString, ftWideString]) then
      AValueList.Add(fviUser, CUSTOM_FILTER, MY_CUST_FILTER, True);
  end;

  if FilterLoadFile then
  begin
    if (Sender is TcxGridDBBandedColumn) and Assigned(TcxGridDBBandedColumn(Sender).DataBinding.Field) and
       (TcxGridDBBandedColumn(Sender).DataBinding.Field.DataType in [ftInteger, ftSmallint]) then
      AValueList.Add(fviUser, CUSTOM_FILTERLOAD, MY_CUST_FILTERLOAD, True);
    if (Sender is TcxGridDBColumn) and Assigned(TcxGridDBColumn(Sender).DataBinding.Field) and
       (TcxGridDBColumn(Sender).DataBinding.Field.DataType in [ftInteger, ftSmallint]) then
      AValueList.Add(fviUser, CUSTOM_FILTERLOAD, MY_CUST_FILTERLOAD, True);
  end;
end;

procedure TdsdDBViewAddOn.OnUserFiltering(Sender: TcxCustomGridTableItem; const AValue: Variant;
  const ADisplayText: string);
  var I, J : Integer; lFilter : TStringList;
      ItemList: TcxFilterCriteriaItemList; cFileName, strConn : String;
      pAdoConnection : TAdoConnection; pADOQuery : TADOQuery;
      List: TStringList; ListName: string;
begin
  if (AValue = CUSTOM_FILTER) then
  begin

    if not Assigned(Sender) or not Assigned(View) then Exit;

    with View.DataController.Filter do
    begin
      lFilter := TStringList.Create;
      lFilter.Sorted := True;
      BeginUpdate;
      try
        Clear;
        root.BoolOperatorKind := TcxFilterBoolOperatorKind.fboAnd;
        ItemList := root.AddItemList(TcxFilterBoolOperatorKind.fboOr);
        for i := 0 to View.DataController.RecordCount - 1 do
        begin
          if (View.DataController.Values[I, Sender.Index] <> Null) and
            (VarToStr(View.DataController.Values[I, Sender.Index]) <> '') then
             if not lFilter.Find(VarToStr(View.DataController.Values[I, Sender.Index]), J) then
             begin
               ItemList.AddItem(View.Columns[Sender.Index], TcxFilterOperatorKind.foEqual,
                    View.DataController.Values[I, Sender.Index],
                    VarToStr(View.DataController.Values[I, Sender.Index]));
               lFilter.Add(VarToStr(View.DataController.Values[I, Sender.Index]));
             end;
        end;
        Active := true;
      finally
        EndUpdate;
        lFilter.Free;
      end;
    end;
  end;

  if (AValue = CUSTOM_FILTERLOAD) then
  begin

    if not Assigned(Sender) or not Assigned(View) then Exit;

    with TFileOpenDialog.Create(nil) do
    try
      SetSubComponent(true);
      FreeNotification(Self);
      OkButtonLabel := 'Загрузить фильтр из файла';
      with FileTypes.Add do
      begin
        DisplayName := 'Файл с данными для фильтра';
        FileMask := '*.xls;*.xlsx';
      end;
      if Execute then cFileName := FileName
      else Exit;
    finally
      Free;
    end;

    pAdoConnection := TAdoConnection.Create(nil);
    pAdoConnection.LoginPrompt := false;
    pADOQuery := TADOQuery.Create(nil);
    pADOQuery.Connection := pAdoConnection;
    try
      // Подключение для  xlsx
      if Pos('.xlsx', AnsiLowerCase(cFileName)) > 0 then
        strConn:='Provider=Microsoft.ACE.OLEDB.12.0;Mode=Read;' +
                 'Data Source="' + cFileName + '";' +
                 'Extended Properties="Excel 12.0 Xml;HDR=Yes;IMEX=1;"'
      else strConn:='Provider=Microsoft.Jet.OLEDB.4.0;Mode=Read;' +
               'Data Source="' + cFileName + '";' +
               'Extended Properties="Excel 8.0;IMEX=1;"';
      pAdoConnection.Connected := False;
      pAdoConnection.ConnectionString := strConn;
      pAdoConnection.Open;

      List := TStringList.Create;
      try
        pAdoConnection.GetTableNames(List, True);
        pADOQuery.ParamCheck := false;
        ListName := '';
        if Copy(ListName, 1, 1) = chr(39) then
           ListName := Copy(List[0], 2, length(List[0])-2);
        if Pos('.xlsx', AnsiLowerCase(cFileName)) > 0 then
          pADOQuery.SQL.Text := 'SELECT * FROM [' + ListName + 'A' + IntToStr(1)+ ':CZ60000]'
        else pADOQuery.SQL.Text := 'SELECT * FROM [' + ListName + 'A' + IntToStr(1)+ ':CZ60000]';
        pADOQuery.Open;
      finally
        FreeAndNil(List);
      end;

      if pADOQuery.RecordCount = 0 then Exit;

      with View.DataController.Filter do
      begin
        lFilter := TStringList.Create;
        lFilter.Sorted := True;
        BeginUpdate;
        try
          Clear;
          root.BoolOperatorKind := TcxFilterBoolOperatorKind.fboAnd;
          ItemList := root.AddItemList(TcxFilterBoolOperatorKind.fboOr);

          pADOQuery.First;
          while not pADOQuery.Eof do
          begin
           if not lFilter.Find(VarToStr(pADOQuery.Fields.Fields[0].Value), J) and
             (VarToStr(pADOQuery.Fields.Fields[0].Value) <> '') and
             TryStrToInt(VarToStr(pADOQuery.Fields.Fields[0].Value), J) then
           begin
             ItemList.AddItem(View.Columns[Sender.Index], TcxFilterOperatorKind.foEqual,
                  pADOQuery.Fields.Fields[0].Value,
                  VarToStr(pADOQuery.Fields.Fields[0].Value));
             lFilter.Add(VarToStr(pADOQuery.Fields.Fields[0].Value));
           end;
            pADOQuery.Next;
          end;
          Active := true;
        finally
          EndUpdate;
          lFilter.Free;
        end;
      end;
    finally
      pADOQuery.Free;
      pAdoConnection.Free;
    end;
  end;
end;

{ TdsdUserSettingsStorageAddOn }

constructor TdsdUserSettingsStorageAddOn.Create(AOwner: TComponent);
begin
  // Значение по умолчанию
  FActive := true;
  inherited;
  if csDesigning in ComponentState then
     exit;
  if AOwner is TForm then begin
     FOnDestroy := TForm(AOwner).OnDestroy;
     TForm(AOwner).OnDestroy := Self.OnDestroy;
  end;
end;

procedure TdsdUserSettingsStorageAddOn.OnDestroy(Sender: TObject);
begin
  if csDesigning in ComponentState then
     exit;
  if Active then
    SaveUserSettings;
  if Assigned(FOnDestroy) then
     FOnDestroy(Sender);
end;

procedure TdsdUserSettingsStorageAddOn.LoadUserSettingsData(Data: String);
 var
  XMLDocument: IXMLDocument;
  i: integer;
  PropertiesStore: TcxPropertiesStore;
  GridView: TcxCustomGridView;
  TreeList: TcxDBTreeList;
  FormName: string;
  PropertiesStoreComponent: TcxPropertiesStoreComponent;
  TempStream: TStringStream;
begin
  if Data <> '' then begin
    XMLDocument := TXMLDocument.Create(nil);
    XMLDocument.LoadFromXML(Data);
    with XMLDocument.DocumentElement do begin
      for I := 0 to ChildNodes.Count - 1 do begin
        if ChildNodes[i].NodeName = 'cxGridView' then begin
           GridView := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxCustomGridView;
           if Assigned(GridView) then
           try
              TempStream := TStringStream.Create(ReConvertConvert(ChildNodes[i].GetAttribute('data')));
              GridView.RestoreFromStream(TempStream,False);
           finally
              TempStream.Free;
           end;
        end;
        if ChildNodes[i].NodeName = 'cxTreeList' then begin
           TreeList := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxDBTreeList;
           if Assigned(TreeList) then
           try
              TempStream := TStringStream.Create(ReConvertConvert(ChildNodes[i].GetAttribute('data')));
              TreeList.RestoreFromStream(TempStream);
           finally
              TempStream.Free;
           end;
        end;
{        if ChildNodes[i].NodeName = 'dxBarManager' then begin
           BarManager := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TdxBarManager;
           if Assigned(BarManager) then
           try
              TempStream := TStringStream.Create(ReConvertConvert(ChildNodes[i].GetAttribute('data')));
              BarManager.LoadFromStream(TempStream);
           finally
              TempStream.Free;
           end;
        end;}
        if ChildNodes[i].NodeName = 'cxPropertiesStore' then begin
           PropertiesStore := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxPropertiesStore;
           if Assigned(PropertiesStore) then begin
              PropertiesStore.StorageType := stStream;
              PropertiesStore.StorageStream := TStringStream.Create(ReConvertConvert(ChildNodes[i].GetAttribute('data')));
              PropertiesStore.RestoreFrom;
              PropertiesStore.StorageStream.Free;
              // Проверим и установим значения для сохранения размера и места формы
              if PropertiesStore.Components.FindComponentItemByComponent(Owner, PropertiesStoreComponent) then begin
                 if PropertiesStoreComponent.Properties.IndexOf('Top') = -1 then
                    PropertiesStoreComponent.Properties.Add('Top');
                 if PropertiesStoreComponent.Properties.IndexOf('Width') = -1 then
                    PropertiesStoreComponent.Properties.Add('Width');
                 if PropertiesStoreComponent.Properties.IndexOf('Left') = -1 then
                    PropertiesStoreComponent.Properties.Add('Left');
                 if PropertiesStoreComponent.Properties.IndexOf('Height') = -1 then
                    PropertiesStoreComponent.Properties.Add('Height');
              end
              else
                 with PropertiesStore.Components.Add do begin
                      Properties.Add('Top');
                      Properties.Add('Width');
                      Properties.Add('Left');
                      Properties.Add('Height');
                 end;
           end;
        end;
      end;
    end;
  end;
end;

procedure TdsdUserSettingsStorageAddOn.LoadUserSettings;
var
  Data: String;
  XMLDocument: IXMLDocument;
  i: integer;
  PropertiesStore: TcxPropertiesStore;
  GridView: TcxCustomGridView;
  TreeList: TcxDBTreeList;
  FormName: string;
  PropertiesStoreComponent: TcxPropertiesStoreComponent;
begin
  if gc_isSetDefault then
     exit;
  if (Owner is TParentForm) and (TParentForm(Owner).FormClassName <> '') then
     FormName := TParentForm(Owner).FormClassName
  else
     FormName := Owner.ClassName;
  Data := TdsdFormStorageFactory.GetStorage.LoadUserFormSettings(FormName);
  if Data <> '' then LoadUserSettingsData(Data);
end;

procedure TdsdUserSettingsStorageAddOn.LoadUserSettingsBack;
var
  Data: String;
  FormName: string;
begin
  if gc_isSetDefault then
     exit;
  if (Owner is TParentForm) and (TParentForm(Owner).FormClassName <> '') then
     FormName := TParentForm(Owner).FormClassName + '_Back'
  else
     FormName := Owner.ClassName + '_Back';
  Data := TdsdFormStorageFactory.GetStorage.LoadUserFormSettings(FormName);
  if Data <> '' then LoadUserSettingsData(Data);
end;

procedure TdsdUserSettingsStorageAddOn.SaveUserSettings;
var
  TempStream: TStringStream;
  i: integer;
  xml: string;
  FormName: string;
begin
  if gc_isSetDefault then
     exit;
  if (Owner is TParentForm) and (TParentForm(Owner).FormClassName <> '') then
     FormName := TParentForm(Owner).FormClassName
  else
     FormName := Owner.ClassName;

  I := 0;
  while I < Owner.ComponentCount do
  begin
    if Owner.Components[I] is TdsdDBViewAddOn then TdsdDBViewAddOn(Owner.Components[I]).ClearDuplicateSearch;
    if Owner.Components[I] is TCrossDBViewAddOn then TCrossDBViewAddOn(Owner.Components[I]).onAfterClose(Nil);
    if Owner.Components[I] is TCrossDBViewReportAddOn then TCrossDBViewReportAddOn(Owner.Components[I]).onAfterClose(Nil);
    Inc(I);
  end;

  TempStream :=  TStringStream.Create;
  try
    xml := '<root>';
    // Сохраняем установки гридов
    for i := 0 to Owner.ComponentCount - 1 do begin
{      if Owner.Components[i] is TdxBarManager then
         with TdxBarManager(Owner.Components[i]) do begin
           SaveToStream(TempStream);
           xml := xml + '<dxBarManager name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;}
      if Owner.Components[i] is TcxCustomGridView then
         with TcxCustomGridView(Owner.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxGridView name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      if Owner.Components[i] is TcxDBTreeList then
         with TcxDBTreeList(Owner.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxTreeList name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      // сохраняем остальные установки
      if Owner.Components[i] is TcxPropertiesStore then
         with Owner.Components[i] as TcxPropertiesStore do begin
            StorageType := stStream;
            StorageStream := TempStream;
            StoreTo;
            xml := xml + '<cxPropertiesStore name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '"/>';
            TempStream.Clear;
         end;
    end;
    xml := xml + '</root>';
    TdsdFormStorageFactory.GetStorage.SaveUserFormSettings(FormName, gfStrToXmlStr(xml));
  finally
    TempStream.Free;
  end;
end;

procedure TdsdUserSettingsStorageAddOn.SaveUserSettingsBack;
var
  TempStream: TStringStream;
  i: integer;
  xml: string;
  FormName: string;
begin
  if gc_isSetDefault then
     exit;
  if (Owner is TParentForm) and (TParentForm(Owner).FormClassName <> '') then
     FormName := TParentForm(Owner).FormClassName + '_Back'
  else
     FormName := Owner.ClassName + '_Back';

  I := 0;
  while I < Owner.ComponentCount do
  begin
    if Owner.Components[I] is TdsdDBViewAddOn then TdsdDBViewAddOn(Owner.Components[I]).ClearDuplicateSearch;
    if Owner.Components[I] is TCrossDBViewAddOn then TCrossDBViewAddOn(Owner.Components[I]).onAfterClose(Nil);
    if Owner.Components[I] is TCrossDBViewReportAddOn then TCrossDBViewReportAddOn(Owner.Components[I]).onAfterClose(Nil);
    Inc(I);
  end;

  TempStream :=  TStringStream.Create;
  try
    xml := '<root>';
    // Сохраняем установки гридов
    for i := 0 to Owner.ComponentCount - 1 do begin
{      if Owner.Components[i] is TdxBarManager then
         with TdxBarManager(Owner.Components[i]) do begin
           SaveToStream(TempStream);
           xml := xml + '<dxBarManager name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;}
      if Owner.Components[i] is TcxCustomGridView then
         with TcxCustomGridView(Owner.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxGridView name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      if Owner.Components[i] is TcxDBTreeList then
         with TcxDBTreeList(Owner.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxTreeList name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      // сохраняем остальные установки
      if Owner.Components[i] is TcxPropertiesStore then
         with Owner.Components[i] as TcxPropertiesStore do begin
            StorageType := stStream;
            StorageStream := TempStream;
            StoreTo;
            xml := xml + '<cxPropertiesStore name = "' + Name + '" data = "' + ConvertConvert(TempStream.DataString) + '"/>';
            TempStream.Clear;
         end;
    end;
    xml := xml + '</root>';
    TdsdFormStorageFactory.GetStorage.SaveUserFormSettings(FormName, gfStrToXmlStr(xml));
  finally
    TempStream.Free;
  end;
end;

{ THeaderSaver }

procedure THeaderSaver.AfterGetExecute(Sender: TObject);
begin
  if Assigned(FAfterExecute) then
     FAfterExecute(Sender);
  EnterAll;
end;

constructor THeaderSaver.Create(AOwner: TComponent);
begin
  inherited;
  FHWnd := AllocateHWnd(WndMethod);
  FNotSave := false;
  FParam := TdsdParam.Create(nil);
  FControlList := TControlList.Create(Self, TControlListItem);
  FEnterValue := TStringList.Create;
  if Self.Owner is TParentForm then begin
     FOnAfterShow := TParentForm(Owner).onAfterShow;
     TParentForm(Owner).onAfterShow := onAfterShow;
  end;
end;

destructor THeaderSaver.Destroy;
begin
  FreeAndNil(FParam);
  FreeAndNil(FControlList);
  FreeAndNil(FEnterValue);
  DeallocateHWnd(FHWnd);
  if Self.Owner is TParentForm then
     TParentForm(Owner).onAfterShow := FOnAfterShow;
  inherited;
end;

procedure THeaderSaver.EnterAll;
var
   Item: TCollectionItem;
begin
  for Item in FControlList do
      onEnter(TControlListItem(Item).Control)
end;

procedure THeaderSaver.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;

  if (Operation = opRemove) then begin
    if AComponent is TControl and Assigned(ControlList) then
    begin
       for i := 0 to ControlList.Count - 1 do
          if ControlList[i].Control = AComponent then
             ControlList[i].Control := nil;
    end;
    if AComponent = StoredProc then
       StoredProc := nil;
    if AComponent = FGetStoredProc then
       FGetStoredProc := nil;
  end;
end;

procedure THeaderSaver.OnAfterShow(Sender: TObject);
begin
  if Assigned(FOnAfterShow) then
     FOnAfterShow(Sender);
  EnterAll;
end;

procedure THeaderSaver.OnEnter(Sender: TObject);
var
  DateTime: TDateTime;
begin
  if Sender is TcxTextEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxTextEdit).Text;
  if Sender is TcxMemo then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxMemo).Text;
  if Sender is TcxMaskEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxMaskEdit).Text;
  if Sender is TcxButtonEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxButtonEdit).Text;
  if Sender is TcxCurrencyEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxCurrencyEdit).Text;
  if Sender is TcxDateEdit then begin
        DateTime := (Sender as TcxDateEdit).Date;
        if DateTime = -700000 then
           DateTime := 0;
     FEnterValue.Values[TComponent(Sender).Name] := DateToStr(DateTime);
  end;
  if Sender is TcxCheckBox then
     FEnterValue.Values[TComponent(Sender).Name] := BoolToStr((Sender as TcxCheckBox).Checked);
  if Sender is TcxComboBox then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxComboBox).Text;
  if Sender is TcxDateNavigator then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxDateNavigator).ToString;
end;

procedure THeaderSaver.OnExit(Sender: TObject);
var isChanged: boolean;
begin
  isChanged := false;
  if FNotSave then
     exit;
  if not Assigned(IdParam) then
     raise Exception.Create('Не установлено свойство IdParam');
  if (IdParam.Value = 0) or VarIsNull(IdParam.Value) then
      exit;
  if Sender is TcxTextEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxTextEdit).Text;
  if Sender is TcxMemo then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxMemo).Text;
  if Sender is TcxMaskEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxMaskEdit).Text;
  if Sender is TcxButtonEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxButtonEdit).Text;
  if Sender is TcxCurrencyEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxCurrencyEdit).Text;
  if Sender is TcxDateEdit then begin
     isChanged := ((TcxDateEdit(Sender).Text = '') AND (FEnterValue.Values[TComponent(Sender).Name] <> '')) or
                  (FEnterValue.Values[TComponent(Sender).Name] <> DateToStr((Sender as TcxDateEdit).Date));
  end;
  if Sender is TcxCheckBox then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> BoolToStr((Sender as TcxCheckBox).Checked);
  if Sender is TcxDateNavigator then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxDateNavigator).ToString;

  try
    if isChanged then
       StoredProc.Execute;
    if isChanged and Assigned(FAction) then
       FAction.Execute;
  // Если в момент сохранения возникает ошибка, то вернем старое значение на гете
  except
    if Assigned(GetStoredProc) then
       GetStoredProc.Execute;
    raise;
  end;
  FNotSave := true;
  PostMessage(FHWnd, WM_SETFLAGHeaderSaver, 0, 0);
end;

procedure THeaderSaver.SetGetStoredProc(Value: TdsdStoredProc);
begin
  //Если ничего не поменялось - выходим
  if Value = FGetStoredProc then exit;
  //если меняется процедура - возвращаем старой процедуре её афтерэкзекют
  if FGetStoredProc <> nil then
    FGetStoredProc.AfterExecute := FAfterExecute;
  FGetStoredProc := Value;
  //Если процедура установлена - меняем ей афтерэкзекют
  if Assigned(FGetStoredProc) then
  Begin
    FAfterExecute := FGetStoredProc.AfterExecute;
    FGetStoredProc.AfterExecute := AfterGetExecute;
  End;
end;

procedure THeaderSaver.WndMethod(var Msg: TMessage);
var
  Handled: Boolean;
begin
  // Assume we handle message
  Handled := True;
  case Msg.Msg of
    WM_SETFLAGHeaderSaver: FNotSave := false;
    else
      // We didn't handle message
      Handled := False;
  end;
  if Handled then
    // We handled message - record in message result
    Msg.Result := 0
  else
    // We didn't handle message
    // pass to DefWindowProc and record result
    Msg.Result := DefWindowProc(fHWnd, Msg.Msg,
      Msg.WParam, Msg.LParam);
end;

{ TControlList }

function TControlList.Add: TControlListItem;
begin
  result := TControlListItem(inherited Add);
end;

function TControlList.GetItem(Index: Integer): TControlListItem;
begin
  Result := TControlListItem(inherited GetItem(Index));
end;

procedure TControlList.SetItem(Index: Integer; const Value: TControlListItem);
begin
  inherited SetItem(Index, Value);
end;

{ TControlListItem }

procedure TControlListItem.Assign(Source: TPersistent);
begin
  if Source is TControlListItem then
     Self.Control := TControlListItem(Source).Control
  else
    inherited; //raises an exception
end;

function TControlListItem.GetDisplayName: string;
begin
  if Assigned(Control) then
     result := Control.Name
  else
     result := inherited;
end;

procedure TControlListItem.SetControl(const Value: TControl);
begin
  if FControl <> Value then begin
    FControl := Value;
    if Assigned(Value) and Assigned(Collection) then begin
       Value.FreeNotification(TComponent(Collection.Owner));
       if (Collection.Owner is THeaderSaver) then begin
          if FControl is TcxTextEdit then begin
             (FControl as TcxTextEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxTextEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxMemo then begin
             (FControl as TcxMemo).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxMemo).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxMaskEdit then begin
             (FControl as TcxMaskEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxMaskEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxDateEdit then begin
             (FControl as TcxDateEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxDateEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxButtonEdit then begin
             (FControl as TcxButtonEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxButtonEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxCheckBox then begin
             (FControl as TcxCheckBox).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxCheckBox).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxCurrencyEdit then begin
             (FControl as TcxCurrencyEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxCurrencyEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxComboBox then begin
             (FControl as TcxComboBox).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxComboBox).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxDateNavigator then begin
             (FControl as TcxDateNavigator).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxDateNavigator).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
       end;
    end;
  end;
end;

{ TRefreshAddOn }

constructor TRefreshAddOn.Create(AOwner: TComponent);
begin
  inherited;
  DataSet := 'ClientDataSet';
  RefreshAction := 'actRefresh';
  FormParams := 'FormParams';
  FKeyField := 'Id';
  if AOwner is TForm then begin
     FOnClose := (AOwner as TForm).OnClose;
     (AOwner as TForm).OnClose := Self.OnClose;
  end;
end;

destructor TRefreshAddOn.Destroy;
begin
  if Owner is TForm then
     TForm(Owner).OnClose := FOnClose;
  inherited;
end;

procedure TRefreshAddOn.OnClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
begin
  // Перечитываем и позиционируемся
  // Только сначала находим форму указанного типа
  for I := 0 to Screen.FormCount - 1 do
      if lowercase(Screen.Forms[i].Name) = lowercase(FormName) then
         with Screen.Forms[i] do begin
           if Assigned(FindComponent(RefreshAction)) then
              TdsdDataSetRefresh(FindComponent(RefreshAction)).Execute;
           if Assigned(FindComponent(DataSet)) and Assigned(Self.Owner.FindComponent(FormParams)) then
              if Assigned(TDataSet(FindComponent(DataSet)).FindField(KeyField)) then
                 TDataSet(FindComponent(DataSet)).Locate(KeyField, TdsdFormParams(Self.Owner.FindComponent(FormParams)).ParamByName(FKeyField).AsString, []);
         end;
  if Assigned(FOnClose) then
     FOnClose(Sender, Action);
end;

{ TCustomDBControlAddOn }

constructor TCustomDBControlAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FErasedFieldName := gcisErased;
  ActionItemList := TActionItemList.Create(Self, TShortCutActionItem);
  OnDblClickActionList := TActionItemList.Create(Self, TActionItem);
end;

procedure TCustomDBControlAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;

  if (Operation = opRemove) then
  begin
    if AComponent is TCustomAction then
    begin
      if Assigned(ActionItemList) then
        for i := 0 to ActionItemList.Count - 1 do
           if ActionItemList[i].Action = AComponent then
              ActionItemList[i].Action := nil;
      if Assigned(OnDblClickActionList) then
        for i := 0 to OnDblClickActionList.Count - 1 do
           if OnDblClickActionList[i].Action = AComponent then
              OnDblClickActionList[i].Action := nil;
    end;
    if AComponent = SortImages then
       SortImages := nil
  end;
end;

procedure TCustomDBControlAddOn.OnAfterInsert(DataSet: TDataSet);
var Field: TField;
begin
  if Assigned(FAfterInsert) then
     FAfterInsert(DataSet);
  Field := DataSet.FindField(ErasedFieldName);
  if Assigned(Field) then
     Field.AsBoolean := false;
end;

procedure TCustomDBControlAddOn.OnDblClick(Sender: TObject);
var i: integer;
begin
  if Assigned(FOnDblClick) then FOnDblClick(Sender);

  // Выполняем События на DblClick
  for I := 0 to FOnDblClickActionList.Count - 1 do
    if Assigned(FOnDblClickActionList[i].Action) then
       if OnDblClickActionList[i].Action.Enabled then begin
          // Выполнили первое действие в списке
          OnDblClickActionList[i].Action.Execute;
          // И сразу вышли!!!
          exit;
       end;
end;

procedure TCustomDBControlAddOn.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: integer;
begin                       
  if Assigned(FOnKeyDown) then
     FOnKeyDown(Sender, Key, Shift);

  // Сначала проверим все action
  // и если там нет ничего, то тогда идем дальше
  for I := 0 to ActionItemList.Count - 1 do
      if (ShortCut(Key, Shift) = TShortCutActionItem(ActionItemList[i]).ShortCut) and Assigned(ActionItemList[i].Action) then begin
         if ActionItemList[i].Action.Enabled then begin
            // Выполнили первое действие в списке
            ActionItemList[i].Action.Execute;
            Key := 0;
            Shift := [];
            // И сразу вышли!!!
            exit;
         end;
      end;
end;

{ TRefreshDispatcher }

constructor TRefreshDispatcher.Create(AOwner: TComponent);
begin
  inherited;
  ComponentList := TOwnedCollection.Create(Self, TComponentListItem);
  FIdParam := TdsdParam.Create(nil);
  CheckIdParam := false;
  FNotRefresh := false;
  FHWnd := AllocateHWnd(WndMethod);
end;

destructor TRefreshDispatcher.Destroy;
begin
  DeallocateHWnd(FHWnd);
  FreeAndNil(FComponentList);
  FreeAndNil(FIdParam);
  inherited;
end;

procedure TRefreshDispatcher.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;

  if (Operation = opRemove) then begin
    if AComponent = FRefreshAction then
       FRefreshAction := nil;
    if AComponent = FShowDialogAction then
       FShowDialogAction := nil;
    if Assigned(ComponentList) then
      for i := 0 to ComponentList.Count - 1 do
         if TComponentListItem(ComponentList.Items[i]).Component = AComponent then
            TComponentListItem(ComponentList.Items[i]).Component := nil;
  end;
end;

procedure TRefreshDispatcher.OnComponentChange(Sender: TObject);
var fNeedRefreshOnExecute_calc: Boolean; // add 22.01.2018
begin
  // add 22.01.2018
  fNeedRefreshOnExecute_calc:= true;
  //
  if FNotRefresh then
     exit;
  if CheckIdParam then
  begin
     if (IdParam.asString = '') or (IdParam.asString = '0') or (IdParam.Value=NULL) then
        exit;
     //
     // add 22.01.2018 - Отловили значение параметра, вдруг он НЕ изменился - НЕ будем перечитывать
     if Assigned (TParentForm(Self.Owner).AddOnFormData.Params) then
        if TParentForm(Self.Owner).AddOnFormData.Params.ParamByName(IdParam.ComponentItem) <> nil
        then fNeedRefreshOnExecute_calc:= TParentForm(Self.Owner).AddOnFormData.Params.ParamByName(IdParam.ComponentItem).isValueChange;
  end;

  if Assigned(FRefreshAction) then
  // перечитываем запросы только если форма загружена
     if Assigned(Self.Owner) and (Self.Owner is TParentForm) then
        if TParentForm(Self.Owner).Visible then
           FRefreshAction.Execute
        else
           TParentForm(Self.Owner).NeedRefreshOnExecute := fNeedRefreshOnExecute_calc; // change 22.01.2018
  FNotRefresh := true;
  SetFlag;
end;

procedure TRefreshDispatcher.SetFlag;
begin
  PostMessage(FHWnd, WM_SETFLAG, 0, 0);
end;

procedure TRefreshDispatcher.SetShowDialogAction(const Value: TExecuteDialog);
begin
  if FShowDialogAction <> Value then begin
     if Assigned(Value) then
        Value.RefreshDispatcher := Self;
     if Assigned(FShowDialogAction) then
        FShowDialogAction.RefreshDispatcher := nil;
     FShowDialogAction := Value;
  end;
end;

procedure TRefreshDispatcher.WndMethod(var Msg: TMessage);
var
  Handled: Boolean;
begin
  // Assume we handle message
  Handled := True;
  case Msg.Msg of
    WM_SETFLAG: FNotRefresh := false;
    else
      // We didn't handle message
      Handled := False;
  end;
  if Handled then
    // We handled message - record in message result
    Msg.Result := 0
  else
    // We didn't handle message
    // pass to DefWindowProc and record result
    Msg.Result := DefWindowProc(fHWnd, Msg.Msg,
      Msg.WParam, Msg.LParam);
end;

{ TComponentListItem }

procedure TComponentListItem.Assign(Source: TPersistent);
begin
  if Source is TComponentListItem then
     with TComponentListItem(Source) do begin
       Self.Component := Component;
     end
  else
    inherited Assign(Source);
end;

function TComponentListItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FComponent) then
     result := FComponent.Name
end;

procedure TComponentListItem.OnChange(Sender: TObject);
begin
  // Вызываем onChange если был
  if Assigned(FOnChange) then
     FOnChange(Sender);
  // Перечитываем запросы
  if Assigned(TRefreshDispatcher(Collection.Owner)) then
     TRefreshDispatcher(Collection.Owner).OnComponentChange(Sender);
end;

procedure TComponentListItem.SetComponent(const Value: TComponent);
begin
  FComponent := Value;
  if Assigned(FComponent) then begin
     if Assigned(Collection) then
        FComponent.FreeNotification(TComponent(Collection.Owner));
     if FComponent is TPeriodChoice then begin
        FOnChange := TPeriodChoice(FComponent).onChange;
        TPeriodChoice(FComponent).onChange := OnChange;
     end;
     if FComponent is TdsdGuides then begin
        FOnChange := TdsdGuides(FComponent).onChange;
        TdsdGuides(FComponent).onChange := OnChange;
     end;
     if FComponent is TcxDateEdit then begin
        FOnChange := TcxDateEdit(FComponent).Properties.OnChange;
        TcxDateEdit(FComponent).Properties.OnChange := OnChange;
     end;
     if FComponent is TcxCurrencyEdit then begin
        FOnChange := TcxCurrencyEdit(FComponent).Properties.OnEditValueChanged;
        TcxCurrencyEdit(FComponent).Properties.OnEditValueChanged := OnChange;
     end;
     if FComponent is TcxCheckBox then begin
        FOnChange := TcxCheckBox(FComponent).Properties.OnEditValueChanged;
        TcxCheckBox(FComponent).Properties.OnEditValueChanged := OnChange;
     end;
  end;
end;

{ TExecuteDialog }

constructor TExecuteDialog.Create(AOwner: TComponent);
begin
  inherited;
  isShowModal := true;
  OpenBeforeShow := true;
  RefreshAllow := true;
end;

function TExecuteDialog.Execute: boolean;
begin
  result := false;
  if Assigned(BeforeAction) then
  begin
    if not BeforeAction.Execute then Exit;
  end;

  with TParentForm(ShowForm) do
    if ModalResult = mrOk then begin
       result := true;
       // Не перечитываем RefreshDispatcher при установке значений. Иначе получится два раза
       if Assigned(RefreshDispatcher) then
          RefreshDispatcher.FNotRefresh := true;
       try
         Self.GuiParams.AssignParams(AddOnFormData.Params.Params);
         if Assigned(RefreshDispatcher) and Assigned(RefreshDispatcher.RefreshAction) and RefreshAllow then
            RefreshDispatcher.RefreshAction.Execute;// OnComponentChange(Self);
         RefreshAllow := true;
       finally
         // Обязательно вернули флаг на место
         if Assigned(RefreshDispatcher) then
            RefreshDispatcher.FNotRefresh := false;
       end;
    end;

  if not result then
  begin
    if Assigned(CancelAction) then
      CancelAction.Execute;
  end else if Assigned(AfterAction) then
      AfterAction.Execute;
end;

procedure TExecuteDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (AComponent = FRefreshDispatcher) then
    FRefreshDispatcher := nil;
end;

{ TCrossDBViewAddOn }

constructor TCrossDBViewAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FCreateColumnList := TList.Create;
  FCreateColorRuleList := TList.Create;
end;

destructor TCrossDBViewAddOn.Destroy;
begin
  FreeAndNil(FCreateColorRuleList);
  FreeAndNil(FCreateColumnList);
  inherited;
end;

procedure TCrossDBViewAddOn.FocusedItemChanged(Sender: TcxCustomGridTableView;
  APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
begin
  if Assigned(FFocusedItemChanged) then
     FFocusedItemChanged(Sender, APrevFocusedItem, AFocusedItem);
  if TcxDBDataController(View.DataController).DataSource.State = dsEdit then begin
     // Если ошибка, то вернем в прошлую ячейку
     try
       TcxDBDataController(View.DataController).DataSource.DataSet.Post;
     except
       TcxDBDataController(View.DataController).DataSource.DataSet.Cancel;
       View.Controller.FocusedItem := APrevFocusedItem;
       raise;
     end;
  end;
end;

procedure TCrossDBViewAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

   if Operation = opRemove then begin
      if AComponent = HeaderDataSet then
         HeaderDataSet := nil;
      if AComponent = FTemplateColumn then
         FTemplateColumn := nil;
   end;
end;

procedure TCrossDBViewAddOn.onAfterClose(DataSet: TDataSet);
var i: integer;
begin
  if Assigned(FAfterClose) then
     FAfterClose(DataSet);

  for i := 0 to FCreateColorRuleList.Count - 1 do
    TColorRule(FCreateColorRuleList.Items[I]).Free;

  FCreateColorRuleList.Clear;

  for i := 0 to FCreateColumnList.Count - 1 do
    View.Columns[View.ColumnCount - 1].Free;

  FCreateColumnList.Clear;
end;

procedure TCrossDBViewAddOn.onBeforeOpen(DataSet: TDataSet);
var NewColumnIndex, I: integer;
    Column: TcxGridColumn;
    TemplateColorRule, ColorRule: TColorRule;
begin
  if Assigned(FBeforeOpen) then
     FBeforeOpen(DataSet);
  View.BeginUpdate;
    try
      // Заполняем заголовки колонок
      if Assigned(HeaderDataSet) and HeaderDataSet.Active then begin
         if not Assigned(HeaderDataSet.Fields.FindField(HeaderColumnName)) then
            raise Exception.Create('HeaderDataSet не имеет поля ' + HeaderColumnName);
         if not Assigned(TemplateColumn) then
            raise Exception.Create('TemplateColumn не установлен ');
         TemplateColorRule := Nil;
         for I := 0 to ColorRuleList.Count - 1 do
           if TColorRule(ColorRuleList.Items[I]).ColorColumn = TemplateColumn then
         begin
           TemplateColorRule := TColorRule(ColorRuleList.Items[I]);
           Break;
         end;

         HeaderDataSet.First;
         NewColumnIndex := 1;
         while not HeaderDataSet.Eof do begin
           Column := View.CreateColumn;
           if TemplateColumn is TcxGridDBBandedColumn then
             Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColumn).DataBinding.FieldName + IntToStr(Column.index);
           if TemplateColumn is TcxGridDBColumn then
             Column.Name:= View.Name + TcxGridDBColumn(TemplateColumn).DataBinding.FieldName + IntToStr(Column.index);
           FCreateColumnList.Add(Column);
           with Column do begin
             Assign(TemplateColumn);
             Visible := true;
             Caption := HeaderDataSet.FieldByName(HeaderColumnName).AsString;
             Width := TemplateColumn.Width;
             if Column is TcxGridDBBandedColumn then
                TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
             if Column is TcxGridDBColumn then
                TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
             if Caption = '' then Options.Editing := False;
             if Assigned(Styles.Header) and (Styles.Header.Font.Orientation = 900) then
               OnCustomDrawHeader := onCustomDrawHeader900
           end;

           if Assigned(TemplateColorRule) then
           begin
             ColorRule:= TColorRule.Create(FColorRuleList);
             ColorRule.Assign(TemplateColorRule);
             ColorRule.ColorColumn := Column;
             if not NoCrossColorColumn then
             begin
               if Assigned(TemplateColorRule.BackGroundValueColumn) then
               begin
                 Column := View.CreateColumn;
                 if TemplateColorRule.BackGroundValueColumn is TcxGridDBBandedColumn then
                   Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 if TemplateColorRule.BackGroundValueColumn is TcxGridDBColumn then
                   Column.Name:= View.Name + TcxGridDBColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 FCreateColumnList.Add(Column);
                 with Column do begin
                   Assign(TemplateColorRule.BackGroundValueColumn);
                   Visible := False;
                   if (Column is TcxGridDBBandedColumn) and (TemplateColorRule.BackGroundValueColumn is TcxGridDBBandedColumn) then
                      TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                   if (Column is TcxGridDBColumn) and (TemplateColorRule.BackGroundValueColumn is TcxGridDBColumn) then
                      TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                 end;
                 ColorRule.BackGroundValueColumn := Column;
               end;
               if Assigned(TemplateColorRule.ValueBoldColumn) then
               begin
                 Column := View.CreateColumn;
                 if TemplateColorRule.ValueBoldColumn is TcxGridDBBandedColumn then
                   Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(Column.index);
                 if TemplateColorRule.ValueBoldColumn is TcxGridDBColumn then
                   Column.Name:= View.Name + TcxGridDBColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(Column.index);
                 FCreateColumnList.Add(Column);
                 with Column do begin
                   Assign(TemplateColorRule.ValueBoldColumn);
                   Visible := False;
                   if (Column is TcxGridDBBandedColumn) and (TemplateColorRule.ValueBoldColumn is TcxGridDBBandedColumn) then
                      TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                   if (Column is TcxGridDBColumn) and (TemplateColorRule.ValueBoldColumn is TcxGridDBColumn) then
                      TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                 end;
                 ColorRule.ValueBoldColumn := Column;
               end;
               if Assigned(TemplateColorRule.ValueColumn) then
               begin
                 Column := View.CreateColumn;
                 if TemplateColorRule.ValueColumn is TcxGridDBBandedColumn then
                   Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 if TemplateColorRule.ValueColumn is TcxGridDBColumn then
                   Column.Name:= View.Name + TcxGridDBColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 FCreateColumnList.Add(Column);
                 with Column do begin
                   Assign(TemplateColorRule.ValueColumn);
                   Visible := False;
                   if (Column is TcxGridDBBandedColumn) and (TemplateColorRule.ValueColumn is TcxGridDBBandedColumn) then
                      TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                   if (Column is TcxGridDBColumn) and (TemplateColorRule.ValueColumn is TcxGridDBColumn) then
                      TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                 end;
                 ColorRule.ValueColumn := Column;
               end;
             end else
             begin
               ColorRule.BackGroundValueColumn := TemplateColorRule.BackGroundValueColumn;
               ColorRule.ValueBoldColumn := TemplateColorRule.ValueBoldColumn;
               ColorRule.ValueColumn := TemplateColorRule.ValueColumn;
             end;
             FCreateColorRuleList.Add(ColorRule);
           end;

           inc(NewColumnIndex);
           HeaderDataSet.Next;
         end;
      end;
    finally
      View.EndUpdate;
    end;
end;

procedure TCrossDBViewAddOn.onCustomDrawHeader900(
  Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
begin

  ACanvas.FillRect(AViewInfo.Bounds);

  ACanvas.TextOut(MAX(AViewInfo.Bounds.Left + 2, AViewInfo.Bounds.Left +
    (AViewInfo.Bounds.Right - AViewInfo.Bounds.Left - ACanvas.TextHeight(AViewInfo.Column.Caption)) div 2), AViewInfo.Bounds.Bottom - 2, AViewInfo.Column.Caption);
  ADone := True;
end;

procedure TCrossDBViewAddOn.onEditing(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; var AAllow: Boolean);
begin
  if Assigned(FEditing) then
     FEditing(Sender, AItem, AAllow);
  if Assigned(HeaderDataSet) and (FCreateColumnList.IndexOf(Aitem) >= 0) then
     HeaderDataSet.Locate(HeaderColumnName, Aitem.Caption, []);
end;

procedure TCrossDBViewAddOn.SetView(const Value: TcxGridTableView);
begin
  inherited;
  if Value <> nil then begin
     FDataSet := TcxDBDataController(Value.DataController).DataSet;
     if Assigned(FDataSet) then
     begin
       FBeforeOpen := FDataSet.BeforeOpen;
       FDataSet.BeforeOpen := onBeforeOpen;
       FAfterClose := FDataSet.AfterClose;
       FDataSet.AfterClose := onAfterClose;
     end;
     FEditing := Value.OnEditing;
     Value.OnEditing := Nil;
     Value.OnEditing := onEditing;
     FFocusedItemChanged := Value.OnFocusedItemChanged;
     Value.OnFocusedItemChanged := FocusedItemChanged;
  end;
end;

{ TAddOnFormData }

{procedure TAddOnFormData.Assign(Source: TPersistent);
begin
  inherited;
  with TAddOnFormData(Source) do begin
    Self.ChoiceAction := ChoiceAction;
    Self.Params := Params;
    Self.ExecuteDialogAction := ExecuteDialogAction;
    Self.isSingle := isSingle;
    Self.isAlwaysRefresh := isAlwaysRefresh;
  end;
end;    }

constructor TAddOnFormData.Create;
begin
  FisAlwaysRefresh := true;
  FisSingle := true;
  FisFreeAtClosing := false;
  FAddOnFormRefresh := TAddOnFormRefresh.Create;
end;

destructor TAddOnFormData.Destroy;
begin
  FAddOnFormRefresh.Free;
  inherited;
end;

{ TColorRule }

procedure TColorRule.Assign(Source: TPersistent);
begin
  if Source is TColorRule then
    with TColorRule(Source) do
    begin
      Self.ColorColumn := ColorColumn;
      Self.ValueColumn := ValueColumn;
      Self.ValueBoldColumn := ValueBoldColumn;
      Self.ColorInValueColumn := ColorInValueColumn;
      Self.BackGroundValueColumn := BackGroundValueColumn;
      Self.ColorValueList.Assign(ColorValueList);
    end
  else
    inherited Assign(Source);
end;

constructor TColorRule.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FColorValueList := TCollection.Create(TColorValue);
  FColorInValueColumn := true;
  FStyle := TcxStyle.Create(nil);
end;

destructor TColorRule.Destroy;
begin
  FreeAndNil(FColorValueList);
  FreeAndNil(FStyle);
  inherited;
end;

{ TColorRulePivot }

procedure TColorRulePivot.Assign(Source: TPersistent);
begin
  if Source is TColorRulePivot then
    with TColorRulePivot(Source) do
    begin
      Self.ColorColumn := ColorColumn;
      Self.ValueColumn := ValueColumn;
      Self.ValueBoldColumn := ValueBoldColumn;
      Self.ColorInValueColumn := ColorInValueColumn;
      Self.BackGroundValueColumn := BackGroundValueColumn;
      Self.ColorValueList.Assign(ColorValueList);
    end
  else
    inherited Assign(Source);
end;

constructor TColorRulePivot.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FColorValueList := TCollection.Create(TColorValue);
  FColorInValueColumn := true;
  FStyle := TcxStyle.Create(nil);
end;

destructor TColorRulePivot.Destroy;
begin
  FreeAndNil(FColorValueList);
  FreeAndNil(FStyle);
  inherited;
end;

{ TSummaryFieldPivot }

procedure TSummaryFieldPivot.Assign(Source: TPersistent);
begin
  if Source is TSummaryFieldPivot then
    with TSummaryFieldPivot(Source) do
    begin
      Self.AddColumn := AddColumn;
      Self.SummaryColumn := SummaryColumn;
      Self.TypeColumn := TypeColumn;
      Self.IfDifferent := IfDifferent;
    end
  else
    inherited Assign(Source);
end;

constructor TSummaryFieldPivot.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FIfDifferent := psNone;
end;

destructor TSummaryFieldPivot.Destroy;
begin
  inherited;
end;

{ TColumnAddOn }

constructor TColumnAddOn.Create(Collection: TCollection);
begin
  inherited;
  FindByFullValue := false;
  onExitColumn := TColumnActionOptions.Create;
end;

procedure TColumnAddOn.Init;
begin
  if Assigned(Column) and Assigned(Action) then
     if Assigned(Column.Properties) then
        with Column.Properties.Buttons.Add as TcxEditButton do begin
          Default := True;
          Kind := bkEllipsis;
          Action := Self.Action;
        end;
end;

{ TPivotAddOn }

constructor TPivotAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FAfterOpen := Nil;
  FExpandRow := 0;
  FExpandColumn := 0;
  FOnGetContentStyleEvent := Nil;
  FColorRuleList := TCollection.Create(TColorRulePivot);
  FSummaryFieldList := TCollection.Create(TSummaryFieldPivot);
end;

destructor TPivotAddOn.Destroy;
begin
  FreeAndNil(FSummaryFieldList);
  FreeAndNil(FColorRuleList);
  inherited;
end;

function TPivotAddOn.GetCurrentData: string;
// <xml><field name="" value=""/><field name="" value=""/></xml>
var
  PivotGridViewDataItem: TcxPivotGridViewDataItem;
  i: integer;
  List: TStringList;
begin
  result := '';
  List := TStringList.Create;
  try
    with PivotGrid.ViewData do begin
      if PivotGrid.ViewData.Selection.FocusedCell.X = -1 then
         exit;

      PivotGridViewDataItem := Columns[Selection.FocusedCell.X];
      while Assigned(PivotGridViewDataItem) do begin
         if (PivotGridViewDataItem.Value <> '') and Assigned(PivotGridViewDataItem.Field) and (PivotGridViewDataItem.Field.Area <> faData) then
            List.Add(PivotGridViewDataItem.Value);
         PivotGridViewDataItem := PivotGridViewDataItem.Parent;
      end;

      for i := 0 to DataBuilder.ColumnFields.Count - 1 do
          if List.Count > i then
             result := result + TcxDBPivotGridField(DataBuilder.ColumnFields[i]).DataBinding.DBField.FieldName +
                       '=' + List[List.Count - 1 - i] + ';';

      List.Clear;
      PivotGridViewDataItem := Rows[Selection.FocusedCell.Y];
      while Assigned(PivotGridViewDataItem) do begin
         if PivotGridViewDataItem.Value <> '' then
            List.Add(PivotGridViewDataItem.Value);
         PivotGridViewDataItem := PivotGridViewDataItem.Parent;
      end;

      for i := 0 to DataBuilder.RowFields.Count - 1 do
          if List.Count > i then
             result := result + TcxDBPivotGridField(DataBuilder.RowFields[i]).DataBinding.DBField.FieldName +
                       '=' + List[List.Count - 1 - i] + ';';
    end;
  finally
    List.Free
  end;
end;

procedure TPivotAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

   if Operation = opRemove then begin
      if AComponent = PivotGrid then
         PivotGrid := nil;
   end;
end;

procedure TPivotAddOn.SetPivotGrid(const Value: TcxDBPivotGrid);
begin
  FPivotGrid := Value;
  if Assigned(FPivotGrid) then begin
    FOnKeyDown := FPivotGrid.OnKeyDown;
    FPivotGrid.OnKeyDown := OnKeyDown;
    FPivotGrid.OnDblClick := OnDblClick;
    FOnGetContentStyleEvent := FPivotGrid.Styles.OnGetContentStyle;
    FPivotGrid.Styles.OnGetContentStyle := Nil;
    FPivotGrid.Styles.OnGetContentStyle := OnGetContentStyle;

    if FPivotGrid is TcxDBPivotGrid then
    begin
      FAfterOpen := TcxDBPivotGrid(FPivotGrid).DataSource.DataSet.AfterOpen;
      TcxDBPivotGrid(FPivotGrid).DataSource.DataSet.AfterOpen := OnAfterOpen;
    end;
  end;
end;

procedure TPivotAddOn.OnAfterOpen(ADataSet: TDataSet);
  var I, J : Integer;
begin
  FPivotGrid.BeginUpdate;
  try
    for I := 0 to FPivotGrid.FieldCount - 1 do
    case FPivotGrid.Fields[I].Area of
      faRow : if FPivotGrid.Fields[I].AreaIndex < FExpandRow then FPivotGrid.Fields[I].ExpandAll;
      faColumn : if FPivotGrid.Fields[I].AreaIndex < FExpandColumn then FPivotGrid.Fields[I].ExpandAll;
    end;

    for I := 0 to FSummaryFieldList.Count - 1 do
      if Assigned(TSummaryFieldPivot(FSummaryFieldList.Items[I]).SummaryColumn) and
         Assigned(TSummaryFieldPivot(FSummaryFieldList.Items[I]).TypeColumn) then
    begin
      for J := 0 to FPivotGrid.FieldCount - 1 do
        if FPivotGrid.Fields[J] = TSummaryFieldPivot(FSummaryFieldList.Items[I]).SummaryColumn then
      begin
        FPivotGrid.Fields[J].OnCalculateCustomSummary := OnCalculateCustomSummary;
        FPivotGrid.Fields[J].SummaryType := stCustom;
      end;
    end;

  finally
    FPivotGrid.EndUpdate;
  end;

  if Assigned(FAfterOpen) then
     FAfterOpen(ADataSet);
end;

procedure TPivotAddOn.OnGetContentStyle(Sender: TcxCustomPivotGrid;
      ACell: TcxPivotGridDataCellViewInfo; var AStyle: TcxStyle);
var Column: TcxGridColumn;
    i, j: integer;
    isBold_calc:Boolean;
begin

  if Assigned(FOnGetContentStyleEvent) then
     FOnGetContentStyleEvent(Sender, ACell, AStyle);

  if ACell = nil then exit;

  // Если это сгруппированная строка, то выходим
//  if ACell.IsGrandTotal or
//     ACell.Row.IsTotalItem or
//     ACell.Column.IsTotalItem then Exit;

  // Работаем с условиями
  try
    for i := 0 to ColorRuleList.Count - 1 do
      with TColorRulePivot(ColorRuleList.Items[i]) do begin
        if Assigned(ColorColumn) then
        begin
          if ACell.DataField = ColorColumn then begin
           //сначала Bold, !!!но так не работает, поэтому - отключил!!!!
           {isBold_calc:= false;
           if Assigned(ValueBoldColumn) then
              if not VarIsNull(ARecord.Values[ValueBoldColumn.Index]) then
              isBold_calc:= AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true');}
           //
           if Assigned(ValueColumn) and (ValueColumn.Area = faData) then
              if not VarIsNull(ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(ValueColumn,stMax)) then begin
                 FStyle.TextColor := ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(ValueColumn,stMax);
                 // if isBold_calc = true then FStyle.Font.Style:= [fsBold] else if Assigned(FStyle.Font) then FStyle.Font.Style:= [];
                 AStyle := FStyle
              end;
           if Assigned(BackGroundValueColumn) and (BackGroundValueColumn.Area = faData) then
              if not VarIsNull(ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(BackGroundValueColumn,stMax)) then begin
              begin
                j := BackGroundValueColumn.Index;
                FStyle.Color := ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(BackGroundValueColumn,stMax);
              end;
                 AStyle := FStyle
              end;
           end;
        end
        else begin
           //сначала Bold, !!!но так не работает, поэтому - отключил!!!!
           {isBold_calc:= false;
           if Assigned(ValueBoldColumn) then
              if not VarIsNull(ARecord.Values[ValueBoldColumn.Index]) then
              isBold_calc:= AnsiUpperCase(ARecord.Values[ValueBoldColumn.Index]) = AnsiUpperCase('true');}
           //
           if Assigned(ValueColumn) and (ValueColumn.Area = faData) then
              if not VarIsNull(ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(ValueColumn,stMax)) then begin
                 FStyle.TextColor := ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(ValueColumn,stMax);
                 // if (isBold_calc = true)and Assigned(FStyle.Font) then FStyle.Font.Style:= [fsBold] else if Assigned(FStyle.Font) then FStyle.Font.Style:= [];
                 AStyle := FStyle
              end;
           if Assigned(BackGroundValueColumn) and (BackGroundValueColumn.Area = faData) then
              if not VarIsNull(ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(BackGroundValueColumn,stMax)) then begin
                 FStyle.Color := ACell.CellSummary.Owner.Row.GetCellByCrossItem(ACell.CellSummary.Owner.Column).GetSummaryByField(BackGroundValueColumn,stMax);
                 AStyle := FStyle
              end;
        end;
      end;
  except
    on E: Exception do ShowMessage(E.Message + ' ' +IntToStr(FPivotGrid.FieldCount)  + ' ' +  IntToStr(J));
  end;

end;

  // расчет сумирования по ячейкам
procedure TPivotAddOn.OnCalculateCustomSummary(
  Sender: TcxPivotGridField; ASummary: TcxPivotGridCrossCellSummary);

  var ARow, AColumn: TcxPivotGridGroupItem; AddColumn, TypeColumn : TcxPivotGridField;
      PivotSummartType: TPivotSummartType; I, S : Integer;

  function VarToDouble(const AValue: Variant): Currency;
  begin
    Result := 0;
    if not VarIsNull(AValue) and (VarType(AValue) in [varSmallInt, varInteger, varSingle, varDouble, varCurrency, varShortInt,
                                                      varByte, varWord, varLongWord, varInt64, varUInt64])  then
      Result := AValue;
  end;

  function VarToInteger(const AValue: Variant): Integer;
  begin
    Result := - 2;
    if not VarIsNull(AValue) and (VarType(AValue) in [varSmallInt, varInteger, varSingle, varShortInt,
                                                      varByte, varWord, varLongWord, varInt64, varUInt64]) then
      Result := AValue;
  end;

  function CalсAveragePrice : variant;
    var I, C : integer; nSum, nAmount : Currency;  bNext : boolean;

    function RowFits : boolean;
      var J : integer;
    begin
      Result := False;
      if ARow.DataController.Values[ARow.RecordIndex, ARow.Field.Index] = ARow.DataController.Values[I, ARow.Field.Index] then
      begin
        if ARow.Field.AreaIndex > 0 then
        begin
          for J := 0 to PivotGrid.FieldCount - 1 do
            if (PivotGrid.Fields[J].Area = ARow.Field.Area) and (PivotGrid.Fields[J].AreaIndex < ARow.Field.AreaIndex) then
              if ARow.DataController.Values[ARow.RecordIndex, PivotGrid.Fields[J].Index] <> ARow.DataController.Values[I, PivotGrid.Fields[J].Index] then Exit;
        end;
        Result := True;
      end;
    end;

    function ColumnFits : boolean;
      var J : integer;
    begin
      Result := False;
      if ARow.DataController.Values[AColumn.RecordIndex, AColumn.Field.Index] = ARow.DataController.Values[I, AColumn.Field.Index] then
      begin
        if AColumn.Field.AreaIndex > 0 then
        begin
          for J := 0 to PivotGrid.FieldCount - 1 do
            if (PivotGrid.Fields[J].Area = AColumn.Field.Area) and (PivotGrid.Fields[J].AreaIndex < AColumn.Field.AreaIndex) then
              if ARow.DataController.Values[AColumn.RecordIndex, PivotGrid.Fields[J].Index] <> ARow.DataController.Values[I, PivotGrid.Fields[J].Index] then Exit;
        end;
        Result := True;
      end;
    end;

  begin
    Result := Null; nSum := 0; nAmount := 0;
    if not Assigned(AddColumn) then Exit;

    for I := 0 to ARow.DataController.RecordCount - 1 do
    begin

      bNext := False;
      for C := 0 to PivotGrid.FieldCount - 1 do
        if (TcxDBPivotGridField(PivotGrid.Fields[c]).Filter.Values.Count > 0) then
           if not TcxDBPivotGridField(PivotGrid.Fields[c]).Filter.Contains(ARow.DataController.Values[I, PivotGrid.Fields[c].Index]) then
      begin
        bNext := True;
        Break;
      end;
      if bNext then Continue;

      if ARow.Field <> Nil then
      begin
        if RowFits then
        begin
          if AColumn.Field <> Nil then
          begin
            if ColumnFits then
            begin
              nSum := nSum + VarToDouble(ARow.DataController.Values[I, Sender.Index]) *
                VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
              nAmount := nAmount + VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
            end
          end else
          begin
            nSum := nSum + VarToDouble(ARow.DataController.Values[I, Sender.Index]) *
              VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
            nAmount := nAmount + VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
          end;
        end;
      end else
      begin
        if AColumn.Field <> Nil then
        begin
          if ColumnFits then
          begin
            nSum := nSum + VarToDouble(ARow.DataController.Values[I, Sender.Index]) *
              VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
            nAmount := nAmount + VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
          end;
        end else
        begin
          nSum := nSum + VarToDouble(ARow.DataController.Values[I, Sender.Index]) *
            VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
          nAmount := nAmount + VarToDouble(ARow.DataController.Values[I, AddColumn.Index]);
        end;
      end;
    end;

    if nAmount > 0 then Result := RoundTo(nSum / nAmount, - 2);
  end;

begin
  ARow := ASummary.Owner.Row;
  AColumn := ASummary.Owner.Column;
  TypeColumn := Nil;

  for I := 0 to FSummaryFieldList.Count - 1 do
    if Assigned(TSummaryFieldPivot(FSummaryFieldList.Items[I]).SummaryColumn) and
       Assigned(TSummaryFieldPivot(FSummaryFieldList.Items[I]).TypeColumn) then
  begin
    if TSummaryFieldPivot(FSummaryFieldList.Items[I]).FSummaryColumn = Sender then
    begin
      AddColumn := TSummaryFieldPivot(FSummaryFieldList.Items[I]).AddColumn;
      TypeColumn := TSummaryFieldPivot(FSummaryFieldList.Items[I]).TypeColumn;
      PivotSummartType := TSummaryFieldPivot(FSummaryFieldList.Items[I]).IfDifferent;
    end;
  end;

  if Assigned(TypeColumn) then
  begin
    S := VarToInteger(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(TypeColumn, stMin));
    if (S >= 0) and (S <> VarToInteger(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(TypeColumn, stMax))) then S := -1;

    if (S >= 0) and (S <= Ord(High(TPivotSummartType))) then PivotSummartType := TPivotSummartType(S)
    else if S <> -1 then PivotSummartType := psNone;
  end else PivotSummartType := psNone;

  case PivotSummartType of
    psCount : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stCount));
    psSum : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stSum));
    psMin : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stMin));
    psMax : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stMax));
    psAverage : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stAverage));
    psStdDev : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stStdDev));
    psStdDevP : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stStdDevP));
    psVariance : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stVariance));
    psVarianceP : ASummary.Custom := VarToDouble(ARow.GetCellByCrossItem(AColumn).GetSummaryByField(Sender, stVarianceP));
    psAveragePrice : ASummary.Custom := CalсAveragePrice;
  end;

end;


{ TCrossDBViewSetTypeId }

constructor TCrossDBViewSetTypeId.Create(AOwner: TComponent);
begin
  inherited;
end;

function TCrossDBViewSetTypeId.LocalExecute: Boolean;
begin
  Result := False;
  if not Assigned(FCrossDBViewAddOn) then
    raise Exception.Create('Не определен CrossDBViewAddOn');

  if not Assigned(FCrossDBViewAddOn.FHeaderDataSet) then
    raise Exception.Create('Не определен HeaderDataSet');

  if not Assigned(FCrossDBViewAddOn.FView) then
    raise Exception.Create('Не определен View');

  if not FCrossDBViewAddOn.FView.Focused then
    raise Exception.Create('Не установлен фокус на грид');

  if not Assigned(FCrossDBViewAddOn.FView.Controller.FocusedColumn) then
    raise Exception.Create('Не установлен фокус на поле грида');

  if FCrossDBViewAddOn.FCreateColumnList.IndexOf(FCrossDBViewAddOn.FView.Controller.FocusedColumn) < 0 then
    raise Exception.Create('Выбранное поле не принадлежит область для позиционирования...');

  Result := FCrossDBViewAddOn.FHeaderDataSet.Locate(FCrossDBViewAddOn.FHeaderColumnName, FCrossDBViewAddOn.FView.Controller.FocusedColumn.Caption, []);
end;


{ TColumnCollectionItem }

function TColumnCollectionItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(Column) then
     result := Column.Name
end;

{ TSummaryItemAddOn }

procedure TSummaryItemAddOn.Assign(Source: TPersistent);
begin
  if Source is TSummaryItemAddOn then
     Self.Param.Assign(TSummaryItemAddOn(Source).Param)
  else
    inherited Assign(Source);
end;

constructor TSummaryItemAddOn.Create(ACollection: TCollection);
begin
  inherited;
  FParam := TdsdParam.Create(nil);
end;

destructor TSummaryItemAddOn.Destroy;
begin
  FreeAndNil(FParam);
  inherited;
end;

procedure TSummaryItemAddOn.onGetText(Sender: TcxDataSummaryItem;
  const AValue: Variant; AIsFooter: Boolean; var AText: string);
begin
  if Param.Value = NULL then
     AText := ''
  else
     AText := Param.Value;
end;

procedure TSummaryItemAddOn.SetDataSummaryItemIndex(const Value: Integer);
begin
  FDataSummaryItemIndex := Value;
  if Value = -1  then
     exit;
  // пытаемся установить свойство onGetText установить
  if Collection.Owner is TdsdDBViewAddOn then
     if Assigned(TdsdDBViewAddOn(Collection.Owner).View) then begin
        if TdsdDBViewAddOn(Collection.Owner).View.DataController.Summary.FooterSummaryItems.Count > Value then
           TdsdDBViewAddOn(Collection.Owner).View.DataController.Summary.FooterSummaryItems[Value].OnGetText := onGetText;
     end;
end;

{ TColorValue }

procedure TColorValue.Assign(Source: TPersistent);
begin
  if Source is TColorValue then
    with TColorValue(Source) do
    begin
      Self.Color := Color;
      Self.Value := Value;
    end
  else
    inherited Assign(Source);
end;

{ TAddOnFormRefresh }

constructor TAddOnFormRefresh.Create;
begin
  FParentList := '';
  FSelfList := '';
  FKeyField := '';
  FNeedRefresh := False;
  FRefreshID := 0;
  FGetStoredProc := nil;
  FDataSet := nil;
end;

destructor TAddOnFormRefresh.Destroy;
begin

  inherited;
end;

function TAddOnFormRefresh.GetDataSet: TDataSet;
begin
  Result := FDataSet;
end;

function TAddOnFormRefresh.GetGetStoredProc: TdsdStoredProc;
begin
  Result := FGetStoredProc;
end;

procedure TAddOnFormRefresh.RefreshRecord;
var
  i: Integer;
  procedure AssignValue(AField: TField; AParam: TdsdParam);
  var
    F: TFormatSettings;
    S: String;
  Begin
    case AField.DataType of
      ftDate,ftTime,ftDateTime:
        Begin
          S:=Copy(AParam.asString,1,10)+' '+Copy(AParam.asString,12,8);
          F.TimeSeparator := ':';
          if pos('.',S)>0 then
          Begin
            F.ShortDateFormat := 'DD.MM.YYYY';
            F.DateSeparator := '.';
          End
          else if pos('-',S)>0 then
          Begin
            F.DateSeparator := '-';
            F.ShortDateFormat := 'YYYY-MM-DD';
          End;
          F.LongDateFormat := 'hh:mm:ss';
          AField.AsDateTime := StrToDateTime(S,F);
        End;
      ftFloat,ftCurrency,ftBCD,TFieldType.ftExtended:
        AField.Value := AParam.AsFloat;
    ELSE
      if VarToStr(AParam.Value) = '' then
        AField.Clear
      else
        AField.Value := AParam.Value;
//      ftUnknown: ;
//      ftString: ;
//      ftSmallint: ;
//      ftInteger: ;
//      ftWord: ;
//      ftBoolean: ;
//      ftFloat: ;
//      ftCurrency: ;
//      ftBCD: ;
//      ftBytes: ;
//      ftVarBytes: ;
//      ftAutoInc: ;
//      ftBlob: ;
//      ftMemo: ;
//      ftGraphic: ;
//      ftFmtMemo: ;
//      ftParadoxOle: ;
//      ftDBaseOle: ;
//      ftTypedBinary: ;
//      ftCursor: ;
//      ftFixedChar: ;
//      ftWideString: ;
//      ftLargeint: ;
//      ftADT: ;
//      ftArray: ;
//      ftReference: ;
//      ftDataSet: ;
//      ftOraBlob: ;
//      ftOraClob: ;
//      ftVariant: ;
//      ftInterface: ;
//      ftIDispatch: ;
//      ftGuid: ;
//      ftTimeStamp: ;
//      ftFMTBcd: ;
//      ftFixedWideChar: ;
//      ftWideMemo: ;
//      ftOraTimeStamp: ;
//      ftOraInterval: ;
//      ftLongWord: ;
//      ftShortint: ;
//      ftByte: ;
//      ftExtended: ;
//      ftConnection: ;
//      ftParams: ;
//      ftStream: ;
//      ftTimeStampOffset: ;
//      ftObject: ;
//      ftSingle: ;
    end;

  end;
begin
  //Если не определена процедура рефреша  то выходим
  if not Assigned(FGetStoredProc) then exit;
  //Если не определ рабочий датасет то выходим
  if not Assigned(FDataSet) then exit;
  //Если ДатаСет не имеет полей - выходим
  if FDataSet.FieldCount = 0 then exit;
  //Если кодер не заполнил ключевое поле, то считаем что 1-я колонка в датасете ключевая
  if (FKeyField = '') then
    FKeyField := FDataSet.Fields[0].FieldName;
  //Если ДатаСет не имеет поля FKeyField - выходим
  if FDataSet.FindField(FKeyField) = nil then exit;
  //Пытаемся найти параметр
  if not Assigned(FGetStoredProc.Params.ParamByName(FKeyParam)) then exit;

  try
    //задизеблить, что бы не вызвался повторно gpInsertUpdate...
    FDataSet.DisableControls;

    //Приписываем ему значение присланого ИД
    FGetStoredProc.Params.ParamByName(FKeyParam).Value := FRefreshID;
    //пробуем выполнить процедуру
    FGetStoredProc.Execute;

    //Если в датасете найдена запись ко ключевому полю - переводим датасет в режим редактирования
    if FDataSet.Locate(FKeyField,FRefreshID,[]) then
      FDataSet.Edit
    else
    //Если запись не найдена - добавляем её в датасет
    Begin
      FDataSet.Append;
      FDataSet.FieldByName(FKeyField).Value := FRefreshID;
    End;
    //Перебрать все поля и заполнить их значениями параметров с такими же именами
    for I := 0 to FDataSet.FieldCount-1 do
    Begin
      //Если это ключевое поле - то перебивать его не нужно
      if CompareText(FDataSet.Fields[i].FieldName, FKeyField) = 0 then Continue;
      //Пробуем прописать значения полю из параметров с таким же именем
      if Assigned(FGetStoredProc.Params.ParamByName(FDataSet.Fields[i].FieldName)) then
        AssignValue(FDataSet.Fields[i],FGetStoredProc.Params.ParamByName(FDataSet.Fields[i].FieldName))
      else
      //Если полного совпадения нет - то пробуем со стандартной приставкой out
      if Assigned(FGetStoredProc.Params.ParamByName('out'+FDataSet.Fields[i].FieldName)) then
        AssignValue(FDataSet.Fields[i],FGetStoredProc.Params.ParamByName('out'+FDataSet.Fields[i].FieldName));
    End;
    FDataSet.Post;
  finally
    if FDataSet.State in [dsInsert,dsEdit] then
      FDataSet.Cancel;
    //Отключаем необходимось перечитывать данные при следующей активизации
    FNeedRefresh := False;
    //вернуть на место, что бы вызвался повторно gpInsertUpdate...
    FDataSet.EnableControls;
  end;
end;

procedure TAddOnFormRefresh.SetDatSet(Value: TDataSet);
begin
  if Value = FDataSet then exit;
  FDataSet := Value;
end;

procedure TAddOnFormRefresh.SetGetStoredProc(Value: TdsdStoredProc);
begin
  if Value = FGetStoredProc then exit;
  FGetStoredProc := Value;
end;

{  TdsdGMMap  }

constructor TdsdGMMap.Create(AOwner: TComponent);
begin
  inherited;
  AfterPageLoaded := DoAfterPageLoaded;
  FMapLoad := False;
end;

procedure TdsdGMMap.DoAfterPageLoaded(Sender: TObject; First: Boolean);
begin
  try
    if First then
    begin
      DoMap;
      FMapLoad := True;
    end;
  except
    FMapLoad := False;

    LoadDefaultWebBrowser;

    if Owner is TForm then
      (Owner as TForm).Close;
  end;
end;

procedure TdsdGMMap.LoadDefaultWebBrowser;
var
  Field: TField;
  GPSNValue, GPSEValue: Real;
  OldDecimalSeparator: Char;
  AddressValue, MapURL: string;
begin
  if Assigned(DataSet) then
  begin
    if Trim(GPSNField) = '' then
      GPSNField := 'GPSN';

    if Trim(GPSEField) = '' then
      GPSEField := 'GPSE';

    GPSNValue := 0.0;
    GPSEValue := 0.0;

    Field := DataSet.FindField(GPSNField);
    if Assigned(Field) then
      GPSNValue := Field.AsFloat;

    Field := DataSet.FindField(GPSEField);
    if Assigned(Field) then
      GPSEValue := Field.AsFloat;

    Field := DataSet.FindField('AddressByGPS');
    if Assigned(Field) then
      AddressValue := Field.AsString;

    if (GPSNValue <> 0.0) and (GPSEValue <> 0.0) then
    begin
      AddressValue := ReplaceStr(AddressValue, ' ', '+');

      OldDecimalSeparator := FormatSettings.DecimalSeparator;
      if OldDecimalSeparator = ',' then
        FormatSettings.DecimalSeparator := '.';

      MapURL := Format('https://www.google.com.ua/maps/place/%s/@%g,%g,%uz?hl=uk', [AddressValue, GPSNValue, GPSEValue, 17]);
      FormatSettings.DecimalSeparator := OldDecimalSeparator;
      ShellExecute(0, 'open', PChar(MapURL), nil, nil, SW_SHOWNORMAL);
    end;
  end;
end;

procedure TdsdGMMap.SetDocLoaded;
begin
  FDocLoaded := True;
end;

{  TGeoMarker  }

type
  TGeoMarkerData = record
    Lat: Real;
    Lng: Real;
    Title: string;
    InsertDate: TDateTime;
  end;

  TGeoMarker = class
  private
    FData: TGeoMarkerData;
    function GetData: TGeoMarkerData;
  public
    constructor Create(ALat, ALng: Real; ATitle: string; AInsertDate: TDateTime);
    property Data: TGeoMarkerData read GetData;
  end;

  TGeoMarkerList = class(TObjectList)
  private
    function GetGeoMarker(Index: Integer): TGeoMarker;
    procedure SetGeoMarker(Index: Integer; const Value: TGeoMarker);
  public
    property Items[Index: Integer]: TGeoMarker read GetGeoMarker write SetGeoMarker; default;
  end;

function CompareGeoMarkerData(Item1, Item2: Pointer): Integer;
var
  Data1, Data2: TGeoMarkerData;
begin
  Data1 := TGeoMarker(Item1).Data;
  Data2 := TGeoMarker(Item2).Data;

  if Data1.InsertDate > Data2.InsertDate then
    Result := 1
  else if Data1.InsertDate < Data2.InsertDate then
    Result := -1
  else
    Result := 0;
end;

{  TdsdWebBrowser  }

constructor TdsdWebBrowser.Create(AOwner: TComponent);
begin
  inherited;
  OnDownloadComplete := DoDownloadComplete;

  FTimer := TTimer.Create(Self);
  FTimer.Enabled := False;
  FTimer.Interval := 1000;
  FTimer.OnTimer := OnTimerNotifyEvent;
end;

destructor TdsdWebBrowser.Destroy;
begin
  FTimer.Free;
  inherited;
end;

procedure TdsdWebBrowser.OnTimerNotifyEvent(Sender: TObject);
var
  i,j: integer;
  GMList: TGeoMarkerList;
  FDataSet: TDataSet;
  GPSNField, GPSEField, AddressField, InsertDateField, Adr: string;
  InsertDateValue: TDateTime;

  function IsDelta : boolean;
  begin
    Result := Sqrt(Sqr(GMList[j].Data.Lat - GMList[i].Data.Lat) + Sqr(GMList[j].Data.Lng - GMList[i].Data.Lng)) > 0.002;
  end;

begin
  FTimer.Enabled := False;
  GMList := TGeoMarkerList.Create;

  GPSNField := TdsdGMMap(FGeoCode.Map).GPSNField;
  if Trim(GPSNField) = '' then
    GPSNField := 'GPSN';

  GPSEField := TdsdGMMap(FGeoCode.Map).GPSEField;
  if Trim(GPSEField) = '' then
    GPSEField := 'GPSE';

  AddressField := TdsdGMMap(FGeoCode.Map).AddressField;
  if Trim(AddressField) = '' then
    AddressField := 'Address';

  InsertDateField := TdsdGMMap(FGeoCode.Map).InsertDateField;
  if Trim(InsertDateField) = '' then
    InsertDateField := 'InsertMobileDate';

  FDataSet := TdsdGMMap(FGeoCode.Map).DataSet;

  try
    if Assigned(FDataSet) then
    begin
      FDataSet.DisableControls;
      try
        if (FDataSet.FindField(GPSNField) <> nil) and (FDataSet.FindField(GPSEField) <> nil) then
        begin
          if TdsdGMMap(FGeoCode.Map).MapType = acShowOne then
          begin
            FGeoCode.Map.RequiredProp.Zoom := 18;

            if (FDataSet.FindField(GPSNField).AsFloat <> 0.0) and
               (FDataSet.FindField(GPSEField).AsFloat <> 0.0)
            then
              FGeoCode.Geocode(FDataSet.FindField(GPSNField).AsFloat, FDataSet.FindField(GPSEField).AsFloat)
            else
            if FDataSet.FindField(AddressField) <> nil then
              FGeoCode.Geocode(FDataSet.FindField(AddressField).AsString);

            InsertDateValue := StrToDateTime('01.01.1900');
            if FDataSet.FindField(InsertDateField) <> nil then
              InsertDateValue := FDataSet.FieldByName(InsertDateField).AsDateTime;

            if (FGeoCode.GeoStatus = gsOK) and (FGeoCode.Count > 0) then
              GMList.Add(TGeoMarker.Create(
                FGeoCode.GeoResult[0].Geometry.Location.Lat,
                FGeoCode.GeoResult[0].Geometry.Location.Lng,
                FGeoCode.GeoResult[0].FormatedAddr,
                InsertDateValue));
          end
          else
          begin
            FGeoCode.Map.RequiredProp.Zoom := 13;

            FDataSet.First;
            while not FDataSet.Eof do
            begin
              InsertDateValue := StrToDateTime('01.01.1900');
              if FDataSet.FindField(InsertDateField) <> nil then
                InsertDateValue := FDataSet.FieldByName(InsertDateField).AsDateTime;

              if (FDataSet.FindField(GPSNField).AsFloat <> 0) and
                 (FDataSet.FindField(GPSEField).AsFloat <> 0) then
              begin
                if FDataSet.FindField(AddressField) <> nil then
                  Adr := FDataSet.FindField(AddressField).AsString
                else Adr := '';

                GMList.Add(TGeoMarker.Create(
                   FDataSet.FindField(GPSNField).AsFloat,
                   FDataSet.FindField(GPSEField).AsFloat,
                   Adr,
                   InsertDateValue));

              end else if FDataSet.FindField(AddressField) <> nil then
              begin
                FGeoCode.Geocode(FDataSet.FindField(AddressField).AsString);

                if (FGeoCode.GeoStatus = gsOK) and (FGeoCode.Count > 0) then
                 GMList.Add(TGeoMarker.Create(
                   FGeoCode.GeoResult[0].Geometry.Location.Lat,
                   FGeoCode.GeoResult[0].Geometry.Location.Lng,
                   FGeoCode.GeoResult[0].FormatedAddr,
                   InsertDateValue));
              end;

              FDataSet.Next;
            end;

            FDataSet.First;
          end;

          GMList.Sort(CompareGeoMarkerData);

          j := 0;
          for i := 0 to Pred(GMList.Count) do if (i = 0) or IsDelta then
          begin
            j := I;
            FGeoCode.Marker.Add(GMList[i].Data.Lat, GMList[i].Data.Lng, FormatDateTime('hh:mm', GMList[i].Data.InsertDate));
            FGeoCode.Marker.Items[FGeoCode.Marker.Count - 1].MarkerType := mtStyledMarker;
            TGMMarker(FGeoCode.Marker).Items[FGeoCode.Marker.Count - 1].StyledMarker.StyledIcon := siBubble;
          end;

          if FGeoCode.Marker.Count > 1 then
          begin
            FDirection.DirectionsRequest.Origin.LatLng.Lat := FGeoCode.Marker.Items[0].Position.Lat;
            FDirection.DirectionsRequest.Origin.LatLng.Lng := FGeoCode.Marker.Items[0].Position.Lng;
            FDirection.DirectionsRequest.Destination.LatLng.Lat := FGeoCode.Marker.Items[Pred(FGeoCode.Marker.Count)].Position.Lat;
            FDirection.DirectionsRequest.Destination.LatLng.Lng := FGeoCode.Marker.Items[Pred(FGeoCode.Marker.Count)].Position.Lng;

            if FGeoCode.Marker.Count > 2 then
            begin
              for i := 1 to FGeoCode.Marker.Count - 2 do
                with FDirection.AddWaypoint.Location.LatLng do
                begin
                  Lat := FGeoCode.Marker.Items[i].Position.Lat;
                  Lng := FGeoCode.Marker.Items[i].Position.Lng;
                end;

              FDirection.Execute;
            end;
          end;

          if FGeoCode.Marker.Count > 0 then
            FGeoCode.Marker.Items[0].CenterMapTo;
        end;
      finally
        FDataSet.EnableControls;
      end;
    end;
  finally
    GMList.Free;
  end;
end;

procedure TdsdWebBrowser.DoDownloadComplete(Sender: TObject);
var
  I: integer;
  Form: TForm;
  Comp: TComponent;
begin
  Form := Owner as TForm;

  if Assigned(Form) then
  begin
    FGeoCode := nil;
    FDirection := nil;

    for I := 0 to Form.ComponentCount - 1 do
    begin
      Comp := Form.Components[I];

      if (Comp.ClassType = TGMGeoCode) and (FGeoCode = nil) then
        FGeoCode := Comp as TGMGeoCode;

      if (Comp.ClassType = TGMDirection) and (FDirection = nil) then
        FDirection := Comp as TGMDirection;

      if (FGeoCode <> nil) and (FDirection <> nil) then
        Break;
    end;

    if Assigned(FGeoCode) and Assigned(FGeoCode.Map) and (FGeoCode.Map.ClassType = TdsdGMMap) and
       Assigned(FGeoCode.Marker) and TdsdGMMap(FGeoCode.Map).MapLoad and
       Assigned(FDirection) and Assigned(FDirection.Map) and (FDirection.Map.ClassType = TdsdGMMap) then
    begin
      FDirection.ClearWaypoint;
      FGeoCode.Marker.Clear;
      TdsdGMMap(FGeoCode.Map).MapLoad := False;
      TdsdGMMap(FGeoCode.Map).SetDocLoaded;

      FTimer.Enabled := true;
    end;
  end;
end;

{ TChangerListItem }

procedure TChangerListItem.Assign(Source: TPersistent);
begin
  if Source is TChangerListItem then
    Self.Control := (Source as TChangerListItem).Control
  else
    inherited Assign(Source);
end;

function TChangerListItem.GetDisplayName: string;
begin
  if Control <> nil then
    Result := Control.Name
  else
    Result := inherited GetDisplayName;
end;

procedure TChangerListItem.SetControl(const Value: TControl);
begin
  if Value <> FControl then
  begin
    FControl := Value;
    if Assigned(FControl) and Assigned(Collection) then
    begin
      FControl.FreeNotification(TComponent(Collection.Owner));
      if (Collection.Owner is THeaderChanger) then
      begin
        if FControl is TcxTextEdit then
          (FControl as TcxTextEdit).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxMemo then
          (FControl as TcxMemo).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxMaskEdit then
          (FControl as TcxMaskEdit).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxDateEdit then
          (FControl as TcxDateEdit).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxButtonEdit then
          (FControl as TcxButtonEdit).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxCheckBox then
          (FControl as TcxCheckBox).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxCurrencyEdit then
          (FControl as TcxCurrencyEdit).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
        if FControl is TcxComboBox then
          (FControl as TcxComboBox).Properties.OnChange := THeaderChanger(Collection.Owner).OnChange;
      end;
    end;
  end;
end;

{ TChangerList }

function TChangerList.Add: TChangerListItem;
begin
  Result := inherited Add as TChangerListItem;
end;

function TChangerList.GetChangerListItem(Index: Integer): TChangerListItem;
begin
  Result := inherited GetItem(Index) as TChangerListItem
end;

procedure TChangerList.SetChangerListItem(Index: Integer; const Value: TChangerListItem);
begin
  inherited SetItem(Index, Value);
end;

{ THeaderChanger }

constructor THeaderChanger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParam := TdsdParam.Create(nil);
  FChangerList := TChangerList.Create(Self, TChangerListItem);
end;

destructor THeaderChanger.Destroy;
begin
  FParam.Free;
  FreeAndNil(FChangerList);
  inherited;
end;

procedure THeaderChanger.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
  begin
    if (AComponent is TControl) and Assigned(ChangerList) then
    begin
      for I := 0 to Pred(ChangerList.Count) do
        if ChangerList[I].Control = AComponent then
          ChangerList[I].Control := nil;
    end;

    if AComponent = Action then
      Action := nil;
  end;
end;

procedure THeaderChanger.OnChange(Sender: TObject);
begin
  if Assigned(Action) then
    if (Sender is TcxTextEdit) or
      (Sender is TcxMemo) or
      (Sender is TcxMaskEdit) or
      (Sender is TcxButtonEdit) or
      (Sender is TcxCurrencyEdit) or
      (Sender is TcxDateEdit) or
      (Sender is TcxCheckBox) or
      (Sender is TcxComboBox) or
      (Sender is TcxDateNavigator) then
      Action.Execute;
end;

{ TExitListItem }

procedure TExitListItem.Assign(Source: TPersistent);
begin
  if Source is TExitListItem then
    Self.Control := (Source as TExitListItem).Control
  else
    inherited Assign(Source);
end;

function TExitListItem.GetDisplayName: string;
begin
  if Control <> nil then
    Result := Control.Name
  else
    Result := inherited GetDisplayName;
end;

procedure TExitListItem.SetControl(const Value: TWinControl);
begin
  if Value <> FControl then
  begin

    if Assigned(FControl) then
    begin
      if FControl is TcxTextEdit then
      begin
        TcxTextEdit(FControl).OnEnter := FOnEnter;
        TcxTextEdit(FControl).OnExit := FOnExit;
      end;
      if FControl is TcxMemo then
      begin
        TcxMemo(FControl).OnEnter := FOnEnter;
        TcxMemo(FControl).OnExit := FOnExit;
      end;
      if FControl is TcxMaskEdit then
      begin
        TcxMaskEdit(FControl).OnEnter := FOnEnter;
        TcxMaskEdit(FControl).OnExit := FOnExit;
      end;
      if FControl is TcxDateEdit then
      begin
        TcxDateEdit(FControl).OnEnter := FOnEnter;
        TcxDateEdit(FControl).OnExit := FOnExit;
      end;
      if FControl is TcxButtonEdit then
      begin
        TcxButtonEdit(FControl).OnEnter := FOnEnter;
        TcxButtonEdit(FControl).OnExit := FOnExit;
      end;
      if FControl is TcxCheckBox then
      begin
        TcxCheckBox(FControl).OnEnter := FOnEnter;
        TcxCheckBox(FControl).OnExit := FOnExit;
      end;
      if FControl is TcxCurrencyEdit then
      begin
        TcxCurrencyEdit(FControl).OnEnter := FOnEnter;
        TcxCurrencyEdit(FControl).OnExit := FOnExit;
      end;
      if FControl is TcxComboBox then
      begin
        TcxComboBox(FControl).OnEnter := FOnEnter;
        TcxComboBox(FControl).OnExit := FOnExit;
      end;
    end;

    FControl := Value;

    if Assigned(FControl) then
    begin
      if FControl is TcxTextEdit then
      begin
        FOnEnter := TcxTextEdit(FControl).OnEnter;
        FOnExit := TcxTextEdit(FControl).OnExit;
        TcxTextEdit(FControl).OnEnter := OnEnter;
        TcxTextEdit(FControl).OnExit := OnExit;
      end;
      if FControl is TcxMemo then
      begin
        FOnEnter := TcxMemo(FControl).OnEnter;
        FOnExit := TcxMemo(FControl).OnExit;
        TcxMemo(FControl).OnEnter := OnEnter;
        TcxMemo(FControl).OnExit := OnExit;
      end;
      if FControl is TcxMaskEdit then
      begin
        FOnEnter := TcxMaskEdit(FControl).OnEnter;
        FOnExit := TcxMaskEdit(FControl).OnExit;
        TcxMaskEdit(FControl).OnEnter := OnEnter;
        TcxMaskEdit(FControl).OnExit := OnExit;
      end;
      if FControl is TcxDateEdit then
      begin
        FOnEnter := TcxDateEdit(FControl).OnEnter;
        FOnExit := TcxDateEdit(FControl).OnExit;
        TcxDateEdit(FControl).OnEnter := OnEnter;
        TcxDateEdit(FControl).OnExit := OnExit;
      end;
      if FControl is TcxButtonEdit then
      begin
        FOnEnter := TcxButtonEdit(FControl).OnEnter;
        FOnExit := TcxButtonEdit(FControl).OnExit;
        TcxButtonEdit(FControl).OnEnter := OnEnter;
        TcxButtonEdit(FControl).OnExit := OnExit;
      end;
      if FControl is TcxCheckBox then
      begin
        FOnEnter := TcxCheckBox(FControl).OnEnter;
        FOnExit := TcxCheckBox(FControl).OnExit;
        TcxCheckBox(FControl).OnEnter := OnEnter;
        TcxCheckBox(FControl).OnExit := OnExit;
      end;
      if FControl is TcxCurrencyEdit then
      begin
        FOnEnter := TcxCurrencyEdit(FControl).OnEnter;
        FOnExit := TcxCurrencyEdit(FControl).OnExit;
        TcxCurrencyEdit(FControl).OnEnter := OnEnter;
        TcxCurrencyEdit(FControl).OnExit := OnExit;
      end;
      if FControl is TcxComboBox then
      begin
        FOnEnter := TcxComboBox(FControl).OnEnter;
        FOnExit := TcxComboBox(FControl).OnExit;
        TcxComboBox(FControl).OnEnter := OnEnter;
        TcxComboBox(FControl).OnExit := OnExit;
      end;
    end;
  end;
end;

procedure TExitListItem.OnExit(Sender: TObject);
  var isChanged : Boolean;
begin
  if Assigned(FOnExit) then FOnExit(Sender);

  isChanged := False;
  if (Sender is TcxTextEdit) and (FValue <> TcxTextEdit(Sender).Text) then isChanged := True;
  if (Sender is TcxMemo) and (FValue <> TcxMemo(Sender).Text) then isChanged := True;
  if (Sender is TcxMaskEdit) and (FValue <> TcxMaskEdit(Sender).Text) then isChanged := True;
  if (Sender is TcxDateEdit) and (FValue <> TcxDateEdit(Sender).Date) then isChanged := True;
  if (Sender is TcxButtonEdit) and (FValue <> TcxButtonEdit(Sender).Text) then isChanged := True;
  if (Sender is TcxCheckBox) and (FValue <> TcxCheckBox(Sender).Checked) then isChanged := True;
  if (Sender is TcxCurrencyEdit) and (FValue <> TcxCurrencyEdit(Sender).Value) then isChanged := True;
  if (Sender is TcxComboBox) and (FValue <> TcxComboBox(Sender).Text) then isChanged := True;
  //
  //if isChanged and Assigned(THeaderExit(Collection.Owner).Action) then THeaderExit(Collection.Owner).Action.Execute;
  //будет всегда
  if Assigned(THeaderExit(Collection.Owner).Action) then THeaderExit(Collection.Owner).Action.Execute;
end;

procedure TExitListItem.OnEnter(Sender: TObject);
begin
  if Assigned(FOnEnter) then FOnEnter(Sender);

  if Sender is TcxTextEdit then FValue := TcxTextEdit(Sender).Text;
  if Sender is TcxMemo then FValue := TcxMemo(Sender).Text;
  if Sender is TcxMaskEdit then FValue := TcxMaskEdit(Sender).Text;
  if Sender is TcxDateEdit then FValue := TcxDateEdit(Sender).Date;
  if Sender is TcxButtonEdit then FValue := TcxButtonEdit(Sender).Text;
  if Sender is TcxCheckBox then FValue := TcxCheckBox(Sender).Checked;
  if Sender is TcxCurrencyEdit then FValue := TcxCurrencyEdit(Sender).Value;
  if Sender is TcxComboBox then FValue := TcxComboBox(Sender).Text;
end;

{ TExitList }

function TExitList.Add: TExitListItem;
begin
  Result := inherited Add as TExitListItem;
end;

function TExitList.GetExitListItem(Index: Integer): TExitListItem;
begin
  Result := inherited GetItem(Index) as TExitListItem
end;

procedure TExitList.SetExitListItem(Index: Integer; const Value: TExitListItem);
begin
  inherited SetItem(Index, Value);
end;

{ THeaderExit }

constructor THeaderExit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FExitList := TExitList.Create(Self, TExitListItem);
end;

destructor THeaderExit.Destroy;
begin
  FreeAndNil(FExitList);
  inherited;
end;

procedure THeaderExit.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
  begin
    if (AComponent is TControl) and Assigned(ExitList) then
    begin
      for I := 0 to Pred(ExitList.Count) do
        if ExitList[I].Control = AComponent then
        begin
          ExitList[I].Control := nil;
        end;
    end;

    if AComponent = Action then
      Action := nil;
  end;
end;

{ TEnterMoveNextListItem }

procedure TEnterMoveNextListItem.Assign(Source: TPersistent);
begin
  if Source is TExitListItem then
    Self.Control := (Source as TExitListItem).Control
  else
    inherited Assign(Source);
end;

function TEnterMoveNextListItem.GetDisplayName: string;
begin
  if Control <> nil then
    Result := Control.Name
  else
    Result := inherited GetDisplayName;
end;

procedure TEnterMoveNextListItem.SetControl(const Value: TWinControl);
begin
  if Value <> FControl then FControl := Value;
end;

{ TEnterMoveNextList }

function TEnterMoveNextList.Add: TEnterMoveNextListItem;
begin
  Result := inherited Add as TEnterMoveNextListItem;
end;

function TEnterMoveNextList.GetEnterMoveNextListItem(Index: Integer): TEnterMoveNextListItem;
begin
  Result := inherited GetItem(Index) as TEnterMoveNextListItem
end;

procedure TEnterMoveNextList.SetEnterMoveNextListItem(Index: Integer; const Value: TEnterMoveNextListItem);
begin
  inherited SetItem(Index, Value);
end;

{ TEnterMoveNext }

constructor TEnterMoveNext.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnterMoveNextList := TEnterMoveNextList.Create(Self, TEnterMoveNextListItem);

  if AOwner is TForm then
  begin
     FOnFormKeyDown := TForm(AOwner).OnKeyDown;
     TForm(AOwner).OnKeyDown := Self.OnFormKeyDown;
  end;
end;

destructor TEnterMoveNext.Destroy;
begin
  FreeAndNil(FEnterMoveNextList);

  if Owner is TForm then
  begin
     TForm(Owner).OnKeyDown := FOnFormKeyDown;
  end;

  inherited;
end;

procedure TEnterMoveNext.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
  begin
    if (AComponent is TControl) and Assigned(EnterMoveNextList) then
    begin
      for I := 0 to Pred(EnterMoveNextList.Count) do
      begin
        if EnterMoveNextList[I].Control = AComponent then
          EnterMoveNextList[I].Control := nil;
        if EnterMoveNextList[I].EnterAction = AComponent then
           EnterMoveNextList[I].EnterAction := nil;
        if EnterMoveNextList[I].ExitAction = AComponent then
           EnterMoveNextList[I].ExitAction := nil;
      end;
    end;
  end;
end;

procedure TEnterMoveNext.OnFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  var Control: TComponent; I, J : Integer; fFind : Boolean;
begin

  if Assigned(FOnFormKeyDown) then FOnFormKeyDown (Sender, Key, Shift);

  if (Key = VK_RETURN) AND ((Shift = []) or (Shift = [ssCtrl]))
  then
  Begin
    if Assigned(Screen.ActiveControl) then
    begin
      if Screen.ActiveControl is TcxCustomInnerTextEdit then Control := TcxCustomInnerTextEdit(Screen.ActiveControl).Owner
      else if Screen.ActiveControl is TcxCustomInnerTextEdit then Control := TcxCustomComboBoxInnerEdit(Screen.ActiveControl).Owner
      else if Screen.ActiveControl is TcxCustomInnerTextEdit then Control := TcxCustomDropDownInnerEdit(Screen.ActiveControl).Owner
      else if Screen.ActiveControl is TcxCustomInnerTextEdit then Control := TcxCustomInnerMemo(Screen.ActiveControl).Owner
      else Control := Screen.ActiveControl;
    end else Control := Nil;

    if Pos('Memo', Control.ClassName) > 0 then Exit;

    //еще выход, т.к. наш контрол не из списка
    fFind:=false;
    for I := 0 to Pred(EnterMoveNextList.Count) do
     if Assigned(EnterMoveNextList[I].Control) and (EnterMoveNextList[I].Control = Control)
    then
    begin
      if Assigned (EnterMoveNextList[I].ExitAction) then EnterMoveNextList[I].ExitAction.Execute;
      fFind:= true;
    end;
    // выход
    if not fFind then exit;


    try

      if Shift = [] then
      begin
        if Assigned(Control) then
        begin
          for I := 0 to Pred(EnterMoveNextList.Count) do
            if Assigned(EnterMoveNextList[I].Control) and (EnterMoveNextList[I].Control = Control) and (I < Pred(EnterMoveNextList.Count)) then
               for J := I + 1 to Pred(EnterMoveNextList.Count) do
                 if Assigned(EnterMoveNextList[J].Control) then
                 begin
                   TWinControl(EnterMoveNextList[J].Control).SetFocus;
                   if Assigned (EnterMoveNextList[J].EnterAction) then EnterMoveNextList[J].EnterAction.Execute;
                   Exit;
                 end;
        end;

        for I := 0 to Pred(EnterMoveNextList.Count) do
          if Assigned(EnterMoveNextList[I].Control) then
        begin
          TWinControl(EnterMoveNextList[I].Control).SetFocus;
          if Assigned (EnterMoveNextList[I].EnterAction) then EnterMoveNextList[I].EnterAction.Execute;
          Exit;
        end;
      end else
      begin

        if Assigned(Control) then
        begin
          for I := 0 to Pred(EnterMoveNextList.Count) do
            if Assigned(EnterMoveNextList[I].Control) and (EnterMoveNextList[I].Control = Control) and (I > 1) then
               for J := I - 1 downto 0 do
                 if Assigned(EnterMoveNextList[J].Control) then
                 begin
                   TWinControl(EnterMoveNextList[J].Control).SetFocus;
                   if Assigned (EnterMoveNextList[J].EnterAction) then EnterMoveNextList[J].EnterAction.Execute;
                   Exit;
                 end;
        end;

        for I := Pred(EnterMoveNextList.Count) downto 0 do
          if Assigned(EnterMoveNextList[I].Control) then
        begin
          TWinControl(EnterMoveNextList[I].Control).SetFocus;
          if Assigned (EnterMoveNextList[I].EnterAction) then EnterMoveNextList[I].EnterAction.Execute;
          Exit;
        end;
      end;

    finally
      Key := 0;
    end;
  End;

end;

{ TGeoMarker }

constructor TGeoMarker.Create(ALat, ALng: Real; ATitle: string; AInsertDate: TDateTime);
begin
  inherited Create;
  FData.Lat := ALat;
  FData.Lng := ALng;
  FData.Title := ATitle;
  FData.InsertDate := AInsertDate;
end;

function TGeoMarker.GetData: TGeoMarkerData;
begin
  Result := FData;
end;

{ TGeoMarkerList }

function TGeoMarkerList.GetGeoMarker(Index: Integer): TGeoMarker;
begin
  Result := inherited GetItem(Index) as TGeoMarker;
end;

procedure TGeoMarkerList.SetGeoMarker(Index: Integer; const Value: TGeoMarker);
begin
  inherited SetItem(Index, Value);
end;

{ TWinControlListItem }

procedure TWinControlListItem.Assign(Source: TPersistent);
begin
  if Source is TWinControlListItem then
     with TWinControlListItem(Source) do begin
       Self.Control := Control;
       Self.GotoControl := GotoControl;
       Self.StoredProc := StoredProc;
       Self.Action := Action;
     end
  else
    inherited Assign(Source);
end;

function TWinControlListItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FControl) then
     result := FControl.Name
end;

procedure TWinControlListItem.SetControl(const Value: TWinControl);
begin
  if FControl = Value then Exit;

  if Assigned(Value) then
  begin
    if not (Value is TcxTextEdit) and
       not (Value is TcxMaskEdit) and
       not (Value is TcxButtonEdit) and
       not (Value is TcxCurrencyEdit) and
       not (Value is TcxDateEdit) then
       raise Exception.Create(Value.ClassName + ' не поддерживаеться');
  end;

  if Assigned(FControl) and Assigned(FKeyDown) then
  begin
    if FControl is TcxTextEdit then
       (FControl as TcxTextEdit).OnKeyDown := FKeyDown
    else if FControl is TcxMaskEdit then
       (FControl as TcxMaskEdit).OnKeyDown := FKeyDown
    else if FControl is TcxButtonEdit then
       (FControl as TcxButtonEdit).OnKeyDown := FKeyDown
    else if FControl is TcxCurrencyEdit then
       (FControl as TcxCurrencyEdit).OnKeyDown := FKeyDown
    else if FControl is TcxDateEdit then
       (FControl as TcxDateEdit).OnKeyDown := FKeyDown;
  end;

  if Assigned(Value) then
  begin
    if Value is TcxTextEdit then
    begin
      FKeyDown := (Value as TcxTextEdit).OnKeyDown;
      (Value as TcxTextEdit).OnKeyDown := edKeyDown
    end
    else if Value is TcxMaskEdit then
    begin
      FKeyDown := (Value as TcxMaskEdit).OnKeyDown;
      (Value as TcxMaskEdit).OnKeyDown := edKeyDown
    end
    else if Value is TcxButtonEdit then
    begin
      FKeyDown := (Value as TcxButtonEdit).OnKeyDown;
      (Value as TcxButtonEdit).OnKeyDown := edKeyDown
    end
    else if Value is TcxCurrencyEdit then
    begin
      FKeyDown := (Value as TcxCurrencyEdit).OnKeyDown;
      (Value as TcxCurrencyEdit).OnKeyDown := edKeyDown
    end
    else if Value is TcxDateEdit then
    begin
      FKeyDown := (Value as TcxDateEdit).OnKeyDown;
      (Value as TcxDateEdit).OnKeyDown := edKeyDown
    end;
  end;

  FControl := Value;
end;

procedure TWinControlListItem.SetGotoControl(const Value: TWinControl);
begin
  FGotoControl := Value;
end;

procedure TWinControlListItem.edKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_RETURN) then
  begin
    Key := 0;
    try
      if Assigned(FStoredProc) then FStoredProc.Execute;
      if Assigned(FAction) then FAction.Execute;
    finally
      if Assigned(FGotoControl) then FGotoControl.SetFocus;
    end;
  end else if Assigned(FKeyDown) then FKeyDown(Sender, Key, Shift);
end;

{ TTabSheetListItem }

procedure TTabSheetListItem.Assign(Source: TPersistent);
begin
  if Source is TTabSheetListItem then
     with TTabSheetListItem(Source) do begin
       Self.Control := Control;
       Self.TabSheet := TabSheet;
     end
  else
    inherited Assign(Source);
end;

function TTabSheetListItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FTabSheet) then
     result := FTabSheet.Name
end;

procedure TTabSheetListItem.SetTabSheet(const Value: TcxTabSheet);
begin

end;

{ TEnterManager }

constructor TdsdEnterManager.Create(AOwner: TComponent);
begin
  inherited;
  ControlList := TOwnedCollection.Create(Self, TWinControlListItem);
  TabSheetList := TOwnedCollection.Create(Self, TTabSheetListItem);
end;

destructor TdsdEnterManager.Destroy;
begin
  FreeAndNil(FTabSheetList);
  FreeAndNil(FControlList);
  inherited;
end;

procedure TdsdEnterManager.SetPageControl(const Value: TcxPageControl);
begin
  if FPageControl = Value then Exit;

  if Assigned(FPageControl) and Assigned(FOnChange) then
  begin
    FPageControl.OnChange := FOnChange;
  end;

  if Assigned(Value) then
  begin
    FOnChange := Value.OnChange;
    Value.OnChange := PageControl1Change;
  end;

  FPageControl := Value;
end;

procedure TdsdEnterManager.PageControl1Change(Sender: TObject);
var i: integer;
begin
  if Assigned(FPageControl) then
    for i := 0 to TabSheetList.Count - 1 do
      if TTabSheetListItem(TabSheetList.Items[i]).TabSheet = FPageControl.ActivePage then
        if Assigned(TTabSheetListItem(TabSheetList.Items[i]).FControl) then
          TTabSheetListItem(TabSheetList.Items[i]).FControl.SetFocus;
end;

procedure TdsdEnterManager.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;

  if (Operation = opRemove) then
  begin
    if AComponent = FPageControl then PageControl := nil;
    if Assigned(ControlList) then
      for i := 0 to ControlList.Count - 1 do
      begin
         if TWinControlListItem(ControlList.Items[i]).Control = AComponent then
            TWinControlListItem(ControlList.Items[i]).Control := nil;
         if TWinControlListItem(ControlList.Items[i]).GotoControl = AComponent then
            TWinControlListItem(ControlList.Items[i]).GotoControl := nil;
         if TWinControlListItem(ControlList.Items[i]).Action = AComponent then
            TWinControlListItem(ControlList.Items[i]).Action := nil;
      end;
    if Assigned(TabSheetList) then
      for i := 0 to TabSheetList.Count - 1 do
      begin
         if TTabSheetListItem(TabSheetList.Items[i]).Control = AComponent then
            TTabSheetListItem(TabSheetList.Items[i]).Control := nil;
         if TTabSheetListItem(TabSheetList.Items[i]).TabSheet = AComponent then
            TTabSheetListItem(TabSheetList.Items[i]).TabSheet := nil;
      end;
  end;
end;

  { TdsdFileToBase64 }

constructor TdsdFileToBase64.Create(AOwner: TComponent);
begin
  inherited;
  FFileOpenDialog := TFileOpenDialog.Create(Self);
  FFileOpenDialog.SetSubComponent(true);
  FFileOpenDialog.FreeNotification(Self);
end;

destructor TdsdFileToBase64.Destroy;
begin
  FreeAndNil(FFileOpenDialog);
  inherited;
end;

procedure TdsdFileToBase64.SetLookupControl(const Value: TWinControl);
begin
  FLookupControl := Value;
  if not Assigned(FLookupControl) then
     exit;
  TAccessControl(FLookupControl).OnDblClick := OnDblClick;
  if FLookupControl is TcxButtonEdit then
     (LookupControl as TcxButtonEdit).Properties.OnButtonClick := OnButtonClick;
  if FLookupControl is TcxDBButtonEdit then
     (LookupControl as TcxDBButtonEdit).Properties.OnButtonClick := OnButtonClick;
end;

procedure TdsdFileToBase64.OnDblClick(Sender: TObject);
begin
  OpenFile;
end;

procedure TdsdFileToBase64.OnButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  if Sender is TcxButtonEdit then
     if not Assigned(TcxButtonEdit(Sender).Properties.Buttons[AButtonIndex].Action) then
        OnDblClick(Sender);
  if Sender is TcxDBButtonEdit then
     if not Assigned(TcxDBButtonEdit(Sender).Properties.Buttons[AButtonIndex].Action) then
        OnDblClick(Sender);
end;

procedure TdsdFileToBase64.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) then begin
      if (AComponent = FLookupControl) then
         FLookupControl := nil;
  end;
end;

procedure TdsdFileToBase64.OpenFile;
  var
      fileStream: TFileStream;
      base64Stream: TStringStream;
begin
  if FFileOpenDialog.Execute then
  begin
    fileStream := TFileStream.Create(FFileOpenDialog.FileName, fmOpenRead);
    base64Stream := TStringStream.Create;
    try
      EncodeStream(fileStream, base64Stream);

      if Assigned(LookupControl) then begin
         if LookupControl is TcxButtonEdit then
            (LookupControl as TcxButtonEdit).Text := base64Stream.DataString;
         if LookupControl is TcxDBButtonEdit then
            (LookupControl as TcxDBButtonEdit).Text := base64Stream.DataString;
      end;

    finally
      FreeAndNil(fileStream);
      FreeAndNil(base64Stream);
    end;
  end;
end;

  { TColumnFieldFilterItem }

constructor TColumnFieldFilterItem.Create(Collection: TCollection);
begin
  inherited;
  FTimer := TTimer.Create(TdsdFieldFilter(Collection.Owner));
  FTimer.Enabled:=False;
  FTimer.OnTimer := TimerTimer;
  FProgressBar := TProgressBar.Create(TdsdFieldFilter(Collection.Owner));
  FProgressBar.Visible:=False;
  FProgressBar.Height := 9;
  FProgressBar.Width := 57;
  FProgressBar.Anchors := [akTop, akRight];
  FOldStr := '';
  FOnEditChange := Nil;
  FOnEditExit := Nil;
  FOnKeyDown := Nil;
  FColumn := Nil;
end;

destructor TColumnFieldFilterItem.Destroy;
begin
  FreeAndNil(FTimer);
  inherited;
end;

procedure TColumnFieldFilterItem.SetTextEdit(const Value: TcxTextEdit);
begin
  if Assigned(FTextEdit) then
  begin
    FTextEdit.Properties.OnChange := FOnEditChange;
    FTextEdit.OnExit := FOnEditExit;
    FTextEdit.OnKeyDown := FOnKeyDown;
    FOnEditChange := Nil;
    FOnEditExit := Nil;
    FOnKeyDown := Nil;
    FProgressBar.Parent := Nil;
  end;
  FTextEdit := Value;
  if Assigned(FTextEdit) then
  begin
    FOnEditChange := FTextEdit.Properties.OnChange;
    FOnEditExit := FTextEdit.OnExit;
    FOnKeyDown := FTextEdit.OnKeyDown;
    FTextEdit.Properties.OnChange := OnEditChange;
    FTextEdit.OnExit := OnEditExit;
    FTextEdit.OnKeyDown := OnKeyDown;
    FProgressBar.Parent := FTextEdit;
    FProgressBar.Top := FTextEdit.Height - FProgressBar.Height - 4;
    FProgressBar.Left := FTextEdit.Width - FProgressBar.Width - 4;
  end;
end;

procedure TColumnFieldFilterItem.OnEditChange(Sender: TObject);
begin
  if not Assigned(TdsdFieldFilter(Collection.Owner).FDataSet) then Exit;
  if not Assigned(TdsdFieldFilter(Collection.Owner).Column) then Exit;
  if Sender is TcxTextEdit then
  begin
    if Trim(TcxTextEdit(Sender).Text)=FOldStr then exit;
    FOldStr:=Trim(TcxTextEdit(Sender).Text);
    FTimer.Enabled:=False;
    FTimer.Interval:=100;
    FTimer.Enabled:=True;
    FProgressBar.Position:=0;
    FProgressBar.Visible:=True;
  end;
end;

procedure TColumnFieldFilterItem.OnEditExit(Sender: TObject);
  var B: TBookMark;
begin
  FTimer.Enabled:=False;
  FProgressBar.Position:=0;
  FProgressBar.Visible:=False;
  TdsdFieldFilter(Collection.Owner).OnEditExit(Sender);
end;

procedure TColumnFieldFilterItem.OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  TdsdFieldFilter(Collection.Owner).OnKeyDown(Sender, Key, Shift);
end;

procedure TColumnFieldFilterItem.TimerTimer(Sender: TObject);
begin
  FProgressBar.Position := FProgressBar.Position + 10;
  if FProgressBar.Position = 100 then OnEditExit(Sender);
end;

  { TCheckBoxItem }

procedure TCheckBoxItem.Assign(Source: TPersistent);
begin
  if Source is TCheckBoxItem then
    with TCheckBoxItem(Source) do
    begin
      Self.Value := Value;
      Self.CheckBox := CheckBox;
    end
  else
    inherited Assign(Source);
end;

constructor TCheckBoxItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FValues := '';
  FOnCheckChange := Nil;
end;

destructor TCheckBoxItem.Destroy;
begin
  inherited;
end;

procedure TCheckBoxItem.SetCheckBox(const Value: TcxCheckBox);
begin
   if Assigned(FCheckBox) then
  begin
    FCheckBox.Properties.OnChange := FOnCheckChange;
  end;
  FCheckBox := Value;
  if Assigned(FCheckBox) then
  begin
    FOnCheckChange := FCheckBox.Properties.OnChange;
    if Collection.Owner is TdsdFieldFilter then
      FCheckBox.Properties.OnChange := TdsdFieldFilter(Collection.Owner).OnCheckChange;
  end;
end;

  { TdsdFieldFilter }

constructor TdsdFieldFilter.Create(AOwner: TComponent);
begin
  inherited;
  FTimer := TTimer.Create(Self);
  FCheckBoxList := TOwnedCollection.Create(Self, TCheckBoxItem);
  FColumnList := TOwnedCollection.Create(Self, TColumnFieldFilterItem);
  FTimer.Enabled:=False;
  FTimer.OnTimer := TimerTimer;
  FProgressBar := TProgressBar.Create(Self);
  FProgressBar.Visible:=False;
  FProgressBar.Height := 9;
  FProgressBar.Width := 57;
  FProgressBar.Anchors := [akTop, akRight];
  FOldStr := '';
  FOnEditChange := Nil;
  FOnEditExit := Nil;
  FOnKeyDown := Nil;
  FFilterRecord := Nil;
  FColumn := Nil;
  FFiltered := False;
end;

destructor TdsdFieldFilter.Destroy;
begin
  FreeAndNil(FColumnList);
  FreeAndNil(FCheckBoxList);
  FreeAndNil(FTimer);
  inherited;
end;

function TdsdFieldFilter.GetColumn: TcxGridColumn;
begin
  if FColumnList.Count > 0 then
     result := TColumnFieldFilterItem(FColumnList.Items[0]).Column
  else
     result := FColumn
end;

procedure TdsdFieldFilter.SetColumn(const Value: TcxGridColumn);
begin
  if (Value is TcxGridDBBandedColumn) or (Value is TcxGridDBColumn) then
  begin
    // Если устанавливается или
    if Value <> nil then
    begin
       if FColumnList.Count > 0 then
          TColumnFieldFilterItem(FColumnList.Items[0]).Column := Value
       else
          TColumnFieldFilterItem(FColumnList.Add).Column := Value;
    end
    else begin
      //если ставится в NIL
      if FColumnList.Count > 0 then
         FColumnList.Delete(0);
    end;
  end else raise Exception.Create(Value.ClassName + ' не поддерживаеться');
end;

procedure TdsdFieldFilter.Notification(AComponent: TComponent;
  Operation: TOperation);
  var I : Integer;
begin
  inherited;

  if (Operation = opRemove) then
  begin
      if (AComponent = FTextEdit) then
         FTextEdit := nil;
      if (AComponent = FDataSet) then
         FDataSet := nil;
      if (AComponent = FActionNumber1) then
         FActionNumber1 := nil;
      if (AComponent is TcxGridColumn) and Assigned(ColumnList) then
      begin
         for i := 0 to ColumnList.Count - 1 do
            if TColumnFieldFilterItem(ColumnList.Items[i]).Column = AComponent then
               TColumnFieldFilterItem(ColumnList.Items[i]).Column := nil;
      end;
  end;
end;

procedure TdsdFieldFilter.SetTextEdit(const Value: TcxTextEdit);
begin
  if Assigned(FTextEdit) then
  begin
    FTextEdit.Properties.OnChange := FOnEditChange;
    FTextEdit.OnExit := FOnEditExit;
    FTextEdit.OnKeyDown := FOnKeyDown;
    FOnEditChange := Nil;
    FOnEditExit := Nil;
    FOnKeyDown := Nil;
    FProgressBar.Parent := Nil;
  end;
  FTextEdit := Value;
  if Assigned(FTextEdit) then
  begin
    FOnEditChange := FTextEdit.Properties.OnChange;
    FOnEditExit := FTextEdit.OnExit;
    FOnKeyDown := FTextEdit.OnKeyDown;
    FTextEdit.Properties.OnChange := OnEditChange;
    FTextEdit.OnExit := OnEditExit;
    FTextEdit.OnKeyDown := OnKeyDown;
    FProgressBar.Parent := FTextEdit;
    FProgressBar.Top := FTextEdit.Height - FProgressBar.Height - 4;
    FProgressBar.Left := FTextEdit.Width - FProgressBar.Width - 4;
  end;
end;

procedure TdsdFieldFilter.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
  if Assigned(Value) then
  begin
    FFilterRecord := FDataSet.OnFilterRecord;
    FFiltered := FDataSet.Filtered;
  end else
  begin
    FFilterRecord := Nil;
    FFiltered := False;
  end;
end;

procedure TdsdFieldFilter.OnEditChange(Sender: TObject);
begin
  if not Assigned(FDataSet) then Exit;
  if not Assigned(Column) and not Assigned(FCheckColumn) then Exit;
  if Sender is TcxTextEdit then
  begin
    if Trim(TcxTextEdit(Sender).Text)=FOldStr then exit;
    FOldStr:=Trim(TcxTextEdit(Sender).Text);
    FTimer.Enabled:=False;
    FTimer.Interval:=100;
    FTimer.Enabled:=True;
    FProgressBar.Position:=0;
    FProgressBar.Visible:=True;
  end;
end;

function TdsdFieldFilter.CheckSelected : Boolean;
  var Item : TCollectionItem;
begin
  Result := False;
  for Item in FCheckBoxList do if Assigned(TCheckBoxItem(Item).FCheckBox) then
  if not TCheckBoxItem(Item).FCheckBox.Checked then Exit;
  Result := True;
end;

procedure TdsdFieldFilter.OnEditExit(Sender: TObject);
  var B: TBookMark; Item : TCollectionItem; bDo : Boolean;
begin
  FTimer.Enabled:=False;
  FProgressBar.Position:=0;
  FProgressBar.Visible:=False;
  if not Assigned(FDataSet) then Exit;
  if not FDataSet.Active then Exit;
  if not Assigned(Column) and not Assigned(FCheckColumn) then Exit;
  FDataSet.DisableControls;
  B := FDataSet.GetBookmark;
  try
    FDataSet.OnFilterRecord := FFilterRecord;
    FDataSet.Filtered := FFiltered;

    bDo := False;
    for Item in FColumnList do if TColumnFieldFilterItem(Item).FOldStr <> '' then
    begin
      bDo := True;
      Break;
    end;

    if bDo or (FOldStr <> '') or not CheckSelected then
    begin
      FDataSet.Filtered:=False;
      FDataSet.OnFilterRecord:=FilterRecord;
      FDataSet.Filtered:=True;
    end;
    FDataSet.First;

    if Assigned(B) then
    begin
       try
         if FDataSet.BookmarkValid(B) then
           FDataSet.GotoBookmark(B);
       except
       end;
       FDataSet.FreeBookmark(B);
    end;

  finally
    FDataSet.EnableControls
  end;
end;

procedure TdsdFieldFilter.OnCheckChange(Sender: TObject);
begin
  OnEditExit(Sender);
end;

procedure TdsdFieldFilter.OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  function SetFocused(Control: TWinControl; Form : TForm): Boolean;
  begin
    if (Control.Parent <> Nil) and (Control.Parent <> Form) then SetFocused(Control.Parent, Form);
    if Control.Parent is TcxPageControl then
    begin
      TcxPageControl(Control.Parent).ActivePage := TcxTabSheet(Control);
    end else if (Control.TabStop or (Control is TcxGrid)) and not (Control is TcxPageControl) then Control.SetFocus;
  end;

begin
  if (Key = VK_RETURN) and (Shift = []) then
  begin
    OnEditExit(Sender);

    // Если под фильтром 1 запись
    if Assigned(FActionNumber1) and (FDataSet.RecordCount = 1) and FActionNumber1.Enabled and FActionNumber1.Visible then
    begin
      FActionNumber1.Execute;
      Key := 0;
    end else if Assigned(Column) then // Если если больше то перейдем на грид
    begin
      SetFocused(TWinControl(Column.GridView.Control), TForm(Owner));
    end;
  end;
end;

procedure TdsdFieldFilter.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  Var S,S1,Name:String; k,i:integer; F:Boolean;
      Item : TCollectionItem;
begin
  if Assigned(FFilterRecord) then
  begin
    FFilterRecord(DataSet, Accept);
    if not Accept then Exit;
  end;

  if not FDataSet.Active then Exit;

  if not CheckSelected and Assigned(FCheckColumn) then
  begin
    if FCheckColumn is TcxGridDBBandedColumn then Name:= TcxGridDBBandedColumn(FCheckColumn).DataBinding.FieldName
    else if FCheckColumn is TcxGridDBColumn then Name:= TcxGridDBColumn(FCheckColumn).DataBinding.FieldName
    else Name := '';

    if Name <> '' then
      for Item in FCheckBoxList do if Assigned(TCheckBoxItem(Item).FCheckBox) then
        if not TCheckBoxItem(Item).CheckBox.Checked and (AnsiUpperCase(DataSet.FieldByName(Name).AsString) = AnsiUpperCase(TCheckBoxItem(Item).Value)) then
    begin
      Accept := False;
      Exit;
    end;
  end;

  for I := 0 to  FColumnList.Count - 1 do if Assigned(FColumnList.Items[I]) then

  begin

    if Assigned(TColumnFieldFilterItem(FColumnList.Items[I]).FTextEdit) then
    begin
      S1 := Trim(TColumnFieldFilterItem(FColumnList.Items[I]).FOldStr);
    end else S1 := Trim(FOldStr);

    if Trim(S1) = '' then Continue;
    Accept:=true;

    if TColumnFieldFilterItem(FColumnList.Items[I]).Column is TcxGridDBBandedColumn then
      Name:= TcxGridDBBandedColumn(TColumnFieldFilterItem(FColumnList.Items[I]).Column).DataBinding.FieldName
    else if TColumnFieldFilterItem(FColumnList.Items[I]).Column is TcxGridDBColumn then
      Name:= TcxGridDBColumn(TColumnFieldFilterItem(FColumnList.Items[I]).Column).DataBinding.FieldName
    else Continue;

    repeat
      k:=pos(' ',S1);
      if K = 0 then k:=length(S1)+1;
      s := Trim(copy(S1,1,k-1));
      S1 := Trim(copy(S1,k,Length(S1)));

      F := Pos(AnsiUpperCase(s), AnsiUpperCase(DataSet.FieldByName(Name).AsString)) > 0;

      Accept:=Accept AND F;
    until (S1='') or (Accept = False);

    if Accept then Break;

  end;
end;

procedure TdsdFieldFilter.TimerTimer(Sender: TObject);
begin
  FProgressBar.Position := FProgressBar.Position + 10;
  if FProgressBar.Position = 100 then OnEditExit(Sender);
end;

{ TPropertiesCell }

procedure TPropertiesCell.Assign(Source: TPersistent);
begin
  if Source is TColorRule then
    with TColorRule(Source) do
    begin
      Self.Column := ColorColumn;
      Self.ValueColumn := ValueColumn;
      Self.EditRepository := EditRepository;
    end
  else
    inherited Assign(Source);
end;

constructor TPropertiesCell.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FOnGetProperties := Nil;
end;

destructor TPropertiesCell.Destroy;
begin
  inherited;
end;

procedure TPropertiesCell.SetColumn(const Value: TcxGridColumn);
begin
  if Assigned(FColumn) then
  begin
    FColumn.OnGetProperties := FOnGetProperties;
  end;
  FColumn := Value;
  FOnGetProperties := FColumn.OnGetProperties;
  FColumn.OnGetProperties := GetProperties;
end;

procedure TPropertiesCell.GetProperties(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
                                    var AProperties: TcxCustomEditProperties);
  var I : Integer;
begin
  if Assigned(FOnGetProperties) then FOnGetProperties(Sender, ARecord, AProperties);

  if not Assigned(FValueColumn) then Exit;
  if not Assigned(FEditRepository) then Exit;

  if not TryStrToInt(ARecord.Values[FValueColumn.Index], I) then Exit;

  if (I > 0) and (I <= FEditRepository.Count) then
    AProperties := FEditRepository.Items[I - 1].Properties
end;

{ TShowFieldImage }

procedure TShowFieldImage.Assign(Source: TPersistent);
begin
  if Source is TShowFieldImage then
    with TShowFieldImage(Source) do
    begin
      Self.FFieldName := FFieldName;
    end
  else
    inherited Assign(Source);
end;

constructor TShowFieldImage.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFieldName := '';
  FImage := Nil;
end;

destructor TShowFieldImage.Destroy;
begin
  inherited;
end;

{ TViewDocumentParam }

procedure TViewDocumentParam.Assign(Source: TPersistent);
begin
  if Source is TViewDocumentParam then
    with TViewDocumentParam(Source) do
    begin
      Self.FPDFScaleMode := PDFScaleMode;
      Self.FPDFZoomPercentage := PDFZoomPercentage;
    end
  else
    inherited Assign(Source);
end;


{ TViewDocument }

procedure TViewDocument.Assign(Source: TPersistent);
begin
  if Source is TShowFieldImage then
    with TViewDocument(Source) do
    begin
      Self.FFieldName := FieldName;
      Self.FControl := Control;
    end
  else
    inherited Assign(Source);
end;

constructor TViewDocument.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFieldName := '';
  FControl := Nil;
  FPdfCtrl := Nil;
  FImage := Nil;
  FisFocused := False;
end;

destructor TViewDocument.Destroy;
begin
  inherited;
end;

procedure TViewDocument.ShowPDF(AMemoryStream: TMemoryStream);
  var Rect1, Rect2 : TRect;
begin
  if not Assigned(FControl) then Exit;
  try
    FPdfCtrl := TPdfControl.Create(FControl.Owner);
    FPdfCtrl.Parent := FControl;
    FPdfCtrl.Align := alClient;
    FPdfCtrl.SendToBack;
    FPdfCtrl.Color := clGray;
    FPdfCtrl.ChangePageOnMouseScrolling := True;
    FPdfCtrl.AllowUserTextSelection := False;
    FPdfCtrl.SmoothScroll := True;

    FBarManager := TdxBarManager.Create(FControl);
    FBarManager.NotDocking := [dsNone, dsLeft, dsTop, dsRight, dsBottom];
    FBarManagerBar := FBarManager.AddToolBar;

    FBarButtonPrev := TdxBarButton(FBarManager.AddItem(TdxBarButton));
    FBarButtonPrev.Caption := '  <  ';
    FBarButtonPrev.OnClick := OnPrevClick;
    FBarManagerBar.ItemLinks.Add(FBarButtonPrev);

    FBarStatic := TdxBarStatic(FBarManager.AddItem(TdxBarStatic));
    FBarManagerBar.ItemLinks.Add(FBarStatic);

    FBarButtonNext := TdxBarButton(FBarManager.AddItem(TdxBarButton));
    FBarButtonNext.Caption := '  >  ';
    FBarButtonNext.OnClick := OnNextClick;
    FBarManagerBar.ItemLinks.Add(FBarButtonNext);

    FBarManagerBar.ItemLinks.Add(FBarManager.AddItem(TdxBarStatic));

    FBarButtonPrint := TdxBarButton(FBarManager.AddItem(TdxBarButton));;
    FBarButtonPrint.Caption := ' Печать ';
    FBarButtonPrint.OnClick := OnPrintDocumentClick;
    FBarManagerBar.ItemLinks.Add(FBarButtonPrint);

    FBarManagerBar.ItemLinks.Add(FBarManager.AddItem(TdxBarStatic));

    FBarRadioGroup := TcxBarEditItem(FBarManager.AddItem(TcxBarEditItem));
    FBarRadioGroup.PropertiesClass := TcxRadioGroupProperties;
    TcxRadioGroupProperties(FBarRadioGroup.Properties).Columns := 3;
    with TcxRadioGroupProperties(FBarRadioGroup.Properties).Items.Add do
    begin
      Caption := 'По ширине ';
      Value := 1;
    end;
    with TcxRadioGroupProperties(FBarRadioGroup.Properties).Items.Add do
    begin
      Caption := 'По высоте ';
      Value := 2;
    end;
    with TcxRadioGroupProperties(FBarRadioGroup.Properties).Items.Add do
    begin
      Caption := 'Масштаб ';
      Value := 3;
    end;
    TcxRadioGroupProperties(FBarRadioGroup.Properties).OnChange := OnScaleChange;
    if TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFScaleMode > smFitAuto then
      FBarRadioGroup.EditValue := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFScaleMode;
    FBarManagerBar.ItemLinks.Add(FBarRadioGroup);

    FBarManagerBar.ItemLinks.Add(FBarManager.AddItem(TdxBarStatic));

    FBarSpinEdit := TcxBarEditItem(FBarManager.AddItem(TcxBarEditItem));
    FBarSpinEdit.PropertiesClass := TcxSpinEditProperties;
    FBarSpinEdit.Caption := 'Масштаб: ';
    TcxSpinEditProperties(FBarSpinEdit.Properties).MaxValue := 10000;
    TcxSpinEditProperties(FBarSpinEdit.Properties).MinValue := 1;
    TcxSpinEditProperties(FBarSpinEdit.Properties).Increment := 5;
    TcxSpinEditProperties(FBarSpinEdit.Properties).ValueType := vtInt;
    FBarSpinEdit.Width := 70;
    FBarSpinEdit.ShowCaption := True;
    TcxSpinEditProperties(FBarSpinEdit.Properties).OnChange := OnZoomChange;
    FBarSpinEdit.Enabled := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFScaleMode = smZoom;
    FBarSpinEdit.EditValue := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFZoomPercentage;
    FBarManagerBar.ItemLinks.Add(FBarSpinEdit);

    FPdfCtrl.OnPageChange := OnPageChange;
    FPdfCtrl.OnPaint := OnPaint;

    FPdfCtrl.LoadFromStream(AMemoryStream);

    if TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFScaleMode = smFitAuto then
    begin
      Rect1 := FPdfCtrl.GetPageRect;
      Rect2 := FPdfCtrl.ClientRect;
      if ((Rect2.Right - Rect2.Left) = 0) OR ((Rect2.Bottom - Rect2.Top) = 0) then
        FPdfCtrl.ScaleMode := smFitAuto
      else if ((Rect1.Right - Rect1.Left) / (Rect2.Right - Rect2.Left)) >
              ((Rect1.Bottom - Rect1.Top) / (Rect2.Bottom - Rect2.Top)) then
      begin
        FPdfCtrl.ScaleMode := smFitWidth;
        FBarRadioGroup.EditValue := 1;
      end
      else
      begin
        FPdfCtrl.ScaleMode := smFitHeight;
        FBarRadioGroup.EditValue := 2;
      end;

      TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFScaleMode := FPdfCtrl.ScaleMode;
    end else
    begin
      FPdfCtrl.ScaleMode := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFScaleMode;
      FBarRadioGroup.EditValue := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFScaleMode;

      FBarSpinEdit.Enabled := FPdfCtrl.ScaleMode = smZoom;
      if FBarSpinEdit.Enabled then FPdfCtrl.ZoomPercentage := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFZoomPercentage;
    end;

    if FisFocused then TForm(FControl.Owner).ActiveControl := FPdfCtrl;
  except
    Clear;
  end;
end;

procedure TViewDocument.ShowGraphic(AGraphicClass: TGraphicClass; AMemoryStream: TMemoryStream);
  var Graphic: TGraphic;
begin
  if not Assigned(FControl) then Exit;
  try
    FImage := TcxImage.Create(FControl.Owner);
    FImage.Parent := FControl;
    FImage.Align := alClient;
    FImage.SendToBack;
    FImage.Properties.ReadOnly := True;

    Graphic := TGraphicClass(AGraphicClass).Create;
    try
      Graphic.LoadFromStream(AMemoryStream);
      FImage.Picture.Graphic := Graphic;
    finally
      Graphic.Free;
    end;
  except
    Clear;
  end;
end;

procedure TViewDocument.Clear;
begin
  if Assigned(FPdfCtrl) then FreeAndNil(FPdfCtrl);
  if Assigned(FImage) then FreeAndNil(FImage);
  if Assigned(FBarManager) then FreeAndNil(FBarManager);
end;

procedure TViewDocument.OnPrevClick(Sender: TObject);
begin
  if not Assigned(FPdfCtrl) then Exit;
  FPdfCtrl.GotoPrevPage;
end;

procedure TViewDocument.OnNextClick(Sender: TObject);
begin
  if not Assigned(FPdfCtrl) then Exit;
  FPdfCtrl.GotoNextPage;
end;

procedure TViewDocument.OnPrintDocumentClick(Sender: TObject);
begin
  if not Assigned(FPdfCtrl) then Exit;
  if not Assigned(FBarManager) then Exit;
  TPdfDocumentVclPrinter.PrintDocument(FPdfCtrl.Document, ExtractFileName(FPdfCtrl.Document.FileName));
end;

procedure TViewDocument.OnPageChange(Sender: TObject);
begin
  if not Assigned(FPdfCtrl) then Exit;
  if not Assigned(FBarManager) then Exit;
  FBarStatic.Caption := IntToStr(FPdfCtrl.PageIndex + 1) + ' из ' + IntToStr(FPdfCtrl.PageCount);
  FBarButtonPrev.Enabled := (FPdfCtrl.PageCount > 1) and (FPdfCtrl.PageIndex > 0);
  FBarButtonNext.Enabled := (FPdfCtrl.PageCount > 1) and (FPdfCtrl.PageIndex < (FPdfCtrl.PageCount - 1));
end;

procedure TViewDocument.OnScaleChange(Sender: TObject);
begin
  if not Assigned(FPdfCtrl) then Exit;
  if not Assigned(FBarManager) then Exit;

  case FBarRadioGroup.CurEditValue of
    1 : FPdfCtrl.ScaleMode := smFitWidth;
    2 : FPdfCtrl.ScaleMode := smFitHeight;
    3 : FPdfCtrl.ScaleMode := smZoom;
  end;
  FBarRadioGroup.EditValue := FBarRadioGroup.CurEditValue;
  TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFScaleMode := FPdfCtrl.ScaleMode;

  FBarSpinEdit.Enabled := FPdfCtrl.ScaleMode = smZoom;
  if FBarSpinEdit.Enabled then
  begin
    FBarSpinEdit.EditValue := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFZoomPercentage;
    FPdfCtrl.ZoomPercentage := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFZoomPercentage;
  end;

  TForm(FControl.Owner).ActiveControl := FPdfCtrl;
end;

procedure TViewDocument.OnPaint(Sender: TObject);
begin
  if not Assigned(FPdfCtrl) then Exit;
  if not Assigned(FBarManager) then Exit;

  TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFZoomPercentage := FPdfCtrl.ZoomPercentage;
  FBarSpinEdit.EditValue := FPdfCtrl.ZoomPercentage;
end;

procedure TViewDocument.OnZoomChange(Sender: TObject);
begin
  if not Assigned(FPdfCtrl) then Exit;
  if not Assigned(FBarManager) then Exit;

  if FPdfCtrl.ScaleMode = smZoom then
  begin
    TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFZoomPercentage := FBarSpinEdit.CurEditValue;
    FPdfCtrl.ZoomPercentage := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFZoomPercentage;
    FBarSpinEdit.EditValue := TdsdDBViewAddOn(Collection.Owner).ViewDocumentParam.PDFZoomPercentage;
  end;
end;

{ TdsdPropertiesСhange }

procedure TdsdPropertiesСhange.Assign(Source: TPersistent);
begin
  if Source is TdsdPropertiesСhange then
    with TdsdPropertiesСhange(Source) do
    begin
      Self.Component := Component;
      Self.EditRepository := EditRepository;
    end
  else
    inherited Assign(Source);
end;

constructor TdsdPropertiesСhange.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIndexProperties := 1;
end;

destructor TdsdPropertiesСhange.Destroy;
begin
  inherited;
end;

procedure TdsdPropertiesСhange.SetComponent(const Value: TComponent);
begin
  if not Assigned(Value) or (Value is TcxCurrencyEdit) or (Value is TcxTextEdit) then
  begin
    FComponent := Value;
  end else raise Exception.Create(Value.ClassName + ' не поддерживается');
end;

procedure TdsdPropertiesСhange.SetIndexProperties(const Value: Integer);
begin
  if not Assigned(FEditRepository) then Exit;
  if (Value < 1) or (Value > FEditRepository.Count) then Exit;
  FIndexProperties := Value;

  if (FComponent is TcxCurrencyEdit) then
  begin
    if FEditRepository.Items[FIndexProperties - 1].Properties is TcxCurrencyEditProperties  then
      (FComponent as TcxCurrencyEdit).Properties.Assign(FEditRepository.Items[FIndexProperties - 1].Properties);
  end else if (FComponent is TcxTextEdit) then
  begin
    if FEditRepository.Items[FIndexProperties - 1].Properties is TcxTextEditProperties  then
      (FComponent as TcxTextEdit).Properties.Assign(FEditRepository.Items[FIndexProperties - 1].Properties);
  end;
end;


{ TTemplateColumn }

constructor TTemplateColumn.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FIsCrossParam := TdsdParam.Create;
  FIsCrossParam.DataType := ftBoolean;
  FIsCrossParam.Value := True;
end;

destructor TTemplateColumn.Destroy;
begin
  FreeAndNil(FIsCrossParam);
  inherited;
end;


procedure TTemplateColumn.Assign(Source: TPersistent);
begin
  if Source is TTemplateColumn then
    with TTemplateColumn(Source) do
    begin
      Self.TemplateColumn := TemplateColumn;
      Self.HeaderColumnName := HeaderColumnName;
    end
  else
    inherited Assign(Source);
end;

function TTemplateColumn.GetDisplayName: string;
begin
  if Assigned(TemplateColumn) or (HeaderColumnName <> '') then
  begin
    Result := '?';
    if TemplateColumn is TcxGridDBBandedColumn then
      Result := TcxGridDBBandedColumn(TemplateColumn).Name;
    if TemplateColumn is TcxGridDBColumn then
      Result := TcxGridDBColumn(TemplateColumn).Name;
    Result := Result + ' - ' + HeaderColumnName
  end
  else
    Result := inherited GetDisplayName;
end;

{ TMultiplyColumn }

procedure TMultiplyColumn.Assign(Source: TPersistent);
begin
  if Source is TMultiplyColumn then
    with TMultiplyColumn(Source) do
    begin
      Self.Column := Column;
      Self.FieldName := FieldName;
      Self.HeaderFieldName := HeaderFieldName;
    end
  else
    inherited Assign(Source);
end;

function TMultiplyColumn.GetDisplayName: string;
begin
  if Assigned(Column) or (FieldName <> '') or (HeaderFieldName <> '') then
  begin
    Result := '?';
    if Column is TcxGridDBBandedColumn then
      Result := TcxGridDBBandedColumn(Column).Name;
    if Column is TcxGridDBColumn then
      Result := TcxGridDBColumn(Column).Name;
    Result := Result + ' - ' + FieldName;
    Result := Result + ' - ' + HeaderFieldName;
  end
  else
    Result := inherited GetDisplayName;
end;

{ TChart }

constructor TChart.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FChartCDS := TClientDataSet.Create(Nil);
  FChartDS := TDataSource.Create(Nil);
  FChartDS.DataSet := FChartCDS;
  FDisplayedDataName := '';
  FisShowTitle := True;
end;

destructor TChart.Destroy;
begin
  FreeAndNil(FChartDS);
  FreeAndNil(FChartCDS);
  inherited;
end;

procedure TChart.Assign(Source: TPersistent);
begin
  if Source is TChart then
    with TChart(Source) do
    begin
      Self.ChartView := ChartView;
      Self.ChartDataSet := ChartDataSet;
      Self.DataGroupsFielddName := DataGroupsFielddName;
      Self.HeaderName := HeaderName;
      Self.HeaderFieldName := HeaderFieldName;
      Self.DisplayedDataComboBox := DisplayedDataComboBox;
    end
  else
    inherited Assign(Source);
end;

function TChart.GetDisplayName: string;
begin
  if (DataGroupsFielddName <> '') then
  begin
    Result := DataGroupsFielddName;
  end
  else
    Result := inherited GetDisplayName;
end;

procedure TChart.SetDisplayedDataComboBox(Value : TcxComboBox);
begin
  if Assigned(DisplayedDataComboBox) then DisplayedDataComboBox.Properties.OnChange := FOnChange;

  FDisplayedDataComboBox := Value;
  if Assigned(DisplayedDataComboBox) then
  begin
    FOnChange := FDisplayedDataComboBox.Properties.OnChange;
    FDisplayedDataComboBox.Properties.OnChange := OnChangeDisplayedData;
  end;

end;

procedure TChart.OnChangeDisplayedData(Sender: TObject);
begin
   if Assigned(DisplayedDataComboBox) then
   begin
     if DisplayedDataComboBox.ItemIndex >= 0 then
     begin
       FDisplayedDataName := DisplayedDataComboBox.Properties.Items.Strings[DisplayedDataComboBox.ItemIndex];
       try
         DisplayedDataComboBox.Properties.OnChange := Nil;
         if Collection.Owner is TCrossDBViewReportAddOn then
           TCrossDBViewReportAddOn(Collection.Owner).onAfterOpen(TCrossDBViewReportAddOn(Collection.Owner).FDataSet);
       finally
         FDisplayedDataComboBox.Properties.OnChange := OnChangeDisplayedData;
       end;
     end;
     TCrossDBViewReportAddOn(Collection.Owner).View.Control.SetFocus;
   end;
end;

{ TCrossDBViewReportAddOn }

constructor TCrossDBViewReportAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FCreateColumnList := TList.Create;
  FCreateColorRuleList := TList.Create;
  FCreateBаndList := TList.Create;
  FCreateTemplateColumn := TList.Create;
  FTemplateColumnList := TCollection.Create(TTemplateColumn);
  FMultiplyColumnList := TCollection.Create(TMultiplyColumn);
  FChartList := TOwnedCollection.Create(Self, TChart);
  isExpand := False;
end;

destructor TCrossDBViewReportAddOn.Destroy;
begin
  FreeAndNil(FChartList);
  FreeAndNil(FMultiplyColumnList);
  FreeAndNil(FTemplateColumnList);
  FreeAndNil(FCreateTemplateColumn);
  FreeAndNil(FCreateColorRuleList);
  FreeAndNil(FCreateColumnList);
  FreeAndNil(FCreateBаndList);
  inherited;
end;

procedure TCrossDBViewReportAddOn.FocusedItemChanged(Sender: TcxCustomGridTableView;
  APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
begin
  if Assigned(FFocusedItemChanged) then
     FFocusedItemChanged(Sender, APrevFocusedItem, AFocusedItem);
  if TcxDBDataController(FView.DataController).DataSource.State = dsEdit then begin
     // Если ошибка, то вернем в прошлую ячейку
     try
       TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
     except
       TcxDBDataController(FView.DataController).DataSource.DataSet.Cancel;
       FView.Controller.FocusedItem := APrevFocusedItem;
       raise;
     end;
  end;
end;

procedure TCrossDBViewReportAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
  var I, J : Integer;
begin
  inherited;

   if Operation = opRemove then begin
      if AComponent = HeaderDataSet then
         HeaderDataSet := nil;
      if AComponent = FActionExpand then
         FActionExpand := nil;
      if Assigned(TemplateColumnList) then
        for I := 0 to TemplateColumnList.Count - 1 do
          if TTemplateColumn(TemplateColumnList.Items[I]).FTemplateColumn = AComponent then
             TTemplateColumn(TemplateColumnList.Items[I]).FTemplateColumn := nil;
      if Assigned(MultiplyColumnList) then
        for I := 0 to MultiplyColumnList.Count - 1 do
          if TMultiplyColumn(MultiplyColumnList.Items[I]).FColumn = AComponent then
             TMultiplyColumn(MultiplyColumnList.Items[I]).FColumn := nil;
      if Assigned(FChartList) then
        for I := 0 to FChartList.Count - 1 do
        begin
          if TChart(FChartList.Items[I]).FChartView = AComponent then
             TChart(FChartList.Items[I]).FChartView := nil;
          if TChart(FChartList.Items[I]).FChartDataSet = AComponent then
             TChart(FChartList.Items[I]).FChartDataSet := nil;
        end;
   end;
end;

// Правим последовательность чтоб не перекасило отображение
procedure TCrossDBViewReportAddOn.ChangingTheSequence;
  var I : integer;
begin
   if View is TcxGridDBBandedTableView then
   begin
     i := 0;
     while I < FTemplateColumnList.Count - 1 do
     begin
       if (TcxGridDBBandedColumn(TTemplateColumn(FTemplateColumnList.Items[I]).FTemplateColumn).Position.ColIndex +
          (TcxGridDBBandedColumn(TTemplateColumn(FTemplateColumnList.Items[I]).FTemplateColumn).Position.RowIndex + 1) *
          TcxGridDBBandedColumn(TTemplateColumn(FTemplateColumnList.Items[I]).FTemplateColumn).Position.Band.ColumnCount) >
         (TcxGridDBBandedColumn(TTemplateColumn(FTemplateColumnList.Items[I + 1]).FTemplateColumn).Position.ColIndex +
          (TcxGridDBBandedColumn(TTemplateColumn(FTemplateColumnList.Items[I + 1]).FTemplateColumn).Position.RowIndex + 1) *
          TcxGridDBBandedColumn(TTemplateColumn(FTemplateColumnList.Items[I + 1]).FTemplateColumn).Position.Band.ColumnCount)  then
       begin
         FTemplateColumnList.Items[I + 1].Index := FTemplateColumnList.Items[I + 1].Index - 1;
         i := 0;
         Continue;
       end;
       Inc(I);
     end;
   end;
end;

procedure TCrossDBViewReportAddOn.onAfterClose(DataSet: TDataSet);
var i: integer;
begin
  if Assigned(FAfterClose) then
     FAfterClose(DataSet);

  for i := 0 to FCreateColorRuleList.Count - 1 do
    TColorRule(FCreateColorRuleList.Items[I]).Free;
  FCreateColorRuleList.Clear;

  for i := 0 to FCreateColumnList.Count - 1 do
    View.Columns[View.ColumnCount - 1].Free;
  FCreateColumnList.Clear;

  for i := 0 to FCreateBаndList.Count - 1 do
    TcxGridDBBandedTableView(View).Bands.Delete(TcxGridBand(FCreateBаndList.Items[I]).Index);
  FCreateBаndList.Clear;

  for i := 0 to FCreateTemplateColumn.Count - 1 do
    FTemplateColumnList.Delete(TTemplateColumn(FCreateTemplateColumn.Items[I]).Index);
  FCreateTemplateColumn.Clear;

  for i := 0 to FChartList.Count - 1 do
    if Assigned(TChart(FChartList.Items[I]).FChartView) and
       (TChart(FChartList.Items[I]).FChartView.DataController.DataSource = TChart(FChartList.Items[I]).FChartDS) then
         TChart(FChartList.Items[I]).FChartView.DataController.DataSource := Nil;

  // Перестраиваем назад если надо
  if (View is TcxGridDBBandedTableView) and isExpand then
  begin
    // Правим последовательность чтоб не перекасило отображение
    ChangingTheSequence;

    for I := 0 to FTemplateColumnList.Count - 1 do
    begin
      TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[I]).TemplateColumn).Position.RowIndex := TTemplateColumn(TemplateColumnList.Items[I]).FRowIndex;
      TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[I]).TemplateColumn).Position.ColIndex := TTemplateColumn(TemplateColumnList.Items[I]).FColIndex;
    end;

    case FMultiplyType of
      mtRight : FMultiplyType := mtTop;
      mtBottom : FMultiplyType := mtLeft;
      mtLeft : FMultiplyType := mtBottom;
      mtTop : FMultiplyType := mtRight;
    end;

    isExpand := False;
  end;

   // Очищаем диаграмы
   for i := 0 to FChartList.Count - 1 do
   begin
     if Assigned(TChart(FChartList.Items[I]).FChartView) then
     with TChart(FChartList.Items[I]) do
     begin
       FChartView.DataController.DataSource := Nil;
       FChartView.ClearSeries;
       FChartView.ClearDataGroups;
       if FChartCDS.Active then FChartCDS.Close;
       FChartCDS.FieldDefs.Clear;
       if Assigned(FDisplayedDataComboBox) then
       begin
         try
           DisplayedDataComboBox.Properties.OnChange := Nil;
           FDisplayedDataComboBox.Properties.Items.Clear;
           FDisplayedDataComboBox.Text := '';
         finally
           FDisplayedDataComboBox.Properties.OnChange := OnChangeDisplayedData;
         end;
       end;
     end;
   end;

end;

procedure TCrossDBViewReportAddOn.ExpandExecute;
  var I, Col, Row: integer;
begin
   // Правим последовательность чтоб не перекасило отображение
   ChangingTheSequence;

   // Перестраиваем
   if (View is TcxGridDBBandedTableView) then
   begin

      // Проверяем линейность
      Col := 0; Row := 0;
      for I := 0 to FTemplateColumnList.Count - 1 do
      begin
        TTemplateColumn(TemplateColumnList.Items[I]).FColIndex := TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[I]).TemplateColumn).Position.ColIndex;
        TTemplateColumn(TemplateColumnList.Items[I]).FRowIndex := TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[I]).TemplateColumn).Position.RowIndex;
        if Col < TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[I]).TemplateColumn).Position.ColIndex then
          Col := TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[I]).TemplateColumn).Position.ColIndex;
        if Row < TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[I]).TemplateColumn).Position.RowIndex then
          Row := TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[I]).TemplateColumn).Position.RowIndex;
      end;

      if Assigned(FActionExpand) and FActionExpand.Value then
      begin

        if (Col = 0) and (Row > 0) or (Col > 0) and (Row = 0) then
        begin

          if Col > 0 then
          begin
            for I := 1 to FTemplateColumnList.Count - 1 do
            begin
              TcxGridDBBandedColumn(TTemplateColumn(FTemplateColumnList.Items[I]).FTemplateColumn).Position.RowIndex := I;
            end;
          end else
          begin
            for I := 1 to FTemplateColumnList.Count - 1 do
            begin
              TcxGridDBBandedColumn(TTemplateColumn(FTemplateColumnList.Items[I]).FTemplateColumn).Position.RowIndex := 0;
            end;
          end;

          case FMultiplyType of
            mtRight : FMultiplyType := mtTop;
            mtBottom : FMultiplyType := mtLeft;
            mtLeft : FMultiplyType := mtBottom;
            mtTop : FMultiplyType := mtRight;
          end;

          isExpand := True;
        end else FActionExpand.Value := False;
      end;
   end else if Assigned(FActionExpand) and FActionExpand.Value then FActionExpand.Value := False;
end;


procedure TCrossDBViewReportAddOn.onAfterOpen(DataSet: TDataSet);
  var I : Integer;
begin
   if Assigned(FAfterOpen) then
      FAfterOpen(DataSet);

   // Пересоздаем диаграммы диаграммы
   for i := 0 to FChartList.Count - 1 do
   begin
     if Assigned(TChart(FChartList.Items[I]).FChartView) then
     with TChart(FChartList.Items[I]) do
     begin

       FChartView.BeginUpdate;

       //  Очтстием перед перестроеемем
       if FChartCDS.Active then
       begin
         FChartView.DataController.DataSource := Nil;
         FChartView.ClearSeries;
         FChartView.ClearDataGroups;
         if FChartCDS.Active then FChartCDS.Close;
         FChartCDS.FieldDefs.Clear;
         if Assigned(FDisplayedDataComboBox) then
         begin
           try
             DisplayedDataComboBox.Properties.OnChange := Nil;
             FDisplayedDataComboBox.Properties.Items.Clear;
             FDisplayedDataComboBox.Text := '';
           finally
             FDisplayedDataComboBox.Properties.OnChange := OnChangeDisplayedData;
           end;
         end;
       end;

       FChartView.DataController.DataSource := FChartDS;
       try
         // Добавляем поля
         if Assigned(ChartDataSet) and ChartDataSet.Active and not ChartDataSet.IsEmpty and
            Assigned(ChartDataSet.FindField(SeriesName)) and
            Assigned(ChartDataSet.FindField(SeriesFieldName))and
            (DataGroupsFielddName <> '') then
         begin

           FChartCDS.FieldDefs.Add(DataGroupsFielddName,      ftString, 20);

           // Строим диограмму

           with FChartView.CreateDataGroup do
           begin
             DisplayText := HeaderName;
             DataBinding.FieldName := DataGroupsFielddName;
           end;

           if Assigned(DisplayedDataComboBox) and (NameDisplayedDataFieldName <> '') then
           begin
             try
               DisplayedDataComboBox.Properties.OnChange := Nil;

               ChartDataSet.First;
               while not ChartDataSet.Eof do
               begin
                 if DisplayedDataComboBox.Properties.Items.IndexOf(ChartDataSet.FieldByName(NameDisplayedDataFieldName).AsString) < 0 then
                   DisplayedDataComboBox.Properties.Items.Add(ChartDataSet.FieldByName(NameDisplayedDataFieldName).AsString);
                 ChartDataSet.Next;
               end;

               if FDisplayedDataName <> '' then
               begin
                 if (DisplayedDataComboBox.Properties.Items.IndexOf(FDisplayedDataName) >= 0) then
                 begin
                   DisplayedDataComboBox.ItemIndex := DisplayedDataComboBox.Properties.Items.IndexOf(FDisplayedDataName);
                 end else FDisplayedDataName := '';
               end;

               if (FDisplayedDataName = '') and (DisplayedDataComboBox.Properties.Items.Count > 0) then
               begin
                 DisplayedDataComboBox.ItemIndex := 0;
                 FDisplayedDataName := DisplayedDataComboBox.Text;
               end;

               if FisShowTitle then FChartView.Title.Text := FDisplayedDataName
               else FChartView.Title.Text := '';
             finally
               FDisplayedDataComboBox.Properties.OnChange := OnChangeDisplayedData;
             end;
           end;

           ChartDataSet.First;
           while not ChartDataSet.Eof do
           begin
             if (FDisplayedDataName = '') or (ChartDataSet.FieldByName(NameDisplayedDataFieldName).AsString = FDisplayedDataName) then
             with FChartView.CreateSeries do
             begin
               DisplayText := ChartDataSet.FieldByName(SeriesName).AsString;
               DataBinding.FieldName := ChartDataSet.FieldByName(SeriesFieldName).AsString;

               if Assigned(DataSet.FindField(ChartDataSet.FieldByName(SeriesFieldName).AsString + '1')) then
               begin
                 case DataSet.FindField(ChartDataSet.FieldByName(SeriesFieldName).AsString + '1').DataType of
                   ftInteger : FChartCDS.FieldDefs.Add(ChartDataSet.FieldByName(SeriesFieldName).AsString, ftInteger, 0);
                   else FChartCDS.FieldDefs.Add(ChartDataSet.FieldByName(SeriesFieldName).AsString, ftFloat, 0);
                 end;
               end else FChartCDS.FieldDefs.Add(ChartDataSet.FieldByName(SeriesFieldName).AsString, ftFloat, 0);

             end;
             ChartDataSet.Next;
           end;

           if FChartCDS.FieldDefs.Count > 1 then FChartCDS.CreateDataSet;

           // Строки в FChartCDS диаграмму
           if FChartCDS.Active then
           begin

             HeaderDataSet.First;
             while not HeaderDataSet.Eof do
             begin
               if Assigned(HeaderDataSet.Fields.FindField(HeaderFieldName)) then
               begin
                 FChartCDS.Last;
                 FChartCDS.Append;
                 FChartCDS.FieldByName(DataGroupsFielddName).AsString := HeaderDataSet.FieldByName(HeaderFieldName).AsString;
                 FChartCDS.Post;
               end;
               HeaderDataSet.Next;
             end;
           end;
         end;
       finally
         FChartView.EndUpdate;
       end;
     end;
   end;

   if FChartList.Count > 0 then OnAfterScroll(FDataSet);
end;

procedure TCrossDBViewReportAddOn.onBeforeOpen(DataSet: TDataSet);
var NewColumnIndex, StartColumnIndex, Row, MaxRow, I, J, tCol, tRow: integer;
    Column: TcxGridColumn; Band: TcxGridBand;
    TemplateColorRule, ColorRule: TColorRule;
    TemplateColumn : TTemplateColumn;
begin
  if Assigned(FBeforeOpen) then
     FBeforeOpen(DataSet);
  View.BeginUpdate;

  try
      // Заполняем заголовки колонок

    if Assigned(HeaderDataSet) and HeaderDataSet.Active then
    begin

       // проверяем чтоб все было заполнено

       if TemplateColumnList.Count = 0 then
          raise Exception.Create('TemplateColumnList не установлены');

       for J := 0 to TemplateColumnList.Count - 1 do
       begin
         if not Assigned(HeaderDataSet.Fields.FindField(TTemplateColumn(TemplateColumnList.Items[J]).HeaderColumnName)) then
            raise Exception.Create('HeaderDataSet не имеет поля ' + TTemplateColumn(TemplateColumnList.Items[J]).HeaderColumnName);
         if not Assigned(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn) then
            raise Exception.Create('TemplateColumn не установлен для TemplateColumnList ' + IntToStr(J));

       end;

       // Перестраиваем если надо
       ExpandExecute;

       // размножаем колонки
       if Assigned(MultiplyDataSet) and MultiplyDataSet.Active and not MultiplyDataSet.IsEmpty then
       begin

         Row := 0;
         if View is TcxGridDBBandedTableView then
         begin
           for J := 0 to MultiplyColumnList.Count - 1 do
           begin
             if TcxGridDBBandedColumn(TMultiplyColumn(MultiplyColumnList.Items[J]).Column).Position.RowIndex > Row then
               Row := TcxGridDBBandedColumn(TMultiplyColumn(MultiplyColumnList.Items[J]).Column).Position.RowIndex;
             TcxGridDBBandedColumn(TMultiplyColumn(MultiplyColumnList.Items[J]).Column).Tag :=
               TcxGridDBBandedColumn(TMultiplyColumn(MultiplyColumnList.Items[J]).Column).Position.RowIndex;
           end;
           Inc(Row);
         end;

         MultiplyDataSet.First;
         NewColumnIndex := 1;
         while not MultiplyDataSet.Eof do
         begin

           for J := 0 to MultiplyColumnList.Count - 1 do
           begin
             Column := View.CreateColumn;
             Column.Name:= Name + 'MultiplyAdd' + MultiplyDataSet.FieldByName(TMultiplyColumn(MultiplyColumnList.Items[J]).FieldName).AsString;

             FCreateColumnList.Add(Column);
             with Column do
             begin
               Assign(TMultiplyColumn(MultiplyColumnList.Items[J]).Column);
               TMultiplyColumn(MultiplyColumnList.Items[J]).Column.Tag := 0;

               Caption := Column.Name;
               Width := TMultiplyColumn(MultiplyColumnList.Items[J]).Column.Width;
               Tag := NewColumnIndex * Row + TMultiplyColumn(MultiplyColumnList.Items[J]).Column.Tag;
               Options.Editing := False;

               if Column is TcxGridDBBandedColumn then
               begin
                 TcxGridDBBandedColumn(Column).DataBinding.FieldName := MultiplyDataSet.FieldByName(TMultiplyColumn(MultiplyColumnList.Items[J]).FieldName).AsString;
                 TcxGridDBBandedColumn(Column).Position.BandIndex := TcxGridDBBandedColumn(TMultiplyColumn(MultiplyColumnList.Items[J]).Column).Position.BandIndex;
                 TcxGridDBBandedColumn(Column).Position.ColIndex := TcxGridDBBandedColumn(Column).Position.Band.ColumnCount;
               end else if Column is TcxGridDBColumn then
               begin
                  TcxGridDBColumn(Column).DataBinding.FieldName := MultiplyDataSet.FieldByName(TMultiplyColumn(MultiplyColumnList.Items[J]).FieldName).AsString;
                  if FMultiplyType in [mtLeft, mtTop] then
                  begin
                    if NewColumnIndex = 1 then
                      StartColumnIndex := TcxGridDBColumn(TMultiplyColumn(MultiplyColumnList.Items[J]).Column).Index;
                    TcxGridDBColumn(Column).Index := StartColumnIndex + NewColumnIndex - 1;
                  end;
               end;
             end;

             TemplateColumn := TTemplateColumn(FTemplateColumnList.Add);
             TemplateColumn.TemplateColumn := Column;
             TemplateColumn.HeaderColumnName := MultiplyDataSet.FieldByName(TMultiplyColumn(MultiplyColumnList.Items[J]).HeaderFieldName).AsString;
             FCreateTemplateColumn.Add(TemplateColumn);
           end;

           MultiplyDataSet.Next;
           Inc(NewColumnIndex);
         end;

           // Построили схему
         if Column is TcxGridDBBandedColumn then
         begin

            for J := 0 to TemplateColumnList.Count - 1 do
            begin
              if TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn.Tag > MaxRow then
                 MaxRow := TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn.Tag;
            end;

            if FMultiplyType = mtRight then
            begin
              for I := Row to MaxRow do
                for J := TemplateColumnList.Count - 1 downto 0 do
              begin
                if (TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Tag = I) then
                  TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Position.ColIndex  := 0;
              end;
            end;
            if FMultiplyType = mtLeft then
            begin
              // Само так получаеться
            end;
            if FMultiplyType = mtTop then
            begin
              for I := MaxRow downto 0 do
                for J := 0 to TemplateColumnList.Count - 1 do
              begin
                if (TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Tag = I) and
                   (TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Position.RowIndex <>
                   (MaxRow - TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Tag)) then
                  TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Position.RowIndex  :=
                    MaxRow - TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Tag;
              end;
            end;
            if FMultiplyType = mtBottom then
            begin
              for I := 0 to MaxRow do
                for J := 0 to TemplateColumnList.Count - 1 do
              begin
                if (TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Tag = I) and
                   (TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Position.RowIndex <>
                    TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Tag) then
                  TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Position.RowIndex  :=
                    TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Tag;
              end;
            end;
         end;

         // Правим последовательность чтоб не перекасило отображение
         ChangingTheSequence;

       end;

       //  Кроссируем
       HeaderDataSet.First;
       NewColumnIndex := 1;
       while not HeaderDataSet.Eof do begin

         Band := Nil;
         for J := 0 to TemplateColumnList.Count - 1 do
         begin

           if not TTemplateColumn(TemplateColumnList.Items[J]).FIsCrossParam.Value then Continue;


           if not Assigned(HeaderDataSet.Fields.FindField(TTemplateColumn(TemplateColumnList.Items[J]).HeaderColumnName)) then Continue;
           if not Assigned(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn) then Continue;

           if (View is TcxGridDBBandedTableView)
              and (BаndColumnName <> '')
              and Assigned(HeaderDataSet.Fields.FindField(BаndColumnName))
              and not Assigned(Band) then
           begin
             Band := TcxGridDBBandedTableView(View).Bands.Add;
             Band.Assign(TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Position.Band);
             Band.Position.ColIndex := Band.Position.ColIndex + 1 + NewColumnIndex;
             Band.Caption := HeaderDataSet.FieldByName(BаndColumnName).AsString;
             Band.Visible := true;
             FCreateBаndList.Add(Band);
           end;

           TemplateColorRule := Nil;
           for I := 0 to ColorRuleList.Count - 1 do
             if TColorRule(ColorRuleList.Items[I]).ColorColumn = TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn then
           begin
             TemplateColorRule := TColorRule(ColorRuleList.Items[I]);
             Break;
           end;

           Column := View.CreateColumn;
           if TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn is TcxGridDBBandedColumn then
             Column.Name:= View.Name + TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).DataBinding.FieldName + IntToStr(Column.index);
           if TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn is TcxGridDBColumn then
             Column.Name:= View.Name + TcxGridDBColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).DataBinding.FieldName + IntToStr(Column.index);
           FCreateColumnList.Add(Column);
           with Column do begin
             Assign(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn);
             Visible := true;
             Caption := HeaderDataSet.FieldByName(TTemplateColumn(TemplateColumnList.Items[J]).HeaderColumnName).AsString;
             Width := TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn.Width;
             if Column is TcxGridDBBandedColumn then
             begin
                TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                if Assigned(Band) then
                begin
                  TcxGridDBBandedColumn(Column).Position.BandIndex := Band.Index;
                  TcxGridDBBandedColumn(Column).Position.ColIndex := TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Position.ColIndex;
                  TcxGridDBBandedColumn(Column).Position.RowIndex := TcxGridDBBandedColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).Position.RowIndex;
                end else TcxGridDBBandedColumn(Column).Position.ColIndex := TcxGridDBBandedColumn(Column).Position.Band.ColumnCount;
             end;
             if Column is TcxGridDBColumn then
                TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TTemplateColumn(TemplateColumnList.Items[J]).TemplateColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
             Options.Editing := False;
           end;

           if Assigned(TemplateColorRule) then
           begin
             ColorRule:= TColorRule.Create(FColorRuleList);
             ColorRule.Assign(TemplateColorRule);
             ColorRule.ColorColumn := Column;
             if not NoCrossColorColumn then
             begin
               if Assigned(TemplateColorRule.BackGroundValueColumn) then
               begin
                 Column := View.CreateColumn;
                 if TemplateColorRule.BackGroundValueColumn is TcxGridDBBandedColumn then
                   Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 if TemplateColorRule.BackGroundValueColumn is TcxGridDBColumn then
                   Column.Name:= View.Name + TcxGridDBColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 FCreateColumnList.Add(Column);
                 with Column do begin
                   Assign(TemplateColorRule.BackGroundValueColumn);
                   Visible := False;
                   if (Column is TcxGridDBBandedColumn) and (TemplateColorRule.BackGroundValueColumn is TcxGridDBBandedColumn) then
                      TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                   if (Column is TcxGridDBColumn) and (TemplateColorRule.BackGroundValueColumn is TcxGridDBColumn) then
                      TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColorRule.BackGroundValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                 end;
                 ColorRule.BackGroundValueColumn := Column;
               end;
               if Assigned(TemplateColorRule.ValueBoldColumn) then
               begin
                 Column := View.CreateColumn;
                 if TemplateColorRule.ValueBoldColumn is TcxGridDBBandedColumn then
                   Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(Column.index);
                 if TemplateColorRule.ValueBoldColumn is TcxGridDBColumn then
                   Column.Name:= View.Name + TcxGridDBColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(Column.index);
                 FCreateColumnList.Add(Column);
                 with Column do begin
                   Assign(TemplateColorRule.ValueBoldColumn);
                   Visible := False;
                   if (Column is TcxGridDBBandedColumn) and (TemplateColorRule.ValueBoldColumn is TcxGridDBBandedColumn) then
                      TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                   if (Column is TcxGridDBColumn) and (TemplateColorRule.ValueBoldColumn is TcxGridDBColumn) then
                      TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColorRule.ValueBoldColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                 end;
                 ColorRule.ValueBoldColumn := Column;
               end;
               if Assigned(TemplateColorRule.ValueColumn) then
               begin
                 Column := View.CreateColumn;
                 if TemplateColorRule.ValueColumn is TcxGridDBBandedColumn then
                   Column.Name:= View.Name + TcxGridDBBandedColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 if TemplateColorRule.ValueColumn is TcxGridDBColumn then
                   Column.Name:= View.Name + TcxGridDBColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(Column.index);
                 FCreateColumnList.Add(Column);
                 with Column do begin
                   Assign(TemplateColorRule.ValueColumn);
                   Visible := False;
                   if (Column is TcxGridDBBandedColumn) and (TemplateColorRule.ValueColumn is TcxGridDBBandedColumn) then
                      TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                   if (Column is TcxGridDBColumn) and (TemplateColorRule.ValueColumn is TcxGridDBColumn) then
                      TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColorRule.ValueColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
                 end;
                 ColorRule.ValueColumn := Column;
               end;
             end else
             begin
               ColorRule.BackGroundValueColumn := TemplateColorRule.BackGroundValueColumn;
               ColorRule.ValueBoldColumn := TemplateColorRule.ValueBoldColumn;
               ColorRule.ValueColumn := TemplateColorRule.ValueColumn;
             end;
             FCreateColorRuleList.Add(ColorRule);
           end;
         end;

         inc(NewColumnIndex);
         HeaderDataSet.Next;
       end;
    end;
  finally
    View.EndUpdate;
  end;
end;

procedure TCrossDBViewReportAddOn.SetView(const Value: TcxGridTableView);
begin
  inherited;
  if Value <> nil then
  begin
     FDataSet := TcxDBDataController(Value.DataController).DataSet;
     if Assigned(FDataSet) then
     begin
       FBeforeOpen := FDataSet.BeforeOpen;
       FDataSet.BeforeOpen := onBeforeOpen;
       FAfterClose := FDataSet.AfterClose;
       FDataSet.AfterClose := onAfterClose;
       FAfterOpen := FDataSet.AfterOpen;
       FDataSet.AfterOpen :=  onAfterOpen;
     end;
     FFocusedItemChanged := Value.OnFocusedItemChanged;
     Value.OnFocusedItemChanged := FocusedItemChanged;
  end;
end;

procedure TCrossDBViewReportAddOn.OnAfterScroll(DataSet: TDataSet);
  var I, J : Integer; FieldName : String;
begin
  inherited OnAfterScroll(DataSet);

  if not Assigned(DataSet) then Exit;
  if not DataSet.Active then Exit;

  for i := 0 to FChartList.Count - 1 do
    if TChart(FChartList.Items[I]).FChartCDS.Active then
  with TChart(FChartList.Items[I]) do
  begin

    FChartView.BeginUpdate;
    try
      FChartCDS.First;
      while not FChartCDS.Eof do
      begin
        FChartCDS.Edit;

        for J := 1 to FChartCDS.FieldCount - 1 do
        begin
          FieldName := FChartCDS.Fields.Fields[J].FieldName + IntToStr(FChartCDS.RecNo);

          if Assigned(DataSet) and Assigned(DataSet.FindField(FieldName)) then
            FChartCDS.FindField(FChartCDS.Fields.Fields[J].FieldName).AsVariant := DataSet.FieldByName(FieldName).AsVariant
          else FChartCDS.FindField(FChartCDS.Fields.Fields[J].FieldName).AsVariant := 0;
        end;

        FChartCDS.Post;
        FChartCDS.Next;
      end;
    finally
      FChartView.EndUpdate;
    end;
  end;
end;

{ TdsdChartColumn }

procedure TdsdChartColumn.Assign(Source: TPersistent);
begin
  if Source is TdsdChartColumn then
    with TdsdChartColumn(Source) do
    begin
      Self.FColumn := FColumn;
      Self.FTitle := FTitle;
    end
  else
    inherited Assign(Source);
end;

function TdsdChartColumn.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FColumn) then
     result := FColumn.Name
end;

{ TdsdChartSeries }

constructor TdsdChartSeries.Create(Collection: TCollection);
begin
  inherited;
  FChartColumnList := TCollection.Create(TdsdChartColumn);
  FSeriesName:= '';
end;

destructor TdsdChartSeries.Destroy;
begin
  FreeAndNil(FChartColumnList);
  inherited;
end;

procedure TdsdChartSeries.Assign(Source: TPersistent);
begin
  if Source is TdsdChartSeries then
    with TdsdChartSeries(Source) do
    begin
      Self.FChartColumnList.Assign(FChartColumnList);
      Self.FSeriesName := FSeriesName;
    end
  else
    inherited Assign(Source);
end;

function TdsdChartSeries.GetDisplayName: string;
begin
  result := inherited;
  if FSeriesName <> '' then
     result := FSeriesName
end;

{ TdsdChartVariant }

constructor TdsdChartVariant.Create(Collection: TCollection);
begin
  inherited;
  FChartSeriesList := TOwnedCollection.Create(Self, TdsdChartSeries);
  FHeaderName:= '';
end;

destructor TdsdChartVariant.Destroy;
begin
  FreeAndNil(FChartSeriesList);
  inherited;
end;

procedure TdsdChartVariant.Assign(Source: TPersistent);
begin
  if Source is TdsdChartVariant then
    with TdsdChartVariant(Source) do
    begin
      Self.FChartSeriesList.Assign(FChartSeriesList);
      Self.FHeaderName := FHeaderName;
    end
  else
    inherited Assign(Source);
end;

function TdsdChartVariant.GetDisplayName: string;
begin
  result := inherited;
  if FHeaderName <> '' then
     result := FHeaderName
end;

{ TdsdChartView }

constructor TdsdChartView.Create(Collection: TCollection);
begin
  inherited;
  FChartCDS := TClientDataSet.Create(Nil);
  FChartDS := TDataSource.Create(Nil);
  FChartDS.DataSet := FChartCDS;
  FisShowTitle := True;
  FChartVariantList := TOwnedCollection.Create(Self, TdsdChartVariant);
  FDisplayedIndex := -1;
end;

destructor TdsdChartView.Destroy;
begin
  FreeAndNil(FChartDS);
  FreeAndNil(FChartCDS);
  FreeAndNil(FChartVariantList);
  inherited;
end;

procedure TdsdChartView.Assign(Source: TPersistent);
begin
  if Source is TdsdChartView then
    with TdsdChartView(Source) do
    begin
      Self.ChartView := ChartView;
      Self.FChartVariantList.Assign(FChartVariantList);
      Self.DisplayedDataComboBox := DisplayedDataComboBox;
      Self.FDisplayedIndex := FDisplayedIndex;
      Self.FisShowTitle := FisShowTitle;
    end
  else
    inherited Assign(Source);
end;

function TdsdChartView.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FChartView) then
     result := FChartView.Name
end;

procedure TdsdChartView.SetDisplayedDataComboBox(Value : TcxComboBox);
begin
  if Assigned(DisplayedDataComboBox) then DisplayedDataComboBox.Properties.OnChange := FOnChange;

  FDisplayedDataComboBox := Value;
  if Assigned(DisplayedDataComboBox) then
  begin
    FOnChange := FDisplayedDataComboBox.Properties.OnChange;
    FDisplayedDataComboBox.Properties.OnChange := OnChangeDisplayedData;
  end;

end;

procedure TdsdChartView.OnChangeDisplayedData(Sender: TObject);
begin
   if Assigned(DisplayedDataComboBox) then
   begin
     if DisplayedDataComboBox.ItemIndex >= 0 then
     begin
       FDisplayedIndex := DisplayedDataComboBox.ItemIndex;
       try
         DisplayedDataComboBox.Properties.OnChange := Nil;
         if Collection.Owner is TdsdDBViewAddOn then
           if Assigned(TcxDBDataController(TdsdDBViewAddOn(Collection.Owner).FView.DataController).DataSource) then
             if Assigned(TcxDBDataController(TdsdDBViewAddOn(Collection.Owner).FView.DataController).DataSource.DataSet) then
           TdsdDBViewAddOn(Collection.Owner).onAfterOpen(TcxDBDataController(TdsdDBViewAddOn(Collection.Owner).FView.DataController).DataSource.DataSet);
       finally
         FDisplayedDataComboBox.Properties.OnChange := OnChangeDisplayedData;
       end;
     end;
     TCrossDBViewReportAddOn(Collection.Owner).View.Control.SetFocus;
   end;
end;

{ TChartAddOn }

constructor TChartAddOn.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TChartAddOn.Destroy;
begin
  inherited;
end;


procedure TChartAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
  var I, J : Integer;
begin
  inherited;

   if Operation = opRemove then begin
      if AComponent = ChartView then
         ChartView := nil;
   end;
end;

procedure TChartAddOn.SetView(const Value: TcxGridDBChartView);
  var I : Integer;
begin

  if FChartView = Value then Exit;

  FChartView := Value;
  if csDesigning  in ComponentState then Exit;
  if Assigned(FChartView) then
  begin

    if Assigned(TcxDBDataController(FChartView.DataController).DataSource) then
       if Assigned(TcxDBDataController(FChartView.DataController).DataSource.DataSet) then begin
          FBeforeOpen := TcxDBDataController(FChartView.DataController).DataSource.DataSet.BeforeOpen;
          TcxDBDataController(FChartView.DataController).DataSource.DataSet.BeforeOpen := OnBeforeOpen;
          FAfterOpen := TcxDBDataController(FChartView.DataController).DataSource.DataSet.AfterOpen;
          TcxDBDataController(FChartView.DataController).DataSource.DataSet.AfterOpen := OnAfterOpen;
     end;
  end;
end;

procedure TChartAddOn.onBeforeOpen(ADataSet: TDataSet);
var NewColumnIndex, I: integer;
    Column: TcxGridColumn;
    TemplateColorRule, ColorRule: TColorRule;
begin
  if Assigned(FBeforeOpen) then FBeforeOpen(ADataSet);
  if not Assigned(SeriesDataSet) then Exit;

  ChartView.BeginUpdate;
  try
    FChartView.ClearSeries;
  finally
    ChartView.EndUpdate;
  end;
end;

procedure TChartAddOn.OnAfterOpen(ADataSet: TDataSet);
  var I, J : Integer;
begin
  if Assigned(FAfterOpen) then
     FAfterOpen(ADataSet);
  if not Assigned(SeriesDataSet) then Exit;

  ChartView.BeginUpdate;
  try
    FChartView.ClearSeries;
    if not SeriesDataSet.Active then Exit;

    SeriesDataSet.First;
    while not SeriesDataSet.Eof do
    begin

      with FChartView.CreateSeries do
      begin
        DisplayText := SeriesDataSet.FieldByName(FSeriesDisplayText).AsString;
        DataBinding.FieldName := SeriesDataSet.FieldByName(FSeriesFieldName).AsString;;
      end;

      SeriesDataSet.Next;
    end;

  finally
    ChartView.EndUpdate;
  end;
end;

{ TPositionCellData }

constructor TPositionCellData.Create;
begin
  FLeftParam := TdsdParam.Create;
  FTopParam := TdsdParam.Create;
  FWidthParam := TdsdParam.Create;
  FHeightParam := TdsdParam.Create;
end;

destructor TPositionCellData.Destroy;
begin
  FLeftParam.Free;
  FTopParam.Free;
  FWidthParam.Free;
  FHeightParam.Free;
end;

{ TFieldParamsData }

constructor TFieldParamsData.Create;
begin
  FFieldIdParam := TdsdParam.Create;
  FFieldIdParam.DataType := ftString;
  FFieldIdParam.Value := 'Id';
  FFieldParentIdParam := TdsdParam.Create;;
  FFieldParentIdParam.DataType := ftString;
  FFieldParentIdParam.Value := 'ParentId';
  FFieldPositionFixedParam := TdsdParam.Create;
  FFieldPositionFixedParam.DataType := ftString;
  FFieldPositionFixedParam.Value := 'isPositionFixed';
  FFieldLeftParam := TdsdParam.Create;
  FFieldLeftParam.DataType := ftString;
  FFieldLeftParam.Value := 'Left';
  FFieldTopParam := TdsdParam.Create;
  FFieldTopParam.DataType := ftString;
  FFieldTopParam.Value := 'Top';
  FFieldWidthParam := TdsdParam.Create;
  FFieldWidthParam.DataType := ftString;
  FFieldWidthParam.Value := 'Width';
  FFieldHeightParam := TdsdParam.Create;
  FFieldHeightParam.DataType := ftString;
  FFieldHeightParam.Value := 'Height';
  FFieldTextParam := TdsdParam.Create;
  FFieldTextParam.DataType := ftString;
  FFieldTextParam.Value := 'Name';
  FFieldColorParam := TdsdParam.Create;
  FFieldColorParam.DataType := ftString;
  FFieldColorParam.Value := '';
  FFieldTextColorParam := TdsdParam.Create;
  FFieldTextColorParam.DataType := ftString;
  FFieldTextColorParam.Value := '';
  FFieldRootTreeParam := TdsdParam.Create;
  FFieldRootTreeParam.DataType := ftString;
  FFieldRootTreeParam.Value := '';
  FFieldLetterTreeParam := TdsdParam.Create;
  FFieldLetterTreeParam.DataType := ftString;
  FFieldLetterTreeParam.Value := '';
end;

destructor TFieldParamsData.Destroy;
begin
  FFieldIdParam.Free;
  FFieldPositionFixedParam.Free;
  FFieldLeftParam.Free;
  FFieldTopParam.Free;
  FFieldWidthParam.Free;
  FFieldHeightParam.Free;
  FFieldTextParam.Free;
  FFieldColorParam.Free;
  FFieldTextColorParam.Free;
  FFieldRootTreeParam.Free;
  FFieldLetterTreeParam.Free;
end;

{ TCheckerboardAddOn }

constructor TCheckerboardAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FCreatePanelList := TList.Create;
  FFocusedIdParam := TdsdParam.Create;
  FPositionCellData := TPositionCellData.Create;
  FFieldParamsData := TFieldParamsData.Create;

  FStyle := TcxEditStyle.Create(Nil, False);
  FStyleFocused := TcxEditStyle.Create(Nil, False);
  FStyleFocused.Color := clMenuHighlight;
  FStyleFocused.TextColor := clYellow;
  FStyleFocused.TextStyle := [fsBold];
  FStyleFocused.BorderStyle := ebsThick;

  FTimer := TTimer.Create(Nil);
  FTimer.Enabled := False;
  FTimer.Interval := 100;
  FTimer.OnTimer := OnTimer;
  FTimerProcess := 0;
  FFocusID := 0;
  FFocusSetID := 0;

  FGap := 5;
  FHeight := 137;
  FWidth := 105;
  FMinWidth := 20;
  FMinHeight := 30;

end;

destructor TCheckerboardAddOn.Destroy;
  var I : Integer;
begin
  FTimer.Free;
  FPositionCellData.Free;
  FFocusedIdParam.Free;
  FCreatePanelList.Free;
  FFieldParamsData.Free;
  FStyleFocused.Free;
  FStyle.Free;
  inherited;
end;


procedure TCheckerboardAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
  var I, J : Integer;
begin
  inherited;

   if Operation = opRemove then begin
      if AComponent = FControl then
         FControl := nil
      else if AComponent = FDataSet then
         FDataSet := nil;
   end;
end;

procedure TCheckerboardAddOn.SetDataSet(const Value: TDataSet);
  var I : Integer;
begin

  if Assigned(FDataSet) and not (csDesigning  in ComponentState) then
  begin
    FDataSet.AfterOpen := FAfterOpen;
    FDataSet.AfterClose := FAfterClose;
    FDataSet.BeforeClose := FBeforeClose;
  end;

  FDataSet := Value;
  if csDesigning  in ComponentState then Exit;
  if Assigned(FDataSet) then
  begin
    FAfterOpen := FDataSet.AfterOpen;
    FDataSet.AfterOpen := OnAfterOpen;
    FAfterClose := FDataSet.AfterClose;
    FDataSet.AfterClose := OnAfterClose;
    FBeforeClose := FDataSet.BeforeClose;
    FDataSet.BeforeClose := OnBeforeClose;
  end;
end;

procedure TCheckerboardAddOn.SetRunUpdateAllPositionAction(const Value: TCustomAction);
begin
  if Assigned(Value) and (not (Value is TdsdRunAction)) then raise Exception.Create('Должен быть TdsdRunAction.');

  if Assigned(FRunUpdateAllPositionAction) then TdsdRunAction(FRunUpdateAllPositionAction).OnRunTask := Nil;
  FRunUpdateAllPositionAction := Value;
  if Assigned(FRunUpdateAllPositionAction) then TdsdRunAction(FRunUpdateAllPositionAction).OnRunTask := OnRunTask;
end;


procedure TCheckerboardAddOn.OnAfterOpen(ADataSet: TDataSet);
  var nTop, nLeft, I : Integer; isPositionFixed : Boolean;
      cxMemo : TcxMemo;
begin
  if Assigned(FAfterOpen) then
     FAfterOpen(ADataSet);

  // Отключим кнопку сохранения если есть
  if Assigned(FRunUpdateAllPositionAction) then
  begin
    FRunUpdateAllPositionAction.Enabled := False
  end;

  if not Assigned(FControl) then Exit;

  nTop := FGap;
  nLeft := FGap;
  isPositionFixed := False;

  if FFieldParamsData.FFieldPositionFixedParam.Value <> '' then
  begin
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      if ADataSet.FieldByName(FFieldParamsData.FFieldPositionFixedParam.Value).AsBoolean then
      begin
        isPositionFixed := True;
        if nTop < ADataSet.FieldByName(FFieldParamsData.FFieldTopParam.Value).AsInteger then
          nTop := ADataSet.FieldByName(FFieldParamsData.FFieldTopParam.Value).AsInteger;
        if nLeft < (ADataSet.FieldByName(FFieldParamsData.FFieldLeftParam.Value).AsInteger + ADataSet.FieldByName(FFieldParamsData.FFieldWidthParam.Value).AsInteger + FGap) then
          nLeft := ADataSet.FieldByName(FFieldParamsData.FFieldLeftParam.Value).AsInteger + ADataSet.FieldByName(FFieldParamsData.FFieldWidthParam.Value).AsInteger + FGap;
      end;

      ADataSet.Next;
    end;

    if isPositionFixed and ((nLeft + FWidth) > FControl.Width) then
    begin
      nLeft := FGap;
      nTop := nTop + FHeight + FGap;
    end;
  end;


  ADataSet.First;

  // Проверим корень
  if (FFieldParamsData.FFieldRootTreeParam.Value <> '') and Assigned(FPriorAction) then
  begin
    if ADataSet.IsEmpty then FPriorAction.Enabled := False
    else FPriorAction.Enabled := not FDataSet.FieldByName(FFieldParamsData.FFieldRootTreeParam.Value).AsBoolean;
  end;

  while not ADataSet.Eof do
  begin
    cxMemo := TcxMemo.Create(FControl.Owner);
    cxMemo.Visible := False;
    cxMemo.Style := FStyle;
    cxMemo.StyleFocused := FStyleFocused;
    cxMemo.Parent := FControl;

    if isPositionFixed and ADataSet.FieldByName(FFieldParamsData.FFieldPositionFixedParam.Value).AsBoolean then
    begin
      cxMemo.Top := ADataSet.FieldByName(FFieldParamsData.FFieldTopParam.Value).AsInteger;
      cxMemo.Left := ADataSet.FieldByName(FFieldParamsData.FFieldLeftParam.Value).AsInteger;
      cxMemo.Height := ADataSet.FieldByName(FFieldParamsData.FFieldHeightParam.Value).AsInteger;
      cxMemo.Width := ADataSet.FieldByName(FFieldParamsData.FFieldWidthParam  .Value).AsInteger;
    end else
    begin
      cxMemo.Top := nTop;
      cxMemo.Left := nLeft;
      cxMemo.Height := FHeight;
      cxMemo.Width := FWidth;

      if (nLeft > FGap) and ((nLeft + FWidth * 2) > FControl.Width) then
      begin
        nLeft := FGap;
        nTop := nTop + cxMemo.Height + FGap;
      end else nLeft := nLeft + cxMemo.Width + FGap;
    end;

    cxMemo.Properties.ReadOnly := True;

    cxMemo.OnMouseDown := OnMouseDown;
    cxMemo.OnMouseMove := OnMouseMove;
    cxMemo.OnMouseUp := OnMouseUp;
    cxMemo.OnDblClick := OnDblClick;
    cxMemo.OnEnter := OnEnter;


    cxMemo.Tag := ADataSet.FieldByName(FFieldParamsData.FFieldIdParam.Value).AsInteger;
    cxMemo.Text := ADataSet.FieldByName(FFieldParamsData.FFieldTextParam.Value).AsString;

    // Заменим цвет фон
    if FFieldParamsData.FFieldColorParam.Value <> '' then
      cxMemo.Style.Color := FDataSet.FieldByName(FFieldParamsData.FFieldColorParam.Value).AsInteger;
    // Звменим цвет шрифта
    if FFieldParamsData.FFieldTextColorParam.Value <> '' then
      cxMemo.Style.TextColor := FDataSet.FieldByName(FFieldParamsData.FFieldTextColorParam.Value).AsInteger;

    FCreatePanelList.Add(cxMemo);
    ADataSet.Next;
  end;

  for i := 0 to FCreatePanelList.Count - 1 do
    TWinControl(FCreatePanelList.Items[I]).Visible := True;

  FTimerProcess := FTimerProcess or 4;
  FTimer.Enabled := True;

end;

procedure TCheckerboardAddOn.OnBeforeClose(ADataSet: TDataSet);
  var I, J : Integer;
begin
  if Assigned(FBeforeClose) then
     FBeforeClose(ADataSet);

  if not ADataSet.Active then Exit;

  FFocusID := ADataSet.FieldByName(FFieldParamsData.FFieldIdParam.Value).AsInteger;

  if (FFieldParamsData.FFieldParentIdParam.Value <> '') and
     Assigned(ADataSet.FindField(FFieldParamsData.FFieldParentIdParam.Value)) then
    FFocusSetID := ADataSet.FieldByName(FFieldParamsData.FFieldParentIdParam.Value).AsInteger;

  // Отключим кнопку сохранения если есть
  if Assigned(FRunUpdateAllPositionAction) then
  begin
    FRunUpdateAllPositionAction.Enabled := False
  end;

end;

procedure TCheckerboardAddOn.OnAfterClose(ADataSet: TDataSet);
  var I, J : Integer;
begin
  if Assigned(FAfterClose) then
     FAfterClose(ADataSet);

  for i := 0 to FCreatePanelList.Count - 1 do
    TWinControl(FCreatePanelList.Items[I]).Free;

  FCreatePanelList.Clear;
end;

procedure TCheckerboardAddOn.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssCtrl in Shift) and (Button = mbLeft) then
  begin
    if not (Sender is TWinControl) then Exit;

    FControlDown := TWinControl(Sender);
    FPosCellData.Left := FControlDown.Left;
    FPosCellData.Top := FControlDown.Top;
    FPosCellData.Width := FControlDown.Width;
    FPosCellData.Height := FControlDown.Height;

    if ((FControlDown.Width-X) < 20) and ((FControlDown.Height-Y) < 20) then
    begin
      Screen.Cursor := crSizeNWSE;
      //FPanelDown.Cursor := crSizeNWSE;
      SetCapture(FControlDown.Handle);
      FSizing := true;
      FMouseDownSpot.X := x;
      FMouseDownSpot.Y := Y;
    end else
    begin
      Screen.Cursor := crSizeAll;
      //FPanelDown.Cursor := crSizeAll;
      SetCapture(FControlDown.Handle);
      FCapturing := true;
      FMouseDownSpot.X := x;
      FMouseDownSpot.Y := Y;
    end;
  end;
end;

procedure TCheckerboardAddOn.OnMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FCapturing then
  begin
    if (FControlDown.Left - (FMouseDownSpot.x - x)) >= 0 then
      FControlDown.Left := FControlDown.Left - (FMouseDownSpot.x - x);
    if (FControlDown.Top - (FMouseDownSpot.y - y)) >= 0 then
      FControlDown.Top := FControlDown.Top - (FMouseDownSpot.y - y);
  end else if FSizing then
  begin
    if FMinWidth <= (FControlDown.Width + X-FMouseDownSpot.X) then
    begin
      FControlDown.Width := FControlDown.Width + X-FMouseDownSpot.X;
      FMouseDownSpot.X := X;
    end;
    if  FMinHeight <= (FControlDown.Height + Y-FMouseDownSpot.Y) then
    begin
      FControlDown.Height := FControlDown.Height + Y-FMouseDownSpot.Y;
      FMouseDownSpot.Y := Y;
    end;
  end;
end;

procedure TCheckerboardAddOn.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FCapturing or FSizing then
  begin
    ReleaseCapture;
    FCapturing := false;
    FSizing := false;

    //FPanelDown.Cursor:=crDefault;
    Screen.Cursor:=crDefault;

    if (FPosCellData.Left <> FControlDown.Left) or
       (FPosCellData.Top <> FControlDown.Top) or
       (FPosCellData.Width <> FControlDown.Width) or
       (FPosCellData.Height <> FControlDown.Height) then
    begin
      FPositionCellData.LeftParam.Value := FControlDown.Left;
      FPositionCellData.TopParam.Value := FControlDown.Top;
      FPositionCellData.WidthParam.Value := FControlDown.Width;
      FPositionCellData.HeightParam.Value := FControlDown.Height;

      if Assigned(FUpdatePositionAction) and not Assigned(FRunUpdateAllPositionAction) then
      begin
        FTimerProcess := FTimerProcess or 1;
        FTimer.Enabled := True
      end else
      if Assigned(FRunUpdateAllPositionAction) then
      begin
        FRunUpdateAllPositionAction.Enabled := True;
      end;

    end;
  end;
end;

procedure TCheckerboardAddOn.OnDblClick(Sender: TObject);
begin
  FFocusedIdParam.Value := TWinControl(Sender).Tag;
  if FDataSet.Locate(FFieldParamsData.FFieldIdParam.Value, TWinControl(Sender).Tag, []) then
    if Assigned(FDblClickAction) then //FDblClickAction.Execute;
    begin
      // Если лист не проваливаемся
      if FFieldParamsData.FFieldLetterTreeParam.Value <> '' then
        if FDataSet.FieldByName(FFieldParamsData.FFieldLetterTreeParam.Value).AsBoolean then Exit;
      FTimerProcess := FTimerProcess or 2;
      FTimer.Enabled := True;
    end;
end;

procedure TCheckerboardAddOn.OnEnter(Sender: TObject);
begin
  FFocusedIdParam.Value := TWinControl(Sender).Tag;
  FDataSet.Locate(FFieldParamsData.FFieldIdParam.Value, TWinControl(Sender).Tag, []);
end;

procedure TCheckerboardAddOn.OnTimer(Sender: TObject);
  var I : Integer;
begin
  FTimer.Enabled := False;
  try

    if (FTimerProcess and 1) > 0 then if Assigned(FUpdatePositionAction) and not Assigned(FRunUpdateAllPositionAction) then FUpdatePositionAction.Execute;

    if (FTimerProcess and 2) > 0 then if Assigned(FDblClickAction) then FDblClickAction.Execute;

    if (FTimerProcess and 4) > 0 then
    begin
      if FFocusID > 0 then
        for i := 0 to FCreatePanelList.Count - 1 do
           if TWinControl(FCreatePanelList.Items[I]).Tag = FFocusID then
           begin
             TWinControl(FCreatePanelList.Items[I]).SetFocus;
             Exit;
           end;
      if FFocusSetID > 0 then
        for i := 0 to FCreatePanelList.Count - 1 do
           if TWinControl(FCreatePanelList.Items[I]).Tag = FFocusSetID then
           begin
             TWinControl(FCreatePanelList.Items[I]).SetFocus;
             Exit;
           end;
      if FCreatePanelList.Count > 0 then TWinControl(FCreatePanelList.Items[0]).SetFocus;
    end;

  finally
    FTimerProcess := 0;
  end;

end;

procedure TCheckerboardAddOn.OnRunTask(Sender: TObject);
  var I, nFocus : Integer;
begin

  if not Assigned(FUpdatePositionAction) and not Assigned(FRunUpdateAllPositionAction) then FUpdatePositionAction.Execute;

  nFocus := FFocusedIdParam.Value;
  try

    with TGaugeFactory.GetGauge('Сохраненеи позиций и размеров ячеек', 0, FCreatePanelList.Count) do
    try
      Start;

      for i := 0 to FCreatePanelList.Count - 1 do
        if FDataSet.Locate(FFieldParamsData.FFieldIdParam.Value, TWinControl(TWinControl(FCreatePanelList.Items[I])).Tag, []) then
      begin
        if (TWinControl(FCreatePanelList.Items[I]).Left <> FDataSet.FieldByName(FFieldParamsData.FFieldLeftParam.Value).AsInteger) or
           (TWinControl(FCreatePanelList.Items[I]).Top <> FDataSet.FieldByName(FFieldParamsData.FFieldTopParam.Value).AsInteger) or
           (TWinControl(FCreatePanelList.Items[I]).Width <> FDataSet.FieldByName(FFieldParamsData.FFieldWidthParam.Value).AsInteger) or
           (TWinControl(FCreatePanelList.Items[I]).Height <> FDataSet.FieldByName(FFieldParamsData.FFieldHeightParam.Value).AsInteger) then
        begin
          FFocusSetID := TWinControl(FCreatePanelList.Items[I]).Tag;
          FPositionCellData.LeftParam.Value := TWinControl(FCreatePanelList.Items[I]).Left;
          FPositionCellData.TopParam.Value := TWinControl(FCreatePanelList.Items[I]).Top;
          FPositionCellData.WidthParam.Value := TWinControl(FCreatePanelList.Items[I]).Width;
          FPositionCellData.HeightParam.Value := TWinControl(FCreatePanelList.Items[I]).Height;
          FUpdatePositionAction.Execute;
        end;
      end;
      IncProgress(1);
    finally
      Finish;
    end;
  finally
    FFocusID := nFocus;
    FTimerProcess := FTimerProcess or 4;
    FTimer.Enabled := True;
  end;
end;

{TCheckListBoxAddOn}

constructor TCheckListBoxAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FIdParam := TdsdParam.Create(nil);
  FIdParam.DataType := ftString;
  FIdParam.Value := '';
  FNameParam := TdsdParam.Create(nil);
  FNameParam.DataType := ftString;
  FNameParam.Value := '';
  FKeyList := '';
end;

destructor TCheckListBoxAddOn.Destroy;
  var I : Integer;
begin
  FNameParam.Free;
  FIdParam.Free;
  inherited;
end;


procedure TCheckListBoxAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
  var I, J : Integer;
begin
  inherited;

   if Operation = opRemove then begin
      if AComponent = FCheckListBox then
         FCheckListBox := nil
      else if AComponent = FDataSet then
         FDataSet := nil;
   end;
end;

procedure TCheckListBoxAddOn.SetDataSet(const Value: TDataSet);
  var I : Integer;
begin

  if Assigned(FDataSet) and not (csDesigning  in ComponentState) then
  begin
    FDataSet.AfterOpen := FAfterOpen;
  end;

  FDataSet := Value;
  if csDesigning  in ComponentState then Exit;
  if Assigned(FDataSet) then
  begin
    FAfterOpen := FDataSet.AfterOpen;
    FDataSet.AfterOpen := OnAfterOpen;
  end;
end;

procedure TCheckListBoxAddOn.OnAfterOpen(ADataSet: TDataSet);
begin
  if Assigned(FAfterOpen) then
     FAfterOpen(ADataSet);

  if Assigned(FCheckListBox) then FCheckListBox.Items.Clear;

  ADataSet.First;
  while not ADataSet.Eof do
  begin
    with FCheckListBox.Items.Add do
    begin
      Tag := ADataSet.FieldByName(FIdParam.Value).AsInteger;
      Text := ADataSet.FieldByName(FNameParam.Value).AsString;
    end;

    ADataSet.Next;
  end;

  if FKeyList <> '' then SetKeyList(FKeyList);
end;

function TCheckListBoxAddOn.GetKeyList: String;
  var I : Integer;
begin
  Result := '';

  if Assigned(FCheckListBox) then
  begin
    for I := 0 to FCheckListBox.Items.Count - 1 do
      if FCheckListBox.Items.Items[I].Checked then
      begin
        if Result <> '' then Result := Result + ',';
        Result := Result + IntToStr(FCheckListBox.Items.Items[I].Tag);
      end;
  end;

  FKeyList := Result;
end;

procedure TCheckListBoxAddOn.SetKeyList(const Value: String);
  var I, J : Integer; Res : TArray<string>;
begin
  FKeyList := Value;
  if Assigned(FCheckListBox) then
  begin

    for I := 0 to FCheckListBox.Items.Count - 1 do
    if FCheckListBox.Items.Items[I].Checked then FCheckListBox.Items.Items[I].Checked := False;

    if Value = '' then Exit;

    Res := TRegEx.Split(Value, ',');
    for I := 0 to High(Res) do
       for J := 0 to FCheckListBox.Items.Count - 1 do
         if IntToStr(FCheckListBox.Items.Items[J].Tag) = Res[I] then FCheckListBox.Items.Items[J].Checked := True;

  end;
end;

{ TcxCustomInnerTextEdit }

procedure TcxCurrencyEdit_check.SetButtons(Value: TcxEditButtons);
begin
  Properties.Buttons.Assign(Value);
end;

function TcxCurrencyEdit_check.GetButtons: TcxEditButtons;
begin
  Result := Properties.Buttons;
end;

procedure TcxCurrencyEdit_check.SetImages(Value: TCustomImageList);
begin
  Properties.Images := Value;
end;

function TcxCurrencyEdit_check.GetImages: TCustomImageList;
begin
  Result := Properties.Images;
end;

end.
