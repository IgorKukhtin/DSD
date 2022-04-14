-- Function: gpUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice (Integer, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice (Integer, TDateTime, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice (Integer, TDateTime, TVarChar, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice (Integer, TDateTime, TVarChar, Boolean, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Invoice(
    IN inId                    Integer,    -- 
    IN inDateRegistered        TDateTime,  -- Дата платежки
    IN inInvNumberRegistered   TVarChar ,  -- Номер платежки
    IN inisDocument            Boolean  ,  -- Есть наш экз.
    IN inTotalDiffSumm         TFloat   ,  -- Корректировочная Сумма
    IN inDateAdoptedByNSZU     TDateTime,  -- Принято НСЗУ
   OUT outSumm_Diff            TFloat   ,  -- разница Сумма с НДС и Корректировочная Сумма
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Invoice());
    vbUserId := inSession;


    vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inId);
    IF vbStatusId = zc_Enum_Status_Erased()
    THEN
        RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> удален. Изменения запрещены.', (SELECT InvNumber FROM Movement WHERE Id = inId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inId);
    END IF;
    IF vbStatusId = zc_Enum_Status_Complete()
    THEN
        RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> проведен. Изменения запрещены.', (SELECT InvNumber FROM Movement WHERE Id = inId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inId);
    END IF;

    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), inId, inDateRegistered);    

    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberRegistered(), inId, inInvNumberRegistered);
  
    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), inId, inisDocument);

    -- Сохранили свойство <> 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiffSumm(), inId, inTotalDiffSumm);
    
    -- Сохранили свойство <> 
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_AdoptedByNSZU(), inId, inDateAdoptedByNSZU);

    -- 
    outSumm_Diff := (COALESCE ( (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSumm()), 0) - COALESCE (inTotalDiffSumm,0) ) :: TFloat;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 17.04.19         * inTotalDiffSumm, outSumm_Diff
 21.04.17         * add inisDocument
 22.03.17         *
*/