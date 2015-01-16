-- Function: gpGet_FileName()

DROP FUNCTION IF EXISTS gpGetDirectoryName(TVarChar);

CREATE OR REPLACE FUNCTION gpGetDirectoryName(
       OUT Directory             TVarChar, 
        IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TVarChar AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
BEGIN
   vbUserId:= lpGetUserBySession (inSession);

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   Directory := '\\Axf\общая\'|| lfGet_Object_ValueData (vbUserId) ||'\medoc\data\';
      
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGetDirectoryName(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpGetDirectoryName('5')