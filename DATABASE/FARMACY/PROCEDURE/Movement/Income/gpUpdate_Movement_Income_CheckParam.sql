-- Function: gpUpdate_Movement_Income_CheckParam()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_CheckParam (Integer, Integer, TDateTime, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_CheckParam(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inMemberIncomeCheckId Integer   , -- ФИО уполномоч. лица
    IN inCheckDate           TDateTime , -- дата проверки уполномоч. лицом
    IN inisSaveNull          Boolean   , -- сохранять пустое значение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF (COALESCE (inisSaveNull, True) = True) OR (COALESCE (inisSaveNull, True) = False AND COALESCE (inMemberIncomeCheckId,0) <> 0)
       THEN   
           -- сохранили связь с <>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberIncomeCheck(), inId, inMemberIncomeCheckId);
           IF COALESCE (inMemberIncomeCheckId,0) <> 0 
              THEN
                  -- сохранили <>
                  PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inId, inCheckDate);
              ELSE
                  -- сохранили <>
                  PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inId, NULL);
           END IF;
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 08.06.17         *
*/

-- тест
-- 