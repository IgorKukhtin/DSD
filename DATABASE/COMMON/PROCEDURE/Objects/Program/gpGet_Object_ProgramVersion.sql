-- Function: gpGet_Object_ProgramVersion()

DROP FUNCTION IF EXISTS gpGet_Object_ProgramVersion(TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProgramVersion(
    IN inProgramName     TVarChar,      -- Форма 
    IN inSession         TVarChar,      -- текущий пользователь
   OUT outMajorVersion   Integer,                                 -- 
   OUT outMinorVersion   Integer                                 -- 
                                   -- 
)
RETURNS RECORD
 AS
$BODY$
BEGIN

   SELECT MajorVersion.ValueData::INTEGER, MinorVersion.ValueData::INTEGER INTO outMajorVersion, outMinorVersion
     FROM OBJECT 
     JOIN ObjectFloat AS MajorVersion 
       ON MajorVersion.objectid = OBJECT.id AND MajorVersion.DescId = zc_ObjectFloat_Program_MajorVersion()
     JOIN ObjectFloat AS MinorVersion 
       ON MinorVersion.objectid = OBJECT.id AND MinorVersion.DescId = zc_ObjectFloat_Program_MinorVersion()
    WHERE Object.ValueData = inProgramName AND Object.DescId = zc_Object_Program();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGet_Object_ProgramVersion(TVarChar, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpGet_Object_ProgramVersion('Project.exe', '')

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.13                          *

*/
