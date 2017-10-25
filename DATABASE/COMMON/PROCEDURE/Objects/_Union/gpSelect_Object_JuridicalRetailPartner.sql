-- Function: gpSelect_Object_JuridicalRetailPartner()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalRetailPartner (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalRetailPartner(
    IN inShowAll         Boolean,     -- показать все
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DescId Integer, DescName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
       
        SELECT 
            Object_Juridical.Id
          , Object_Juridical.ObjectCode  AS Code
          , Object_Juridical.ValueData   AS Name

          , Object_Juridical.DescId      AS DescId
          , ObjectDesc.ItemName          AS DescName
          , Object_Juridical.isErased    AS isErased

        FROM Object AS Object_Juridical
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
        WHERE Object_Juridical.DescId = zc_Object_Juridical()
         AND (Object_Juridical.isErased = FALSE OR inShowAll = TRUE)
        UNION ALL
        SELECT 
            Object_Retail.Id
          , Object_Retail.ObjectCode  AS Code
          , Object_Retail.ValueData   AS Name
          , Object_Retail.DescId      AS DescId
          , ObjectDesc.ItemName       AS DescName
          , Object_Retail.isErased    AS isErased
          
        FROM Object AS Object_Retail
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Retail.DescId
        WHERE Object_Retail.DescId = zc_Object_Retail()
          AND (Object_Retail.isErased = FALSE OR inShowAll = TRUE)
        UNION ALL
        SELECT 
            Object_Partner.Id
          , Object_Partner.ObjectCode  AS Code
          , Object_Partner.ValueData   AS Name
          , Object_Partner.DescId      AS DescId
          , ObjectDesc.ItemName        AS DescName
          , Object_Partner.isErased    AS isErased
          
        FROM Object AS Object_Partner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
        WHERE Object_Partner.DescId = zc_Object_Partner()
          AND (Object_Partner.isErased = FALSE OR inShowAll = TRUE)

       UNION ALL
        SELECT 
            NULL::Integer           Id
          , NULL::Integer           AS Code
          , 'Очистить Значение' :: TVarChar    AS Name
          , NULL::Integer           AS DescId
          , NULL::TVarChar          AS DescName
          , FALSE                   AS isErased
       ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 24.10.17         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalRetailPartner (inShowAll := FALSE, inSession := zfCalc_UserAdmin())
