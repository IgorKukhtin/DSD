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
              --, PaidKindName TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
              , Price_Sale TFloat, Price_Tax TFloat
              , Amount_Sale TFloat--, AmountSumm_Sale TFloat
              , Amount_Tax TFloat--, AmountSumm_Tax TFloat
              , Difference Boolean
              , DocumentTaxKindName TVarChar
              )  
AS
$BODY$
BEGIN

    RETURN QUERY
  
    SELECT CAST (tmpGroupMovement.InvNumber_Sale AS TVarChar) 
         , CAST (tmpGroupMovement.InvNumber_Tax AS TVarChar)
         , CAST (tmpGroupMovement.OperDate_Sale AS TDateTime)
         , CAST (tmpGroupMovement.OperDate_Tax AS TDateTime)
         , tmpGroupMovement.FromCode
         , tmpGroupMovement.FromName
         , tmpGroupMovement.ToCode
         , tmpGroupMovement.ToName
               
        -- , Object_PaidKind.ValueData AS PaidKindName
     
         , Object_Goods.ObjectCode    AS GoodsCode
         , Object_Goods.ValueData     AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
     
         , CAST (tmpGroupMovement.Price_Sale AS TFloat)
         , CAST (tmpGroupMovement.Price_Tax AS TFloat)
     
         , CAST (tmpGroupMovement.Amount_Sale AS TFloat)
         --, CAST (tmpGroupMovement.AmountSumm_Sale AS TFloat)          
         , CAST (tmpGroupMovement.Amount_Tax AS TFloat)
         --, CAST (tmpGroupMovement.AmountSumm_Tax AS TFloat)
         , CAST (CASE WHEN (tmpGroupMovement.Price_Sale<>tmpGroupMovement.Price_Tax) 
                  OR (tmpGroupMovement.Amount_Sale<>tmpGroupMovement.Amount_Tax) 
         --         OR (tmpGroupMovement.AmountSumm_Sale<>tmpGroupMovement.AmountSumm_Tax)
                THEN TRUE ELSE FALSE END AS Boolean) AS Difference
                 
         , Object_DocumentTaxKind.ValueData AS DocumentTaxKindName       
         
    FROM (SELECT /*tmpMovement.MovementId_Sale
               , tmpMovement.MovementId_Tax
               , */tmpMovement.FromCode
               , tmpMovement.FromName
               , tmpMovement.ToCode
               , tmpMovement.ToName
               , MAX (tmpMovement.OperDate_Sale)  AS OperDate_Sale
               , MAX (tmpMovement.OperDate_Tax)   AS OperDate_Tax
               , MAX (tmpMovement.InvNumber_Sale) AS InvNumber_Sale
               , MAX (tmpMovement.InvNumber_Tax)  AS InvNumber_Tax
               , tmpMovement.GoodsId
               , tmpMovement.GoodsKindId
               , MAX (tmpMovement.Price_Sale)     AS Price_Sale
               , SUM (tmpMovement.Amount_Sale)    AS Amount_Sale
               --, SUM(tmpMovement.AmountSumm_Sale) AS AmountSumm_Sale
               , MAX (tmpMovement.Price_Tax)      AS Price_Tax
               , SUM (tmpMovement.Amount_Tax)     AS Amount_Tax
               --, SUM (tmpMovement.AmountSumm_Tax) AS AmountSumm_Tax
               , tmpMovement.DocumentTaxKindId
          FROM (SELECT /*Object_Unit_Juridical.JuridicalCode AS FromCode
                     , Object_Unit_Juridical.JuridicalName AS FromName

                    , */Object_JuridicalBasis.ObjectCode   AS FromCode
                    , Object_JuridicalBasis.ValueData    AS FromName

                     , Object_Juridical.ObjectCode         AS ToCode
                     , Object_Juridical.ValueData          AS ToName
                     
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80770 THEN Movement.Id ELSE 0 END AS MovementId_Sale
                     , MovementLinkMovement.MovementChildId AS MovementId_Tax
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80770 THEN Movement.OperDate ELSE zc_DateStart() END AS OperDate_Sale
                     , Movement_Tax.OperDate AS OperDate_Tax

                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80770 THEN Movement.InvNumber ELSE '' END AS InvNumber_Sale
                     , Movement_Tax.InvNumber AS InvNumber_Tax

                     , MovementItem.ObjectId AS GoodsId
                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId 
                     , MIFloat_Price.ValueData AS Price_Sale
                     , COALESCE (SUM (MIFloat_AmountPartner.ValueData), 0) AS Amount_Sale
                     , 0 AS Price_Tax
                     , 0 AS Amount_Tax
                     , MovementLO_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                FROM Movement 
                     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                     JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                              AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Child()
                     LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId
                     
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

                     /*LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN Object_Unit_View AS Object_Unit_Juridical on Object_Unit_Juridical.Id = MovementLinkObject_From.ObjectId*/

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                     LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                     LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = ObjectLink_Contract_JuridicalBasis.ChildObjectId
                                                                                                                  
                WHERE Movement.DescId = zc_Movement_Sale()
                  AND Movement.OperDate between inStartDate AND inEndDate
                GROUP BY Object_JuridicalBasis.ObjectCode
                       , Object_JuridicalBasis.ValueData
                       , Object_Juridical.ObjectCode   
                       , Object_Juridical.ValueData    
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80770 THEN Movement.Id ELSE 0 END
                       , MovementLinkMovement.MovementChildId
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80770 THEN Movement.OperDate ELSE zc_DateStart() END
                       , Movement_Tax.OperDate
                       , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80770 THEN Movement.InvNumber ELSE '' END
                       , Movement_Tax.InvNumber
                       , MovementItem.ObjectId 
                       , MILinkObject_GoodsKind.ObjectId 
                       , MIFloat_Price.ValueData 
                       , MovementLO_DocumentTaxKind.ObjectId
             UNION
                SELECT Object_Juridical.ObjectCode           AS FromCode
                     , Object_Juridical.ValueData            AS FromName
                     , Object_Contract_Juridical.ObjectCode  AS ToCode
                     , Object_Contract_Juridical.ValueData   AS ToName
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = 80770 THEN MovementLinkMovement.MovementId ELSE 0 END AS MovementId_Sale
                     , Movement.Id  AS MovementId_Tax
                     , zc_DateStart() AS OperDate_Sale
                     , Movement.OperDate AS OperDate_Tax
                     , '' AS InvNumber_Sale
                     , Movement.InvNumber AS InvNumber_Tax
                     , MovementItem.ObjectId AS GoodsId
                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                     , 0 AS Price_Sale
                     , 0 AS Amount_Sale
                    -- , 0 AS AmountSumm_Sale
                     , MIFloat_Price.ValueData AS Price_Tax
                     , MovementItem.Amount AS Amount_Tax
                    -- , MIFloat_Price.ValueData * MovementItem.Amount AS AmountSumm_Tax
                    , MovementLO_DocumentTaxKind.ObjectId AS DocumentTaxKindId
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
                     
                WHERE Movement.DescId = zc_Movement_Tax()
                  AND Movement.OperDate between inStartDate AND inEndDate

                ) AS tmpMovement
               GROUP BY /*tmpMovement.MovementId_Sale
                      , tmpMovement.MovementId_Tax
                      , */tmpMovement.FromCode
                      , tmpMovement.FromName
                      , tmpMovement.ToCode
                      , tmpMovement.ToName
                      , tmpMovement.GoodsId
                      , tmpMovement.GoodsKindId
                      , tmpMovement.DocumentTaxKindId 
             ) AS tmpGroupMovement

         JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGroupMovement.GoodsId
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGroupMovement.GoodsKindId
         LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = tmpGroupMovement.DocumentTaxKindId

         ORDER BY 1,3,2,4,11
 ;
            
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckTax (TDateTime, TDateTime, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.

 17.02.14         * change Amount =  MIFloat_AmountPartner, - summ
 14.02.14         *  
                
*/

-- òåñò
--SELECT * FROM gpReport_CheckTax (inStartDate:= '15.12.2013', inEndDate:= '1.1.2014', inSessiON:= zfCalc_UserAdmin());

/*
select * from Object where descId =91

INSERT INTO MovementLinkObject( DescId, MovementId ,  ObjectId )
select zc_MovementLinkObject_DocumentTaxKind(), 19736,  80770*/