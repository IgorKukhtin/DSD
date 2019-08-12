-- Function: gpInsert_Object_wms_SKU_GROUP(TVarChar)
-- 4.1.1.2 Справочник групп товаров <sku_group>, <sku_depends>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_SKU_GROUP (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_SKU_GROUP(
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (ProcName TVarChar, RowNum Integer, RowData Text, ObjectId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName_SKU_GROUP   TVarChar;
   DECLARE vbProcName_SKU_DEPENDS TVarChar;
   DECLARE vbRowNum   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     vbProcName_SKU_GROUP  := 'gpInsert_Object_wms_SKU_GROUP';
     vbProcName_SKU_DEPENDS:= 'gpInsert_Object_wms_SKU_DEPENDS';


     -- удалили прошлые данные
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName IN (vbProcName_SKU_GROUP, vbProcName_SKU_DEPENDS);

     -- первые строчки XML
     -- vbRowNum:= 1;
     -- INSERT INTO Object_WMS (ProcName, RowNum, RowData) VALUES (vbProcName_SKU_GROUP, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');
     -- INSERT INTO Object_WMS (ProcName, RowNum, RowData) VALUES (vbProcName_SKU_DEPENDS, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');


     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO Object_WMS (ProcName, RowNum, RowData, ObjectId)
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
        -- Результат
        -- sku_group
        SELECT vbProcName_SKU_GROUP AS ProcName
             , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY COALESCE (tmpGoodsGroup_10.Ord, 0) DESC
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
             , ('<sku_group'
            ||' sku_group_id=“' || tmpData.sku_group_id :: TVarChar ||'"' -- Уникальный код группы товаров в справочнике предприятия
             ||' description=“' || zfCalc_Text_replace (tmpData.description, CHR(39), '`') ||'"' -- Уникальное наименование группы товаров в справочнике предприятия
              ||' parent_id=“' || CASE WHEN tmpData.parent_id > 0 THEN tmpData.parent_id :: TVarChar ELSE 'system' END :: TVarChar ||'"' -- Код родительской группы товаров в справочнике предприятия.
              ||' </sku_group>'
               ):: Text AS RowData
               -- Id
             , tmpData.sku_group_id AS ObjectId
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
        SELECT vbProcName_SKU_DEPENDS AS ProcName
             , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
               -- XML
             , ('<sku_depends'
            ||' sku_group_id=“' || tmpData.GoodsGroupId :: TVarChar ||'"' -- Уникальный код группы товаров в справочнике предприятия
                  ||' sku_id=“' || tmpData.sku_id       :: TVarChar ||'"' -- Уникальный код товара в товарном справочнике предприятия
                  ||' </sku_depends>'
               ):: Text AS RowData
               -- Id
             , tmpData.ObjectId
        FROM tmpGoods_all AS tmpData
        ORDER BY 2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19                                       *
*/
-- тест
-- SELECT * FROM gpInsert_Object_wms_SKU_GROUP (zfCalc_UserAdmin()) -- WHERE ProcName = 'gpInsert_Object_wms_SKU_GROUP'
-- SELECT * FROM gpInsert_Object_wms_SKU_GROUP (zfCalc_UserAdmin()) -- WHERE ProcName = 'gpInsert_Object_wms_SKU_DEPENDS'
