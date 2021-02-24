-- Function: gpSelect_Object_InstructionsCash()

DROP FUNCTION IF EXISTS gpSelect_Object_InstructionsCash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InstructionsCash(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InstructionsKindId Integer, InstructionsKindCode Integer, InstructionsKindName TVarChar
             , FileName TVarChar, isErased boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Instructions_User());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT 
     Object.Id                           AS Id 
   , Object.ObjectCode                   AS Code
   , Object.ValueData                    AS Name

   , Object_InstructionsKind.Id          AS InstructionsKindId
   , Object_InstructionsKind.ObjectCode  AS InstructionsKindCode
   , Object_InstructionsKind.ValueData   AS InstructionsKindName

   , ObjectString_FileName.ValueData     AS FileName
   , Object.isErased                     AS isErased
   FROM Object

        LEFT JOIN ObjectString AS ObjectString_FileName
                               ON ObjectString_FileName.ObjectId = Object.Id
                              AND ObjectString_FileName.DescId = zc_ObjectString_Instructions_FileName()

        LEFT JOIN ObjectLink AS ObjectLink_InstructionsKind
                             ON ObjectLink_InstructionsKind.ObjectId = Object.Id
                            AND ObjectLink_InstructionsKind.DescId = zc_ObjectLink_Instructions_InstructionsKind()
        LEFT JOIN Object AS Object_InstructionsKind ON Object_InstructionsKind.Id = ObjectLink_InstructionsKind.ChildObjectId

   WHERE Object.DescId = zc_Object_Instructions()
     AND Object.isErased = False
     AND COALESCE(ObjectString_FileName.ValueData, '') <> '';
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.02.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_InstructionsCash('3')