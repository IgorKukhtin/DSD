-- Function: gpUpdate_MI_Send_Movement()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_Movement (Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_Movement(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inMovementId_new        Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbProtocolXML TBlob;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     --проверка что оба документа не проведены  
    IF (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId) <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> должен быть не проведен.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
    END IF;
    
    IF (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId_new) <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> должен быть не проведен.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId_new), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId_new);
    END IF;



     --перезаписываем привязку к документу
     UPDATE MovementItem SET MovementId = inMovementId_new
     WHERE MovementItem.Id = inId
     ;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId_new);


    -- сохранили протокол
   -- Подготавливаем XML для записи в протокол
   SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>' INTO vbProtocolXML
   FROM
    (SELECT D.FieldXML
     FROM
    (SELECT '<Field FieldName = "Ключ объекта" FieldValue = "' || Movement.Id || '"/>'
         || '<Field FieldName = "Объект" FieldValue = " Номер и дата Предыдущего документа"/>'                               --|| zfStrToXmlStr (COALESCE (Movement.Invnumber, 'NULL')) ||
         || '<Field FieldName = "Значение" FieldValue = " № док ' || Movement.Invnumber || ' от ' || zfConvert_DateToString (Movement.OperDate) ||' "/>'
         || CASE WHEN MovementItem.ParentId <> 0 THEN '<Field FieldName = "ParentId" FieldValue = "' || MovementItem.ParentId || '"/>' ELSE '' END
         || '<Field FieldName = "Удален" FieldValue = "' || MovementItem.isErased || '"/>'
            AS FieldXML
          , 1 AS GroupId
          , MovementItem.DescId
     FROM MovementItem
          LEFT JOIN Movement ON Movement.Id = inMovementId
     WHERE MovementItem.Id = inId
    ) AS D
     ORDER BY D.GroupId, D.DescId
    ) AS D
   ;
   -- Сохранили
   INSERT INTO MovementItemProtocol (MovementItemId, OperDate, UserId, ProtocolData, isInsert)
                             VALUES (inId, current_timestamp, vbUserId, vbProtocolXML, FALSE);
    


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.10.25         *
*/

-- тест
--