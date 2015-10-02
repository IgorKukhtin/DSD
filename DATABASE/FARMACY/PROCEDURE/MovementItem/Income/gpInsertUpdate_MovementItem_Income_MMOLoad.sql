/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_MMOLoad 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TVarChar,
           TVarChar,
           Boolean,
           TVarChar); */

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
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbJuridicalId Integer;
BEGIN

     SELECT JuridicalId INTO vbJuridicalId FROM ObjectHistory_JuridicalDetails_View
            WHERE OKPO = inOKPOFrom;
  
     -- Если не нашли, то сразу ругнемся. 
     IF COALESCE(vbJuridicalId, 0) = 0 THEN
        RAISE EXCEPTION 'Не определено Юридическое лицо с ОКПО <%>', inOKPOFrom;
     END IF;

	
    PERFORM gpInsertUpdate_MovementItem_Income_Load(inJuridicalId := vbJuridicalId, -- Юридические лица
                                                    inInvNumber := inInvNumber  , 
                                                    inOperDate := inOperDate    , -- Дата документа
                                                    inCommonCode := inCommonCode, 
                                                    inBarCode := ''             , 
                                                    inGoodsCode := inGoodsCode  , 
                                                    inGoodsName := inGoodsName  , 
                                                    inAmount    := inAmount     ,  
                                                    inPrice     := inPrice      ,  
                                                    inExpirationDate := inExpirationDate , -- Срок годности
                                                    inPartitionGoods := inPartitionGoods ,   
                                                    inPaymentDate    := inPaymentDate    , -- Дата оплаты
                                                    inPriceWithVAT   := inPriceWithVAT   ,
                                                    inVAT            := inVAT            ,
                                                    inUnitName       := inRemark         ,
                                                    inMakerName      := inMakerName      ,
                                                    inFEA            := inFEA            , -- УК ВЭД
                                                    inMeasure        := inMeasure        , -- Ед. измерения
                                                    inSertificatNumber := inSertificatNumber, -- Номер регистрации
                                                    inSertificatStart  := inSertificatStart , -- Дата начала регистрации
                                                    inSertificatEnd    := inSertificatEnd   , -- Дата окончания регистрации

                                                    inisLastRecord   := inisLastRecord  ,
                                                    inSession        := inSession);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 01.10.15                                                                      * inSertificatNumber, inSertificatStart, inSertificatEnd
 06.03.15                        *   
 05.01.15                        *   
*/
