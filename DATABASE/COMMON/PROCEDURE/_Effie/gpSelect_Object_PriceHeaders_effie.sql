-- Function: gpSelect_Object_PriceHeaders_effie

DROP FUNCTION IF EXISTS gpSelect_Object_PriceHeaders_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceHeaders_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId           TVarChar   -- Идентификатор канала прайса
             , Name            TVarChar   -- Название прайса
             , isDeleted       Boolean    -- Признак активности записи: 0 = активна / 1 = не активна
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     SELECT Object_PriceList.Id                             ::TVarChar AS extId
          , TRIM (Object_PriceList.ValueData)               ::TVarChar AS Name
          , Object_PriceList.isErased                       ::Boolean  AS isDeleted
     FROM Object AS Object_PriceList
     WHERE Object_PriceList.DescId = zc_Object_PriceList()
       AND Object_PriceList.isErased = FALSE
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceHeaders_effie (zfCalc_UserAdmin()::TVarChar);
