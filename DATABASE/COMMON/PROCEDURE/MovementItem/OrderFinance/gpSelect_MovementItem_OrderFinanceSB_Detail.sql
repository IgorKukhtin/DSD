-- Function: gpSelect_MovementItem_OrderFinanceSB_Detail()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderFinanceSB_Detail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderFinanceSB_Detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar

               -- Первичный план на неделю
             , Amount               TFloat
               -- Платежный план на неделю
             , AmountPlan_next      TFloat
               -- Дата Платежный план на неделю
             , OperDate_next        TDateTime
               -- Согласовано к оплате
             , Amount_Detail        TFloat
               -- Дата Согласовано к оплате
             , OperDate_Detail      TDateTime
               -- Платим да/нет
             , isAmountPlan         Boolean

               --
             , Comment_master       TVarChar
             , Comment              TVarChar

             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean

               -- Child
             , MovementItemId_Child    Integer
             , InvNumber_Child         TVarChar
             , InvNumber_Invoice_Child TVarChar
             , GoodsName_Child         TVarChar

               -- Child
             , MovementItemId_Detail   Integer
              )
AS
$BODY$
  DECLARE vbUserId            Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderFinance());
     vbUserId:= lpGetUserBySession (inSession);





     -- Результат такой
     RETURN QUERY
       WITH
       --данные из мастера
       tmpMI_Master AS (SELECT MovementItem.Id
                             , MovementItem.ObjectId             AS JuridicalId
                             , MILinkObject_Contract.ObjectId    AS ContractId
                             , MovementItem.isErased
                               -- Первичный план на неделю
                             , MovementItem.Amount
                               -- Платежный план на неделю
                             , MIFloat_AmountPlan_next.ValueData AS AmountPlan_next
                             , MIDate_Amount_next.ValueData      AS OperDate_next
                               --
                             , MIString_Comment.ValueData        AS Comment

                        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                             JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = tmpIsErased.isErased
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                             -- Платежный план на неделю
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_next
                                                         ON MIFloat_AmountPlan_next.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPlan_next.DescId         = zc_MIFloat_AmountPlan_next()
                             -- Дата Платежный план
                             LEFT JOIN MovementItemDate AS MIDate_Amount_next
                                                        ON MIDate_Amount_next.MovementItemId = MovementItem.Id
                                                       AND MIDate_Amount_next.DescId         = zc_MIDate_Amount_next()
                             -- 
                             LEFT JOIN MovementItemString AS MIString_Comment
                                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                                         AND MIString_Comment.DescId = zc_MIString_Comment()
                        )
        -- данные из чайлда
      , tmpMI_Child AS (SELECT MovementItem.Id
                             , MovementItem.ParentId
                             , MovementItem.isErased
                               -- Первичный план на неделю
                             , MovementItem.Amount
                               -- Платежный план на неделю
                             , MIFloat_AmountPlan_next.ValueData AS AmountPlan_next
                             , MIDate_Amount_next.ValueData      AS OperDate_next

                             , COALESCE (MIString_GoodsName.ValueData, '')                  AS GoodsName
                             , COALESCE (MIString_InvNumber.ValueData, '')                  AS InvNumber
                             , COALESCE (MIString_InvNumber_Invoice.ValueData, '')          AS InvNumber_Invoice
                             , COALESCE (MIString_Comment.ValueData, '')                    AS Comment

                        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                             JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                              AND MovementItem.DescId     = zc_MI_Child()
                                              AND MovementItem.isErased   = tmpIsErased.isErased
                             -- Платежный план на неделю
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_next
                                                         ON MIFloat_AmountPlan_next.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPlan_next.DescId         = zc_MIFloat_AmountPlan_next()
                             -- Дата Платежный план
                             LEFT JOIN MovementItemDate AS MIDate_Amount_next
                                                        ON MIDate_Amount_next.MovementItemId = MovementItem.Id
                                                       AND MIDate_Amount_next.DescId         = zc_MIDate_Amount_next()
                             --
                             LEFT JOIN MovementItemString AS MIString_GoodsName
                                                          ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                                         AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
                             LEFT JOIN MovementItemString AS MIString_InvNumber
                                                          ON MIString_InvNumber.MovementItemId = MovementItem.Id
                                                         AND MIString_InvNumber.DescId = zc_MIString_InvNumber()
                             LEFT JOIN MovementItemString AS MIString_InvNumber_Invoice
                                                          ON MIString_InvNumber_Invoice.MovementItemId = MovementItem.Id
                                                         AND MIString_InvNumber_Invoice.DescId = zc_MIString_InvNumber_Invoice()
                             LEFT JOIN MovementItemString AS MIString_Comment
                                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                                         AND MIString_Comment.DescId = zc_MIString_Comment()
                        )

       -- данные из Detail
     , tmpMI_Detail AS (SELECT MovementItem.Id
                             , MovementItem.ParentId
                             , MovementItem.isErased
                               -- Согласовано к оплате
                             , MovementItem.Amount
                               -- Дата Согласовано к оплате
                             , MIDate_Amount.ValueData          AS OperDate
                               -- Платим да/нет
                             , COALESCE (MIBoolean_AmountPlan.ValueData, TRUE) :: Boolean AS isAmountPlan

                             , Object_Insert.ValueData          AS InsertName
                             , Object_Update.ValueData          AS UpdateName
                             , MIDate_Insert.ValueData          AS InsertDate
                             , MIDate_Update.ValueData          AS UpdateDate

                        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                             JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                              AND MovementItem.DescId     = zc_MI_Detail()
                                              AND MovementItem.isErased   = tmpIsErased.isErased
                             -- Дата Согласовано к оплате
                             LEFT JOIN MovementItemDate AS MIDate_Amount
                                                        ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                       AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                             -- Платим (да/нет)
                             LEFT JOIN MovementItemBoolean AS MIBoolean_AmountPlan
                                                           ON MIBoolean_AmountPlan.MovementItemId = MovementItem.Id
                                                          AND MIBoolean_AmountPlan.DescId = zc_MIBoolean_AmountPlan()
                             --
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
       -- master + Child
     , tmpMI_ord AS (SELECT ROW_NUMBER() OVER (PARTITION BY COALESCE (tmpMI_Child.Id, tmpMI_Master.Id) ORDER BY COALESCE (tmpMI_Detail_1.Id, tmpMI_Detail_2.Id) ASC) AS Ord
                            -- master
                          , tmpMI_Master.Id
                          , Object_Juridical.Id           AS JuridicalId
                          , Object_Juridical.ObjectCode   AS JuridicalCode
                          , Object_Juridical.ValueData    AS JuridicalName
                          , Object_Contract.Id            AS ContractId
                          , Object_Contract.ObjectCode    AS ContractCode
                          , Object_Contract.ValueData     AS ContractName
                          , Object_PaidKind.Id            AS PaidKindId
                          , Object_PaidKind.ValueData     AS PaidKindName
                          , Object_InfoMoney.ObjectCode   AS InfoMoneyCode
                          , Object_InfoMoney.ValueData    AS InfoMoneyName

                            -- Первичный план на неделю
                          , COALESCE (tmpMI_Child.Amount, tmpMI_Master.Amount)                     :: TFloat    AS Amount
                            -- Платежный план на неделю
                          , COALESCE (tmpMI_Child.AmountPlan_next, tmpMI_Master.AmountPlan_next)   :: TFloat    AS AmountPlan_next
                          , COALESCE (tmpMI_Child.OperDate_next, tmpMI_Master.OperDate_next)       :: TDateTime AS OperDate_next

                          , COALESCE (tmpMI_Child.isErased, tmpMI_Master.isErased)                 :: Boolean   AS isErased_master
                            --
                          , tmpMI_Master.Comment                                                   :: TVarChar  AS Comment_master
                          , COALESCE (tmpMI_Child.Comment, tmpMI_Master.Comment)                   :: TVarChar  AS Comment

                            -- Child
                          , tmpMI_Child.Id                ::Integer  AS MovementItemId_Child
                          , tmpMI_Child.InvNumber         ::TVarChar AS InvNumber_Child
                          , tmpMI_Child.InvNumber_Invoice ::TVarChar AS InvNumber_Invoice_Child
                          , tmpMI_Child.GoodsName         ::TVarChar AS GoodsName_Child
                            -- Detail
                          , COALESCE (tmpMI_Detail_1.Id, tmpMI_Detail_2.Id)                     ::Integer    AS MovementItemId_Detail
                          , COALESCE (tmpMI_Detail_1.OperDate, tmpMI_Detail_2.OperDate)         ::TDateTime  AS OperDate_Detail
                          , COALESCE (tmpMI_Detail_1.Amount, tmpMI_Detail_2.Amount)             ::TFloat     AS Amount_Detail
                          , COALESCE (tmpMI_Detail_1.isAmountPlan, tmpMI_Detail_2.isAmountPlan) ::Boolean    AS isAmountPlan
                          , COALESCE (tmpMI_Detail_1.isErased, tmpMI_Detail_2.isErased)         ::Boolean    AS isErased
                          , COALESCE (tmpMI_Detail_1.InsertName, tmpMI_Detail_2.InsertName)     ::TVarChar   AS InsertName
                          , COALESCE (tmpMI_Detail_1.UpdateName, tmpMI_Detail_2.UpdateName)     ::TVarChar   AS UpdateName
                          , COALESCE (tmpMI_Detail_1.InsertDate, tmpMI_Detail_2.InsertDate)     ::TDateTime  AS InsertDate
                          , COALESCE (tmpMI_Detail_1.InsertDate, tmpMI_Detail_2.InsertDate)     ::TDateTime  AS UpdateDate

                     FROM tmpMI_Master
                          LEFT JOIN tmpMI_Child  ON tmpMI_Child.ParentId = tmpMI_Master.Id
                          LEFT JOIN tmpMI_Detail AS tmpMI_Detail_1 ON tmpMI_Detail_1.ParentId = tmpMI_Master.Id
                          LEFT JOIN tmpMI_Detail AS tmpMI_Detail_2 ON tmpMI_Detail_2.ParentId = tmpMI_Child.Id
                          --
                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpMI_Master.JuridicalId
                          LEFT JOIN Object AS Object_Contract  ON Object_Contract.Id  = tmpMI_Master.ContractId
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                               ON ObjectLink_Contract_InfoMoney.ObjectId      = tmpMI_Master.ContractId
                                              AND ObjectLink_Contract_InfoMoney.DescId        = zc_ObjectLink_Contract_InfoMoney()
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                               ON ObjectLink_Contract_PaidKind.ObjectId      = tmpMI_Master.ContractId
                                              AND ObjectLink_Contract_PaidKind.DescId        = zc_ObjectLink_Contract_PaidKind()
                          LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId
                          LEFT JOIN Object AS Object_PaidKind  ON Object_PaidKind.Id  = ObjectLink_Contract_PaidKind.ChildObjectId
                     WHERE COALESCE (tmpMI_Detail_1.Id, tmpMI_Detail_2.Id) > 0
                    )

       -- Результат
       SELECT tmpMI.Id
            , tmpMI.JuridicalId
            , tmpMI.JuridicalCode
            , tmpMI.JuridicalName
            , tmpMI.ContractId
            , tmpMI.ContractCode
            , tmpMI.ContractName
            , tmpMI.PaidKindId
            , tmpMI.PaidKindName
            , tmpMI.InfoMoneyCode
            , tmpMI.InfoMoneyName

              -- Первичный план на неделю
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.Amount ELSE 0 END          :: TFloat    AS Amount
              -- Платежный план на неделю
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.AmountPlan_next ELSE 0 END :: TFloat    AS AmountPlan_next
              -- Дата Платежный план на неделю
            , tmpMI.OperDate_next                                           :: TDateTime AS OperDate_next
              -- Согласовано к оплате
            , tmpMI.Amount_Detail     :: TFloat    AS Amount_Detail
              -- Дата Согласовано к оплате
            , tmpMI.OperDate_Detail   :: TDateTime AS OperDate_Detail
              -- Платим да/нет
            , tmpMI.isAmountPlan      ::Boolean    AS isAmountPlan

              --
            , tmpMI.Comment_master    ::TVarChar AS Comment_master
            , tmpMI.Comment           ::TVarChar AS Comment

              --
            , tmpMI.InsertName
            , tmpMI.UpdateName
            , tmpMI.InsertDate
            , tmpMI.UpdateDate
              --
            , CASE WHEN tmpMI.isErased_master = TRUE OR tmpMI.isErased = TRUE THEN TRUE ELSE FALSE END ::Boolean AS isErased

              -- Child
            , tmpMI.MovementItemId_Child    ::Integer
            , tmpMI.InvNumber_Child         ::TVarChar
            , tmpMI.InvNumber_Invoice_Child ::TVarChar
            , tmpMI.GoodsName_Child         ::TVarChar

              -- Detail
            , tmpMI.MovementItemId_Detail   ::Integer

       FROM tmpMI_ord AS tmpMI
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.26         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderFinanceSB_Detail (inMovementId:= 33348246 , inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderFinanceSB_Detail (inMovementId:= 33348246 , inIsErased:= FALSE, inSession:= '9818')
