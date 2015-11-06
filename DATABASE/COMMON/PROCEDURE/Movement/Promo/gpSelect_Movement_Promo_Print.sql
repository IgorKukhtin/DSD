-- Function: gpSelect_Movement_Promo_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE(LineNo Integer,
              GroupName TVarChar,
              LineName TVarChar,
              LineValue TEXT)
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbValue TVarChar; 
    
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Promo());
    vbUserId:= inSession;

    RETURN QUERY
        SELECT
            1 as LineNo,
            ''::TVarChar as GroupName,
            'Сеть (Наименование сети, регионы на которые распространяется акция)'::TVarChar as LineName,
            (SELECT STRING_AGG(Movement_PromoPartner.PartnerName, chr(13)||chr(10)) 
             FROM Movement_PromoPartner_View AS Movement_PromoPartner 
             WHERE Movement_PromoPartner.ParentId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            2 as LineNo,
            ''::TVarChar as GroupName,
            'Период акции (На полке)'::TVarChar as LineName,
            (SELECT 
                CAST(Movement_Promo.StartPromo as TVarChar)||' - '||CAST(Movement_Promo.EndPromo as TVarChar)
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            3 as LineNo,
            ''::TVarChar as GroupName,
            'Период отгрузки по акционной цене в сети'::TVarChar as LineName,
            (SELECT 
                CAST(Movement_Promo.StartSale as TVarChar)||' - '||CAST(Movement_Promo.EndSale as TVarChar)
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            4 as LineNo,
            ''::TVarChar as GroupName,
            'Стоимость участия, грн'::TVarChar as LineName,
            (SELECT 
                CAST(Movement_Promo.CostPromo as TVarChar)
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            5 as LineNo,
            ''::TVarChar as GroupName,
            'Условия участия (в счет маркетингового бюджета или по выставленному счету)'::TVarChar as LineName,
            (SELECT STRING_AGG(MovementItem_PromoCondition.ConditionPromoName||chr(9)||CAST(MovementItem_PromoCondition.Amount as TVarChar), chr(13)||chr(10)) 
             FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition 
             WHERE MovementItem_PromoCondition.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            6 as LineNo,
            ''::TVarChar as GroupName,
            'Позиции'::TVarChar as LineName,
            (SELECT STRING_AGG(MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            7 as LineNo,
            ''::TVarChar as GroupName,
            '% дополнительной скидки'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.Amount AS TVarChar)||'%'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            8 as LineNo,
            ''::TVarChar as GroupName,
            'Цена отгрузки без учета НДС, с учетом скидки, грн'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.PriceWithOutVAT AS TVarChar)||'грн.'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            9 as LineNo,
            ''::TVarChar as GroupName,
            'Цена отгрузки с учетом НДС, с учетом скидки, грн'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.PriceWithVAT AS TVarChar)||'грн.'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            10 as LineNo,
            ''::TVarChar as GroupName,
            'Объем продаж в аналогичный период, кг'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.AmountReal AS TVarChar)||'кг'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            11 as LineNo,
            ''::TVarChar as GroupName,
            'Планируемый объем продаж на акционный период (в кг)'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.AmountPlanMin AS TVarChar)||' - '||CAST(MI_PromoGoods.AmountPlanMax AS TVarChar)||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            12 as LineNo,
            ''::TVarChar as GroupName,
            'Вид упаковки'::TVarChar as LineName,
            (SELECT STRING_AGG(MI_PromoGoods.GoodsName||': '||MI_PromoGoods.GoodsKindName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            13 as LineNo,
            ''::TVarChar as GroupName,
            'Количество товара поставляемого в период акции в данном виде упаковки, кг'::TVarChar as LineName,
            (SELECT STRING_AGG('_______'||Chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            13 as LineNo,
            ''::TVarChar as GroupName,
            'Рекламная поддержка (газета, сопровождение наружной рекламой (сити-лайтами, билбордами), ТВ, радио, дегустации и прочее)'::TVarChar as LineName,
            (SELECT Movement_Promo.AdvertisingName 
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            NULL as LineNo,
            'Дополнительная информация'::TVarChar as GroupName,
            'Цена в прайс-листе (грн)'::TVarChar as LineName,
            (SELECT STRING_AGG(CAST(MI_PromoGoods.Price AS TVarChar)||'грн.'||chr(9)||MI_PromoGoods.GoodsName, chr(13)||chr(10)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            NULL as LineNo,
            'Дополнительная информация'::TVarChar as GroupName,
            'Ответственный представитель коммерческого отдела'::TVarChar as LineName,
            (SELECT Movement_Promo.PersonalTradeName 
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            NULL as LineNo,
            'Дополнительная информация'::TVarChar as GroupName,
            'Ответственный представитель маркетингового отдела'::TVarChar as LineName,
            (SELECT Movement_Promo.PersonalName 
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Promo_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
 31.10.15                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Promo_Print (inMovementId := 2139691, inSession:= '5');
