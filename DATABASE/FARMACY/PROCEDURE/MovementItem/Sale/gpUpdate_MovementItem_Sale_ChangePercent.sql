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

    IF inSession::Integer NOT IN (3, 183242, 235009, 4183126, 6828543 )
    THEN
      RAISE EXCEPTION 'Изменение <Процента скидки> вам запрещено.';
    END IF;
            
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;
    
    IF COALESCE((SELECT MovementLinkObject_SPKind.ObjectId
                 FROM MovementLinkObject AS MovementLinkObject_SPKind
                 WHERE MovementLinkObject_SPKind.MovementId = inId
                   AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()), 0) =
       zc_Enum_SPKind_InsuranceCompanies()
    THEN
      -- сохранили <% Скидки>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inId, inChangePercent);
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


select * from gpUpdate_MovementItem_Sale_ChangePercent(inId := 32321893 , inChangePercent := 80 ,  inSession := '3');