-- Function: gpGet_Object_MedicalProgramSPLink()

DROP FUNCTION IF EXISTS gpGet_Object_MedicalProgramSPLink (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MedicalProgramSPLink(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , MedicalProgramSPId Integer, MedicalProgramSPName TVarChar
             , UnitId Integer, UnitName TVarChar
              )
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MedicalProgramSPLink());

      IF COALESCE (inId, 0) = 0
      THEN
           RETURN QUERY
             SELECT CAST (0 AS Integer)    AS Id
                  , lfGet_ObjectCode(0, zc_Object_MedicalProgramSPLink()) AS Code
                 
                  , NULL :: Integer        AS MedicalProgramSPId
                  , CAST ('' AS TVarChar)  AS MedicalProgramSPName
                  , NULL :: Integer        AS UnitId
                  , CAST ('' AS TVarChar)  AS UnitName;
      ELSE
           RETURN QUERY
             SELECT Object_MedicalProgramSPLink.Id         AS Id
                  , Object_MedicalProgramSPLink.ObjectCode AS Code
                  , Object_MedicalProgramSP.Id              AS MedicalProgramSPId
                  , Object_MedicalProgramSP.ValueData       AS MedicalProgramSPName
                  , Object_Unit.Id                          AS UnitId
                  , Object_Unit.ValueData                   AS UnitName

             FROM Object AS Object_MedicalProgramSPLink
                  LEFT JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                       ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                      AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
                  LEFT JOIN Object AS Object_MedicalProgramSP ON Object_MedicalProgramSP.Id = ObjectLink_MedicalProgramSP.ChildObjectId
                  LEFT JOIN ObjectLink AS ObjectLink_Unit
                                       ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                      AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

             WHERE Object_MedicalProgramSPLink.Id = inId;
      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_MedicalProgramSPLink (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.10.21                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_MedicalProgramSPLink (2915395, zfCalc_UserAdmin())
