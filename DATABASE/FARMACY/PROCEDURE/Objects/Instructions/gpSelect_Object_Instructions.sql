-- Function: gpSelect_Object_Instructions()

DROP FUNCTION IF EXISTS gpSelect_Object_Instructions (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Instructions(
    IN inisShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InstructionsKindId Integer, InstructionsKindCode Integer, InstructionsKindName TVarChar
             , FileName TVarChar, isErased boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbAll Boolean;
  DECLARE vbManagers Boolean;
  DECLARE vbMarketing Boolean;  
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Instructions_User());
   vbUserId:= lpGetUserBySession (inSession);

   vbAll := False;
   vbManagers := False;
   vbMarketing := False;

   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
      OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_CashierPharmacy())
      AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
   THEN
     vbAll := TRUE;
   ELSEIF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = 12084491)
   THEN
     vbMarketing := TRUE;   
   ELSEIF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
   THEN
     vbManagers := TRUE;
   END IF;

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
     AND (Object.isErased = False OR inisShowAll = True)
     AND (vbAll = TRUE OR
          vbManagers = TRUE AND Object_InstructionsKind.Id = zc_Enum_InstructionsKind_Managers() OR
          vbMarketing = TRUE AND Object_InstructionsKind.Id = zc_Enum_InstructionsKind_Marketing());
 
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
SELECT * FROM gpSelect_Object_Instructions(False, '3')