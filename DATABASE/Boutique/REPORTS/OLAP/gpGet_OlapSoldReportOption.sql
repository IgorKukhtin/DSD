-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpGet_OlapSoldReportOption (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OlapSoldReportOption(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (SortField Integer, FieldType TVarChar, Caption TVarChar, CaptionCode TVarChar, FieldName TVarChar, FieldCodeName TVarChar, DisplayFormat TVarChar
             , TableName TVarChar, TableSyn TVarChar, ConnectFieldName TVarChar
             , VisibleFieldName TVarChar, VisibleFieldCode TVarChar, SummaryType TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get());


     -- ���������
     RETURN QUERY
       SELECT tmp.SortField        :: Integer,  tmp.FieldType        :: TVarChar, tmp.Caption          :: TVarChar, tmp.CaptionCode :: TVarChar
            , tmp.FieldName        :: TVarChar, tmp.FieldCodeName    :: TVarChar, tmp.DisplayFormat    :: TVarChar
            , tmp.TableName        :: TVarChar, tmp.TableSyn         :: TVarChar, tmp.ConnectFieldName :: TVarChar
            , tmp.VisibleFieldName :: TVarChar, tmp.VisibleFieldCode :: TVarChar, tmp.SummaryType      :: TVarChar

       FROM (SELECT 101 AS SortField, 'data' AS FieldType, '���. ������'   AS Caption,          '' AS CaptionCode,      'Income_Amount'   AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''              AS ConnectFieldName, '' AS VisibleFieldName, ''                AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 102 AS SortField, 'data' AS FieldType, '���. �������'  AS Caption,          '' AS CaptionCode,      'Sale_Amount'     AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''              AS ConnectFieldName, '' AS VisibleFieldName, ''                AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 103 AS SortField, 'data' AS FieldType, '����� �������' AS Caption,          '' AS CaptionCode,      'Sale_Summ'       AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''              AS ConnectFieldName, '' AS VisibleFieldName, ''                AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 104 AS SortField, 'data' AS FieldType, '�\� �������'   AS Caption,          '' AS CaptionCode,      'Sale_SummCost'   AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''              AS ConnectFieldName, '' AS VisibleFieldName, ''                AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 105 AS SortField, 'data' AS FieldType, '����� �����'   AS Caption,          '' AS CaptionCode,      'Sale_Summ_10100' AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''              AS ConnectFieldName, '' AS VisibleFieldName, ''                AS VisibleFieldCode, '' AS SummaryType

       UNION SELECT 106 AS SortField, 'data' AS FieldType, '�������� ������'       AS Caption,          '' AS CaptionCode, 'Sale_Summ_10201' AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''                      AS ConnectFieldName, '' AS VisibleFieldName, ''           AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 107 AS SortField, 'data' AS FieldType, '������ outlet'         AS Caption,          '' AS CaptionCode, 'Sale_Summ_10202' AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''                      AS ConnectFieldName, '' AS VisibleFieldName, ''           AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 108 AS SortField, 'data' AS FieldType, '������ �������'        AS Caption,          '' AS CaptionCode, 'Sale_Summ_10203' AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''                      AS ConnectFieldName, '' AS VisibleFieldName, ''           AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 109 AS SortField, 'data' AS FieldType, '������ ��������������' AS Caption,          '' AS CaptionCode, 'Sale_Summ_10204' AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''                      AS ConnectFieldName, '' AS VisibleFieldName, ''           AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 110 AS SortField, 'data' AS FieldType, '������ �����'          AS Caption,          '' AS CaptionCode, 'Sale_Summ_10200' AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''                      AS ConnectFieldName, '' AS VisibleFieldName, ''           AS VisibleFieldCode, '' AS SummaryType

       UNION SELECT 111 AS SortField, 'data' AS FieldType, '���. �������'   AS Caption,          '' AS CaptionCode, 'Return_Amount'     AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''               AS ConnectFieldName, '' AS VisibleFieldName, ''             AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 113 AS SortField, 'data' AS FieldType, '����� �������'  AS Caption,          '' AS CaptionCode, 'Return_Summ'       AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''               AS ConnectFieldName, '' AS VisibleFieldName, ''             AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 114 AS SortField, 'data' AS FieldType, '�\� �������'    AS Caption,          '' AS CaptionCode, 'Return_SummCost'   AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''               AS ConnectFieldName, '' AS VisibleFieldName, ''             AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 115 AS SortField, 'data' AS FieldType, '������ �������' AS Caption,          '' AS CaptionCode, 'Return_Summ_10200' AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''               AS ConnectFieldName, '' AS VisibleFieldName, ''             AS VisibleFieldCode, '' AS SummaryType

       UNION SELECT 121 AS SortField, 'data' AS FieldType, '���. ����'      AS Caption,          '' AS CaptionCode, 'Result_Amount'     AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''               AS ConnectFieldName, '' AS VisibleFieldName, ''             AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 123 AS SortField, 'data' AS FieldType, '����� ����'     AS Caption,          '' AS CaptionCode, 'Result_Summ'       AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''               AS ConnectFieldName, '' AS VisibleFieldName, ''             AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 124 AS SortField, 'data' AS FieldType, '�\� ����'       AS Caption,          '' AS CaptionCode, 'Result_SummCost'   AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''               AS ConnectFieldName, '' AS VisibleFieldName, ''             AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 125 AS SortField, 'data' AS FieldType, '������ ����'    AS Caption,          '' AS CaptionCode, 'Result_Summ_10200' AS FieldName,        '' AS FieldCodeName, ',0.##' AS DisplayFormat
                  , ''  AS TableName, ''     AS TableSyn,  ''               AS ConnectFieldName, '' AS VisibleFieldName, ''             AS VisibleFieldCode, '' AS SummaryType


       UNION SELECT 11, 'dimension' AS FieldType, '�������� �����'    AS Caption,  ''             AS CaptionCode,      'BrandName'       AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_Brand'      AS TableSyn, 'BrandId'      AS ConnectFieldName, 'ValueData'       AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 12, 'dimension' AS FieldType, '�����'             AS Caption,  ''             AS CaptionCode,      'PeriodName'      AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_Period'     AS TableSyn, 'PeriodId'     AS ConnectFieldName, 'ValueData'       AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 13, 'dimension' AS FieldType, '���'               AS Caption,  ''             AS CaptionCode,      'PeriodYearName'  AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_PeriodYear' AS TableSyn, 'PeriodYearId' AS ConnectFieldName, 'ValueData'       AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 14, 'dimension' AS FieldType, '���������'         AS Caption,  ''             AS CaptionCode,      'PartnerName'     AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_Partner'    AS TableSyn, 'PartnerId'    AS ConnectFieldName, 'ValueData'       AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType

       UNION SELECT 21, 'dimension' AS FieldType, '������ (���)'            AS Caption, ''                    AS CaptionCode,      'GoodsGroupNameFull'   AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_GoodsGroupAll'    AS TableSyn, 'GoodsGroupId_all'   AS ConnectFieldName, 'ValueData'            AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 22, 'dimension' AS FieldType, '������'                  AS Caption,  ''                   AS CaptionCode,      'GoodsGroupName'       AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_GoodsGroup'       AS TableSyn, 'GoodsGroupId'       AS ConnectFieldName, 'ValueData'            AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 23, 'dimension' AS FieldType, '��������'                AS Caption,  ''                   AS CaptionCode,      'LabelName'            AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_Label'            AS TableSyn, 'LabelId'            AS ConnectFieldName, 'ValueData'            AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 24, 'dimension' AS FieldType, '������ �������'          AS Caption,  ''                   AS CaptionCode,      'CompositionGroupName' AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_CompositionGroup' AS TableSyn, 'CompositionGroupId' AS ConnectFieldName, 'ValueData'            AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType

       UNION SELECT 31, 'dimension' AS FieldType, '������'             AS Caption,  ''              AS CaptionCode,      'CompositionName' AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_Composition' AS TableSyn, 'CompositionId' AS ConnectFieldName, 'ValueData'       AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 32, 'dimension' AS FieldType, '��������'           AS Caption,  ''              AS CaptionCode,      'GoodsInfoName'   AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_GoodsInfo'   AS TableSyn, 'GoodsInfoId'   AS ConnectFieldName, 'ValueData'       AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 33, 'dimension' AS FieldType, '�����'              AS Caption,  ''              AS CaptionCode,      'LineFabricaName' AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_LineFabrica' AS TableSyn, 'LineFabricaId' AS ConnectFieldName, 'ValueData'       AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 34, 'dimension' AS FieldType, '�������'            AS Caption,  ''              AS CaptionCode,      'FabrikaName'     AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_Fabrika'     AS TableSyn, 'FabrikaId'     AS ConnectFieldName, 'ValueData'       AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 35, 'dimension' AS FieldType, '������'             AS Caption,  ''              AS CaptionCode,      'GoodsSizeName'   AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_GoodsSize'   AS TableSyn, 'GoodsSizeId'   AS ConnectFieldName, 'ValueData'       AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType

       UNION SELECT 41, 'dimension' AS FieldType, '�������������'  AS Caption,  ''          AS CaptionCode,      'UnitName'    AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_Unit'    AS TableSyn, 'UnitId'    AS ConnectFieldName, 'ValueData'   AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType
       UNION SELECT 42, 'dimension' AS FieldType, '�������������'  AS Caption,  ''          AS CaptionCode,      'UnitName_in' AS FieldName,        '' AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_Unit_in' AS TableSyn, 'UnitId_in' AS ConnectFieldName, 'ValueData'   AS VisibleFieldName, '' AS VisibleFieldCode, '' AS SummaryType

       UNION SELECT 51, 'dimension' AS FieldType, '�������'        AS Caption,  '��� ���.'  AS CaptionCode,      'GoodsName'   AS FieldName,        'GoodsCode'  AS FieldCodeName,    '' AS DisplayFormat
                      , 'Object'    AS TableName, 'Object_Goods'   AS TableSyn, 'GoodsId'   AS ConnectFieldName, 'ValueData'   AS VisibleFieldName, 'ObjectCode' AS VisibleFieldCode, '' AS SummaryType
            ) AS tmp
         
     ORDER BY 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.18                                        *
*/

-- ����
-- SELECT * FROM gpGet_OlapSoldReportOption (zfCalc_UserAdmin())
