-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Summ (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_Summ(
    IN inId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioSummTax             TFloat    , -- 
 INOUT ioSummReal            TFloat    , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbNPP_old TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);

     -- расчет после !!!пересчета!!!
     IF ioSummReal > 0
     THEN
         ioSummTax:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSumm()), 0)
                   - ioSummReal
                    ;
     ELSE
         ioSummReal:= 0;
     END IF;

     -- сохранили значение <Cумма откорректированной скидки, без НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTax(), inId, ioSummTax); 
     -- сохранили значение <ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal(), inId, ioSummReal);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.05.23         *
*/

-- тест
--