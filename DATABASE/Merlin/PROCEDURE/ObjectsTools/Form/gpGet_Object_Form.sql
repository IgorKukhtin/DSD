-- Function: gpGet_Object_Form()

--DROP FUNCTION gpGet_Object_Form();

CREATE OR REPLACE FUNCTION gpGet_Object_Form(
    IN inFormName    TVarChar,      -- Форма 
    IN inSession     TVarChar       -- текущий пользователь
)
RETURNS TBlob AS
$BODY$
DECLARE
  Data TBlob;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   SELECT 
       ObjectBLOB_FormData.ValueData INTO Data
   FROM Object
   JOIN ObjectBLOB AS ObjectBLOB_FormData 
     ON ObjectBLOB_FormData.DescId = zc_ObjectBlob_Form_Data() 
    AND ObjectBLOB_FormData.ObjectId = Object.Id
   WHERE Object.ValueData ILIKE inFormName AND Object.DescId = zc_Object_Form();
    
   RETURN DATA; 
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGet_Object_Form(TVarChar, TVarChar)
  OWNER TO postgres;

-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_Form('Form1', '')