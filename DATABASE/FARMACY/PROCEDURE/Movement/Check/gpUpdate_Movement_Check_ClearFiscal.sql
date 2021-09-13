-- Function: gpUpdate_Movement_Check_ClearFiscal()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_ClearFiscal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_ClearFiscal(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbZReport Integer;
   DECLARE vbFiscalCheckNumber TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpGetUserBySession (inSession);
--    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION 'Выполнение операции вам запрещено.';
    END IF;

    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    SELECT
      StatusId,
      COALESCE(MovementLinkObject_CashRegister.ObjectId, 0),
      COALESCE(MovementFloat_ZReport.ValueData, 0),
      COALESCE(MovementString_FiscalCheckNumber.ValueData, '')
    INTO
      vbStatusId,
      vbCashRegisterId,
      vbZReport,
      vbFiscalCheckNumber
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                      ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                     AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
         LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                 ON MovementFloat_ZReport.MovementId =  Movement.Id
                                AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()
         LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                  ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                 AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
    WHERE Id = inId;
    
    IF vbCashRegisterId <> 0 OR
      vbZReport <> 0 OR
      vbFiscalCheckNumber <> ''
    THEN
    
        -- Сохранили связь с кассовым аппаратом
      IF vbCashRegisterId <> 0
      THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CashRegister(), inId, 0);
      END IF;

        -- сохранили <Номер Z отчета>
      IF vbZReport <> 0
      THEN
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ZReport(), inId, Null);
      END IF;

        -- сохранили Номер чека в кассовом аппарате
      IF vbFiscalCheckNumber <> ''
      THEN
        PERFORM lpInsertUpdate_MovementString(zc_MovementString_FiscalCheckNumber(), inId, '');
      END IF;

      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.09.21                                                                                    *
*/
-- тест
-- select * from gpUpdate_Movement_Check_ClearFiscal(inId := 24824105 ,  inSession := '3');
