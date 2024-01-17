-- Function: gpUpdate_Object_GoodsGroupProperty_ColorReport()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsGroupProperty_ColorReport(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsGroupProperty_ColorReport(
    IN inId                  Integer   ,     -- ключ объекта <> 
    IN inColorReport         TFloat    ,     -- Цвет текста в "отчет по отгрузке"
    IN inSession             TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroupProperty());
   vbUserId:= lpGetUserBySession (inSession);


   -- сохранили свойство <Цвет текста в "отчет по отгрузке">
   IF COALESCE (inColorReport,0) <> 0
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsGroupProperty_ColorReport(), inId, inColorReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsGroupProperty_ColorReport(), inId, Null);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.01.24         * 
*/

-- тест
--