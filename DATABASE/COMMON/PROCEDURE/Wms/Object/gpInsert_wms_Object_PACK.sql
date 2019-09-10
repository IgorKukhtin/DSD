-- Function: gpInsert_wms_Object_PACK(TVarChar)
-- 3.4	���������� �������� <pack>

DROP FUNCTION IF EXISTS gpInsert_wms_Object_PACK (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Object_PACK(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_wms_Object_PACK());

     --
     vbProcName:= 'gpInsert_wms_Object_PACK';
     --
     vbTagName:= 'pack';
     --
     vbActionName:= 'set';


     -- ��������
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- ������� ������� ������
         DELETE FROM wms_Message WHERE wms_Message.GUID = inGUID; -- AND wms_Message.ProcName = vbProcName;
     END IF;


     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO wms_Message (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId, InsertDate)
        WITH tmpGoods AS (SELECT tmp.sku_id            :: Integer -- ***���������� ��� ������ � �������� ����������� �����������
                               , tmp.sku_code                     -- ����������, ��������-�������� ��� ������ ��� ����������� � �������� ������.
                               , tmp.name                         -- ������������ ������ � �������� ����������� �����������
                                 -- ��� 1-�� ��.
                               , COALESCE (tmp.WeightMin, 0) AS WeightMin
                               , COALESCE (tmp.WeightMax, 0) AS WeightMax
                               , COALESCE (tmp.WeightAvg, 0) AS WeightAvg
                                 -- ������� 1-�� ��.
                               , CASE WHEN tmp.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 0.01 ELSE COALESCE (tmp.Height, 0) END AS Height
                               , CASE WHEN tmp.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 0.01 ELSE COALESCE (tmp.Length, 0) END AS Length
                               , CASE WHEN tmp.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 0.01 ELSE COALESCE (tmp.Width, 0)  END AS Width
                                 -- ���� (E2/E3)
                               , COALESCE (tmp.GoodsPropertyBoxId, 0) AS GoodsPropertyBoxId
                               , COALESCE (tmp.BoxId, 0) AS BoxId, COALESCE (tmp.BoxCode, 0) AS BoxCode, COALESCE (tmp.BoxName, '') AS BoxName
                               , COALESCE (tmp.WeightOnBox, 0)    AS WeightOnBox              -- ���-�� ��. � ��. (E2/E3)
                               , COALESCE (tmp.CountOnBox, 0)     AS CountOnBox               -- ���-�� ��. � ��. (E2/E3)
                               , COALESCE (tmp.BoxVolume, 0)      AS BoxVolume                -- ����� ��., �3. (E2/E3)
                               , COALESCE (tmp.BoxWeight, 0)      AS BoxWeight                -- ��� ������� ��. (E2/E3)
                               , COALESCE (tmp.BoxHeight, 0)      AS BoxHeight                -- ������ ��. (E2/E3)
                               , COALESCE (tmp.BoxLength, 0)      AS BoxLength                -- ����� ��. (E2/E3)
                               , COALESCE (tmp.BoxWidth, 0)       AS BoxWidth                 -- ������ ��. (E2/E3)
                               , COALESCE (tmp.WeightGross, 0)    AS WeightGross              -- ��� ������ ������� ����� "�� ???" (E2/E3)
                               , COALESCE (tmp.WeightAvgGross, 0) AS WeightAvgGross           -- ��� ������ ������� ����� "�� �������� ����" (E2/E3)
                               , COALESCE (tmp.WeightAvgNet, 0)   AS WeightAvgNet             -- ��� ����� ������� ����� "�� �������� ����" (E2/E3)
                          FROM lpSelect_wms_Object_SKU() AS tmp
                         )
              --
            , tmpData AS (-- unit � ��������� ��������
                          SELECT tmpGoods.sku_id                 AS pack_id
                               , tmpGoods.sku_id                 AS sku_id
                               -- ���������� �������� ��������
                               , tmpGoods.name                   AS description
                               --
                               , '-'                 :: TVarChar AS barcode
                               -- ������� �������� ��������: t � �������� �������� ���������; f � �� �������� �������� ��������� �������� �� ��������� t
                               , 't'                 :: TVarChar AS is_main
                               -- ��� ��������: ��������� ��������
                               , 'unit'              :: TVarChar AS ctn_type
                               -- ������� �������� (������������� �������� �� ������� ������� ������). ��� ��������� �������� ����� 0. 
                               , '0'                 :: TVarChar AS code_id
                               -- ���������� ��������� ��������, �.�. ���������� ��������� ���������
                               , 1                   :: Integer  AS units
                               -- ���������� ��������� �������� � ������
                               , 1                   :: Integer  AS base_units
                               -- �������� ������, �.�. ��� ����� ��������� �������
                               , 0                   :: Integer  AS layer_qty
                               -- ������ �������� (��)
                               , tmpGoods.Width      :: TFloat   AS width
                               -- ����� �������� (��)
                               , tmpGoods.Length     :: TFloat   AS length
                               -- ������ �������� (��)
                               , tmpGoods.Height     :: TFloat   AS height
                               -- ��� �������� (��)
                               , 0                   :: TFloat   AS weight
                               -- ��� ������ �������� (��) � �������� ��������, ������ ��� ������ ����� ������������ � ASN-���������
                               , tmpGoods.WeightAvg  :: TFloat   AS weight_brutto
                               --
                               , 1 AS GroupId
                          FROM tmpGoods
                        --WHERE tmpGoods.sku_id IN (34570361)

                         UNION ALL
                          -- carton � ���������� ��������
                          SELECT tmpGoods.GoodsPropertyBoxId     AS pack_id
                               , tmpGoods.sku_id                 AS sku_id
                                 -- ���������� �������� ��������
                               , tmpGoods.name                   AS description
                               --
                               , '-'                 :: TVarChar AS barcode
                               -- ������� �������� ��������: t � �������� �������� ���������; f � �� �������� �������� ��������� �������� �� ��������� t
                               , 't'                 :: TVarChar AS is_main
                               -- ��� ��������: ���������� ��������
                               , 'carton'            :: TVarChar AS ctn_type
                               -- ������� �������� (������������� �������� �� ������� ������� ������). ��� ��������� �������� ����� 0. 
                               , tmpGoods.sku_id     :: TVarChar AS code_id
                               -- ���������� ��������� ��������, �.�. ���������� ��������� ���������
                               , CEIL (CASE WHEN tmpGoods.WeightAvg > 0 THEN tmpGoods.WeightAvgNet / tmpGoods.WeightAvg ELSE 1 END) :: Integer AS units
                               -- ���������� ��������� �������� � ������
                               , CEIL (CASE WHEN tmpGoods.WeightAvg > 0 THEN tmpGoods.WeightAvgNet / tmpGoods.WeightAvg ELSE 1 END) :: Integer AS base_units
                               -- �������� ������, �.�. ��� ����� ��������� �������
                               , 0                   :: Integer  AS layer_qty
                               -- ������ �������� (��)
                               , tmpGoods.BoxWidth   :: TFloat   AS width
                               -- ����� �������� (��)
                               , tmpGoods.BoxLength  :: TFloat   AS length
                               -- ������ �������� (��)
                               , tmpGoods.BoxHeight  :: TFloat   AS height
                               -- ��� �������� (��)
                               , tmpGoods.BoxWeight  :: TFloat   AS weight
                               -- ��� ������ �������� (��) � �������� ��������, ������ ��� ������ ����� ������������ � ASN-���������
                               , tmpGoods.WeightAvg  :: TFloat   AS weight_brutto
                               --
                               , 2 AS GroupId
                          FROM tmpGoods
                          WHERE tmpGoods.BoxId > 0
                          --AND tmpGoods.sku_id = 795223
                         ) 
        -- ���������
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                -- , (ROW_NUMBER() OVER (PARTITION BY tmpData.GroupId ORDER BY tmpData.GroupId, tmpData.sku_id) :: Integer) AS RowNum
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.GroupId, tmpData.sku_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- ���������� ������������� ���������
                          ||' action="' || vbActionName                              ||'"' -- ???
                         ||' pack_id="' || tmpData.pack_id               :: TVarChar ||'"' -- ���������� ��� ��������
                          ||' sku_id="' || tmpData.sku_id                :: TVarChar ||'"' -- ���������� ��� ������ � ����������� ����������� 
                     ||' description="' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.description, CHR(39), '`'), '"', '`') ||'"' -- ���������� �������� ��������
                         ||' barcode="' || tmpData.barcode                           ||'"' -- 
                         ||' is_main="' || tmpData.is_main                           ||'"' -- ������� �������� ��������: t � �������� �������� ���������; f � �� �������� �������� ��������� �������� �� ��������� t
                        ||' ctn_type="' || tmpData.ctn_type                          ||'"' -- ��� ��������: unit � ��������� �������� carton � ���������� ��������
                         ||' code_id="' || tmpData.code_id                           ||'"' -- ������� �������� (������������� �������� �� ������� ������� ������). ��� ��������� �������� ����� 0. 
                           ||' units="' || tmpData.units                 :: TVarChar ||'"' -- ���������� ��������� ��������, �.�. ���������� ��������� ���������
                      ||' base_units="' || tmpData.base_units            :: TVarChar ||'"' -- ���������� ��������� �������� � ������
                       ||' layer_qty="' || tmpData.layer_qty             :: TVarChar ||'"' -- �������� ������, �.�. ��� ����� ��������� �������
                           ||' width="' || tmpData.width                 :: TVarChar ||'"' -- ������ �������� (��)
                          ||' length="' || tmpData.length                :: TVarChar ||'"' -- ����� �������� (��)
                          ||' height="' || tmpData.height                :: TVarChar ||'"' -- ������ �������� (��)
                          ||' weight="' || zfConvert_FloatToString (tmpData.weight)        ||'"' -- ��� �������� (��)
                   ||' weight_brutto="' || zfConvert_FloatToString (tmpData.weight_brutto) ||'"' -- ��� ������ �������� (��) � �������� ��������, ������ ��� ������ ����� ������������ � ASN-���������
                                        ||'></' || vbTagName || '>'
                     ):: Text AS RowData
                     -- Id
                   , tmpData.pack_id AS ObjectId
                   , tmpData.GroupId
              FROM tmpData
              ORDER BY tmpData.GroupId, tmpData.sku_id
             ) AS tmp
      --WHERE tmp.RowNum BETWEEN 1 AND 1
        ORDER BY 4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.19                                       *
*/
-- select * FROM wms_Message WHERE RowData ILIKE '%sync_id=1%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY Id
-- ����
-- SELECT * FROM gpInsert_wms_Object_PACK ('1', zfCalc_UserAdmin())
