-- Function: gpInsert_Object_wms_SKU_GROUP(TVarChar)
-- 4.1.1.2 ���������� ����� ������� <sku_group>, <sku_depends>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_SKU_GROUP (VarChar(255));
DROP FUNCTION IF EXISTS gpInsert_Object_wms_SKU_GROUP (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_SKU_GROUP(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName            TVarChar;
   DECLARE vbTagName_sku_group   TVarChar;
   DECLARE vbTagName_sku_depends TVarChar;
   DECLARE vbActionName          TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Object_wms_SKU_GROUP';
     --
     vbTagName_sku_group   := 'sku_group';
     vbTagName_sku_depends := 'sku_depends';
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


     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO Object_WMS (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        WITH tmpGoods_all AS (SELECT tmpGoods.sku_id, tmpGoods.GoodsGroupId, tmpGoods.GoodsGroupName, tmpGoods.ObjectId
                              FROM lpSelect_Object_WMS_SKU() AS tmpGoods
                             )
          -- 0
        , tmpGoodsGroup_0 AS (SELECT tmpGoodsGroup.GoodsGroupId                               AS GoodsGroupId
                                   , tmpGoodsGroup.GoodsGroupName                             AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 0                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoods_all.GoodsGroupId, tmpGoods_all.GoodsGroupName FROM tmpGoods_all
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.GoodsGroupId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 1
        , tmpGoodsGroup_1 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 1                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_0 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 2
        , tmpGoodsGroup_2 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 2                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_1 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 3
        , tmpGoodsGroup_3 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 3                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_2 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 4
        , tmpGoodsGroup_4 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 4                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_3 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 5
        , tmpGoodsGroup_5 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 5                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_4 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 6
        , tmpGoodsGroup_6 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 6                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_5 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 7
        , tmpGoodsGroup_7 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 7                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_6 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 8
        , tmpGoodsGroup_8 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 8                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_7 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 9
        , tmpGoodsGroup_9 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 9                                                        AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_8 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- 10
       , tmpGoodsGroup_10 AS (SELECT Object_GoodsGroup.Id                                     AS GoodsGroupId
                                   , Object_GoodsGroup.ValueData                              AS GoodsGroupName
                                   , COALESCE (ObjectLink_GoodsGroup_parent.ChildObjectId, 0) AS ParentId
                                   , 10                                                       AS Ord
                              FROM (SELECT DISTINCT tmpGoodsGroup_x.ParentId FROM tmpGoodsGroup_9 AS tmpGoodsGroup_x WHERE tmpGoodsGroup_x.ParentId > 0
                                   ) AS tmpGoodsGroup
                                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoodsGroup.ParentId
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                        ON ObjectLink_GoodsGroup_parent.ObjectId = tmpGoodsGroup.ParentId
                                                       AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                             )
          -- all
        , tmpData AS (SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_0 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_1 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_2 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_3 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_4 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_5 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_6 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_7 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_8 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_9 AS tmp
                     UNION
                      SELECT tmp.GoodsGroupId AS sku_group_id, tmp.GoodsGroupName AS description, tmp.ParentId AS parent_id FROM tmpGoodsGroup_10 AS tmp
                     )
        -- ���������
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- sku_group
              SELECT vbProcName          AS ProcName
                   , vbTagName_sku_group AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY COALESCE (tmpGoodsGroup_10.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_9.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_8.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_7.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_6.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_5.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_4.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_3.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_2.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_1.Ord, 0) DESC
                                                          , COALESCE (tmpGoodsGroup_0.Ord, 0) DESC
                                                          , tmpData.sku_group_id
                                                           ) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName_sku_group
                          ||' action="' || vbActionName                     ||'"' -- ???
                    ||' sku_group_id="' || tmpData.sku_group_id :: TVarChar ||'"' -- ���������� ��� ������ ������� � ����������� �����������
                     ||' description="' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.description, CHR(39), '`'), '"', '`') ||'"' -- ���������� ������������ ������ ������� � ����������� �����������
                       ||' parent_id="' || CASE WHEN tmpData.parent_id > 0 THEN tmpData.parent_id :: TVarChar ELSE 'system' END :: TVarChar ||'"' -- ��� ������������ ������ ������� � ����������� �����������.
                                        ||'></' || vbTagName_sku_group || '>'
                     ):: Text AS RowData
                     -- Id
                   , tmpData.sku_group_id AS ObjectId
                   , 1                    AS GroupId
              FROM tmpData
                   LEFT JOIN tmpGoodsGroup_10 ON tmpGoodsGroup_10.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_9 ON tmpGoodsGroup_9.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_8 ON tmpGoodsGroup_8.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_7 ON tmpGoodsGroup_7.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_6 ON tmpGoodsGroup_6.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_5 ON tmpGoodsGroup_5.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_4 ON tmpGoodsGroup_4.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_3 ON tmpGoodsGroup_3.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_2 ON tmpGoodsGroup_2.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_1 ON tmpGoodsGroup_1.GoodsGroupId = tmpData.sku_group_id
                   LEFT JOIN tmpGoodsGroup_0 ON tmpGoodsGroup_0.GoodsGroupId = tmpData.sku_group_id
      
             UNION ALL
              -- sku_depends
              SELECT vbProcName            AS ProcName
                   , vbTagName_sku_depends AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName_sku_depends
                          ||' action="' || vbActionName                     ||'"' -- ???
                   ||' sku_groups_id="' || tmpData.GoodsGroupId :: TVarChar ||'"' -- ���������� ��� ������ ������� � ����������� �����������
                          ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ���������� ��� ������ � �������� ����������� �����������
                                        ||'></' || vbTagName_sku_depends || '>'
                     ):: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 2 AS GroupId

              FROM tmpGoods_all AS tmpData
             ) AS tmp
     -- WHERE tmp.RowNum BETWEEN 1 AND 1
        ORDER BY 4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.19                                       *
*/
-- select * FROM Object_WMS WHERE RowData ILIKE '%sync_id=1%
-- select * FROM Object_WMS WHERE GUID = '1' ORDER BY Id
-- ����
-- SELECT * FROM gpInsert_Object_wms_SKU_GROUP ('1', zfCalc_UserAdmin()) -- WHERE ProcName = 'gpInsert_Object_wms_SKU_GROUP'
-- SELECT * FROM gpInsert_Object_wms_SKU_GROUP ('1', zfCalc_UserAdmin()) -- WHERE ProcName = 'gpInsert_Object_wms_SKU_DEPENDS'
