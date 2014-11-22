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

  // ��������� ���������  {}
  IIterator = interface
    function GetName: string;
    property Name: string read GetName;
    function HasNextItem: boolean;
    function Item: Variant;
  end;{IIterator}

  // �������� �� �����. � ����������� �� ��������� ����������� � DateOLAPField �������� �������� �� ����, �������, ������� ��� �����
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

  // ������� ����� ��� �������� ������ � ����� ���� ������
  TOLAPField = class
    // ������������ ��������� ����
    Caption: string;
    // ���� ����
    FieldName: string;
    // ������������ �� ���� �
    Visible: boolean;
    // ��� ���� 
    FieldType: TFieldType;
    // ������������ ������ ���� �������
    function GetSelectSQL: string; virtual; abstract;
    // ������������ ������ GROUP
    function GetSelectGroupSQL: string; virtual; abstract;
    // ������ PIVOT ��������� � �������
    function GetPivotSQL: string; virtual;
    // ���������� ������ ���������� JOIN ���������
    function GetJoinSQL: string; virtual;

    function GetGroupSQL: string; virtual;
    // ���������� ������� WHERE
    function GetWhereCondition: string; virtual;
    constructor Create;
  end;

  // ����� ��� �������� ������ � ����� ������ ���� ������
  TDataOLAPField = class(TOLAPField)
  private
    // ������������ ���� ��� ���������� ��������
    FObligatoryFields: TStringList;
    // ���������� ������������ SQL ������� �� ���������� ��������
    function GetAgregatFuncData: string;
    function GetFieldCount: integer;
    function GetObject(Index: Variant): TOLAPField;
    procedure SetObject(Index: Variant; const Value: TOLAPField);
  public
    CountFieldName: string;
    // ��� ����������� ������
    SummaryType: TSummaryType;
    // ������ ����������� �������
    DisplayFormat: String;
    // ������� �������
    Condition: String;
    // ���������� ������������ ����� ��� ���������� ��������
    property ObligatoryFieldCount: integer read GetFieldCount;
    // ������������ ���� ��� ���������� ��������
    property ObligatoryObjects[Index: Variant]: TOLAPField read GetObject write SetObject;
    // ������������ ������ ���� �������
    function GetSelectSQL: string; override;
    // ������������ ������ GROUP
    function GetSelectGroupSQL: string; override;
    // ������ PIVOT ��������� � �������
    function GetPivotSQL: string; override;
    // ���������� ������� WHERE
    function GetWhereCondition: string; override;
    constructor Create;
  end;

  // ����� ��� �������� ������ � ����� �������� ���� ������
  TDimensionOLAPField = class(TOLAPField)
    // �������, ��� �������� �������� ��������
    TableName: string;
    // ������� �������
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

  // ����� ��� ������ � ������ ���� ����
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

  // �������� ��������� ��� ������������ ������
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
    // ��� ����
    property SummaryType: TSummaryType read FSummaryType write FSummaryType;
    // ���� ��������� ��� �������� OLAP ������������� �� ������� ��� �� �������
    property isOLAPonServer: boolean read FisOLAPonServer write FisOLAPonServer;
    // ���� ��������� ������� �� ����� �� ���� �������� ���������� ��� �� ���� ����������
    property isCreateDate: boolean read FisCreateDate write FisCreateDate;
    // ���� ��� ������������ � �������������� ������� � XML ���������
    property XMLScheme: string read GetXMLScheme write PutXMLScheme;
    // ���������� ����� � ���������
    property FieldCount: integer read GetFieldCount;
    // ������ ����� ����������
    property Objects[Index: Variant]: TOLAPField read GetObject;
    // ���������� �������� ��� ������������ ������
    function GetIterator: IIterator;
    // ��������� ������ ��� ���������� OLAP ������. ������ ������� ��������� �����
    constructor Create(DataSet: TDataSet);
    destructor Destroy; override;
  end;

  // ����� �������������� ������ ��� ����������� ������
  TOlap = class
  public
    class function CheckReportOption(OlapReportOption: TOlapReportOption;
       var PMessage: string): boolean;
    // ���� isCount = true �� ���������� SQL ������ ��� �������� ���������� �����
    class function CreateSQLExpression(OlapReportOption: TOlapReportOption;
          FieldDefs: TFieldDefs; DataList: TStringList): string;
  end;

implementation

uses SysUtils, DateUtils, Variants, dsdOLAPXMLBind;

{ TELOlapSalers }

