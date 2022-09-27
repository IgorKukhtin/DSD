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
      WITH tmpReport AS (SELECT gpSelect.MovementId, gpSelect.InvNumber, gpSelect.OperDate
                              , gpSelect.DateStartSale           -- Дата отгрузки по акционным ценам
                              , gpSelect.DeteFinalSale           -- Дата отгрузки по акционным ценам
                              , gpSelect.DateStartPromo          -- Дата проведения акции
                              , gpSelect.DateFinalPromo          -- Дата проведения акции
                              , gpSelect.RetailName              -- Сеть, в которой проходит акция
                              , gpSelect.AreaName                -- Регион
                              , gpSelect.TradeMarkName           -- Торговая марка
                              , gpSelect.GoodsId        
                              , gpSelect.GoodsCode               -- Код позиции
                              , gpSelect.GoodsName               -- Позиция
                              , gpSelect.GoodsKindName           -- Наименование обьекта <Вид товара>
                              , gpSelect.GoodsKindCompleteName   -- Наименование обьекта <Вид товара(примечание)>
                              , gpSelect.MeasureName             -- единица измерения
                              , gpSelect.PriceWithVAT            -- Отгрузочная акционная цена с учетом НДС, грн
                              , gpSelect.Price                   -- * Цена спецификации с НДС, грн
                              , gpSelect.CostPromo               -- * Стоимость участия
                              , gpSelect.PriceSale               -- * Цена на полке/скидка для покупателя
                              , gpSelect.AdvertisingName         -- * рекламн.поддержка
                              , gpSelect.Comment                 -- примечание
                              , gpSelect.CommentMain             --
  
                         FROM gpSelect_Report_Promo_Result (inStartDate:= inOperDate, inEndDate:= inOperDate + INTERVAL '7 DAY'
                                                          , inIsPromo:= TRUE, inIsTender:= FALSE, inIsGoodsKind:= TRUE
                                                          , inUnitId:= 0, inRetailId:= 0, inMovementId:= 0, inJuridicalId:= 0
                                                          , inSession:= inSession
                                                           ) AS gpSelect
                         WHERE gpSelect.DateStartSale  = CURRENT_DATE + INTERVAL '2 DAY'
                            OR gpSelect.DateStartPromo = CURRENT_DATE + INTERVAL '2 DAY'
                        )
       , tmpListTelegramId AS (SELECT DISTINCT ObjectString_Area_TelegramId.ValueData AS TelegramId
                               FROM ObjectString AS ObjectString_Area_TelegramId
                               WHERE ObjectString_Area_TelegramId.DescId    = zc_ObjectString_Area_TelegramId()
                                 AND ObjectString_Area_TelegramId.ValueData <> ''
                              )
       , tmpListArea AS (SELECT tmpReport.MovementId
                              , STRING_AGG (DISTINCT Object_Area.ValueData, ';')  AS AreaName
                              , COALESCE (tmpListTelegramId.TelegramId, ObjectString_Area_TelegramId.ValueData) AS TelegramId
                              , COALESCE (ObjectString_Area_TelegramBotToken.ValueData, '5733732182:AAFsuEi0lAGAx4O4ZoIO8C4bfnJvKHr020c') AS TelegramBotToken
                         FROM tmpReport
                              INNER JOIN Movement AS Movement_PromoPartner
                                                  ON Movement_PromoPartner.ParentId = tmpReport.MovementId
                                                 AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                                                 AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                              INNER JOIN MovementItem AS MI_PromoPartner
                                                      ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                     AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                     AND MI_PromoPartner.IsErased   = FALSE
                              INNER JOIN ObjectLink AS ObjectLink_Partner_Area
                                                    ON ObjectLink_Partner_Area.ObjectId = MI_PromoPartner.ObjectId
                                                   AND ObjectLink_Partner_Area.DescId   = zc_ObjectLink_Partner_Area()
                              LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
                              LEFT JOIN ObjectString AS ObjectString_Area_TelegramId
                                                     ON ObjectString_Area_TelegramId.ObjectId  = ObjectLink_Partner_Area.ChildObjectId
                                                    AND ObjectString_Area_TelegramId.DescId    = zc_ObjectString_Area_TelegramId()
                                                    AND ObjectString_Area_TelegramId.ValueData <> ''
                              LEFT JOIN ObjectString AS ObjectString_Area_TelegramBotToken
                                                     ON ObjectString_Area_TelegramBotToken.ObjectId  = ObjectLink_Partner_Area.ChildObjectId
                                                    AND ObjectString_Area_TelegramBotToken.DescId    = zc_ObjectString_Area_TelegramBotToken()
                                                    AND ObjectString_Area_TelegramBotToken.ValueData <> ''
                              -- !!! Фоззі РЦ!!!
                              LEFT JOIN tmpListTelegramId ON ObjectLink_Partner_Area.ChildObjectId = 310819 
                              
                         GROUP BY tmpReport.MovementId
                                , COALESCE (tmpListTelegramId.TelegramId, ObjectString_Area_TelegramId.ValueData)
                                , COALESCE (ObjectString_Area_TelegramBotToken.ValueData, '5733732182:AAFsuEi0lAGAx4O4ZoIO8C4bfnJvKHr020c')
                        )
      -- Результат
      SELECT CASE WHEN tmpListArea.TelegramId <> '' AND MovementDate_Message.ValueData IS NULL
                      THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isSend
             
           , tmpListArea.AreaName   :: TVarChar AS AreaName    -- Регион
           , tmpReport.AreaName                 AS AreaName_all-- Регион
           , COALESCE (MovementDate_Message.ValueData, zc_DateStart()) :: TDateTime AS OperDate_message

           , tmpListArea.TelegramId :: TVarChar AS TelegramId
         --, '-1001660847836' :: TVarChar AS TelegramId
           , COALESCE (tmpListArea.TelegramBotToken, (SELECT MAX (tmpListArea.TelegramBotToken) FROM tmpListArea WHERE tmpListArea.TelegramBotToken <> '')) :: TVarChar AS TelegramBotToken

           , ('АКЦИЯ.'
           || ' Сеть: '    || tmpReport.RetailName || '.'
           || ' Регион: '  || tmpReport.AreaName   || '.'
           || ' Позиция: ' || tmpReport.GoodsName  || '.'
           || ' Торговая марка: '          || COALESCE (tmpReport.TradeMarkName, '')           || '.'
           || ' Вид упаковки: '            || COALESCE (tmpReport.GoodsKindCompleteName, '')   || '.'
           || ' Дата начала отгрузки: '    || zfConvert_DateToString (tmpReport.DateStartSale) || '.'
           || ' Дата окончания отгрузки: ' || zfConvert_DateToString (tmpReport.DeteFinalSale) || '.' 
           || ' Дата начала акции: '       || zfConvert_DateToString (tmpReport.DateStartSale) || '.' 
           || ' Дата окончания акции: '    || zfConvert_DateToString (tmpReport.DeteFinalSale) || '.' 
           || ' Рекламн. поддержка: '      || COALESCE (tmpReport.AdvertisingName, '')         || '.'
             ) :: TBlob AS Msg

           , CASE WHEN tmpReport.DateStartSale  = CURRENT_DATE + INTERVAL '2 DAY' THEN TRUE ELSE FALSE END :: Boolean AS isStartSale
           , CASE WHEN tmpReport.DateStartPromo = CURRENT_DATE + INTERVAL '2 DAY' THEN TRUE ELSE FALSE END :: Boolean AS isStartPromo

           , tmpReport.MovementId, tmpReport.InvNumber, tmpReport.OperDate
           , tmpReport.DateStartSale           -- Дата отгрузки по акционным ценам
           , tmpReport.DeteFinalSale           -- Дата отгрузки по акционным ценам
           , tmpReport.DateStartPromo          -- Дата проведения акции
           , tmpReport.DateFinalPromo          -- Дата проведения акции
           , tmpReport.RetailName              -- Сеть, в которой проходит акция
           , tmpReport.TradeMarkName           -- Торговая марка
           , tmpReport.GoodsId        
           , tmpReport.GoodsCode               -- Код позиции
           , tmpReport.GoodsName               -- Позиция
           , tmpReport.GoodsKindName           -- Наименование обьекта <Вид товара>
           , tmpReport.GoodsKindCompleteName   -- Наименование обьекта <Вид товара(примечание)>
           , tmpReport.MeasureName             -- единица измерения
           , tmpReport.PriceWithVAT            -- Отгрузочная акционная цена с учетом НДС, грн
           , tmpReport.Price                   -- * Цена спецификации с НДС, грн
           , tmpReport.CostPromo               -- * Стоимость участия
           , tmpReport.PriceSale               -- * Цена на полке/скидка для покупателя
           , tmpReport.AdvertisingName         -- * рекламн.поддержка
           , tmpReport.Comment                 -- примечание
           , tmpReport.CommentMain             --
      FROM tmpReport
           LEFT JOIN tmpListArea ON tmpListArea.MovementId = tmpReport.MovementId
           LEFT JOIN MovementDate AS MovementDate_Message
                                  ON MovementDate_Message.MovementId = tmpReport.MovementId
                                 AND MovementDate_Message.DescId     = zc_MovementDate_Message()
      WHERE 1= 0
      ORDER BY tmpReport.DateStartSale
             , tmpReport.DateStartPromo
             , tmpReport.MovementId
             , tmpReport.GoodsCode
             , tmpReport.GoodsKindCompleteName
    --LIMIT 1
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
