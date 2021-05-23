-- Function: gpInsertUpdate_Object_GoodsKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportExportLink(Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportExportLink(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportExportLink(Integer, Integer, TVarChar, Integer, Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportExportLink(
 INOUT ioId	                 Integer   ,    -- внутренний ключ объекта  
    IN inIntegerKey              Integer   ,    -- цифровой ключ объекта  
    IN inStringKey               TVarChar  ,    -- строковый ключ объекта
    IN inObjectMainId            Integer   ,    -- первый объект связи 
    IN inObjectChildId           Integer   ,    -- второй объект связи
    IN inImportExportLinkTypeId  Integer   ,    -- тип связи
    IN inText                    TBlob     ,    -- текстовое поле
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKind());
   vbUserId:= lpGetUserBySession (inSession);


   --проверить что бы связи типа zc_Enum_ImportExportLinkType_UploadCompliance редактировались только админом
   IF 1 = 0 AND (inImportExportLinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance())
   THEN
       IF NOT EXISTS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
       THEN
           RAISE EXCEPTION 'Ошибка. Связи типа <%> может создавать/редактировать только администратор', (Select ValueData from Object Where Id = zc_Enum_ImportExportLinkType_UploadCompliance());
       END IF;
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ImportExportLink(), inIntegerKey, inStringKey);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ImportExportLink_ObjectMain(), ioId, inObjectMainId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ImportExportLink_ObjectChild(), ioId, inObjectChildId);  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ImportExportLink_LinkType(), ioId, inImportExportLinkTypeId);  

   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ImportExportLink_Text(), ioId, inText);  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);   

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportExportLink(Integer, Integer, TVarChar, Integer, Integer, Integer, TBlob, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 02.12.15                                                         *IF (inImportExportLinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance())
 23.12.14                         *
 09.12.14                         *
 08.12.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsKind()
