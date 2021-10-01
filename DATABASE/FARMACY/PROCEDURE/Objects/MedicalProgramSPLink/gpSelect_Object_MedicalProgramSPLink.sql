-- Function: gpSelect_Object_MedicalProgramSPLink()

DROP FUNCTION IF EXISTS gpSelect_Object_MedicalProgramSPLink (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedicalProgramSPLink(
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , MedicalProgramSPId Integer, MedicalProgramSPCode Integer, MedicalProgramSPName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, JuridicalName TVarChar
             , isErased Boolean
              ) AS
$BODY$
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MedicalProgramSPLink());

      RETURN QUERY 
        SELECT Object_MedicalProgramSPLink.Id         AS Id
             , Object_MedicalProgramSPLink.ObjectCode AS Code

             , Object_MedicalProgramSP.Id         AS MedicalProgramSPId
             , Object_MedicalProgramSP.ObjectCode AS MedicalProgramSPCode
             , Object_MedicalProgramSP.ValueData  AS MedicalProgramSPName

             , Object_Unit.Id             AS UnitId
             , Object_Unit.ObjectCode     AS UnitCode
             , Object_Unit.ValueData      AS UnitName
             , Object_Juridical.ValueData AS JuridicalName

             , Object_MedicalProgramSPLink.isErased

        FROM Object AS Object_MedicalProgramSPLink
             LEFT JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                  ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                 AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
             LEFT JOIN Object AS Object_MedicalProgramSP ON Object_MedicalProgramSP.Id = ObjectLink_MedicalProgramSP.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Unit
                                  ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

        WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.10.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_MedicalProgramSPLink ('3')
