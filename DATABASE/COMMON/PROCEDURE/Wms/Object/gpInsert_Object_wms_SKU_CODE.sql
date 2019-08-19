-- Function: gpInsert_Object_wms_SKU_CODE(TVarChar)
-- 4.1.1.1 Справочник товаров <sku>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_SKU_CODE (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_SKU_CODE(
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (ProcName TVarChar, TagName TVarChar, ActionName TVarChar, RowNum Integer, RowData Text, ObjectId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
   DECLARE vbRowNum     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Object_wms_SKU_CODE';
     --
     vbTagName := 'sku_code';
     --
     vbActionName:= 'set';


     -- удалили прошлые данные
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- первые строчки XML
     -- vbRowNum:= 1;
     -- INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData) VALUES (vbProcName, vbTagName, vbActionName, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');


     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData, ObjectId)
        SELECT tmp.ProcName, tmp.TagName, tmp.ActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId
        FROM
       (SELECT vbProcName   AS ProcName
             , vbTagName    AS TagName
             , vbActionName AS ActionName
             , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
               -- XML
             , ('<sku_code'
                   ||' action="' || vbActionName                     ||'"' -- ???
                   ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Уникальный код товара в товарном справочнике предприятия
                 ||' sku_code="' || tmpData.sku_code     :: TVarChar ||'"' -- Уникальный, человеко-читаемый код товара для отображения в экранных формах.
                      ||'></sku_code>'
               ) :: Text AS RowData
               -- Id
             , tmpData.ObjectId
        FROM lpSelect_Object_wms_SKU() AS tmpData
       ) AS tmp
     -- WHERE tmp.RowNum = 1
        ORDER BY 4
     -- LIMIT 1
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19                                       *
*/
/*
CREATE TABLE Object_WMS(
   Id                    BIGSERIAL NOT NULL PRIMARY KEY, 
   ProcName              TVarChar NOT NULL,
   TagName               TVarChar NOT NULL,
   ActionName            TVarChar NOT NULL,
   RowNum                Integer  NOT NULL,
   RowData               Text     NOT NULL,
   ObjectId              Integer  NOT NULL
   );
CREATE INDEX idx_Object_WMS_ProcName ON Object_WMS (ProcName);
CREATE INDEX idx_Object_WMS_TagName  ON Object_WMS (TagName);
*/
-- delete FROM Object_WMS
-- select * FROM Object_WMS
-- тест
-- SELECT * FROM gpInsert_Object_wms_SKU_CODE (zfCalc_UserAdmin())
