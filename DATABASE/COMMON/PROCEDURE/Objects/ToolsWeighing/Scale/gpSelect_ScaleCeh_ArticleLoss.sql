-- Function: gpSelect_ScaleCeh_Asset()

DROP FUNCTION IF EXISTS gpSelect_ScaleCeh_Asset (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ScaleCeh_Asset(
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (Id   Integer
             , Code Integer
             , Name TVarChar
             , InvNumber TVarChar
             , isErased  Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT Object_Asset.Id                   AS AssetId
            , Object_Asset.ObjectCode           AS AssetCode
            , Object_Asset.ValueData            AS AssetName
            , ObjectString_InvNumber.ValueData  AS InvNumber
            , Object_Asset.isErased             AS isErased

       FROM Object AS Object_Asset
            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = Object_Asset.Id
                                  AND ObjectString_InvNumber.DescId   = zc_ObjectString_Asset_InvNumber()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_DocGoods
                                    ON ObjectBoolean_DocGoods.ObjectId = Object_Asset.Id
                                   AND ObjectBoolean_DocGoods.DescId   = zc_ObjectBoolean_Asset_DocGoods()
       WHERE Object_Asset.DescId = zc_Object_Asset()
         AND Object_Asset.isErased = FALSE
         -- почти ВСЕ
         AND (ObjectBoolean_DocGoods.ValueData = TRUE OR vbUserId = 5)
       ORDER BY 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ScaleCeh_Asset (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.06.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ScaleCeh_Asset (inSession:=zfCalc_UserAdmin())
