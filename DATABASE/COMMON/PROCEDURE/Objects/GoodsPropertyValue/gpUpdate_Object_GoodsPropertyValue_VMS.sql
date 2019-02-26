-- Function: gpUpdate_Object_GoodsPropertyValue_AmountDoc()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_VMS(Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_VMS(Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsPropertyValue_VMS(
    IN inId                  Integer,    -- ключ объекта <Значения свойств товаров для классификатора>
    IN inGoodsId             Integer,    -- Товары
    IN inGoodsKindId         Integer,    -- Виды товара
    IN inisGoodsTypeKind_Sh  Boolean,
    IN inisGoodsTypeKind_Nom Boolean,
    IN inisGoodsTypeKind_Ves Boolean,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisGoodsTypeKind_Sh  Boolean;
   DECLARE vbisGoodsTypeKind_Nom Boolean;
   DECLARE vbisGoodsTypeKind_Ves Boolean;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsPropertyValue_VMS());

   -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;
  
   SELECT CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Sh
        , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Nom
        , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Ves
  INTO vbisGoodsTypeKind_Sh, vbisGoodsTypeKind_Nom, vbisGoodsTypeKind_Ves
   FROM Object_GoodsByGoodsKind_View
        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh
                             ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ObjectId = Object_GoodsByGoodsKind_View.Id
                            AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom
                             ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ObjectId = Object_GoodsByGoodsKind_View.Id
                            AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves
                             ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ObjectId = Object_GoodsByGoodsKind_View.Id
                            AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves()
   WHERE Object_GoodsByGoodsKind_View.GoodsId     = inGoodsId
     AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;

   ---
   IF inisGoodsTypeKind_Sh = TRUE AND vbisGoodsTypeKind_Sh = TRUE
   THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh(), inId, zc_Enum_GoodsTypeKind_Sh());
   ELSEIF inisGoodsTypeKind_Sh = TRUE AND vbisGoodsTypeKind_Sh = FALSE
   THEN
         RAISE EXCEPTION 'Ошибка. В свойствах товара <%> <%> значения <%> НЕТ.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId), lfGet_Object_ValueData (zc_Enum_GoodsTypeKind_Sh());
   ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh(), inId, Null);
   END IF;
   ---
   IF inisGoodsTypeKind_Nom = TRUE AND vbisGoodsTypeKind_Nom = TRUE
   THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom(), inId, zc_Enum_GoodsTypeKind_Nom());
   ELSEIF inisGoodsTypeKind_Nom = TRUE AND vbisGoodsTypeKind_Nom = FALSE
   THEN
         RAISE EXCEPTION 'Ошибка. В свойствах товара <%> <%> значения <%> НЕТ.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId), lfGet_Object_ValueData (zc_Enum_GoodsTypeKind_Nom());
   ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom(), inId, Null);
   END IF;
   ---
   IF inisGoodsTypeKind_Ves = TRUE AND vbisGoodsTypeKind_Ves = TRUE
   THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Ves(), inId, zc_Enum_GoodsTypeKind_Ves());
   ELSEIF inisGoodsTypeKind_Ves = TRUE AND vbisGoodsTypeKind_Ves = FALSE
   THEN
         RAISE EXCEPTION 'Ошибка. В свойствах товара <%> <%> значения <%> НЕТ.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId), lfGet_Object_ValueData (zc_Enum_GoodsTypeKind_Ves());
   ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Ves(), inId, Null);
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

