-- Function: gpInsertUpdate_MI_OrderReturnTare_byTransport()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderReturnTare_byTransport (Integer, Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderReturnTare_byTransport(
 INOUT ioMovementId             Integer   , --
    IN inMovementId_Transport   Integer   , --
    IN inInvNumber              TVarChar  , -- Номер документа
    IN inOperDate               TDateTime ,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Transport Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderReturnTare());
     vbUserId:= lpGetUserBySession (inSession);

     --сохраненный путевой
     vbMovementId_Transport := (SELECT MovementLinkMovement_Transport.MovementChildId
                                FROM MovementLinkMovement AS MovementLinkMovement_Transport
                                WHERE MovementLinkMovement_Transport.MovementId = ioMovementId
                                  AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                                );
     -- проверка если путевой не поменялся ничего не делаем
     IF vbMovementId_Transport = inMovementId_Transport
     THEN 
         RETURN;
     END IF;

     --Если док. не сохранен док. - сохраняем или пересохраняем с новім путевім
     ioMovementId := lpInsertUpdate_Movement_OrderReturnTare (ioId        := COALESCE (ioMovementId,0)
                                                            , inInvNumber := CASE WHEN COALESCE (inInvNumber, '') = '' 
                                                                                  THEN CAST (NEXTVAL ('movement_OrderReturnTare_seq') AS TVarChar)
                                                                                  ELSE inInvNumber
                                                                             END ::TVarChar
                                                            , inOperDate  := inOperDate
                                                            , inMovementId_Transport := inMovementId_Transport
                                                            , inComment   := ''::TVarChar
                                                            , inUserId    := vbUserId
                                                           ) AS tmp;

     --если поменялся удаляем сохраненные строки и записываем новые
     UPDATE MovementItem SET isErased = TRUE
     WHERE MovementItem.isErased = FALSE
       AND MovementItem.MovementId = ioMovementId;
     
     --записали новые строки
     PERFORM lpInsertUpdate_MovementItem_OrderReturnTare (ioId           := 0
                                                        , inMovementId   := ioMovementId
                                                        , inGoodsId      := tmp.GoodsId
                                                        , inPartnerId    := tmp.PartnerId
                                                        , inAmount       := tmp.Amount
                                                        , inUserId       := vbUserId
                                                         )
     FROM (WITH
           --документы продаж из реестра по путевому
           tmpReport AS (SELECT tmp.*
                         FROM lpReport_OrderReturnTare_SaleByTransport (inMovementId_Transport := inMovementId_Transport, inUserId := vbUserId) AS tmp
                         )
           SELECT tmpReport.GoodsId
                , tmpReport.PartnerId
                , SUM (tmpReport.Amount) ::TFloat AS Amount
           FROM tmpReport
           GROUP BY tmpReport.GoodsId
                  , tmpReport.PartnerId
           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.01.22         *
*/

-- тест
--