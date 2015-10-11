DROP FUNCTION IF EXISTS gpDelete_Object_AdditionalGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_AdditionalGoods(
    IN inId               Integer   , -- ключ объекта <Дополнительные товары>
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LinkGoods());
    vbUserId := lpGetUserBySession(inSession);
    --Удаляем обьект <Дополнительные товары>
    PERFORM lpDelete_Object(inId, inSession);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_AdditionalGoods (Integer, TVarChar) OWNER TO postgres;
  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 16.10.14                                                         *
  
*/