// ��-�� ������� ������������� ������ ������� ��������� ���������� �������
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
    PMessage := '�������� ���� �� ���� ������ ��� ����';
    result := false;
    exit;
  end;

  if not LisDataChosen then begin
    PMessage := '�������� ���� �� ���� ������';
    result := false;
    exit;
  end;

  if OlapReportOption.isOLAPonServer and (LDateCount <> 1) then begin
    PMessage := '��� �������� ������������� ���������� ������� ���� ��� ����';
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
begin
  if not CheckReportOption (OlapReportOption, LMessage) then
     raise Exception.Create(LMessage);

  for i := 0 to OlapReportOption.FFields.Count - 1 do
    with TOLAPField(OlapReportOption.FFields.Objects[i]) do begin
      {������ ������ � ����� ������}
      if OlapReportOption.FFields.Objects[i] is TDimensionOLAPField then
         FilterSQL := FilterSQL + (OlapReportOption.FFields.Objects[i] as TDimensionOLAPField).GetFilterSQL;
      if Visible then begin
         if (OlapReportOption.FFields.Objects[i] is TDimensionOLAPField)
             or (not OlapReportOption.isOLAPonServer) then begin
            if FieldType = ftString then
               FieldDefs.Add(FieldName, FieldType, 250)
            else
               FieldDefs.Add(FieldName, FieldType);
            if OlapReportOption.FFields.Objects[i] is TDataOLAPField then
               DataList.Add(FieldName)
         end;
         SelectSQL := SelectSQL + GetSelectSQL;
         SelectGroupSQL := SelectGroupSQL + GetSelectGroupSQL;
         PivotSQL := PivotSQL + GetPivotSQL;
         JoinSQL := JoinSQL + GetJoinSQL;
         GroupBySQL := GroupBySQL + GetGroupSQL;
         WhereCondition := WhereCondition + GetWhereCondition;
       end;
    end;

  // ������� ���������� �������
  SelectSQL := TrimComma(SelectSQL);
  PivotSQL := TrimComma(PivotSQL);
  GroupBySQL := TrimComma(GroupBySQL);
  SelectGroupSQL := TrimComma(SelectGroupSQL);

  if WhereCondition <> '' then
     // ������� ������ OR
     WhereCondition := ' HAVING ' + Copy(WhereCondition, Pos('OR', WhereCondition) + 3, Length(WhereCondition));

  result := 'SELECT ' + SelectSQL + ' FROM ( SELECT ' + SelectGroupSQL +
    ' FROM SoldTable' +
    ' WHERE ' + OlapReportOption.GetDoc_Date + ' BETWEEN ''' +
               FormatDateTime('dd.mm.yyyy', OlapReportOption.FromDate) + ''' AND ''' +
               FormatDateTime('dd.mm.yyyy', OlapReportOption.ToDate) + '''' + FilterSQL +
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
begin
  isOLAPonServer := false;
  isCreateDate := false;
  SummaryType := stNone;

  FFields := TStringList.Create;

  with DataSet do begin
    First;
    while not EOF do begin
       if FieldByName('FieldType').AsString = 'data' then
       begin
         OLAPField := TDataOLAPField.Create;
         OLAPField.Caption := FieldByName('Caption').asString;
         OLAPField.FieldName := FieldByName('FieldName').asString;
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

(*  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '����� ����������-�������';
  OLAPField.FieldName := 'SOLD_SUMM';
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '��� ����������-�������';
  OLAPField.FieldName := 'WEIGHT';
  OLAPField.DisplayFormat := ',0.0';
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '��� � ����� ����������-�������';
  OLAPField.FieldName := 'WEIGHT_WITH_TARE';
  OLAPField.DisplayFormat := ',0.0';
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '����� �����+�������';
  OLAPField.FieldName := 'EXCHANGE_SUMM';
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '��� �����+�������';
  OLAPField.FieldName := 'EXCHANGE_WEIGHT';
  OLAPField.DisplayFormat := ',0.0';
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '% �����+�������';
  OLAPField.FieldName := 'EXCHANGE_PERCENT';
  OLAPField.DisplayFormat := ',0.00';
  OLAPField.SummaryType := stPercent;
  OLAPField.Condition := 'CASE WHEN SUM(SOLD_SUMM) = 0 THEN 0 ELSE SUM(EXCHANGE_SUMM) / SUM(SOLD_SUMM) * 100 END';
  OLAPField.ObligatoryObjects[0] := Objects['SOLD_SUMM'];
  OLAPField.ObligatoryObjects[1] := Objects['EXCHANGE_SUMM'];
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '������������� ����������-�������';
  OLAPField.FieldName := 'PRIMECOST';
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '����� ����������-�������';
  OLAPField.FieldName := 'INCOME';
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '������� ����������-�������';
  OLAPField.FieldName := 'PROFIT';
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '% �������';
  OLAPField.FieldName := 'PROFIT_PERCENT';
  OLAPField.DisplayFormat := ',0.00';
  OLAPField.SummaryType := stPercent;
  OLAPField.Condition := 'CASE WHEN SUM(INCOME) = 0 THEN 0 ELSE SUM(PROFIT) / SUM(INCOME) * 100 END';
  OLAPField.ObligatoryObjects[0] := Objects['INCOME'];
  OLAPField.ObligatoryObjects[1] := Objects['PROFIT'];
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  OLAPField := TDataOLAPField.Create;
  OLAPField.Caption := '���������� � ��';
  OLAPField.FieldName := 'QTY';
  OLAPField.DisplayFormat := ',0.000';
  FFields.AddObject(OLAPField.FieldName, OLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '������';
  DimensionOLAPField.FieldName := 'BRANCH_NAME';
  DimensionOLAPField.TableName := 'DIC_PLACE';
  DimensionOLAPField.TableSyn := 'DP';
  DimensionOLAPField.ConnectFieldName := 'BRANCH_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '��������� ������ �������������';
  DimensionOLAPField.FieldName := 'GOOD_CAT_NAME';
  DimensionOLAPField.TableName := 'DIC_GOOD_CATHEGORY_PRODUCER';
  DimensionOLAPField.TableSyn := 'DGCP';
  DimensionOLAPField.ConnectFieldName := 'GOOD_CAT_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '�������������';
  DimensionOLAPField.FieldName := 'PRODUCER_NAME';
  DimensionOLAPField.TableName := 'DIC_PRODUCER';
  DimensionOLAPField.TableSyn := 'DPR';
  DimensionOLAPField.ConnectFieldName := 'PRODUCER_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '��� ������ �������������';
  DimensionOLAPField.FieldName := 'GOOD_TYPE_DISTRIBUTOR_NAME';
  DimensionOLAPField.TableName := 'DIC_GOOD_TYPE_DISTRIBUTOR';
  DimensionOLAPField.TableSyn := 'DGTD';
  DimensionOLAPField.ConnectFieldName := 'GOOD_TYPE_DISTRIBUTOR_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '����� ����� �������������';
  DimensionOLAPField.FieldName := 'MARKET_TYPE_NAME';
  DimensionOLAPField.TableName := 'DIC_MARKET_TYPE';
  DimensionOLAPField.TableSyn := 'DMT';
  DimensionOLAPField.ConnectFieldName := 'DISTRIBUTOR_MARKET_TYPE_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '��� ������ �������������';
  DimensionOLAPField.FieldName := 'GOOD_PRODUCER_TYPE_NAME';
  DimensionOLAPField.TableName := 'DIC_GOOD_TYPE_PRODUCER';
  DimensionOLAPField.TableSyn := 'DGTP';
  DimensionOLAPField.ConnectFieldName := 'GOOD_PRODUCER_TYPE_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '���';
  DimensionOLAPField.FieldName := 'GOOD_NAME';
  DimensionOLAPField.TableName := 'DIC_GOOD';
  DimensionOLAPField.TableSyn := 'DG';
  DimensionOLAPField.ConnectFieldName := 'GOOD_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '��� ���';
  DimensionOLAPField.FieldName := 'PRICE_TYPE_NAME';
  DimensionOLAPField.TableName := 'V_DIC_ALL_PRICE_TYPE';
  DimensionOLAPField.TableSyn := 'VDAPT';
  DimensionOLAPField.ConnectFieldName := 'PRICE_TYPE_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '��������';
  DimensionOLAPField.FieldName := 'CONTRACT_NAME';
  DimensionOLAPField.TableName := 'DIC_FIN_CENTRE';
  DimensionOLAPField.TableSyn := 'DFC';
  DimensionOLAPField.ConnectFieldName := 'CONTRACT_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '�������������';
  DimensionOLAPField.FieldName := 'DEPARTMENT_NAME';
  DimensionOLAPField.TableName := 'DIC_DEPARTMENT';
  DimensionOLAPField.TableSyn := 'DDEP';
  DimensionOLAPField.ConnectFieldName := 'DEPARTMENT_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '��������� ��';
  DimensionOLAPField.FieldName := 'POSITION_NAME';
  DimensionOLAPField.TableName := 'DIC_POSITION';
  DimensionOLAPField.TableSyn := 'DPOS';
  DimensionOLAPField.ConnectFieldName := 'AGENT_POSITION_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '��� ��';
  DimensionOLAPField.FieldName := 'AGENT_NAME';
  DimensionOLAPField.TableName := 'V_DIC_PERSON';
  DimensionOLAPField.TableSyn := 'VDP';
  DimensionOLAPField.VisibleFieldName := 'FULL_NAME';
  DimensionOLAPField.ConnectFieldName := 'AGENT_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '���';
  DimensionOLAPField.FieldName := 'SHOP_NAME';
  DimensionOLAPField.TableName := 'DIC_SHOP';
  DimensionOLAPField.TableSyn := 'DS';
  DimensionOLAPField.VisibleFieldName := VarArrayOf(['CODE', 'NAME']);
  DimensionOLAPField.ConnectFieldName := 'SHOP_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '����� ��������';
  DimensionOLAPField.FieldName := 'DELIV_TIME';
  DimensionOLAPField.Alignment := taCenter;
 // DimensionOLAPField.FieldType := ftDateTime;
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '�������� ����� ��������';
  DimensionOLAPField.FieldName := 'DELIV_TIME_FACT';
  DimensionOLAPField.ConnectFieldName := 'DELIV_TIME_FACT';
  DimensionOLAPField.Alignment := taCenter;
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '����������';
  DimensionOLAPField.FieldName := 'CAR_NAME';
  DimensionOLAPField.TableName := 'DIC_CAR';
  DimensionOLAPField.TableSyn := 'DC';
  DimensionOLAPField.ConnectFieldName := 'CAR_ID';
  DimensionOLAPField.Alignment := taCenter;
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '���';
  DimensionOLAPField.FieldName := 'TRANSACTOR_NAME';
  DimensionOLAPField.TableName := 'V_TD_DIC_TRANSACTOR';
  DimensionOLAPField.TableSyn := 'VTDT';
  DimensionOLAPField.VisibleFieldName := VarArrayOf(['CODE', 'NAME']);
  DimensionOLAPField.ConnectFieldName := 'CONTRACTOR_ID';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '����� ���������';
  DimensionOLAPField.FieldName := 'DOCUMENT_NUMBER';
  DimensionOLAPField.ConnectFieldName := 'DOCUMENT_NUMBER';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '���� ���������';
  DimensionOLAPField.FieldName := 'DOC_DATE_DIM';
  DimensionOLAPField.ConnectFieldName := 'DOC_DATE';
  DimensionOLAPField.FieldType := ftDateTime;
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);

  DimensionOLAPField := TDimensionOLAPField.Create;
  DimensionOLAPField.Caption := '��� ���������';
  DimensionOLAPField.FieldName := 'DOC_TAG';
  DimensionOLAPField.ConnectFieldName := 'DOC_TAG';
  FFields.AddObject(DimensionOLAPField.FieldName, DimensionOLAPField);
  *)

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := '���';
  DateOLAPField.FieldName := 'YEAR_DATE_DOC';
  DateOLAPField.ShowDateType := [sdYear];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := '�����';
  DateOLAPField.FieldName := 'MONTH_DATE_DOC';
  DateOLAPField.ShowDateType := [sdMonth];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := '����� � ���';
  DateOLAPField.FieldName := 'MONTH_YEAR_DATE_DOC';
  DateOLAPField.ShowDateType := [sdMonth, sdYear];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := '������';
  DateOLAPField.FieldName := 'WEEK_DATE_DOC';
  DateOLAPField.ShowDateType := [sdWeek];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := '���� ������';
  DateOLAPField.FieldName := 'DAYOFWEEK_DATE_DOC';
  DateOLAPField.ShowDateType := [sdDayOfWeek];
  FFields.AddObject(DateOLAPField.FieldName, DateOLAPField);

  DateOLAPField := TDateOLAPField.Create(Self);
  DateOLAPField.Caption := '����';
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
        raise Exception.Create('�� ���������� ��� �������');
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
        raise Exception.Create('�� ���������� ��� �������');
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
  // � ������ ���� ���������� ���� �� ������� �������
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
    // � ������ ���� ���������� ���� �� ������� �������
    if TableName = '' then
       result := ', OlapTable.' + ConnectFieldName + ' ' + FieldName
    else begin
      // ���� ���� ������� ��������� ����� �����
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
    result := ' , ' + FOlapReportOption.GetDoc_Date + ' '
  else
  begin // ���� ���� ��������� �����-���� �����
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

