-- Function: gpInsertUpdate_Object_Form()

-- DROP FUNCTION gpInsertUpdate_Object_Form();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Form(
    IN inFormName    TVarChar  ,    -- главное Название объекта <Форма> 
    IN inFormData    TBLOB     ,    -- Данные формы 
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);
   
   SELECT Object.Id
          INTO vbId
   FROM Object 
   WHERE DescId = zc_Object_Form() AND ValueData = inFormName;

   PERFORM lpCheckUnique_Object_ValueData (vbId, zc_Object_Form(), inFormName);

   IF COALESCE (vbId, 0) = 0
   THEN
       vbId := lpInsertUpdate_Object (vbId, zc_Object_Form(), 0, inFormName);
   END IF;

   PERFORM lpInsertUpdate_ObjectBLOB(zc_ObjectBlob_Form_Data(), vbId, inFormData);
   
   RETURN 0;
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.05.21                                        *
*/

-- тест
-- SELECT gpInsertUpdate_Object_Form ('Плановая Прибыль (Факт)', '81245')
