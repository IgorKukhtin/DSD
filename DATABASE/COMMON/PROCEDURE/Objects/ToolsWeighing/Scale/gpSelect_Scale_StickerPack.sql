-- Function: gpSelect_Scale_StickerPack()

DROP FUNCTION IF EXISTS gpSelect_Scale_StickerPack (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_StickerPack(
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (GroupId             Integer
             , GroupCode           Integer
             , GroupName           TVarChar
             , StickerPackId       Integer
             , StickerPackCode     Integer
             , StickerPackName     TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT 1                            :: Integer  AS GroupId
            , 1                            :: Integer  AS GroupCode
            , 'Группа'                     :: TVarChar AS GroupName
            , Object_StickerPack.Id                    AS StickerPackId
            , Object_StickerPack.ObjectCode            AS StickerPackCode
            , Object_StickerPack.ValueData             AS StickerPackName

       FROM Object AS Object_StickerPack
       WHERE Object_StickerPack.DescId = zc_Object_StickerPack()
         AND Object_StickerPack.ObjectCode <> 0
         AND Object_StickerPack.isErased = FALSE
       ORDER BY 1, 5
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Scale_StickerPack (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.12.17                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_StickerPack (inSession:=zfCalc_UserAdmin())
