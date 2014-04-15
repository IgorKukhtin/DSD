-- FunctiON: gpReport_CheckTax ()

--DROP FUNCTION IF EXISTS gpReport_CheckTax (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckTax (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTax (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inDocumentTaxKindID   Integer ,
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE ( InvNumber_Sale TVarChar, InvNumber_Tax TVarChar, OperDate_Sale TDateTime, OperDate_Tax TDateTime
              , Contract_InvNumber TVarChar
              , FromCode Integer, FromName TVarChar
              , ToCode Integer, TOName TVarChar              
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
              , Price_Sale TFloat--, Price_Tax TFloat
              , Amount_Sale TFloat
              , Amount_Tax TFloat
              , Difference Boolean
              , DocumentTaxKindName TVarChar
              )  
AS
$BODY$

BEGIN

    RETURN QUERY

      WITH tmpMovWith AS (SELECT  Movement.Id AS MovementId
                                , Movement.InvNumber as InvNumber
                                , MovementDate_OperDatePartner.ValueData AS OperDate_Sale
                                , Movement.DescId AS Movement_DescId
                                , zc_MovementLinkObject_To() AS MovementLODescId 
                                , MovementLO_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                                , MovementLinkMovement.MovementChildId AS MovementId_Tax
                                , Movement_Tax.OperDate as OperDate_Tax
                                , CASE WHEN MovementLO_DocumentTaxKind.ObjectId in (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(),zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()) 
                                            THEN MovementLinkObject_Partner.ObjectId
                                            ELSE 0 
                                  END AS PartnerId_Tax
                          FROM Movement 
                               JOIN MovementDate AS MovementDate_OperDatePartner
                                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                                AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                               JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                                        AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                               LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId

                               JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                       ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                                       AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                       AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindID OR inDocumentTaxKindID =0)

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                            ON MovementLinkObject_Partner.MovementId = Movement_Tax.Id
                                                           AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                   
                          WHERE Movement.DescId = zc_Movement_Sale()
                            AND (Movement.StatusId = zc_Enum_Status_Complete())
   
                      UNION ALL 
                          SELECT  Movement.Id AS MovementId
                                , Movement.InvNumber as InvNumber
                                , MovementDate_OperDatePartner.ValueData AS OperDate_Sale
                                , Movement.DescId AS Movement_DescId
                                , zc_MovementLinkObject_From() AS MovementLODescId 
                                , CASE WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR() THEN zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR() 
                                       WHEN MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR() THEN zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                       ELSE 0
                                  END AS DocumentTaxKindId
                                , 0 AS MovementId_Tax     
                                , DATE_TRUNC ('Month', inEndDate) + interval '1 month' - interval '1 day'  as OperDate_Tax
                                , CASE WHEN MovementLO_DocumentTaxKind.ObjectId in (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()) 
                                            THEN MovementLinkObject_From.ObjectId
                                            ELSE 0 
                                  END AS PartnerId_Tax
                          FROM Movement 
                          JOIN MovementDate AS MovementDate_OperDatePartner
                                            ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                           AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                           AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate

                          JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id 
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND (MovementLO_DocumentTaxKind.ObjectId = CASE WHEN inDocumentTaxKindID = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR() THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                                                                                  WHEN inDocumentTaxKindID = zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR() THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR() END
                                                       OR inDocumentTaxKindID =0)
                                                       
                          JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           WHERE Movement.DescId = zc_Movement_ReturnIn()  
                            AND (Movement.StatusId = zc_Enum_Status_Complete())
                            AND (inDocumentTaxKindID in (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR(),  0))
                          )
       
  
    SELECT CAST (tmpGroupMovement.InvNumber_Sale AS TVarChar) 
         , CAST (MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumber_Tax
         , CAST (tmpGroupMovement.OperDate_Sale AS TDateTime)
         , CAST (tmpGroupMovement.OperDate_Tax AS TDateTime)
         , View_Contract_InvNumber.InvNumber AS Contract_InvNumber

         , Object_JuridicalBasis.ObjectCode           AS FromCode
         , Object_JuridicalBasis.ValueData            AS FromName
         , Object_Juridical.ObjectCode  AS ToCode
         , Object_Juridical.ValueData   AS ToName
               
         , Object_Goods.ObjectCode    AS GoodsCode
         , Object_Goods.ValueData     AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
     
         , CAST (tmpGroupMovement.Price_Sale AS TFloat)
     
         , CAST (tmpGroupMovement.Amount_Sale AS TFloat)
         , CAST (tmpGroupMovement.Amount_Tax AS TFloat)

         , CAST (CASE WHEN (tmpGroupMovement.Amount_Sale<>tmpGroupMovement.Amount_Tax) 
                      THEN TRUE ELSE FALSE END AS Boolean) AS Difference
                 
         , Object_DocumentTaxKind.ValueData AS DocumentTaxKindName       
         
    FROM (SELECT tmpMovement.JuridicalBasisId
               , tmpMovement.JuridicalId
               , MAX (tmpMovement.OperDate_Sale)  AS OperDate_Sale
               , MAX (tmpMovement.OperDate_Tax)   AS OperDate_Tax
               , MAX (tmpMovement.InvNumber_Sale) AS InvNumber_Sale
               , tmpMovement.MovementId_Tax AS MovementId_Tax
               , tmpMovement.GoodsId
               , tmpMovement.GoodsKindId
               , tmpMovement.Price_Sale     AS Price_Sale
               , SUM (tmpMovement.Amount_Sale)    AS Amount_Sale
               , SUM (tmpMovement.Amount_Tax)     AS Amount_Tax
               , tmpMovement.DocumentTaxKindId
               , tmpMovement.ContractId_Tax
               , tmpMovement.PartnerId_Tax
          FROM (SELECT  ObjectLink_Contract_JuridicalBasis.ChildObjectId AS JuridicalBasisId
                      , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                      , CASE WHEN (tmpMovWith.DocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()) THEN tmpMovWith.MovementId ELSE 0 END AS MovementId_Sale
                      , MAX (tmpMovWith.MovementId_Tax) AS MovementId_Tax
                      , CASE WHEN (tmpMovWith.DocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()) THEN tmpMovWith.OperDate_Sale ELSE DATE_TRUNC ('Month', inEndDate) + interval '1 month' - interval '1 day'  END AS OperDate_Sale
                      , tmpMovWith.OperDate_Tax  
                      , CASE WHEN (tmpMovWith.DocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()) THEN tmpMovWith.InvNumber ELSE '' END AS InvNumber_Sale
                      , MovementItem.ObjectId AS GoodsId
                      , MILinkObject_GoodsKind.ObjectId AS GoodsKindId 
                      , MIFloat_Price.ValueData AS Price_Sale
                      , SUM (CASE WHEN tmpMovWith.Movement_DescId=zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE ((-1) * COALESCE (MIFloat_AmountPartner.ValueData, 0)) END)  AS Amount_Sale
                      , 0 AS Amount_Tax
                      , tmpMovWith.DocumentTaxKindId
                      , MovementLinkObject_Contract.ObjectId AS ContractId_Tax
                      , tmpMovWith.PartnerId_Tax
                FROM tmpMovWith

                     JOIN MovementItem ON MovementItem.MovementId = tmpMovWith.MovementId
                                      AND MovementItem.isErased = false 

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = tmpMovWith.MovementId
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                       
                     JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                AND MIFloat_Price.ValueData <> 0
                                                
                     JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                AND MIFloat_AmountPartner.ValueData <> 0
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = tmpMovWith.MovementId
                                                 AND MovementLinkObject_To.DescId = tmpMovWith.MovementLODescId   
                     
                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
               
                GROUP BY ObjectLink_Contract_JuridicalBasis.ChildObjectId 
                       , ObjectLink_Partner_Juridical.ChildObjectId 
                       , CASE WHEN (tmpMovWith.DocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()) THEN tmpMovWith.MovementId ELSE 0 END 
                       , CASE WHEN (tmpMovWith.DocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()) THEN tmpMovWith.OperDate_Sale ELSE DATE_TRUNC ('Month', inEndDate) + interval '1 month' - interval '1 day'  END 
                       , tmpMovWith.OperDate_Tax  
                       , CASE WHEN (tmpMovWith.DocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()) THEN tmpMovWith.InvNumber ELSE '' END 
                       , MovementItem.ObjectId 
                       , MILinkObject_GoodsKind.ObjectId 
                       , MIFloat_Price.ValueData
                       , tmpMovWith.DocumentTaxKindId
                       , MovementLinkObject_Contract.ObjectId 
                       , tmpMovWith.PartnerId_Tax
              HAVING SUM (CASE WHEN tmpMovWith.Movement_DescId=zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE -1 * COALESCE (MIFloat_AmountPartner.ValueData, 0) END ) >0 
                       
             UNION all
                SELECT MovementLinkObject_From.ObjectId AS JuridicalBasisId
                     , MovementLinkObject_To.ObjectId    AS JuridicalId
                    
                     , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()) THEN MovementLinkMovement.MovementId ELSE 0 END AS MovementId_Sale
                     , Movement.Id  AS MovementId_Tax
                     , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()) THEN Movement.OperDate ELSE DATE_TRUNC ('Month', inEndDate) + interval '1 month' - interval '1 day'  END AS OperDate_Sale
                     , Movement.OperDate AS OperDate_Tax
                     , '' AS InvNumber_Sale
                     , MovementItem.ObjectId AS GoodsId
                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                     , MIFloat_Price.ValueData  AS Price_Sale
                     , 0 AS Amount_Sale
                     , MovementItem.Amount AS Amount_Tax
                     , MovementLO_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                     , MovementLinkObject_Contract.ObjectId AS ContractId_Tax 
                     , CASE WHEN MovementLO_DocumentTaxKind.ObjectId in(zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR() ) THEN MovementLinkObject_Partner.ObjectId ELSE 0 END AS PartnerId_Tax
                FROM Movement 
                     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                      AND MovementItem.Amount<>0
                                      AND MovementItem.isErased = false 
                     LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementChildId  = Movement.Id
                                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                                                   AND inDocumentTaxKindID = zc_Enum_DocumentTaxKind_Tax()
                     JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                 AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindID OR inDocumentTaxKindID =0)

                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                AND MIFloat_Price.ValueData <> 0
                                                
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                           
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                    
                    /*   берем партнера для  - Сводная налоговая по т.т.(реализация)  */
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                 ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     
                WHERE Movement.DescId = zc_Movement_Tax()
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                  AND Movement.StatusId = zc_Enum_Status_Complete()

               ) AS tmpMovement
               GROUP BY tmpMovement.JuridicalBasisId
                      , tmpMovement.JuridicalId
                      , tmpMovement.GoodsId
                      , tmpMovement.GoodsKindId
                      , tmpMovement.DocumentTaxKindId 
                      , tmpMovement.MovementId_Tax
                      , tmpMovement.ContractId_Tax
                      , tmpMovement.Price_Sale
                      , tmpMovement.PartnerId_Tax
             ) AS tmpGroupMovement

         JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGroupMovement.GoodsId
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGroupMovement.GoodsKindId
         LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = tmpGroupMovement.DocumentTaxKindId

         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpGroupMovement.JuridicalId
         LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = tmpGroupMovement.JuridicalBasisId

         LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                  ON MovementString_InvNumberPartner.MovementId =  tmpGroupMovement.MovementId_Tax
                                 AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

         LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpGroupMovement.ContractId_Tax
            

         ORDER BY 1,3,2,4,11
 ;
            
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckTax (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.03.14         *
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 18.03.14         *
 17.02.14         * change Amount =  MIFloat_AmountPartner, - summ
 14.02.14         *  
*/

-- тест
--SELECT * FROM gpReport_CheckTax (inStartDate:= '01.12.2013', inEndDate:= '31.12.2013', inSessiON:= zfCalc_UserAdmin());
--select * from gpReport_CheckTax(inStartDate := ('01.12.2013')::TDateTime , inEndDate := ('05.12.2013')::TDateTime , inDocumentTaxKindId := 0 ,  inSession := zfCalc_UserAdmin());

--select * from gpReport_CheckTax(inStartDate := ('01.02.2014')::TDateTime , inEndDate := ('28.02.2014')::TDateTime , inDocumentTaxKindId := 80791 ,  inSession := '5');

/*
select * from Object where Id =80791

INSERT INTO MovementLinkObject( DescId, MovementId ,  ObjectId )
select zc_MovementLinkObject_DocumentTaxKind(), 19736,  80770*/