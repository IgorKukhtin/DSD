-- Function: gpUpdate_MI_Over_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_SummNalogRet  (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_SummNalogRet(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inSummNalog           TFloat    , 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRet(), inId, inSummNalog);

     -- сохранили свойство <сумму к выплате>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummToPay(), inId
                    , COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummService()), 0)
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummMinus()), 0)
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummAdd()), 0)
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummHoliday()), 0)
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummSocialAdd()), 0)

                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummTransport()), 0)
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummTransportAdd()), 0)
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummTransportAddLong()), 0)
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummTransportTaxi()), 0)

                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummPhone()), 0)

                      -- "минус" <Налоги - удержания с ЗП>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummNalog()), 0)
                      -- "плюс" <Налоги - возмещение к ЗП>
                    -- + inSummNalog
                    + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummNalogRet()), 0)    --
                      -- "минус" <Алименты - удержание>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummChild()), 0)
                      -- "минус" <Удержания сторон. юр.л.>
                    - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummMinusExt()), 0)
                    );


   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.01.18         *
*/

-- тест
-- 