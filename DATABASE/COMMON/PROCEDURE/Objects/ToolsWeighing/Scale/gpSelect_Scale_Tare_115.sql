-- Function: gpSelect_Scale_Tare_115()

DROP FUNCTION IF EXISTS gpSelect_Scale_Tare_115 (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Tare_115(
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (GuideId   Integer
             , GuideCode Integer
             , GuideName TVarChar
             , Weight    TFloat
             , NPP       Integer
             , isErased  Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT Object_Box.Id         AS GuideId
            , Object_Box.ObjectCode AS GuideCode
            , ('  ' || Object_Box.ValueData) :: TVarChar AS GuideName
            , ObjectFloat_Box_Weight.ValueDaTa         AS Weight
            , ObjectFloat_Box_NPP.ValueDaTa :: Integer AS NPP
            , Object_Box.isErased   AS isErased
       FROM Object AS Object_Box
            INNER JOIN ObjectFloat AS ObjectFloat_Box_NPP
                                   ON ObjectFloat_Box_NPP.ObjectId  = Object_Box.Id
                                  AND ObjectFloat_Box_NPP.DescId    = zc_ObjectFloat_Box_NPP()
                                  AND ObjectFloat_Box_NPP.ValueDaTa > 0
            INNER JOIN ObjectFloat AS ObjectFloat_Box_Weight
                                   ON ObjectFloat_Box_Weight.ObjectId  = Object_Box.Id
                                  AND ObjectFloat_Box_Weight.DescId    = zc_ObjectFloat_Box_Weight()
                                --AND ObjectFloat_Box_Weight.ValueDaTa > 0
                                  
       WHERE Object_Box.DescId = zc_Object_Box()
         AND Object_Box.isErased = FALSE
       ORDER BY ObjectFloat_Box_NPP.ValueDaTa ASC
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.04.22                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Tare_115 (inSession:=zfCalc_UserAdmin())
