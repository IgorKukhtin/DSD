-- Function: gpSelect_Object_ChannelSales_effie

DROP FUNCTION IF EXISTS gpSelect_Object_ChannelSales_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ChannelSales_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id              TVarChar   -- Идентификатор канала продаж
             , Name            TVarChar   -- Название канала продаж
             , isDeleted       Integer    -- Признак активности записи: 0 = активна / 1 = не активна
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     SELECT Object_PartnerTag.Id                             ::TVarChar AS Id
          , TRIM (Object_PartnerTag.ValueData)               ::TVarChar AS Name
          , CASE WHEN Object_PartnerTag.isErased = FALSE THEN 0 ELSE 1 END ::Integer AS isDeleted
     FROM Object AS Object_PartnerTag
     WHERE Object_PartnerTag.DescId = zc_Object_PartnerTag()

    UNION ALL
     SELECT zfCalc_UserAdmin()  ::TVarChar AS Id
          , 'канал відсутній'   ::TVarChar AS Name
            -- FALSE
          , 0  ::Integer AS isDeleted
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ChannelSales_effie (zfCalc_UserAdmin()::TVarChar);
