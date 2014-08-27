-- Function: gpInsertUpdate_Object_GoodsByGoodsKind1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKind1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind1CLink(
    IN inId                     Integer,    -- ключ
    IN inCode                   Integer,    -- Код
    IN inName                   TVarChar,   -- Название
    IN inGoodsId                Integer,    -- 
    IN inGoodsKindId            Integer,    -- 
    IN inBranchId               Integer,    -- 
    IN inBranchTopId            Integer,    -- 
    IN inIsSybase               Boolean  DEFAULT NULL,    -- 
    IN inSession                TVarChar DEFAULT ''       -- сессия пользователя
)
  RETURNS TABLE (Id Integer, BranchId Integer, BranchName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbBranchId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind1CLink());
   vbUserId := lpGetUserBySession (inSession);

   -- что-то
   IF COALESCE(inBranchId, 0) = 0 THEN
      vbBranchId := inBranchTopId;
   ELSE
      vbBranchId := inBranchId;
   END IF;
   
   -- проверка
   IF COALESCE (inCode, 0) = 0 AND COALESCE (TRIM (inName), '') = '' THEN
       RAISE EXCEPTION 'Ошибка. Не установлен <Код>.';
   END IF;
   -- проверка
   IF COALESCE (TRIM (inName), '') = '' THEN
       RAISE EXCEPTION 'Ошибка. Не установлено <Название>.';
   END IF;
   -- проверка
   IF COALESCE (vbBranchId, 0) = 0 THEN
       RAISE EXCEPTION 'Ошибка. Не установлен <Филиал>.';
   END IF;
   -- проверка
   IF inId <> 0
   THEN
       IF COALESCE (inGoodsId, 0) = 0 THEN
           RAISE EXCEPTION 'Ошибка. Не установлен <Товар>.';
       END IF;
       IF COALESCE (inGoodsKindId, 0) = 0 THEN
           RAISE EXCEPTION 'Ошибка. Не установлен <Вид товара>.';
       END IF;
   END IF;

   -- проверка уникальность inCode для !!!одного!! Филиала
   IF inCode <> 0
   THEN IF EXISTS (SELECT ObjectLink.ChildObjectId
                   FROM ObjectLink
                        JOIN Object ON Object.Id = ObjectLink.ObjectId
                                   AND Object.ObjectCode = inCode
                   WHERE ObjectLink.ChildObjectId = vbBranchId
                     AND ObjectLink.ObjectId <> COALESCE (inId, 0)
                     AND ObjectLink.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch())
        THEN
            RAISE EXCEPTION 'Ошибка. Код 1С <%> уже установлен у <%>. ', inCode, lfGet_Object_ValueData (vbBranchId);
        END IF;
   END IF;


   -- сохранили <Объект>
   inId := lpInsertUpdate_Object (inId, zc_Object_GoodsByGoodsKind1CLink(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind1CLink_Goods(), inId, inGoodsId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind(), inId, inGoodsKindId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind1CLink_Branch(), inId, vbBranchId);
   IF inIsSybase IS NOT NULL THEN 
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase(), inId, inIsSybase);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

   -- вернули значения
   RETURN 
     QUERY SELECT inId, Object.Id, Object.ValueData FROM Object WHERE Object.Id = vbBranchId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar)  OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.02.14                                        * all
 11.02.14                        *
*/
