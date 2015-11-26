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
    DECLARE vbCountGoods Integer;
    DECLARE vbVAT TFloat;
    DECLARE vbPriceList Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Promo());
    vbUserId:= inSession;

    SELECT
        COUNT(*)
    INTO
        vbCountGoods
    FROM
        MovementItem_PromoGoods_View AS MI_PromoGoods
    WHERE MI_PromoGoods.MovementId = inMovementId
      AND MI_PromoGoods.IsErased = FALSE;
    
    --узнали прайслист
    SELECT
        COALESCE(Movement_Promo.PriceListId,zc_PriceList_Basis())
    INTO
        vbPriceList
    FROM
        Movement_Promo_View AS Movement_Promo
    WHERE
        Movement_Promo.Id = inMovementId;
    --вытащили значение "с НДС" и "значение НДС"
    SELECT
       PriceList.VATPercent
    INTO
       vbVAT
    FROM
        gpGet_Object_PriceList(vbPriceList,inSession) as PriceList;
    
    RETURN QUERY
        SELECT
            1 as LineNo,
            ''::TVarChar as GroupName,
            'Сеть (Наименование сети, регионы на которые распространяется акция)'::TVarChar as LineName,
            (SELECT STRING_AGG(Movement_PromoPartner.PartnerName, chr(13)) 
             FROM Movement_PromoPartner_View AS Movement_PromoPartner 
             WHERE Movement_PromoPartner.ParentId = inMovementId
               AND Movement_PromoPartner.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            2 as LineNo,
            ''::TVarChar as GroupName,
            'Период акции (На полке)'::TVarChar as LineName,
            (SELECT 
                TO_CHAR(Movement_Promo.StartPromo , 'DD.MM.YYYY')||' - '||TO_CHAR(Movement_Promo.EndPromo, 'DD.MM.YYYY')
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            3 as LineNo,
            ''::TVarChar as GroupName,
            'Период отгрузки по акционной цене в сети'::TVarChar as LineName,
            (SELECT 
                TO_CHAR(Movement_Promo.StartSale, 'DD.MM.YYYY')||' - '||TO_CHAR(Movement_Promo.EndSale, 'DD.MM.YYYY')
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            4 as LineNo,
            ''::TVarChar as GroupName,
            'Стоимость участия, грн'::TVarChar as LineName,
            (SELECT 
                replace(TO_CHAR(Movement_Promo.CostPromo, 'FM9990D09')||' ','.0 ','')
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            5 as LineNo,
            ''::TVarChar as GroupName,
            'Условия участия (в счет маркетингового бюджета или по выставленному счету)'::TVarChar as LineName,
            (SELECT STRING_AGG(MovementItem_PromoCondition.ConditionPromoName||': '||replace(TO_CHAR(MovementItem_PromoCondition.Amount,'FM9990D09')||' ','.0 ',''), chr(13)) 
             FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition 
             WHERE MovementItem_PromoCondition.MovementId = inMovementId
               AND MovementItem_PromoCondition.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            6 as LineNo,
            ''::TVarChar as GroupName,
            'Позиции'::TVarChar as LineName,
            (SELECT STRING_AGG(MI_PromoGoods.GoodsName, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            7 as LineNo,
            ''::TVarChar as GroupName,
            '% дополнительной скидки'::TVarChar as LineName,
            (SELECT STRING_AGG(replace(TO_CHAR(MI_PromoGoods.Amount,'FM9990D09')||' ','.0 ','')||'%   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            8 as LineNo,
            ''::TVarChar as GroupName,
            'Цена отгрузки без учета НДС, с учетом скидки, грн'::TVarChar as LineName,
            (SELECT STRING_AGG(replace(TO_CHAR(MI_PromoGoods.PriceWithOutVAT,'FM9990D09')||' ','.0 ','')||'   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            9 as LineNo,
            ''::TVarChar as GroupName,
            'Цена отгрузки с учетом НДС, с учетом скидки, грн'::TVarChar as LineName,
            (SELECT STRING_AGG(replace(TO_CHAR(MI_PromoGoods.PriceWithVAT,'FM9990D09')||' ','.0 ','')||'   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            10 as LineNo,
            ''::TVarChar as GroupName,
            'Объем продаж в аналогичный период, кг'::TVarChar as LineName,
            (SELECT STRING_AGG(replace(TO_CHAR(MI_PromoGoods.AmountReal,'FM9990D09')||' ','.0 ','')||'   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            11 as LineNo,
            ''::TVarChar as GroupName,
            'Планируемый объем продаж на акционный период (в кг)'::TVarChar as LineName,
            (SELECT STRING_AGG(replace(TO_CHAR(MI_PromoGoods.AmountPlanMin,'FM9990D09')||' ','.0 ','')||' - '||replace(TO_CHAR(MI_PromoGoods.AmountPlanMax,'FM9990D09')||' ','.0 ','')||'   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            12 as LineNo,
            ''::TVarChar as GroupName,
            'Вид упаковки'::TVarChar as LineName,
            (SELECT STRING_AGG(CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName||': ' ELSE '' END||MI_PromoGoods.GoodsKindName, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            13 as LineNo,
            ''::TVarChar as GroupName,
            'Количество товара поставляемого в период акции в данном виде упаковки, кг'::TVarChar as LineName,
            (SELECT STRING_AGG('_______    '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            14 as LineNo,
            ''::TVarChar as GroupName,
            'Рекламная поддержка (газета, сопровождение наружной рекламой (сити-лайтами, билбордами), ТВ, радио, дегустации и прочее)'::TVarChar as LineName,
            (SELECT STRING_AGG(Movement_PromoAdvertising.AdvertisingName, chr(13)) 
             FROM Movement_PromoAdvertising_View AS Movement_PromoAdvertising
             WHERE Movement_PromoAdvertising.ParentId = inMovementId
               AND Movement_PromoAdvertising.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            NULL as LineNo,
            'Дополнительная информация'::TVarChar as GroupName,
            'Цена в прайс-листе с НДС (грн)'::TVarChar as LineName,
            (SELECT STRING_AGG(replace(TO_CHAR(ROUND(MI_PromoGoods.Price*((100+vbVAT)/100),2),'FM9990D09')||' ','.0 ','')||'   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13))
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
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
