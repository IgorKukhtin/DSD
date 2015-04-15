-- Function: gpInsertUpdate_Object_MarginCategory(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategoryLink (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategoryLink(
    IN inId               Integer,       -- Ключ объекта <Виды форм оплаты>
    IN inMarginCategoryId Integer, 
    IN inUnitId           Integer, 
    IN inJuridicalId      Integer, 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE(Id INTEGER) AS
$BODY$
   DECLARE UserId Integer;
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   UserId := inSession;

   IF COALESCE(inMarginCategoryId, 0) = 0 THEN
      RAISE EXCEPTION 'Необходимо определить категорию наценки';
   END IF;

   IF COALESCE(inJuridicalId, 0) = 0 THEN
      RAISE EXCEPTION 'Необходимо определить продавца';
   END IF;

   IF COALESCE(inId, 0) = 0 THEN
      -- сохранили <Объект>
      inId := lpInsertUpdate_Object (0, zc_Object_MarginCategoryLink(), 0, '');
   END IF;

   -- сохранили связь с <Категорией наценки>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MarginCategoryLink_MarginCategory(), inId, inMarginCategoryId);
   -- сохранили связь с <ПОдразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MarginCategoryLink_Unit(), inId, inUnitId);
   -- сохранили связь с <Продавцом>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MarginCategoryLink_Juridical(), inId, inJuridicalId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, UserId);

   RETURN 
      QUERY SELECT inId AS Id;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MarginCategoryLink (Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.15                          *

*/

-- тест
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginCategory(0, 2,'ау','2'); ROLLBACK
