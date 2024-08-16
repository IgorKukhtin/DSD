-- Function: gpReport_Check_Sale_TotalSum ()

DROP FUNCTION IF EXISTS gpReport_Check_Sale_TotalSum (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_Sale_TotalSum (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, OperDatePartner TDateTime, InvNumber TVarChar
             , PaidKindName TVarChar
             , FromCode  Integer
             , FromName  TVarChar
             , ToCode    Integer
             , ToName    TVarChar
             , isPriceWithVAT Boolean
             , VATPercent     TFloat
             , ChangePercent  TFloat
             , TotalSummMVAT   TFloat
             , TotalSummPVAT   TFloat
             , TotalSumm       TFloat
             , Summ_MVat_calc1  TFloat
             , Summ_PVat_calc1  TFloat
             , Summ_calc1       TFloat
             , Summ_MVat_calc2  TFloat
             , Summ_PVat_calc2  TFloat
             , Summ_calc2       TFloat
             , isMVat_diff     Boolean
             , isPVat_diff     Boolean
             , isSum_diff      Boolean
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
      WITH 
         tmpMov AS (-- zc_Movement_Sale
                    SELECT Movement.Id                   AS Id
                         , Movement.OperDate             AS OperDate
                         , Movement.InvNumber            AS InvNumber
                         , MD_OperDatePartner.ValueData  AS OperDatePartner 
                         , MovementLinkObject_PaidKind.ObjectId AS PaidKindId
                    FROM MovementDate AS MD_OperDatePartner
                         INNER JOIN Movement ON Movement.Id = MD_OperDatePartner.MovementId
                                            AND Movement.DescId   = zc_Movement_Sale()
                                            AND Movement.StatusId = zc_Enum_Status_Complete()

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                      ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                     AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                    WHERE MD_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                      AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                   )
   
       , tmpMovementFloat AS (SELECT MovementFloat.*
                              FROM MovementFloat
                              WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                AND MovementFloat.DescId IN (zc_MovementFloat_TotalSummMVAT()
                                                           , zc_MovementFloat_TotalSummPVAT()
                                                           , zc_MovementFloat_TotalSumm() 
                                                           , zc_MovementFloat_VATPercent()
                                                           , zc_MovementFloat_ChangePercent()
                                                            )
                             )

       , tmpMovementBoolean AS (SELECT MovementBoolean.*
                                FROM MovementBoolean
                                WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                  AND MovementBoolean.DescId = zc_MovementBoolean_PriceWithVAT()
                                )

        , tmpMLO AS (SELECT MovementLinkObject.*
                                         FROM MovementLinkObject
                                         WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                           AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
                                         )


     -- + все свойства Документа
       , tmpMovement AS (SELECT tmpMov.Id   AS MovementId
                              , tmpMov.OperDate 
                              , tmpMov.OperDatePartner
                              , tmpMov.InvNumber 
                              , tmpMov.PaidKindId
                              , MB_PriceWithVAT.ValueData             AS isPriceWithVAT
                              , COALESCE (MF_VATPercent.ValueData,0)  AS VATPercent
                              , MovementFloat_ChangePercent.ValueData AS ChangePercent
                        FROM tmpMov
                           LEFT JOIN tmpMovementBoolean AS MB_PriceWithVAT
                                                        ON MB_PriceWithVAT.MovementId = tmpMov.Id
                                                       AND MB_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                          LEFT JOIN tmpMovementFloat AS MF_VATPercent
                                                     ON MF_VATPercent.MovementId = tmpMov.Id
                                                    AND MF_VATPercent.DescId = zc_MovementFloat_VATPercent()
      
                          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                  ON MovementFloat_ChangePercent.MovementId = tmpMov.Id
                                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                        )

        --группировка - MovementItem.ObjectId + MILinkObject_GoodsKind.ObjectId 
      , tmpTotal1 AS (SELECT tmpMov.Id, tmp.*
                      FROM tmpMov
                         LEFT JOIN lpSelect_MovementFloat_TotalSumm1_Sale (tmpMov.Id) AS tmp ON 1=1
                      )
        --группировка - COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId) +  COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId)
      , tmpTotal2 AS (SELECT tmpMov.Id, tmp.*
                      FROM tmpMov
                         LEFT JOIN lpSelect_MovementFloat_TotalSumm_Sale (tmpMov.Id) AS tmp ON 1=1
                     )

             SELECT tmpData.MovementId
                  , tmpData.OperDate
                  , tmpData.OperDatePartner
                  , tmpData.InvNumber 
                  , Object_PaidKind.ValueData AS PaidKindName
                                         
                  , Object_From.ObjectCode AS FromCode
                  , Object_From.ValueData  AS FromName
                  , Object_To.ObjectCode   AS ToCode
                  , Object_To.ValueData    AS ToName
                   
                  , tmpData.isPriceWithVAT ::Boolean
                  , tmpData.VATPercent     ::TFloat
                  , tmpData.ChangePercent  ::TFloat
                 
                  , MovementFloat_TotalSummMVAT.ValueData   ::TFloat  AS TotalSummMVAT
                  , MovementFloat_TotalSummPVAT.ValueData   ::TFloat  AS TotalSummPVAT
                  , MovementFloat_TotalSumm.ValueData       ::TFloat  AS TotalSumm

                 /* , tmpData.AmountSummNoVAT ::TFloat AS AmountSummMVAT
                  , tmpData.AmountSummWVAT  ::TFloat AS AmountSummPVAT
                  , tmpData.AmountSumm      ::TFloat AS AmountSumm
                   */
                  , tmpTotal1.TotalSummMVAT ::TFloat AS Summ_MVat_calc1
                  , tmpTotal1.TotalSummPVAT ::TFloat AS Summ_PVat_calc1
                  , tmpTotal1.TotalSumm     ::TFloat AS Summ_calc1

                  , tmpTotal2.TotalSummMVAT ::TFloat AS Summ_MVat_calc2
                  , tmpTotal2.TotalSummPVAT ::TFloat AS Summ_PVat_calc2
                  , tmpTotal2.TotalSumm     ::TFloat AS Summ_calc2
        
                  , CASE WHEN MovementFloat_TotalSummMVAT.ValueData <> tmpTotal1.TotalSummMVAT OR MovementFloat_TotalSummMVAT.ValueData <> tmpTotal2.TotalSummMVAT THEN TRUE ELSE FALSE END AS isMVat_diff
                  , CASE WHEN MovementFloat_TotalSummPVAT.ValueData <> tmpTotal1.TotalSummPVAT OR MovementFloat_TotalSummPVAT.ValueData <> tmpTotal2.TotalSummPVAT THEN TRUE ELSE FALSE END  AS isPVat_diff
                  , CASE WHEN MovementFloat_TotalSumm.ValueData <> tmpTotal1.TotalSumm OR MovementFloat_TotalSumm.ValueData <> tmpTotal2.TotalSumm THEN TRUE ELSE FALSE END                  AS isSum_diff

              FROM tmpMovement AS tmpData

               LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId

               LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                          ON MovementFloat_TotalSummMVAT.MovementId = tmpData.MovementId
                                         AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
               LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                          ON MovementFloat_TotalSummPVAT.MovementId = tmpData.MovementId
                                         AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
               LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                          ON MovementFloat_TotalSumm.MovementId = tmpData.MovementId
                                         AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm() 

               -- расчет как lpInsertUpdate_MovementFloat_TotalSumm
               LEFT JOIN tmpTotal1 ON tmpTotal1.Id = tmpData.MovementId  
               LEFT JOIN tmpTotal2 ON tmpTotal2.Id = tmpData.MovementId
               
               LEFT JOIN tmpMLO AS MovementLinkObject_From
                                ON MovementLinkObject_From.MovementId = tmpData.MovementId
                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
               LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

               LEFT JOIN tmpMLO AS MovementLinkObject_To
                                ON MovementLinkObject_To.MovementId = tmpData.MovementId
                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
               LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
       ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.24         *
*/

-- тест
--
/* SELECT * FROM gpReport_Check_Sale_TotalSum (inStartDate:= '17.07.2024', inEndDate:= '18.07.2024', inSession:= zfCalc_UserAdmin())
 WHERE MovementId IN (28747885, 28765855, 28740796 , 28742362) ; 
 */
SELECT * FROM gpReport_Check_Sale_TotalSum (inStartDate:= '17.07.2024', inEndDate:= '18.07.2024', inSession:= zfCalc_UserAdmin())