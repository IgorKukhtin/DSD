-- Function: gpUpdate_Object_GoodsPropertyValue_Nom()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_Nom(Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsPropertyValue_Nom(
    IN inId                  Integer,    -- ключ объекта <Значения свойств товаров для классификатора>
    IN inGoodsId             Integer,    -- Товары
    IN inGoodsKindId         Integer,    -- Виды товара
    IN inisGoodsTypeKind     Boolean,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId           Integer;
   DECLARE vbisGoodsTypeKind  Boolean;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsPropertyValue_VMS());

   -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;
  
   SELECT CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind
  INTO vbisGoodsTypeKind
   FROM Object_GoodsByGoodsKind_View
        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom
                             ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ObjectId = Object_GoodsByGoodsKind_View.Id
                            AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom()
   WHERE Object_GoodsByGoodsKind_View.GoodsId     = inGoodsId
     AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;

   ---
   IF inisGoodsTypeKind = TRUE AND vbisGoodsTypeKind = TRUE
   THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom(), inId, zc_Enum_GoodsTypeKind_Nom());
   ELSEIF inisGoodsTypeKind = TRUE AND vbisGoodsTypeKind = FALSE
   THEN
         RAISE EXCEPTION 'Ошибка. В свойствах товара <%> <%> значения <%> НЕТ.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId), lfGet_Object_ValueData (zc_Enum_GoodsTypeKind_Nom());
   ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom(), inId, Null);
   END IF;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.02.19         *
*/

-- тест
-- 

