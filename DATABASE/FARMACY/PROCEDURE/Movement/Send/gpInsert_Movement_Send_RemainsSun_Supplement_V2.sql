-- Function: gpInsert_Movement_Send_RemainsSun_Supplement

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun_Supplement_V2 (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun_Supplement_V2(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbObjectId   Integer;
   DECLARE vbisShoresSUN Boolean;
   DECLARE vbDOW_curr    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     SELECT COALESCE(ObjectBoolean_CashSettings_ShoresSUN.ValueData, FALSE) 
     INTO vbisShoresSUN
     FROM Object AS Object_CashSettings
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_ShoresSUN
                                  ON ObjectBoolean_CashSettings_ShoresSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_ShoresSUN.DescId = zc_ObjectBoolean_CashSettings_ShoresSUN()
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;
     
     IF vbisShoresSUN = TRUE
     THEN
       -- день недели
       vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                     FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                    );
                    
       IF NOT EXISTS(SELECT Object_Unit.Id
                     FROM Object AS Object_Unit
                         LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = Object_Unit.Id AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_Supplement_V2_in
                                                 ON ObjectBoolean_SUN_v2_Supplement_V2_in.ObjectId = Object_Unit.Id
                                                AND ObjectBoolean_SUN_v2_Supplement_V2_in.DescId = zc_ObjectBoolean_Unit_SUN_v2_Supplement_in()
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_Supplement_V2_out
                                                 ON ObjectBoolean_SUN_v2_Supplement_V2_out.ObjectId = Object_Unit.Id
                                                AND ObjectBoolean_SUN_v2_Supplement_V2_out.DescId = zc_ObjectBoolean_Unit_SUN_v2_Supplement_out()                                    
                     WHERE Object_Unit.DescId = zc_Object_Unit()
                       -- если указан день недели - проверим его
                       AND OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' 
                       AND (COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_in.ValueData, FALSE) = TRUE 
                         OR COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_out.ValueData, FALSE) = TRUE)   )
       THEN 
         vbisShoresSUN := FALSE;
       END IF;
     END IF;

     -- все Подразделения для схемы SUN Supplement_V2
     CREATE TEMP TABLE _tmpUnit_SUN_Supplement_V2 (UnitId Integer, DeySupplOut Integer, DeySupplIn Integer, isSUN_Supplement_V2_in Boolean, isSUN_Supplement_V2_out Boolean, isSUN_Supplement_V2_Priority Boolean, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean, isColdOutSUN Boolean) ON COMMIT DROP;

     -- Выкладки
     CREATE TEMP TABLE _tmpGoodsLayout_SUN_Supplement_V2 (GoodsId Integer, UnitId Integer, Layout TFloat, isNotMoveRemainder6 boolean, MovementLayoutId Integer) ON COMMIT DROP;

     -- Маркетинговый план для точек
     CREATE TEMP TABLE _tmpGoods_PromoUnit_Supplement_V2 (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- Товары дисконтных проектов
     CREATE TEMP TABLE _tmpGoods_DiscountExternal_Supplement_V2  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     CREATE TEMP TABLE _tmpGoods_TP_exception_Supplement_V2   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- Уже использовано в текущем СУН
     CREATE TEMP TABLE _tmpGoods_Sun_exception_Supplement_V2   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- исключаем такие перемещения
     CREATE TEMP TABLE _tmpUnit_SunExclusion_Supplement_V2 (UnitId_from Integer, UnitId_to Integer) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all_Supplement_V2 (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Layout TFloat, PromoUnit TFloat, AmountRemains TFloat, AmountNotSend TFloat, 
                                                      AmountSalesDay TFloat, Need TFloat, Give TFloat, AmountUse TFloat, 
                                                      MinExpirationDate TDateTime, isCloseMCS boolean) ON COMMIT DROP;

     -- 3. распределяем-1 остатки - по всем аптекам
     CREATE TEMP TABLE _tmpResult_Supplement_V2   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;

     -- !!!1 - сформировали данные во временные табл!!!
     IF EXISTS (SELECT Object_Goods_Retail.ID
                     , Object_Goods_Retail.KoeffSUN_V2
                FROM Object_Goods_Retail
                     INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                 AND Object_Goods_Main.isSupplementSUN2 = TRUE
                WHERE Object_Goods_Retail.RetailID = vbObjectId)     
     THEN
       PERFORM lpInsert_Movement_Send_RemainsSun_Supplement_V2_Sum (inOperDate:= inOperDate
                                                                  , inDriverId:= 0 -- vbDriverId_1
                                                                  , inUserId  := vbUserId
                                                                    );
     ELSE
       PERFORM lpInsert_Movement_Send_RemainsSun_Supplement_V2 (inOperDate:= inOperDate
                                                              , inDriverId:= 0 -- vbDriverId_1
                                                              , inUserId  := vbUserId
                                                               );
     END IF;

     --raise notice 'Value 06: %', (select Count(*) from _tmpResult_Supplement_V2);

     --DELETE FROM _tmpResult_Supplement_V2
     --WHERE _tmpResult_Supplement_V2.UnitId_to <> (SELECT _tmpResult_Supplement_V2.UnitId_to FROM _tmpResult_Supplement_V2 LIMIT 1);
          
     -- создали документы
     UPDATE _tmpResult_Supplement_V2 SET MovementId = tmp.MovementId
     FROM (SELECT tmp.UnitId_from
                , tmp.UnitId_to
                , gpInsertUpdate_Movement_Send (ioId               := 0
                                              , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                              , inOperDate         := inOperDate
                                              , inFromId           := UnitId_from
                                              , inToId             := UnitId_to
                                              , inComment          := 'Распределение товара по сети согласно дополнению к СУН2'
                                              , inChecked          := FALSE
                                              , inisComplete       := FALSE
                                              , inNumberSeats      := 1
                                              , inDriverSunId      := 0
                                              , inSession          := inSession
                                               ) AS MovementId

           FROM (SELECT DISTINCT _tmpResult_Supplement_V2.UnitId_from, _tmpResult_Supplement_V2.UnitId_to FROM _tmpResult_Supplement_V2 WHERE _tmpResult_Supplement_V2.Amount > 0) AS tmp
          ) AS tmp
     WHERE _tmpResult_Supplement_V2.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Supplement_V2.UnitId_to   = tmp.UnitId_to
          ;

     -- сохранили свойство <Перемещение по СУН> + isAuto + zc_Enum_PartionDateKind_6
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v2(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
     FROM (SELECT DISTINCT _tmpResult_Supplement_V2.MovementId FROM _tmpResult_Supplement_V2 WHERE _tmpResult_Supplement_V2.Amount > 0
          ) AS tmp;


     -- 6.1. создали строки - Перемещение по СУН
     UPDATE _tmpResult_Supplement_V2 SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inCommentSendID        := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Supplement_V2 AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp
     WHERE _tmpResult_Supplement_V2.MovementId = tmp.MovementId
       AND _tmpResult_Supplement_V2.GoodsId    = tmp.GoodsId
          ;

     -- 8. Удаляем документы, что б не мешали
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Supplement_V2.MovementId FROM _tmpResult_Supplement_V2 WHERE _tmpResult_Supplement_V2.MovementId > 0
          ) AS tmp;

     -- Частим товары
     IF EXISTS(SELECT _tmpResult_Supplement_V2.MovementId FROM _tmpResult_Supplement_V2 WHERE _tmpResult_Supplement_V2.MovementId > 0) AND 
        vbisShoresSUN = False
     THEN
       
       PERFORM gpUpdate_Goods_inSupplementSUN2_Revert(inGoodsMainId       := Object_Goods_Main.Id 
                                                    , inisSupplementSUN2  := Object_Goods_Main.isSupplementSUN2
                                                    , inSession           := inSession)
       FROM Object_Goods_Main 
       WHERE Object_Goods_Main.isSupplementSUN2 = True;
     END IF;
             
   --  raise notice 'Value 05: % %', (select Count(*) from _tmpResult_Supplement_V2 WHERE _tmpResult_Supplement_V2.MovementId > 0), vbisShoresSUN;      
   --  RAISE EXCEPTION '<ok>';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.19                                        *
*/

-- тест SELECT * FROM gpInsert_Movement_Send_RemainsSun_Supplement_V2 (inOperDate:= CURRENT_DATE + INTERVAL '2 DAY', inSession:= zfCalc_UserAdmin()) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