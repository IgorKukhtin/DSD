
-- Function: gpSelect_Object_MedicalProgramSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MedicalProgramSP(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedicalProgramSP(
    IN inSPKindId           Integer  ,     -- Виды соц. проектов
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , SPKindId Integer, SPKindName TVarChar
             , GroupMedicalProgramSPId Integer, GroupMedicalProgramSPName TVarChar
             , ProgramId TVarChar
             , isFree Boolean
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MedicalProgramSP());

   RETURN QUERY 
     SELECT Object_MedicalProgramSP.Id                 AS Id
          , Object_MedicalProgramSP.ObjectCode         AS Code
          , Object_MedicalProgramSP.ValueData          AS Name

          , Object_SPKind.Id                           AS SPKindId
          , Object_SPKind.ValueData                    AS SPKindName

          , Object_GroupMedicalProgramSP.Id            AS GroupMedicalProgramSPId
          , Object_GroupMedicalProgramSP.ValueData     AS GroupMedicalProgramSPName

          , ObjectString_ProgramId.ValueData           AS ProgramId
          , COALESCE(ObjectBoolean_Free.ValueData, FALSE) AS isFree

          , Object_MedicalProgramSP.isErased           AS isErased
     FROM Object AS Object_MedicalProgramSP

         LEFT JOIN ObjectLink AS ObjectLink_MedicalProgramSP_SPKind
                              ON ObjectLink_MedicalProgramSP_SPKind.ObjectId = Object_MedicalProgramSP.Id
                             AND ObjectLink_MedicalProgramSP_SPKind.DescId = zc_ObjectLink_MedicalProgramSP_SPKind()
         LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = ObjectLink_MedicalProgramSP_SPKind.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_MedicalProgramSP_GroupMedicalProgramSP
                              ON ObjectLink_MedicalProgramSP_GroupMedicalProgramSP.ObjectId = Object_MedicalProgramSP.Id
                             AND ObjectLink_MedicalProgramSP_GroupMedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP()
         LEFT JOIN Object AS Object_GroupMedicalProgramSP ON Object_GroupMedicalProgramSP.Id = ObjectLink_MedicalProgramSP_GroupMedicalProgramSP.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_ProgramId 	
                                ON ObjectString_ProgramId.ObjectId = Object_MedicalProgramSP.Id
                               AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Free 	
                                 ON ObjectBoolean_Free.ObjectId = Object_MedicalProgramSP.Id
                                AND ObjectBoolean_Free.DescId = zc_ObjectBoolean_MedicalProgramSP_Free()

     WHERE Object_MedicalProgramSP.DescId = zc_Object_MedicalProgramSP()
       AND (ObjectLink_MedicalProgramSP_SPKind.ChildObjectId = inSPKindId OR inSPKindId = 0);
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.10.21                                                       *

*/

-- тест
-- 
SELECT * FROM gpSelect_Object_MedicalProgramSP(0,'2')