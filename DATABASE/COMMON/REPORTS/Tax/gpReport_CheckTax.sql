-- FunctiON: gpReport_CheckTax ()

DROP FUNCTION IF EXISTS gpReport_CheckTax (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckTax (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTax (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inDocumentTaxKindID   Integer ,
    IN inSessiON             TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE ( InvNumber_Sale TVarChar, InvNumber_Tax TVarChar, OperDate_Sale TDateTime, OperDate_Tax TDateTime
              , Contract_InvNumber TVarChar
              , FromCode Integer, FromName TVarChar
              , ToCode Integer, TOName TVarChar              
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
              , Price_Sale TFloat, Price_Tax TFloat
              , Amount_Sale TFloat
              , Amount_Tax TFloat
              , Difference Boolean
              , DocumentTaxKindName TVarChar
              )  
AS
$BODY$
BEGIN

    RETURN QUERY
  
    SELECT CAST (tmpGroupMovement.InvNumber_Sale AS TVarChar) 
         , CAST (MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumber_Tax
         , CAST (tmpGroupMovement.OperDate_Sale AS TDateTime)
         , CAST (tmpGroupMovement.OperDate_Tax AS TDateTime)
         , View_Contract_InvNumber.InvNumber AS Contract_InvNumber
         , tmpGroupMovement.FromCode
         , tmpGroupMovement.FromName
         , tmpGroupMovement.ToCode
         , tmpGroupMovement.ToName
               
         , Object_Goods.ObjectCode    AS GoodsCode
         , Object_Goods.ValueData     AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
     
         , CAST (tmpGroupMovement.Price_Sale AS TFloat)
         , CAST (tmpGroupMovement.Price_Tax AS TFloat)
     
         , CAST (tmpGroupMovement.Amount_Sale AS TFloat)
         , CAST (tmpGroupMovement.Amount_Tax AS TFloat)

         , CAST (CASE WHEN (tmpGroupMovement.Price_Sale<>tmpGroupMovement.Price_Tax) 
                  OR (tmpGroupMovement.Amount_Sale<>tmpGroupMovement.Amount_Tax) 
                      THEN TRUE ELSE FALSE END AS Boolean) AS Difference
                 
         , Object_DocumentTaxKind.ValueData AS DocumentTaxKindName       
         
    FROM (SELECT tmpMovement.FromCode
               , tmpMovement.FromName
               , tmpMovement.ToCode
               , tmpMovement.ToName
               , MAX (tmpMovement.OperDate_Sale)  AS OperDate_Sale
               , MAX (tmpMovement.OperDate_Tax)   AS OperDate_Tax
               , MAX (tmpMovement.InvNumber_Sale) AS InvNumber_Sale
               --, (tmpMovement.InvNumber_Tax)  AS InvNumber_Tax
               , tmpMovement.MovementId_Tax AS MovementId_Tax
               , tmpMovement.GoodsId
               , tmpMovement.GoodsKindId
               , MAX (tmpMovement.Price_Sale)     AS Price_Sale
               , SUM (tmpMovement.Amount_Sale)    AS Amount_Sale
               , MAX (tmpMovement.Price_Tax)      AS Price_Tax
               , SUM (tmpMovement.Amount_Tax)     AS Amount_Tax
               , tmpMovement.DocumentTaxKindId
               , tmpMovement.ContractId_Tax
          FROM (SELECT Object_JuridicalBasis.ObjectCode   AS FromCode
                     , Object_JuridicalBasis.ValueData    AS FromName

                     , Object_Juridical.ObjectCode         AS ToCode
                     , Object_Juridical.ValueData          AS ToName
                     
                     , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()) THEN Movement.Id ELSE 0 END AS MovementId_Sale
                     , MovementLinkMovement.MovementChildId AS MovementId_Tax
                     , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()) THEN MovementDate_OperDatePartner.ValueData ELSE zc_DateStart() END AS OperDate_Sale
                     , Movement_Tax.OperDate AS OperDate_Tax

                     , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()) THEN Movement.InvNumber ELSE '' END AS InvNumber_Sale
                    -- , MovementString_InvNumberPartner.ValueData AS InvNumber_Tax

                     , MovementItem.ObjectId AS GoodsId
                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId 
                     , MIFloat_Price.ValueData AS Price_Sale
                     , COALESCE (SUM (MIFloat_AmountPartner.ValueData), 0) AS Amount_Sale
                     , 0 AS Price_Tax
                     , 0 AS Amount_Tax
                     , MovementLO_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                     , MovementLinkObject_Contract.ObjectId AS ContractId_Tax
                FROM Movement 
                     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                     JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                                              AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
                     LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId

                     JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                 AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindID OR inDocumentTaxKindID =0)

                     LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                            ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                           AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                           --AND MovementDate_OperDatePartner.ValueData between inStartDate AND inEndDate

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                       
                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                
                     LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     
                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                     LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                     LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = ObjectLink_Contract_JuridicalBasis.ChildObjectId
                                                                                                                  
                WHERE Movement.DescId = zc_Movement_Sale()
                  AND ((Movement.StatusId = zc_Enum_Status_Complete()) OR (Movement.StatusId = zc_Enum_Status_UnComplete()))
                  AND MovementDate_OperDatePartner.ValueData between inStartDate AND inEndDate
                  --AND Movement.OperDate between inStartDate AND inEndDate
                 --and Movement.id=114652
                GROUP BY Object_JuridicalBasis.ObjectCode
                       , Object_JuridicalBasis.ValueData
                       , Object_Juridical.ObjectCode   
                       , Object_Juridical.ValueData    
                       , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()) THEN Movement.Id ELSE 0 END
                       , MovementLinkMovement.MovementChildId                                                                                                               -- Id íàëîãîâîé
                       , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()) THEN MovementDate_OperDatePartner.ValueData ELSE zc_DateStart() END
                       , Movement_Tax.OperDate
                       , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()) THEN Movement.InvNumber ELSE '' END
                       --, Movement_Tax.InvNumber
                       , MovementItem.ObjectId 
                       , MILinkObject_GoodsKind.ObjectId 
                       , MIFloat_Price.ValueData 
                       , MovementLO_DocumentTaxKind.ObjectId
                       , MovementLinkObject_Contract.ObjectId
                       
             UNION
                SELECT Object_Juridical.ObjectCode           AS FromCode
                     , Object_Juridical.ValueData            AS FromName
                     , Object_Contract_Juridical.ObjectCode  AS ToCode
                     , Object_Contract_Juridical.ValueData   AS ToName
                     , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()) THEN MovementLinkMovement.MovementId ELSE 0 END AS MovementId_Sale
                     , Movement.Id  AS MovementId_Tax
                     , zc_DateStart() AS OperDate_Sale
                     , Movement.OperDate AS OperDate_Tax
                     , '' AS InvNumber_Sale
                    -- , MovementString_InvNumberPartner.ValueData AS InvNumber_Tax
                     , MovementItem.ObjectId AS GoodsId
                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                     , 0 AS Price_Sale
                     , 0 AS Amount_Sale
                     , MIFloat_Price.ValueData AS Price_Tax
                     , MovementItem.Amount AS Amount_Tax
                     , MovementLO_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                     , MovementLinkObject_Contract.ObjectId AS ContractId_Tax 
                FROM Movement 
                     JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                      AND MovementItem.Amount<>0
                     LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementChildId  = Movement.Id
                                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()

                     JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = Movement.Id
                                                 AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                 AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindID OR inDocumentTaxKindID =0)

                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                           
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     
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
                  AND ((Movement.StatusId = zc_Enum_Status_Complete()) OR (Movement.StatusId = zc_Enum_Status_UnComplete()))
                  --and Movement.Id =129833

                ) AS tmpMovement
               GROUP BY tmpMovement.FromCode
                      , tmpMovement.FromName
                      , tmpMovement.ToCode
                      , tmpMovement.ToName
                      , tmpMovement.GoodsId
                      , tmpMovement.GoodsKindId
                      , tmpMovement.DocumentTaxKindId 
                      --, tmpMovement.InvNumber_Tax
                      , tmpMovement.MovementId_Tax
                      , tmpMovement.ContractId_Tax
             ) AS tmpGroupMovement

         JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGroupMovement.GoodsId
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGroupMovement.GoodsKindId
         LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = tmpGroupMovement.DocumentTaxKindId

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
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 18.03.14         *
 17.02.14         * change Amount =  MIFloat_AmountPartner, - summ
 14.02.14         *  
                
*/

-- òåñò
--SELECT * FROM gpReport_CheckTax (inStartDate:= '01.12.2013', inEndDate:= '31.12.2013', inSessiON:= zfCalc_UserAdmin());

/*
select * from Object where descId =91

INSERT INTO MovementLinkObject( DescId, MovementId ,  ObjectId )
select zc_MovementLinkObject_DocumentTaxKind(), 19736,  80770*/