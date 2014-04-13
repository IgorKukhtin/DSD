-- FunctiON: gpReport_CheckContractInMovement ()

DROP FUNCTION IF EXISTS gpReport_CheckContractInMovement (TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_CheckContractInMovement (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inSessiON             TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE ( MovementDate TDateTime, MovementDescName TVarChar, MovementInvNumber TVarChar
              , PaidKindName TVarChar
              , JuridicalName TVarChar, OKPO TVarChar
              , Contract_InvNumber TVarChar, ContractStartDate TDateTime, ContractEndDate TDateTime
              )  
AS
$BODY$
BEGIN

    RETURN QUERY


    SELECT tmpMovement.MovementDate
         , MovementDesc.ItemName                     AS MovementDescName
         , tmpMovement.MovementInvNumber
         , Object_PaidKind.ValueData                 AS PaidKindName
         , Object_Juridical.ValueData                AS JuridicalName
         , ObjectHistory_JuridicalDetails_View.OKPO
         , tmpMovement.InvNumber                     AS Contract_InvNumber
         , tmpMovement.ContractStartDate
         , tmpMovement.ContractEndDate
                  
    FROM (SELECT Movement.Id                            AS MovementId
               , Movement.DescId                        AS MovementDescId            
               , Movement.InvNumber                     AS MovementInvNumber
               , MovementDate_OperDatePartner.ValueData AS MovementDate
               , Object_Contract_View.StartDate         AS ContractStartDate
               , Object_Contract_View.EndDate           AS ContractEndDate
               , Object_Contract_View.InvNumber
               , Object_Contract_View.JuridicalId
               , MovementLinkObject_PaidKind.ObjectId   AS PaidKindId
                 
          FROM MovementDate AS MovementDate_OperDatePartner
               JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId 
                            AND Movement.DescId not in (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_ProfitLossService(), zc_Movement_TransportService(), zc_Movement_PersonalAccount())
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
               LEFT JOIN Object_Contract_View  ON Object_Contract_View.ContractId = MovementLinkObject_Contract.ObjectId

               LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            AND (MovementDate_OperDatePartner.ValueData < Object_Contract_View.StartDate OR MovementDate_OperDatePartner.ValueData > Object_Contract_View.EndDate)

        UNION ALL

          SELECT Movement.Id                    AS MovementId
               , Movement.DescId                AS MovementDescId
               , Movement.InvNumber             AS MovementInvNumber
               , Movement.OperDate              AS MovementDate
               , Object_Contract_View.StartDate AS ContractStartDate
               , Object_Contract_View.EndDate   AS ContractEndDate
               , Object_Contract_View.InvNumber
               , MovementItem.ObjectId          AS JuridicalId
               , MILinkObject_PaidKind.ObjectId AS PaidKindId

          FROM Movement 
                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                        AND MovementItem.DescId     = zc_MI_Master()
                  LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId 

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                   ON MILinkObject_Contract.MovementItemId = MovementItem.Id 
                                                  AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                  LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = MILinkObject_Contract.ObjectId

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
               AND Movement.DescId in (zc_Movement_ProfitLossService(), zc_Movement_TransportService())               
               AND (Movement.OperDate < Object_Contract_View.StartDate OR Movement.OperDate > Object_Contract_View.EndDate)
          ) AS tmpMovement
          LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMovement.MovementDescId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpMovement.JuridicalId 
          LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMovement.PaidKindId

 ;

            
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckContractInMovement (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 13.04.14         *
                
*/

--select * from gpReport_CheckContractInMovement(inStartDate := ('01.01.2014')::TDateTime , inEndDate := ('31.01.2014 23:59:00')::TDateTime ,  inSession := '5');