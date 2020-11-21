-- Function: gpInsert_wms_Object_PACK(TVarChar)
-- 3.4	���������� �������� <pack>

DROP FUNCTION IF EXISTS gpInsert_wms_Object_PACK (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Object_PACK(
    IN inGUID          VarChar(255),      -- 
   OUT outRecCount     Integer     ,      --
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS Integer
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


     -- !!!������ ��� ������ - � Object_GoodsByGoodsKind - �������� ����.!!!
     PERFORM gpInsertUpdate_wms_Object_GoodsByGoodsKind (inSession);

     -- ������������ ����� ������ - ���� ���� - wms_Object_Pack
     PERFORM lpInsertUpdate_wms_Object_Pack();


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
                               , COALESCE (tmp.GoodsTypeKindId, 0)    AS GoodsTypeKindId
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
                               , COALESCE (tmp.WeightMaxGross, 0) AS WeightMaxGross           -- ��� ������ ������� ����� "�� ������������� ����" (E2/E3)
                               , COALESCE (tmp.WeightMaxNet, 0)   AS WeightMaxNet             -- ��� ����� ������� ����� "�� ������������� ����" (E2/E3)
                          FROM lpSelect_wms_Object_SKU() AS tmp
                        --WHERE sku_id in ('2659002')
                        --WHERE sku_id IN ('3445471', '5304811', '27981831')
                        --WHERE InfoMoneyId = 8963 -- �������
                        --  AND sku_id NOT IN ('40671281', '40671301', '40671311', '47541391', '48461811')
                        --WHERE tmp.BoxId NOT IN (zc_Box_E2(), zc_Box_E3())

                         )
              --
            , tmpData AS (-- unit � ��������� ��������
                          SELECT wms_Object_Pack.Id              AS pack_id
                               , tmpGoods.sku_id                 AS sku_id
                               -- ���������� �������� ��������
                               , tmpGoods.name                   AS description
                               --
                               , '-'                 :: TVarChar AS barcode
                               -- ������� �������� ��������: t � �������� �������� ���������; f � �� �������� �������� ��������� �������� �� ��������� t
                               , 't'                 :: TVarChar AS is_main
                               -- ��� ��������: ��������� ��������
                               , wms_Object_Pack.ctn_type        AS ctn_type
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
                               , CASE WHEN tmpGoods.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves() THEN 0.001 ELSE tmpGoods.WeightAvg END :: TFloat AS weight
                               -- ��� ������ �������� (��) � �������� ��������, ������ ��� ������ ����� ������������ � ASN-���������
                               , tmpGoods.WeightAvg  :: TFloat   AS weight_brutto
                               --
                               , 1 AS GroupId
                          FROM tmpGoods
                               INNER JOIN wms_Object_Pack ON wms_Object_Pack.GoodsPropertyBoxId = tmpGoods.GoodsPropertyBoxId
                                                         AND wms_Object_Pack.GoodsTypeKindId    = tmpGoods.GoodsTypeKindId
                                                         AND wms_Object_Pack.ctn_type           = 'unit' -- ��� ��������: ��������� ��������
                         UNION ALL
                          -- carton � ���������� ��������
                          SELECT wms_Object_Pack.Id              AS pack_id
                               , tmpGoods.sku_id                 AS sku_id
                                 -- ���������� �������� ��������
                               , tmpGoods.name                   AS description
                               --
                               , '-'                 :: TVarChar AS barcode
                               -- ������� �������� ��������: t � �������� �������� ���������; f � �� �������� �������� ��������� �������� �� ��������� t
                               , 'f'                 :: TVarChar AS is_main
                               -- ��� ��������: ���������� ��������
                               , wms_Object_Pack.ctn_type        AS ctn_type

                               -- ������� �������� (������������� �������� �� ������� ������� ������). ��� ��������� �������� ����� 0. 
                             --, tmpGoods.sku_id         :: TVarChar AS code_id
                               , wms_Object_Pack_unit.Id :: TVarChar AS code_id

                               -- ���������� ��������� ��������, �.�. ���������� ��������� ���������
                               , CASE WHEN tmpGoods.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves()
                                           THEN tmpGoods.WeightMaxNet * 1000
                                      WHEN tmpGoods.WeightAvgNet > 0
                                           THEN CEIL (CASE WHEN tmpGoods.WeightAvg > 0 THEN tmpGoods.WeightAvgNet / tmpGoods.WeightAvg ELSE 1 END)
                                      ELSE tmpGoods.CountOnBox
                                 END :: Integer AS units
                               -- ���������� ��������� �������� � ������
                               , CASE WHEN tmpGoods.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves()
                                           THEN tmpGoods.WeightMaxNet * 1000
                                      WHEN tmpGoods.WeightAvgNet > 0
                                           THEN CEIL (CASE WHEN tmpGoods.WeightAvg > 0 THEN tmpGoods.WeightAvgNet / tmpGoods.WeightAvg ELSE 1 END)
                                      ELSE tmpGoods.CountOnBox
                                 END :: Integer AS base_units
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
                               , (tmpGoods.WeightAvgNet + tmpGoods.BoxWeight) :: TFloat   AS weight_brutto
                               --
                               , 2 AS GroupId
                          FROM tmpGoods
                               INNER JOIN wms_Object_Pack ON wms_Object_Pack.GoodsPropertyBoxId = tmpGoods.GoodsPropertyBoxId
                                                         AND wms_Object_Pack.GoodsTypeKindId    = tmpGoods.GoodsTypeKindId
                                                         AND wms_Object_Pack.ctn_type           = 'carton' -- ��� ��������: ���������� ��������
                               INNER JOIN wms_Object_Pack AS wms_Object_Pack_unit
                                                          ON wms_Object_Pack_unit.GoodsPropertyBoxId = tmpGoods.GoodsPropertyBoxId
                                                         AND wms_Object_Pack_unit.GoodsTypeKindId    = tmpGoods.GoodsTypeKindId
                                                         AND wms_Object_Pack_unit.ctn_type           = 'unit' -- ��� ��������: ��������� ��������
                        --WHERE tmpGoods.BoxId > 0
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
            --WHERE tmpData.sku_id :: TVarChar IN ('3445471')
              ORDER BY tmpData.GroupId, tmpData.sku_id
             ) AS tmp
      --WHERE tmp.RowNum BETWEEN 1 AND 1
        ORDER BY 4;


     -- ���������
     outRecCount:= (SELECT COUNT(*) FROM wms_Message WHERE wms_Message.GUID = inGUID);

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
