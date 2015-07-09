-- Function: gpUpdate_Movement_VIP()

DROP FUNCTION IF EXISTS gpUpdate_Movement_VIP(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_VIP(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inManagerId           Integer   , -- № менеджера
    IN inBayerName           TVarChar  , -- ФИО покупателя
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  
  IF COALESCE(inManagerId,0) <> 0 THEN
  -- Приписываем менеджера
    Perform lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), inMovementId, inManagerId);
  --прописываем ФИО покупателя
    Perform lpInsertUpdate_MovementString(zc_MovementString_Bayer(), inMovementId, inBayerName);
  END IF;
  --Отмечаем документ как отложенный
  Perform lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), inMovementId, True);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 03.07.15                                                                       *
*/

-- тест
--Select Max(Id) from Object Where DescId = zc_Object_Member()
-- SELECT * FROM gpUpdate_Movement_VIP (inMovementId:= 12810, inManagerId:=396592, inBayerName:= 'Test', inSession:= '3')

