-- Function: gpInsertUpdate_Movement_OrderSale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderSale (Integer, TVarChar, TDateTime, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderSale (Integer, TVarChar, TDateTime, TDateTime, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderSale(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber           TVarChar  , -- Номер документа
 INOUT ioOperDate            TDateTime , -- Дата документа
    IN inOperDate_top        TDateTime ,
    IN inPartnerId           Integer   , --
    IN inTotalCountKg        TFloat    , 
    IN inTotalSumm           TFloat    , 
    IN inComment             TVarChar   , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderSale());


     -- если не внесли дату документа берем дату из журнала
     IF COALESCE (ioOperDate, zc_DateStart()) = zc_DateStart()
     THEN
         ioOperDate := inOperDate_top;
     END IF;
     
     -- сохранили <Документ>
      SELECT tmp.ioId, tmp.ioInvNumber
    INTO ioId, ioInvNumber
      FROM lpInsertUpdate_Movement_OrderSale (ioId           := ioId
                                            , ioInvNumber    := ioInvNumber
                                            , inOperDate     := ioOperDate
                                            , inPartnerId    := inPartnerId
                                            , inTotalCountKg := inTotalCountKg
                                            , inTotalSumm    := inTotalSumm
                                            , inComment      := inComment
                                            , inUserId       := vbUserId
                                             ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.21         *
*/

-- тест
-- select * from gpInsertUpdate_Movement_OrderSale(ioId := 18775751 , ioInvNumber := '2' , ioOperDate := ('13.01.2021')::TDateTime , inOperDate_top := ('31.01.2021')::TDateTime , inPartnerId := 4126219 , inTotalCountKg := 222 , inTotalSumm := 22222 , inComment := '' ,  inSession := '5');
