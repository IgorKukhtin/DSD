-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitForFarmacyCash(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForFarmacyCash(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar
             , ParentId Integer, ParentName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , UserFarmacyCashId Integer, UserFarmacyCashName TVarChar
             , FarmacyCashAmount TFloat, FarmacyCashDate TDateTime
) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

    RETURN QUERY 
     
        SELECT Object_Unit.Id                       AS Id  
             , Object_Unit.ValueData                AS Name
             , COALESCE(Object_Parent.Id,0)         AS ParentId
             , Object_Parent.ValueData              AS ParentName
             , Object_Juridical.Id                  AS JuridicalId
             , Object_Juridical.ValueData           AS JuridicalName
             , Object_UserFarmacyCash.Id            AS UserFarmacyCashId
             , Object_UserFarmacyCash.ValueData     AS UserFarmacyCashName

             , ObjectFloat_FarmacyCash.ValueData    AS FarmacyCashAmount
             , ObjectDate_FarmacyCash.ValueData     AS FarmacyCashDate

        FROM Object AS Object_Unit

        INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                            AND ObjectLink_Unit_Parent.ChildObjectId > 0 -- исключили "группы"
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
         
        LEFT JOIN ObjectLink AS ObjectLink_Unit_UserFarmacyCash
                             ON ObjectLink_Unit_UserFarmacyCash.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_UserFarmacyCash.DescId = zc_ObjectLink_Unit_UserFarmacyCash()
        LEFT JOIN Object AS Object_UserFarmacyCash ON Object_UserFarmacyCash.Id = ObjectLink_Unit_UserFarmacyCash.ChildObjectId    

        LEFT JOIN ObjectFloat AS ObjectFloat_FarmacyCash
                              ON ObjectFloat_FarmacyCash.ObjectId = Object_Unit.Id
                             AND ObjectFloat_FarmacyCash.DescId = zc_ObjectFloat_Unit_FarmacyCash()

        LEFT JOIN ObjectDate AS ObjectDate_FarmacyCash
                             ON ObjectDate_FarmacyCash.ObjectId = Object_Unit.Id
                            AND ObjectDate_FarmacyCash.DescId = zc_ObjectDate_Unit_FarmacyCash()

        WHERE Object_Unit.DescId = zc_Object_Unit()
        ORDER BY Object_Unit.ValueData
       ;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UnitForFarmacyCash(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.16         *
*/

-- тест
 --SELECT * FROM gpSelect_Object_UnitForFarmacyCash ('2')