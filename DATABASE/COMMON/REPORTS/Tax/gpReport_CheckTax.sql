-- FunctiON: gpReport_CheckTax ()

DROP FUNCTION IF EXISTS gpReport_CheckTax (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTax (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    
    IN inSessiON      TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE ( InvNumber_Sale TVarChar, InvNumber_Tax TVarChar, OperDate_Sale TDateTime, OperDate_Tax TDateTime
              , FromCode Integer, FromName TVarChar
              , ToCode Integer, TOName TVarChar              
              , PaidKindName TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
              , Price_Sale TFloat, Price_Tax TFloat
              , Amount_Sale TFloat, AmountSumm_Sale TFloat
              , Amount_Tax TFloat, AmountSumm_Tax TFloat
              , Difference TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY
  
    SELECT CAST (tmpGroupMovement.InvNumber_Sale AS TVarChar) 
         , CAST (tmpGroupMovement.InvNumber_Tax AS TVarChar)
         , CAST (tmpGroupMovement.OperDate_Sale AS TDateTime)
         , CAST (tmpGroupMovement.OperDate_Tax AS TDateTime)
         , Object_From.ObjectCode    AS FromCode
         , Object_From.ValueData     AS FromName
         , Object_To.ObjectCode      AS ToCode
         , Object_To.ValueData       AS TOName
         , Object_PaidKind.ValueData AS PaidKindName
     
         , Object_Goods.ObjectCode    AS GoodsCode
         , Object_Goods.ValueData     AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
     
         , CAST (tmpGroupMovement.Price_Sale AS TFloat)
         , CAST (tmpGroupMovement.Price_Tax AS TFloat)
     
         , CAST (tmpGroupMovement.Amount_Sale AS TFloat)
         , CAST (tmpGroupMovement.AmountSumm_Sale AS TFloat)          
         , CAST (tmpGroupMovement.Amount_Tax AS TFloat)
         , CAST (tmpGroupMovement.AmountSumm_Tax AS TFloat)
         , CAST (CASE WHEN (tmpGroupMovement.Price_Sale<>tmpGroupMovement.Price_Tax) 
                  OR (tmpGroupMovement.Amount_Sale<>tmpGroupMovement.Amount_Tax) 
                  OR (tmpGroupMovement.AmountSumm_Sale<>tmpGroupMovement.AmountSumm_Tax)
                THEN 1 ELSE 0 END AS TFloat) AS Difference 
                
         
    FROM (SELECT tmpMovement.MovementId_Sale
               , tmpMovement.MovementId_Tax
               , MAX (tmpMovement.OperDate_Sale)  AS OperDate_Sale
               , MAX (tmpMovement.OperDate_Tax)   AS OperDate_Tax
               , MAX (tmpMovement.InvNumber_Sale) AS InvNumber_Sale
               , MAX (tmpMovement.InvNumber_Tax)  AS InvNumber_Tax
               , tmpMovement.GoodsId
               , tmpMovement.GoodsKindId
               , MAX (tmpMovement.Price_Sale)     AS Price_Sale
               , SUM (tmpMovement.Amount_Sale)    AS Amount_Sale
               , SUM(tmpMovement.AmountSumm_Sale) AS AmountSumm_Sale
               , MAX (tmpMovement.Price_Tax)      AS Price_Tax
               , SUM (tmpMovement.Amount_Tax)     AS Amount_Tax
               , SUM (tmpMovement.AmountSumm_Tax) AS AmountSumm_Tax
      
          FROM (SELECT Movement.Id AS MovementId_Sale
                     , MovementLinkMovement.MovementChildId AS MovementId_Tax
                     , Movement.OperDate AS OperDate_Sale
                     , zc_DateStart() AS OperDate_Tax

                     , Movement.InvNumber AS InvNumber_Sale
                     , '' AS InvNumber_Tax

                     , MovementItem.ObjectId AS GoodsId
                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId 
                     , MIFloat_Price.ValueData AS Price_Sale
                     , MovementItem.Amount AS Amount_Sale
                     , MIFloat_Price.ValueData * MovementItem.Amount AS AmountSumm_Sale
                     , 0 AS Price_Tax
                     , 0 AS Amount_Tax
                     , 0 AS AmountSumm_Tax
                FROM Movement 
                     join MovementItem ON MovementItem.MovementId = Movement.Id
                    join MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                             AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Child()
                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                            
                WHERE Movement.DescId = zc_Movement_Sale()
                  AND Movement.OperDate between inStartDate AND inEndDate
             UNION
                SELECT MovementLinkMovement.MovementId AS MovementId_Sale
                     , Movement.Id  AS MovementId_Tax
                     , zc_DateStart() AS OperDate_Sale
                     , Movement.OperDate AS OperDate_Tax
                     , '' AS InvNumber_Sale
                     , Movement.InvNumber AS InvNumber_Tax
                     , MovementItem.ObjectId AS GoodsId
                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                     , 0 AS Price_Sale
                     , 0 AS Amount_Sale
                     , 0 AS AmountSumm_Sale
                     , MIFloat_Price.ValueData AS Price_Tax
                     , MovementItem.Amount AS Amount_Tax
                     , MIFloat_Price.ValueData * MovementItem.Amount AS AmountSumm_Tax
                FROM Movement 
                     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                     LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementChildId  = Movement.Id
                                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Child()
                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                WHERE Movement.DescId = zc_Movement_Tax()
                  AND Movement.OperDate between inStartDate AND inEndDate

                ) AS tmpMovement
               GROUP BY tmpMovement.MovementId_Sale
                      , tmpMovement.MovementId_Tax
                      , tmpMovement.GoodsId
                      , tmpMovement.GoodsKindId
             ) AS tmpGroupMovement

         JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGroupMovement.GoodsId
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGroupMovement.GoodsKindId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = tmpGroupMovement.MovementId_Sale
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                  ON MovementLinkObject_To.MovementId = tmpGroupMovement.MovementId_Sale
                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                      ON MovementLinkObject_PaidKind.MovementId = tmpGroupMovement.MovementId_Sale
                                     AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

         ORDER BY 1,3,2,4,11
 ;
            
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckTax (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 14.02.14         *  
                
*/

-- òåñò
--SELECT * FROM gpReport_CheckTax (inStartDate:= '15.12.2013', inEndDate:= '1.1.2014', inSessiON:= zfCalc_UserAdmin());
