-- Function: gpUpdate_MovementItem_PromoGoods_Plan()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Plan (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoGoods_Plan(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inAmountPlan1           TFloat    , --
    IN inAmountPlan2           TFloat    , --
    IN inAmountPlan3           TFloat    , --
    IN inAmountPlan4           TFloat    , --
    IN inAmountPlan5           TFloat    , --
    IN inAmountPlan6           TFloat    , --
    IN inAmountPlan7           TFloat    , --
   OUT outAmountPlan1_wh       TFloat    ,
   OUT outAmountPlan2_wh       TFloat    ,
   OUT outAmountPlan3_wh       TFloat    ,
   OUT outAmountPlan4_wh       TFloat    ,
   OUT outAmountPlan5_wh       TFloat    ,
   OUT outAmountPlan6_wh       TFloat    ,
   OUT outAmountPlan7_wh       TFloat    ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbMeasureId       Integer;
   DECLARE vbGoodsWeight     TFloat;
   DECLARE vbUserId_PersonalTrade Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    
    -- находим пользователя PersonalTrade
    vbUserId_PersonalTrade := (SELECT ObjectLink_User_Member.ObjectId
                               FROM MovementItem
                                   LEFT JOIN MovementLinkObject AS MLO_PersonalTrade
                                          ON MLO_PersonalTrade.MovementId = MovementItem.MovementId
                                         AND MLO_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                       ON ObjectLink_Personal_Member.ObjectId = MLO_PersonalTrade.ObjectId
                                                      AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                   LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                        ON ObjectLink_User_Member.ChildObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                       AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                               WHERE MovementItem.Id = inId);
                               
    -- изменение данных только для PersonalTradeName + или если разрешены права zc_Enum_Process_Update_MI_Promo_Plan                      
    IF COALESCE (vbUserId_PersonalTrade, 0) <> vbUserId
    THEN                
        -- проверка прав пользователя на вызов процедуры
        vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Promo_Plan());
    END IF;

    -- сохраняем 
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan1(), inId, inAmountPlan1);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan2(), inId, inAmountPlan2);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan3(), inId, inAmountPlan3);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan4(), inId, inAmountPlan4);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan5(), inId, inAmountPlan5);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan6(), inId, inAmountPlan6);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan7(), inId, inAmountPlan7);
    
    --
    SELECT ObjectLink_Goods_Measure.ChildObjectId
         , COALESCE (ObjectFloat_Goods_Weight.ValueData, 0) ::TFloat
      INTO vbMeasureId, vbGoodsWeight
    FROM MovementItem AS MI_PromoGoods
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                              ON ObjectLink_Goods_Measure.ObjectId = MI_PromoGoods.ObjectId
                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
         
         LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                     ON ObjectFloat_Goods_Weight.ObjectId = MI_PromoGoods.ObjectId
                                    AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()   
    WHERE MI_PromoGoods.Id = inId
      AND MI_PromoGoods.DescId = zc_MI_Master()
      AND MI_PromoGoods.IsErased = FALSE;
       
                                              
    outAmountPlan1_wh := (inAmountPlan1 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan2_wh := (inAmountPlan2 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan3_wh := (inAmountPlan3 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan4_wh := (inAmountPlan4 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan5_wh := (inAmountPlan5 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan6_wh := (inAmountPlan6 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan7_wh := (inAmountPlan7 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 10.11.17         *
*/
-- test 
-- select * from gpUpdate_MI_PromoGoods_Plan(inId := 64152049 , inAmountPlan1 := 2 , inAmountPlan2 := 0 , inAmountPlan3 := 0 , inAmountPlan4 := 0 , inAmountPlan5 := 0 , inAmountPlan6 := 0 , inAmountPlan7 := 0 ,  inSession := '887408');
--select * from gpUpdate_MI_PromoGoods_Plan(inId := 64803248 , inAmountPlan1 := 0 , inAmountPlan2 := 0 , inAmountPlan3 := 5 , inAmountPlan4 := 0 , inAmountPlan5 := 0 , inAmountPlan6 := 0 , inAmountPlan7 := 0 ,  inSession := '893419');
