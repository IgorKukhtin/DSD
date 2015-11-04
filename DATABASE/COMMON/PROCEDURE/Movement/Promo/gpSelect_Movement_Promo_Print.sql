-- Function: gpSelect_Movement_Promo_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Promo());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
        SELECT
            Movement_Promo.Id
          , Movement_Promo.InvNumber
          , Movement_Promo.OperDate
          , Movement_Promo.PromoKindName      --Вид акции
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.OperDateStart      --Дата начала расч. продаж до акции
          , Movement_Promo.OperDateEnd        --Дата окончания расч. продаж до акции
          , Movement_Promo.CostPromo          --Стоимость участия в акции
          , Movement_Promo.Comment            --Примечание
          , Movement_Promo.AdvertisingName    --Рекламная поддержка
          , Movement_Promo.UnitName           --Подразделение
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalName       --Ответственный представитель маркетингового отдела	
        FROM
            Movement_Promo_View AS Movement_Promo
        WHERE 
            Movement_Promo.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        SELECT
            MI_PromoGoods.Id               --идентификатор
          , MI_PromoGoods.GoodsCode        --код объекта  <товар>
          , MI_PromoGoods.GoodsName        --наименование объекта <товар>
          , MI_PromoGoods.Amount           --% скидки на товар
          , MI_PromoGoods.Price            --Цена в прайсе
          , MI_PromoGoods.PriceWithOutVAT  --Цена отгрузки без учета НДС, с учетом скидки, грн
          , MI_PromoGoods.PriceWithVAT     --Цена отгрузки с учетом НДС, с учетом скидки, грн
          , MI_PromoGoods.AmountReal       --Объем продаж в аналогичный период, кг
          , MI_PromoGoods.AmountPlanMin    --Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMax    --Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.GoodsKindName    --Наименование обьекта <Вид товара>
        FROM
            MovementItem_PromoGoods_View AS MI_PromoGoods
        WHERE
            MI_PromoGoods.MovementId = inMovementId
            AND
            MI_PromoGoods.isErased = FALSE 
        ORDER BY
            MI_PromoGoods.GoodsKindName
          , MI_PromoGoods.GoodsName;

    RETURN NEXT Cursor2;

    OPEN Cursor3 FOR
        SELECT
            MI_PromoCondition.Id                 --идентификатор
          , MI_PromoCondition.ConditionPromoName --наименование объекта <Условие участия в акции>
          , MI_PromoCondition.Amount             --значение
        FROM
            MovementItem_PromoCondition_View AS MI_PromoCondition
        WHERE
            MI_PromoCondition.MovementId = inMovementId
            AND
            MI_PromoCondition.isErased = FALSE 
        ORDER BY
            MI_PromoCondition.PromoConditionName;

    RETURN NEXT Cursor3;
    
    OPEN Cursor4 FOR
        SELECT
            Movement_Promo.Id                 --идентификатор
          , Movement_Promo.PartnerId          --Покупатель для акции
          , Movement_Promo.PartnerName        --Покупатель для акции
          , Movement_Promo.PartnerDescName    --Тип Покупатель для акции
        FROM
            Movement_Promo_View AS Movement_Promo
        WHERE
            MI_PromoCondition.ParentId = inMovementId
        ORDER BY
            Movement_Promo.PartnerDescName
          , Movement_Promo.PartnerName;

    RETURN NEXT Cursor4;

    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Promo_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
 31.10.15                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Promo_Print (inMovementId := 570596, inSession:= '5');
