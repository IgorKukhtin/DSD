-- Function: gpGet_Object_Program()

DROP FUNCTION IF EXISTS gpGet_Object_Program(TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Program(
    IN inProgramName TVarChar,      -- Программа 
    IN inSession     TVarChar       -- текущий пользователь
)
RETURNS TBlob AS
$BODY$
DECLARE
  Data TBlob;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   SELECT 
       ObjectBLOB_ProgramData.ValueData INTO Data
   FROM Object
   JOIN ObjectBLOB AS ObjectBLOB_ProgramData 
     ON ObjectBLOB_ProgramData.DescId = zc_ObjectBlob_Program_Data() 
    AND ObjectBLOB_ProgramData.ObjectId = Object.Id
   WHERE Object.ValueData = inProgramName AND Object.DescId = zc_Object_Program();
    
   RETURN DATA; 
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGet_Object_Program(TVarChar, TVarChar)
  OWNER TO postgres;

-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_Form('Form1', '')

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.13                          *

*/
