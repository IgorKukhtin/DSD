-- Function: gpInsertUpdate_Object_MarginCategory(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategoryItem (Integer, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategoryItem(
    IN inId               Integer,       -- Ключ объекта <Виды форм оплаты>
    IN inMinPrice         TFloat, 
    IN inMarginPercent    TFloat, 
    IN inMarginCategoryId Integer, 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE(Id INTEGER) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean; 
   DECLARE vbMarginPercent TFloat;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   vbUserId := inSession;

   IF COALESCE(inMarginCategoryId, 0) = 0 THEN
      RAISE EXCEPTION 'Необходимо определить категорию наценки';
   END IF;

   -- определили <Признак новый или корректировка>
   vbIsUpdate:= COALESCE (inId, 0) > 0;

   IF COALESCE(inId, 0) <> 0 THEN
      vbMarginPercent := (SELECT ObjectFloat.ValueData 
                          FROM ObjectFloat 
                          WHERE ObjectFloat.ObjectId = inId 
                            AND ObjectFloat.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent()
                          );
   END IF;


   IF COALESCE(inId, 0) = 0 THEN
      -- сохранили <Объект>
      inId := lpInsertUpdate_Object (0, zc_Object_MarginCategoryItem(), 0, '');
   END IF;

   -- сохранили свойство <Минимальная цена>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginCategoryItem_MinPrice(), inId, inMinPrice);
   -- сохранили свойство <% наценки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginCategoryItem_MarginPercent(), inId, inMarginPercent);

   -- сохранили связь с <Категорией наценки>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MarginCategoryItem_MarginCategory(), inId, inMarginCategoryId);


   -- сохранили историю
    IF ((COALESCE(inMarginPercent,0) <>0 ) AND (inMarginPercent <> COALESCE(vbMarginPercent,0))) 
    THEN
        -- сохранили историю
        PERFORM gpInsertUpdate_ObjectHistory_MarginCategoryItem(
                ioId                    := 0 :: Integer,    -- ключ объекта <Элемент истории>
                inMarginCategoryItemId  := inId,            -- 
                inPrice                 := inMinPrice,      -- Цена
                inValue                 := inMarginPercent, -- % наценки
                inSession  := inSession);

    END IF;


   -- сохранили протокол
   --PERFORM lpInsert_ObjectProtocol (inId, UserId);
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);


   RETURN 
      QUERY SELECT inId AS Id;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MarginCategoryItem (Integer, TFloat, TFloat, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.17         *
 09.04.15                          *
*/

-- тест
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginCategory(0, 2,'ау','2'); ROLLBACK
