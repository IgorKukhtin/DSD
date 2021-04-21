-- Function: gpMovementItem_Loss_AddDeferredCheck

DROP FUNCTION IF EXISTS gpMovementItem_Loss_AddDeferredCheck (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Loss_AddDeferredCheck(
    IN inMovementId       Integer,   -- Списание
    IN inCheckID          Integer,   -- Чек
    IN inSession          TVarChar  -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbComent TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Документ не созранен.';
    END IF;


    SELECT Format('Чек %s от %s кол-во %s сумма %s покупатель %s'
         , Movement_Check.InvNumber
         , TO_CHAR (Movement_Check.OperDate, 'dd.mm.yyyy')
         , Movement_Check.TotalCount
         , Movement_Check.TotalSumm
         , COALESCE (Object_BuyerForSite.ValueData, MovementString_Bayer.ValueData , ''))
    INTO vbComent
    FROM Movement_Check_View AS Movement_Check
	     LEFT JOIN MovementString AS MovementString_Bayer
                                      ON MovementString_Bayer.MovementId = Movement_Check.Id
                                     AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                      ON MovementLinkObject_BuyerForSite.MovementId = Movement_Check.Id
                                     AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
         LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
    WHERE Movement_Check.Id = inCheckID;

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inMovementId, vbComent);

    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price()
                                            , lpInsertUpdate_MovementItem_Loss (ioId                 := COALESCE(MovementItemLoos.Id,0)
                                                                              , inMovementId         := inMovementId
                                                                              , inGoodsId            := MovementItemCheck.ObjectId
                                                                              , inAmount             := MovementItemCheck.Amount
                                                                              , inUserId             := vbUserId)
                                            , MovementItemCheck.Price)  
    FROM (SELECT MovementItemCheck.ObjectId
               , SUM(MovementItemCheck.Amount)  AS Amount
               , MAX(MIFloat_Price.ValueData)   AS Price
          FROM MovementItem AS MovementItemCheck
               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                           ON MIFloat_Price.MovementItemId = MovementItemCheck.Id
                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()          
          WHERE MovementItemCheck.MovementId = inCheckID
          AND MovementItemCheck.IsErased = False
          AND MovementItemCheck.DescId = zc_MI_Master()
          GROUP BY MovementItemCheck.ObjectId) AS MovementItemCheck

         LEFT OUTER JOIN MovementItem AS MovementItemLoos
                                      ON MovementItemLoos.MovementId = inMovementId  
                                     AND MovementItemLoos.ObjectId = MovementItemCheck.ObjectId 
                                     AND MovementItemLoos.DescId = zc_MI_Master();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.21                                                       * add BuyerForSite
 19.07.19                                                       *
*/

-- тест
-- select * from gpMovementItem_Loss_AddDeferredCheck(inMovementId := 16461309 , inCheckID := 16357692 ,  inSession := '3');