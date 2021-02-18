-- Function: gpGet_Object_Instructions()

DROP FUNCTION IF EXISTS gpGet_Object_Instructions(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Instructions(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InstructionsKindId Integer, InstructionsKindCode Integer, InstructionsKindName TVarChar
             , FileName TVarChar
             , isErased boolean) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbInstructionsKindId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Instructions_User());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inId, 0) = 0
   THEN

       IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       THEN
         vbInstructionsKindId := zc_Enum_InstructionsKind_IT();
       ELSEIF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = 12084491)
       THEN
         vbInstructionsKindId := zc_Enum_InstructionsKind_Marketing();   
       ELSEIF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
       THEN
         vbInstructionsKindId := zc_Enum_InstructionsKind_Managers();
       ELSE
         RAISE EXCEPTION 'У вас нет прав добавлять инструкции.';
       END IF;

       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_Instructions()) AS Code
           , CAST ('' as TVarChar) AS Name

           , Object_InstructionsKind.Id          AS InstructionsKindId
           , Object_InstructionsKind.ObjectCode  AS InstructionsKindCode
           , Object_InstructionsKind.ValueData   AS InstructionsKindName

           , CAST ('' as TVarChar) AS FileName     
       
           , CAST (NULL AS Boolean) AS isErased
       FROM Object AS Object_InstructionsKind
       WHERE Object_InstructionsKind.ID = vbInstructionsKindId;
   ELSE
       RETURN QUERY 
       SELECT 
               Object_ImportType.Id                AS Id 
             , Object_ImportType.ObjectCode        AS Code
             , Object_ImportType.ValueData         AS Name

             , Object_InstructionsKind.Id          AS InstructionsKindId
             , Object_InstructionsKind.ObjectCode  AS InstructionsKindCode
             , Object_InstructionsKind.ValueData   AS InstructionsKindName

             , ObjectString_FileName.ValueData     AS FileName
             , Object_ImportType.isErased          AS isErased
       FROM Object AS Object_ImportType

            LEFT JOIN ObjectString AS ObjectString_FileName
                                   ON ObjectString_FileName.ObjectId = Object_ImportType.Id
                                  AND ObjectString_FileName.DescId = zc_ObjectString_Instructions_FileName()

            LEFT JOIN ObjectLink AS ObjectLink_InstructionsKind
                                 ON ObjectLink_InstructionsKind.ObjectId = Object_ImportType.Id
                                AND ObjectLink_InstructionsKind.DescId = zc_ObjectLink_Instructions_InstructionsKind()
            LEFT JOIN Object AS Object_InstructionsKind ON Object_InstructionsKind.Id = ObjectLink_InstructionsKind.ChildObjectId
                                  
      WHERE Object_ImportType.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Instructions (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.02.21                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_Instructions(0,'3')