-- Function: gpInsert_Movement_wms_INCOMING(TVarChar)
-- 4.1 ����������� �������� <incoming>

DROP FUNCTION IF EXISTS gpInsert_Movement_wms_INCOMING (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Movement_wms_INCOMING(
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
     vbProcName:= 'gpInsert_Movement_wms_INCOMING';
     --
     vbTagName       := 'incoming';
     vbTagName_detail:= 'incoming_detail';
     --
     vbActionName:= 'set';


     -- ������� ������� ������
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        WITH tmpGoods_all AS (SELECT tmpGoods.sku_id
                                     -- ����� ���������
                                   , zfCalc_inc_id_toWMS (CURRENT_DATE, tmpGoods.sku_id) AS inc_id
                                     -- ���� ���������
                                   , CURRENT_DATE AS OperDate
                                     -- ���� ������������
                                   , CURRENT_DATE AS PartionDate
                                     -- 
                                   , (ROW_NUMBER() OVER (ORDER BY tmpGoods.sku_id)) :: Integer AS RowNum
                                     --
                                   , tmpGoods.ObjectId
                              FROM lpSelect_Object_WMS_SKU() AS tmpGoods
                             )
        -- ���������
        SELECT tmp.ProcName, tmp.TagName, tmp.ActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- ����������� �������� � WMS � ����� �������������. �� ������ SKU ��������� ��������� ������� �� ��������, �������������� ��������� ��.
              SELECT vbProcName     AS ProcName
                   , vbTagName      AS TagName
                   , vbActionName   AS ActionName
                   , tmpData.RowNum AS RowNum
                     -- XML
                     -- ����������� ��������
                   , ('<' || vbTagName
                         ||' sync_id="' || tmpData.inc_id       :: TVarChar ||'"' -- ???
                          ||' action="' || vbActionName                     ||'"' -- ???
                          ||' inc_id="' || tmpData.inc_id       :: TVarChar ||'"' -- ����� ���������
                            ||' type="' || 'A'                              ||'"' -- ��� ����������� ��������: � - ������������; � - ������� ��������; � - �������;
                    ||' date_to_ship="' || zfConvert_DateToWMS (tmpData.OperDate) ||'"' -- ��������� ���� ������
                     ||' supplier_id="' || '0'                              ||'"' -- ��� ���������� ��� ������ � �������� �������� �� ���������: 0 (��� �����)
                                        ||'>'

                     -- ������ ����������� ��������
                          ||'<' || vbTagName_detail
                          ||' action="' || vbActionName                     ||'"' -- ???
                          ||' inc_id="' || tmpData.inc_id       :: TVarChar ||'"' -- ����� ���������
                            ||' line="' || '1'                              ||'"' -- ����� ������ �������� ������� ���������
                          ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ���������� ������������� ������
                             ||' qty="' || '1'                              ||'"' -- ���������� ������ � ������� �������� �� 
                 ||' production_date="' || zfConvert_DateToWMS (tmpData.PartionDate) ||'"' -- ���� ������������
                                        ||'></' || vbTagName_detail || '>'
                                        || '</' || vbTagName        || '>'

                     ) :: Text AS RowData

                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM tmpGoods_all AS tmpData
            /* UNION ALL
              -- ������ ����������� ��������
              SELECT vbProcName       AS ProcName
                   , vbTagName_detail AS TagName
                   , vbActionName     AS ActionName
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
              FROM tmpGoods_all AS tmpData*/
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
-- SELECT * FROM gpInsert_Movement_wms_INCOMING (zfCalc_UserAdmin())
