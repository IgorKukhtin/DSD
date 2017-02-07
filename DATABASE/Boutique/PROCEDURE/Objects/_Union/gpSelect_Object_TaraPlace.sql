-- Function: gpSelect_Object_PartnerAndUnit()

DROP FUNCTION IF EXISTS gpSelect_Object_PartnerAndUnit (Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_TaraPlace (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TaraPlace(
    IN inisShowDel         Boolean,     -- показать все
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescId Integer, DescName TVarChar, isErased Boolean,
    Juridical_Name TVarChar, Retail_Name TVarChar, BranchName TVarChar)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
       
        SELECT 
            Object_Partner.Id
          , Object_Partner.ObjectCode  AS Code
          , Object_Partner.ValueData   AS Name
          , Object_Partner.DescId      AS DescId
          , ObjectDesc.ItemName        AS DescName
          , Object_Partner.isErased
          , Object_Juridical.ValueData AS Juridical_Name
          , Object_Retail.ValueData    AS Retail_Name
          , NULL::TVarChar             AS BranchName
        FROM 
            Object AS Object_Partner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                      AND Object_Partner.DescId = zc_Object_Partner()
            LEFT OUTER JOIN Object AS Object_Juridical
                                   ON Object_Juridical.id = ObjectLink_Partner_Juridical.ChildObjectId
                                  AND Object_Juridical.DescId = zc_Object_Juridical()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = CASE 
                                                                                     WHEN Object_Partner.DescId = zc_Object_Partner() THEN Object_Juridical.Id
                                                                                     WHEN Object_Partner.DescId = zc_Object_Juridical() THEN Object_Partner.Id
                                                                                 END
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                      AND Object_Partner.DescId in (zc_Object_Partner(),zc_Object_Juridical())
            LEFT OUTER JOIN Object AS Object_Retail
                                   ON Object_Retail.id = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND Object_Retail.DescId = zc_Object_Retail() 
                                   
        WHERE 
            Object_Partner.DescId in (zc_Object_Partner(),zc_Object_Juridical() ,zc_Object_Retail())
            AND
            (
                Object_Partner.isErased = FALSE
                OR
                inisShowDel = TRUE
            )
        UNION ALL
        SELECT 
            Object_Unit.Id
          , Object_Unit.ObjectCode  AS Code
          , Object_Unit.ValueData   AS Name
          , Object_Unit.DescId      AS DescId
          , ObjectDesc.ItemName     AS DescName
          , Object_Unit.isErased
          , NULL::TVarChar          AS Juridical_Name
          , NULL::TVarChar          AS Retail_Name
          , Object_Branch.ValueData AS BranchName
        FROM 
            Object AS Object_Unit
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                       ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                      AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                      AND Object_Unit.DescId = zc_Object_Unit()
            LEFT OUTER JOIN Object AS Object_Branch
                                   ON Object_Branch.id = ObjectLink_Unit_Branch.ChildObjectId
                                  AND Object_Branch.DescId = zc_Object_Branch()
        WHERE 
            Object_Unit.DescId in (zc_Object_Unit(),zc_Object_Branch())
            AND
            (
                Object_Unit.isErased = FALSE
                OR
                inisShowDel = TRUE
            )
        UNION ALL
        SELECT 
            Object_Member.Id
          , Object_Member.ObjectCode  AS Code
          , Object_Member.ValueData   AS Name
          , Object_Member.DescId      AS DescId
          , ObjectDesc.ItemName       AS DescName
          , Object_Member.isErased
          , NULL::TVarChar            AS Juridical_Name
          , NULL::TVarChar            AS Retail_Name
          , NULL::TVarChar            AS BranchName
        FROM 
            Object AS Object_Member
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
            INNER JOIN (SELECT DISTINCT CLO.ObjectId
                        FROM Container Inner Join ContainerLinkObject AS CLO
                                                                      ON CLO.DescId = zc_ContainerLinkObject_Member()
                                                                     AND CLO.ContainerId = Container.Id
                        WHERE Container.DescId = zc_Container_Count()) AS CLO_Member
                                                                             ON CLO_Member.ObjectId = Object_Member.Id
        WHERE 
            Object_Member.DescId = zc_Object_Member();
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_TaraPlace (Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 17.12.15                                                         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_TaraPlace (inisShowDel := FALSE, inSession := zfCalc_UserAdmin())
