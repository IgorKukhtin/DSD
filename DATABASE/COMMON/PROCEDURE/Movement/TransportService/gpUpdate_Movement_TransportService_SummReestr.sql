-- Function: gpUpdate_Movement_TransportService_SummReestr ()

DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportService_SummReestr (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TransportService_SummReestr(
    IN inId                       Integer   , --
    IN inMIId                     Integer   , -- Ключ объекта <строчная часть Документа>
    IN inSummReestr               TFloat    , -- Сумма отгрузки, грн
    IN inSession                  TVarChar    -- сессия пользователя

)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbisSummReestr Boolean;
   DECLARE vbSummReestr   TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportService());


     -- 
     IF COALESCE (inSummReestr, 0) <> 0
     THEN
          -- сохранили св-во
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SummReestr(), inMIId, FALSE);
          -- сохранили св-во
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummReestr(), inMIId, inSummReestr);
     ELSE
          -- сохранили св-во
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SummReestr(), inMIId, TRUE);

          --рассчитываем и сохраняем св-во Сумма отгрузки по реестру накладных
          vbSummReestr := COALESCE ((SELECT SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0)) AS vbSummReestr
                                     FROM MovementLinkMovement
                                          INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement.MovementId
                                          JOIN MovementFloat AS MovementFloat_MovementItemId
                                                             ON MovementFloat_MovementItemId.ValueData ::Integer = MovementItem.Id
                                                            AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                          JOIN MovementFloat AS MovementFloat_TotalSumm
                                                             ON MovementFloat_TotalSumm.MovementId = MovementFloat_MovementItemId.MovementId
                                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                     WHERE MovementLinkMovement.MovementChildId = inId
                                       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport() )
                                    ,0) ::TFloat;
          
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummReestr(), inMIId, vbSummReestr );

     END IF;

     -- сохранили протокол
     --PERFORM lpInsert_MovementProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.20         *
*/

-- тест
--