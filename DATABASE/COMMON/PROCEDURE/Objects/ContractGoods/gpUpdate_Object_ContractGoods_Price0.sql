-- Function: gpInsertUpdate_Object_ContractGoods_byPriceList  ()

DROP FUNCTION IF EXISTS gpUpdate_Object_ContractGoods_Price0(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ContractGoods_Price0(
    IN inId        Integer   ,    -- 
   OUT outPrice    TFloat    ,    --
    IN inSession   TVarChar       -- сессия пользователя
)
 RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractGoods());
   
   IF COALESCE (inId,0) = 0
   THEN
       RETURN;
   END IF;
   
   outPrice := 0;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractGoods_Price(), inId, outPrice);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.20         *
*/

-- тест
--