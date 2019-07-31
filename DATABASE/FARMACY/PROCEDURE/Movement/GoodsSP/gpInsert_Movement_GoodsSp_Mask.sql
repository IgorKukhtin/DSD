-- Function: gpInsert_Movement_GoodsSP_Mask()

DROP FUNCTION IF EXISTS gpInsert_Movement_GoodsSP_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_GoodsSP_Mask(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ >
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_GoodsSP());
     vbUserId := inSession;

     -- сохранили <Документ>
     SELECT gpInsertUpdate_Movement_GoodsSP (ioId               := 0
                                           , inInvNumber        := CAST (NEXTVAL ('movement_goodssp_seq') AS TVarChar)
                                           , inOperDate         := inOperDate                   ::  TDateTime
                                           , inOperDateStart    := tmp.OperDateStart            ::  TDateTime
                                           , inOperDateEnd      := tmp.OperDateEnd              ::  TDateTime
                                           , inSession          := inSession
                                            )
     INTO vbMovementId
     FROM gpGet_Movement_GoodsSP (ioId, 'False', inOperDate, inSession) AS tmp;

     -- записываем строки документа
     PERFORM lpInsertUpdate_MovementItem_GoodsSP  (ioId    := 0
                                                 , inMovementId         := vbMovementId
                                                 , inGoodsId            := tmp.GoodsId                    :: Integer
                                                 , inIntenalSPId        := tmp.IntenalSPId                :: Integer
                                                 , inBrandSPId          := tmp.BrandSPId                  :: Integer
                                                 , inKindOutSPId        := tmp.KindOutSPId                :: Integer
                                                 , inColSP              := COALESCE (tmp.ColSP, 0)        :: TFloat
                                                 , inCountSP            := COALESCE (tmp.CountSP, 0)      :: TFloat
                                                 , inPriceOptSP         := COALESCE (tmp.PriceOptSP, 0)   :: TFloat
                                                 , inPriceRetSP         := COALESCE (tmp.PriceRetSP, 0)   :: TFloat
                                                 , inDailyNormSP        := COALESCE (tmp.DailyNormSP, 0)  :: TFloat
                                                 , inDailyCompensationSP:= COALESCE (tmp.DailyCompensationSP, 0) ::TFloat
                                                 , inPriceSP            := COALESCE (tmp.PriceSP, 0)      :: TFloat
                                                 , inPaymentSP          := COALESCE (tmp.PaymentSP, 0)    :: TFloat
                                                 , inGroupSP            := COALESCE (tmp.GroupSP, 0)      :: TFloat
                                                 , inDenumeratorValueSP := COALESCE (tmp.DenumeratorValueSP,0) ::TFloat
                                                 , inPack               := tmp.Pack                       :: TVarChar
                                                 , inCodeATX            := tmp.CodeATX                    :: TVarChar
                                                 , inMakerSP            := tmp.MakerSP                    :: TVarChar
                                                 , inReestrSP           := tmp.ReestrSP                   :: TVarChar
                                                 , inReestrDateSP       := tmp.ReestrDateSP               :: TVarChar
                                                 , inIdSP               := tmp.IdSP
                                                 , inDosageIdSP         := tmp.DosageIdSP
                                                 , inProgramIdSP        := tmp.ProgramIdSP
                                                 , inNumeratorUnitSP    := tmp.NumeratorUnitSP
                                                 , inDenumeratorUnitSP  := tmp.DenumeratorUnitSP
                                                 , inDynamicsSP         := tmp.DynamicsSP
                                                 , inUserId             := vbUserId
                                                  )
     FROM gpSelect_MovementItem_GoodsSP (ioId, 'False', 'False', inSession)  AS tmp;
     
     -- записываем строки документа
     ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
  20.08.18        *
*/

-- тест
-- 