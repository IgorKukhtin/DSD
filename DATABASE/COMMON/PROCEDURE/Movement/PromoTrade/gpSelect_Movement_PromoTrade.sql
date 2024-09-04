-- Function: gpSelect_Movement_PromoTrade()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoTrade (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoTrade(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , InvNumber        Integer    --Номер документа
             , InvNumberFull    TVarChar   --Номер документа + дата
             , OperDate         TDateTime   --Дата документа
             , StatusCode       Integer     --код статуса
             , StatusName       TVarChar    --Статус
             , ContractId       Integer     --Договора
             , ContractName     TVarChar    --Договора
             , PromoKindId      Integer     --Вид акции
             , PromoKindName    TVarChar    --Вид акции
             , PromoItemId      Integer     -- Статья затрат
             , PromoItemName    TVarChar  -- Статья затрат
             , PriceListId      Integer     --прайс лист
             , PriceListName    TVarChar    --Прайс лист
             , StartPromo       TDateTime   --Дата начала акции
             , EndPromo         TDateTime   --Дата окончания акции
             , OperDateStart    TDateTime   --Дата начала расч. продаж до акции
             , OperDateEnd      TDateTime   --Дата окончания расч. продаж до акции
             , CostPromo        TFloat      --Стоимость участия в акции
             , ChangePercent    TFloat      --(-)% Скидки (+)% Наценки по договору

             , Comment          TVarChar    --Примечание
             , PersonalTradeId  INTEGER     --Ответственный представитель коммерческого отдела
             , PersonalTradeName TVarChar   --Ответственный представитель коммерческого отдела
             , InsertDate TDateTime
             , InsertName TVarChar
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
           , tmpMovement AS (SELECT Movement_PromoTrade.*
                             FROM Movement AS Movement_PromoTrade
                                  INNER JOIN tmpStatus ON Movement_PromoTrade.StatusId = tmpStatus.StatusId
                             WHERE Movement_PromoTrade.DescId = zc_Movement_PromoTrade()
                               AND Movement_PromoTrade.OperDate BETWEEN inStartDate AND inEndDate
                            )


        SELECT Movement_PromoTrade.Id                                                 --Идентификатор
             , Movement_PromoTrade.InvNumber :: Integer         AS InvNumber          --Номер документа  
             , ('№ ' || Movement_PromoTrade.InvNumber || ' от ' || zfConvert_DateToString (Movement_PromoTrade.OperDate)  ) :: TVarChar AS InvNumberFull
             , Movement_PromoTrade.OperDate                                           --Дата документа
             , Object_Status.ObjectCode                    AS StatusCode         --код статуса
             , Object_Status.ValueData                     AS StatusName         --Статус
             , MovementLinkObject_Contract.ObjectId        AS ContractId        --
             , Object_Contract.ValueData                   AS ContractName      --  
             , MovementLinkObject_PromoKind.ObjectId       AS PromoKindId        --Вид акции
             , Object_PromoKind.ValueData                  AS PromoKindName      --Вид акции      
             , Object_PromoItem.Id                         AS PromoItemId        --
             , Object_PromoItem.ValueData                  AS PromoItemName      --
             , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --Прайс Лист
             , Object_PriceList.ValueData                  AS PriceListName      --Прайс Лист
             , MovementDate_StartPromo.ValueData           AS StartPromo         --Дата начала акции
             , MovementDate_EndPromo.ValueData             AS EndPromo           --Дата окончания акции
             , MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала расч. продаж до акции
             , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания расч. продаж до акции
             , MovementFloat_CostPromo.ValueData           AS CostPromo          --Стоимость участия в акции    
             , MovementFloat_ChangePercent.ValueData       AS ChangePercent      --(-)% Скидки (+)% Наценки по договору 
             , MovementString_Comment.ValueData            AS Comment            --Примечание
             , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --Ответственный представитель коммерческого отдела
             , Object_PersonalTrade.ValueData              AS PersonalTradeName  --Ответственный представитель коммерческого отдела
             , MovementDate_Insert.ValueData               AS InsertDate
             , Object_Insert.ValueData                     AS InsertName

        FROM tmpMovement AS Movement_PromoTrade
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PromoTrade.StatusId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract 
                         ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
     
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoKind
                                     ON MovementLinkObject_PromoKind.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PromoKind.DescId = zc_MovementLinkObject_PromoKind()
        LEFT JOIN Object AS Object_PromoKind 
                         ON Object_PromoKind.Id = MovementLinkObject_PromoKind.ObjectId


        LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                     ON MovementLinkObject_PriceList.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
        LEFT JOIN Object AS Object_PriceList
                         ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId
     
        LEFT JOIN MovementDate AS MovementDate_StartPromo
                                ON MovementDate_StartPromo.MovementId = Movement_PromoTrade.Id
                               AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId =  Movement_PromoTrade.Id
                               AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                               
        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement_PromoTrade.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement_PromoTrade.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

        LEFT JOIN MovementFloat AS MovementFloat_CostPromo
                                ON MovementFloat_CostPromo.MovementId = Movement_PromoTrade.Id
                               AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()

        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId = Movement_PromoTrade.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_PromoTrade.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                     ON MovementLinkObject_PersonalTrade.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
        LEFT JOIN Object AS Object_PersonalTrade 
                         ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoItem
                                     ON MovementLinkObject_PromoItem.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PromoItem.DescId = zc_MovementLinkObject_PromoItem()
        LEFT JOIN Object AS Object_PromoItem ON Object_PromoItem.Id = MovementLinkObject_PromoItem.ObjectId

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                     ON MovementLinkObject_Insert.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_PromoTrade (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.24         *
*/

-- SELECT * FROM gpSelect_Movement_PromoTrade (inStartDate:= '01.11.2016', inEndDate:= '30.11.2016', inIsErased:= FALSE, inPeriodForOperDate:=TRUE, inIsAllPartner:= False, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
