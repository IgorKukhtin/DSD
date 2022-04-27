unit dsdOlap;

interface
uses Classes, DB;

type

  TSummaryType = (stNone, stSum, stMin, stMax, stCount, stAverage, stUniqueCount, stPercent);
  TAreaType = (atFilter, atVertical, atHorisontal, atData);
  TShowDate = (sdYear, sdMonth, sdDay, sdWeek, sdDayOfWeek);
  TShowDateSet = set of TShowDate;

  TDateOLAPField = class;
  TOlapReportOption = class;

  // Интрефейс итератора  {}
  IIterator = interface
    function GetName: string;
    property Name: string read GetName;
    function HasNextItem: boolean;
    function Item: Variant;
  end;{IIterator}

  // Итератор по датам. В зависимости от параметра переданного в DateOLAPField итератор работает по дням, неделям, месяцам или годам
  TDateIterator = class (TInterfacedObject, IIterator)
  private
    FDateOLAPField: TDateOLAPField;
    FCurrentDate, FDateFrom, FDateTo: TDateTime;
    FIncrement: integer;
    function GetName: string;
    function HasNextItem: boolean;
    function Item: Variant;
  public
    constructor Create(PDateFrom, PDateTo: TDateTime; PDateOLAPField: TDateOLAPField);
  end;

  // базовый класс для хранения данных о полях ОЛАП отчета
  TOLAPField = class
    // Отображаемый заголовок поля
    Caption: string;
    // Ключ поля
    FieldName: string;
    // Отображается ли поле в
    Visible: boolean;
    // Тип поля 
    FieldType: TFieldType;
    // Возвращается строка поля запроса
    function GetSelectSQL: string; virtual; abstract;
    // Формирование строки GROUP
    function GetSelectGroupSQL: string; virtual; abstract;
    // Строим PIVOT выражение в запросе
    function GetPivotSQL: string; virtual;
    // Возвращаем сточку построения JOIN выражения
    function GetJoinSQL: string; virtual;

    function GetGroupSQL: string; virtual;
    // Построение условия WHERE
    function GetWhereCondition: string; virtual;
    constructor Create;
  end;

  // класс для хранения данных о полях данных ОЛАП отчета
  TDataOLAPField = class(TOLAPField)
  private
    // Обязательные поля для вычислимых значений
    FObligatoryFields: TStringList;
    // возвращает формирование SQL запроса по агрегатным функциям
    function GetAgregatFuncData: string;
    function GetFieldCount: integer;
    function GetObject(Index: Variant): TOLAPField;
    procedure SetObject(Index: Variant; const Value: TOLAPField);
  public
    CountFieldName: string;
    // Тип группировки данных
    SummaryType: TSummaryType;
    // Формат отображения данного
    DisplayFormat: String;
    // Сложное условие
    Condition: String;
    // Количество обязательных полей для вычислимых значений
    property ObligatoryFieldCount: integer read GetFieldCount;
    // Обязательные поля для вычислимых значений
    property ObligatoryObjects[Index: Variant]: TOLAPField read GetObject write SetObject;
    // Возвращается строка поля запроса
    function GetSelectSQL: string; override;
    // Формирование строки GROUP
    function GetSelectGroupSQL: string; override;
    // Строим PIVOT выражение в запросе
    function GetPivotSQL: string; override;
    // Построение условия WHERE
    function GetWhereCondition: string; override;
    constructor Create;
  end;

  // класс для хранения данных о полях аналитик ОЛАП отчета
  TDimensionOLAPField = class(TOLAPField)
    // Таблица, где хранятся нахвания аналитик
    TableName: string;
    // Синоним таблицы
    TableSyn: string;
    ConnectFieldName: string;
    VisibleFieldName: Variant;
    Area: TAreaType;
    AreaIndex: integer;
    FilterList: TStringList;
    Alignment: Variant;
    function GetSelectSQL: string; override;
    function GetSelectGroupSQL: string; override;
    function GetJoinSQL: string; override;
    function GetGroupSQL: string; override;
    function GetFilterSQL: string;
    constructor Create;
  end;

  // Класс для работы с полями типа Дата
  TDateOLAPField = class(TOLAPField)
  private
    FOlapReportOption: TOlapReportOption;
  public
    ShowDateType: TShowDateSet;
    function GetSelectSQL: string; override;
    function GetSelectGroupSQL: string; override;
    function GetGroupSQL: string; override;
    constructor Create(OlapReportOption: TOlapReportOption);
  end;

  // Хранится структура для формирования отчета
  TOlapReportOption = class
  private
    FFields: TStringList;
    FisCreateDate: boolean;
    FisOLAPonServer: boolean;
    FSummaryType: TSummaryType;
    function GetFieldCount: integer;
    function GetObject(Index: Variant): TOLAPField;
    function GetXMLScheme: string;
    procedure PutXMLScheme(const Value: string);
    function GetDoc_Date: string;
  public
    FromDate, ToDate: TDateTime;
    BusinessId : Integer;
    isPeriodYear: Boolean;
    // Тип сумм
    property SummaryType: TSummaryType read FSummaryType write FSummaryType;
    // Флаг указывает где строится OLAP представление на сервере или на клиенте
    property isOLAPonServer: boolean read FisOLAPonServer write FisOLAPonServer;
    // Флаг указывает строить ли отчет по дате создания документов или по дате документов
    property isCreateDate: boolean read FisCreateDate write FisCreateDate;
    // поле для сериализация и десериализации объекта в XML структуру
    property XMLScheme: string read GetXMLScheme write PutXMLScheme;
    // количество полей в структуре
    property FieldCount: integer read GetFieldCount;
    // массив полей сструктуры
    property Objects[Index: Variant]: TOLAPField read GetObject;
    // Возвращает итератор для формирования отчета
    function GetIterator: IIterator;
    // Настройка данных для построения OLAP отчета. Задаем жесткую структуру полей
    constructor Create(DataSet: TDataSet);
    destructor Destroy; override;
  end;

  // Класс подготавливает данные для отображения отчета
  TOlap = class
  public
    class function CheckReportOption(OlapReportOption: TOlapReportOption;
       var PMessage: string): boolean;
    // если isCount = true то возвращаем SQL только для подсчета количества строк
    class function CreateSQLExpression(OlapReportOption: TOlapReportOption;
          FieldDefs: TFieldDefs; DataList: TStringList): string;
  end;

