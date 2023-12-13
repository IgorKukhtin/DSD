-- Function: lpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice_Amount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Invoice_Amount(
    IN inId               Integer  ,  --
   OUT outAmount          TFloat   ,  --
    IN inUserId           Integer      -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
BEGIN
    
    outAmount := (SELECT SUM (zfCalc_SummWVAT (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0), MovementFloat_VATPercent.ValueData)) ::TFloat Summа_WVAT
                  FROM Movement           
                     LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                             ON MovementFloat_VATPercent.MovementId = Movement.Id
                                            AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE

                     LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                 ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                  WHERE Movement.Id = inId
                  );


    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), inId, outAmount);


    -- !!!протокол через свойства конкретного объекта!!!
    -- сохранили свойство <Дата корректировки>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inId, CURRENT_TIMESTAMP);
    -- сохранили свойство <Пользователь (корректировка)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inId, inUserId);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.12.23         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Invoice_Amount
