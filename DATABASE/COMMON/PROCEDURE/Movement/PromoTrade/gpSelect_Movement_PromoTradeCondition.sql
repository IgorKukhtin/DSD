-- Function: gpSelect_Movement_PromoTradeCondition()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoTradeCondition (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoTradeCondition(
    IN inMovementId    Integer , -- Ключ документа <Акция>
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord              Integer
             , Name             TVarChar    --имя параметра
             , Value            TVarChar    --значение параметра 
              )

AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementId_PromoTradeCondition Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

 /*     select zc_MovementLinkObject_PriceList 
 union select zc_MovementLinkObject_Contract.Скидка 
 union select zc_MovementLinkObject_Contract.Отсрочка по договору (в этой колонке название банк или календарные дни)   zc_MovementLinkObject_ContractConditionKind /  zc_MovementFloat_DelayDay
 union select zc_MovementFloat_RetroBonus :: TVarChar 
 union select zc_MovementFloat_Market :: TVarChar 
 union select zc_MovementFloat_ReturnIn :: TVarChar 
 union select zc_MovementFloat_Logist :: TVarChar
 */

    vbMovementId_PromoTradeCondition := (SELECT Movement.Id
                                         FROM Movement
                                         WHERE Movement.DescId = zc_Movement_PromoTradeCondition()
                                           AND Movement.ParentId =  inMovementId
                                         );

    -- Результат
    RETURN QUERY
    WITH 
    tmpText AS (    SELECT  1 ::Integer  AS Ord, 'Прайс-лист:'              ::TVarChar AS Name
              UNION SELECT  2 ::Integer  AS Ord, 'Скидка:'                  ::TVarChar AS Name
              UNION SELECT  3 ::Integer  AS Ord, 'Отсрочка по договору:'    ::TVarChar AS Name
              UNION SELECT  4 ::Integer  AS Ord, 'Ретро бонус:'             ::TVarChar AS Name
              UNION SELECT  5 ::Integer  AS Ord  , 'Маркетинговый бюджет:'  ::TVarChar AS Name
              UNION SELECT  6 ::Integer  AS Ord  , 'Компенсация возвратов:' ::TVarChar AS Name
              UNION SELECT  7 ::Integer  AS Ord  , 'Логистический бонус:'   ::TVarChar AS Name
              UNION SELECT  8 ::Integer  AS Ord  , 'Отчеты:'                ::TVarChar AS Name
              UNION SELECT  9 ::Integer  AS Ord  , 'Маркетинг:'             ::TVarChar AS Name
                 )

    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , Object_PriceList.ValueData ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList 
                                      ON MovementLinkObject_PriceList.MovementId = inMovementId
                                     AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
         LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId
    WHERE tmpText.Ord = 1
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          ,  MovementFloat_ChangePercent.ValueData ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent 
                                 ON MovementFloat_ChangePercent.MovementId = inMovementId
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
    WHERE tmpText.Ord = 2
    
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , ((COALESCE (MovementFloat_DelayDay.ValueData, 0) ::Integer) ||     
            CASE WHEN MovementLinkObject_CCKind.ObjectId = zc_Enum_ContractConditionKind_DelayDayCalendar() THEN  ' К.дн.'   
                 WHEN MovementLinkObject_CCKind.ObjectId = zc_Enum_ContractConditionKind_DelayDayBank() THEN ' Б.дн.'
                 ELSE ' дн.'
            END)                       ::TVarChar AS Value                                               
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_DelayDay
                                 ON MovementFloat_DelayDay.MovementId = inMovementId
                                AND MovementFloat_DelayDay.DescId = zc_MovementFloat_DelayDay() 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_CCKind
                                      ON MovementLinkObject_CCKind.MovementId = inMovementId
                                     AND MovementLinkObject_CCKind.DescId = zc_MovementLinkObject_ContractConditionKind()
    WHERE tmpText.Ord = 3
     
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_RetroBonus.ValueData) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_RetroBonus 
                                 ON MovementFloat_RetroBonus.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_RetroBonus.DescId = zc_MovementFloat_RetroBonus()
    WHERE tmpText.Ord = 4
    
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_Market.ValueData) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_Market 
                                 ON MovementFloat_Market.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Market.DescId = zc_MovementFloat_Market()
    WHERE tmpText.Ord = 5
    
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_ReturnIn.ValueData) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_ReturnIn
                                 ON MovementFloat_ReturnIn.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_ReturnIn.DescId = zc_MovementFloat_ReturnIn()
    WHERE tmpText.Ord = 6
     
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_Logist.ValueData) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_Logist
                                 ON MovementFloat_Logist.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Logist.DescId = zc_MovementFloat_Logist()
    WHERE tmpText.Ord = 7
    
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_Report.ValueData) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_Report
                                 ON MovementFloat_Report.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Report.DescId = zc_MovementFloat_Report()
    WHERE tmpText.Ord = 8     

 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_Report.ValueData) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_Report
                                 ON MovementFloat_Report.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Report.DescId = zc_MovementFloat_MarketSumm()
    WHERE tmpText.Ord = 9
        
ORDER by 1  
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.09.24         *
*/

-- SELECT * FROM gpSelect_Movement_PromoTradeCondition (inMovementId:= 29197668 , inSession:= zfCalc_UserAdmin())