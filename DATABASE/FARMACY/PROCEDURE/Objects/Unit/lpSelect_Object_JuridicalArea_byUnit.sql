-- Function: gpSelect_Object_Unit_JuridicalArea()

DROP FUNCTION IF EXISTS lpSelect_Object_JuridicalArea_byUnit(Integer, Integer);
DROP FUNCTION IF EXISTS lpSelect_Object_JuridicalArea_byUnit(Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpSelect_Object_JuridicalArea_byUnit(
    IN inUnitId           Integer,
    IN inJuridicalId      Integer,
    IN inisShowAll        Boolean  DEFAULT FALSE
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
             , isErased_Unit          Boolean
             , isErased_Juridical     Boolean
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
             , isCorporate_Juridical  Boolean
             , AreaId_Juridical       Integer
             , AreaName_Juridical     TVarChar
             , isDefault_JuridicalArea Boolean
             , isOnly_JuridicalArea    Boolean
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
                     , Object_Unit.isErased                                 AS isErased
                     , Object_Area.Id                                       AS AreaId
                     , Object_Area.ValueData                                AS AreaName
                     , Object_Retail.Id                                     AS RetailId
                     , Object_Retail.ValueData                              AS RetailName 
                     , COALESCE (ObjectDate_Create.ValueData, NULL) :: TDateTime AS CreateDate
                     , COALESCE (ObjectDate_Close.ValueData, NULL)  :: TDateTime AS CloseDate
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
             
                       LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                       LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                                    
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
                  AND (Object_Unit.isErased = FALSE OR inisShowAll = TRUE)
                  AND (Object_Unit.Id = inUnitId OR inUnitId = 0)
                )
             
  , tmpJuridical AS (SELECT Object_Juridical.Id                 AS Id
                          , Object_Juridical.ObjectCode         AS Code
                          , Object_Juridical.ValueData          AS Name
                          , ObjectBoolean_isCorporate.ValueData AS isCorporate
                          , Object_Juridical.isErased           AS isErased
                      FROM Object AS Object_Juridical
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                                   ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                      WHERE Object_Juridical.DescId = zc_Object_Juridical()
                        AND (Object_Juridical.isErased = FALSE OR inisShowAll = TRUE)
                        AND COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) = FALSE
                        AND (Object_Juridical.Id = inJuridicalId OR inJuridicalId = 0)
                     )
                        
  , tmpJuridicalArea AS (SELECT ObjectLink_JuridicalArea_Juridical.ChildObjectId                 AS JuridicalId
                              , ObjectLink_JuridicalArea_Area.ChildObjectId                      AS AreaId
                              , Object_Area.ValueData                                            AS AreaName
                              , COALESCE (ObjectBoolean_JuridicalArea_Default.ValueData, FALSE)  AS isDefault
                              , CASE WHEN ObjectLink_JuridicalArea_Juridical.ChildObjectId IN (2618417 -- ГАЙДАР ПЛЮС ООО
                                                                                             , 183322  -- Золотой Орлан
                                                                                              )
                                          THEN TRUE
                                     ELSE COALESCE (ObjectBoolean_JuridicalArea_Only.ValueData, FALSE)
                                END AS isOnly
                         FROM Object AS Object_JuridicalArea
                               INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                                     ON ObjectLink_JuridicalArea_Juridical.ObjectId = Object_JuridicalArea.Id 
                                                    AND ObjectLink_JuridicalArea_Juridical.DescId = zc_ObjectLink_JuridicalArea_Juridical()
                                                    AND (ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_JuridicalArea_Juridical.ChildObjectId       
                               
                               LEFT JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                    ON ObjectLink_JuridicalArea_Area.ObjectId = Object_JuridicalArea.Id 
                                                   AND ObjectLink_JuridicalArea_Area.DescId = zc_ObjectLink_JuridicalArea_Area()
                               LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_JuridicalArea_Area.ChildObjectId                     
                                                    
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_Default
                                                       ON ObjectBoolean_JuridicalArea_Default.ObjectId = Object_JuridicalArea.Id
                                                      AND ObjectBoolean_JuridicalArea_Default.DescId = zc_ObjectBoolean_JuridicalArea_Default()

                               LEFT JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_Only
                                                       ON ObjectBoolean_JuridicalArea_Only.ObjectId = Object_JuridicalArea.Id
                                                      AND ObjectBoolean_JuridicalArea_Only.DescId = zc_ObjectBoolean_JuridicalArea_Only()
                         WHERE Object_JuridicalArea.DescId = zc_Object_JuridicalArea()
                           AND Object_JuridicalArea.isErased = FALSE
                         )    

   , tmpUnitJuridical AS (SELECT tmpUnit.Id                 AS UnitId
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
                               , tmpUnit.RetailId           AS RetailId_Juridical
                               , tmpUnit.RetailName         AS RetailName_Juridical
                                                              
                               , tmpJuridical.Id            AS JuridicalId
                               , tmpJuridical.Code          AS JuridicalCode
                               , tmpJuridical.Name          AS JuridicalName
                               , tmpJuridical.isCorporate   AS isCorporate_Juridical
                               , tmpJuridical.isErased      AS isErased_Juridical
                          FROM tmpUnit
                               CROSS JOIN tmpJuridical
                               LEFT JOIN (SELECT DISTINCT tmpJuridicalArea.JuridicalId FROM tmpJuridicalArea WHERE tmpJuridicalArea.isOnly = TRUE
                                         ) AS tmpIsOnly ON tmpIsOnly.JuridicalId = tmpJuridical.Id
                               LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = tmpJuridical.Id
                                                         AND tmpJuridicalArea.AreaId      = tmpUnit.AreaId
                          WHERE -- выбрали если Юр лицу не указан isOnly
                                tmpIsOnly.JuridicalId IS NULL
                                -- или он СТРОГО из определенного региона
                             OR tmpJuridicalArea.JuridicalId > 0
                          )
                           
    SELECT tmpUnitJuridical.UnitId
         , tmpUnitJuridical.UnitCode
         , tmpUnitJuridical.UnitName
         , tmpUnitJuridical.UnitAddress
         , tmpUnitJuridical.ProvinceCityId_Unit
         , tmpUnitJuridical.ProvinceCityName_Unit
         , tmpUnitJuridical.ParentId_Unit
         , tmpUnitJuridical.ParentName_Unit
         , tmpUnitJuridical.UserManagerId_Unit
         , tmpUnitJuridical.UserManagerName_Unit
         , tmpUnitJuridical.JuridicalName_Unit
         , tmpUnitJuridical.isErased_Unit
         , tmpUnitJuridical.isErased_Juridical
         , CASE WHEN tmpUnitJuridical.isErased_Unit = TRUE OR tmpUnitJuridical.isErased_Juridical = TRUE THEN TRUE ELSE FALSE END isErased
         , tmpUnitJuridical.AreaId_Unit
         , tmpUnitJuridical.AreaName_Unit
         , tmpUnitJuridical.CreateDate_Unit
         , tmpUnitJuridical.CloseDate_Unit
         
         , tmpUnitJuridical.JuridicalId
         , tmpUnitJuridical.JuridicalCode
         , tmpUnitJuridical.JuridicalName
         , tmpUnitJuridical.RetailId_Juridical
         , tmpUnitJuridical.RetailName_Juridical
         , tmpUnitJuridical.isCorporate_Juridical
         
         , COALESCE (tmp1.AreaId, COALESCE (tmp2.AreaId, COALESCE (tmp3.AreaId, 0)))                           AS AreaId_Juridical
         , COALESCE (tmp1.AreaName, COALESCE (tmp2.AreaName, COALESCE (tmp3.AreaName, '')))       :: TVarChar  AS AreaName_Juridical
         , COALESCE (tmp1.isDefault, COALESCE (tmp2.isDefault, COALESCE (tmp3.isDefault, FALSE))) :: Boolean   AS isDefault_JuridicalArea
         , COALESCE (tmp1.isOnly, COALESCE (tmp2.isOnly, COALESCE (tmp3.isOnly, FALSE)))          :: Boolean   AS isOnly_JuridicalArea
         
    From tmpUnitJuridical
         LEFT JOIN tmpJuridicalArea AS tmp1 ON tmp1.juridicalId = tmpUnitJuridical.JuridicalId AND tmp1.areaId = tmpUnitJuridical.AreaId_Unit 
         LEFT JOIN tmpJuridicalArea AS tmp2 ON tmp2.juridicalId = tmpUnitJuridical.JuridicalId AND tmp2.isDefault = TRUE
         LEFT JOIN tmpJuridicalArea AS tmp3 ON tmp3.juridicalId = tmpUnitJuridical.JuridicalId AND tmp3.AreaId = zc_Area_Basis() -- ДНЕПР 
   ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.10.17         *
*/

-- тест
-- SELECT * FROM lpSelect_Object_JuridicalArea_byUnit (0, 0)
