-- Function: gpSelect_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , InvNumber        TVarChar    --Номер документа
             , OperDate         TDateTime   --Дата документа
             , StatusCode       Integer     --код статуса
             , StatusName       TVarChar    --Статус
             , PromoKindId      Integer     --Вид акции
             , PromoKindName    TVarChar    --Вид акции
             , StartPromo       TDateTime   --Дата начала акции
             , EndPromo         TDateTime   --Дата окончания акции
             , StartSale        TDateTime   --Дата начала отгрузки по акционной цене
             , EndSale          TDateTime   --Дата окончания отгрузки по акционной цене
             , OperDateStart    TDateTime   --Дата начала расч. продаж до акции
             , OperDateEnd      TDateTime   --Дата окончания расч. продаж до акции
             , CostPromo        TFloat      --Стоимость участия в акции
             , Comment          TVarChar    --Примечание
             , AdvertisingId    INTEGER     --Рекламная поддержка
             , AdvertisingName  TVarChar    --Рекламная поддержка
             , UnitId           INTEGER     --Подразделение
             , UnitName         TVarChar    --Подразделение
             , PersonalTradeId  INTEGER     --Ответственный представитель коммерческого отдела
             , PersonalTradeName TVarChar   --Ответственный представитель коммерческого отдела
             , PersonalId       INTEGER     --Ответственный представитель маркетингового отдела	
             , PersonalName     TVarChar    --Ответственный представитель маркетингового отдела	
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
          , Movement_Promo.StatusCode         --код статуса
          , Movement_Promo.StatusName         --Статус
          , Movement_Promo.PromoKindId        --Вид акции
          , Movement_Promo.PromoKindName      --Вид акции
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.OperDateStart      --Дата начала расч. продаж до акции
          , Movement_Promo.OperDateEnd        --Дата окончания расч. продаж до акции
          , Movement_Promo.CostPromo          --Стоимость участия в акции
          , Movement_Promo.Comment            --Примечание
          , Movement_Promo.AdvertisingId      --Рекламная поддержка
          , Movement_Promo.AdvertisingName    --Рекламная поддержка
          , Movement_Promo.UnitId             --Подразделение
          , Movement_Promo.UnitName           --Подразделение
          , Movement_Promo.PersonalTradeId    --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalId         --Ответственный представитель маркетингового отдела	
          , Movement_Promo.PersonalName       --Ответственный представитель маркетингового отдела	
        FROM
            Movement_Promo_View AS Movement_Promo
            INNER JOIN tmpStatus ON Movement_Promo.StatusId = tmpStatus.StatusId
        WHERE
            Movement_Promo.OperDate BETWEEN inStartDate AND inEndDate
        ORDER BY InvNumber;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 13.10.15                                                                        *
*/