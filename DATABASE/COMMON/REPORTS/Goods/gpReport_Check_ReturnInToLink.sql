-- Function: gpReport_Check_ReturnInToLink ()

DROP FUNCTION IF EXISTS gpReport_Check_ReturnInToLink (TDateTime,TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_ReturnInToLink (TDateTime,TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_ReturnInToLink (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --                                 
    IN inJuridicalId       Integer   ,
    IN inPartnerId         Integer   , --
    IN inPaidKindId        Integer   , --
    IN inisShowAll         Boolean   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Movement_ReturnId Integer, MovementDescName TVarChar, StatusCode Integer
             , OperDate TDateTime, InvNumber TVarChar                   --, OperDatePartner TDateTime   ---InvNumberPartner TVarChar,
             , PaidKindName TVarChar
             , ContractCode Integer, ContractName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , Amount TFloat, AmountChild TFloat
             , Price TFloat
             , Summa TFloat, SummaChild TFloat
             , SummDiff TFloat
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

 /*   IF inJuridicalId = 0 AND inPartnerId = 0
    THEN inShowAll:= TRUE;
    END IF;
 */

    -- Результат
    RETURN QUERY
      WITH 
      tmpMovReturn  AS (SELECT tmp.Id
                             , tmp.MovementDescId
                             , tmp.PartnerId
                             , tmp.OperDatePartner
                             , tmp.ContractId
                             , tmp.PaidKindId
                        FROM (SELECT Movement.Id
                                   , Movement.DescId                      AS MovementDescId
                                   , COALESCE (MovementLinkObject_From.ObjectId, 0)     AS PartnerId
                                   , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                   , COALESCE (MovementLinkObject_PaidKind.ObjectId,0)  AS PaidKindId
                                   , MD_OperDatePartner.ValueData         AS OperDatePartner
                              FROM MovementDate AS MD_OperDatePartner
                                   INNER JOIN Movement ON Movement.Id = MD_OperDatePartner.MovementId
                                                      AND Movement.DescId   = zc_Movement_ReturnIn()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id 
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                               AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                              WHERE MD_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                AND (MovementLinkObject_From.ObjectId = inPartnerId OR inPartnerId = 0)
                                AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                                AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
                             ) AS tmp
                       )
   , tmpMI_Master AS (SELECT tmpMovReturn.Id                               AS MovementId
                           , tmpMovReturn.MovementDescId
                           , tmpMovReturn.PartnerId
                           , tmpMovReturn.ContractId
                           , tmpMovReturn.PaidKindId
                           , MI_Master.Id                               AS MI_Id
                           , MI_Master.ObjectId                         AS GoodsId
                           , CASE WHEN MI_Master.isErased = TRUE THEN 0 ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) END AS AmountPartner
                      FROM tmpMovReturn
                           INNER JOIN MovementItem AS MI_Master 
                                                   ON MI_Master.MovementId = tmpMovReturn.Id
                                                  AND MI_Master.DescId     = zc_MI_Master()
                                                  AND MI_Master.isErased   = FALSE
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MI_Master.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                     )
      , tmpMI_Child AS (SELECT MI_Child.ParentId                  AS MI_Id
                             , SUM (COALESCE (MI_Child.Amount,0)) AS Amount
                        FROM tmpMovReturn
                         INNER JOIN MovementItem AS MI_Child
                                                 ON MI_Child.MovementId = tmpMovReturn.Id
                                                AND MI_Child.DescId     = zc_MI_Child()
                                                AND MI_Child.isErased   = FALSE
                        GROUP BY MI_Child.ParentId
                     )

   , tmpData AS (SELECT tmpMI_Master.MI_Id AS MovementItemId
                      , tmpMI_Master.MovementId
                      , tmpMI_Master.MovementDescId
                      , tmpMI_Master.GoodsId
                      , tmpMI_Master.AmountPartner  AS Amount
                      , tmpMI_Child.Amount          AS AmountChild
                      , tmpMI_Master.PartnerId 
                      , tmpMI_Master.ContractId
                      , tmpMI_Master.PaidKindId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)      AS GoodsKindId
                      , COALESCE (MIFloat_Price.ValueData, 0)              AS Price
                      , (tmpMI_Master.AmountPartner * COALESCE (MIFloat_Price.ValueData, 0))      AS Summa
                      , (tmpMI_Child.Amount * COALESCE (MIFloat_Price.ValueData, 0))              AS SummaChild
                 FROM tmpMI_Master
                   INNER JOIN tmpMI_Child ON tmpMI_Child.MI_Id = tmpMI_Master.MI_Id
                                         AND (tmpMI_Child.Amount <> tmpMI_Master.AmountPartner OR inisShowAll = True)
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = tmpMI_Master.MI_Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = tmpMI_Master.MI_Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                 )
   , tmpMaster_check AS (SELECT 
                        tmp.MovementId
                      , tmp.GoodsId
                      , SUM (tmp.Amount)  AS Amount
                 FROM (SELECT DISTINCT tmpData.MovementItemId, tmpData.MovementId, tmpData.GoodsId, tmpData.Amount FROM tmpData) AS tmp
                      GROUP BY 
                        tmp.MovementId
                      , tmp.GoodsId
                 )
   , tmpChild_check AS (SELECT 
                       tmp.MovementId
                      , tmp.GoodsId
                      , SUM (tmp.AmountChild)  AS AmountChild
                 FROM tmpData AS tmp
                      GROUP BY 
                        tmp.MovementId
                      , tmp.GoodsId
                 )
   , tmp_check AS (SELECT tmpMaster_check.MovementId, tmpMaster_check.GoodsId
                  FROM tmpMaster_check JOIN tmpChild_check ON tmpChild_check.MovementId = tmpMaster_check.MovementId
                                                         AND tmpChild_check.GoodsId     = tmpMaster_check.GoodsId
                                                         AND (tmpChild_check.AmountChild <> tmpMaster_check.Amount OR inisShowAll = True)
                 )
             -- результат
             SELECT Movement_Return.Id          AS Movement_ReturnId
                  , MovementDesc.ItemName       AS MovementDescName
                  , Object_Status.ObjectCode    AS StatusCode
                  , Movement_Return.OperDate    AS OperDate
                  , Movement_Return.InvNumber   AS InvNumber
                  , Object_PaidKind.ValueData   AS PaidKindName
                  , View_Contract_InvNumber.ContractCode   AS ContractCode
                  , View_Contract_InvNumber.InvNumber      AS ContractName
                  , Object_Partner.ObjectCode   AS PartnerCode
                  , Object_Partner.ValueData    AS PartnerName
                  , Object_Goods.ObjectCode     AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_GoodsKind.ValueData  AS GoodsKindName
                  , tmpData.Amount      :: Tfloat
                  , tmpData.AmountChild :: Tfloat
                  , tmpData.Price       :: Tfloat
                  , tmpData.Summa       :: Tfloat 
                  , tmpData.SummaChild  :: Tfloat 
                  , (tmpData.Summa - tmpData.SummaChild) :: Tfloat AS SummDiff
              FROM tmpData
                INNER JOIN tmp_check ON tmp_check.MovementId = tmpData.MovementId AND tmp_check.GoodsId = tmpData.GoodsId

                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
                LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpData.ContractId
                
                LEFT JOIN Movement AS Movement_Return ON Movement_Return.Id = tmpData.MovementId
                LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
                LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Return.StatusId
               
                LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId

       ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.03.17         * add inisShowAll
 10.01.17         * 
*/

-- тест
-- SELECT * FROM gpReport_Check_ReturnInToLink (inStartDate:= '2016-05-24' ::TDateTime , inEndDate:= '2016-05-24' ::TDateTime, inJuridicalId:= 0, inPartnerId:=0,  inPaidKindId:=0, inisShowAll:= FALSE, inSession:= zfCalc_UserAdmin()) 
