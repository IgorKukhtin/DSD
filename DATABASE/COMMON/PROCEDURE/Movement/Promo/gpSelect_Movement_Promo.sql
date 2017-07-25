-- Function: gpSelect_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inPeriodForOperDate Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , InvNumber        Integer     --Номер документа
             , OperDate         TDateTime   --Дата документа
             , StatusCode       Integer     --код статуса
             , StatusName       TVarChar    --Статус
             , PromoKindId      Integer     --Вид акции
             , PromoKindName    TVarChar    --Вид акции
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
             , CostPromo        TFloat      --Стоимость участия в акции
             , Comment          TVarChar    --Примечание
             , CommentMain      TVarChar    --Примечание (Общее)
             , UnitId           Integer     --Подразделение
             , UnitName         TVarChar    --Подразделение
             , PersonalTradeId  Integer     --Ответственный представитель коммерческого отдела
             , PersonalTradeName TVarChar   --Ответственный представитель коммерческого отдела
             , PersonalId       Integer     --Ответственный представитель маркетингового отдела	
             , PersonalName     TVarChar    --Ответственный представитель маркетингового отдела	
             , PartnerName      TVarChar     --Партнер
             , PartnerDescName  TVarChar     --тип Партнера
             , ContractName     TVarChar     --№ договора
             , ContractTagName  TVarChar     --признак договора
             , isFirst          Boolean      --Первый документ в группе (для автопересчета данных)
             , ChangePercentName TVarChar    -- Скидка по договору
             , isPromo          Boolean     --Акция (да/нет)
             , Checked          Boolean     --Согласовано (да/нет)
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        SELECT
            Movement_Promo.Id                 --Идентификатор
          , Movement_Promo.InvNumber          --Номер документа
          , Movement_Promo.OperDate           --Дата документа
          , CASE WHEN Movement_PromoPartner.StatusId = zc_Enum_Status_Erased() THEN Movement_PromoPartner.StatusCode ELSE Movement_Promo.StatusCode END :: Integer  AS StatusCode
          , CASE WHEN Movement_PromoPartner.StatusId = zc_Enum_Status_Erased() THEN Movement_PromoPartner.StatusName ELSE Movement_Promo.StatusName END :: TVarChar AS StatusName
          , Movement_Promo.PromoKindId        --Вид акции
          , Movement_Promo.PromoKindName      --Вид акции
          , Movement_Promo.PriceListId        --Прай слист
          , Movement_Promo.PriceListName      --Прай слист
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.EndReturn          --Дата окончания возвратов по акционной цене
          , Movement_Promo.OperDateStart      --Дата начала расч. продаж до акции
          , Movement_Promo.OperDateEnd        --Дата окончания расч. продаж до акции
          , Movement_Promo.MonthPromo         -- месяц акции
          , Movement_Promo.CostPromo          --Стоимость участия в акции
          , Movement_Promo.Comment            --Примечание
          , Movement_Promo.CommentMain        --Примечание (Общее)
          , Movement_Promo.UnitId             --Подразделение
          , Movement_Promo.UnitName           --Подразделение
          , Movement_Promo.PersonalTradeId    --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalId         --Ответственный представитель маркетингового отдела	
          , Movement_Promo.PersonalName       --Ответственный представитель маркетингового отдела	
          , Movement_PromoPartner.PartnerName     --Партнер
          , Movement_PromoPartner.PartnerDescName --Тип партнера
          , Movement_PromoPartner.ContractName --Название контракта
          , Movement_PromoPartner.ContractTagName --признак договора 
          , CASE
                WHEN (ROW_NUMBER() OVER(PARTITION BY Movement_Promo.Id ORDER BY Movement_PromoPartner.Id)) = 1
                    THEN TRUE
            ELSE FALSE
            END as IsFirst
          , COALESCE (Object_ChangePercent.ValueData, 'ДА')    :: TVarChar AS ChangePercentName
          
          , Movement_Promo.isPromo            --Акция
          , Movement_Promo.Checked            --согласовано
        FROM
            Movement_Promo_View AS Movement_Promo
            INNER JOIN tmpStatus ON Movement_Promo.StatusId = tmpStatus.StatusId
            LEFT JOIN Movement_PromoPartner_View AS Movement_PromoPartner
                                                 ON Movement_PromoPartner.ParentId = Movement_Promo.Id
                                                AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            LEFT JOIN MovementItem AS MI_Child
                                   ON MI_Child.MovementId = Movement_Promo.Id
                                  AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() -- без учета % скидки по договору
                                  AND MI_Child.isErased   = FALSE
            LEFT JOIN Object AS Object_ChangePercent ON Object_ChangePercent.Id = MI_Child.ObjectId
        WHERE
            (
                inPeriodForOperDate = TRUE
                AND
                Movement_Promo.OperDate BETWEEN inStartDate AND inEndDate
            )
            OR
            (
                inPeriodForOperDate = FALSE
                AND
                (
                    Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
                    OR
                    inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale
                )
            );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 25.07.17         *
 05.10.16         * add inJuridicalBasisId
 27.11.15                                                                        *inPeriodForOperDate
 17.11.15                                                                        *Movement_PromoPartner_View
 13.10.15                                                                        *
*/

-- SELECT * FROM gpSelect_Movement_Promo (inStartDate:= '01.11.2016', inEndDate:= '30.11.2016', inIsErased:= FALSE, inPeriodForOperDate:=TRUE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
