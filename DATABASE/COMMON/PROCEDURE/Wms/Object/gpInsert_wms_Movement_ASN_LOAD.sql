-- Function: gpInsert_wms_Movement_ASN_LOAD(TVarChar)
-- 4.1.1 ����� � ������������

DROP FUNCTION IF EXISTS gpInsert_wms_Movement_ASN_LOAD (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Movement_ASN_LOAD(
    IN inGUID          VarChar(255),      -- 
   OUT outRecCount     Integer     ,      --
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS Integer
AS
$BODY$
   DECLARE vbProcName       TVarChar;
   DECLARE vbTagName        TVarChar;
   DECLARE vbTagName_detail TVarChar;
   DECLARE vbActionName     TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_wms_Movement_ASN_LOAD());

     --
     vbProcName:= 'gpInsert_wms_Movement_ASN_LOAD';
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
         DELETE FROM wms_Message WHERE wms_Message.GUID = inGUID; -- AND wms_Message.ProcName = vbProcName;
     END IF;


     -- ��������
     IF EXISTS (SELECT 1
                FROM wms_Movement_WeighingProduction AS Movement
                     INNER JOIN wms_MI_WeighingProduction AS MI ON MI.MovementId = Movement.Id
                                                               AND MI.isErased   = FALSE
                                                               -- !!!����� ��� ������� ����!!!
                                                               AND MI.ParentId   > 0 
                                                               -- ������ �� ������� ��� �� ����������
                                                               AND MI.StatusId_wms IS NULL
          
                WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE + INTERVAL '1 DAY'
                      -- �� ������
                  AND Movement.StatusId NOT IN (zc_Enum_Status_Erased()) -- zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()
               )
     THEN
         -- !!!������ ��� ������ - � Object_GoodsByGoodsKind - �������� ����.!!!
         PERFORM gpInsertUpdate_wms_Object_GoodsByGoodsKind (inSession);
     END IF;


     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO wms_Message (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId, InsertDate)
        WITH tmpMI AS (SELECT -- �� ����� (EAN-128)
                              COALESCE (Object_BarCodeBox.ValueData, '') AS name
                              --COALESCE (Object_BarCodeBox.ValueData, '') || '-' || MI.ParentId :: TVarChar AS name
                              -- ID ������ 
                            , MI.sku_id
                              -- ���������� WMS
                            , SUM (zfCalc_QTY_toWMS (inGoodsTypeKindId:= MI.GoodsTypeKindId
                                                   , inMeasureId      := OL_Goods_Measure.ChildObjectId
                                                   , inAmount         := CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN MI.Amount ELSE MI.RealWeight END
                                                   , inRealWeight     := MI.RealWeight
                                                   , inCount          := MI.Amount
                                                   , inWeightMin      := wms_Object_GoodsByGoodsKind.WeightMin
                                                   , inWeightMax      := wms_Object_GoodsByGoodsKind.WeightMax
                                                    )) AS qty
                              -- ���� ������������
                            , MI.PartionDate - INTERVAL '0 DAY' AS production_date
                              -- ��� (��� ������)
                            , SUM (MI.RealWeight) AS real_weight
                              -- ��� ������ ��. (E2/E3)
                            , COALESCE (wms_Object_GoodsByGoodsKind.BoxWeight, 0.0) :: TFloat AS pack_weight
                              -- ����� ������� �� ��������
                            , COALESCE (wms_MI_Incoming.Id, 0) :: Integer AS inc_id
                              -- ObjectId
                            , MI.ParentId
                       FROM wms_Movement_WeighingProduction AS Movement
                            INNER JOIN wms_MI_WeighingProduction AS MI ON MI.MovementId = Movement.Id
                                                                      AND MI.isErased   = FALSE
                                                                      -- !!!����� ��� ������� ����!!!
                                                                      AND MI.ParentId   > 0 
                                                                      -- ������ �� ������� ��� �� ����������
                                                                      AND (MI.StatusId_wms IS NULL
                                                                     --OR Movement.OperDate = CURRENT_DATE - INTERVAL '0 DAY'
                                                                          )
                            LEFT JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MI.BarCodeBoxId
                            LEFT JOIN ObjectLink AS OL_Goods_Measure
                                                 ON OL_Goods_Measure.ObjectId = CASE WHEN MI.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh ELSE Movement.GoodsId END
                                                AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                            -- �������� ����.
                            LEFT JOIN wms_Object_GoodsByGoodsKind ON wms_Object_GoodsByGoodsKind.GoodsId     = CASE WHEN MI.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh     ELSE Movement.GoodsId     END
                                                                 AND wms_Object_GoodsByGoodsKind.GoodsKindId = CASE WHEN MI.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsKindId_link_sh ELSE Movement.GoodsKindId END
                            -- �������� ����.
                            INNER JOIN wms_MI_Incoming ON wms_MI_Incoming.OperDate        = Movement.OperDate
                                                      AND wms_MI_Incoming.GoodsId         = CASE WHEN MI.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh     ELSE Movement.GoodsId     END
                                                      AND wms_MI_Incoming.GoodsKindId     = CASE WHEN MI.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsKindId_link_sh ELSE Movement.GoodsKindId END
                                                      AND wms_MI_Incoming.GoodsTypeKindId = MI.GoodsTypeKindId
                                                      -- !!!����������� ������� ������ ���� Incoming!!!
                                                      AND wms_MI_Incoming.StatusId_wms    IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())

                       WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE + INTERVAL '1 DAY'
                             -- �� ������
                         AND Movement.StatusId NOT IN (zc_Enum_Status_Erased()) -- zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete()
                         --
                         -- AND Movement.Id = 391
                       GROUP BY -- �� ����� (EAN-128)
                                Object_BarCodeBox.ValueData
                              --COALESCE (Object_BarCodeBox.ValueData, '') || '-' || MI.ParentId :: TVarChar
                                -- ID ������ 
                              , MI.sku_id
                                -- ���� ������������
                              , MI.PartionDate
                                -- ��� �����
                              , COALESCE (wms_Object_GoodsByGoodsKind.BoxWeight, 0.0)
                                -- ����� ������� �� ��������
                              , wms_MI_Incoming.Id
                                -- ObjectId
                              , MI.ParentId
                      )
        -- ���������
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (-- �� ����� ������� (�� ������������, �� � WMS) ����� � �������, �� ��������� ��������� ��������� �ASN ���� <asn_load> �� ������ �����.
              SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer AS RowNum
                     -- XML
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- ���������� ������������� ���������
                          ||' action="' || vbActionName                              ||'"' -- ???
                            ||' name="' || tmpData.name                              ||'"' -- �� ����� (EAN-128)
                          ||' sku_id="' || tmpData.sku_id                :: TVarChar ||'"' -- ID ������ 
                             ||' qty="' || tmpData.qty                   :: TVarChar ||'"' -- ���������� ������ (��� �������� ���������� ���������� � ��.) 
                 ||' production_date="' || zfConvert_Date_toWMS (tmpData.production_date) :: TVarChar ||'"' -- ���� ������������
                     ||' real_weight="' || tmpData.real_weight           :: TVarChar ||'"' -- ��� (��� ������)
                     ||' pack_weight="' || tmpData.pack_weight           :: TVarChar ||'"' -- ��� �����
                          ||' inc_id="' || tmpData.inc_id                :: TVarChar ||'"' -- ����� ������� �� ��������
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- ObjectId
                   , tmpData.ParentId AS ObjectId
                     -- 
                   , 0                AS GroupId
              FROM tmpMI AS tmpData
           -- WHERE tmpData.sku_id = '795292'
             ) AS tmp
     -- WHERE tmp.RowNum = 1
        ORDER BY 4
     -- LIMIT 1
       ;

     IF inGUID <> '1'
     THEN
         -- �������� ��� ������ ����������
         UPDATE wms_MI_WeighingProduction SET StatusId_wms = zc_Enum_Status_UnComplete()
         FROM wms_Message
         WHERE wms_Message.GUID     = inGUID
           AND wms_Message.ObjectId = wms_MI_WeighingProduction.ParentId
           -- ������ �� ������� ��� �� ����������
        -- AND wms_MI_Incoming.StatusId_wms IS NULL
         ;
     END IF;


     -- ���������
     outRecCount:= (SELECT COUNT(*) FROM wms_Message WHERE wms_Message.GUID = inGUID);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.19                                       *
*/
-- select * FROM wms_Message WHERE RowData ILIKE '%sync_id=1%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY Id
-- ����
-- SELECT * FROM gpInsert_wms_Movement_ASN_LOAD ('1', zfCalc_UserAdmin())
