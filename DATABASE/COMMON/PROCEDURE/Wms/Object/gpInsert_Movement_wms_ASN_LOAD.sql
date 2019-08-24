-- Function: gpInsert_Movement_wms_ASN_LOAD(TVarChar)
-- 4.1.1 ����� � ������������

DROP FUNCTION IF EXISTS gpInsert_Movement_wms_ASN_LOAD (VarChar(255));
DROP FUNCTION IF EXISTS gpInsert_Movement_wms_ASN_LOAD (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Movement_wms_ASN_LOAD(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName       TVarChar;
   DECLARE vbTagName        TVarChar;
   DECLARE vbTagName_detail TVarChar;
   DECLARE vbActionName     TVarChar;
   DECLARE vbMovementId_income Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Movement_wms_ASN_LOAD';
     --
     vbTagName:= 'asn_load';
     --
     vbActionName:= 'set';

     -- ��������
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- ������� ������� ������
         DELETE FROM Object_WMS WHERE Object_WMS.GUID = inGUID; -- AND Object_WMS.ProcName = vbProcName;
     END IF;

     -- �����
     vbMovementId_income:= COALESCE ((SELECT Movement_Incoming.Id FROM Movement_Incoming WHERE Movement_Incoming.OperDate = CURRENT_DATE), 0);

     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO Object_WMS (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
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
                                   , COALESCE (MI_Incoming.Id, 0) :: Integer AS inc_id
                                     -- GoodsId
                                   , Movement.GoodsId
                                     -- ObjectId
                                   , Movement.Id AS ObjectId
                                   , MAX (MI.Id) AS Id
                              FROM Movement_WeighingProduction AS Movement
                                   INNER JOIN MI_WeighingProduction AS MI ON MI.MovementId = Movement.Id
                                                                         AND MI.isErased   = FALSE
                                                                         AND MI.ParentId   > 0 
                                   LEFT JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MI.BarCodeBoxId
                                   -- �������� ����.
                                   LEFT JOIN Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.GoodsId     = Movement.GoodsId
                                                                    AND Object_GoodsByGoodsKind.GoodsKindId = Movement.GoodsKindId

                                   -- �������� ����.
                                   LEFT JOIN MI_Incoming ON MI_Incoming.MovementId      = vbMovementId_income
                                                        AND MI_Incoming.GoodsId         = Movement.GoodsId
                                                        AND MI_Incoming.GoodsKindId     = Movement.GoodsKindId
                                                        AND MI_Incoming.GoodsTypeKindId = MI.GoodsTypeKindId

                              WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '0 DAY' AND CURRENT_DATE + INTERVAL '1 DAY'
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
                                     , MI_Incoming.Id
                                       -- GoodsId
                                     , Movement.GoodsId
                                       -- ObjectId
                                     , Movement.Id
                             )
        -- ���������
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- �� ����� ������� (�� ������������, �� � WMS) ����� � �������, �� ��������� ��������� ��������� �ASN ���� <asn_load> �� ������ �����.
              SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.sku_id)) :: Integer AS RowNum
                     -- XML
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- ���������� ������������� ���������
                          ||' action="' || vbActionName                              ||'"' -- ???
                            ||' name="' || tmpData.name                              ||'"' -- �� ����� (EAN-128)
                          ||' sku_id="' || tmpData.sku_id                :: TVarChar ||'"' -- ID ������ 
                             ||' qty="' || tmpData.qty                   :: TVarChar ||'"' -- ���������� ������ (��� �������� ���������� ���������� � ��.) 
                 ||' production_date="' || zfConvert_DateToWMS (tmpData.production_date) :: TVarChar ||'"' -- ���� ������������
                     ||' real_weight="' || tmpData.real_weight           :: TVarChar ||'"' -- ��� (��� ������)
                     ||' pack_weight="' || tmpData.pack_weight           :: TVarChar ||'"' -- ��� �����
                          ||' inc_id="' || tmpData.inc_id                :: TVarChar ||'"' -- ����� ������� �� ��������
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM tmpGoods_all AS tmpData
           -- WHERE tmpData.sku_id = '795292'
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
-- select * FROM Object_WMS WHERE RowData ILIKE '%sync_id=1%
-- select * FROM Object_WMS WHERE GUID = '1' ORDER BY Id
-- ����
-- SELECT * FROM gpInsert_Movement_wms_ASN_LOAD ('1', zfCalc_UserAdmin())
