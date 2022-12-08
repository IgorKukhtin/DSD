-- Function: gpUpdate_MovementItem_Sale_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_ChangePercent (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_ChangePercent(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inChangePercent       TFloat    , -- % скидки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId := inSession;

    IF 3 <> inSession::Integer AND 4183126 <> inSession::Integer AND 235009  <> inSession::Integer AND 183242  <> inSession::Integer 
    THEN
      RAISE EXCEPTION 'Изменение <Процента скидки> вам запрещено.';
    END IF;
            
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

     -- сохранили
    PERFORM lpInsertUpdate_MovementItem_Sale (ioId                 := T.Id
                                            , inMovementId         := inId
                                            , inGoodsId            := T.GoodsId
                                            , inAmount             := T.Amount
                                            , inPrice              := ROUND( COALESCE(T.PriceSale,0) - (COALESCE(T.PriceSale,0)/100 * inChangePercent) ,2)
                                            , inPriceSale          := T.PriceSale
                                            , inChangePercent      := inChangePercent
                                            , inSumm               := ROUND(COALESCE(T.Amount,0) * COALESCE(ROUND( COALESCE(T.PriceSale,0) - (COALESCE(T.PriceSale,0)/100 * inChangePercent) ,2),0), 2)
                                            , inisSp               := COALESCE(T.IsSp,False) ::Boolean
                                            , inNDSKindId          := T.NDSKindId 
                                            , inUserId             := vbUserId
                                             )
    FROM gpSelect_MovementItem_Sale(inMovementId := inId  , inShowAll := False, inIsErased := False,  inSession := inSession) AS T;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_MovementItem_Sale_ChangePercent (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.12.22                                                       *               
*/

-- 
select * from gpUpdate_MovementItem_Sale_ChangePercent(inId := 540915992 , inChangePercent := 50.0 ,  inSession := '3');