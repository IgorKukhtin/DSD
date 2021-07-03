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

-- RAISE EXCEPTION 'Ошибка.<%>', inProgramName;

IF inProgramName ilike 'Project.exe' AND 1=0
THEN
   SELECT 
       ObjectBLOB_ProgramData.ValueData INTO Data
   FROM Object
   JOIN ObjectBLOB AS ObjectBLOB_ProgramData 
     ON ObjectBLOB_ProgramData.DescId = zc_ObjectBlob_Program_Data() 
    AND ObjectBLOB_ProgramData.ObjectId = Object.Id
   WHERE Object.ValueData = 'Project.exe.win64' AND Object.DescId = zc_Object_Program();

ELSE

   SELECT 
       ObjectBLOB_ProgramData.ValueData INTO Data
   FROM Object
   JOIN ObjectBLOB AS ObjectBLOB_ProgramData 
     ON ObjectBLOB_ProgramData.DescId = zc_ObjectBlob_Program_Data() 
    AND ObjectBLOB_ProgramData.ObjectId = Object.Id
   WHERE Object.ValueData = inProgramName AND Object.DescId = zc_Object_Program();

END IF;
    
   RETURN DATA; 
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGet_Object_Program(TVarChar, TVarChar)
  OWNER TO postgres;

-- SELECT length(gpGet_Object_Program) FROM gpGet_Object_Program('ProjectMobile.apk', '')

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.13                          *

*/
