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
             , PaidKindName TVarChar, InfoMoneyName TVarChar
             , StartDate TDateTime, EndDate_real TDateTime, EndDate TVarChar
             , Amount TFloat, AmountRemains TFloat, AmountPartner TFloat, AmountPlan TFloat
             , AmountStart TFloat
             , BankName TVarChar, MFO TVarChar, BankAccountId Integer, BankAccountName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOrderFinanceId Integer;
  DECLARE vbBankAccountMainId Integer;
  DECLARE vbOperDate TDateTime;
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
     vbBankAccountMainId := (SELECT MovementLinkObject.ObjectId AS Id
                             FROM MovementLinkObject
                             WHERE MovementLinkObject.MovementId = inMovementId
                               AND MovementLinkObject.DescId = zc_MovementLinkObject_BankAccount()
                            );
     vbOperDate := (SELECT Movement.OperDate
                    FROM Movement
                    WHERE Movement.Id = inMovementId
                    );

--   select DISCTINCT zc_ObjectLink_Contract_Juridical если zc_ObjectLink_Contract_InfoMoney соответсвует соотвю списку полученному из zc_ObjectLink_OrderFinanceProperty_Object
     
     RETURN QUERY
     WITH
/*        tmpOrderFinanceProperty AS (SELECT DISTINCT OrderFinanceProperty_Object.ChildObjectId AS Id
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

      , tmpJuridicalOrderFinance AS (SELECT OL_JuridicalOrderFinance_Juridical.ChildObjectId   AS JuridicalId
                                          , OL_JuridicalOrderFinance_BankAccount.ChildObjectId AS BankAccountId
                                          , OL_JuridicalOrderFinance_InfoMoney.ChildObjectId   AS InfoMoneyId
                                     FROM Object AS Object_JuridicalOrderFinance
                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_Juridical
                                                              ON OL_JuridicalOrderFinance_Juridical.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_Juridical.DescId = zc_ObjectLink_JuridicalOrderFinance_Juridical()
                              
                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_BankAccount
                                                              ON OL_JuridicalOrderFinance_BankAccount.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_BankAccount.DescId = zc_ObjectLink_JuridicalOrderFinance_BankAccount()
                                        
                                         LEFT JOIN ObjectLink AS OL_JuridicalOrderFinance_InfoMoney
                                                              ON OL_JuridicalOrderFinance_InfoMoney.ObjectId = Object_JuridicalOrderFinance.Id
                                                             AND OL_JuridicalOrderFinance_InfoMoney.DescId = zc_ObjectLink_JuridicalOrderFinance_InfoMoney()
                              
                                     WHERE Object_JuridicalOrderFinance.DescId = zc_Object_JuridicalOrderFinance()
                                       AND Object_JuridicalOrderFinance.isErased = FALSE
                                     )
                                     */
                                     
          -- если в справ. назначение платежа пусто, надо для таких договоров на показать все делать поиск последнего из банковской выписки, за последний месяц
          tmp_Comment AS (SELECT *
                          FROM (SELECT DISTINCT
                                       Object_MoneyPlace.Id               AS JuridicalId
                                     , MILinkObject_InfoMoney.ObjectId    AS InfoMoneyId
                                     , MovementItem.ObjectId              AS BankAccountId_main
                                     , MILinkObject_BankAccount.ObjectId  AS BankAccountId
                                     , MIString_Comment.ValueData         AS Comment
                                     , ROW_NUMBER() OVER (Partition by  Object_MoneyPlace.Id, MILinkObject_InfoMoney.ObjectId, MovementItem.ObjectId ORDER BY Movement.Id DESC ) AS Ord_byComment   -- комментарий последнего документа
                                FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                                            AND MovementItem.DescId = zc_MI_Master()
                                                            AND COALESCE (MovementItem.Amount,0) < 0

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                      ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                     INNER JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
                                                                        AND Object_MoneyPlace.DescId = zc_Object_Juridical()

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                     INNER JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                                                      ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()

                                     LEFT JOIN MovementItemString AS MIString_Comment
                                                                  ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                 AND MIString_Comment.DescId = zc_MIString_Comment()
                
                                WHERE Movement.DescId = zc_Movement_BankAccount()
                                  AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 MONTH' AND vbOperDate
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND MovementItem.ObjectId = vbBankAccountMainId   --4529011   --  р/сч. ОТП банк
                                ) AS tmp
                          WHERE tmp.Ord_byComment = 1
                          )

   , tmpJuridicalOrderFinance AS (SELECT DISTINCT
                                         tmp.BankAccountId
                                       , tmp.JuridicalId
                                       , tmp.InfoMoneyId
                                       , tmp.Comment
                                  FROM gpSelect_Object_JuridicalOrderFinance_choice (inBankAccountMainId:= vbBankAccountMainId
                                                                                   , inOrderFinanceId := COALESCE (vbOrderFinanceId,0)
                                                                                   , inisShowAll      := FALSE 
                                                                                   , inisErased       := FALSE
                                                                                   , inSession        := inSession) AS tmp
                                  )
