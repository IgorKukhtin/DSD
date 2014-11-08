-- Function: gpInsertUpdate_Object_LinkGoods(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_LinkGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_LinkGoods(
    IN inId               Integer   , -- ключ объекта <Условия договора>
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE(Id Integer, GoodsMainCode Integer, GoodsMainName TVarChar) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LinkGoods());
   vbUserId := lpGetUserBySession(inSession);

   PERFORM lpDelete_Object(inId, inSession);

   RETURN QUERY SELECT 0 AS Id, 0 AS GoodsMainCode, ''::TVarChar AS GoodsMainName;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_LinkGoods (Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.14                         *
  
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_LinkGoods (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
