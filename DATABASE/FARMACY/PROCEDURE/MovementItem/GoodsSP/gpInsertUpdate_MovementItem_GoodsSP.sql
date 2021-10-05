-- Function: gpInsert_MovementItem_GoodsSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSP (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Float, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSP (Integer, Integer,  Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSP (Integer, Integer,  Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSP (Integer, Integer,  Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSP (Integer, Integer,  Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSP (Integer, Integer,  Integer, Integer, Integer, Integer
                                                           , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                           , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                           , TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsSP(
 INOUT ioId                   Integer   , -- Ключ записи
    IN inMovementId           Integer   ,
    IN inGoodsId              Integer   , -- Товары
    IN inIntenalSPId          Integer ,
    IN inBrandSPId            Integer ,
    IN inKindOutSPId          Integer ,
    IN inColSP                TFloat  ,
    IN inCountSPMin           TFloat  ,
    IN inCountSP              TFloat  ,
    IN inPriceOptSP           TFloat  ,
    IN inPriceRetSP           TFloat  ,
    IN inDailyNormSP          TFloat  ,
    IN inDailyCompensationSP  TFloat  ,
    IN inPriceSP              TFloat  ,
    IN inPaymentSP            TFloat  ,
    IN inGroupSP              TFloat  ,

    IN inDenumeratorValueSP   TFloat  ,

    IN inPack                 TVarChar,
    IN inCodeATX              TVarChar,
    IN inMakerSP              TVarChar,
    IN inReestrSP             TVarChar,
    IN inReestrDateSP         TVarChar,
    IN inIdSP                 TVarChar  ,    --
    IN inDosageIdSP           TVarChar  ,    --

    IN inProgramIdSP          TVarChar  ,    --
    IN inNumeratorUnitSP      TVarChar  ,    --
    IN inDenumeratorUnitSP    TVarChar  ,    --

    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- сохранить запись
    ioId := lpInsertUpdate_MovementItem_GoodsSP (ioId                  := COALESCE(ioId,0)
                                               , inMovementId          := inMovementId
                                               , inGoodsId             := inGoodsId
                                               , inIntenalSPId         := inIntenalSPId
                                               , inBrandSPId           := inBrandSPId
                                               , inKindOutSPId         := inKindOutSPId
                                               , inColSP               := inColSP
                                               , inCountSPMin          := inCountSPMin
                                               , inCountSP             := inCountSP
                                               , inPriceOptSP          := inPriceOptSP
                                               , inPriceRetSP          := inPriceRetSP
                                               , inDailyNormSP         := inDailyNormSP
                                               , inDailyCompensationSP := inDailyCompensationSP
                                               , inPriceSP             := inPriceSP
                                               , inPaymentSP           := inPaymentSP
                                               , inGroupSP             := inGroupSP
                                               , inDenumeratorValueSP  := inDenumeratorValueSP
                                               , inPack                := inPack
                                               , inCodeATX             := inCodeATX
                                               , inMakerSP             := inMakerSP
                                               , inReestrSP            := inReestrSP
                                               , inReestrDateSP        := inReestrDateSP
                                               , inIdSP                := inIdSP
                                               , inDosageIdSP          := inDosageIdSP
                                               , inProgramIdSP         := inProgramIdSP
                                               , inNumeratorUnitSP     := inNumeratorUnitSP
                                               , inDenumeratorUnitSP   := inDenumeratorUnitSP
                                               , inUserId              := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.07.19         *
 22.04.19         * add IdSP, inDosageIdSP
 14.08.18         *
*/
--