-- Function: gpInsertUpdate_Object_LinkGoods(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LinkGoods (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LinkGoods(
 INOUT ioId               Integer   , -- ключ объекта <Условия договора>
    IN inGoodsMainId      Integer   , -- Главный товар
    IN inGoodsId          Integer   , -- Товар для замены
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LinkGoods());
   vbUserId := lpGetUserBySession(inSession);

   -- !!!выход!!!
   IF COALESCE (ioId, 0) = 0 AND COALESCE (inGoodsMainId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
   THEN
       RETURN;
   END IF;

   -- проверка
   IF EXISTS (SELECT Object_LinkGoods_View.Id
              FROM Object_LinkGoods_View
              WHERE Object_LinkGoods_View.GoodsMainId = inGoodsMainId
                AND Object_LinkGoods_View.GoodsId = inGoodsId
                AND Object_LinkGoods_View.Id <> COALESCE (ioId, 0)
             )
   THEN
       RAISE EXCEPTION 'Связь между данными товарами уже установлена';
   END IF;

   -- сохранили
   ioId := lpInsertUpdate_Object_LinkGoods (ioId, inGoodsMainId, inGoodsId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.02.19                                        *
 26.08.14                         *
 02.07.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_LinkGoods (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
