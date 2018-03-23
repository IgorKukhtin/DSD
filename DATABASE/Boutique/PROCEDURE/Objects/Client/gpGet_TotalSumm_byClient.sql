-- Function: gpGet_TotalSumm_byClient (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_TotalSumm_byClient (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_TotalSumm_byClient(
    IN inUnitId           Integer  , -- 
    IN inClientId         Integer  , -- 
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS TABLE (LastDate TDateTime, HappyDate TDateTime
             , PhoneMobile TVarChar, Phone TVarChar
             , Comment_Client TVarChar
             , TotalSumm TFloat, TotalSummPay TFloat, TotalDebt TFloat
             , DiscountTax TFloat, DiscountTaxTwo TFloat
               )
AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_GoodsAccount());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
       WITH
           -- выбираю все контейнеры по покупателю и подразделению , если выбрано 
           tmpContainer AS (SELECT CLO_PartionMI.ObjectId          AS PartionId_MI
                                 , Container.Amount
                            FROM Container
                                 INNER JOIN ContainerLinkObject AS CLO_Client 
                                                                ON CLO_Client.ContainerId = Container.Id
                                                               AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                               AND CLO_Client.ObjectId    = inClientId                            --inClientId --Перцева Наталья 6343  -- 
                                 INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                                ON CLO_Unit.ContainerId = Container.Id
                                                               AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                               AND CLO_Unit.ObjectId    = inUnitId
                                 LEFT JOIN ContainerLinkObject AS CLO_PartionMI 
                                                               ON CLO_PartionMI.ContainerId = Container.Id
                                                              AND CLO_PartionMI.DescId      = zc_ContainerLinkObject_PartionMI()
                             -- !!!кроме Покупатели + Прибыль будущих периодов!!!
                             WHERE Container.ObjectId <> zc_Enum_Account_20102() 
                               AND Container.DescId  = zc_Container_Summ()                         
                           ) 
         -- получили конечный долг и у нас все партии продажи
         , tmpPartion AS (SELECT tmpContainer.PartionId_MI
                               , sum(tmpContainer.Amount) OVER () as SummDedt
                          FROM tmpContainer
                          )                     
          -- расчет суммы продаж и оплат по партии продажи
         , tmpData AS (SELECT tmpData.SummDedt AS SummDedt
                            , SUM ((MI_PartionMI.Amount * MIFloat_OperPriceList.ValueData)
                                  - COALESCE (MIFloat_TotalReturn.ValueData, 0) 
                                  - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) 
                                  - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                  )   AS TotalSumm
                                   
                            , SUM (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)) AS TotalPay
                            , MAX (Movement_PartionMI.Operdate) AS LastDate
                       FROM (SELECT DISTINCT tmpPartion.PartionId_MI , tmpPartion.SummDedt  FROM tmpPartion) AS tmpData
                           
                           LEFT JOIN Object AS Object_PartionMI     ON Object_PartionMI.Id     = tmpData.PartionId_MI
                           LEFT JOIN MovementItem AS MI_PartionMI   ON MI_PartionMI.Id         = Object_PartionMI.ObjectCode
                           LEFT JOIN Movement AS Movement_PartionMI ON Movement_PartionMI.Id   = MI_PartionMI.MovementId 

                           LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                       ON MIFloat_OperPriceList.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()                             

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                       ON MIFloat_TotalCountReturn.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                       ON MIFloat_TotalChangePercent.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                       ON MIFloat_TotalChangePercentPay.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                       ON MIFloat_TotalPay.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                       ON MIFloat_TotalPayOth.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                       ON MIFloat_TotalPayReturn.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                       ON MIFloat_TotalReturn.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                       GROUP BY tmpData.SummDedt 
                       )

       SELECT tmpData.LastDate              :: TDateTime AS LastDate
             , ObjectDate_HappyDate.ValueData            AS HappyDate
             , ObjectString_PhoneMobile.ValueData        AS PhoneMobile
             , ObjectString_Phone.ValueData              AS Phone
             , ObjectString_Comment.ValueData            AS Comment_Client
             
             , COALESCE (tmpData.TotalSumm, 0) :: TFloat AS TotalSumm
             , COALESCE (tmpData.TotalPay, 0)  :: TFloat AS TotalSummPay
             , COALESCE (tmpData.SummDedt, 0)  :: TFloat AS TotalDebt
             , ObjectFloat_DiscountTax.ValueData         AS DiscountTax
             , ObjectFloat_DiscountTaxTwo.ValueData      AS DiscountTaxTwo

       FROM (SELECT inClientId AS Id) AS tmpClient
            
            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax 
                                  ON ObjectFloat_DiscountTax.ObjectId = tmpClient.Id 
                                 AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTaxTwo 
                                  ON ObjectFloat_DiscountTaxTwo.ObjectId = tmpClient.Id
                                 AND ObjectFloat_DiscountTaxTwo.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()

            LEFT JOIN ObjectString AS  ObjectString_Comment 
                                   ON  ObjectString_Comment.ObjectId = tmpClient.Id
                                  AND  ObjectString_Comment.DescId = zc_ObjectString_Client_Comment()

            LEFT JOIN ObjectDate AS ObjectDate_HappyDate 
                                 ON ObjectDate_HappyDate.ObjectId = tmpClient.Id 
                                AND ObjectDate_HappyDate.DescId = zc_ObjectDate_Client_HappyDate()

            LEFT JOIN ObjectString AS ObjectString_PhoneMobile 
                                   ON ObjectString_PhoneMobile.ObjectId = tmpClient.Id 
                                  AND ObjectString_PhoneMobile.DescId = zc_ObjectString_Client_PhoneMobile()

            LEFT JOIN ObjectString AS ObjectString_Phone 
                                   ON ObjectString_Phone.ObjectId = tmpClient.Id 
                                  AND ObjectString_Phone.DescId = zc_ObjectString_Client_Phone()
            LEFT JOIN tmpData ON 1 = 1
;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.18         * 
*/

-- тест
-- SELECT * FROM gpGet_TotalSumm_byClient (inUnitId:= 0, inClientId:= 1, inSession:= zfCalc_UserAdmin())
