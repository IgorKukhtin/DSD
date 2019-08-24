-- Function: gpInsert_Movement_wms_INCOMING(TVarChar)
-- 4.1 ����������� �������� <incoming>

DROP FUNCTION IF EXISTS gpInsert_Movement_wms_INCOMING (VarChar(255));
DROP FUNCTION IF EXISTS gpInsert_Movement_wms_INCOMING (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Movement_wms_INCOMING(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName          TVarChar;
   DECLARE vbTagName           TVarChar;
   DECLARE vbTagName_detail    TVarChar;
   DECLARE vbActionName        TVarChar;
   DECLARE vbMovementId_income Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Movement_wms_INCOMING';
     --
     vbTagName       := 'incoming';
     vbTagName_detail:= 'incoming_detail';
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


     -- 1.1 ������������ ����� ������
     vbMovementId_income:= (SELECT Movement_Incoming.Id FROM Movement_Incoming WHERE Movement_Incoming.OperDate = CURRENT_DATE);
     IF COALESCE (vbMovementId_income, 0) = 0
     THEN
        INSERT INTO Movement_Incoming (OperDate, StatusId, StatusId_wms, InsertDate, UpdateDate)
          VALUES (CURRENT_DATE, zc_Enum_Status_UnComplete(), zc_Enum_Status_UnComplete(), CURRENT_TIMESTAMP, NULL)
           RETURNING Id INTO vbMovementId_income;
     END IF;

     INSERT INTO MI_Incoming (MovementId, GoodsId, GoodsKindId, GoodsTypeKindId, sku_id, sku_code, Amount, RealWeight, PartionDate, isErased)
        WITH tmpGoods_all AS (SELECT tmpGoods.GoodsId, tmpGoods.GoodsKindId, tmpGoods.GoodsTypeKindId, tmpGoods.sku_id, tmpGoods.sku_code
                              FROM lpSelect_Object_WMS_SKU() AS tmpGoods
                             )
        SELECT vbMovementId_income AS MovementId
             , tmpGoods_all.GoodsId
             , tmpGoods_all.GoodsKindId
             , tmpGoods_all.GoodsTypeKindId
             , tmpGoods_all.sku_id
             , tmpGoods_all.sku_code
             , 1            AS Amount
             , 1            AS RealWeight
             , CURRENT_DATE AS PartionDate
             , FALSE        AS isErased
        FROM tmpGoods_all
             LEFT JOIN MI_Incoming ON MI_Incoming.MovementId      = vbMovementId_income
                                  AND MI_Incoming.GoodsId         = tmpGoods_all.GoodsId
                                  AND MI_Incoming.GoodsKindId     = tmpGoods_all.GoodsKindId
                                  AND MI_Incoming.GoodsTypeKindId = tmpGoods_all.GoodsTypeKindId
        WHERE MI_Incoming.GoodsId IS NULL
       ;



     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO Object_WMS (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        WITH tmpMI AS (SELECT MI_Incoming.sku_id
                              -- ���� ���������
                            , Movement_Incoming.OperDate
                              -- ���� ������������
                            , MI_Incoming.PartionDate
                              -- 
                            , (ROW_NUMBER() OVER (ORDER BY MI_Incoming.Id)) :: Integer AS RowNum
                              --
                            , MI_Incoming.Id
                       FROM MI_Incoming
                           LEFT JOIN Movement_Incoming ON Movement_Incoming.Id = MI_Incoming.MovementId
                       WHERE MI_Incoming.MovementId = vbMovementId_income
                         AND MI_Incoming.isErased   = FALSE
                      )
        -- ���������
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- ����������� �������� � WMS � ����� �������������. �� ������ SKU ��������� ��������� ������� �� ��������, �������������� ��������� ��.
              SELECT vbProcName     AS ProcName
                   , vbTagName      AS TagName
                   , tmpData.RowNum AS RowNum
                     -- XML
                     -- ����������� ��������
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- ���������� ������������� ���������
                          ||' action="' || vbActionName                              ||'"' -- ???
                          ||' inc_id="' || tmpData.Id                    :: TVarChar ||'"' -- ����� ���������
                            ||' type="' || 'A'                                       ||'"' -- ��� ����������� ��������: � - ������������; � - ������� ��������; � - �������;
                    ||' date_to_ship="' || zfConvert_DateToWMS (tmpData.OperDate)    ||'"' -- ��������� ���� ������
                     ||' supplier_id="' || '0'                                       ||'"' -- ��� ���������� ��� ������ � �������� �������� �� ���������: 0 (��� �����)
                                        ||'>'

                     -- ������ ����������� ��������
                          ||'<' || vbTagName_detail
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- ���������� ������������� ���������
                          ||' action="' || vbActionName                              ||'"' -- ???
                          ||' inc_id="' || tmpData.Id                    :: TVarChar ||'"' -- ����� ���������
                            ||' line="' || '1'                                       ||'"' -- ����� ������ �������� ������� ���������
                          ||' sku_id="' || tmpData.sku_id                :: TVarChar ||'"' -- ���������� ������������� ������
                             ||' qty="' || '1'                                       ||'"' -- ���������� ������ � ������� �������� �� 
                 ||' production_date="' || zfConvert_DateToWMS (tmpData.PartionDate) ||'"' -- ���� ������������
                                        ||'></' || vbTagName_detail || '>'
                                        || '</' || vbTagName        || '>'

                     ) :: Text AS RowData

                     -- Id
                   , tmpData.Id AS ObjectId
                   , 0 AS GroupId
              FROM tmpMI AS tmpData
           -- WHERE tmpData.sku_id = '795292'
            /* UNION ALL
              -- ������ ����������� ��������
              SELECT vbProcName       AS ProcName
                   , vbTagName_detail AS TagName
                   , tmpData.RowNum + 1   AS RowNum
                     -- XML
                   , ('<' || vbTagName_detail
                          ||' action="' || vbActionName                     ||'"' -- ???
                          ||' inc_id="' || tmpData.inc_id       :: TVarChar ||'"' -- ����� ���������
                            ||' line="' || '1'                              ||'"' -- ����� ������ �������� ������� ���������
                          ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ���������� ������������� ������
                             ||' qty="' || '1'                              ||'"' -- ���������� ������ � ������� �������� �� 
                 ||' production_date="' || TO_CHAR (CURRENT_DATE, 'DD-MM-YYYY') :: TVarChar ||'"' -- ���� ������������
                                        ||'></' || vbTagName_detail || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 2 AS GroupId
              FROM tmpMI AS tmpData*/
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
-- SELECT * FROM gpInsert_Movement_wms_INCOMING ('1', zfCalc_UserAdmin())
