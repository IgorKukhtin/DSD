































-- FunctiON: gpReport_CheckTaxCorrective ()

DROP FUNCTION IF EXISTS gpReport_CheckTaxCorrective (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTaxCorrective (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    
    IN inSessiON      TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE ( InvNumber_ReturnIn TVarChar, InvNumber_TaxCorrective TVarChar, OperDate_ReturnIn TDateTime, OperDate_TaxCorrective TDateTime
              , FromCode Integer, FromName TVarChar
              , ToCode Integer, TOName TVarChar              
              --, PaidKindName TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
              , Price_ReturnIn TFloat, Price_TaxCorrective TFloat
              , Amount_ReturnIn TFloat
              , Amount_TaxCorrective TFloat
              , Difference Boolean
              , DocumentTaxKindName TVarChar
              )  
AS
$BODY$
BEGIN

    RETURN QUERY

    SELECT CAST (tmpGroupMovement.InvNumber_ReturnIn AS TVarChar) 
         , CAST (tmpGroupMovement.InvNumber_TaxCorrective AS TVarChar) 
         , CAST (tmpGroupMovement.OperDate_ReturnIn AS TDateTime)
         , CAST (tmpGroupMovement.OperDate_TaxCorrective AS TDateTime)
         , tmpGroupMovement.FromCode
         , tmpGroupMovement.FromName
         , tmpGroupMovement.ToCode
         , tmpGroupMovement.ToName
         
         --, Object_PaidKind.ValueData AS PaidKindName
     
         , Object_Goods.ObjectCode    AS GoodsCode
         , Object_Goods.ValueData     AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
     
         , CAST (tmpGroupMovement.Price_ReturnIn AS TFloat)
         , CAST (tmpGroupMovement.Price_TaxCorrective AS TFloat)
     
         , CAST (tmpGroupMovement.Amount_ReturnIn AS TFloat)
      
         , CAST (tmpGroupMovement.Amount_TaxCorrective AS TFloat)
        
         , CAST (CASE WHEN (tmpGroupMovement.Price_ReturnIn<>tmpGroupMovement.Price_TaxCorrective) 
                        OR (tmpGroupMovement.Amount_ReturnIn<>tmpGroupMovement.Amount_TaxCorrective) 
                      THEN TRUE 
                      ELSE FALSE END AS Boolean) AS Difference 
         , Object_DocumentTaxKind.ValueData AS DocumentTaxKindName
    FROM (
          SELECT tmpMovement.FromCode
               , tmpMovement.FromName
               , tmpMovement.ToCode
               , tmpMovement.ToName
               , tmpMovement.MovementId_ReturnIn
                 , COALESCE (MAX (tmpMovement.InvNumber_ReturnIn),'') AS InvNumber_ReturnIn
                 , MAX (tmpMovement.InvNumber_TaxCorrective) AS InvNumber_TaxCorrective
                 , MAX (tmpMovement.OperDate_TaxCorrective) AS OperDate_TaxCorrective
                 , tmpMovement.GoodsId
                 , tmpMovement.GoodsKindId   
                 , MAX (tmpMovement.OperDate_ReturnIn) AS OperDate_ReturnIn
                 , MAX (tmpMovement.Price_TaxCorrective) AS Price_TaxCorrective
                 , MAX (tmpMovement.Price_ReturnIn) AS Price_ReturnIn
                 , SUM (tmpMovement.Amount_TaxCorrective)     AS Amount_TaxCorrective
                 , SUM (tmpMovement.Amount_ReturnIn)     AS Amount_ReturnIn
                 , tmpMovement.DocumentTaxKindId
          FROM (SELECT Object_Juridical_From.ObjectCode   AS FromCode
                     , Object_Juridical_From.ValueData    AS FromName
                     , Object_JuridicalBasis.ObjectCode   AS ToCode
                     , Object_JuridicalBasis.ValueData    AS ToName

                     , MovementLinkMovement.MovementId AS MovementId_TaxCorrective
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80775 THEN Movement.Id ELSE 0 END AS MovementId_ReturnIn
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80775 THEN Movement.OperDate ELSE zc_DateStart() END AS OperDate_ReturnIn
                     , zc_DateStart() AS OperDate_TaxCorrective
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80775 THEN Movement.InvNumber ELSE '' END AS InvNumber_ReturnIn
                     , '' AS InvNumber_TaxCorrective
                     , MovementItem.ObjectId AS GoodsId
                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId 
                     , MIFloat_Price.ValueData AS Price_ReturnIn
                     , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS Amount_ReturnIn
                     , 0 AS Price_TaxCorrective
                     , 0 AS Amount_TaxCorrective
                     , MovementLO_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                FROM Movement 
                     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                     JOIN MovementLinkMovement ON MovementLinkMovement.MovementChildId = Movement.Id
                                             AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                                     
                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                     
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()         

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                     LEFT JOIN Object AS Object_Juridical_From ON Object_Juridical_From.Id = ObjectLink_Partner_Juridical.ChildObjectId


                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                     LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = ObjectLink_Contract_JuridicalBasis.ChildObjectId
                     
                     
                                                                              
                WHERE Movement.DescId = zc_Movement_ReturnIn()
                  AND Movement.OperDate between inStartDate AND inEndDate
             UNION
                SELECT Object_Juridical.ObjectCode           AS FromCode
                     , Object_Juridical.ValueData            AS FromName
                     , Object_Contract_Juridical.ObjectCode  AS ToCode
                     , Object_Contract_Juridical.ValueData   AS ToName
                     
                     , Movement.Id AS MovementId_TaxCorrective
                     , MovementLinkMovement.MovementChildId AS MovementId_ReturnIn
                     , Movement_ReturnIn.OperDate AS OperDate_ReturnIn
                     , Movement.OperDate AS OperDate_TaxCorrective
                     , Movement_ReturnIn.InvNumber AS InvNumber_ReturnIn
                     , Movement.InvNumber AS InvNumber_TaxCorrective
                     , MovementItem.ObjectId AS GoodsId
                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                     , 0 AS Price_ReturnIn
                     , 0 AS Amount_ReturnIn
                     , MIFloat_Price.ValueData AS Price_TaxCorrective
                     , MovementItem.Amount AS Amount_TaxCorrective

                     , MovementLO_DocumentTaxKind.ObjectId AS DocumentTaxKindId

                FROM Movement 
                     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                     LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId  = Movement.Id
                                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = MovementLinkMovement.MovementChildId

                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id =  MovementLinkObject_From.ObjectId

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN Object AS Object_Contract_Juridical ON Object_Contract_Juridical.Id =  MovementLinkObject_To.ObjectId 

                WHERE Movement.DescId = zc_Movement_TaxCorrective()
                  AND Movement.OperDate between inStartDate AND inEndDate
          ) AS tmpMovement 
          GROUP BY tmpMovement.FromCode
                 , tmpMovement.FromName
                 , tmpMovement.ToCode
                 , tmpMovement.ToName
                 , tmpMovement.MovementId_ReturnIn
                 , tmpMovement.MovementId_TaxCorrective
                 , tmpMovement.OperDate_ReturnIn
                 , tmpMovement.InvNumber_ReturnIn
                 , tmpMovement.GoodsId
                 , tmpMovement.GoodsKindId  
                 , tmpMovement.DocumentTaxKindId 
       ) AS tmpGroupMovement
       
         JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGroupMovement.GoodsId
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGroupMovement.GoodsKindId

         LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = tmpGroupMovement.DocumentTaxKindId


;
            
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckTaxCorrective (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.

  18.02.14         *  
                
*/

-- òåñò
--SELECT * FROM gpReport_CheckTaxCorrective (inStartDate:= '15.12.2013', inEndDate:= '1.1.2014', inSession:= zfCalc_UserAdmin());


--select * from MovementLinkMovement