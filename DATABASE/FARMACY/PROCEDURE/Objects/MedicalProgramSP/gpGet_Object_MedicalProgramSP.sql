-- Function: gpGet_Object_MedicalProgramSP (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MedicalProgramSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MedicalProgramSP(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , SPKindId Integer, SPKindName TVarChar
             , ProgramId TVarChar
             , isFree boolean
             , isErased boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MedicalProgramSP());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_MedicalProgramSP()) AS Code
           , CAST ('' as TVarChar)   AS NAME
           , CAST (0 as Integer)     AS SPKindId
           , CAST ('' as TVarChar)   AS SPKindName
           , CAST ('' as TVarChar)   AS ProgramId
           , CAST (FALSE AS Boolean) AS isFree
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_MedicalProgramSP.Id                 AS Id
            , Object_MedicalProgramSP.ObjectCode         AS Code
            , Object_MedicalProgramSP.ValueData          AS Name

            , Object_SPKind.Id                           AS SPKindId
            , Object_SPKind.ValueData                    AS SPKindName

            , ObjectString_ProgramId.ValueData           AS ProgramId
            , COALESCE(ObjectBoolean_Free.ValueData, FALSE) AS isFree

            , Object_MedicalProgramSP.isErased           AS isErased
       FROM Object AS Object_MedicalProgramSP

           LEFT JOIN ObjectLink AS ObjectLink_MedicalProgramSP_SPKind
                                ON ObjectLink_MedicalProgramSP_SPKind.ObjectId = Object_MedicalProgramSP.Id
                               AND ObjectLink_MedicalProgramSP_SPKind.DescId = zc_ObjectLink_MedicalProgramSP_SPKind()
           LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = ObjectLink_MedicalProgramSP_SPKind.ChildObjectId

           LEFT JOIN ObjectString AS ObjectString_ProgramId 	
                                  ON ObjectString_ProgramId.ObjectId = Object_MedicalProgramSP.Id
                                 AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Free 	
                                   ON ObjectBoolean_Free.ObjectId = Object_MedicalProgramSP.Id
                                  AND ObjectBoolean_Free.DescId = zc_ObjectBoolean_MedicalProgramSP_Free()
                                  
         WHERE Object_MedicalProgramSP.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.10.21                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_MedicalProgramSP(0,'2')