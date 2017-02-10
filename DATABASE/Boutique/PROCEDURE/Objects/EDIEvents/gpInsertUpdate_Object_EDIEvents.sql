-- Function: gpInsertUpdate_Object_EDIEvents(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_EDIEvents (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_EDIEvents(
 INOUT ioId	             Integer,     -- ключ объекта <Призник договора>
    IN inCode                Integer,     -- Id Документа
    IN inName                TVarChar,    -- Название
    IN inSession             TVarChar     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_EDIEvents());
   vbUserId:= lpGetUserBySession (inSession);


   -- Проверка Desc
   IF NOT EXISTS (SELECT MovementBooleanDesc.Code FROM MovementBooleanDesc WHERE LOWER (MovementBooleanDesc.Code) = LOWER (inName))
   THEN 
       RAISE EXCEPTION 'Ошибка.Название для EDIEvents не получено.';
   END IF;


   -- сохранили <Объект> - !!!ВСЕГДА Insert!!!
   ioId:= lpInsertUpdate_Object (0, zc_Object_EDIEvents(), inCode, inName);
   
   -- сохранили свойство <Дата создания>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
   -- сохранили свойство <Пользователь (создание)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_EDIEvents (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.07.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_EDIEvents ()
/*
select *
from Object
     left join ObjectDate on ObjectDate.ObjectId = Object.Id and ObjectDate.DescId = zc_ObjectDate_Protocol_Insert()
     left join ObjectLink on ObjectLink.ObjectId = Object.Id and ObjectLink.DescId = zc_ObjectLink_Protocol_Insert()
     left join Object as Object_User on Object_User.Id = ObjectLink.ChildObjectId
     left join Movement on Movement.Id = Object.ObjectCode
where Object.DescId = zc_Object_EDIEvents()
*/