--select * from gpSelect_Object_JuridicalOrderFinance_choice(inBankAccountMainId := 351627 , inOrderFinanceId := 0 , inShowAll := 'False' , inisErased := 'False' ,  inSession := '5');
   , tmpData AS (SELECT DISTINCT
                        ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                      , ObjectLink_Contract_InfoMoney.ObjectId      AS ContractId
                      , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                      , tmpJuridicalOrderFinance.BankAccountId      AS BankAccountId
                      , COALESCE (tmpJuridicalOrderFinance.Comment, tmp_Comment.Comment) ::TVarChar AS Comment
                 FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                      LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                           ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId
                                          AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

                      INNER JOIN tmpJuridicalOrderFinance ON tmpJuridicalOrderFinance.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId
                                                         AND tmpJuridicalOrderFinance.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId

                      INNER JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                            ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Contract_InfoMoney.ObjectId
                                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                                           AND ObjectLink_Contract_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()

                      LEFT JOIN tmp_Comment ON tmp_Comment.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId
                                           AND tmp_Comment.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
                 WHERE ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                )

   , tmpMI AS (SELECT MovementItem.Id                   AS Id
                    , MovementItem.ObjectId             AS JuridicalId
                    , MILinkObject_Contract.ObjectId    AS ContractId
                    , MovementItem.Amount               AS Amount
                    , MIFloat_AmountRemains.ValueData   AS AmountRemains
                    , MIFloat_AmountPartner.ValueData   AS AmountPartner
                    , MIFloat_AmountPlan.ValueData      AS AmountPlan
                    , MIFloat_AmountStart.ValueData     AS AmountStart
                    , MILinkObject_BankAccount.ObjectId AS BankAccountId
                    , MIString_Comment.ValueData        AS Comment
                    , Object_Insert.ValueData           AS InsertName
                    , Object_Update.ValueData           AS UpdateName
                    , MIDate_Insert.ValueData           AS InsertDate
                    , MIDate_Update.ValueData           AS UpdateDate
                    , MovementItem.isErased             AS isErased
        
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

                    LEFT JOIN MovementItemFloat AS MIFloat_AmountStart
                                                ON MIFloat_AmountStart.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountStart.DescId = zc_MIFloat_AmountStart()

                    LEFT JOIN MovementItemString AS MIString_Comment
                                                 ON MIString_Comment.MovementItemId = MovementItem.Id
                                                AND MIString_Comment.DescId = zc_MIString_Comment()
        
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                     ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                    LEFT JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                                     ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()

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
           --, ObjectDate_Start.ValueData       AS StartDate
           , View_Contract.StartDate
           , View_Contract.EndDate_real
           , (''|| CASE WHEN View_Contract.ContractTermKindId = zc_Enum_ContractTermKind_Long() THEN '* ' ELSE '' END
                || (LPAD (EXTRACT (Day FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||LPAD (EXTRACT (Month FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||EXTRACT (YEAR FROM View_Contract.EndDate_term) :: TVarChar)
             ) ::TVarChar AS EndDate
                             
           , tmpMI.Amount        ::TFloat
           , tmpMI.AmountRemains ::TFloat
           , tmpMI.AmountPartner ::TFloat
           , tmpMI.AmountPlan    ::TFloat
           , tmpMI.AmountStart   ::TFloat
           

           , Partner_BankAccount_View.BankName
           , Partner_BankAccount_View.MFO
           , Partner_BankAccount_View.Id      AS BankAccountId
           , Partner_BankAccount_View.Name    AS BankAccountName

           --, COALESCE (tmpMI.Comment, tmpData.Comment) ::TVarChar AS Comment
           , CASE WHEN COALESCE (tmpMI.Comment,'') = '' THEN COALESCE (tmpData.Comment,'') ELSE COALESCE (tmpMI.Comment,'') END ::TVarChar AS Comment

           , tmpMI.InsertName
           , tmpMI.UpdateName
           , tmpMI.InsertDate
           , tmpMI.UpdateDate

           , COALESCE (tmpMI.isErased, FALSE) AS isErased

       FROM tmpData
            FULL JOIN tmpMI ON tmpMI.JuridicalId = tmpData.JuridicalId
                           AND tmpMI.ContractId  = tmpData.ContractId
            
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (tmpData.JuridicalId, tmpMI.JuridicalId)
            LEFT JOIN Object AS Object_Contract  ON Object_Contract.Id  = COALESCE (tmpData.ContractId, tmpMI.ContractId)
            
            LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                 ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId
            
            --LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = COALESCE (tmpData.InfoMoneyId, tmpMI.InfoMoneyId)
            
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

            LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = COALESCE (tmpMI.BankAccountId, tmpData.BankAccountId)

           /* LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                 ON ObjectLink_Contract_PaidKind.ObjectId = tmpData.ContractId
                                AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_Contract_PaidKind.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = tmpData.ContractId
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                AND Object_Contract.ValueData <> '-'
           */
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = tmpData.ContractId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId
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
           --, ObjectDate_Start.ValueData       AS StartDate
           , View_Contract.StartDate
           , View_Contract.EndDate_real
           , (''|| CASE WHEN View_Contract.ContractTermKindId = zc_Enum_ContractTermKind_Long() THEN '* ' ELSE '' END
                || (LPAD (EXTRACT (Day FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||LPAD (EXTRACT (Month FROM View_Contract.EndDate_term) :: TVarChar,2,'0') ||'.'||EXTRACT (YEAR FROM View_Contract.EndDate_term) :: TVarChar)
             ) ::TVarChar AS EndDate


           , MovementItem.Amount              :: TFloat AS Amount
           , MIFloat_AmountRemains.ValueData  :: TFloat AS AmountRemains
           , MIFloat_AmountPartner.ValueData  :: TFloat AS AmountPartner
           , MIFloat_AmountPlan.ValueData     :: TFloat AS AmountPlan
           , MIFloat_AmountStart.ValueData    :: TFloat AS AmountStart

           , Partner_BankAccount_View.BankName
           , Partner_BankAccount_View.MFO
           , Partner_BankAccount_View.Id      AS BankAccountId
           , Partner_BankAccount_View.Name    AS BankAccountName

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

            LEFT JOIN MovementItemFloat AS MIFloat_AmountStart
                                        ON MIFloat_AmountStart.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountStart.DescId = zc_MIFloat_AmountStart()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                             ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = MILinkObject_BankAccount.ObjectId

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


            /*LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                 ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_Contract_PaidKind.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_Contract.Id
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                AND Object_Contract.ValueData <> '-'
             */
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = Object_Contract.Id
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId
            ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.21         * AmountStart
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderFinance (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')