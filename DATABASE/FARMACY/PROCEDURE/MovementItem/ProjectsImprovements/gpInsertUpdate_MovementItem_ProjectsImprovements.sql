-- Function: gpInsertUpdate_MovementItem_ProjectsImprovements()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProjectsImprovements(Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ProjectsImprovements(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioOperDate            TDateTime , -- Дата
    IN inTitle               TVarChar  , -- Название
    IN inDescription         TVarChar  , -- Описание задания 
   OUT outisApprovedBy       Boolean   , -- Утверждено
   OUT outisPerformed        Boolean   , --
   OUT outUserName           TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProjectsImprovements());

     IF ioOperDate IS NULL
     THEN
       ioOperDate := CURRENT_DATE;
     END IF;

     ioId := lpInsertUpdate_MovementItem_ProjectsImprovements(ioId, inMovementId, ioOperDate, inTitle, inDescription, vbUserId);

     SELECT COALESCE (MIBoolean_ApprovedBy.ValueData, False), MovementItem.Amount = 1, Object_User.ValueData
     INTO outisApprovedBy, outisPerformed, outUserName
     FROM MovementItem 
          LEFT JOIN MovementItemBoolean AS MIBoolean_ApprovedBy
                                        ON MIBoolean_ApprovedBy.MovementItemId = MovementItem.Id
                                       AND MIBoolean_ApprovedBy.DescId = zc_MIBoolean_ApprovedBy()
   
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Insert
                                           ON MILinkObject_Insert.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Insert.DescId = zc_MILinkObject_Insert()
          LEFT JOIN Object AS Object_User ON Object_User.Id = MILinkObject_Insert.ObjectId
     WHERE MovementItem.Id = ioId;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.05.20                                                       *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_ProjectsImprovements(ioId := 343273619 , inMovementId := 18831317 , ioOperDate := ('13.05.2020')::TDateTime , inTitle := 'Проба 2' , inDescription := 'Доделка
' ,  inSession := '3');