-- Function: gpUpdate_MovementItem_PromoGoods_Plan_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Plan_byReport (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoGoods_Plan_byReport (
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioAmountPlan1           TFloat    , --
 INOUT ioAmountPlan2           TFloat    , --
 INOUT ioAmountPlan3           TFloat    , --
 INOUT ioAmountPlan4           TFloat    , --
 INOUT ioAmountPlan5           TFloat    , --
 INOUT ioAmountPlan6           TFloat    , --
 INOUT ioAmountPlan7           TFloat    , --
   OUT outAmountPlan1_wh       TFloat    ,
   OUT outAmountPlan2_wh       TFloat    ,
   OUT outAmountPlan3_wh       TFloat    ,
   OUT outAmountPlan4_wh       TFloat    ,
   OUT outAmountPlan5_wh       TFloat    ,
   OUT outAmountPlan6_wh       TFloat    ,
   OUT outAmountPlan7_wh       TFloat    ,
    IN inisPlan1               Boolean   ,
    IN inisPlan2               Boolean   ,
    IN inisPlan3               Boolean   ,
    IN inisPlan4               Boolean   ,
    IN inisPlan5               Boolean   ,
    IN inisPlan6               Boolean   ,
    IN inisPlan7               Boolean   ,
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
    IF inisPlan1 = TRUE THEN PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan1(), inId, ioAmountPlan1); ELSE ioAmountPlan1 := 0; END IF;
    IF inisPlan2 = TRUE THEN PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan2(), inId, ioAmountPlan2); ELSE ioAmountPlan2 := 0; END IF;
    IF inisPlan3 = TRUE THEN PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan3(), inId, ioAmountPlan3); ELSE ioAmountPlan3 := 0; END IF;
    IF inisPlan4 = TRUE THEN PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan4(), inId, ioAmountPlan4); ELSE ioAmountPlan4 := 0; END IF;
    IF inisPlan5 = TRUE THEN PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan5(), inId, ioAmountPlan5); ELSE ioAmountPlan5 := 0; END IF;
    IF inisPlan6 = TRUE THEN PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan6(), inId, ioAmountPlan6); ELSE ioAmountPlan6 := 0; END IF;
    IF inisPlan7 = TRUE THEN PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan7(), inId, ioAmountPlan7); ELSE ioAmountPlan7 := 0; END IF;
    
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
       
                                              
    outAmountPlan1_wh := (ioAmountPlan1 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan2_wh := (ioAmountPlan2 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan3_wh := (ioAmountPlan3 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan4_wh := (ioAmountPlan4 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan5_wh := (ioAmountPlan5 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan6_wh := (ioAmountPlan6 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
    outAmountPlan7_wh := (ioAmountPlan7 * CASE WHEN vbMeasureId = zc_Measure_Sh() THEN vbGoodsWeight ELSE 1 END)  ::TFloat;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 10.11.17         *
*/
-- test 
-- select * from gpUpdate_MI_PromoGoods_Plan_byReport(inId := 64152049 , ioAmountPlan1 := 2 , ioAmountPlan2 := 0 , ioAmountPlan3 := 0 , ioAmountPlan4 := 0 , ioAmountPlan5 := 0 , ioAmountPlan6 := 0 , ioAmountPlan7 := 0 ,  inSession := '887408');
--select * from gpUpdate_MI_PromoGoods_Plan_byReport(inId := 64803248 , ioAmountPlan1 := 0 , ioAmountPlan2 := 0 , ioAmountPlan3 := 5 , ioAmountPlan4 := 0 , ioAmountPlan5 := 0 , ioAmountPlan6 := 0 , ioAmountPlan7 := 0 ,  inSession := '893419');
