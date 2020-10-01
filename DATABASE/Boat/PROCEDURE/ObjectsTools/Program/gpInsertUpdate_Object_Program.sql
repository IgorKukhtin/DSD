-- Function: gpInsertUpdate_Object_Program()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Program(TVarChar, TFloat, TFloat, TBLOB, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Program(
    IN inProgramName    TVarChar  ,    -- главное Название объекта <Программа> 
    IN inMajorVersion   TFloat    , 
    IN inMinorVersion   TFloat    , 
    IN inProgramData    TBLOB     ,    -- Данные формы 
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
DECLARE 
  vbId integer;
BEGIN
   
   SELECT Object.Id INTO vbId 
   FROM Object 
   WHERE DescId = zc_Object_Program() AND ValueData = inProgramName;

   IF COALESCE(vbId, 0) = 0 THEN
      vbId := lpInsertUpdate_Object(vbId, zc_Object_Program(), 0, inProgramName);
   END IF;

   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Program_MajorVersion(), vbId, inMajorVersion);

   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Program_MinorVersion(), vbId, inMinorVersion);

   PERFORM lpInsertUpdate_ObjectBLOB(zc_ObjectBlob_Program_Data(), vbId, inProgramData);
   
   RETURN 0;
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                        
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.13                          *

*/
    