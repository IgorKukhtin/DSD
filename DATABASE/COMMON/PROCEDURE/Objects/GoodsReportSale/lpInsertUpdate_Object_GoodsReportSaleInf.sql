-- Function: lpInsertUpdate_Object_GoodsReportSaleInf  ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsReportSaleInf (Integer, TDateTime, TDateTime, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsReportSaleInf(
    IN inId                       Integer   ,    -- ключ объекта <> 
    IN inStartDate                TDateTime ,    -- 
    IN inEndDate                  TDateTime ,    -- 
    IN inWeek                     TFloat    ,    -- 
    IN inUserId                   Integer        -- сессия пользователя
)
 RETURNS VOID AS
$BODY$
BEGIN
   
   -- сохранили <Объект>
   inId := lpInsertUpdate_Object (inId, zc_Object_GoodsReportSaleInf(), 0, '');

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSaleInf_Week(), inId, inWeek);
   
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_GoodsReportSaleInf_Start(), inId, inStartDate);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_GoodsReportSaleInf_End(), inId, inEndDate);
  
   -- сохранили свойство <Дата корр.>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);
   -- сохранили свойство <Пользователь (корр.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.11.17         *
*/

-- тест
-- 