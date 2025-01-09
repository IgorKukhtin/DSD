 -- Function: gpReport_ContractGoodsMovement()

DROP FUNCTION IF EXISTS gpReport_ContractGoodsMovement (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ContractGoodsMovement(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inContractId         Integer   , --
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, EndBeginDate TDateTime, EndBeginDate_calc TDateTime
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , StartDate_Contract TDateTime
             , ContractKindName TVarChar
             , ContractStateKindId Integer
             , ContractStateKindCode Integer
             , ContractStateKindName TVarChar
             , InfoMoneyGroupCode  Integer
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyCode Integer
             , InfoMoneyName TVarChar
             , PaidKindId Integer
             , PaidKindName TVarChar
             , PersonalId Integer
             , PersonalCode Integer
             , PersonalName TVarChar
             , PersonalTradeId Integer
             , PersonalTradeCode Integer
             , PersonalTradeName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar 
             , CurrencyId Integer, CurrencyName TVarChar
             , DiffPrice TFloat, RoundPrice TFloat
             , PriceWithVAT Boolean 
             , isMultWithVAT Boolean
             --           
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar             
             , MeasureName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , Price           TFloat
             , ChangePrice     TFloat
             , ChangePercent   TFloat
             , CountForAmount  TFloat
             , CountForPrice   TFloat
             , Comment TVarChar
             , isBonusNo Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- inShowAll:= TRUE;
     RETURN QUERY 
     WITH tmpMovement AS ( SELECT Movement.Id                          AS Id
                                , Movement.InvNumber                   AS InvNumber
                                , Movement.OperDate                    AS OperDate
                                , MovementLinkObject_Contract.ObjectId AS ContractId
                                , ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                 ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                AND (MovementLinkObject_Contract.ObjectId = inContractId OR inContractId = 0)
                                LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                     ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                                                    AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()           
                           WHERE Movement.DescId = zc_Movement_ContractGoods()
                             AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                         )


        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementDate.DescId = zc_MovementDate_EndBegin()
                              )
        , tmpMovementBoolean AS (SELECT MovementBoolean.*
                                 FROM MovementBoolean
                                 WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementBoolean.DescId IN (zc_MovementBoolean_PriceWithVAT() 
                                                                , zc_MovementBoolean_MultWithVAT()
                                                                 )
                                 )
        , tmpMovementFloat AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_DiffPrice() 
                                                            , zc_MovementFloat_RoundPrice()
                                                             )
                               )
        , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                                    FROM MovementLinkObject
                                    WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                      AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Currency() 
                                                                       )
                                    )
 
        , tmpMI AS (SELECT MovementItem.* 
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                    )
 
        , tmpMILO AS (SELECT MovementItemLinkObject.*
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                     )

        , tmpMI_String AS (SELECT MovementItemString.*
                           FROM MovementItemString
                           WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             AND MovementItemString.DescId IN (zc_MIString_Comment())
                          )

        , tmpMI_Float AS (SELECT MovementItemFloat.*
                           FROM MovementItemFloat
                           WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                            , zc_MIFloat_ChangePrice()
                                                            , zc_MIFloat_ChangePercent() 
                                                            , zc_MIFloat_CountForAmount()
                                                            , zc_MIFloat_CountForPrice()
                                                             )
                          )

        , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                            FROM MovementItemBoolean
                            WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                              AND MovementItemBoolean.DescId IN (zc_MIBoolean_BonusNo())
                           )
 
        , tmpGoods_param AS (SELECT tmp.ObjectId                                 AS GoodsId 
                                  , ObjectString_Goods_GoodsGroupFull.ValueData  AS GoodsGroupNameFull
                                  , Object_Measure.ValueData                     AS MeasureName
                             FROM (SELECT DISTINCT tmpMI.ObjectId FROM tmpMI) AS tmp
                                 LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                        ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmp.ObjectId
                                                       AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                      ON ObjectLink_Goods_Measure.ObjectId = tmp.ObjectId
                                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                             )
 
       , tmpContract_View AS (SELECT *
                              FROM Object_Contract_View
                              WHERE Object_Contract_View.ContractId IN (SELECT DISTINCT tmpMovement.ContractId FROM tmpMovement)
                              )
       , tmpInfoMoney_View AS (SELECT *
                               FROM Object_InfoMoney_View
                               WHERE Object_InfoMoney_View.InfoMoneyId IN (SELECT DISTINCT tmpContract_View.InfoMoneyId FROM tmpContract_View)
                               )

       , tmpContract_param AS (SELECT tmp.ContractId
                                    , Object_Personal.Id          AS PersonalId
                                    , Object_Personal.ObjectCode  AS PersonalCode
                                    , Object_Personal.ValueData   AS PersonalName
                                    , Object_PersonalTrade.Id          AS PersonalTradeId
                                    , Object_PersonalTrade.ObjectCode  AS PersonalTradeCode
                                    , Object_PersonalTrade.ValueData   AS PersonalTradeName
                               FROM (SELECT DISTINCT tmpMovement.ContractId FROM tmpMovement) AS tmp
                                    LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                         ON ObjectLink_Contract_Personal.ObjectId = tmp.ContractId
                                                        AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                    LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId               
 
                                    LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                                         ON ObjectLink_Contract_PersonalTrade.ObjectId = tmp.ContractId 
                                                        AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                    LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Contract_PersonalTrade.ChildObjectId 
                               )
        --связываем документы со строками
       , tmpData AS (SELECT Movement.Id                         AS Id
                          , Movement.InvNumber                  AS InvNumber
                          , Movement.OperDate ::TDateTime       AS OperDate
                          , MovementDate_EndBegin.ValueData     AS EndBeginDate
                          , Movement.ContractId
                          , Movement.JuridicalId
                          --
                          , MovementItem.Id                     AS MovementItemId
                          , MovementItem.ObjectId               AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId,0) AS GoodsKindId
                     FROM tmpMovement AS Movement

                          LEFT JOIN tmpMovementDate AS MovementDate_EndBegin
                                                    ON MovementDate_EndBegin.MovementId = Movement.Id
                                                   AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

                          INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                          LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    )
        --получаем дату следующего документа, до которой действует теущий, по ключу Юр.лицо + договор+товар+вид товара
       , tmpRez AS (SELECT *
                    FROM (SELECT tmpData.* 
                               , COALESCE (tmpData_next.OperDate- interval '1 day', zc_DateEnd()) AS OperDate_next
                               , ROW_NUMBER() OVER (PARTITION BY tmpData.Id, tmpData.MovementItemId, tmpData.OperDate, tmpData.JuridicalId, tmpData.ContractId, tmpData.GoodsId, tmpData.GoodsKindId  ORDER BY tmpData_next.OperDate ASC) AS Ord
                          FROM tmpData 
                              LEFT JOIN tmpData AS tmpData_next
                                                ON tmpData_next.OperDate > tmpData.OperDate
                                               AND tmpData_next.GoodsId = tmpData.GoodsId
                                               AND tmpData_next.ContractId = tmpData.ContractId
                                               AND tmpData_next.GoodsKindId = tmpData.GoodsKindId
                                               AND tmpData_next.JuridicalId = tmpData.JuridicalId
                         ) AS tmp
                    WHERE tmp.Ord = 1
                    )


       SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate      ::TDateTime  AS OperDate
           , Movement.EndBeginDate  ::TDateTime  AS EndBeginDate
           , Movement.OperDate_next ::TDateTime  AS EndBeginDate_calc

           , View_Contract.ContractId            AS ContractId
           , View_Contract.ContractCode          AS ContractCode
           , View_Contract.InvNumber             AS ContractName
           , View_Contract.StartDate             AS StartDate_Contract
           , View_Contract.ContractKindName
           , View_Contract.ContractStateKindId
           , View_Contract.ContractStateKindCode
           , View_Contract.ContractStateKindName
           , Object_InfoMoney_View.InfoMoneyGroupCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationCode
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           , Object_PaidKind.Id            AS PaidKindId
           , Object_PaidKind.ValueData     AS PaidKindName
           , tmpContract_param.PersonalId
           , tmpContract_param.PersonalCode
           , tmpContract_param.PersonalName
           , tmpContract_param.PersonalTradeId
           , tmpContract_param.PersonalTradeCode
           , tmpContract_param.PersonalTradeName
           
           , Object_Juridical.Id                 AS JuridicalId
           , Object_Juridical.ValueData          AS JuridicalName

           , Object_Currency.Id                  AS CurrencyId
           , Object_Currency.ValueData           AS CurrencyName
          
           , MovementFloat_DiffPrice.ValueData  ::TFloat AS DiffPrice
           , MovementFloat_RoundPrice.ValueData ::TFloat AS RoundPrice
           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS PriceWithVAT
           , COALESCE (MovementBoolean_MultWithVAT.ValueData, FALSE)  :: Boolean AS isMultWithVAT           
           ----
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , tmpGoods_param.GoodsGroupNameFull
           , tmpGoods_param.MeasureName
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , MIFloat_Price.ValueData   ::TFloat AS Price
           , COALESCE (MIFloat_ChangePrice.ValueData, 0)   :: TFloat AS ChangePrice
           , COALESCE (MIFloat_ChangePercent.ValueData, 0) :: TFloat AS ChangePercent 
           , COALESCE (MIFloat_CountForAmount.ValueData,1) :: TFloat AS CountForAmount
           , COALESCE (MIFloat_CountForPrice.ValueData,1)  :: TFloat AS CountForPrice

           , MIString_Comment.ValueData                    :: TVarChar AS Comment         
           , COALESCE (MIBoolean_BonusNo.ValueData, FALSE) ::Boolean AS isBonusNo 

           
       FROM tmpRez AS Movement
            LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = Movement.ContractId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement.JuridicalId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId
            LEFT JOIN tmpInfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
            LEFT JOIN tmpContract_param ON tmpContract_param.ContractId = Movement.ContractId

           /* LEFT JOIN tmpMovementDate AS MovementDate_EndBegin
                                      ON MovementDate_EndBegin.MovementId = Movement.Id
                                     AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()  
           */

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                         ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_MultWithVAT
                                         ON MovementBoolean_MultWithVAT.MovementId = Movement.Id
                                        AND MovementBoolean_MultWithVAT.DescId = zc_MovementBoolean_MultWithVAT()

            LEFT JOIN tmpMovementFloat AS MovementFloat_DiffPrice
                                       ON MovementFloat_DiffPrice.MovementId = Movement.Id
                                      AND MovementFloat_DiffPrice.DescId = zc_MovementFloat_DiffPrice()
            LEFT JOIN tmpMovementFloat AS MovementFloat_RoundPrice
                                       ON MovementFloat_RoundPrice.MovementId = Movement.Id
                                      AND MovementFloat_RoundPrice.DescId = zc_MovementFloat_RoundPrice()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Currency
                                            ON MovementLinkObject_Currency.MovementId = Movement.Id
                                           AND MovementLinkObject_Currency.DescId = zc_MovementLinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MovementLinkObject_Currency.ObjectId
 
            ---       
           -- INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
            
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId --MovementItem.ObjectId
            LEFT JOIN tmpGoods_param ON tmpGoods_param.GoodsId = Movement.GoodsId --MovementItem.ObjectId

           /* LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
            */
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Movement.GoodsKindId

            LEFT JOIN tmpMI_Float AS MIFloat_Price
                                  ON MIFloat_Price.MovementItemId = Movement.MovementItemId --MovementItem.Id
                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN tmpMI_Float AS MIFloat_ChangePrice
                                  ON MIFloat_ChangePrice.MovementItemId = Movement.MovementItemId --
                                 AND MIFloat_ChangePrice.DescId = zc_MIFloat_ChangePrice()
            LEFT JOIN tmpMI_Float AS MIFloat_ChangePercent
                                  ON MIFloat_ChangePercent.MovementItemId = Movement.MovementItemId --
                                 AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
            LEFT JOIN tmpMI_Float AS MIFloat_CountForAmount
                                  ON MIFloat_CountForAmount.MovementItemId = Movement.MovementItemId --
                                 AND MIFloat_CountForAmount.DescId = zc_MIFloat_CountForAmount()
            LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                  ON MIFloat_CountForPrice.MovementItemId = Movement.MovementItemId --
                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN tmpMI_String AS MIString_Comment
                                   ON MIString_Comment.MovementItemId = Movement.MovementItemId --
                                  AND MIString_Comment.DescId = zc_MIString_Comment()
 
            LEFT JOIN tmpMI_Boolean AS MIBoolean_BonusNo
                                    ON MIBoolean_BonusNo.MovementItemId = Movement.MovementItemId --
                                   AND MIBoolean_BonusNo.DescId = zc_MIBoolean_BonusNo()

   
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.11.24         *
*/

-- тест
-- select * from gpReport_ContractGoodsMovement(inStartDate := ('13.11.2024')::TDateTime , inEndDate := ('13.11.2024')::TDateTime, inContractId :=6583556 ,  inSession := '5');

