-- Function: gpInsert_Movement_wms_ASN_LOAD(TVarChar)
-- 4.1.1 ����� � ������������

DROP FUNCTION IF EXISTS gpInsert_Movement_wms_ASN_LOAD (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Movement_wms_ASN_LOAD(
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (ProcName TVarChar, TagName TVarChar, ActionName TVarChar, RowNum Integer, RowData Text, ObjectId Integer, GroupId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName       TVarChar;
   DECLARE vbTagName        TVarChar;
   DECLARE vbTagName_detail TVarChar;
   DECLARE vbActionName     TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Movement_wms_ASN_LOAD';
     --
     vbTagName:= 'asn_load';
     --
     vbActionName:= 'set';


     -- ������� ������� ������
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        WITH tmpGoods_all AS (SELECT -- �� ����� (EAN-128)
                                     COALESCE (Object_BarCodeBox.ValueData, '') AS name
                                     -- ID ������ 
                                   , MI.sku_id
                                     -- ���������� ������ (��� �������� ���������� ���������� � ��.) 
                                   , SUM (CASE WHEN MI.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves()
                                                    THEN MI.RealWeight * 1000.0
                                               ELSE MI.Amount
                                          END) AS qty
                                     -- ���� ������������
                                   , MI.PartionDate AS production_date
                                     -- ��� (��� ������)
                                   , SUM (MI.RealWeight) AS real_weight
                                     -- ��� �����
                                   , COALESCE (Object_GoodsByGoodsKind.BoxWeight, 0.0) :: TFloat AS pack_weight
                                     -- ����� ������� �� ��������
                                   , zfCalc_inc_id_toWMS (Movement.OperDate, zfConvert_StringToFloat (MI.sku_id) :: Integer) AS inc_id
                                     -- GoodsId
                                   , Movement.GoodsId
                                     -- ObjectId
                                   , Movement.Id AS ObjectId
                              FROM Movement_WeighingProduction AS Movement
                                   INNER JOIN MI_WeighingProduction AS MI ON MI.MovementId = Movement.Id
                                                                         AND MI.isErased   = FALSE
                                                                         AND MI.ParentId   > 0 
                                   LEFT JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MI.BarCodeBoxId
                                   -- �������� ����.
                                   LEFT JOIN Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.GoodsId     = Movement.GoodsId
                                                                    AND Object_GoodsByGoodsKind.GoodsKindId = Movement.GoodsKindId
                              WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE + INTERVAL '1 DAY'
                                AND Movement.StatusId_wms IS NULL
                              GROUP BY -- �� ����� (EAN-128)
                                       Object_BarCodeBox.ValueData
                                       -- ID ������ 
                                     , MI.sku_id
                                       -- ���� ������������
                                     , MI.PartionDate
                                       -- ��� �����
                                     , COALESCE (Object_GoodsByGoodsKind.BoxWeight, 0.0)
                                       -- ����� ������� �� ��������
                                     , zfCalc_inc_id_toWMS (Movement.OperDate, zfConvert_StringToFloat (MI.sku_id) :: Integer)
                                       -- GoodsId
                                     , Movement.GoodsId
                                       -- ObjectId
                                     , Movement.Id
                             )
        -- ���������
        SELECT tmp.ProcName, tmp.TagName, tmp.ActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- �� ����� ������� (�� ������������, �� � WMS) ����� � �������, �� ��������� ��������� ��������� �ASN ���� <asn_load> �� ������ �����.
              SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , vbActionName AS ActionName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.sku_id)) :: Integer AS RowNum
                     -- XML
                   , ('<' || vbTagName
                          ||' action="' || vbActionName                     ||'"' -- ???
                            ||' name="' || tmpData.name                     ||'"' -- �� ����� (EAN-128)
                          ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ID ������ 
                             ||' qty="' || tmpData.qty          :: TVarChar ||'"' -- ���������� ������ (��� �������� ���������� ���������� � ��.) 
                 ||' production_date="' || zfConvert_DateToWMS (tmpData.production_date) :: TVarChar ||'"' -- ���� ������������
                     ||' real_weight="' || tmpData.real_weight  :: TVarChar ||'"' -- ��� (��� ������)
                     ||' pack_weight="' || tmpData.pack_weight  :: TVarChar ||'"' -- ��� �����
                          ||' inc_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ����� ������� �� ��������
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM tmpGoods_all AS tmpData
             ) AS tmp
     -- WHERE tmp.RowNum = 1
        ORDER BY 4
     -- LIMIT 1
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.19                                       *
*/
-- delete FROM Object_WMS
-- select * FROM Object_WMS
-- ����
-- SELECT * FROM gpInsert_Movement_wms_ASN_LOAD (zfCalc_UserAdmin())
