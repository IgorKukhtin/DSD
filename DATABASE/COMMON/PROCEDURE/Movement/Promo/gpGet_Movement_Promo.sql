-- Function: gpGet_Movement_Promo()

DROP FUNCTION IF EXISTS gpGet_Movement_Promo (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Promo(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , InvNumber        TVarChar    --Номер документа
             , OperDate         TDateTime   --Дата документа
             , StatusCode       Integer     --код статуса
             , StatusName       TVarChar    --Статус
             , PromoKindId      Integer     --Вид акции
             , PromoKindName    TVarChar    --Вид акции
             , PriceListId      Integer     --прайс лист
             , PriceListName    TVarChar    --Прайс лист
             , StartPromo       TDateTime   --Дата начала акции
             , EndPromo         TDateTime   --Дата окончания акции
             , StartSale        TDateTime   --Дата начала отгрузки по акционной цене
             , EndSale          TDateTime   --Дата окончания отгрузки по акционной цене
             , OperDateStart    TDateTime   --Дата начала расч. продаж до акции
             , OperDateEnd      TDateTime   --Дата окончания расч. продаж до акции
             , CostPromo        TFloat      --Стоимость участия в акции
             , Comment          TVarChar    --Примечание
             , CommentMain      TVarChar    --Примечание (Общее)
             , UnitId           INTEGER     --Подразделение
             , UnitName         TVarChar    --Подразделение
             , PersonalTradeId  INTEGER     --Ответственный представитель коммерческого отдела
             , PersonalTradeName TVarChar   --Ответственный представитель коммерческого отдела
             , PersonalId       INTEGER     --Ответственный представитель маркетингового отдела	
             , PersonalName     TVarChar    --Ответственный представитель маркетингового отдела	
             )
AS
$BODY$
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Promo());
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                 AS Id
          , CAST (NEXTVAL ('movement_Promo_seq') AS TVarChar) AS InvNumber
          , inOperDate				                          AS OperDate
          , Object_Status.Code               	              AS StatusCode
          , Object_Status.Name              		          AS StatusName
          , NULL::Integer                                     AS PromoKindId         --Вид акции
          , NULL::TVarChar                                    AS PromoKindName       --Вид акции
          , Object_PriceList.Id                               AS PriceListId         --Прайс лист
          , Object_PriceList.ValueData                        AS PriceListName       --Прайс лист
          , NULL::TDateTime                                   AS StartPromo          --Дата начала акции
          , NULL::TDateTime                                   AS EndPromo            --Дата окончания акции
          , NULL::TDateTime                                   AS StartSale           --Дата начала отгрузки по акционной цене
          , NULL::TDateTime                                   AS EndSale             --Дата окончания отгрузки по акционной цене
          , NULL::TDateTime                                   AS OperDateStart       --Дата начала расч. продаж до акции
          , NULL::TDateTime                                   AS OperDateEnd         --Дата окончания расч. продаж до акции
          , NULL::TFloat                                      AS CostPromo           --Стоимость участия в акции
          , NULL::TVarChar                                    AS Comment             --Примечание
          , NULL::TVarChar                                    AS CommentMain         --Примечание (Общее)
          , NULL::Integer                                     AS UnitId              --Подразделение
          , NULL::TVarChar                                    AS UnitName            --Подразделение
          , NULL::Integer                                     AS PersonalTradeId     --Ответственный представитель коммерческого отдела
          , NULL::TVarChar                                    AS PersonalTradeName   --Ответственный представитель коммерческого отдела
          , NULL::Integer                                     AS PersonalId          --Ответственный представитель маркетингового отдела	
          , NULL::TVarChar                                    AS PersonalName        --Ответственный представитель маркетингового отдела	
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT OUTER JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis();
    ELSE
        RETURN QUERY
        SELECT
            Movement_Promo.Id                 --Идентификатор
          , Movement_Promo.InvNumber          --Номер документа
          , Movement_Promo.OperDate           --Дата документа
          , Movement_Promo.StatusCode         --код статуса
          , Movement_Promo.StatusName         --Статус
          , Movement_Promo.PromoKindId        --Вид акции
          , Movement_Promo.PromoKindName      --Вид акции
          , Movement_Promo.PriceListId        --Вид акции
          , Movement_Promo.PriceListName      --Вид акции
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.OperDateStart      --Дата начала расч. продаж до акции
          , Movement_Promo.OperDateEnd        --Дата окончания расч. продаж до акции
          , Movement_Promo.CostPromo          --Стоимость участия в акции
          , Movement_Promo.Comment            --Примечание
          , Movement_Promo.Comment            --Примечание (Общее)
          , Movement_Promo.UnitId             --Подразделение
          , Movement_Promo.UnitName           --Подразделение
          , Movement_Promo.PersonalTradeId    --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalId         --Ответственный представитель маркетингового отдела	
          , Movement_Promo.PersonalName       --Ответственный представитель маркетингового отдела	
             
        FROM
            Movement_Promo_View AS Movement_Promo
        WHERE Movement_Promo.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Promo (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 13.10.15                                                                        *
*/
