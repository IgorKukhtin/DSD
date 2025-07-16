-- Function: gpSelect_MI_PromoTradeOkupaemost_Print()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoTradeOkupaemost_Print (Integer, TFloat, Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoTradeOkupaemost_Print(
    IN inMovementId       Integer,       -- ключ Документа 
    IN inPersentOnCredit  TFloat,        -- % по кредиту, год
    IN inNum1             Integer,       -- № строк печати колонка 1
    IN inNum2             Integer,       -- № строк печати колонка 2
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (TextInfo        TVarChar
             , RetailName      TVarChar   -- торговая сеть      
             , PriceListName   TVarChar   --
             , ChangePercent         TFloat
             , Persent_Condition     TFloat 
             , Summ_pos_1          TFloat     --Стоимость ввода позиции, грн 
             , Summ_pos_2          TFloat     --Стоимость ввода позиции, грн 
             , Summ_one            TFloat
             , PartnerCount          TFloat
             , SummPromo_1         TFloat     --Ожидаемый среднемесячный объем продаж, грн
             , SummPromo_2         TFloat     --Ожидаемый среднемесячный объем продаж, грн 
             , Due_Pass_year1      TFloat     --Ожидаемый проход1 в год, грн
             , Due_Pass_year2      TFloat     --Ожидаемый проход2 в год, грн
             , TotalCost_1         TFloat     --Итого затрат, ГОД
             , TotalCost_2         TFloat     --Итого затрат, ГОД
             , Profit1           TFloat     --Прибыль1, грн год
             , Profit2           TFloat     --Прибыль2, грн год
             , PaybackPeriod1    TFloat     --Период окупаемости1, мес.
             , PaybackPeriod2    TFloat     --Период окупаемости2, мес.
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH 
    --расчетные данные
    tmpData AS (SELECT *
                FROM gpSelect_MI_PromoTradeOkupaemost(inMovementId, inPersentOnCredit, inSession) AS tmp
                WHERE tmp.Num IN (inNum1, inNum2)
                )
    --Далее группироуем для печати
    SELECT CASE WHEN inNum1 = 1 THEN 'Текущие коммерческие условия' ELSE 'Новые коммерческие условия' END ::TVarChar AS TextInfo
         , tmpData.RetailName
         , tmpData.PriceListName
         , CASE WHEN tmpData.Num IN (1,2) THEN tmpData.ChangePercent ELSE tmpData.ChangePercent_new END          ::TFloat AS ChangePercent
         , MAX (CASE WHEN tmpData.Num IN (1,2) THEN tmpData.Persent_Condition ELSE tmpData.Persent_Condition_new END)  ::TFloat AS Persent_Condition    --Комм. условия:
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.Summ_pos ELSE 0 END)       ::TFloat AS Summ_pos_1
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.Summ_pos ELSE 0 END)       ::TFloat AS Summ_pos_2
         , CASE WHEN SUM (COALESCE (tmpData.PartnerCount,0)) <> 0 THEN  SUM (tmpData.Summ) / SUM (tmpData.PartnerCount) ELSE 0 END ::TFloat AS Summ_one             --Стоимость ввода 1 SKU в 1ТТ:
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN COALESCE (tmpData.PartnerCount,0) ELSE 0 END )                                 ::TFloat AS PartnerCount                                                                                                                   --кол-во ТТ
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.SummPromo * 12 ELSE 0 END) ::TFloat AS SummPromo_1                                    --ИТОГО "Ожидаемый среднемесячный объем продаж, грн" вкладка "Окупаемость" * 12
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.SummPromo * 12 ELSE 0 END) ::TFloat AS SummPromo_2
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.Due_Pass_year1 ELSE 0 END) ::TFloat AS Due_Pass_year1                                 --ИТОГО "Ожидаемый проход1 в год, грн" вкладка "Окупаемость"
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.Due_Pass_year2 ELSE 0 END) ::TFloat AS Due_Pass_year2
       
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.TotalCost ELSE 0 END)      ::TFloat AS TotalCost_1                                    --Итого затрат, ГОД
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.TotalCost ELSE 0 END)      ::TFloat AS TotalCost_2
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.Profit1 ELSE 0 END)        ::TFloat AS Profit1                                        --Прибыль, грн год
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.Profit2 ELSE 0 END)        ::TFloat AS Profit2
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.PaybackPeriod1 ELSE 0 END) ::TFloat AS PaybackPeriod1                                 --Плановая окупаемость по сети, мес
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.PaybackPeriod2 ELSE 0 END) ::TFloat AS PaybackPeriod2
    FROM tmpData
    GROUP BY tmpData.RetailName
        , tmpData.PriceListName
        , CASE WHEN tmpData.Num IN (1,2) THEN tmpData.ChangePercent ELSE tmpData.ChangePercent_new END
        --, CASE WHEN tmpData.Num IN (1,2) THEN tmpData.Persent_Condition ELSE tmpData.Persent_Condition_new END
        --, CASE WHEN COALESCE (tmpData.PartnerCount,0) <> 0 THEN  tmpData.Summ / tmpData.PartnerCount ELSE 0 END
        --, tmpData.PartnerCount  
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.07.25         *
*/
-- тест
-- select * from gpSelect_MI_PromoTradeOkupaemost_Print(inMovementId := 31603021, inPersentOnCredit:=18.5, inNum1:=1, inNum2:=2, inSession := '9457');
--            select * from gpSelect_MI_PromoTradeOkupaemost_Print(inMovementId := 31603021 , inPersentOnCredit := 18.5 , inNum1 := 1 , inNum2 := 2 ,  inSession := '9457');--