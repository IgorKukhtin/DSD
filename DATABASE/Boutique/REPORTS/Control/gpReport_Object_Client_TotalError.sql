-- Function: gpReport_Object_Client_TotalError()

DROP FUNCTION IF EXISTS gpReport_Object_Client_TotalError (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Object_Client_TotalError(
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (ClientId          Integer
             , ClientCode        Integer
             , ClientName        TVarChar
 
             , TotalCount        TFloat
             , TotalSumm         TFloat
             , TotalSummDiscount TFloat
             , TotalSummPay      TFloat
             
             , TotalCount_Calc   TFloat
             , TotalSumm_Calc    TFloat
             , TotalSummDiscount_Calc TFloat
             , TotalSummPay_Calc TFloat
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_GoodsAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpObject AS (SELECT Object_Client.Id                        AS Id
                             , Object_Client.ObjectCode                AS Code
                             , Object_Client.ValueData                 AS Name
                             , ObjectFloat_TotalCount.ValueData        AS TotalCount
                             , ObjectFloat_TotalSumm.ValueData         AS TotalSumm
                             , ObjectFloat_TotalSummDiscount.ValueData AS TotalSummDiscount
                             , ObjectFloat_TotalSummPay.ValueData      AS TotalSummPay
                        FROM Object AS Object_Client
                              LEFT JOIN ObjectFloat AS ObjectFloat_TotalCount 
                                                    ON ObjectFloat_TotalCount.ObjectId = Object_Client.Id
                                                   AND ObjectFloat_TotalCount.DescId = zc_ObjectFloat_Client_TotalCount()
                  
                              LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm 
                                                    ON ObjectFloat_TotalSumm.ObjectId = Object_Client.Id
                                                   AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_Client_TotalSumm()
                  
                              LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummDiscount 
                                                    ON ObjectFloat_TotalSummDiscount.ObjectId = Object_Client.Id
                                                   AND ObjectFloat_TotalSummDiscount.DescId = zc_ObjectFloat_Client_TotalSummDiscount()
                  
                              LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummPay 
                                                    ON ObjectFloat_TotalSummPay.ObjectId = Object_Client.Id 
                                                   AND ObjectFloat_TotalSummPay.DescId = zc_ObjectFloat_Client_TotalSummPay()
                  
                        WHERE Object_Client.DescId = zc_Object_Client()
                          AND (Object_Client.isErased = FALSE)
                       )
        -- данные из документов
        , tmpMovAll AS (SELECT Movement.Id
                             , Movement.DescId
                             , CASE WHEN Object_From.DescId = zc_Object_Client() THEN MovementLinkObject_From.ObjectId
                                    WHEN Object_To.DescId   = zc_Object_Client() THEN MovementLinkObject_To.ObjectId
                               END                                                                                                          AS ClientId
                             , CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() AND Object_From.DescId = zc_Object_Client() THEN 1
                                    WHEN Movement.DescId = zc_Movement_GoodsAccount() AND Object_To.DescId   = zc_Object_Client() THEN (-1)
                                    WHEN Movement.DescId = zc_Movement_Sale()     THEN 1
                                    WHEN Movement.DescId = zc_Movement_ReturnIn() THEN (-1)
                               END                                                                                                          AS Koef
                        FROM Movement 
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                             
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                        WHERE Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_GoodsAccount())
                         --AND Movement.StatusId = zc_Enum_Status_Complete() 
                          AND  Movement.StatusId <> zc_Enum_Status_Erased()
                        )
        , tmpMov AS (SELECT Movement.ClientId
                          , SUM (COALESCE (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN 0 ELSE MovementFloat_TotalCount.ValueData END, 0)         * Movement.Koef ) AS TotalCount      -- кол-во
                          , SUM (COALESCE (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN 0 ELSE MovementFloat_TotalSummPriceList.ValueData END, 0) * Movement.Koef ) AS TotalSumm       -- Сумма
                          , SUM (COALESCE (MovementFloat_TotalSummChange.ValueData, 0)    * Movement.Koef ) AS TotalSummChange     -- Сумма скидки
                          , SUM (COALESCE (MovementFloat_TotalSummPay.ValueData, 0)       * Movement.Koef ) AS TotalSummPay        -- Сумма оплаты
                     FROM tmpMovAll AS Movement
                          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                  ON MovementFloat_TotalCount.MovementId = Movement.Id
                                                 AND MovementFloat_TotalCount.DescId     = zc_MovementFloat_TotalCount()
                                                 
                          LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                                  ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                                 AND MovementFloat_TotalSummPriceList.DescId     = zc_MovementFloat_TotalSummPriceList()
                                                 
                          LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                                  ON MovementFloat_TotalSummChange.MovementId = Movement.Id
                                                 AND MovementFloat_TotalSummChange.DescId     = zc_MovementFloat_TotalSummChange()
                                                 
                          LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                                  ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                                                 AND MovementFloat_TotalSummPay.DescId     = zc_MovementFloat_TotalSummPay()
                     GROUP BY Movement.ClientId
                     )
        , tmpData AS (SELECT tmpObject.Id                 AS ClientId
                           , tmpObject.Code               AS ClientCode
                           , tmpObject.Name               AS ClientName
                           , tmpObject.TotalCount       
                           , tmpObject.TotalSumm        
                           , tmpObject.TotalSummDiscount
                           , tmpObject.TotalSummPay  
                           
                           , tmpMov.TotalCount         AS TotalCount_Calc
                           , tmpMov.TotalSumm          AS TotalSumm_Calc
                           , tmpMov.TotalSummChange    AS TotalSummDiscount_Calc
                           , tmpMov.TotalSummPay       AS TotalSummPay_Calc
                           
                      FROM tmpObject
                           LEFT JOIN tmpMov ON tmpMov.ClientId = tmpObject.Id
                      WHERE tmpObject.TotalCount        <> tmpMov.TotalCount
                         OR tmpObject.TotalSumm         <> tmpMov.TotalSumm
                         OR tmpObject.TotalSummDiscount <> tmpMov.TotalSummChange
                         OR tmpObject.TotalSummPay      <> tmpMov.TotalSummPay
                      )
   

       SELECT tmpData.ClientId
            , tmpData.ClientCode
            , tmpData.ClientName

            , tmpData.TotalCount             :: TFloat
            , tmpData.TotalSumm              :: TFloat
            , tmpData.TotalSummDiscount      :: TFloat
            , tmpData.TotalSummPay           :: TFloat
            
            , tmpData.TotalCount_Calc        :: TFloat
            , tmpData.TotalSumm_Calc         :: TFloat
            , tmpData.TotalSummDiscount_Calc :: TFloat
            , tmpData.TotalSummPay_Calc      :: TFloat
           
       FROM tmpData
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 08.01.18         *
*/

-- тест
-- SELECT * FROM gpReport_Object_Client_TotalError (inSession:= zfCalc_UserAdmin())
