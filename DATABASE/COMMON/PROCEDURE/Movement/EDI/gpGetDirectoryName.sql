-- Function: gpGet_FileName()

DROP FUNCTION IF EXISTS gpGetDirectoryName(TVarChar);

CREATE OR REPLACE FUNCTION gpGetDirectoryName(
       OUT Directory             TVarChar, 
        IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TVarChar AS
$BODY$
DECLARE
  UserId Integer;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   Directory := 'd:\medoc\data\';
      
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGetDirectoryName(TVarChar)
  OWNER TO postgres;

-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_UserFormSettings('Form1', '2')