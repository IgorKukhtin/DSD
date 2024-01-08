-- Function: gpUpdate_Object_PartionCell_Params()

DROP FUNCTION IF EXISTS gpUpdate_Object_PartionCell_Params (Integer,Integer,Integer,Integer,Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PartionCell_Params(
    IN inId_1	      Integer,   	-- ключ объекта <Единица измерения>
    IN inId_2	      Integer,
    IN inId_3	      Integer,
    IN inId_4	      Integer,
    IN inId_5	      Integer,
    IN inId_6	      Integer,
    IN inBoxCount_1   TFloat,
    IN inBoxCount_2   TFloat,
    IN inBoxCount_3   TFloat,
    IN inBoxCount_4   TFloat,
    IN inBoxCount_5   TFloat,
    IN inBoxCount_6   TFloat,
    IN inSession      TVarChar      -- сессия пользователя
)
  RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), inId_1, inBoxCount_1);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), inId_2, inBoxCount_2);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), inId_3, inBoxCount_3);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), inId_4, inBoxCount_4);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), inId_5, inBoxCount_5);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), inId_6, inBoxCount_6);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId_1, vbUserId);
   PERFORM lpInsert_ObjectProtocol (inId_2, vbUserId);
   PERFORM lpInsert_ObjectProtocol (inId_3, vbUserId);
   PERFORM lpInsert_ObjectProtocol (inId_4, vbUserId);
   PERFORM lpInsert_ObjectProtocol (inId_5, vbUserId);
   PERFORM lpInsert_ObjectProtocol (inId_6, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 08.01.24         *

*/

-- тест
-- 