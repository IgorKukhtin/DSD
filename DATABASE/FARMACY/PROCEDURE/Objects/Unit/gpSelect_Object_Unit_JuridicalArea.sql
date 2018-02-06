
-- Function: gpSelect_Object_Unit_JuridicalArea()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_JuridicalArea(Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Unit_JuridicalArea(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_JuridicalArea(
    IN inisShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId                  Integer
             , UnitCode                Integer
             , UnitName                TVarChar
             , UnitAddress             TVarChar
             , ProvinceCityId_Unit     Integer
             , ProvinceCityName_Unit   TVarChar
             , ParentId_Unit           Integer
             , ParentName_Unit         TVarChar
             , UserManagerId_Unit      Integer
             , UserManagerName_Unit    TVarChar
             , JuridicalName_Unit      TVarChar
             , isErased_Unit           Boolean
             , isErased_Juridical      Boolean
             , isErased                Boolean
             , AreaId_Unit             Integer
             , AreaName_Unit           TVarChar
             , CreateDate_Unit         TDateTime
             , CloseDate_Unit          TDateTime
             , JuridicalId             Integer
             , JuridicalCode           Integer
             , JuridicalName           TVarChar
             , RetailId_Juridical      Integer
             , RetailName_Juridical    TVarChar
             , isCorporate_Juridical   Boolean
             , AreaId_Juridical        Integer
             , AreaName_Juridical      TVarChar
             , isDefault_JuridicalArea Boolean
             , isOnly_JuridicalArea    Boolean
) AS     
$BODY$   
BEGIN    

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
    SELECT tmp.UnitId
         , tmp.UnitCode
         , tmp.UnitName
         , tmp.UnitAddress
         , tmp.ProvinceCityId_Unit
         , tmp.ProvinceCityName_Unit
         , tmp.ParentId_Unit
         , tmp.ParentName_Unit
         , tmp.UserManagerId_Unit
         , tmp.UserManagerName_Unit
         , tmp.JuridicalName_Unit
         , tmp.isErased_Unit
         , tmp.isErased_Juridical
         , tmp.isErased
         
         , tmp.AreaId_Unit
         , tmp.AreaName_Unit
         , tmp.CreateDate_Unit
         , tmp.CloseDate_Unit
         
         , tmp.JuridicalId
         , tmp.JuridicalCode
         , tmp.JuridicalName
         , tmp.RetailId_Juridical
         , tmp.RetailName_Juridical
         , tmp.isCorporate_Juridical
         
         , tmp.AreaId_Juridical
         , tmp.AreaName_Juridical
         , tmp.isDefault_JuridicalArea
         , tmp.isOnly_JuridicalArea
         
    FROM lpSelect_Object_JuridicalArea_byUnit (inUnitId := 0, inJuridicalId := 0, inisShowAll:= inisShowAll) AS tmp
   ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.18         *
 26.09.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_JuridicalArea ( '2')