-- Function: gpSelect_Movement_PromoSale()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoSale (TDateTime, TDateTime, Boolean, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoSale(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inPeriodForOperDate Boolean ,
    IN inIsAllPartner      Boolean ,   -- Развернуть по контрагентам
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , InvNumber        Integer     --Номер документа
             , OperDate         TDateTime   --Дата документа
             , StatusCode       Integer     --код статуса
             , StatusName       TVarChar    --Статус      
             , PriceListId      Integer     --Прайс лист
             , PriceListName    TVarChar    --Прайс лист
             , StartPromo       TDateTime   --Дата начала акции
             , EndPromo         TDateTime   --Дата окончания акции
             , StartSale        TDateTime   --Дата начала отгрузки по акционной цене
             , EndSale          TDateTime   --Дата окончания отгрузки по акционной цене
             , OperDateStart    TDateTime   --Дата начала расч. продаж до акции
             , OperDateEnd      TDateTime   --Дата окончания расч. продаж до акции
             , ChangePercent    TFloat      --(-)% Скидки (+)% Наценки по договору

             , CountDayPromo    Integer
             , CountDaySale     Integer
             , CountDayOperDate Integer

             , Comment          TVarChar    --Примечание
             , PersonalTradeId  Integer     --Ответственный представитель коммерческого отдела
             , PersonalTradeName TVarChar   --Ответственный представитель коммерческого отдела
             , PersonalId       Integer     --Ответственный представитель маркетингового отдела
             , PersonalName     TVarChar    --Ответственный представитель маркетингового отдела
             , DayCount         Integer     --
             , InsertName TVarChar
             , InsertDate TDateTime
             , NotBudgPromoId Integer, NotBudgPromoName TVarChar, isNotBudgPromo Boolean
             
             , PartnerName      TVarChar     --Партнер
             , PartnerDescName  TVarChar     --тип Партнера
             , ContractName     TVarChar     --№ договора
             , ContractTagName  TVarChar     --признак договора
             , RetailName       TVarChar     -- "сеть" - STRING_AGG, если сети нет, тогда юр лица
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
           , tmpMovement AS (SELECT Movement_PromoSale.*
                                  , MovementDate_StartSale.ValueData            AS StartSale
                                  , MovementDate_EndSale.ValueData              AS EndSale
                             FROM Movement AS Movement_PromoSale
                                  INNER JOIN tmpStatus ON Movement_PromoSale.StatusId = tmpStatus.StatusId

                                  LEFT JOIN MovementDate AS MovementDate_StartSale
                                                         ON MovementDate_StartSale.MovementId = Movement_PromoSale.Id
                                                        AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                  LEFT JOIN MovementDate AS MovementDate_EndSale
                                                         ON MovementDate_EndSale.MovementId = Movement_PromoSale.Id
                                                        AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

                             WHERE Movement_PromoSale.DescId = zc_Movement_PromoSale()
                               AND ( (inPeriodForOperDate = TRUE AND Movement_PromoSale.OperDate BETWEEN inStartDate AND inEndDate)
                                  OR (inPeriodForOperDate = FALSE AND (MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                                                                       OR inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                                                                      )
                                     )
                                   )
                            )

           , tmpMovement_PromoSalePartner AS (SELECT Movement_PromoSalePartner.Id                                                 --Идентификатор
                                               , Movement_PromoSalePartner.StatusId
                                               , Object_Status.ObjectCode               AS StatusCode
                                               , Object_Status.ValueData                AS StatusName
                                               , Movement_PromoSalePartner.ParentId                                    --Ссылка на основной документ <Акции> (zc_Movement_Promo)
                                               , Object_Partner.ValueData               AS PartnerName             --Покупатель для акции
                                               , ObjectDesc_Partner.ItemName            AS PartnerDescName         --Тип Покупатель для акции
                                               , Object_Contract.ValueData              AS ContractName            --наименование контракта
                                               , Object_ContractTag.ValueData           AS ContractTagName         --признак контракта
                                               , COALESCE (Object_Retail.ValueData, Object_Juridical.ValueData)   AS RetailName      --Наименование объекта <Торговая сеть> или юр.лицо

                                          FROM tmpMovement
                                               LEFT JOIN Movement AS Movement_PromoSalePartner ON Movement_PromoSalePartner.ParentId = tmpMovement.Id
                                                                                          AND Movement_PromoSalePartner.DescId = zc_Movement_PromoSalePartner()
                                                                                          AND Movement_PromoSalePartner.StatusId <> zc_Enum_Status_Erased()
                                               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PromoSalePartner.StatusId

                                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                            ON MovementLinkObject_Partner.MovementId = Movement_PromoSalePartner.Id
                                                                           AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
                                               LEFT OUTER JOIN ObjectDesc AS ObjectDesc_Partner ON ObjectDesc_Partner.Id = Object_Partner.DescId

                                               LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                          ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                         AND Object_Partner.DescId = zc_Object_Partner()
                                               LEFT OUTER JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id)
                                       
                                               LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                                          ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id)
                                                                         AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                               LEFT OUTER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                            ON MovementLinkObject_Contract.MovementId = Movement_PromoSalePartner.Id
                                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

                                               LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                                                    ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                                                   AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                                               LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                                         )
           , tmpStrRetail AS (SELECT tmpMovement_PromoSalePartner.ParentId
                                   , STRING_AGG (DISTINCT tmpMovement_PromoSalePartner.RetailName, ', ') ::TVarChar AS RetailName
                              FROM tmpMovement_PromoSalePartner
                              GROUP BY tmpMovement_PromoSalePartner.ParentId
                              )

        -- Результат
        SELECT Movement_PromoSale.Id                                                 --Идентификатор
             , Movement_PromoSale.InvNumber :: Integer                               --Номер документа
             , Movement_PromoSale.OperDate                                           --Дата документа
             , CASE WHEN Movement_PromoSalePartner.StatusId = zc_Enum_Status_Erased() THEN Movement_PromoSalePartner.StatusCode ELSE Object_Status.ObjectCode END :: Integer  AS StatusCode
             , CASE WHEN Movement_PromoSalePartner.StatusId = zc_Enum_Status_Erased() THEN Movement_PromoSalePartner.StatusName ELSE Object_Status.ValueData END :: TVarChar AS StatusName   
           
             , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --Прайс Лист
             , Object_PriceList.ValueData                  AS PriceListName      --Прайс Лист
             , MovementDate_StartPromo.ValueData           AS StartPromo         --Дата начала акции
             , MovementDate_EndPromo.ValueData             AS EndPromo           --Дата окончания акции
             , Movement_PromoSale.StartSale                    AS StartSale          --Дата начала отгрузки по акционной цене
             , Movement_PromoSale.EndSale                      AS EndSale            --Дата окончания отгрузки по акционной цене
             , MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала расч. продаж до акции
             , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания расч. продаж до акции
             , MovementFloat_ChangePercent.ValueData       AS ChangePercent      --(-)% Скидки (+)% Наценки по договору

             , (DATE_PART ('DAY', AGE (MovementDate_EndPromo.ValueData, MovementDate_StartPromo.ValueData) )+1)      ::Integer AS CountDayPromo
             , (DATE_PART ('DAY', AGE (Movement_PromoSale.EndSale, Movement_PromoSale.StartSale) )+1)                        ::Integer AS CountDaySale
             , (DATE_PART ('DAY', AGE (MovementDate_OperDateEnd.ValueData, MovementDate_OperDateStart.ValueData) )+1)::Integer AS CountDayOperDate

             , MovementString_Comment.ValueData            AS Comment            --Примечание
             , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --Ответственный представитель коммерческого отдела
             , Object_PersonalTrade.ValueData              AS PersonalTradeName  --Ответственный представитель коммерческого отдела
             , MovementLinkObject_Personal.ObjectId        AS PersonalId         --Ответственный представитель маркетингового отдела
             , Object_Personal.ValueData                   AS PersonalName       --Ответственный представитель маркетингового отдела


             , (1 + EXTRACT (DAY FROM (Movement_PromoSale.EndSale - Movement_PromoSale.StartSale))) :: Integer AS DayCount

             , Object_User.ValueData                  AS InsertName
             , MovementDate_Insert.ValueData          AS InsertDate

             , Object_NotBudgPromo.Id                 AS NotBudgPromoId
             , Object_NotBudgPromo.ValueData          AS NotBudgPromoName
             , COALESCE (MovementBoolean_NotBudgPromo.ValueData, FALSE) ::Boolean AS isNotBudgPromo

             , Movement_PromoSalePartner.PartnerName     --Партнер
             , Movement_PromoSalePartner.PartnerDescName --Тип партнера
             , Movement_PromoSalePartner.ContractName    --Название контракта
             , Movement_PromoSalePartner.ContractTagName --признак договора
             , COALESCE (Movement_PromoSalePartner.RetailName, tmpStrRetail.RetailName) :: TVarChar AS RetailName      -- сеть/юр.лицо

        FROM tmpMovement AS Movement_PromoSale
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PromoSale.StatusId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                          ON MovementLinkObject_PriceList.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
             LEFT JOIN Object AS Object_PriceList
                              ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

             LEFT JOIN MovementDate AS MovementDate_StartPromo
                                    ON MovementDate_StartPromo.MovementId = Movement_PromoSale.Id
                                   AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
             LEFT JOIN MovementDate AS MovementDate_EndPromo
                                    ON MovementDate_EndPromo.MovementId =  Movement_PromoSale.Id
                                   AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

             LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId = Movement_PromoSale.Id
                                   AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
             LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId = Movement_PromoSale.Id
                                   AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                     ON MovementFloat_ChangePercent.MovementId = Movement_PromoSale.Id
                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_PromoSale.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementBoolean AS MovementBoolean_NotBudgPromo
                                       ON MovementBoolean_NotBudgPromo.MovementId = Movement_PromoSale.Id
                                      AND MovementBoolean_NotBudgPromo.DescId = zc_MovementBoolean_NotBudgPromo()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_NotBudgPromo
                                          ON MovementLinkObject_NotBudgPromo.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_NotBudgPromo.DescId = zc_MovementLinkObject_NotBudgPromo()
             LEFT JOIN Object AS Object_NotBudgPromo ON Object_NotBudgPromo.Id = MovementLinkObject_NotBudgPromo.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
             LEFT JOIN Object AS Object_PersonalTrade
                              ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                          ON MovementLinkObject_Personal.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
             LEFT JOIN Object AS Object_Personal
                              ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

             LEFT JOIN tmpMovement_PromoSalePartner AS Movement_PromoSalePartner
                                                ON Movement_PromoSalePartner.ParentId = Movement_PromoSale.Id
                                               AND inIsAllPartner = TRUE

             LEFT JOIN tmpStrRetail ON tmpStrRetail.ParentId = Movement_PromoSale.Id
                                                
             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_PromoSale.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                          ON MovementLinkObject_Insert.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_PromoSale (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 27.07.26         * 
*/

-- SELECT * FROM gpSelect_Movement_PromoSale (inStartDate:= '01.11.2024', inEndDate:= '30.11.2024', inIsErased:= FALSE, inPeriodForOperDate:=TRUE, inIsAllPartner:= False, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())