implementation

uses SysUtils, DateUtils, Variants, dsdOLAPXMLBind, TypInfo;

{ TELOlapSalers }

// Из-за частого использования делаем функцию убирающую лидирующую запятую
function TrimComma(PString: string): string;
begin
  result := Copy(PString, Pos(',', PString) + 1, Length(PString))
end;

class function TOlap.CheckReportOption(OlapReportOption: TOlapReportOption;
  var PMessage: string): boolean;
var
  LisDimensionChosen: boolean;
  LisDataChosen: boolean;
  LDateCount: integer;
  i: integer;
begin
  LisDimensionChosen := false;
  LisDataChosen := false;
  LDateCount := 0;

  for i := 0 to OlapReportOption.FieldCount - 1 do
      if OlapReportOption.Objects[i].Visible then begin
         if OlapReportOption.Objects[i] is TDataOLAPField then LisDataChosen := true;
         if OlapReportOption.Objects[i] is TDimensionOLAPField then LisDimensionChosen := true;
         if OlapReportOption.Objects[i] is TDateOLAPField then begin
            inc(LDateCount);
            LisDimensionChosen := true;
         end;
      end;

  if not LisDimensionChosen then begin
    PMessage := 'Выберите хотя бы один фильтр или дату';
    result := false;
    exit;
  end;

  if not LisDataChosen then begin
    PMessage := 'Выберите хотя бы одно данное';
    result := false;
    exit;
  end;

  if OlapReportOption.isOLAPonServer and (LDateCount <> 1) then begin
    PMessage := 'Для обычного представления необходимо выбрать один тип даты';
    result := false;
    exit;
  end;

  result := true;
