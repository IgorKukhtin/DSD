-- Function: gpSelect_Movement_Promo_Message()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_Message (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_Message(
    IN inOperDate      TDateTime , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (isSend               Boolean
             , AreaName             TVarChar  -- Регион
             , AreaName_all         TBlob     -- Регион
             , OperDate_message     TDateTime
             , TelegramId           TVarChar
             , TelegramBotToken     TVarChar
             , Msg                  TBlob     -- Регион
             , isStartSale          Boolean
             , isStartPromo         Boolean
             , MovementId           Integer   -- ИД документа акции
             , InvNumber            Integer   -- № документа акции
             , OperDate             TDateTime --
             , DateStartSale        TDateTime -- Дата отгрузки по акционным ценам
             , DeteFinalSale        TDateTime -- Дата отгрузки по акционным ценам
             , DateStartPromo       TDateTime -- Дата проведения акции
             , DateFinalPromo       TDateTime -- Дата проведения акции
             , RetailName           TBlob     -- Сеть, в которой проходит акция
             , TradeMarkName        TVarChar  -- Торговая марка
             , GoodsId              Integer
             , GoodsCode            Integer   -- Код позиции
             , GoodsName            TVarChar  -- Позиция
             , GoodsKindName        TVarChar  -- Наименование обьекта <Вид товара>
             , GoodsKindCompleteName TVarChar -- Наименование обьекта <Вид товара(примечание)>
             , MeasureName          TVarChar  -- единица измерения
             , PriceWithVAT         TFloat    -- Отгрузочная акционная цена с учетом НДС, грн
             , Price                TFloat    -- * Цена спецификации с НДС, грн
             , CostPromo            TFloat    -- * Стоимость участия
             , PriceSale            TFloat    -- * Цена на полке/скидка для покупателя
             , AdvertisingName      TBlob     -- * рекламн.поддержка
             , Comment              TVarChar  -- примечание
             , CommentMain          TVarChar  --
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    
    -- Результат
    RETURN QUERY
      -- Результат
      SELECT TRUE :: Boolean AS isSend
             
           , 'AreaName'   :: TVarChar AS AreaName    -- Регион
           , 'AreaName_all' :: TBlob AS AreaName_all-- Регион
           , CURRENT_DATE :: TDateTime AS OperDate_message

           , '-4889574969' :: TVarChar AS TelegramId
--           , '8397089850:AAG3YSsJeqVXwfDorhVoPH4fIBC5iGuhkvQ' :: TVarChar AS TelegramBotToken -- @test_1001744702809_bot
           , '5733732182:AAFsuEi0lAGAx4O4ZoIO8C4bfnJvKHr020c' :: TVarChar AS TelegramBotToken --  @alan_01_bot

           , ('test send ...'
             ) :: TBlob AS Msg

           , TRUE:: Boolean AS isStartSale
           , TRUE AS isStartPromo

           , 0 :: Integer AS MovementId, 0 :: Integer AS InvNumber
           , CURRENT_DATE :: TDateTime AS OperDate
           , CURRENT_DATE :: TDateTime AS DateStartSale           -- Дата отгрузки по акционным ценам
           , CURRENT_DATE :: TDateTime AS DeteFinalSale           -- Дата отгрузки по акционным ценам
           , CURRENT_DATE :: TDateTime AS DateStartPromo          -- Дата проведения акции
           , CURRENT_DATE :: TDateTime AS DateFinalPromo          -- Дата проведения акции

           , 'RetailName'    :: TBlob AS RetailName              -- Сеть, в которой проходит акция
           , 'TradeMarkName' :: TVarChar AS TradeMarkName           -- Торговая марка
           , 0 :: Integer GoodsId        
           , 0 :: Integer GoodsCode               -- Код позиции
           , 'GoodsName' :: TVarChar AS GoodsName               -- Позиция
           , 'GoodsKindName' :: TVarChar AS GoodsKindName           -- Наименование обьекта <Вид товара>
           , 'GoodsKindCompleteName' :: TVarChar AS GoodsKindCompleteName   -- Наименование обьекта <Вид товара(примечание)>
           , 'MeasureName' :: TVarChar AS MeasureName             -- единица измерения
           , 0 :: TFloat AS PriceWithVAT            -- Отгрузочная акционная цена с учетом НДС, грн
           , 0 :: TFloat AS Price                   -- * Цена спецификации с НДС, грн
           , 0 :: TFloat AS CostPromo               -- * Стоимость участия
           , 0 :: TFloat AS PriceSale               -- * Цена на полке/скидка для покупателя
           , 'AdvertisingName' :: TBlob AS AdvertisingName         -- * рекламн.поддержка
           , 'Comment' :: TVarChar AS Comment                 -- примечание
           , 'CommentMain' :: TVarChar AS CommentMain             --
      WHERE 1=1
        AND vbUserId = 5
     ;
                                                         
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.22                                        *
*/

-- delete from MovementDate where DescId = zc_MovementDate_Message()
-- SELECT * FROM gpSelect_Movement_Promo_Message (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Movement_Promo_Message (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inSession:= zfCalc_UserAdmin());