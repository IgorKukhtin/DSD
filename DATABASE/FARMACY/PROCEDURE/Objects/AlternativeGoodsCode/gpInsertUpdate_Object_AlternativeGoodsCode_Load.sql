-- Function: gpInsertUpdate_Object_AlternativeGoodsCode(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AlternativeGoodsCode (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AlternativeGoodsCode(
 INOUT ioId               Integer   , -- ключ объекта <Условия договора>
    IN inGoodsMainCode    TVarChar  , -- Главный товар
    IN inGoodsCode        TVarChar  , -- Товар для замены
    IN inRetailId         Integer   , -- Торговая сеть
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsMainId Integer;
   DECLARE vbGoodsId  Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AlternativeGoodsCode());
     SELECT Id from Object_Goods_View
      WHERE ObjectId = 25603 AND GoodsCode = 24673::TVarChar

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AlternativeGoodsCode(
    IN inGoodsMainId   , -- Главный товар
    IN inGoodsId       , -- Товар для замены
    IN inRetailId      , -- Торговая сеть
    IN inSession          TVarChar    -- сессия пользователя
   

   -- сохранили протокол
--   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AlternativeGoodsCode (Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         *
  
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_AlternativeGoodsCode (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
