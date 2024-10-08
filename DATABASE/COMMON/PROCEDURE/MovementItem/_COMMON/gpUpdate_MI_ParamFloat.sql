-- Function: gpUpdate_MI_ParamFloat()

--для MIFloatEditForm , передаем деск   MovementItemFloat , права, и значение 

DROP FUNCTION IF EXISTS gpUpdate_MI_ParamFloat (Integer, TVarChar, TVarChar, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_ParamFloat(
    IN inId              Integer  , -- ключ строка    
    IN inDescCode        TVarChar ,
    IN inDescProcess     TVarChar ,
    IN inValue           TFloat   ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession
                             , (SELECT ObjectId AS Id 
                                FROM ObjectString 
                                WHERE ValueData = inDescProcess
                                 AND DescId = zc_ObjectString_Enum()));

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat ((SELECT MovementItemFloatDesc.Id
                                                FROM MovementItemFloatDesc
                                                WHERE MovementItemFloatDesc.Code = inDescCode)
                                             , inId
                                             , inValue);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.24         *
*/

-- тест
--