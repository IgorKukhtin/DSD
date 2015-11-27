-- Function: gpSelect_Object_PromoPartner()

DROP FUNCTION IF EXISTS gpSelect_Object_PromoPartner (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PromoPartner(
    IN inisShowDel           Boolean,     -- показать все
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescId Integer, DescName TVarChar, isErased Boolean,
    Juridical_Name TVarChar, Retail_Name TVarChar)
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
          , Object_Juridical.ValueData     AS Juridical_Name
          , Object_Retail.ValueData        AS Retail_Name
        FROM 
            Object AS Object_PromoPartner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_PromoPartner.DescId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = Object_PromoPartner.Id
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                      AND Object_PromoPartner.DescId = zc_Object_Partner()
            LEFT OUTER JOIN Object AS Object_Juridical
                                   ON Object_Juridical.id = ObjectLink_Partner_Juridical.ChildObjectId
                                  AND Object_Juridical.DescId = zc_Object_Juridical()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = CASE 
                                                                                     WHEN Object_PromoPartner.DescId = zc_Object_Partner() THEN Object_Juridical.Id
                                                                                     WHEN Object_PromoPartner.DescId = zc_Object_Juridical() THEN Object_PromoPartner.Id
                                                                                 END
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                      AND Object_PromoPartner.DescId in (zc_Object_Partner(),zc_Object_Juridical())
            LEFT OUTER JOIN Object AS Object_Retail
                                   ON Object_Retail.id = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND Object_Retail.DescId = zc_Object_Retail() 
                                   
        WHERE 
            Object_PromoPartner.DescId in (zc_Object_Partner(),zc_Object_Juridical() /*,zc_Object_Retail()*/)
            AND
            (
                Object_PromoPartner.isErased = FALSE
                OR
                inisShowDel = TRUE
            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PromoPartner (Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 27.11.15                                        * rem zc_Object_Retail
 06.11.15                                                         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_PromoPartner (inisShowDel := FALSE, inSession := zfCalc_UserAdmin())
