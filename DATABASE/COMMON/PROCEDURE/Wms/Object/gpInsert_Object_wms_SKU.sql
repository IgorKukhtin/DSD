-- Function: gpInsert_Object_wms_SKU(TVarChar)
-- 4.1.1.1 —правочник товаров <sku>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_SKU (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_SKU(
    IN inSession       VarChar(255)       -- сесси€ пользовател€
)
-- RETURNS TABLE (ProcName TVarChar, RowNum Integer, RowData Text, ObjectId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName TVarChar;
   DECLARE vbRowNum   Integer;
BEGIN
     vbProcName:= 'gpInsert_Object_wms_SKU';
/*
CREATE TABLE Object_WMS(
   Id                    BIGSERIAL NOT NULL PRIMARY KEY, 
   ProcName              TVarChar NOT NULL,
   RowNum                Integer  NOT NULL,
   RowData               Text     NOT NULL,
   ObjectId              Integer  NOT NULL
   );
CREATE INDEX idx_Object_WMS_ProcName ON Object_WMS (ProcName);
*/
     -- проверка прав пользовател€ на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());



     -- удалили прошлые данные
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- первые строчки XML
     -- vbRowNum:= 1;
     -- INSERT INTO Object_WMS (ProcName, RowNum, RowData) VALUES (vbProcName, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');


     -- –езультат
     -- RETURN QUERY
     -- –езультат - сформировали новые данные - Ёлементы XML
     INSERT INTO Object_WMS (ProcName, RowNum, RowData, ObjectId)
        SELECT vbProcName AS ProcName
             , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.sku_id) :: Integer) AS RowNum
               -- XML
             , ('<sku'
--                ||' syncid=У' || tmpData.sku_id    :: TVarChar ||'"' -- ???
--                ||' action=У' || 'update'                       ||'"' -- ???
--              ||' syncdate=У' || CURRENT_TIMESTAMP  :: TVarChar ||'"' -- ???
                  ||' sku_id=У' || tmpData.sku_id       :: TVarChar ||'"' -- ”никальный код товара в товарном справочнике предпри€ти€
                ||' sku_code=У' || tmpData.sku_code     :: TVarChar ||'"' -- ”никальный, человеко-читаемый код товара дл€ отображени€ в экранных формах.
                    ||' name=У' || tmpData.name                     ||'"' -- Ќаименование товара в товарном справочнике предпри€ти€
             ||' description=У' || ''                                ||'"' -- ќписание товара в товарном справочнике предпри€ти€.
            ||' control_date=У' || '3'                               ||'"' -- ѕараметр, определ€ющий каким образом —”—  должна следить за сроками годности товара на складе:У0Ф Ц Ќе учитыватьУ1Ф Ц ѕо сроку годностиУ2Ф Ц ѕо дате окончани€ срока годностиУ3Ф Ц ѕо дате производства и дате окончани€ срока годности.«начение по умолчанию: 0
            ||' product_life=У' || tmpData.product_life :: TVarChar ||'"' -- —рок годности товара в сутках.
                 ||' measure=У' || tmpData.MeasureName              ||'"' -- ≈диница измерени€ товара (идентификатор из справочника в √—).
         ||' lot_capture_req=У' || 'f'                               ||'"' -- ѕараметр товара, указывающий на необходимость ввода партии товара дл€ груза при приеме товара на склад: f Ц Ќе вводить t Ц ¬водить
          ||' weight_control=У' || 'A'                               ||'"' -- –ежим учета веса: УAФ Ц автоматически при приемке УMФ Ц вручную при приемке
   ||' host_transform_factor=У' || '1'                               ||'"' --  оэффициент пересчета из базовых единиц (сколько базовых единиц √— в одной штучной в WMS).
                     ||' upc=У' || ''                                ||'"' -- Ўтрихкод товара
                     ||' </sku>'
               ):: Text AS RowData
               -- Id
             , tmpData.ObjectId
        FROM lpSelect_Object_wms_SKU() AS tmpData
        ORDER BY 2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 »—“ќ–»я –ј«–јЅќ“ »: ƒј“ј, ј¬“ќ–
              ‘елонюк ».¬.    ухтин ».¬.    лиментьев  .».
 10.08.19                                       *
*/
-- тест
-- SELECT * FROM gpInsert_Object_wms_SKU (zfCalc_UserAdmin())
