-- Function: gpInsertUpdate_Object_Form()

-- DROP FUNCTION gpInsertUpdate_Object_Form();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Form(
    IN inFormName    TVarChar  ,    -- главное Название объекта <Форма> 
    IN inFormData    TBLOB     ,    -- Данные формы 
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE Id integer;
   DECLARE vbUserId Integer;
BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Forms());
   vbUserId := inSession;

   SELECT Object.Id INTO Id 
   FROM Object 
   WHERE DescId = zc_Object_Form() AND ValueData = inFormName;

   PERFORM lpCheckUnique_Object_ValueData(Id, zc_Object_Form(), inFormName, vbUserId);

   IF COALESCE(Id, 0) = 0 THEN
      Id := lpInsertUpdate_Object(Id, zc_Object_Form(), 0, inFormName);
   END IF;

   PERFORM lpInsertUpdate_ObjectBLOB(zc_ObjectBlob_Form_Data(), Id, inFormData);
   
   RETURN 0;
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            