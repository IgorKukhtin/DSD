-- Function: gpSelect_MovementItem_OrderFinance()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderFinance (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderFinance(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , OKPO TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindName TVarChar, InfoMoneyName TVarChar, StartDate TDateTime
             , Amount TFloat, AmountRemains TFloat, AmountPartner TFloat, AmountPlan TFloat
             , Comment TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOrderFinanceId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);


     IF inShowAll THEN
     
     vbOrderFinanceId := (SELECT MovementLinkObject.ObjectId AS Id
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.MovementId = inMovementId
                            AND MovementLinkObject.DescId = zc_MovementLinkObject_OrderFinance()
                         );
--   select DISCTINCT zc_ObjectLink_Contract_Juridical если zc_ObjectLink_Contract_InfoMoney соответсвует соотвю списку полученному из zc_ObjectLink_OrderFinanceProperty_Object
     
     RETURN QUERY
     WITH
     tmpOrderFinanceProperty AS (SELECT DISTINCT OrderFinanceProperty_Object.ChildObjectId AS Id
                                 FROM ObjectLink AS OrderFinanceProperty_OrderFinance
                                      INNER JOIN ObjectLink AS OrderFinanceProperty_Object
                                                            ON OrderFinanceProperty_Object.ObjectId = OrderFinanceProperty_OrderFinance.ObjectId
                                                           AND OrderFinanceProperty_Object.DescId = zc_ObjectLink_OrderFinanceProperty_Object()
                                                           AND COALESCE (OrderFinanceProperty_Object.ChildObjectId,0) <> 0

                                 WHERE OrderFinanceProperty_OrderFinance.ChildObjectId = vbOrderFinanceId
                                   AND OrderFinanceProperty_OrderFinance.DescId = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                )
   , tmpInfoMoney AS (SELECT DISTINCT Object_InfoMoney_View.InfoMoneyId
                      FROM Object_InfoMoney_View
                           INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyId
                                                               OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyDestinationId
                                                               OR tmpOrderFinanceProperty.Id = Object_InfoMoney_View.InfoMoneyGroupId)
                      )

   , tmpData AS (SELECT DISTINCT 
                        ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                      , ObjectLink_Contract_InfoMoney.ObjectId      AS ContractId
                      , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                 FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                      INNER JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
                        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                             ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId
                                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                 WHERE ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                )

   , tmpMI AS (SELECT MovementItem.Id                  AS Id
                    , MovementItem.ObjectId            AS JuridicalId
                    , MILinkObject_Contract.ObjectId   AS ContractId
                    , MovementItem.Amount              AS Amount
                    , MIFloat_AmountRemains.ValueData  AS AmountRemains
                    , MIFloat_AmountPartner.ValueData  AS AmountPartner
                    , MIFloat_AmountPlan.ValueData     AS AmountPlan
                    , MIString_Comment.ValueData       AS Comment
                    , Object_Insert.ValueData          AS InsertName
                    , Object_Update.ValueData          AS UpdateName
                    , MIDate_Insert.ValueData          AS InsertDate
                    , MIDate_Update.ValueData          AS UpdateDate
                    , MovementItem.isErased            AS isErased
        
               FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Master()
                                     AND MovementItem.isErased   = tmpIsErased.isErased
        
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
        
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
        
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan
                                                ON MIFloat_AmountPlan.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountPlan.DescId = zc_MIFloat_AmountPlan()
        
                    LEFT JOIN MovementItemString AS MIString_Comment
                                                 ON MIString_Comment.MovementItemId = MovementItem.Id
                                                AND MIString_Comment.DescId = zc_MIString_Comment()
        
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                     ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                    LEFT JOIN MovementItemDate AS MIDate_Insert
                                               ON MIDate_Insert.MovementItemId = MovementItem.Id
                                              AND MIDate_Insert.DescId = zc_MIDate_Insert()
                    LEFT JOIN MovementItemDate AS MIDate_Update
                                               ON MIDate_Update.MovementItemId = MovementItem.Id
                                              AND MIDate_Update.DescId = zc_MIDate_Update()

                    LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                     ON MILO_Insert.MovementItemId = MovementItem.Id
                                                    AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                    LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                    LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                     ON MILO_Update.MovementItemId = MovementItem.Id
                                                    AND MILO_Update.DescId = zc_MILinkObject_Update()
                    LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
                    )

       -- Результат
       SELECT
             tmpMI.Id                         AS Id
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , ObjectHistory_JuridicalDetails_View.OKPO

           , Object_Contract.Id               AS ContractId
           , Object_Contract.ObjectCode       AS ContractCode
           , Object_Contract.ValueData        AS ContractName
           , Object_PaidKind.ValueData        AS PaidKindName
           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , ObjectDate_Start.ValueData       AS StartDate
           
           , tmpMI.Amount
           , tmpMI.AmountRemains
           , tmpMI.AmountPartner
           , tmpMI.AmountPlan
           , tmpMI.Comment

           , tmpMI.InsertName
           , tmpMI.UpdateName
           , tmpMI.InsertDate
           , tmpMI.UpdateDate

           , COALESCE (tmpMI.isErased, FALSE) AS isErased

       FROM tmpData
            FULL JOIN tmpMI ON tmpMI.JuridicalId = tmpData.JuridicalId
                           AND tmpMI.ContractId  = tmpData.ContractId
            
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
            LEFT JOIN Object AS Object_Contract  ON Object_Contract.Id  = tmpData.ContractId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpData.InfoMoneyId
            
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
            
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                 ON ObjectLink_Contract_PaidKind.ObjectId = tmpData.ContractId
                                AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_Contract_PaidKind.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = tmpData.ContractId
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                AND Object_Contract.ValueData <> '-'
            
            ;
       ELSE
     -- Результат такой
     RETURN QUERY
       -- Результат
       SELECT
             MovementItem.Id                  AS Id
           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , ObjectHistory_JuridicalDetails_View.OKPO

           , Object_Contract.Id               AS ContractId
           , Object_Contract.ObjectCode       AS ContractCode
           , Object_Contract.ValueData        AS ContractName
           , Object_PaidKind.ValueData        AS PaidKindName
           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , ObjectDate_Start.ValueData       AS StartDate
           
           , MovementItem.Amount              AS Amount
           , MIFloat_AmountRemains.ValueData  AS AmountRemains
           , MIFloat_AmountPartner.ValueData  AS AmountPartner
           , MIFloat_AmountPlan.ValueData     AS AmountPlan
           , MIString_Comment.ValueData       AS Comment

           , Object_Insert.ValueData          AS InsertName
           , Object_Update.ValueData          AS UpdateName
           , MIDate_Insert.ValueData          AS InsertDate
           , MIDate_Update.ValueData          AS UpdateDate

           , MovementItem.isErased            AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                        ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan
                                        ON MIFloat_AmountPlan.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPlan.DescId = zc_MIFloat_AmountPlan()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId = MovementItem.Id
                                      AND MIDate_Update.DescId = zc_MIDate_Update()

            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                             ON MILO_Insert.MovementItemId = MovementItem.Id
                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_Update
                                             ON MILO_Update.MovementItemId = MovementItem.Id
                                            AND MILO_Update.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

            LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                 ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId


            LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                 ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_Contract_PaidKind.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_Contract.Id
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                AND Object_Contract.ValueData <> '-'
            ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderFinance (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderFinance (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')