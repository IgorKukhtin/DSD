-- Function: gpSelect_Object_PartnerAndUnit()

DROP FUNCTION IF EXISTS gpSelect_Object_AssetPlace (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AssetPlace(
    IN inisShowDel         Boolean,     -- показать все
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescId Integer, DescName TVarChar
             , isErased Boolean
             , BranchName TVarChar
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
          , Object_Juridical.isErased
          , NULL::TVarChar              AS BranchName
        FROM Object AS Object_Juridical
            Inner JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id 
                               AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                               AND ObjectBoolean_isCorporate.ValueData = True
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                                   
        WHERE Object_Juridical.DescId = zc_Object_Juridical()
          AND (Object_Juridical.isErased = FALSE OR inisShowDel = TRUE)
        UNION ALL
        SELECT 
            Object_Unit.Id
          , Object_Unit.ObjectCode  AS Code
          , Object_Unit.ValueData   AS Name
          , Object_Unit.DescId      AS DescId
          , ObjectDesc.ItemName     AS DescName
          , Object_Unit.isErased
          , Object_Branch.ValueData AS BranchName
        FROM Object AS Object_Unit
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                       ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                      AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT OUTER JOIN Object AS Object_Branch
                                   ON Object_Branch.id = ObjectLink_Unit_Branch.ChildObjectId
                                  AND Object_Branch.DescId = zc_Object_Branch()
        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND (Object_Unit.isErased = FALSE OR inisShowDel = TRUE)
        UNION ALL
        SELECT 
            Object_Member.Id
          , Object_Member.ObjectCode  AS Code
          , Object_Member.ValueData   AS Name
          , Object_Member.DescId      AS DescId
          , ObjectDesc.ItemName       AS DescName
          , Object_Member.isErased
          , NULL::TVarChar            AS BranchName
        FROM Object AS Object_Member
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
        WHERE Object_Member.DescId = zc_Object_Member()
         AND (Object_Member.isErased = FALSE OR inisShowDel = TRUE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AssetPlace (Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 31.07.16         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_AssetPlace (inisShowDel := FALSE, inSession := zfCalc_UserAdmin())
