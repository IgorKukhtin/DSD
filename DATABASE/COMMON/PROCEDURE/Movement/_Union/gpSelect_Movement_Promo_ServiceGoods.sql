-- Function: gpSelect_Movement_Promo_ServiceGoods()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_ServiceGoods (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_ServiceGoods(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inIsErased                 Boolean ,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , InvNumber        Integer     --Номер документа 
             , InvNumber_full   TVarChar    --
             , OperDate         TDateTime   --Дата документа
             , StatusCode       Integer     --код статуса
             , StatusName       TVarChar    --Статус
             , DescName         TVarChar    --вид документа
             , PromoKindId      Integer     --Вид акции
             , PromoKindName    TVarChar    --Вид акции
             , PromoStateKindId Integer     -- Состояние Акции
             , PromoStateKindName TVarChar  -- Состояние Акции
             , PriceListId      Integer     --Прайс лист
             , PriceListName    TVarChar    --Прайс лист
             , StartPromo       TDateTime   --Дата начала акции
             , EndPromo         TDateTime   --Дата окончания акции
             , StartSale        TDateTime   --Дата начала отгрузки по акционной цене
             , EndSale          TDateTime   --Дата окончания отгрузки по акционной цене
             , EndReturn        TDateTime   --Дата окончания возвратов по акционной цене
             , OperDateStart    TDateTime   --Дата начала расч. продаж до акции
             , OperDateEnd      TDateTime   --Дата окончания расч. продаж до акции
             , MonthPromo       TDateTime   --Месяц акции
             , UnitId           Integer     --Подразделение
             , UnitName         TVarChar    --Подразделение
             , PersonalTradeId  Integer     --Ответственный представитель коммерческого отдела
             , PersonalTradeName TVarChar   --Ответственный представитель коммерческого отдела
             , PersonalId       Integer     --Ответственный представитель маркетингового отдела
             , PersonalName     TVarChar    --Ответственный представитель маркетингового отдела
             --
             , ContractId       Integer     --Договора
             , ContractCode     Integer     --Договора
             , ContractName     TVarChar    --Договора 
             , ContractTagName  TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , RetailId Integer, RetailName TVarChar  
             , PaidKindName       TVarChar
             , AdvertisingName    TVarChar
             , Comment            TVarChar 
             , AdvertisingName_full TVarChar 
             , InfoMoneyId        Integer
             , InfoMoneyCode      Integer 
             , InfoMoneyName      TVarChar
             , InfoMoneyId_choice    Integer
             , InfoMoneyName_choice  TVarChar
             , CostPromo          TFloat
             , SummMarket         TFloat  
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Временно замена!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

         , tmpMovement AS (SELECT Movement.*
                           FROM tmpStatus
                                INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                                   AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND Movement.DescId IN (zc_Movement_Promo(),zc_Movement_PromoTrade())
                          )

         , tmpAdvertising AS (WITH
                               tmpMov AS (SELECT Movement.*
                                          FROM Movement
                                          WHERE Movement.ParentId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_Promo())
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                            AND Movement.DescId = zc_Movement_PromoAdvertising()
                                          )
                             , tmpMovementString AS (SELECT MovementString.* 
                                                  FROM MovementString
                                                  WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov) 
                                                    AND MovementString.DescId IN (zc_MovementString_Comment()
                                                                                 )
                                                  )

                             , tmpMLO AS (SELECT MovementLinkObject.* 
                                          FROM MovementLinkObject
                                          WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov) 
                                            AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Advertising()
                                                                            )
                                          )SELECT Movement.ParentId 
                                   , Object_Advertising.Id            AS AdvertisingId
                                   , Object_Advertising.ValueData     AS AdvertisingName
                                   , MovementString_Comment.ValueData AS Comment
                              FROM Movement
                              LEFT JOIN tmpMLO AS MovementLinkObject_Advertising
                                               ON MovementLinkObject_Advertising.MovementId = Movement.Id
                                              AND MovementLinkObject_Advertising.DescId = zc_MovementLinkObject_Advertising()
                              LEFT JOIN Object AS Object_Advertising ON Object_Advertising.Id = MovementLinkObject_Advertising.ObjectId
                              LEFT OUTER JOIN tmpMovementString AS MovementString_Comment
                                                                ON MovementString_Comment.MovementId = Movement.Id
                                                               AND MovementString_Comment.DescId = zc_MovementString_Comment()
                              WHERE Movement.ParentId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_Promo())
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                                AND Movement.DescId = zc_Movement_PromoAdvertising()
                              )
         --получаем договора из  PromoPartner
         , tmpPromoPartner AS (WITH
                               tmpMov AS (SELECT Movement.*
                                          FROM Movement
                                          WHERE Movement.ParentId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_Promo())
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                            AND Movement.DescId = zc_Movement_PromoPartner()
                                          )

                             , tmpMLO AS (SELECT MovementLinkObject.* 
                                          FROM MovementLinkObject
                                          WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov) 
                                            AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Contract()
                                                                            , zc_MovementLinkObject_Partner()
                                                                            )
                                          )
                               SELECT 
                                   Movement.ParentId
                                 , Object_Contract.Id              AS ContractId
                                 , Object_Contract.ObjectCode      AS ContractCode
                                 , Object_Contract.ValueData       AS InvNumber
                                 , Object_ContractTag.ValueData    AS ContractTagName
                                 , STRING_AGG (DISTINCT Object_Juridical.ValueData, ';')  AS JuridicalName 
                                 , STRING_AGG (DISTINCT Object_Retail.ValueData, ';')     AS RetailName
                               FROM tmpMov AS Movement 
                                   LEFT JOIN tmpMLO AS MovementLinkObject_Contract
                                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                   LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

                                   LEFT JOIN tmpMLO AS MovementLinkObject_Partner
                                                                ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                               AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                   LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

                                   LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                             AND Object_Partner.DescId = zc_Object_Partner()
                                   LEFT OUTER JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_Partner.ObjectId)

                                   LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                              ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id)
                                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                   LEFT OUTER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                                        ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                                       AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                                   LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId                           
                               GROUP BY Movement.ParentId
                                      , Object_Contract.Id
                                      , Object_Contract.ObjectCode
                                      , Object_Contract.ValueData
                                      , Object_ContractTag.ValueData
                               ) 

         , tmpInfoMoney AS (WITH
                               tmpMov AS (SELECT Movement.*
                                          FROM Movement
                                          WHERE Movement.ParentId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_Promo())
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                            AND Movement.DescId = zc_Movement_InfoMoney()
                                          )

                             , tmpMLO AS (SELECT MovementLinkObject.* 
                                          FROM MovementLinkObject
                                          WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov) 
                                            AND MovementLinkObject.DescId IN (zc_MovementLinkObject_InfoMoney_CostPromo()
                                                                            , zc_MovementLinkObject_InfoMoney_Market()
                                                                            )
                                          )
                            SELECT Movement.ParentId
                                 , MLO_InfoMoney_CostPromo.ObjectId  AS InfoMoneyId_CostPromo       
                                 , MLO_InfoMoney_Market.ObjectId     AS InfoMoneyId_Market       
                               FROM tmpMov AS Movement
                                   LEFT JOIN tmpMLO AS MLO_InfoMoney_CostPromo
                                                    ON MLO_InfoMoney_CostPromo.MovementId = Movement.Id
                                                   AND MLO_InfoMoney_CostPromo.DescId = zc_MovementLinkObject_InfoMoney_CostPromo()

                                   LEFT JOIN tmpMLO AS MLO_InfoMoney_Market
                                                    ON MLO_InfoMoney_Market.MovementId = Movement.Id
                                                   AND MLO_InfoMoney_Market.DescId = zc_MovementLinkObject_InfoMoney_Market()
                            )                                   

         --строки Promo
         , tmpMI_promo AS (WITH
                           tmpMI AS (SELECT MovementItem.*
                                     FROM MovementItem
                                     WHERE MovementItem.DescId = zc_MI_Master()
                                       AND MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_Promo())
                                       AND MovementItem.isErased = FALSE
                                     )
                         , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                                                    FROM MovementItemFloat
                                                    WHERE MovementItemFloat.MovementItemId In (SELECT DISTINCT tmpMI.Id FROM tmpMI) 
                                                      AND MovementItemFloat.DescId IN (zc_MIFloat_SummOutMarket(), zc_MIFloat_SummInMarket())
                                                    )
                           SELECT MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
                                , SUM (COALESCE (MIFloat_SummOutMarket.ValueData,0) - COALESCE (MIFloat_SummInMarket.ValueData,0))  ::TFloat AS SummMarket
                           FROM tmpMI AS MovementItem
                                LEFT JOIN tmpMovementItemFloat AS MIFloat_SummOutMarket
                                                            ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummOutMarket.DescId = zc_MIFloat_SummOutMarket()
                                LEFT JOIN tmpMovementItemFloat AS MIFloat_SummInMarket
                                                            ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummInMarket.DescId = zc_MIFloat_SummInMarket()
                           GROUP BY MovementItem.MovementId
                             )
 
 
       , tmpMovementDate AS (SELECT MovementDate.* 
                            FROM MovementDate
                            WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                              AND MovementDate.DescId IN (zc_MovementDate_EndPromo()
                                                        , zc_MovementDate_EndReturn()
                                                        , zc_MovementDate_EndSale()
                                                        , zc_MovementDate_Month()
                                                        , zc_MovementDate_OperDateEnd()
                                                        , zc_MovementDate_OperDateStart()
                                                        , zc_MovementDate_StartPromo()
                                                        , zc_MovementDate_StartSale())
                            )

       , tmpMovementString AS (SELECT MovementString.* 
                            FROM MovementString
                            WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                              AND MovementString.DescId IN (zc_MovementString_Comment()
                                                           )
                            )

       , tmpMovementFloat AS (SELECT MovementFloat.* 
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                              AND MovementFloat.DescId IN (zc_MovementFloat_CostPromo()
                                                           )
                            )
       , tmpMLO AS (SELECT MovementLinkObject.* 
                    FROM MovementLinkObject
                    WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                      AND MovementLinkObject.DescId IN (zc_MovementLinkObject_PromoKind()
                                                      , zc_MovementLinkObject_PriceList()
                                                      , zc_MovementLinkObject_Unit()
                                                      , zc_MovementLinkObject_PersonalTrade()
                                                      , zc_MovementLinkObject_Personal()
                                                      , zc_MovementLinkObject_PromoStateKind()
                                                      , zc_MovementLinkObject_PaidKind()
                                                      , zc_MovementLinkObject_Contract()
                                                      , zc_MovementLinkObject_PromoItem()
                                                      )
                    )

      , tmpInfoMoney_View AS (SELECT *
                              FROM Object_InfoMoney_View
                              )
 
          --ну как то так нужно вывести данные несколькими строками
         , tmpPomo_params AS (SELECT tmpMovement.Id AS ParentId
                                   , tmpAdvertising.AdvertisingId
                                   , tmpAdvertising.AdvertisingName 
                                   , tmpAdvertising.Comment  AS Comment_Advertising
                                   , MovementFloat_CostPromo.ValueData  ::TFloat AS CostPromo
                                   , 0 ::TFloat AS SummMarket
                                   , tmpInfoMoney.InfoMoneyId_CostPromo AS InfoMoneyId
                              FROM tmpMovement
                                   LEFT JOIN tmpAdvertising ON tmpAdvertising.ParentId = tmpMovement.Id
                                   LEFT JOIN MovementFloat AS MovementFloat_CostPromo
                                                           ON MovementFloat_CostPromo.MovementId = tmpMovement.Id 
                                                          AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()
                                   LEFT JOIN tmpInfoMoney ON tmpInfoMoney.ParentId = tmpMovement.Id
                              WHERE tmpMovement.DescId = zc_Movement_Promo() 
                                AND (MovementFloat_CostPromo.ValueData <> 0 OR tmpInfoMoney.InfoMoneyId_CostPromo > 0)
                           UNION ALL
                              SELECT tmpMovement.Id AS ParentId
                              , NULL AS AdvertisingId
                              , NULL AS AdvertisingName 
                              , NULL AS Comment_Advertising
                              , 0  ::TFloat AS CostPromo
                              , tmpMI_promo.SummMarket ::TFloat AS SummMarket
                              , tmpInfoMoney.InfoMoneyId_Market AS InfoMoneyId
                              FROM tmpMovement
                                   LEFT JOIN tmpMI_promo ON tmpMI_promo.MovementId = tmpMovement.Id 
                                   LEFT JOIN tmpInfoMoney ON tmpInfoMoney.ParentId =  tmpMovement.Id 
                              WHERE tmpMovement.DescId = zc_Movement_Promo()
                                AND (COALESCE (tmpMI_promo.SummMarket,0) <> 0 OR tmpInfoMoney.InfoMoneyId_Market > 0)
                             )


        -- Результат
        SELECT Movement.Id                                                 --Идентификатор
             , Movement.InvNumber :: Integer                               --Номер документа  
             , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) :: TVarChar AS InvNumber_full
             , Movement.OperDate                                           --Дата документа
             , Object_Status.ObjectCode        :: Integer  AS StatusCode
             , Object_Status.ValueData         :: TVarChar AS StatusName 
             , MovementDesc.ItemName           ::TVarChar  AS DescName
             , MovementLinkObject_PromoKind.ObjectId       AS PromoKindId        --Вид акции
             , Object_PromoKind.ValueData                  AS PromoKindName      --Вид акции
             , Object_PromoStateKind.Id                    AS PromoStateKindId        --Состояние акции
             , Object_PromoStateKind.ValueData             AS PromoStateKindName      --Состояние акции
             , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --Прайс Лист
             , Object_PriceList.ValueData                  AS PriceListName      --Прайс Лист
             , MovementDate_StartPromo.ValueData           AS StartPromo         --Дата начала акции
             , MovementDate_EndPromo.ValueData             AS EndPromo           --Дата окончания акции    
             , MovementDate_StartSale.ValueData            AS StartSale          --Дата начала отгрузки по акционной цене
             , MovementDate_EndSale.ValueData              AS EndSale            --Дата окончания отгрузки по акционной цене
             , MovementDate_EndReturn.ValueData            AS EndReturn          --Дата окончания возвратов по акционной цене
             , MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала расч. продаж до акции
             , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания расч. продаж до акции
             , MovementDate_Month.ValueData                AS MonthPromo         -- месяц акции
             , MovementLinkObject_Unit.ObjectId            AS UnitId             --Подразделение
             , Object_Unit.ValueData                       AS UnitName           --Подразделение
             , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --Ответственный представитель коммерческого отдела
             , Object_PersonalTrade.ValueData              AS PersonalTradeName  --Ответственный представитель коммерческого отдела
             , MovementLinkObject_Personal.ObjectId        AS PersonalId         --Ответственный представитель маркетингового отдела
             , Object_Personal.ValueData                   AS PersonalName       --Ответственный представитель маркетингового отдела

             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN MovementLinkObject_Contract.ObjectId ELSE tmpPromoPartner.ContractId END            AS ContractId        --  
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Object_Contract.ObjectCode ELSE tmpPromoPartner.ContractCode END                    AS ContractCode
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Object_Contract.ValueData ELSE tmpPromoPartner.InvNumber END  ::TVarChar            AS ContractName      -- 
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Object_ContractTag.ValueData ELSE tmpPromoPartner.ContractTagName END  ::TVarChar   AS ContractTagName
             , Object_Juridical.Id                                                                                                                           AS JuridicalId
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Object_Juridical.ValueData ELSE tmpPromoPartner.JuridicalName END  ::TVarChar       AS JuridicalName
             , Object_Retail.Id                                                                                                                              AS RetailId
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Object_Retail.ValueData ELSE tmpPromoPartner.RetailName END  ::TVarChar             AS RetailName   
             , Object_PaidKind.ValueData  ::TVarChar                                                                                                         AS PaidKindName
             
             , CASE WHEN Movement.DescId = zc_Movement_Promo() THEN tmpPomo_params.AdvertisingName ELSE NULL END ::TVarChar AS AdvertisingName      --рекламная поддержка
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN MovementString_Comment.ValueData ELSE tmpPomo_params.Comment_Advertising END   ::TVarChar AS Comment            --Примечание затрат
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN NULL
                    ELSE COALESCE (tmpPomo_params.AdvertisingName,'') 
                        || CASE WHEN COALESCE (tmpPomo_params.Comment_Advertising,'') <> '' THEN ' ;'||COALESCE (tmpPomo_params.Comment_Advertising,'') ELSE '' END
               END ::TVarChar AS AdvertisingName_full 
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Object_PromoItem.Id ELSE View_InfoMoney.InfoMoneyId END            AS InfoMoneyId
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Object_PromoItem.ObjectCode ELSE View_InfoMoney.InfoMoneyCode END  AS InfoMoneyCode
             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Object_PromoItem.ValueData ELSE View_InfoMoney.InfoMoneyName_all END  ::TVarChar AS InfoMoneyName

             , View_InfoMoney.InfoMoneyId                    AS InfoMoneyId_choice
             , View_InfoMoney.InfoMoneyName_all   ::TVarChar AS InfoMoneyName_choice


             , CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN MovementFloat_CostPromo.ValueData 
                    ELSE tmpPomo_params.CostPromo
               END                                   ::TFloat AS CostPromo
             , COALESCE (tmpPomo_params.SummMarket,0)::TFloat AS SummMarket   
             
        FROM tmpMovement AS Movement
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
             LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

             LEFT JOIN tmpMLO AS MovementLinkObject_PromoKind
                                          ON MovementLinkObject_PromoKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PromoKind.DescId = zc_MovementLinkObject_PromoKind()
             LEFT JOIN Object AS Object_PromoKind
                              ON Object_PromoKind.Id = MovementLinkObject_PromoKind.ObjectId

             LEFT JOIN tmpMLO AS MovementLinkObject_PriceList
                                          ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                         AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
             LEFT JOIN Object AS Object_PriceList
                              ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

             LEFT JOIN tmpMovementDate AS MovementDate_StartSale
                                    ON MovementDate_StartSale.MovementId = Movement.Id
                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
             LEFT JOIN tmpMovementDate AS MovementDate_EndSale
                                    ON MovementDate_EndSale.MovementId = Movement.Id
                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

             LEFT JOIN tmpMovementDate AS MovementDate_StartPromo
                                    ON MovementDate_StartPromo.MovementId = Movement.Id
                                   AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
             LEFT JOIN tmpMovementDate AS MovementDate_EndPromo
                                    ON MovementDate_EndPromo.MovementId =  Movement.Id
                                   AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

             LEFT JOIN tmpMovementDate AS MovementDate_EndReturn
                                    ON MovementDate_EndReturn.MovementId = Movement.Id
                                   AND MovementDate_EndReturn.DescId = zc_MovementDate_EndReturn()

             LEFT JOIN tmpMovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId = Movement.Id
                                   AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
             LEFT JOIN tmpMovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                   AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

             LEFT JOIN tmpMovementDate AS MovementDate_Month
                                    ON MovementDate_Month.MovementId = Movement.Id
                                   AND MovementDate_Month.DescId = zc_MovementDate_Month()

             LEFT JOIN tmpMLO AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN Object AS Object_Unit
                              ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

             LEFT JOIN tmpMLO AS MovementLinkObject_PersonalTrade
                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement.Id
                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
             LEFT JOIN Object AS Object_PersonalTrade
                              ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

             LEFT JOIN tmpMLO AS MovementLinkObject_Personal
                                          ON MovementLinkObject_Personal.MovementId = Movement.Id
                                         AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
             LEFT JOIN Object AS Object_Personal
                              ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

             LEFT JOIN tmpMLO AS MovementLinkObject_PromoStateKind
                                          ON MovementLinkObject_PromoStateKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PromoStateKind.DescId = zc_MovementLinkObject_PromoStateKind()
             LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementLinkObject_PromoStateKind.ObjectId

             LEFT JOIN tmpMLO AS MovementLinkObject_PaidKind
                                          ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

             --PromoTrade
             LEFT JOIN tmpMLO AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                         AND Movement.DescId = zc_Movement_PromoTrade()
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                  ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                 AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
             LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                  ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                                 AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId       

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
             
             LEFT JOIN tmpMLO AS MovementLinkObject_PromoItem
                                          ON MovementLinkObject_PromoItem.MovementId = Movement.Id
                                         AND MovementLinkObject_PromoItem.DescId = zc_MovementLinkObject_PromoItem()
                                         AND Movement.DescId = zc_Movement_PromoTrade()
             LEFT JOIN Object AS Object_PromoItem ON Object_PromoItem.Id = MovementLinkObject_PromoItem.ObjectId

             LEFT JOIN tmpMovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                     AND Movement.DescId = zc_Movement_PromoTrade()

             LEFT JOIN tmpMovementFloat AS MovementFloat_CostPromo
                                     ON MovementFloat_CostPromo.MovementId = Movement.Id
                                    AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()
                                    AND Movement.DescId = zc_Movement_PromoTrade() 

             LEFT JOIN tmpPomo_params ON tmpPomo_params.ParentId = Movement.Id
                                     AND Movement.DescId = zc_Movement_Promo()
             LEFT JOIN tmpInfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpPomo_params.InfoMoneyId
             LEFT JOIN tmpPromoPartner ON tmpPromoPartner.ParentId = Movement.Id
                                      AND Movement.DescId = zc_Movement_Promo()
            
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.08.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Promo_ServiceGoods (inStartDate:= '19.09.2024', inEndDate:= '19.09.2024', inIsErased := FALSE, inSession:= '2')