-- Function: gpLink_Object_MemberSP_LikiDnipro()

DROP FUNCTION IF EXISTS gpLink_Object_MemberSP_LikiDnipro (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLink_Object_MemberSP_LikiDnipro(
    IN inMemberSPId	         Integer   ,    -- ключ объекта
    IN inLikiDniproId        Integer   ,    -- Id 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberSP());
   vbUserId := inSession;
   
   -- проверка заполнения мед.учрежд.
   IF COALESCE (inMemberSPId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Значение <Пациент> не установлено.';
   END IF;
   
   -- убрали связь с предыдущим значением если есть 
   IF EXISTS(SELECT *
             FROM ObjectFloat
              WHERE ObjectFloat.DescId = zc_ObjectFloat_MemberSP_LikiDniproId()
                AND ObjectFloat.ObjectId <> inMemberSPId
                AND ObjectFloat.ValueData = inLikiDniproId)
   THEN
     UPDATE ObjectFloat SET ValueData = 0
     WHERE ObjectFloat.DescId = zc_ObjectFloat_MemberSP_LikiDniproId()
       AND ObjectFloat.ObjectId <> inMemberSPId
       AND ObjectFloat.ValueData = inLikiDniproId;
   END IF;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MemberSP_LikiDniproId(), inMemberSPId, inLikiDniproId);
      
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inMemberSPId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.03.21                                                       *
*/

-- тест
-- SELECT * FROM gpLink_Object_MemberSP_LikiDnipro()
