-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternal(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountManual        TFloat    , -- Ручное количество Итого
    IN inPrice               TFloat    ,
    IN inComment             TVarChar  ,
    IN inPartnerGoodsCode    TVarChar  ,
    IN inPartnerGoodsName    TVarChar  ,
    IN inJuridicalName       TVarChar  ,
    IN inContractName        TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE(ioId Integer, ioPrice TFloat, ioPartnerGoodsCode TVarChar, ioPartnerGoodsName TVarChar
            , ioJuridicalName TVarChar, ioContractName TVarChar
            , outSumm TFloat, outCalcAmount TFloat, outSummAll TFloat, outAmountAll TFloat, outCalcAmountAll TFloat
            , outAmount TFloat, outMessageText TVarChar
            , outMakerName TVarChar, outPartionGoodsDate TDateTime
) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbId Integer;

   DECLARE vbSumm TFloat;   
   DECLARE vbCalcAmount TFloat;   
   DECLARE vbSummAll TFloat;   
   DECLARE vbAmountAll TFloat;   
   DECLARE vbCalcAmountAll TFloat;   
   DECLARE vbMinimumLot TFloat;   
   DECLARE vbMakerName TVarChar;
   DECLARE vbPartionGoodsDate TDateTime;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    
     -- Поиск
     vbId:= (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE);

     -- Проверка что б такого элемента не было - т.е. ошибку лайт)
     IF COALESCE (vbId, 0) <> 0 AND COALESCE (inId, 0) = 0
     THEN 
     
        RETURN QUERY
        SELECT MovementItem.Id    AS ioId
             , inPrice            AS ioPrice
             , inPartnerGoodsCode AS ioPartnerGoodsCode
             , inPartnerGoodsName AS ioPartnerGoodsName
             , inJuridicalName    AS ioJuridicalName
             , inContractName     AS ioContractName
             , (CEIL (MovementItem.Amount / COALESCE (vbMinimumLot, 1)) * COALESCE (vbMinimumLot, 1) * inPrice) :: TFloat AS outSumm
             , (CEIL (MovementItem.Amount / COALESCE (vbMinimumLot, 1)) * COALESCE (vbMinimumLot, 1))           :: TFloat AS outCalcAmount
             , (COALESCE (-- Количество, установленное вручную
                          MIFloat_AmountManual.ValueData
                          -- округлили ВВЕРХ AllLot
                        , CEIL ((--Спецзаказ
                                 MovementItem.Amount
                                 -- Количество дополнительное
                               + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                 -- кол-во отказов
                               + COALESCE (MIFloat_ListDiff.ValueData, 0)
                                 -- кол-во СУА
                               + COALESCE (MIFloat_AmountSUA.ValueData, 0)
                                ) / COALESCE (vbMinimumLot, 1)
                               ) * COALESCE (vbMinimumLot, 1)
                         ) * inPrice) :: TFloat AS outSummAll
             , (MovementItem.Amount + COALESCE(MIFloat_AmountSecond.ValueData,0) /*+ COALESCE(MIFloat_ListDiff.ValueData,0)*/ ) :: TFloat AS outAmountAll
             , COALESCE (-- Количество, установленное вручную
                         MIFloat_AmountManual.ValueData
                          -- округлили ВВЕРХ AllLot
                       , CEIL ((--Спецзаказ
                                 MovementItem.Amount
                                -- Количество дополнительное
                              + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                 -- кол-во отказов
                              + COALESCE (MIFloat_ListDiff.ValueData, 0)
                                -- кол-во СУА
                              + COALESCE (MIFloat_AmountSUA.ValueData, 0)
                               ) / COALESCE (vbMinimumLot, 1)
                              ) * COALESCE (vbMinimumLot, 1)
                        ) :: TFloat AS outCalcAmountAll

             , MovementItem.Amount            AS outAmount
             , ('Ошибка.' || CHR (13) || 'Для товара <' || lfGet_Object_ValueData (MovementItem.ObjectId) || '> уже сформировано кол-во заказа = <' || MovementItem.Amount :: TVarChar || '>.' || CHR (13) || 'Информация обновлена.') :: TVarChar AS outMessageText 

             , MIString_Maker.ValueData       :: TVarChar    AS outMakerName
             , MIDate_PartionGoods.ValueData  :: TDateTime   AS outPartionGoodsDate
            
        FROM MovementItem
             LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
             LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                               ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                                              AND MIFloat_AmountManual.ValueData <> 0
             LEFT OUTER JOIN MovementItemFloat AS MIFloat_ListDiff
                                               ON MIFloat_ListDiff.MovementItemId = MovementItem.Id
                                              AND MIFloat_ListDiff.DescId = zc_MIFloat_ListDiff()
             LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSUA
                                               ON MIFloat_AmountSUA.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountSUA.DescId         = zc_MIFloat_AmountSUA()

             LEFT JOIN MovementItemString AS MIString_Maker 
                                          ON MIString_Maker.MovementItemId = MovementItem.Id
                                         AND MIString_Maker.DescId = zc_MIString_Maker()
             LEFT JOIN MovementItemDate AS MIDate_PartionGoods                                        
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId = MovementItem.Id

            
        WHERE MovementItem.Id = vbId;

        -- !!!Выход!!!
        RETURN;

     END IF;


    IF inJuridicalName = '' THEN 
        PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, inGoodsId, vbUserId);
        SELECT MinPrice.Price
            , MinPrice.GoodsCode
            , MinPrice.GoodsName
            , MinPrice.JuridicalName
            , MinPrice.ContractName  
            , MinPrice.MakerName
            , MinPrice.PartionGoodsDate
        INTO inPrice
            , inPartnerGoodsCode
            , inPartnerGoodsName
            , inJuridicalName
            , inContractName 
            , vbMakerName
            , vbPartionGoodsDate
        FROM (
                SELECT *, MIN(DDD.Id) OVER(PARTITION BY MovementItemId) AS MinId 
                FROM(
                        SELECT *, MIN(SuperFinalPrice_Deferment) OVER(PARTITION BY MovementItemId) AS MinSuperFinalPrice
                        FROM _tmpMI
                    ) AS DDD
                WHERE DDD.SuperFinalPrice_Deferment = DDD.MinSuperFinalPrice
             ) AS MinPrice
        WHERE MinPrice.Id = MinPrice.MinId;
    END IF;
  
    inPrice := COALESCE(inPrice, 0);
    -- проверить что у нас на самом деле меняется
    SELECT Object_Goods_Retail.MinimumLot INTO vbMinimumLot
    FROM Object_Goods_Retail 
    WHERE Object_Goods_Retail.Id = inGoodsId
      AND Object_Goods_Retail.MinimumLot <> 0;
    
    SELECT
        (CEIL((MovementItem.Amount
             + COALESCE (MIFloat_AmountSecond.ValueData, 0)
             + COALESCE (MIFloat_ListDiff.ValueData, 0)
             + COALESCE (MIFloat_AmountSUA.ValueData, 0)
              ) / COALESCE (vbMinimumLot, 1)
             ) * COALESCE (vbMinimumLot, 1)) :: TFloat
      , COALESCE (MIFloat_AmountManual.ValueData
                , CEIL((MovementItem.Amount
                      + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                      + COALESCE (MIFloat_ListDiff.ValueData, 0)
                      + COALESCE (MIFloat_AmountSUA.ValueData, 0)
                       ) / COALESCE (vbMinimumLot, 1)
                      ) * COALESCE(vbMinimumLot, 1)
                 ) :: TFloat
    INTO
        vbCalcAmount,
        vbCalcAmountAll
    FROM
        MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                          ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                          ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_ListDiff
                                          ON MIFloat_ListDiff.MovementItemId = MovementItem.Id
                                         AND MIFloat_ListDiff.DescId = zc_MIFloat_ListDiff()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSUA
                                          ON MIFloat_AmountSUA.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountSUA.DescId = zc_MIFloat_AmountSUA()
    WHERE MovementItem.Id = inId;
    
    IF (coalesce(vbCalcAmount,0) <> coalesce(inAmountManual,0)) or (COALESCE(vbCalcAmountAll,0) <> COALESCE(inAmountManual,0))
    THEN
        vbId := lpInsertUpdate_MovementItem_OrderInternal(inId, inMovementId, inGoodsId, inAmount, inAmountManual, inPrice, vbUserId);
    ELSE
        vbId := lpInsertUpdate_MovementItem_OrderInternal(inId, inMovementId, inGoodsId, inAmount, NULL, inPrice, vbUserId);
    END IF;    

          -- сохранили свойство <Примечание>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbId, inComment);
     
    IF COALESCE (inContractName, '') = ''
    THEN 
        DROP TABLE IF EXISTS _tmpMI;
        PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, inGoodsId, vbUserId);
        SELECT MinPrice.MakerName
             , MinPrice.ContractName
             , MinPrice.PartionGoodsDate
         INTO  vbMakerName
             , inContractName
             , vbPartionGoodsDate
         FROM (
                 SELECT *, MIN(DDD.Id) OVER(PARTITION BY MovementItemId) AS MinId 
                 FROM(
                         SELECT *, MIN(SuperFinalPrice_Deferment) OVER(PARTITION BY MovementItemId) AS MinSuperFinalPrice
                         FROM _tmpMI
                     ) AS DDD
                 WHERE DDD.SuperFinalPrice_Deferment = DDD.MinSuperFinalPrice
              ) AS MinPrice
         WHERE MinPrice.Id = MinPrice.MinId;
    END IF;

    vbCalcAmount := CEIL(inAmount / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1);     
    vbSumm := vbCalcAmount * inPrice;
    SELECT
         (CEIL(inAmount / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1))           :: TFloat AS outCalcAmount
       , (CEIL(inAmount / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1) * inPrice) :: TFloat AS outSumm
       , (inAmount + COALESCE(MIFloat_AmountSecond.ValueData,0) /*+ COALESCE(MIFloat_ListDiff.ValueData,0)*/ ) :: TFloat AS outAmountAll
       , COALESCE (MIFloat_AmountManual.ValueData
                 , CEIL ((inAmount
                        + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                        + COALESCE(MIFloat_ListDiff.ValueData,0)
                        + COALESCE (MIFloat_AmountSUA.ValueData, 0)
                         ) / COALESCE (vbMinimumLot, 1)
                        ) * COALESCE (vbMinimumLot, 1)
                  ) :: TFloat AS outCalcAmountAll
       , (COALESCE (MIFloat_AmountManual.ValueData
                  , CEIL ((inAmount
                         + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                         + COALESCE(MIFloat_ListDiff.ValueData,0)
                         + COALESCE (MIFloat_AmountSUA.ValueData, 0)
                          ) / COALESCE (vbMinimumLot, 1)
                         ) * COALESCE (vbMinimumLot, 1)
                   ) * inPrice) :: TFloat AS outSummAll

       , COALESCE (MIString_Maker.ValueData, vbMakerName)              :: TVarChar    AS outMakerName
       , COALESCE (Object_Contract.ValueData, inContractName)          :: TVarChar    AS ioContractName     
       , COALESCE (MIDate_PartionGoods.ValueData, vbPartionGoodsDate)  :: TDateTime   AS outPartionGoodsDate
       
    INTO
         vbCalcAmount
       , vbSumm
       , vbAmountAll
       , vbCalcAmountAll
       , vbSummAll
       , vbMakerName
       , inContractName
       , vbPartionGoodsDate
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                          ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                          ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_ListDiff
                                          ON MIFloat_ListDiff.MovementItemId = MovementItem.Id
                                         AND MIFloat_ListDiff.DescId = zc_MIFloat_ListDiff()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSUA
                                          ON MIFloat_AmountSUA.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountSUA.DescId         = zc_MIFloat_AmountSUA()

        LEFT JOIN MovementItemString AS MIString_Maker 
                                     ON MIString_Maker.MovementItemId = MovementItem.Id
                                    AND MIString_Maker.DescId = zc_MIString_Maker()
       
        LEFT JOIN MovementItemDate AS MIDate_PartionGoods                                        
                                   ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                  AND MIDate_PartionGoods.MovementItemId = MovementItem.Id

        LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                                         ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                        AND MILinkObject_Contract.MovementItemId = MovementItem.Id
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId AND Object_Contract.DescId = zc_Object_Contract()
    WHERE MovementItem.Id = vbId;
    
    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    RETURN 
        QUERY
        SELECT vbId
           , inPrice
           , inPartnerGoodsCode
           , inPartnerGoodsName
           , inJuridicalName
           , inContractName      AS ioContractName
           , vbSumm
           , vbCalcAmount
           , vbSummAll
           , vbAmountAll
           , vbCalcAmountAll
           , inAmount            AS outAmount
           , '' :: TVarChar      AS outMessageText
           , vbMakerName         AS outMakerName
           , vbPartionGoodsDate  AS outPartionGoodsDate
          ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 22.03.21                                                                     * add AmountSUA
 02.11.18         * add ListDiff
 30.08.17         *
 30.03.16                                        * add ошибка лайт
 06.02.15                         *
 23.10.14                         *
 03.07.14                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')