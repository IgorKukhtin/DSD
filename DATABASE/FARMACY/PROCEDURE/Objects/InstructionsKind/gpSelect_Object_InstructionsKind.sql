-- Function: gpSelect_Object_InstructionsKind()

DROP FUNCTION IF EXISTS gpSelect_Object_InstructionsKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InstructionsKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, EnumName TVarChar, isErased boolean)
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
     Object.Id              AS Id 
   , Object.ObjectCode      AS Code
   , Object.ValueData       AS Name
   , ObjectString.ValueData AS EnumName
   , Object.isErased        AS isErased
   FROM Object
        LEFT JOIN ObjectString ON ObjectString.ObjectId = Object.Id
                              AND ObjectString.DescId = zc_ObjectString_Enum()
   WHERE Object.DescId = zc_Object_InstructionsKind()
     AND (vbAll = TRUE OR
          vbManagers = TRUE AND Object.Id = zc_Enum_InstructionsKind_Managers() OR
          vbMarketing = TRUE AND Object.Id = zc_Enum_InstructionsKind_Marketing());
 
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
-- SELECT * FROM gpSelect_Object_InstructionsKind('3')