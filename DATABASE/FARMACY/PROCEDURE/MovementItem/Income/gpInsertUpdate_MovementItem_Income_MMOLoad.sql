-- Function: gpInsertUpdate_MovementItem_Income_MMOLoad ()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_MMOLoad
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_MMOLoad(TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TDateTime, Boolean, Integer
                                                                 , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar
                                                                 , TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_MMOLoad(TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TDateTime, Boolean, Integer
                                                                 , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar
                                                                 , TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TVarChar, TVarChar);
                                                                 
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income_MMOLoad(
    IN inOKPOFrom            TVarChar  , -- Юридические лица
    IN inOKPOTo              TVarChar  , -- Юридические лица

    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inInvTaxNumber        TVarChar  , -- Номер налоговой
    IN inPaymentDate         TDateTime , -- Дата оплаты
    IN inPriceWithVAT        Boolean   , -- Признак: цена включает НДС или не вкл.НДС
    IN inSyncCode            Integer   , -- Код метода синхронизации

    IN inRemark              TVarChar  , -- Комментарий
    
    IN inGoodsCode           TVarChar  , -- ID товара
    IN inGoodsName           TVarChar  , -- Наименование товара
    IN inMakerCode           TVarChar  , -- ID производителя
    IN inMakerName           TVarChar  , -- Наименование производителя
    IN inCommonCode          Integer   , -- ID внешний (например Морион)
    IN inVAT                 Integer   , -- Процент НДС
    IN inPartitionGoods      TVarChar  , -- Номер серии 
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inAmount              TFloat    , -- Количество 
    IN inPrice               TFloat    , -- Цена Отпускная (для аптеки это закупочная)
    IN inFEA                 TVarChar  , -- УК ВЭД
    IN inMeasure             TVarChar  , -- Ед. измерения
    IN inSertificatNumber    TVarChar  , -- Номер регистрации
    IN inSertificatStart     TDateTime , -- Дата начала регистрации
    IN inSertificatEnd       TDateTime , -- Дата окончания регистрации
    
    IN inisLastRecord        Boolean   ,
    IN inCodeUKTZED          TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbJuridicalId_from Integer;
   DECLARE vbJuridicalId_to   Integer;
BEGIN

     -- Проверка
     IF 1 < (SELECT COUNT(*) FROM ObjectHistory_JuridicalDetails_View WHERE OKPO = inOKPOFrom)
     THEN
         RAISE EXCEPTION 'Невозможно определить Юридическое лицо, одинаковое ОКПО "%" установлено у разных Юридических лиц.', inOKPOFrom;
     END IF;
     -- Проверка
     IF 1 < (SELECT COUNT(*) FROM ObjectHistory_JuridicalDetails_View WHERE OKPO = inOKPOTo)
     THEN
         RAISE EXCEPTION 'Невозможно определить Юридическое лицо, одинаковое ОКПО "%" установлено у разных Юридических лиц.', inOKPOTo;
     END IF;

     -- нашли Поставщика
     vbJuridicalId_from:= (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE OKPO = inOKPOFrom);
     -- Если не нашли, то сразу ругнемся. 
     IF COALESCE (vbJuridicalId_from, 0) = 0
     THEN
        RAISE EXCEPTION 'Не определено Юридическое лицо Поставщика с ОКПО "%"', inOKPOFrom;
     END IF;

     -- нашли "Наше"
     vbJuridicalId_to:= (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE OKPO = inOKPOTo);
     -- Если не нашли, то сразу ругнемся. 
     IF COALESCE (vbJuridicalId_to, 0) = 0
     THEN
        RAISE EXCEPTION 'Не определено Наше Юридическое лицо с ОКПО "%"', inOKPOTo;
     END IF;

	
   -- сохранили
   PERFORM gpInsertUpdate_MovementItem_Income_Load (inJuridicalId_from := vbJuridicalId_from   -- Юридические лица - Поставщик
                                                  , inJuridicalId_to   := vbJuridicalId_to     -- Юридические лица - "Наше"
                                                  , inInvNumber := inInvNumber   
                                                  , inOperDate := inOperDate     -- Дата документа
                                                  , inCommonCode := inCommonCode 
                                                  , inBarCode := ''              
                                                  , inGoodsCode := inGoodsCode   
                                                  , inGoodsName := inGoodsName   
                                                  , inAmount    := inAmount       
                                                  , inPrice     := inPrice        
                                                  , inExpirationDate := inExpirationDate  -- Срок годности
                                                  , inPartitionGoods := inPartitionGoods    
                                                  , inPaymentDate    := inPaymentDate     -- Дата оплаты
                                                  , inPriceWithVAT   := inPriceWithVAT   
                                                  , inVAT            := inVAT            
                                                  , inUnitName       := inRemark         
                                                  , inMakerName      := inMakerName      
                                                  , inFEA            := inFEA             -- УК ВЭД
                                                  , inMeasure        := inMeasure         -- Ед. измерения
                                                  , inSertificatNumber := inSertificatNumber -- Номер регистрации
                                                  , inSertificatStart  := inSertificatStart  -- Дата начала регистрации
                                                  , inSertificatEnd    := inSertificatEnd    -- Дата окончания регистрации

                                                  , inisLastRecord   := inisLastRecord  
                                                  , inCodeUKTZED     := inCodeUKTZED
                                                  , inSession        := CASE WHEN inSession = '1871720' THEN '2592170' ELSE inSession END); -- Авто-загрузка прайс-поставщик => Авто-загрузка ММО
                                                  
                                                  
   --

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 11.12.17         * inCodeUKTZED
 01.10.15                                                                      * inSertificatNumber, inSertificatStart, inSertificatEnd
 06.03.15                        *   
 05.01.15                        *   
*/
