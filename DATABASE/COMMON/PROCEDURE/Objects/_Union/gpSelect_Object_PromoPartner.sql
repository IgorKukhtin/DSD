-- Function: gpSelect_Object_PromoPartner()

DROP FUNCTION IF EXISTS gpSelect_Object_PromoPartner (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PromoPartner(
    IN inisShowDel           Boolean,     -- показать все
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescId Integer, DescName TVarChar, isErased Boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
       
        SELECT 
            Object_PromoPartner.Id
          , Object_PromoPartner.ObjectCode AS Code
          , Object_PromoPartner.ValueData  AS Name
          , Object_PromoPartner.DescId     AS DescId
          , ObjectDesc.ItemName            AS DescName
          , Object_PromoPartner.isErased
        FROM 
            Object AS Object_PromoPartner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_PromoPartner.DescId
        WHERE 
            Object_PromoPartner.DescId in (zc_Object_Partner(),zc_Object_Juridical(),zc_Object_Retail())
            AND
            (
                Object_PromoPartner.isErased = FALSE
                OR
                inisShowDel = TRUE
            )
        ORDER BY
            ObjectDesc.ItemName,
            Object_PromoPartner.ValueData;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PromoPartner (Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 06.11.15                                                         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_PromoPartner (inisShowDel := FALSE, inSession := zfCalc_UserAdmin())
