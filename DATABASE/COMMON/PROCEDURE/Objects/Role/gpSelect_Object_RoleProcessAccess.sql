-- Function: gpSelect_Object_RoleProcess()

DROP FUNCTION IF EXISTS gpSelect_Object_RoleProcessAccess (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RoleProcessAccess(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, RoleId Integer, RoleProcessId Integer, Process_EnumName TVarChar) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Process());

   RETURN QUERY 
   SELECT 
     ObjectProcess.Id         AS Id 
   , ObjectProcess.ObjectCode AS Code
   , ObjectProcess.ValueData  AS Name
   , ObjectLink_RoleProcessAccess_Role.ChildObjectId AS RoleId
   , ObjectLink_RoleProcessAccess_Role.ObjectId AS RoleProcessId

   , ObjectString.ValueData AS Process_EnumName

   FROM ObjectLink AS ObjectLink_RoleProcessAccess_Role
   JOIN ObjectLink AS ObjectLink_RoleProcessAccess_Process ON ObjectLink_RoleProcessAccess_Process.ObjectId = ObjectLink_RoleProcessAccess_Role.ObjectId
    AND ObjectLink_RoleProcessAccess_Process.DescId = zc_ObjectLink_RoleProcessAccess_Process()

   JOIN Object AS ObjectProcess ON ObjectProcess.Id = ObjectLink_RoleProcessAccess_Process.ChildObjectId

        LEFT JOIN ObjectString ON ObjectString.ObjectId = ObjectLink_RoleProcessAccess_Process.ChildObjectId
                              AND ObjectString.DescId = zc_ObjectString_Enum()

   WHERE ObjectLink_RoleProcessAccess_Role.DescId = zc_ObjectLink_RoleProcessAccess_Role();        
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RoleProcess(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.12.13                         *
*/
-- ����
