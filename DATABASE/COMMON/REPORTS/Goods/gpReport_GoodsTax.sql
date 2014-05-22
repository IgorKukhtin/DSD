-- Function: gpReport_GoodsTax ()

DROP FUNCTION IF EXISTS gpReport_GoodsTax (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsTax (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inGoodsId      Integer   ,
    IN inSession      TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE  (InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime, MovementDescName TVarChar, StatusName TVarChar
              , Unit_infCode Integer, Unit_infName TVarChar
              , DirectionCode Integer, DirectionName TVarChar
              , PartnerCode Integer, PartnerName TVarChar, JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar
              , ContractCode Integer, ContractNumber TVarChar, PaidKindName TVarChar
              , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
              , DocumentTaxKindName TVarChar, InvNumberPartner_Master TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
              , AmountPartner TFloat, OperPrice TFloat
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY

    WITH tmpContainer AS (SELECT Container.Id AS ContainerId, Container.ObjectId AS GoodsId, Container.Amount
                          FROM (SELECT inGoodsId AS GoodsId) AS tmpGoods 
                               JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                             AND Container.DescId = zc_Container_Count()
                         )


  select  Movement.InvNumber
        , Movement.OperDate AS OperDate
        , MovementDate_OperDatePartner.ValueData AS OperDatePartner
        , MovementDesc.ItemName   AS MovementDescName
        , Object_Status.ValueData                    AS StatusName

        , Object_Unit_inf.ObjectCode     AS Unit_infCode
        , Object_Unit_inf.ValueData      AS Unit_infName
        , Object_Direction.ObjectCode    AS DirectionCode
        , Object_Direction.ValueData     AS DirectionName

        , Object_Partner.ObjectCode AS PartnerCode
        , Object_Partner.ValueData AS PartnerName
        , Object_Juridical.ObjectCode AS JuridicalCode
        , Object_Juridical.ValueData AS JuridicalName
        , ObjectHistory_JuridicalDetails_View.OKPO
                
        , View_Contract_InvNumber.ContractCode
        , View_Contract_InvNumber.InvNumber AS ContractNumber
        , Object_PaidKind.ValueData AS PaidKindName

        , View_InfoMoney.InfoMoneyGroupName
        , View_InfoMoney.InfoMoneyDestinationName
        , View_InfoMoney.InfoMoneyCode
        , View_InfoMoney.InfoMoneyName

        , Object_TaxKind.ValueData             AS DocumentTaxKindName
        , MS_InvNumberPartner_Master.ValueData AS InvNumberPartner_Master

        , Object_Goods.ObjectCode AS GoodsCode
        , Object_Goods.ValueData  AS GoodsName
        , Object_GoodsKind.ValueData AS GoodsKindName

        , CAST (tmp_All.AmountPartner AS TFloat) AS AmountPartner
        , CAST (tmp_All.OperPrice AS TFloat)     AS OperPrice

        , CAST (tmp_All.SummStart AS TFloat) AS SummStart
        , CAST (tmp_All.SummIn AS TFloat)    AS SummIn
        , CAST (tmp_All.SummOut AS TFloat)   AS SummOut
        , CAST (tmp_All.SummEnd AS TFloat)   AS SummEnd 

  from (select  tmpContainer_All.MovementId
              , tmpContainer_All.GoodsId
              , COALESCE (ContainerLO_Car.ObjectId, COALESCE (ContainerLO_Unit.ObjectId, COALESCE (ContainerLO_Member.ObjectId, tmpContainer_All.UnitId))) AS DirectionId
              , COALESCE (ContainerLO_GoodsKind.ObjectId, 0) AS GoodsKindId
              , (tmpContainer_All.SummStart) AS SummStart
              , (tmpContainer_All.SummEnd) AS SummEnd
              , (tmpContainer_All.SummIn)  AS SummIn
              , (tmpContainer_All.SummOut) AS SummOut
              , tmpContainer_All.AmountPartner
              , tmpContainer_All.OperPrice
        from (/*SELECT tmpContainer.ContainerId
                  , tmpContainer.GoodsId
                  , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummStart
                  , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate >inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                  , 0 AS SummIn
                  , 0 AS SummOut
                  , 0 AS MovementDescId
                  , 0 AS MovementId
                  , NULL :: TDateTime AS OperDate
                  , '' AS InvNumber
             FROM tmpContainer
                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                AND MIContainer.OperDate >= inStartDate
             GROUP BY tmpContainer.ContainerId, tmpContainer.GoodsId, tmpContainer.Amount
             HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                 OR (tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
          union all*/
             select tmpMIContainer.MovementId 
                  , tmpMIContainer.UnitId
                  , tmpMIContainer.ContainerId
                  , tmpMIContainer.GoodsId
                  , 0 AS SummStart
                  , 0 AS SummEnd
                  , tmpMIContainer.SummIn  AS SummIn
                  , tmpMIContainer.SummOut AS SummOut
                  , tmpMIContainer.AmountPartner
                  , tmpMIContainer.OperPrice
             from (SELECT MovementItem.MovementId
                        , MovementLinkObject_Unit.ObjectId AS UnitId
                        , 0 AS ContainerId
                        , MovementItem.ObjectId AS GoodsId
                        , 0 AS SummStart
                        , 0 AS SummEnd
                        , SUM (case when MovementDesc.Id = zc_Movement_ReturnIn() then COALESCE (MovementItem.Amount,0) else 0 end)      AS SummIn
                        , SUM (case when MovementDesc.Id = zc_Movement_Sale() then COALESCE (MovementItem.Amount,0) else 0 end) AS SummOut
                        , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                        , COALESCE (MIFloat_Price.ValueData, 0) AS OperPrice
--                    FROM tmpContainer
--                        LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
--                                                                      AND MIContainer.OperDate between  inStartDate and inEndDate
                    FROM MovementItem
                        INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                           AND Movement.OperDate between  inStartDate and inEndDate
                                           AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                           AND Movement.DescId NOT IN (zc_Movement_Tax(), zc_Movement_TaxCorrective())
                        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                    AND MovementLinkObject_Unit.DescId = CASE WHEN MovementDesc.Id = zc_Movement_Sale() THEN zc_MovementLinkObject_From()
                                                                                              WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To()
                                                                                         END
                    WHERE MovementItem.ObjectId = inGoodsId
                      AND MovementItem.isErased   = FALSE
                    GROUP BY MovementItem.ObjectId
                           , MovementLinkObject_Unit.ObjectId
                           , COALESCE (MIFloat_Price.ValueData, 0)
                           , MovementItem.MovementId
                  ) AS tmpMIContainer

    ) AS tmpContainer_All
         
    LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpContainer_All.ContainerId
                                                    AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
    LEFT JOIN ContainerLinkObject AS ContainerLO_Unit ON ContainerLO_Unit.ContainerId = tmpContainer_All.ContainerId
                                                     AND ContainerLO_Unit.DescId = zc_ContainerLinkObject_Unit()                                                          
    LEFT JOIN ContainerLinkObject AS ContainerLO_Member ON ContainerLO_Member.ContainerId = tmpContainer_All.ContainerId
                                                       AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()
    LEFT JOIN ContainerLinkObject AS ContainerLO_GoodsKind ON ContainerLO_GoodsKind.ContainerId = tmpContainer_All.ContainerId
                                                          AND ContainerLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()                                                     
    ) AS tmp_All

     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp_All.GoodsId
     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmp_All.GoodsKindId

     LEFT JOIN Movement ON Movement.Id = tmp_All.MovementId 
     LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

     LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = tmp_All.DirectionId

     LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = tmp_All.DirectionId
                                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
     LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit ON ObjectLink_Personal_Unit.ObjectId = tmp_All.DirectionId
                                                     AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
     LEFT JOIN Object AS Object_Unit_inf on Object_Unit_inf.Id = COALESCE (ObjectLink_Car_Unit.ChildObjectId, COALESCE (ObjectLink_Personal_Unit.ChildObjectId, tmp_All.DirectionId))

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = tmp_All.MovementId 
                                        AND MovementLinkObject_Partner.DescId = CASE WHEN MovementDesc.Id = zc_Movement_Sale() THEN zc_MovementLinkObject_To()
                                                                                     WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From()
                                                                                END
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = tmp_All.MovementId
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = tmp_All.MovementId
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = tmp_All.MovementId
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MovementLinkMovement_Master.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_Master ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                                                  AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = COALESCE (MovementLinkMovement_Master.MovementChildId, tmp_All.MovementId)
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  tmp_All.MovementId
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
 ;
    
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsTax (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 20.05.14         * rename gpReport_GoodsTax
 10.04.14                                        * ALL
 09.02.14         *  GROUP BY tmp_All
                   , add GoodsKind
 21.12.13                                        * Personal -> Member
 05.11.13         *  
*/

-- òåñò
-- SELECT * FROM gpReport_GoodsTax (inStartDate:= '01.12.2013', inEndDate:= '01.12.2013', inGoodsId:= 1826, inSession:= zfCalc_UserAdmin());
