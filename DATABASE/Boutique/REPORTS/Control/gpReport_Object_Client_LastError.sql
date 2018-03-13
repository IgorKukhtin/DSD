-- Function: gpReport_Object_Client_LastError()

DROP FUNCTION IF EXISTS gpReport_Object_Client_LastError (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Object_Client_LastError(
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (ClientId          Integer
             , ClientCode        Integer
             , ClientName        TVarChar
 
             , OperDate         TDateTime
             , InvNumber        Integer

             , LastCount        TFloat
             , LastSumm         TFloat
             , LastSummDiscount TFloat
             , LastDate         TDateTime
             
             , LastCount_Calc   TFloat
             , LastSumm_Calc    TFloat
             , LastSummDiscount_Calc TFloat
             , LastDate_Calc    TDateTime
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
                             , ObjectFloat_LastCount.ValueData         AS LastCount
                             , ObjectFloat_LastSumm.ValueData          AS LastSumm
                             , ObjectFloat_LastSummDiscount.ValueData  AS LastSummDiscount
                             , ObjectDate_LastDate.ValueData           AS LastDate

                        FROM Object AS Object_Client
                              LEFT JOIN ObjectFloat AS ObjectFloat_LastCount 
                                                    ON ObjectFloat_LastCount.ObjectId = Object_Client.Id
                                                   AND ObjectFloat_LastCount.DescId = zc_ObjectFloat_Client_LastCount()

                              LEFT JOIN ObjectFloat AS ObjectFloat_LastSumm 
                                                    ON ObjectFloat_LastSumm.ObjectId = Object_Client.Id
                                                   AND ObjectFloat_LastSumm.DescId = zc_ObjectFloat_Client_LastSumm()

                              LEFT JOIN ObjectFloat AS ObjectFloat_LastSummDiscount 
                                                    ON ObjectFloat_LastSummDiscount.ObjectId = Object_Client.Id
                                                   AND ObjectFloat_LastSummDiscount.DescId = zc_ObjectFloat_Client_LastSummDiscount()

                              LEFT JOIN ObjectDate AS ObjectDate_LastDate 
                                                   ON ObjectDate_LastDate.ObjectId = Object_Client.Id
                                                  AND ObjectDate_LastDate.DescId = zc_ObjectDate_Client_LastDate()

                        WHERE Object_Client.DescId = zc_Object_Client()
                          AND (Object_Client.isErased = FALSE)
                       )
        -- данные из документов
        , tmpMovAll AS (SELECT tmp.Id
                             , tmp.ClientId
                             , tmp.LastDate
                        FROM (SELECT Movement.Id
                                   , MovementLinkObject_To.ObjectId                    AS ClientId
                                   , COALESCE (MD_Insert.ValueData, Movement.OperDate) AS LastDate
                                   , ROW_NUMBER() OVER (PARTITION BY MovementLinkObject_To.ObjectId ORDER BY MovementLinkObject_To.ObjectId, COALESCE ( MD_Insert.ValueData, Movement.OperDate) desc, Movement.Id desc) AS Ord
                              FROM Movement
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                   LEFT JOIN MovementDate AS MD_Insert
                                                          ON MD_Insert.MovementId = Movement.Id
                                                         AND MD_Insert.DescId     = zc_MovementDate_Insert()
                              WHERE/* Movement.StatusId = zc_Enum_Status_Complete() 
                                AND */Movement.DescId = zc_Movement_Sale()
                              ) AS tmp
                        WHERE tmp.Ord = 1
                        )
        , tmpMov AS (SELECT Movement.ClientId
                          , Movement.LastDate
                          , Movement.Id                                              AS MovementId
                          , COALESCE (MovementFloat_TotalCount.ValueData, 0)         AS TotalCount          -- кол-во
                          , COALESCE (MovementFloat_TotalSummPriceList.ValueData, 0) AS TotalSumm           -- Сумма
                          , COALESCE (MovementFloat_TotalSummChange.ValueData, 0)    AS TotalSummChange     -- Сумма скидки
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
                     )
                     
        , tmpData AS (SELECT tmpObject.Id                 AS ClientId
                           , tmpObject.Code               AS ClientCode
                           , tmpObject.Name               AS ClientName
                           , tmpMov.MovementId
                           
                           , tmpObject.LastCount       
                           , tmpObject.LastSumm        
                           , tmpObject.LastSummDiscount
                           , tmpObject.LastDate  
                           
                           , tmpMov.TotalCount         AS LastCount_Calc
                           , tmpMov.TotalSumm          AS LastSumm_Calc
                           , tmpMov.TotalSummChange    AS LastSummDiscount_Calc
                           , tmpMov.LastDate           AS LastDate_Calc
                           
                      FROM tmpObject
                           LEFT JOIN tmpMov ON tmpMov.ClientId = tmpObject.Id
                      WHERE tmpObject.LastCount        <> tmpMov.TotalCount
                         OR tmpObject.LastSumm         <> tmpMov.TotalSumm
                         OR tmpObject.LastSummDiscount <> tmpMov.TotalSummChange
                         OR tmpObject.LastDate         <> tmpMov.LastDate
                      )
   

       SELECT tmpData.ClientId
            , tmpData.ClientCode
            , tmpData.ClientName

            , Movement.OperDate
            , Movement.InvNumber            :: Integer

            , tmpData.LastCount             :: TFloat
            , tmpData.LastSumm              :: TFloat
            , tmpData.LastSummDiscount      :: TFloat
            , tmpData.LastDate              :: TDateTime
            
            , tmpData.LastCount_Calc        :: TFloat
            , tmpData.LastSumm_Calc         :: TFloat
            , tmpData.LastSummDiscount_Calc :: TFloat
            , tmpData.LastDate_Calc         :: TDateTime
           
       FROM tmpData
            LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
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
-- SELECT * FROM gpReport_Object_Client_LastError (inSession:= zfCalc_UserAdmin())
