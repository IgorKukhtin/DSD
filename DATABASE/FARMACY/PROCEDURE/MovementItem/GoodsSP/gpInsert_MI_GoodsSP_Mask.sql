-- Function: gpInsert_MI_GoodsSP_Mask()

DROP FUNCTION IF EXISTS gpInsert_MI_GoodsSP_Mask (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_GoodsSP_Mask(
    IN inMovementId          Integer   , -- Ключ объекта <Документ >
    IN inMovementId_Mask     Integer   , -- Ключ объекта <Документ маска >
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_GoodsSP());
     vbUserId := inSession;

     -- записываем строки документа
     PERFORM lpInsertUpdate_MovementItem_GoodsSP (ioId                 := COALESCE (MI_Master.Id, 0)
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := COALESCE (MI_Master.GoodsId, MI_Mask.GoodsId, 0)
                                                , inIntenalSPId        := COALESCE (MI_Mask.IntenalSPId, MI_Master.IntenalSPId, 0)
                                                , inBrandSPId          := COALESCE (MI_Mask.BrandSPId, MI_Master.BrandSPId, 0)
                                                , inKindOutSPId        := COALESCE (MI_Mask.KindOutSPId, MI_Master.KindOutSPId, 0)
                                                , inColSP              := COALESCE (MI_Mask.ColSP, MI_Master.ColSP, 0)               :: TFloat
                                                , inCountSP            := COALESCE (MI_Mask.CountSP, MI_Master.CountSP, 0)           :: TFloat
                                                , inPriceOptSP         := COALESCE (MI_Mask.PriceOptSP, MI_Master.PriceOptSP, 0)     :: TFloat
                                                , inPriceRetSP         := COALESCE (MI_Mask.PriceRetSP, MI_Master.PriceRetSP, 0)     :: TFloat
                                                , inDailyNormSP        := COALESCE (MI_Mask.DailyNormSP, MI_Master.DailyNormSP, 0)   :: TFloat
                                                , inDailyCompensationSP:= COALESCE (MI_Mask.DailyCompensationSP, MI_Master.DailyCompensationSP, 0) ::TFloat
                                                , inPriceSP            := COALESCE (MI_Mask.PriceSP, MI_Master.PriceSP, 0)           :: TFloat
                                                , inPaymentSP          := COALESCE (MI_Mask.PaymentSP, MI_Master.PaymentSP, 0)       :: TFloat
                                                , inGroupSP            := COALESCE (MI_Mask.GroupSP, MI_Master.GroupSP, 0)           :: TFloat
                                                , inPack               := COALESCE (MI_Mask.Pack, MI_Master.Pack, '')                :: TVarChar
                                                , inCodeATX            := COALESCE (MI_Mask.CodeATX, MI_Master.CodeATX, '')          :: TVarChar
                                                , inMakerSP            := COALESCE (MI_Mask.MakerSP, MI_Master.MakerSP, '')          :: TVarChar
                                                , inReestrSP           := COALESCE (MI_Mask.ReestrSP, MI_Master.ReestrSP, '')        :: TVarChar
                                                , inReestrDateSP       := COALESCE (MI_Mask.ReestrDateSP, MI_Master.ReestrDateSP, ''):: TVarChar
                                                , inUserId             := vbUserId
                                                )
                                                
     FROM gpSelect_MovementItem_GoodsSP (inMovementId, 'False', 'False', inSession) AS MI_Master
          FULL JOIN (SELECT * FROM gpSelect_MovementItem_GoodsSP (inMovementId_Mask, 'False', 'False', inSession) AS ttt) AS MI_Mask ON MI_Mask.GoodsId = MI_Master.GoodsId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
  22.08.18        *
*/

-- тест
-- 