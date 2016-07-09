-- Function: gpInsertUpdate_MI_Over_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Over_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inUnitId              Integer   , -- 
    IN inAmount              TFloat    , -- Количество
    IN inRemains	     TFloat    , -- 
    IN inPrice	             TFloat    , -- 
    IN inMCS                 TFloat    , -- 
   OUT outAmountMaster       TFloat    ,
   OUT outSummaMaster        TFloat    ,
   OUT outSummaChild         TFloat    ,
    IN inMinExpirationDate   TDateTime , -- 
    IN inComment             TVarChar  , --  
    IN inSession             TVarChar    -- сессия пользователя

)                              
RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- сохранили 
   ioId := lpInsertUpdate_MI_Over_Child(ioId               := ioId
                                      , inMovementId       := inMovementId
                                      , inParentId         := inParentId                                
                                      , inUnitId           := inUnitId
                                      , inAmount           := inAmount
                                      , inRemains          := inRemains
                                      , inPrice            := inPrice
                                      , inMCS              := inMCS
                                      , inMinExpirationDate:= inMinExpirationDate
                                      , inComment          := inComment
                                      , inUserId           := vbUserId
                                      );
   
   outSummaChild := inPrice * inAmount;
   -- автомат изменение инфы в мастере (кол-во и сумма)
   SELECT Sum(MI.Amount)::TFloat
        , Sum( COALESCE(MIFloat_Price.ValueData,0) * MI.Amount)  ::TFloat
   INTO outAmountMaster, outSummaMaster
   FROM MovementItem AS MI 
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MI.ParentId
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
   WHERE MI.MovementId = inMovementId AND MI.ParentId = inParentId AND MI.DescId = zc_MI_Child() AND MI.isErased = False;

   PERFORM lpInsertUpdate_MovementItem (inParentId, zc_MI_Master(), MI_Master.ObjectId, inMovementId, outAmountMaster, NULL)
   FROM MovementItem AS MI_Master 
   WHERE MI_Master.MovementId = inMovementId AND MI_Master.Id = inParentId AND MI_Master.DescId = zc_MI_Master() AND MI_Master.isErased = False
   ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.16         *
 */

-- тест
-- 