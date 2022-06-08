-- Function: gpReport_TelegramBot_PublishedSite()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_PublishedSite (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_PublishedSite(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Message Text             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMessage Text;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    vbUserId:= lpGetUserBySession (inSession);
   
    IF EXISTS (SELECT 1
               FROM Object_Goods_Main
               WHERE Object_Goods_Main.isPublished <> Object_Goods_Main.isPublishedSite
                  OR Object_Goods_Main.isPublished = True AND Object_Goods_Main.isPublishedSite IS NULL)
    THEN
      RETURN QUERY
      SELECT 'Есть расхождение между признаками опубликован на сайте и в базе.';
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В. 
 06.04.22                                                       * 
*/

-- тест
-- 

SELECT * FROM gpReport_TelegramBot_PublishedSite(inSession := '3');