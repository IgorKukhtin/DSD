-- Function: gpInsert_Movement_GoodsSPSearch_1303_Mask()

DROP FUNCTION IF EXISTS gpInsert_Movement_GoodsSPSearch_1303_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_GoodsSPSearch_1303_Mask(
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

     -- сохранили новый <Документ>
     SELECT gpInsertUpdate_Movement_GoodsSPSearch_1303 (ioId            := 0
                                                      , inInvNumber     := CAST (NEXTVAL ('Movement_GoodsSPSearch_1303_seq') AS TVarChar)
                                                      , inOperDate      := inOperDate    ::  TDateTime 
                                                      , inOperDateStart := tmp.OperDateStart            ::  TDateTime
                                                      , inOperDateEnd   := tmp.OperDateEnd              ::  TDateTime
                                                      , inSession       := inSession
                                                       )
     INTO vbMovementId
     FROM gpGet_Movement_GoodsSPSearch_1303 (ioId, inOperDate, inSession) AS tmp;
                                                    
     -- записываем строки документа
     PERFORM lpInsertUpdate_MovementItem_GoodsSPSearch_1303  (ioId                 := 0
                                                            , inMovementId         := vbMovementId
                                                            , inGoodsId            := COALESCE (tmp.GoodsId, NULL)   :: Integer 
                                                            , inCol                := tmp.Col                        :: Integer
                                                            
                                                            , inIntenalSP_1303Id   := tmp.IntenalSP_1303Id           :: Integer
                                                            , inBrandSPId          := tmp.BrandSPId                  :: Integer
                                                            
                                                            , inKindOutSP_1303Id   := tmp.KindOutSP_1303Id           :: Integer
                                                            , inDosage_1303Id      := tmp.Dosage_1303Id              :: Integer
                                                            , inCountSP_1303Id     := tmp.CountSP_1303Id             :: Integer
                                                            , inMakerCountrySP_1303Id := tmp.MakerCountrySP_1303Id   :: Integer
                                                            
                                                            , inCodeATX            := tmp.CodeATX                    :: TVarChar
                                                            , inReestrSP           := tmp.ReestrSP                   :: TVarChar
                                                            , inValiditySP         := tmp.ValiditySP                 :: TDateTime
                                                            
                                                            , inPriceOptSP         := COALESCE (tmp.PriceOptSP,0)   :: TFloat
                                                            , inCurrencyId         := tmp.CurrencyId                :: Integer
                                                            , inExchangeRate       := COALESCE (tmp.ExchangeRate,0) :: TFloat
                                                            
                                                            , inOrderNumberSP      := COALESCE (tmp.OrderNumberSP,0)  :: Integer
                                                            , inOrderDateSP        := tmp.OrderDateSP    :: TDateTime
                                                            , inUserId             := vbUserId           :: Integer
                                                             )
     FROM gpSelect_MovementItem_GoodsSPSearch_1303 (ioId, 'False', 'False', inSession)  AS tmp;                        
    
     -- записываем строки документа
     ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  16.11.22        *
*/

-- тест
-- 
