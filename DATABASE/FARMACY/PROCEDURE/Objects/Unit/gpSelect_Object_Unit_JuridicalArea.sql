-- Function: gpSelect_Object_Unit_JuridicalArea()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_JuridicalArea(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_JuridicalArea(
    IN inisShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId                 Integer
             , UnitCode               Integer
             , UnitName               TVarChar
             , UnitAddress            TVarChar
             , ProvinceCityId_Unit    Integer
             , ProvinceCityName_Unit  TVarChar
             , ParentId_Unit          Integer
             , ParentName_Unit        TVarChar
             , UserManagerId_Unit     Integer
             , UserManagerName_Unit   TVarChar
             , JuridicalName_Unit     TVarChar
             , isErased               Boolean
             , AreaId_Unit            Integer
             , AreaName_Unit          TVarChar
             , CreateDate_Unit        TDateTime
             , CloseDate_Unit         TDateTime
             , JuridicalId            Integer
             , JuridicalCode          Integer
             , JuridicalName          TVarChar
             , RetailId_Juridical     Integer
             , RetailName_Juridical   TVarChar
             , AreaId_Juridical       Integer
             , AreaName_Juridical     TVarChar
             , isCorporate_Juridical  Boolean
             , isDefault_JuridicalArea Boolean
             
) AS     
$BODY$   
BEGIN    

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
    WITH 
    tmpUnit AS (SELECT Object_Unit.Id                                       AS Id
                     , Object_Unit.ObjectCode                               AS Code
                     , Object_Unit.ValueData                                AS Name
                     , ObjectString_Unit_Address.ValueData                  AS Address
                     , Object_ProvinceCity.Id                               AS ProvinceCityId
                     , Object_ProvinceCity.ValueData                        AS ProvinceCityName
                     , COALESCE(ObjectLink_Unit_Parent.ChildObjectId,0)     AS ParentId
                     , Object_Parent.ValueData                              AS ParentName
                     , COALESCE (Object_UserManager.Id, 0)                  AS UserManagerId
                     , Object_UserManager.ValueData                         AS UserManagerName
                     , Object_Juridical.ValueData                           AS JuridicalName
                     --, ObjectBoolean_isLeaf.ValueData                       AS isLeaf
                     , Object_Unit.isErased                                 AS isErased
                     , Object_Area.Id                                       AS AreaId
                     , Object_Area.ValueData                                AS AreaName
                     , COALESCE( ObjectDate_Create.ValueData, NULL) :: TDateTime  AS CreateDate
                     , COALESCE(ObjectDate_Close.ValueData, NULL)   :: TDateTime  AS CloseDate
                FROM Object AS Object_Unit
                       INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                                            AND ObjectLink_Unit_Parent.ChildObjectId > 0
                       LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
                       
                       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                            ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                           AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
             
                       LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                            ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                                           AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                       LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
               
                       LEFT JOIN ObjectLink AS ObjectLink_Unit_UserManager
                                            ON ObjectLink_Unit_UserManager.ObjectId = Object_Unit.Id
                                           AND ObjectLink_Unit_UserManager.DescId = zc_ObjectLink_Unit_UserManager()
                       LEFT JOIN Object AS Object_UserManager ON Object_UserManager.Id = ObjectLink_Unit_UserManager.ChildObjectId
               
                       LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                            ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id 
                                           AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                       LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId
                               
                       LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                               ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                              AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()
               
                       LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                              ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                             AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
               
                       LEFT JOIN ObjectDate AS ObjectDate_Create
                                            ON ObjectDate_Create.ObjectId = Object_Unit.Id
                                           AND ObjectDate_Create.DescId = zc_ObjectDate_Unit_Create()
                       LEFT JOIN ObjectDate AS ObjectDate_Close
                                            ON ObjectDate_Close.ObjectId = Object_Unit.Id
                                           AND ObjectDate_Close.DescId = zc_ObjectDate_Unit_Close()
                                           
                WHERE Object_Unit.DescId = zc_Object_Unit()
                  AND (inisShowAll = True OR Object_Unit.isErased = False)
                )
                
  , tmpJuridicalArea AS (SELECT ObjectLink_JuridicalArea_Juridical.ChildObjectId                 AS JuridicalId
                              , ObjectLink_JuridicalArea_Area.ChildObjectId                      AS AreaId
                              , Object_Area.ValueData                                            AS AreaName
                              , COALESCE (ObjectBoolean_JuridicalArea_Default.ValueData, FALSE)  AS isDefault
                         FROM Object AS Object_JuridicalArea
                               INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                                     ON ObjectLink_JuridicalArea_Juridical.ObjectId = Object_JuridicalArea.Id 
                                                    AND ObjectLink_JuridicalArea_Juridical.DescId = zc_ObjectLink_JuridicalArea_Juridical()
                               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_JuridicalArea_Juridical.ChildObjectId       
                               
                               LEFT JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                    ON ObjectLink_JuridicalArea_Area.ObjectId = Object_JuridicalArea.Id 
                                                   AND ObjectLink_JuridicalArea_Area.DescId = zc_ObjectLink_JuridicalArea_Area()
                               LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_JuridicalArea_Area.ChildObjectId                     
                                                    
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_Default
                                                       ON ObjectBoolean_JuridicalArea_Default.ObjectId = Object_JuridicalArea.Id
                                                      AND ObjectBoolean_JuridicalArea_Default.DescId = zc_ObjectBoolean_JuridicalArea_Default()
                         WHERE Object_JuridicalArea.DescId = zc_Object_JuridicalArea()
                           AND Object_JuridicalArea.isErased = FALSE
                         )    
                                  
  , tmpJuridical_All AS (SELECT Object_Juridical.Id                 AS Id
                          , Object_Juridical.ObjectCode         AS Code
                          , Object_Juridical.ValueData          AS Name
                          , Object_Retail.Id                    AS RetailId
                          , Object_Retail.ValueData             AS RetailName 
                          , ObjectBoolean_isCorporate.ValueData AS isCorporate
                      FROM Object AS Object_Juridical
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
               
                          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                                  ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                      WHERE Object_Juridical.DescId = zc_Object_Juridical()
                        AND Object_Juridical.isErased = FALSE
                        AND COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) = FALSE
                     )
  , tmpJuridical AS (SELECT tmpJuridical_All.*
                          , tmpJuridicalArea.AreaId             AS AreaId
                          , tmpJuridicalArea.AreaName           AS AreaName
                          , tmpDefault.AreaId                   AS AreaId_Default
                          , tmpDefault.AreaName                 AS AreaName_Default
                          , COALESCE (tmpJuridicalArea.isDefault, FALSE)  AS isDefault
                     FROM tmpJuridical_All
                          LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = tmpJuridical_All.Id
                          
                          LEFT JOIN (SELECT tmpJuridical_All.Id
                                          , tmpDefault.AreaId    
                                          , tmpDefault.AreaName     
                                          , TRUE  AS isDefault
                                     FROM tmpJuridical_All
                                          INNER JOIN tmpJuridicalArea AS tmpDefault 
                                                                      ON tmpDefault.JuridicalId = tmpJuridical_All.Id
                                                                     AND tmpDefault.isDefault = TRUE   
                                     ) AS tmpDefault ON tmpDefault.Id = tmpJuridical_All.Id
                    )
                     
                        
    SELECT tmpUnit.Id                 AS UnitId
         , tmpUnit.Code               AS UnitCode
         , tmpUnit.Name               AS UnitName
         , tmpUnit.Address            AS UnitAddress
         , tmpUnit.ProvinceCityId     AS ProvinceCityId_Unit
         , tmpUnit.ProvinceCityName   AS ProvinceCityName_Unit
         , tmpUnit.ParentId           AS ParentId_Unit
         , tmpUnit.ParentName         AS ParentName_Unit
         , tmpUnit.UserManagerId      AS UserManagerId_Unit
         , tmpUnit.UserManagerName    AS UserManagerName_Unit
         , tmpUnit.JuridicalName      AS JuridicalName_Unit
         , tmpUnit.isErased           AS isErased_Unit
         , tmpUnit.AreaId             AS AreaId_Unit
         , tmpUnit.AreaName           AS AreaName_Unit
         , tmpUnit.CreateDate         AS CreateDate_Unit
         , tmpUnit.CloseDate          AS CloseDate_Unit
         
         , COALESCE (tmpJuridical.Id, tmpJuridical_Default.Id)                   AS JuridicalId
         , COALESCE (tmpJuridical.Code, tmpJuridical_Default.Code)               AS JuridicalCode
         , COALESCE (tmpJuridical.Name, tmpJuridical_Default.Name)               AS JuridicalName
         , COALESCE (tmpJuridical.RetailId, tmpJuridical_Default.RetailId)       AS RetailId_Juridical
         , COALESCE (tmpJuridical.RetailName, tmpJuridical_Default.RetailName)   AS RetailName_Juridical
         , COALESCE (tmpJuridical.AreaId, tmpJuridical_Default.AreaId)           AS AreaId_Juridical
         , COALESCE (tmpJuridical.AreaName, tmpJuridical_Default.AreaName)       AS AreaName_Juridical

         , COALESCE (tmpJuridical.isCorporate, tmpJuridical_Default.isCorporate) AS isCorporate_Juridical
         , COALESCE (tmpJuridical.isDefault, tmpJuridical_Default.isDefault)     AS isDefault_JuridicalArea
         
    FROM tmpUnit
         LEFT JOIN tmpJuridical ON (tmpJuridical.AreaId = tmpUnit.AreaId OR COALESCE (tmpJuridical.AreaId, 0) = 0 OR tmpJuridical.isDefault = TRUE) 

   ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.09.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_JuridicalArea (False, '2')