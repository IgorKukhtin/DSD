-- Function: gpUpdate_Movement_Check_MemberSp()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_MemberSp (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_MemberSp(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inMemberSpId        Integer   , -- Пациент
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);

    SELECT Movement.StatusId
    INTO vbStatusId
    FROM Movement 
    WHERE Movement.Id = inId;
         
    -- проверка   
    IF COALESCE(inId, 0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;
    -- проверка 
    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение Пациента в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberSp(), inId, inMemberSpId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 11.01.19         *
*/
-- тест
-- select * from gpUpdate_Movement_Check_MemberSp(inId := 7784533 , inMemberSpId := 183294 ,  inSession := '3');