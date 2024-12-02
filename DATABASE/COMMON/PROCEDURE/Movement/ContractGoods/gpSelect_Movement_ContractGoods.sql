-- Function: gpSelect_Movement_ContractGoods()

DROP FUNCTION IF EXISTS gpSelect_Movement_ContractGoods (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ContractGoods(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, EndBeginDate TDateTime
             , StatusCode Integer, StatusName TVarChar

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
             , SiteTagId Integer, SiteTagName TVarChar
             , PriceListId_first Integer, PriceListName_first TVarChar
             , PriceListId_curr Integer, PriceListName_curr TVarChar
             
             , DiffPrice TFloat, RoundPrice TFloat
             , PriceWithVAT Boolean 
             , isMultWithVAT Boolean
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbIsDocumentUser Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ContractGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
     WITH 
     tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
   , tmpMov AS (SELECT Movement.*
                FROM tmpStatus
                     JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                  AND Movement.DescId = zc_Movement_ContractGoods()
                                  AND Movement.StatusId = tmpStatus.StatusId
                )

   , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                               FROM MovementLinkObject
                               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                 AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Contract())
                               )

   , tmpMovement AS (SELECT Movement.*
                          , MovementLinkObject_Contract.ObjectId AS ContractId
                          , ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                     FROM tmpMov AS Movement
                          LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Contract
                                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                               ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                     )

   , tmpContractPrice AS (SELECT tmp.ContractId
                               , MAX (CASE WHEN tmp.StartDate = StartDate_first THEN tmp.PriceListId ELSE 0 END) AS PriceListId_first
                               , MAX (tmp.PriceListId_curr) AS PriceListId_curr
                          FROM (SELECT ObjectLink_ContractPriceList_PriceList.ChildObjectId AS PriceListId
                                     , ObjectDate_StartDate.ValueData          :: TDateTime AS StartDate
                                     , ObjectDate_EndDate.ValueData            :: TDateTime AS EndDate
                                     , MIN (ObjectDate_StartDate.ValueData) OVER ()         AS StartDate_first
                                     , CASE WHEN ObjectDate_StartDate.ValueData <= tmp.OperDate AND ObjectDate_EndDate.ValueData >= tmp.OperDate
                                            THEN ObjectLink_ContractPriceList_PriceList.ChildObjectId
                                            ELSE 0
                                       END AS PriceListId_curr -- текущий прайс лист
                                     , tmp.ContractId
                                FROM (SELECT DISTINCT tmpMovement.ContractId, tmpMovement.OperDate FROM tmpMovement) AS tmp
                                 
                                      INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                            ON ObjectLink_ContractPriceList_Contract.ChildObjectId = tmp.ContractId
                                                           AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                            
                                      INNER JOIN Object AS Object_ContractPriceList
                                                        ON Object_ContractPriceList.Id = ObjectLink_ContractPriceList_Contract.ObjectId
                                                       AND Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                                                       AND Object_ContractPriceList.isErased = FALSE
                             
                                      LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                                           ON ObjectLink_ContractPriceList_PriceList.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                          AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                            
                                      LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                           ON ObjectDate_StartDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                          AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                      LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                           ON ObjectDate_EndDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                          AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()
                                ) AS tmp
                           WHERE tmp.StartDate = StartDate_first 
                              OR COALESCE (tmp.PriceListId_curr,0) <> 0
                           GROUP BY tmp.ContractId
                         )
       , tmpContract_View AS (SELECT *
                              FROM Object_Contract_View
                              WHERE Object_Contract_View.ContractId IN (SELECT DISTINCT tmpMovement.ContractId FROM tmpMovement)
                              )
       , tmpInfoMoney_View AS (SELECT *
                               FROM Object_InfoMoney_View
                               WHERE Object_InfoMoney_View.InfoMoneyId IN (SELECT DISTINCT tmpContract_View.InfoMoneyId FROM tmpContract_View)
                               )

       SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate ::TDateTime       AS OperDate
           , MovementDate_EndBegin.ValueData     AS EndBeginDate

           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName

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
           , Object_Personal.Id          AS PersonalId
           , Object_Personal.ObjectCode  AS PersonalCode
           , Object_Personal.ValueData   AS PersonalName
           , Object_PersonalTrade.Id          AS PersonalTradeId
           , Object_PersonalTrade.ObjectCode  AS PersonalTradeCode
           , Object_PersonalTrade.ValueData   AS PersonalTradeName
           
           , Object_Juridical.Id                 AS JuridicalId
           , Object_Juridical.ValueData          AS JuridicalName

           , Object_Currency.Id                  AS CurrencyId
           , Object_Currency.ValueData           AS CurrencyName

           , COALESCE (Object_SiteTag.Id, 0)         ::Integer  AS SiteTagId
           , COALESCE (Object_SiteTag.ValueData, '') ::TVarChar AS SiteTagName

           , Object_PriceList_first.Id           AS PriceListId_first
           , Object_PriceList_first.ValueData    AS PriceListName_first
           , Object_PriceList_curr.Id            AS PriceListId_curr
           , Object_PriceList_curr.ValueData     AS PriceListName_curr
           
           , MovementFloat_DiffPrice.ValueData  ::TFloat AS DiffPrice
           , MovementFloat_RoundPrice.ValueData ::TFloat AS RoundPrice           

           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS PriceWithVAT
           , COALESCE (MovementBoolean_MultWithVAT.ValueData, FALSE)  :: Boolean AS isMultWithVAT

           , MovementString_Comment.ValueData    AS Comment

           , Object_Insert.ValueData             AS InsertName
           , MovementDate_Insert.ValueData       AS InsertDate
           , Object_Update.ValueData             AS UpdateName
           , MovementDate_Update.ValueData       AS UpdateDate
           
       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId = Movement.ContractId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement.JuridicalId

            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_MultWithVAT
                                      ON MovementBoolean_MultWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_MultWithVAT.DescId = zc_MovementBoolean_MultWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_DiffPrice
                                    ON MovementFloat_DiffPrice.MovementId = Movement.Id
                                   AND MovementFloat_DiffPrice.DescId = zc_MovementFloat_DiffPrice()
            LEFT JOIN MovementFloat AS MovementFloat_RoundPrice
                                    ON MovementFloat_RoundPrice.MovementId = Movement.Id
                                   AND MovementFloat_RoundPrice.DescId = zc_MovementFloat_RoundPrice()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Currency
                                         ON MovementLinkObject_Currency.MovementId = Movement.Id
                                        AND MovementLinkObject_Currency.DescId = zc_MovementLinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MovementLinkObject_Currency.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SiteTag
                                         ON MovementLinkObject_SiteTag.MovementId = Movement.Id
                                        AND MovementLinkObject_SiteTag.DescId = zc_MovementLinkObject_SiteTag()
            LEFT JOIN Object AS Object_SiteTag ON Object_SiteTag.Id = MovementLinkObject_SiteTag.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId
            
            LEFT JOIN tmpContractPrice ON tmpContractPrice.ContractId = Movement.ContractId

            LEFT JOIN Object AS Object_PriceList_first ON Object_PriceList_first.Id = tmpContractPrice.PriceListId_first
            LEFT JOIN Object AS Object_PriceList_curr ON Object_PriceList_curr.Id = tmpContractPrice.PriceListId_curr

            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId
            LEFT JOIN tmpInfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                 ON ObjectLink_Contract_Personal.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId               

            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                 ON ObjectLink_Contract_PersonalTrade.ObjectId = View_Contract.ContractId 
                                AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Contract_PersonalTrade.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.12.24         *
 15.11.24         *
 08.11.23         * 
 15.09.22         *
 05.07.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ContractGoods (inStartDate:= '30.11.2017', inEndDate:= '30.11.2017', inJuridicalBasisId:=0, inIsErased := FALSE, inSession:= '2')
