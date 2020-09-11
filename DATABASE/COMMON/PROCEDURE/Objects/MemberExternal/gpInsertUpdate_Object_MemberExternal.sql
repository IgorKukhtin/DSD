-- Function: gpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberExternal(
 INOUT ioId	             Integer   ,    -- ключ объекта <Физические лица(сторонние)> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта
    IN inDriverCertificate   TVarChar  ,    -- Водительское удостоверение
    IN inINN                 TVarChar  ,    -- ИНН
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MemberExternal());
   vbUserId := lpGetUserBySession (inSession);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object_MemberExternal (ioId	 := ioId
                                               , inCode  := inCode
                                               , inName  := inName
                                               , inDriverCertificate := inDriverCertificate
                                               , inINN   := inINN
                                               , inUserId:= vbUserId
                                                );

  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.09.20         *
 27.01.20         *
 28.03.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MemberExternal()
