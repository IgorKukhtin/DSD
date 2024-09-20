-- Function: gpSelect_Movement_Promo_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE(LineNo TVarChar,
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
    vbUserId:= lpGetUserBySession (inSession);

    SELECT COUNT(*) INTO vbCountGoods
    FROM (SELECT DISTINCT MI_PromoGoods.GoodsName
          FROM MovementItem_PromoGoods_View AS MI_PromoGoods
          WHERE MI_PromoGoods.MovementId = inMovementId
            AND MI_PromoGoods.IsErased = FALSE
         ) AS tmp;
    
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
            '1' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Сеть (Наименование сети, регионы на которые распространяется акция)'::TVarChar as LineName,
            (SELECT STRING_AGG (CASE WHEN Movement_PromoPartner.Retail_Name <> '' THEN Movement_PromoPartner.Retail_Name || ' ' ELSE '' END || Movement_PromoPartner.PartnerName, chr(13)) 
             FROM Movement_PromoPartner_View AS Movement_PromoPartner 
             WHERE Movement_PromoPartner.ParentId = inMovementId
               AND Movement_PromoPartner.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            '2' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Период акции (На полке)'::TVarChar as LineName,
            (SELECT 
                TO_CHAR(Movement_Promo.StartPromo , 'DD.MM.YYYY')||' - '||TO_CHAR(Movement_Promo.EndPromo, 'DD.MM.YYYY')
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            '3' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Период отгрузки по акционной цене в сети'::TVarChar as LineName,
            (SELECT 
                TO_CHAR(Movement_Promo.StartSale, 'DD.MM.YYYY')||' - '||TO_CHAR(Movement_Promo.EndSale, 'DD.MM.YYYY')
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue

       UNION ALL
        SELECT
            '4.1.' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Стоимость участия, грн'::TVarChar as LineName,
            (SELECT 
                REPLACE(TO_CHAR(Movement_Promo.CostPromo, 'FM9999990.99')||' ','. ','')
                -- REPLACE(TO_CHAR(Movement_Promo.CostPromo, 'FM9990D99')||' ',', ','')
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
       UNION ALL
        SELECT
            '4.2.' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Компенсация, грн'::TVarChar as LineName,
            (SELECT zfConvert_FloatToString (SUM (MI_PromoGoods.SummOutMarket))
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE
               AND MI_PromoGoods.SummOutMarket <> 0
            )::TEXT AS LineValue
        UNION ALL

        SELECT
            '5' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Условия участия (в счет маркетингового бюджета или по выставленному счету)'::TVarChar as LineName,
            (SELECT Movement_Promo.PromoKindName FROM Movement_Promo_View AS Movement_Promo WHERE Movement_Promo.Id = inMovementId) :: TEXT AS LineValue
            /*(SELECT STRING_AGG(MovementItem_PromoCondition.ConditionPromoName||': '||replace(TO_CHAR(MovementItem_PromoCondition.Amount,'FM9999990D099999999')||' ','.0 ',''), chr(13)||chr(10)) 
             FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition 
             WHERE MovementItem_PromoCondition.MovementId = inMovementId
               AND MovementItem_PromoCondition.IsErased = FALSE)::TEXT AS LineValue*/
        UNION ALL
        SELECT
            '6' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Позиции'::TVarChar as LineName,
            (SELECT STRING_AGG( DISTINCT MI_PromoGoods.GoodsCode :: TVarChar || ' ' || MI_PromoGoods.GoodsName, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            '7.1' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            '% скидки'::TVarChar as LineName,
            (SELECT STRING_AGG( DISTINCT REPLACE(TO_CHAR(MI_PromoGoods.Amount,'FM9999990D099999999')||' ','.0 ','')||'%   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            '7.2' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            '% дополнительной скидки'::TVarChar as LineName,
            (SELECT STRING_AGG(MovementItem_PromoCondition.ConditionPromoName||': '||REPLACE(TO_CHAR(MovementItem_PromoCondition.Amount,'FM9999990D099999999')||' ','.0 ',''), chr(13)) 
             FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition 
             WHERE MovementItem_PromoCondition.MovementId = inMovementId
               AND MovementItem_PromoCondition.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            '8' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Цена отгрузки без учета НДС, с учетом скидки, грн'::TVarChar as LineName,
            (SELECT STRING_AGG( DISTINCT CASE WHEN COALESCE(MI_PromoGoods.Amount,0)=0 THEN '«по спецификации»' ELSE REPLACE(TO_CHAR(MI_PromoGoods.PriceWithOutVAT,'FM9999990D099999999')||' ','.0 ','') END||'   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            '9' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Цена отгрузки с учетом НДС, с учетом скидки, грн'::TVarChar as LineName,
            (SELECT STRING_AGG( DISTINCT CASE WHEN COALESCE(MI_PromoGoods.Amount,0)=0 THEN '«по спецификации»' ELSE REPLACE(TO_CHAR(MI_PromoGoods.PriceWithVAT,'FM9999990D099999999')||' ','.0 ','') END||'   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            '10' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Объем продаж в аналогичный период'::TVarChar as LineName,
            (SELECT STRING_AGG( COALESCE (COALESCE ('*' || MI_PromoGoods.GoodsKindName, MI_PromoGoods.GoodsKindCompleteName) ||': ','') || COALESCE(REPLACE( TO_CHAR (MI_PromoGoods.AmountReal, 'FM9999990D099999999') ||' ','.0 ', ''),'0') || MI_PromoGoods.Measure || '   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13))
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            '11' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Планируемый объем продаж на акционный период'::TVarChar as LineName,
            (SELECT STRING_AGG( COALESCE (COALESCE ('*' || MI_PromoGoods.GoodsKindName, MI_PromoGoods.GoodsKindCompleteName) ||': ','') || COALESCE(REPLACE(TO_CHAR(MI_PromoGoods.AmountPlanMin,'FM9999990D099999999')||' ','.0 ',''),'0') || ' - '||COALESCE(REPLACE(TO_CHAR(MI_PromoGoods.AmountPlanMax,'FM9999990D099999999')||' ','.0 ',''),'0') || MI_PromoGoods.Measure || '   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
/*         UNION ALL
        UNION ALL
        SELECT
            '12' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Вид упаковки'::TVarChar as LineName,
            (SELECT STRING_AGG (MI_PromoGoods.GoodsKindName, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            '13' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Количество товара поставляемого в период акции в данном виде упаковки'::TVarChar as LineName,
            (SELECT STRING_AGG('_______' || MI_PromoGoods.Measure || ' ' ||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13)) 
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE)::TEXT AS LineValue*/
        UNION ALL
        SELECT
            '12' :: TVarChar AS LineNo,
            ''::TVarChar as GroupName,
            'Рекламная поддержка (газета, сопровождение наружной рекламой (сити-лайтами, билбордами), ТВ, радио, дегустации и прочее)'::TVarChar as LineName,
            (SELECT STRING_AGG(Movement_PromoAdvertising.AdvertisingName, chr(13)) 
             FROM Movement_PromoAdvertising_View AS Movement_PromoAdvertising
             WHERE Movement_PromoAdvertising.ParentId = inMovementId
               AND Movement_PromoAdvertising.IsErased = FALSE)::TEXT AS LineValue
        UNION ALL
        SELECT
            '' :: TVarChar AS LineNo,
            'Дополнительная информация'::TVarChar as GroupName,
            'Цена в прайс-листе клиента с НДС (грн)'::TVarChar as LineName,
            (SELECT STRING_AGG( DISTINCT REPLACE(TO_CHAR(ROUND(MI_PromoGoods.Price*((100+vbVAT)/100),2),'FM9999990D099999999')||' ','.0 ','')||'   '||CASE WHEN vbCountGoods > 1 THEN MI_PromoGoods.GoodsName ELSE '' END, chr(13))
             FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             WHERE MI_PromoGoods.MovementId = inMovementId
               AND MI_PromoGoods.IsErased = FALSE
               AND MI_PromoGoods.Price <> 0
               )::TEXT AS LineValue
        UNION ALL
        SELECT
            '' :: TVarChar AS LineNo,
            'Дополнительная информация'::TVarChar as GroupName,
            'Ответственный представитель коммерческого отдела'::TVarChar as LineName,
            (SELECT Movement_Promo.PersonalTradeName 
             FROM Movement_Promo_View AS Movement_Promo
             WHERE Movement_Promo.Id = inMovementId)::TEXT AS LineValue
        UNION ALL
        SELECT
            '' :: TVarChar AS LineNo,
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
