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
             , AmountSummMVAT TFloat
             , AmountSummPVAT  TFloat
             , AmountSumm      TFloat
             , Summ_MVat_calc  TFloat
             , Summ_PVat_calc  TFloat
             , Summ_calc       TFloat
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
   
       , tmpMI AS (SELECT MovementItem.*
                   FROM MovementItem
                   WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.isErased   = FALSE
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


       , tmpMIFloat AS (SELECT MovementItemFloat.*
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                         , zc_MIFloat_AmountPartner()
                                                         , zc_MIFloat_ChangePercent() 
                                                         , zc_MIFloat_CountForPrice()
                                                          )
                       )

     -- + все свойства Документа
       , tmpMovement AS (SELECT tmpMov.Id
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

       , tmpMI_calc AS (
                        SELECT tmpMovement.Id AS MovementId
                             , tmpMovement.OperDate
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDatePartner
                             , tmpMovement.PaidKindId
                             , tmpMovement.isPriceWithVAT
                             , tmpMovement.VATPercent
                             , tmpMovement.ChangePercent
                            
                             , tmpMI.Id       AS MovementItemId 
                             
                             , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND tmpMovement.PaidKindId =  zc_Enum_PaidKind_FirstForm() -- !!!для НАЛ не учитываем!!!
                                    THEN zfCalc_PriceTruncate (inOperDate     := tmpMovement.OperDatePartner
                                                             , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                             , inPrice        := MIFloat_Price.ValueData
                                                             , inIsWithVAT    := COALESCE (tmpMovement.isPriceWithVAT, FALSE)
                                                              )
                                     ELSE COALESCE (MIFloat_Price.ValueData, 0)
                               END AS Price
                        FROM tmpMovement
                           INNER JOIN tmpMI ON tmpMI.MovementId = tmpMovement.Id

                           LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                                ON MIFloat_ChangePercent.MovementItemId = tmpMI.Id
                                               AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
 
                           LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = tmpMI.Id
                                               AND MIFloat_Price.DescId         = zc_MIFloat_Price()
  
                        ) 

       , tmpData AS (SELECT tmp.MovementId
                          , tmp.OperDate
                          , tmp.OperDatePartner
                          , tmp.InvNumber 
                          , tmp.PaidKindId
                          , tmp.isPriceWithVAT
                          , tmp.VATPercent
                          , tmp.ChangePercent
                          , CAST (SUM (tmp.AmountSummNoVAT)AS NUMERIC (16, 2))  AS AmountSummNoVAT
                          , CAST (SUM ((tmp.AmountSummNoVAT + COALESCE (tmp.OperSumm_VAT,0))) AS NUMERIC (16, 2))  AS AmountSummWVAT
                          , CAST (SUM (tmp.AmountSumm)     AS NUMERIC (16, 2))  AS AmountSumm 
                          , CAST (SUM (tmp.OperSumm_VAT)   AS NUMERIC (16, 2))  AS OperSumm_VAT
                     FROM (SELECT tmpMI.MovementId
                                , tmpMI.OperDate
                                , tmpMI.OperDatePartner
                                , tmpMI.InvNumber 
                                , tmpMI.PaidKindId
                                , tmpMI.isPriceWithVAT
                                , tmpMI.VATPercent
                                , tmpMI.ChangePercent
                                , tmpMI.MovementItemId
                                  -- расчет суммы без НДС, до 2 знаков
                                , SUM ( (COALESCE (MIFloat_AmountPartner.ValueData,0) * CASE WHEN tmpMI.isPriceWithVAT = TRUE
                                                                   THEN CAST (tmpMI.Price * (1 - (tmpMI.VATPercent / (tmpMI.VATPercent + 100) ) )AS NUMERIC(16, 2) )
                                                                   ELSE tmpMI.Price
                                                              END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                        )) AS AmountSummNoVAT   --SUMM_MVat
                     
                                  -- расчет суммы с НДС, до 2 знаков
                                , SUM ( (COALESCE (MIFloat_AmountPartner.ValueData,0) * CASE WHEN tmpMI.isPriceWithVAT <> TRUE
                                                                   THEN CAST (tmpMI.Price * (1 + (tmpMI.VATPercent / 100)) AS NUMERIC(16, 2) )
                                                                   ELSE tmpMI.Price
                                                              END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                       )) AS AmountSummWVAT    --SUMM_PVat
      
                                  -- расчет суммы с НДС и скидкой, до 2 знаков
                                ,  CAST (
                                        SUM ( (1 + (COALESCE (tmpMI.ChangePercent,0) / 100))  * 
                                        (COALESCE (MIFloat_AmountPartner.ValueData,0) * CASE WHEN tmpMI.isPriceWithVAT <> TRUE
                                                                   THEN CAST (tmpMI.Price * (1 + (tmpMI.VATPercent / 100)) AS NUMERIC(16, 2) )
                                                                   ELSE tmpMI.Price
                                                              END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                                         ) )
                                         AS NUMERIC (16, 2)) AS AmountSumm

                                , CAST (
                                        SUM (CASE WHEN tmpMI.isPriceWithVAT = TRUE OR tmpMI.VATPercent = 0
                                                       -- если цены с НДС
                                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                                  CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                                                            THEN CAST (COALESCE (MIFloat_AmountPartner.ValueData,0) * tmpMI.Price / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                                                       ELSE CAST (COALESCE (MIFloat_AmountPartner.ValueData,0) * tmpMI.Price AS NUMERIC (16, 2))
                                                                  END
                                                                * tmpMI.VATPercent / (100 + tmpMI.VATPercent)
                                                                  AS NUMERIC (16, 6))
                                                  WHEN tmpMI.VATPercent > 0
                                                       -- если цены без НДС
                                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                                  CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                                                            THEN CAST (COALESCE (MIFloat_AmountPartner.ValueData,0) * tmpMI.Price / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                                                       ELSE CAST (COALESCE (MIFloat_AmountPartner.ValueData,0) * tmpMI.Price AS NUMERIC (16, 2))
                                                                  END
                                                                * tmpMI.VATPercent / 100
                                                                  AS NUMERIC (16, 6))
                                             END)
                                        AS NUMERIC (16, 2)) AS OperSumm_VAT
                           FROM tmpMI_calc AS tmpMI
                              LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                                   ON MIFloat_AmountPartner.MovementItemId = tmpMI.MovementItemId
                                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                    
                              LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = tmpMI.MovementItemId
                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                           GROUP BY tmpMI.MovementId
                                  , tmpMI.OperDate
                                  , tmpMI.OperDatePartner
                                  , tmpMI.InvNumber 
                                  , tmpMI.PaidKindId
                                  , tmpMI.isPriceWithVAT
                                  , tmpMI.VATPercent
                                  , tmpMI.ChangePercent  
                                  , tmpMI.MovementItemId
                           ) AS tmp 
                     GROUP BY tmp.MovementId
                            , tmp.OperDate
                            , tmp.OperDatePartner
                            , tmp.InvNumber 
                            , tmp.PaidKindId
                            , tmp.isPriceWithVAT
                            , tmp.VATPercent
                            , tmp.ChangePercent
             )

      , tmpTotal AS (SELECT tmpMov.Id, tmp.*
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

                  , tmpData.AmountSummNoVAT ::TFloat AS AmountSummMVAT
                  , tmpData.AmountSummWVAT  ::TFloat AS AmountSummPVAT
                  , tmpData.AmountSumm      ::TFloat AS AmountSumm
                  
                  , tmpTotal.TotalSummMVAT ::TFloat AS Summ_MVat_calc
                  , tmpTotal.TotalSummPVAT ::TFloat AS Summ_PVat_calc
                  , tmpTotal.TotalSumm     ::TFloat AS Summ_calc
        
                  , CASE WHEN MovementFloat_TotalSummMVAT.ValueData <> tmpData.AmountSummNoVAT OR MovementFloat_TotalSummMVAT.ValueData <> tmpTotal.TotalSummMVAT THEN TRUE ELSE FALSE END AS isMVat_diff
                  , CASE WHEN MovementFloat_TotalSummPVAT.ValueData <> tmpData.AmountSummWVAT OR MovementFloat_TotalSummPVAT.ValueData <> tmpTotal.TotalSummPVAT THEN TRUE ELSE FALSE END  AS isPVat_diff
                  , CASE WHEN MovementFloat_TotalSumm.ValueData <> tmpData.AmountSumm OR MovementFloat_TotalSumm.ValueData <> tmpTotal.TotalSumm THEN TRUE ELSE FALSE END                  AS isSum_diff

              FROM tmpData

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
               LEFT JOIN tmpTotal ON tmpTotal.Id = tmpData.MovementId  
               
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