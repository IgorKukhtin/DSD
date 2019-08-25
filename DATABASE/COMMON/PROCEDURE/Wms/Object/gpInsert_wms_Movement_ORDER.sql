-- Function: gpInsert_Movement_wms_ORDER(TVarChar)
-- 4.2	����� �� �������� <order>

DROP FUNCTION IF EXISTS gpInsert_Movement_wms_ORDER (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Movement_wms_ORDER(
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (ProcName TVarChar, TagName TVarChar, ActionName TVarChar, RowNum Integer, RowData Text, ObjectId Integer)
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
     vbProcName:= 'gpInsert_Movement_wms_ORDER';
     --
     vbTagName       := 'order';
     vbTagName_detail:= 'order_detail'
     --
     vbActionName:= 'set';


     -- ������� ������� ������
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        WITH tmpGoods_all AS (SELECT tmpGoods.sku_id, tmpGoods.ObjectId
                              FROM lpSelect_Object_WMS_SKU() AS tmpGoods
                             )
        SELECT tmp.ProcName, tmp.TagName, tmp.ActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- ����� �� ��������
              SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , vbActionName AS ActionName
                   , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName
                         ||' action="' || vbActionName                     ||'"' -- ???
                       ||' order_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ����� ���������
                      ||' client_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ��� ��������� � ����������� �����������.
                           ||' type="' || '�'                              ||'"' -- ��� ������: �������� - �; �������� ����� - �; �������� - �;
              ||' processing_method="' || '�'                              ||'"' -- ������ ��������� ������ (����� ���� ������): ������� - �; ������ - �; ��� ���������� - �;
                   ||' date_to_ship="' || CURRENT_DATE         :: TVarChar ||'"' -- �������������� ���� �������� ������
                       ||' comments="' || tmpData.Comment      :: TVarChar ||'"' -- ����������� � ���������
                                       ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
              FROM tmpGoods_all AS tmpData
             UNION ALL
              -- ������ ������ �� ��������
              SELECT vbProcName       AS ProcName
                   , vbTagName_detail AS TagName
                   , vbActionName     AS ActionName
                   , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' + vbTagName_detail
                         ||' action="' || vbActionName                     ||'"' -- ???
                       ||' order_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ����� ���������
                           ||' line="' || '1'                              ||'"' -- ����� ������ �������� ������� ���������
                         ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ���������� ������������� ������
                         ||' status="' || tmpData.sku_id       :: TVarChar ||'"' -- ��������� �����: �������� (��� ���� ������ ���������) - �; ���������� (��� ���� ������ ���������) - �; ���� (��� ���� ������ ��������� �����) - �;
                            ||' qty="' || '1'                              ||'"' -- ���������� ������ � ������� �������� �� 
                       ||' comments="' || tmpData.Comment      :: TVarChar ||'"' -- ����������� � ������ ���������
                                       ||'></' || vbTagName_detail || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
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
-- SELECT * FROM gpInsert_Movement_wms_ORDER (zfCalc_UserAdmin())