end;

class function TOlap.CreateSQLExpression(OlapReportOption: TOlapReportOption;
   FieldDefs: TFieldDefs; DataList: TStringList): string;
var
  i, j: integer;
  SelectSQL: string;
  SelectGroupSQL: string;
  JoinSQL: string;
  GroupBySQL: string;
  PivotSQL: string;
  DateGroup: string;
  WhereCondition: string;
  FilterSQL: string;
  LMessage: string;
  PivotDimensionSQL: TStringList;

  lSelectGroupSQL,lGroupBySQL,lJoinSQL : string;

  YearStart, YearEnd, Month, Day: Word;

  BusinessId_str : String;
begin
  if not CheckReportOption (OlapReportOption, LMessage) then
     raise Exception.Create(LMessage);

  for i := 0 to OlapReportOption.FFields.Count - 1 do
    with TOLAPField(OlapReportOption.FFields.Objects[i]) do begin
      {Фильтр ставим в любом случае}
      if OlapReportOption.FFields.Objects[i] is TDimensionOLAPField then
         FilterSQL := FilterSQL + (OlapReportOption.FFields.Objects[i] as TDimensionOLAPField).GetFilterSQL;
      if Visible then begin
         if (OlapReportOption.FFields.Objects[i] is TDimensionOLAPField)
             or (not OlapReportOption.isOLAPonServer) then
         begin
            if FieldType = ftString then
               FieldDefs.Add(FieldName, FieldType, 250)
            else
               FieldDefs.Add(FieldName, FieldType);
            //
            if OlapReportOption.FFields.Objects[i] is TDataOLAPField then
               DataList.Add(FieldName)
         end;
         //
         lSelectGroupSQL:=GetSelectGroupSQL;
         if System.Pos(''+ lSelectGroupSQL + '', SelectGroupSQL) = 0 then SelectGroupSQL := SelectGroupSQL + lSelectGroupSQL;
         lGroupBySQL := GetGroupSQL;
         if System.Pos(''+ lGroupBySQL + '', GroupBySQL) = 0 then GroupBySQL := GroupBySQL + lGroupBySQL;
         lJoinSQL:=GetJoinSQL;
         if System.Pos(''+ lJoinSQL + '', JoinSQL) = 0 then JoinSQL := JoinSQL + lJoinSQL;

         SelectSQL := SelectSQL + GetSelectSQL;
         PivotSQL := PivotSQL + GetPivotSQL;
         WhereCondition := WhereCondition + GetWhereCondition;
       end;
    end;

  // Убираем лидирующую запятую
  SelectSQL := TrimComma(SelectSQL);
  PivotSQL := TrimComma(PivotSQL);
  GroupBySQL := TrimComma(GroupBySQL);
  SelectGroupSQL := TrimComma(SelectGroupSQL);

  if WhereCondition <> '' then
     // Убираем первый OR
     WhereCondition := ' HAVING ' + Copy(WhereCondition, Pos('OR', WhereCondition) + 3, Length(WhereCondition));


  DecodeDate(OlapReportOption.FromDate, YearStart, Month, Day);
  DecodeDate(OlapReportOption.ToDate, YearEnd, Month, Day);

  if OlapReportOption.BusinessId > 0 then BusinessId_str:= ' and BusinessId = ' + IntToStr(OlapReportOption.BusinessId);

  if OlapReportOption.isPeriodYear = TRUE
  then
      result := 'SELECT ' + SelectSQL + ' FROM ( SELECT ' + SelectGroupSQL
             + ' FROM SoldTable'
             + ' WHERE SoldTable.PeriodYear BETWEEN '
                       + IntToStr(YearStart) + ' AND ' + IntToStr(YearEnd)
                       + BusinessId_str
                       + FilterSQL
             + ' GROUP BY ' + GroupBySQL + WhereCondition + ' ) OlapTable ' + JoinSQL
  else
      result := 'SELECT ' + SelectSQL + ' FROM ( SELECT ' + SelectGroupSQL +
        ' FROM SoldTable' +
        ' WHERE ' + OlapReportOption.GetDoc_Date + ' BETWEEN ''' +
                   FormatDateTime('dd.mm.yyyy', OlapReportOption.FromDate) + ''' AND ''' +
                   FormatDateTime('dd.mm.yyyy', OlapReportOption.ToDate) + ''''
                  + BusinessId_str
                  + FilterSQL +
        ' GROUP BY ' + GroupBySQL + WhereCondition + ' ) OlapTable ' + JoinSQL;

  if OlapReportOption.isOLAPonServer then begin
     PivotDimensionSQL := TStringList.Create;
     with OlapReportOption.GetIterator do begin
       DateGroup := Name;
       while HasNextItem do begin
         if PivotDimensionSQL.IndexOf(Item) = -1 then
            PivotDimensionSQL.Add(Item);
       end;
     end;
     for j := 0 to PivotDimensionSQL.Count - 1 do
       for i := 0 to OlapReportOption.FFields.Count - 1 do
           with TOLAPField(OlapReportOption.FFields.Objects[i]) do
             if Visible and (OlapReportOption.FFields.Objects[i] is TDataOLAPField) then begin
               if FieldType = ftString then
                  FieldDefs.Add(PivotDimensionSQL[j] + '_' + FieldName, FieldType, 250)
               else
                  FieldDefs.Add(PivotDimensionSQL[j] + '_' + FieldName, FieldType);
               DataList.Add(PivotDimensionSQL[j] + '_' + FieldName)
             end;

     result := 'SELECT * FROM (' + result + ')' +
               'PIVOT (' + PivotSQL + ' FOR ' + DateGroup + ' IN (' + PivotDimensionSQL.CommaText + '))';
  end;
end;

{ TOlapReportOption }

constructor TOlapReportOption.Create(DataSet: TDataSet);
var
  OLAPField: TDataOLAPField;
  DimensionOLAPField: TDimensionOLAPField;
  DateOLAPField: TDateOLAPField;
  FieldNameList: TStringList;
  i: integer;
begin
  isPeriodYear := false;
  isOLAPonServer := false;
  isCreateDate := false;
  SummaryType := stNone;
  FieldNameList := TStringList.Create;

  FFields := TStringList.Create;

  with DataSet do begin
    First;
    while not EOF do begin
       if FieldByName('FieldType').AsString = 'data' then
       begin
         OLAPField := TDataOLAPField.Create;
         OLAPField.Caption  := FieldByName('Caption').asString;
         OLAPField.FieldName:= FieldByName('FieldName').asString;
         // Устанавливаем данные для расчета
         if FieldByName('SummaryType').asString <> '' then begin
            OLAPField.SummaryType := TSummaryType(GetEnumValue(TypeInfo(TSummaryType), FieldByName('SummaryType').asString));
            OLAPField.Condition := FieldByName('VisibleFieldName').asString;
            FieldNameList.DelimitedText := FieldByName('ConnectFieldName').asString;
            for I := 0 to FieldNameList.Count - 1 do
                OLAPField.ObligatoryObjects[i] := Objects[FieldNameList[i]];
         end;
         FFields.AddObject(OLAPField.FieldName, OLAPField);
       end;
       if FieldByName('FieldType').AsString = 'dimension' then
       begin
        DimensionOLAPField := TDimensionOLAPField.Create;
        DimensionOLAPField.Caption := FieldByName('Caption').asString;
        DimensionOLAPField.FieldName := FieldByName('FieldName').asString;
        DimensionOLAPField.TableName := FieldByName('TableName').asString;
        DimensionOLAPField.TableSyn := FieldByName('TableSyn').asString;;
        DimensionOLAPField.ConnectFieldName := FieldByName('ConnectFieldName').asString;
        DimensionOLAPField.VisibleFieldName := FieldByName('VisibleFieldName').asString;
        FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);
       end;
       Next;
    end;
  end;

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := 'Год';
  DateOLAPField.FieldName := 'YEAR_DATE_DOC';
  DateOLAPField.ShowDateType := [sdYear];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := 'Месяц';
  DateOLAPField.FieldName := 'MONTH_DATE_DOC';
  DateOLAPField.ShowDateType := [sdMonth];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := 'Месяц и год';
  DateOLAPField.FieldName := 'MONTH_YEAR_DATE_DOC';
  DateOLAPField.ShowDateType := [sdMonth, sdYear];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := 'Неделя';
  DateOLAPField.FieldName := 'WEEK_DATE_DOC';
  DateOLAPField.ShowDateType := [sdWeek];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := 'День недели';
  DateOLAPField.FieldName := 'DAYOFWEEK_DATE_DOC';
  DateOLAPField.ShowDateType := [sdDayOfWeek];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := 'Дата';
  DateOLAPField.FieldName := 'DATE_DOC';
  DateOLAPField.ShowDateType := [sdYear, sdMonth, sdDay];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);
end;

destructor TOlapReportOption.Destroy;
begin
  FFields.Free;
end;

function TOlapReportOption.GetDoc_Date: string;
begin
  if isCreateDate then
     result := 'OperDate'
  else
     result := 'OperDate'
end;

function TOlapReportOption.GetFieldCount: integer;
begin
  result := FFields.Count
end;

function TOlapReportOption.GetIterator: IIterator;
var i: integer;
begin
  for i := 0 to FFields.Count - 1 do
      if Objects[i].Visible and (Objects[i] is TDateOLAPField) then begin
         result := TDateIterator.Create(FromDate, ToDate, Objects[i] as TDateOLAPField);
         break;
       end;
end;

function TOlapReportOption.GetObject(Index: Variant): TOLAPField;
var i: integer;
begin
  result := nil;
  if VarIsStr(Index) then begin
     i := FFields.IndexOf(Index);
     if i > -1 then
        result := TOLAPField(FFields.Objects[i])
  end
  else
     if VarIsOrdinal(Index) then
        result := TOLAPField(FFields.Objects[Index])
     else
        raise Exception.Create('Не правильный тип индекса');
end;

function TOlapReportOption.GetXMLScheme: string;
var i: integer;
begin
  result := '<items isOLAPonServer = "' + BoolToStr(isOLAPonServer) +
                 '" isCreateDate = "' + BoolToStr(isCreateDate) +
                 '" SummaryType = "' + IntToStr(Integer(SummaryType)) + '" >';
  for i := 0 to FieldCount - 1 do
      result := result + '<item name = "' + Objects[i].FieldName + '" visible = "' + BoolToStr(Objects[i].Visible) + '" />';
  result := result + '</items>';
end;

procedure TOlapReportOption.PutXMLScheme(const Value: string);
var i: integer;
begin
  with Getitems(Value) do begin
    Self.isOLAPonServer := isOLAPonServer;
    Self.isCreateDate := isCreateDate;
    Self.SummaryType := TSummaryType(SummaryType);
    for i := 0 to Count - 1 do
      if Assigned(Objects[Item[i].Name]) then
         Objects[Item[i].Name].Visible := Item[i].Visible;
  end;
end;

{ TOLAPField }

constructor TOLAPField.Create;
begin
  Visible := false;
end;

function TOLAPField.GetGroupSQL: string;
begin
  result := '';
end;

function TOLAPField.GetJoinSQL: string;
begin
  result := '';
end;

function TOLAPField.GetPivotSQL: string;
begin
  result := '';
end;

function TOLAPField.GetWhereCondition: string;
begin
  result := ''
end;

{ TDataOLAPField }

constructor TDataOLAPField.Create;
begin
  SummaryType := stSum;
  DisplayFormat := ',0.00';
  FObligatoryFields := TStringList.Create;
  FieldType := ftFloat;
end;

function TDataOLAPField.GetAgregatFuncData: string;
begin
  case SummaryType of
    stSum: result := 'SUM(' + FieldName + ') ';
    stUniqueCount: result := ' COUNT(DISTINCT ' + CountFieldName + ') ';
    stPercent: result := Condition;
  end;
end;

function TDataOLAPField.GetFieldCount: integer;
begin
  result := FObligatoryFields.Count;
end;

procedure TDataOLAPField.SetObject(Index: Variant; const Value: TOLAPField);
begin
  FObligatoryFields.InsertObject(Index, Value.FieldName, Value)
end;

function TDataOLAPField.GetObject(Index: Variant): TOLAPField;
begin
  if VarIsStr(Index) then
     result := TOLAPField(FObligatoryFields.Objects[FObligatoryFields.IndexOf(Index)]) else
     if VarIsOrdinal(Index) then
        result := TOLAPField(FObligatoryFields.Objects[Index])
     else
        raise Exception.Create('Не правильный тип индекса');
end;

function TDataOLAPField.GetPivotSQL: string;
begin
  case SummaryType of
    stSum: result := GetSelectGroupSQL;
    stUniqueCount: result := ', MAX( ' + FieldName + ') AS ' + FieldName;
    stPercent: result := ' , SUM(' + FieldName + ') AS ' + FieldName;
  end;
end;

function TDataOLAPField.GetSelectGroupSQL: string;
begin
  result := ' , ' + GetAgregatFuncData + ' AS ' + FieldName;
end;

function TDataOLAPField.GetSelectSQL: string;
begin
  result := ', OlapTable.' + FieldName
end;

function TDataOLAPField.GetWhereCondition: string;
begin
  result := ' OR (' + GetAgregatFuncData + ') <> 0 ';
end;

{ TDimenshionOLAPField }

constructor TDimensionOLAPField.Create;
begin
  inherited;
  VisibleFieldName := 'NAME';
  FilterList := TStringList.Create;
  FieldType := ftString;
  Alignment := null;
end;

function TDimensionOLAPField.GetGroupSQL: string;
begin
  if FieldName = 'DELIV_TIME' then
     result := ', DELIV_TIME'
  else
     result := GetSelectGroupSQL
end;

function TDimensionOLAPField.GetJoinSQL: string;
begin
  // В случае если выбирается поле из главной таблицы
  if TableName = '' then
     result := ''
  else
     result := ' LEFT JOIN ' + TableName + ' ' + TableSyn +
                      ' ON ' + TableSyn + '.ID = OlapTable.' + ConnectFieldName
end;

function TDimensionOLAPField.GetSelectGroupSQL: string;
begin
  if FieldName = 'DELIV_TIME' then
     result := ', DELIV_TIME'
  else
     result := ', ' + ConnectFieldName
end;

function TDimensionOLAPField.GetSelectSQL: string;
var i: integer;
begin
  if FieldName = 'DELIV_TIME' then
     result := ', DELIV_TIME'
  else begin
    // В случае если выбирается поле из главной таблицы
    if TableName = '' then
       result := ', OlapTable.' + ConnectFieldName + ' ' + FieldName
    else begin
      // Если надо вывести несколько полей сразу
      if VarType(VisibleFieldName) = 8204 then
      begin
        result := '';
        for i := VarArrayLowBound(VisibleFieldName, 1) to VarArrayHighBound(VisibleFieldName, 1) do begin
           if i = VarArrayHighBound(VisibleFieldName, 1) then
              result := result + TableSyn + '.' + VisibleFieldName[i]
           else
              result := TableSyn + '.' + VisibleFieldName[i] + result + '||''' +' '+ '''||';
        end;
        result := ', ' + result + ' AS ' + FieldName;
      end
      else
        result := ', ' + TableSyn + '.' + VisibleFieldName + ' AS ' + FieldName;
    end;
  end
end;

function TDimensionOLAPField.GetFilterSQL: string;
begin
  result := '';
  if FilterList.Count > 0 then
     result := ' AND ' + ConnectFieldName + ' IN (' + FilterList.CommaText + ')';
end;

{ TDateOLAPField }

constructor TDateOLAPField.Create(OlapReportOption: TOlapReportOption);
begin
  inherited Create;
  FOlapReportOption := OlapReportOption;
  if [sdYear, sdMonth, sdDay] = ShowDateType then
     FieldType := ftDate
  else
     FieldType := ftString
end;

function TDateOLAPField.GetGroupSQL: string;
begin
  if [sdYear, sdMonth, sdDay] = ShowDateType then
    result := ' , extract( epoch from ' + FOlapReportOption.GetDoc_Date + ')::BIGINT '
  else
  begin // Если надо вычленить какую-нить часть
    result := '';
    if sdDay in ShowDateType then
       result := 'DD';
    if sdMonth in ShowDateType then
       if result = '' then
          result := 'MM'
       else
          result := result + '.MM';
    if sdYear in ShowDateType then
      if result = '' then
         result := 'YYYY'
      else
         result := result + '.YYYY';
    if sdDayOfWeek in ShowDateType then
       result := 'D';
    if sdWeek in ShowDateType then
       result := 'IW';
    result := ', TO_CHAR(' + FOlapReportOption.GetDoc_Date + ', ''' + result +''')';
  end;
end;

function TDateOLAPField.GetSelectGroupSQL: string;
begin
  result := GetGroupSQL + ' AS ' + FieldName;
end;

function TDateOLAPField.GetSelectSQL: string;
begin
  result := ', OlapTable.' + FieldName;
end;

{ TDateIterator }

constructor TDateIterator.Create(PDateFrom, PDateTo: TDateTime; PDateOLAPField: TDateOLAPField);
begin
  FDateFrom := PDateFrom;
  FDateTo := PDateTo;
  FCurrentDate := 0;
  FDateOLAPField := PDateOLAPField;
  FIncrement := 1;
end;

function TDateIterator.GetName: string;
begin
  result := FDateOLAPField.FieldName
end;

function TDateIterator.HasNextItem: boolean;
begin
  if FCurrentDate = 0 then
    FCurrentDate := FDateFrom
  else
    if (sdDay in FDateOLAPField.ShowDateType) or (sdDayOfWeek in FDateOLAPField.ShowDateType) then
       FCurrentDate := IncDay(FCurrentDate)
    else
      if sdWeek in FDateOLAPField.ShowDateType then
         FCurrentDate := IncWeek(FCurrentDate) - DayOfTheWeek(FCurrentDate) + 1
      else
         if sdMonth in FDateOLAPField.ShowDateType then
            FCurrentDate := IncMonth(FCurrentDate) - DayOfTheMonth(IncMonth(FCurrentDate)) + 1
         else
           if sdYear in FDateOLAPField.ShowDateType then
              FCurrentDate := IncYear(FCurrentDate) - DayOfTheYear(IncYear(FCurrentDate)) + 1;
  result := FCurrentDate <= FDateTo;
end;

function TDateIterator.Item: Variant;
begin
  if sdDay in FDateOLAPField.ShowDateType then
     result := chr(39) + DateToStr(FCurrentDate) + chr(39) 
  else
    if sdDayOfWeek in FDateOLAPField.ShowDateType then
       result := IntToStr(DayOfWeek(FCurrentDate-1))
    else
      if sdWeek in FDateOLAPField.ShowDateType then
         result := chr(39) + FormatFloat('00', WeekOf(FCurrentDate)) + chr(39)
      else
         if sdMonth in FDateOLAPField.ShowDateType then begin
            if sdYear in FDateOLAPField.ShowDateType then
               result := chr(39) + FormatFloat('00', MonthOf(FCurrentDate)) + '.' + FormatFloat('0000', YearOf(FCurrentDate)) + chr(39)
            else
               result := chr(39) + FormatFloat('00', MonthOf(FCurrentDate)) + chr(39)
         end
         else
           if sdYear in FDateOLAPField.ShowDateType then
            result := IntToStr(YearOf(FCurrentDate))
end;

end.

