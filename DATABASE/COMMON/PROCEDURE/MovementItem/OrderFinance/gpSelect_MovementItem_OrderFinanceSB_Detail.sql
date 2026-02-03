-- Function: gpSelect_MovementItem_OrderFinanceSB_Detail()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderFinanceSB_Detail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderFinanceSB_Detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , OKPO TVarChar
             , ObjectDesc_ItemName TVarChar, JuridicalName_inf TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, NumGroup Integer
             , Condition TVarChar, ContractStateKindCode Integer
             , StartDate TDateTime, EndDate_real TDateTime, EndDate TVarChar, PersonalName_contract TVarChar
               -- *** Предварительный План на неделю
             , Amount               TFloat
               -- *** Дата предварительный план
             , OperDate_Amount      TDateTime
               --
             , AmountRemains TFloat
             , AmountSumm           TFloat
               -- План оплат
             , AmountPlan_1         TFloat
             , AmountPlan_2         TFloat
             , AmountPlan_3         TFloat
             , AmountPlan_4         TFloat
             , AmountPlan_5         TFloat
               -- План оплат - Итог
             , AmountPlan_total     TFloat

               -- Платим да/нет
             , isAmountPlan_1       Boolean
             , isAmountPlan_2       Boolean
             , isAmountPlan_3       Boolean
             , isAmountPlan_4       Boolean
             , isAmountPlan_5       Boolean

             , Comment              TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             --чайлд
             , MovementItemId_Child    Integer 
             , InvNumber_Child         TVarChar
             , InvNumber_Invoice_Child TVarChar
             , GoodsName_Child         TVarChar
             , Comment_Child           TVarChar
             , Comment_SB_Child        TVarChar
             , Amount_Child            TFloat
             , isSign_Child            Boolean
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
       tmpMI_Master AS (SELECT tmp.*
                        FROM gpSelect_MovementItem_OrderFinanceSB(inMovementId := inMovementId ::Integer
                                                                , inShowAll    := FALSE        ::Boolean       
                                                                , inIsErased   := inIsErased   ::Boolean
                                                                , inSession    := inSession    ::TVarChar
                                                                  ) AS tmp 
                        )
       --данные из чайлда
     , tmpMI_Child AS (SELECT tmp.*
                       FROM gpSelect_MovementItem_OrderFinance_Child(inMovementId := inMovementId ::Integer
                                                                   , inIsErased   := inIsErased   ::Boolean
                                                                   , inSession    := inSession    ::TVarChar
                                                                     ) AS tmp
                       WHERE COALESCE (tmp.Id,0) <> 0
                       )

      --master + Child 
     , tmpMI_ord AS (SELECT ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.Id ORDER BY tmpMI_Child.Id ASC) AS Ord
                          -- master
                          , tmpMI_Master.Id
                          , tmpMI_Master.JuridicalId
                          , tmpMI_Master.JuridicalCode
                          , tmpMI_Master.JuridicalName
                          , tmpMI_Master.OKPO
                          , tmpMI_Master.ObjectDesc_ItemName ::TVarChar
                          , tmpMI_Master.JuridicalName_inf   ::TVarChar
                          , tmpMI_Master.ContractId
                          , tmpMI_Master.ContractCode
                          , tmpMI_Master.ContractName
                          , tmpMI_Master.PaidKindId
                          , tmpMI_Master.PaidKindName
                          , tmpMI_Master.InfoMoneyCode
                          , tmpMI_Master.InfoMoneyName
                          , tmpMI_Master.NumGroup               ::Integer  AS NumGroup
                          , tmpMI_Master.Condition              ::TVarChar AS Condition
                          , tmpMI_Master.ContractStateKindCode  ::Integer  AS ContractStateKindCode
                          , tmpMI_Master.StartDate
                          , tmpMI_Master.EndDate_real
                          , tmpMI_Master.EndDate               ::TVarChar AS EndDate
                          , tmpMI_Master.PersonalName_contract ::TVarChar AS PersonalName_contract
                          , tmpMI_Master.Amount            :: TFloat AS Amount
                          , tmpMI_Master.OperDate_Amount   ::TDateTime AS OperDate_Amount
                          , tmpMI_Master.AmountRemains     :: TFloat AS AmountRemains
                          , tmpMI_Master.AmountSumm        :: TFloat AS AmountSumm
                          , tmpMI_Master.AmountPlan_1      :: TFloat AS AmountPlan_1
                          , tmpMI_Master.AmountPlan_2      :: TFloat AS AmountPlan_2
                          , tmpMI_Master.AmountPlan_3      :: TFloat AS AmountPlan_3
                          , tmpMI_Master.AmountPlan_4      :: TFloat AS AmountPlan_4
                          , tmpMI_Master.AmountPlan_5      :: TFloat AS AmountPlan_5
                          , tmpMI_Master.AmountPlan_total  :: TFloat AS AmountPlan_total
                          , tmpMI_Master.isAmountPlan_1    ::Boolean  AS isAmountPlan_1
                          , tmpMI_Master.isAmountPlan_2    ::Boolean  AS isAmountPlan_2
                          , tmpMI_Master.isAmountPlan_3    ::Boolean  AS isAmountPlan_3
                          , tmpMI_Master.isAmountPlan_4    ::Boolean  AS isAmountPlan_4
                          , tmpMI_Master.isAmountPlan_5    ::Boolean  AS isAmountPlan_5
                          , tmpMI_Master.Comment           ::TVarChar AS Comment
                          , tmpMI_Master.InsertName
                          , tmpMI_Master.UpdateName
                          , tmpMI_Master.InsertDate
                          , tmpMI_Master.UpdateDate
                          , tmpMI_Master.isErased
                          -- Child
                          , tmpMI_Child.Id                ::Integer  AS MovementItemId_Child
                          , tmpMI_Child.InvNumber         ::TVarChar AS InvNumber_Child
                          , tmpMI_Child.InvNumber_Invoice ::TVarChar AS InvNumber_Invoice_Child
                          , tmpMI_Child.GoodsName         ::TVarChar AS GoodsName_Child
                          , tmpMI_Child.Comment           ::TVarChar AS Comment_Child
                          , tmpMI_Child.Comment_SB        ::TVarChar AS Comment_SB_Child
                          , tmpMI_Child.Amount            ::TFloat   AS Amount_Child
                          , tmpMI_Child.isSign            ::Boolean  AS isSign_Child
                          , tmpMI_Child.isErased          ::Boolean  AS isErased_Child
                     FROM tmpMI_Master
                         LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id
                     )

       -- Результат
       SELECT tmpMI.Id
            , tmpMI.JuridicalId
            , tmpMI.JuridicalCode
            , tmpMI.JuridicalName
            , tmpMI.OKPO
            , tmpMI.ObjectDesc_ItemName ::TVarChar
            , tmpMI.JuridicalName_inf   ::TVarChar
            , tmpMI.ContractId
            , tmpMI.ContractCode
            , tmpMI.ContractName
            , tmpMI.PaidKindId
            , tmpMI.PaidKindName
 
            , tmpMI.InfoMoneyCode
            , tmpMI.InfoMoneyName
            , tmpMI.NumGroup               ::Integer  AS NumGroup
            , tmpMI.Condition              ::TVarChar AS Condition
            , tmpMI.ContractStateKindCode  ::Integer  AS ContractStateKindCode
              -- Договор с
            , tmpMI.StartDate
              -- Договор до
            , tmpMI.EndDate_real
            , tmpMI.EndDate               ::TVarChar AS EndDate
            , tmpMI.PersonalName_contract ::TVarChar AS PersonalName_contract
              -- Предварительный План на неделю
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.Amount ELSE 0 END :: TFloat AS Amount
              -- Дата предварительный план
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.OperDate_Amount ELSE Null END     ::TDateTime AS OperDate_Amount
              -- Нач. долг
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.AmountRemains ELSE 0 END          :: TFloat AS AmountRemains
              -- Приход
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.AmountSumm ELSE 0 END             :: TFloat AS AmountSumm
              -- План оплат
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.AmountPlan_1 ELSE 0 END     :: TFloat AS AmountPlan_1
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.AmountPlan_2 ELSE 0 END     :: TFloat AS AmountPlan_2
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.AmountPlan_3 ELSE 0 END     :: TFloat AS AmountPlan_3
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.AmountPlan_4 ELSE 0 END     :: TFloat AS AmountPlan_4
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.AmountPlan_5 ELSE 0 END     :: TFloat AS AmountPlan_5
              -- План оплат - Итог
            , CASE WHEN tmpMI.Ord = 1 THEN tmpMI.AmountPlan_total ELSE 0 END :: TFloat AS AmountPlan_total
 
              -- Платим да/нет
            , tmpMI.isAmountPlan_1    ::Boolean  AS isAmountPlan_1
            , tmpMI.isAmountPlan_2    ::Boolean  AS isAmountPlan_2
            , tmpMI.isAmountPlan_3    ::Boolean  AS isAmountPlan_3
            , tmpMI.isAmountPlan_4    ::Boolean  AS isAmountPlan_4
            , tmpMI.isAmountPlan_5    ::Boolean  AS isAmountPlan_5
            , tmpMI.Comment           ::TVarChar AS Comment
            , tmpMI.InsertName
            , tmpMI.UpdateName
            , tmpMI.InsertDate
            , tmpMI.UpdateDate
 
            , CASE WHEN tmpMI.isErased = TRUE OR tmpMI.isErased_Child = TRUE THEN TRUE ELSE FALSE END ::Boolean AS isErased
          
            --  чайлд
            , tmpMI.MovementItemId_Child    ::Integer
            , tmpMI.InvNumber_Child         ::TVarChar
            , tmpMI.InvNumber_Invoice_Child ::TVarChar
            , tmpMI.GoodsName_Child         ::TVarChar
            , tmpMI.Comment_Child           ::TVarChar
            , tmpMI.Comment_SB_Child        ::TVarChar
            , tmpMI.Amount_Child            ::TFloat 
            , tmpMI.isSign_Child            ::Boolean
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
