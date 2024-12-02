-- Function: gpInsertUpdate_Movement_ContractGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ContractGoods(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа / С какой даты действует
    --IN inEndBeginDate        TDateTime , -- По какую дату действует
   OUT outEndBeginDate       TDateTime , -- По какую дату действует
    IN inContractId          Integer   , -- 
    IN inCurrencyId          Integer   , -- Валюта 
    IN inSiteTagId           Integer   , -- Категория сайт
    IN inDiffPrice           TFloat    ,  -- Разрешенный % отклонение для цены
    IN inRoundPrice          TFloat    ,  -- Кол-во знаков для округления 
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет) 
    IN inisMultWithVAT       Boolean   , -- Цена кратная НДС
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ContractGoods());
     
     -- сохранили <Документ>
      SELECT tmp.ioId, tmp.ioInvNumber, tmp.outEndBeginDate
             INTO ioId, ioInvNumber, outEndBeginDate
      FROM lpInsertUpdate_Movement_ContractGoods (ioId           := ioId
                                                , ioInvNumber    := ioInvNumber
                                                , inOperDate     := inOperDate
                                                --, inEndBeginDate := inEndBeginDate
                                                , inContractId   := inContractId 
                                                , inCurrencyId   := inCurrencyId
                                                , inSiteTagId    := inSiteTagId
                                                , inDiffPrice    := inDiffPrice
                                                , inRoundPrice   := inRoundPrice 
                                                , inPriceWithVAT := inPriceWithVAT
                                                , inisMultWithVAT:= inisMultWithVAT ::Boolean
                                                , inComment      := inComment
                                                , inUserId       := vbUserId
                                                 ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.12.24         *
 15.11.24         *
 29.11.23         *
 08.11.23         *
 15.09.22         *
 05.07.21         *
*/

-- тест
-- select * from gpInsertUpdate_Movement_ContractGoods(ioId := 18775751 , ioInvNumber := '2' , ioOperDate := ('13.01.2021')::TDateTime , inOperDate_top := ('31.01.2021')::TDateTime , inPartnerId := 4126219 , inTotalCountKg := 222 , inTotalSumm := 22222 , inComment := '' ,  inSession := '5');
