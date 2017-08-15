-- Function: gpSetErased_GoodsSP()

DROP FUNCTION IF EXISTS gpSetErased_GoodsSP (TVarChar);


CREATE OR REPLACE FUNCTION gpSetErased_GoodsSP(
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);
  
  
    -- перед загрузкой всем товарам свойство <Участвует в СП> устанавливаем = FALSE
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), ObjectBoolean_Goods_SP.ObjectId, FALSE)         -- сохранили свойство <SP>
          , lpInsert_ObjectProtocol (ObjectBoolean_Goods_SP.ObjectId, vbUserId)                                        -- сохранили протокол
    FROM ObjectBoolean AS ObjectBoolean_Goods_SP 
    WHERE ObjectBoolean_Goods_SP.DescId    = zc_ObjectBoolean_Goods_SP()
     AND (ObjectBoolean_Goods_SP.ValueData = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.08.17         *
*/

-- тест
-- SELECT * FROM gpSetErased_GoodsSP ('3');