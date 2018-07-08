-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     ,Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inCurrencyPartnerValue TFloat    ,
    IN inParPartnerValue      TFloat    ,
    --IN inAmountCurrency       TFloat    ,
    IN inAmount               TFloat    , -- сумма обмен
    IN inAmountIn             TFloat    , -- Сумма прихода
    IN inAmountOut            TFloat    , -- Сумма расхода
    
    IN inCashId               Integer   , --
    IN inMoneyPlaceId         Integer   , --
    IN inInfoMoneyId          Integer   ,
    IN inUnitId               Integer   ,
    IN inCurrencyId           Integer   , --
   OUT outCurrencyValue       TFloat    , --
   OUT outParValue            TFloat    , --
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmountCurrency TFloat;   
   DECLARE vbAmount TFloat;
   DECLARE vbAmountIn TFloat;
   DECLARE vbAmountOut TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());


     -- определяется уникальный № док.
     IF vbUserId = zc_User_Sybase() THEN
        -- ioInvNumber:= ioInvNumber;
        UPDATE Movement SET InvNumber = ioInvNumber WHERE Movement.Id = ioId;
        -- если такой элемент не был найден
        IF NOT FOUND THEN
           -- Ошибка
           RAISE EXCEPTION 'Ошибка. NOT FOUND Movement <%>', ioId;
        END IF;

        -- !!!Выход!!!
        RETURN;

     ELSEIF COALESCE (ioId, 0) = 0 THEN
        ioInvNumber:= CAST (NEXTVAL ('movement_cash_seq') AS TVarChar);
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;

     -- Если НЕ Базовая Валюта
     IF inCurrencyDocumentId <> zc_Currency_Basis()
     THEN
         -- Определили курс на Дату документа
         SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue,0)
                INTO outCurrencyValue, outParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := inOperDate -- (SELECT Movement.OperDate FROM Movement  WHERE Movement.Id = ioId)
                                               , inCurrencyCashId:= zc_Currency_Basis()
                                               , inCurrencyToId  := inCurrencyId
                                                ) AS tmp;
     ELSE
         -- курс не нужен
         outCurrencyValue:= 0;
         outParValue     := 0;

     END IF;

     -- !!!очень важный расчет!!!
     IF inAmountIn <> 0 THEN
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN
             -- запишем оригинал - сумму в валюте
             vbAmountCurrency := inAmountIn;
             -- сумму в ГРН - посчитаем - кроме обмена
             vbAmount         := CASE WHEN inAmount > 0 THEN inAmount ELSE CAST (inAmountIn * outCurrencyValue / outParValue AS NUMERIC (16, 2)) END;
             -- это значение в ГРН - сохраним
             vbAmountIn       := vbAmount;

        ELSE -- ВСЕ в ГРН
             vbAmount         := inAmountIn;
             vbAmountIn       := inAmountIn;
        END IF;

     ELSE
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN
             -- запишем оригинал - сумму в валюте
             vbAmountCurrency := -1 * inAmountOut;
             -- сумму в ГРН - посчитаем - кроме обмена
             vbAmount         := -1 * CASE WHEN inAmount > 0 THEN inAmount ELSE CAST (inAmountOut * outCurrencyValue / outParValue AS NUMERIC (16, 2)) END;
             -- это значение в ГРН - сохраним
             vbAmountOut      := ABS (vbAmount);

        ELSE -- ВСЕ в ГРН
             vbAmount         := -1 * inAmountOut;
             vbAmountOut      := inAmountOut;
        END IF;
     END IF;

     -- проверка
     IF COALESCE (vbAmount, 0) = 0 AND inCurrencyId <> 0
     THEN
        RAISE EXCEPTION 'Ошибка.Сумма пересчета из валюты <%> в валюту <%> не должна быть = 0.', lfGet_Object_ValueData (inCurrencyId), lfGet_Object_ValueData (zc_Enum_Currency_Basis());
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Cash (ioId                    := ioId
                                         , inInvNumber             := ioInvNumber
                                         , inOperDate              := inOperDate
                                         , inCurrencyPartnerValue  := inCurrencyPartnerValue
                                         , inParPartnerValue       := inParPartnerValue     
                                         , inAmountCurrency        := vbAmountCurrency      
                                         , inAmount                := inAmount              
                                         , inAmountIn              := vbAmountIn
                                         , inAmountOut             := vbAmountOut
                                         , inCashId                := inCashId              
                                         , inMoneyPlaceId          := inMoneyPlaceId        
                                         , inInfoMoneyId           := inInfoMoneyId         
                                         , inUnitId                := inUnitId              
                                         , inCurrencyId            := inCurrencyId     
                                         , inCurrencyValue         := outCurrencyValue
                                         , inParValue              := outParValue     
                                         , inComment               := inComment             
                                         , inUserId                := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.07.18         *
 */

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Cash (ioId:= 22, ioInvNumber:= '3', inOperDate:= '04.02.2018', inFromId:= 229, inToId:= 311, inCurrencyDocumentId:= zc_Currency_USD(), inComment:= 'vbn', inSession:= zfCalc_UserAdmin()));
