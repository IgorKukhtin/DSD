-- Function: gpFarmacy_Scheduler()

DROP FUNCTION IF EXISTS gpFarmacy_Scheduler(TVarChar);

CREATE OR REPLACE FUNCTION gpFarmacy_Scheduler(
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 Text;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    IF COALESCE((SELECT count(*) as CountProc
                 FROM pg_stat_activity
                 WHERE state = 'active'
                   AND query ilike '%gpFarmacy_Scheduler%'), 0) > 1
    THEN
      Return;
    END IF;

    -- Создание технических переучетов
    BEGIN
       PERFORM gpInsertUpdate_Movement_TechnicalRediscount_Formation (inSession := zfCalc_UserAdmin());
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_Movement_TechnicalRediscount_Formation', True, text_var1::TVarChar, vbUserId);
    END;

    -- Установка главного товара в товарах поставщика
    BEGIN
      UPDATE Object_Goods_Juridical SET GoodsMainId = tmpLink.GoodsMainId
      FROM (select Max(ObjectLink_LinkGoods_Main_jur.ChildObjectId)  AS GoodsMainId
                            , ObjectLink_LinkGoods_Child_jur.ChildObjectId AS GoodsId
                       from  ObjectLink AS ObjectLink_LinkGoods_Main_jur

                             INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child_jur
                                                   ON ObjectLink_LinkGoods_Child_jur.ObjectId = ObjectLink_LinkGoods_Main_jur.ObjectId
                                                  AND ObjectLink_LinkGoods_Child_jur.DescId = zc_ObjectLink_LinkGoods_Goods()

                             INNER JOIN ObjectLink AS ObjectLink_Goods_Object_jur
                                                   ON ObjectLink_Goods_Object_jur.ObjectId = ObjectLink_LinkGoods_Child_jur.ChildObjectId
                                                  AND ObjectLink_Goods_Object_jur.DescId = zc_ObjectLink_Goods_Object()

                             INNER JOIN Object ON Object.Id =ObjectLink_Goods_Object_jur.ChildObjectId
                                              AND Object.DescId = zc_Object_Juridical()

                       where ObjectLink_LinkGoods_Main_jur.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                       group by ObjectLink_LinkGoods_Child_jur.ChildObjectId) AS tmpLink
      WHERE Object_Goods_Juridical.ID = tmpLink.GoodsId
        AND COALESCE (Object_Goods_Juridical.GoodsMainId, 0) <> COALESCE(tmpLink.GoodsMainId, 0);
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run UPDATE Object_Goods_Juridical', True, text_var1::TVarChar, vbUserId);
    END;

    -- Заполнение кошелька
    BEGIN
      IF date_part('DAY',  CURRENT_DATE)::Integer IN (1, 2) AND date_part('HOUR',  CURRENT_TIME)::Integer = 6
      THEN
         PERFORM gpSelect_Calculation_MoneyBoxSun (inUnitID := 0, inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Calculation_MoneyBoxSun', True, text_var1::TVarChar, vbUserId);
    END;

    -- Заполнение фонда
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer = '6' AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 30
      THEN
         PERFORM gpSelect_Calculation_Retail_Fund (inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Calculation_Unit_Fund', True, text_var1::TVarChar, vbUserId);
    END;

    -- Создание полного списания
    BEGIN
      IF CURRENT_DATE = date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AND date_part('HOUR',  CURRENT_TIME)::Integer = 22
         AND NOT EXISTS(SELECT 1 FROM Movement
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                           ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                          AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()    
                              LEFT JOIN MovementBoolean AS MovementBoolean_FinalFormation
                                                        ON MovementBoolean_FinalFormation.MovementId = Movement.Id
                                                       AND MovementBoolean_FinalFormation.DescId = zc_MovementBoolean_FinalFormation()
                        WHERE Movement.OperDate  = date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                          AND Movement.DescId = zc_Movement_Loss()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND COALESCE(MovementLinkObject_ArticleLoss.ObjectId, 0) = 13892113
                          AND COALESCE(MovementBoolean_FinalFormation.ValueData, False) = True)
      THEN
         PERFORM grInsert_Movement_LossOverdue (inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run grInsert_Movement_LossOverdue', True, text_var1::TVarChar, vbUserId);
    END;

    -- Удаление старых отказанных VIP перемещений
    BEGIN
       PERFORM gpSetErased_Movement_Send(Movement.id, zfCalc_UserAdmin())
       FROM Movement
            INNER JOIN MovementBoolean AS MovementBoolean_VIP
                                       ON MovementBoolean_VIP.MovementId = Movement.Id
                                      AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

            INNER JOIN MovementBoolean AS MovementBoolean_Confirmed
                                       ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                      AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
       WHERE Movement.DescId = zc_Movement_Send()
         AND Movement.StatusId = zc_Enum_Status_UnComplete()
         AND Movement.OperDate < CURRENT_DATE
         AND COALESCE (MovementBoolean_VIP.ValueData, FALSE) = TRUE
         AND COALESCE (MovementBoolean_Confirmed.ValueData, FALSE) = FALSE      
         AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE; 
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run SetErased_Movement_Send_VIP', True, text_var1::TVarChar, vbUserId);
    END;

    -- Простановка первого чека
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer = '6' AND date_part('MINUTE',  CURRENT_TIME)::Integer > 30
      THEN
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_FirstCheck(), tmpMovementCheck.UnitId, tmpMovementCheck.OperDate)
         FROM (SELECT AnalysisContainerItem.UnitId 
                    , MIN(AnalysisContainerItem.OperDate)    AS OperDate
               FROM AnalysisContainerItem
               WHERE AnalysisContainerItem.AmountCheck > 0
               GROUP BY AnalysisContainerItem.UnitId) AS tmpMovementCheck;
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run FirstCheck', True, text_var1::TVarChar, vbUserId);
    END;

    -- Правка вип чеков по НДС, срокам и исключенимм
    BEGIN
      PERFORM gpUpdate_MovementItem_DeferredLincObject (inSession := zfCalc_UserAdmin());
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_MovementItem_DeferredLincObject', True, text_var1::TVarChar, vbUserId);
    END;

    -- Корректировка остатка по таблеткам
    BEGIN
      PERFORM gpUpdate_MovementItem_RemainingAdjustment (inSession := zfCalc_UserAdmin());
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_MovementItem_RemainingAdjustment', True, text_var1::TVarChar, vbUserId);
    END;

    -- Удаление заказо по таблеткам без наличия
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer in (9, 12, 19) AND date_part('HOUR',  CURRENT_TIME)::Integer <= 21
      THEN
        PERFORM gpErased_Movement_Check_Booking_Tabletki (inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpErased_Movement_Check_Booking_Tabletki', True, text_var1::TVarChar, vbUserId);
    END;

    -- Перерасчет ЗП каждый час
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer >= 9 AND date_part('HOUR',  CURRENT_TIME)::Integer <= 21 AND
         EXISTS(SELECT Movement.ID
                FROM Movement
                     LEFT JOIN MovementDate AS MovementDate_Calculation
                                            ON MovementDate_Calculation.MovementId = Movement.Id
                                           AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation()
                WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
                  AND Movement.DescId = zc_Movement_Wages()
                  AND (MovementDate_Calculation.ValueData IS NULL
                   OR MovementDate_Calculation.ValueData + INTERVAL '1 HOUR' <= CURRENT_TIMESTAMP))
      THEN
         PERFORM gpInsertUpdate_Movement_Wages_CalculationAll(inMovementId := (SELECT Movement.ID
                                                                               FROM Movement
                                                                               WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
                                                                                 AND Movement.DescId = zc_Movement_Wages())
                                                           ,  inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_Movement_Wages_CalculationAll', True, text_var1::TVarChar, vbUserId);
    END;

    -- Сброс 5 категории через 30 дней
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer < 1 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 21
      THEN
          PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PartionGoods_Cat_5(), ContainerLinkObject.ObjectId , False)
          FROM Container
               INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                             AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                        
               INNER JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                        ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId    
                                       AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                       AND ObjectBoolean_PartionGoods_Cat_5.ValueData = True
                                                     
               INNER JOIN ObjectDate AS ObjectDate_PartionGoods_Cat_5
                                     ON ObjectDate_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId    
                                    AND ObjectDate_PartionGoods_Cat_5.DescId =zc_ObjectDate_PartionGoods_Cat_5() 

          WHERE Container.DescId = zc_Container_CountPartionDate()
            AND Container.Amount <> 0
            AND ObjectDate_PartionGoods_Cat_5.ValueData < CURRENT_DATE - INTERVAL '31 DAY';      
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run zc_ObjectBoolean_PartionGoods_Cat_5', True, text_var1::TVarChar, vbUserId);
    END;
    
    -- Простановка фиксированных сумм в ЗП
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer < 1 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 21
      THEN
          PERFORM  gpUpdate_Goods_SummaWages (T1.goodsid, 50, zfCalc_UserAdmin())
          FROM gpSelect_MovementItem_Promo(inMovementId := 20813880 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3') AS T1
               INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = T1.goodsid
          WHERE COALESCE(Object_Goods_Retail.SummaWages, 0) <> 50;

          PERFORM  gpUpdate_Goods_SummaWagesStore (T1.goodsid, 10, zfCalc_UserAdmin())
          FROM gpSelect_MovementItem_Promo(inMovementId := 20813880 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3') AS T1
               INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = T1.goodsid
          WHERE COALESCE(Object_Goods_Retail.SummaWagesStore, 0) <> 10;    
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_Goods_SummaWages', True, text_var1::TVarChar, vbUserId);
    END;
    
    -- Пропись в ЗП
    IF date_part('DAY',  CURRENT_DATE)::Integer = 1 AND date_part('HOUR',  CURRENT_TIME)::Integer = 5 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 30
    THEN

      -- Заполнение суммы по выполнению плана продаж
      BEGIN
         PERFORM gpUpdate_MovementItem_Wages_Marketing (inOperDate := CURRENT_DATE, inSession:=  zfCalc_UserAdmin());
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_MovementItem_Wages_Marketing', True, text_var1::TVarChar, vbUserId);
      END;    

      -- Заполнение суммы по плану по уменьшению кол-во неликвида
      BEGIN
         PERFORM gpUpdate_MovementItem_Wages_IlliquidAssets (inOperDate := CURRENT_DATE, inSession:=  zfCalc_UserAdmin());
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_MovementItem_Wages_IlliquidAssets', True, text_var1::TVarChar, vbUserId);
      END;    

      -- Заполнение суммы СП в дополнительные расходы
      BEGIN
         PERFORM gpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP (inOperDate := CURRENT_DATE - INTERVAL '1 DAY', inSession:=  zfCalc_UserAdmin());
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP', True, text_var1::TVarChar, vbUserId);
      END;    
    
      -- Заполнение суммы от продажи страховым компаниям в дополнительные расходы
      BEGIN
         PERFORM gpInsertUpdate_MovementItem_WagesAdditionalExpenses_IC (inOperDate := CURRENT_DATE - INTERVAL '1 DAY', inSession:=  zfCalc_UserAdmin());
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_MovementItem_WagesAdditionalExpenses_IC', True, text_var1::TVarChar, vbUserId);
      END;    

      -- Фиксация неликвидов
      BEGIN
         PERFORM gpInsertUpdate_Movement_IlliquidUnit_Formation(inOperDate := CURRENT_DATE, inSession:=  zfCalc_UserAdmin());
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_Movement_IlliquidUnit_Formation', True, text_var1::TVarChar, vbUserId);
      END;    
    END IF;    

    -- Списание товара с комментарием "Нетоварный вид"
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer = 21 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 21
         AND NOT EXISTS(SELECT 1 FROM Movement
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                           ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                          AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()    
                              LEFT JOIN MovementBoolean AS MovementBoolean_FinalFormation
                                                        ON MovementBoolean_FinalFormation.MovementId = Movement.Id
                                                       AND MovementBoolean_FinalFormation.DescId = zc_MovementBoolean_FinalFormation()
                        WHERE Movement.OperDate  = date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                          AND Movement.DescId = zc_Movement_Loss()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND COALESCE(MovementLinkObject_ArticleLoss.ObjectId, 0) = 13892113
                          AND COALESCE(MovementBoolean_FinalFormation.ValueData, False) = True)
      THEN
          PERFORM gpInsert_Movement_Loss_NonCommodity (inOperDate := CURRENT_DATE, inSession := zfCalc_UserAdmin());    
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsert_Movement_Loss_NonCommodity', True, text_var1::TVarChar, vbUserId);
    END;
    
    -- Автоматическое формирование FinalSUA
    BEGIN
      IF date_part('DOW', CURRENT_DATE)::Integer = 5 AND date_part('HOUR',  CURRENT_TIME)::Integer = 18 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 21
      THEN
          PERFORM gpInsert_Movement_FinalSUA_Auto (inSession := zfCalc_UserAdmin());    
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsert_Movement_FinalSUA_Auto', True, text_var1::TVarChar, vbUserId);
    END;
    
    -- Переоценка для сайта
    BEGIN
      IF date_part('isodow', CURRENT_DATE)::Integer in (2, 3, 4, 5) AND date_part('HOUR',  CURRENT_TIME)::Integer = 12 AND 
         date_part('MINUTE',  CURRENT_TIME)::Integer >= 25 AND date_part('MINUTE',  CURRENT_TIME)::Integer < 35 AND
         CURRENT_DATE >= '25.08.2021' 
      THEN
         PERFORM * FROM gpRun_Object_RepriceSheduler_RepriceSite (inSession);    
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpRun_Object_RepriceSheduler_RepriceSite', False, 'Пероценка для сайта выполнена', vbUserId);
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpRun_Object_RepriceSheduler_RepriceSite', True, text_var1::TVarChar, vbUserId);
    END;

    -- Сброс фиксированных скидок
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer = 2 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 15
      THEN
         PERFORM gpUpdate_Goods_SetinHideOnTheSite(inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_Goods_SetinHideOnTheSite', True, text_var1::TVarChar, vbUserId);
    END;

    -- Учтановка признака "Скрывать на сайте нет в наличии и в поставках" 
    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer = 4 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 25
      THEN
         PERFORM gpUpdate_Object_PriceChangeClear(inId := PriceChange.ID, inSession := inSession) 
         FROM gpSelect_Object_PriceChange(inRetailId := 4 , inUnitId := 0 , inGoodsId := 0 , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3') AS PriceChange
         WHERE PriceChange.FixEndDate < CURRENT_DATE
           AND (COALESCE(PriceChange.FixValue, 0) <> 0 OR COALESCE(PriceChange.FixPercent) <> 0 OR COALESCE(PriceChange.FixDiscount) <> 0);
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_Object_PriceChangeClear', True, text_var1::TVarChar, vbUserId);
    END;

    -- Переформирование ВИП чек для резерва под продажи
    IF date_part('DAY',  CURRENT_DATE)::Integer = 1 AND date_part('HOUR',  CURRENT_TIME)::Integer = 4 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 30
    THEN

      BEGIN
         PERFORM gpSelect_Movement_Check_AutoVIPforSales (inSession:=  zfCalc_UserAdmin());
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Movement_Check_AutoVIPforSales', True, text_var1::TVarChar, vbUserId);
      END;    

    END IF;    

    -- Простановка признака Нет хладагента
    BEGIN
      IF date_part('isodow', CURRENT_DATE)::Integer in (6) AND date_part('HOUR',  CURRENT_TIME)::Integer = 11 AND 
         date_part('MINUTE',  CURRENT_TIME)::Integer >= 15 AND date_part('MINUTE',  CURRENT_TIME)::Integer < 35
      THEN
         PERFORM gpUpdate_Goods_isColdSUN(inGoodsMainId := T1.GoodsMainId, inisColdSUN := False,  inSession := inSession) 
         FROM gpSelect_Goods_CommentNoRefrigerant(inStartDate := CURRENT_DATE - INTERVAL '7 DAY', inEndDate := CURRENT_DATE,  inSession := inSession) AS T1
         WHERE T1.isColdSUNCK = FALSE AND T1.isColdSUN = FALSE; 
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_Goods_isColdSUN', True, text_var1::TVarChar, vbUserId);
    END;

    -- Создание ЗП менеджеров по текущему месяцу
    IF date_part('DAY',  CURRENT_DATE)::Integer = 1 AND date_part('HOUR',  CURRENT_TIME)::Integer = 1 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 30
    THEN

      BEGIN
         IF NOT EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE) AND Movement.DescId = zc_Movement_WagesVIP())
         THEN
           PERFORM gpInsertUpdate_Movement_WagesVIP (ioId := 0
                                                   , inInvNumber := CAST (NEXTVAL ('Movement_WagesVIP_seq')  AS TVarChar)
                                                   , ioOperDate := date_trunc('month', CURRENT_DATE)
                                                   , inSession:=  zfCalc_UserAdmin());
         END IF;
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_Movement_WagesVIP', True, text_var1::TVarChar, vbUserId);
      END;    

    END IF;    

    -- Удаление вчарашних заказов по нашему сайту
    IF date_part('HOUR',  CURRENT_TIME)::Integer = 21 AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 30
    THEN

      BEGIN
         PERFORM gpRun_Movement_Check_Delay_Site (zfCalc_UserAdmin());
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpRun_Movement_Check_Delay_Site', True, text_var1::TVarChar, vbUserId);
      END;    

    END IF;    

    IF date_part('HOUR',  CURRENT_TIME)::Integer = 21 AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 30 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 50
    THEN

      -- Удаление нулевых чеков
      BEGIN
         PERFORM gpSetErased_Movement_Check (Movement.Id, inSession) FROM
         (WITH
          tmpMovementCheck AS (SELECT Movement.Id
                               FROM Movement
                               WHERE Movement.DescId = zc_Movement_Check()
                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                 AND Movement.OperDate >= CURRENT_DATE - INTERVAL '10 DAY')

          SELECT Movement.Id
          FROM tmpMovementCheck AS Movement

               LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId = Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
                     
               LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                      
               LEFT JOIN MovementBoolean AS MovementBoolean_AutoVIPforSales
                                         ON MovementBoolean_AutoVIPforSales.MovementId = Movement.Id
                                        AND MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales()


                                                       
          WHERE COALESCE (MovementFloat_TotalCount.ValueData, 0) = 0
            AND COALESCE (MovementFloat_TotalSumm.ValueData, 0) = 0
            AND COALESCE (MovementBoolean_AutoVIPforSales.ValueData, False) = False) AS Movement;
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSetErased_Movement_Check', True, text_var1::TVarChar, vbUserId);
      END;    

      -- Проставление смен 
      BEGIN
         PERFORM gpUpdate_MI_EmployeeScheduleVIP_SetPayrollTypeVIP(inMovementId := Movement.Id,  inSession := inSession)
         FROM Movement
         WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
           AND Movement.DescId = zc_Movement_EmployeeScheduleVIP()
           AND Movement.StatusId = zc_Enum_Status_UnComplete();
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_MI_EmployeeScheduleVIP_SetPayrollTypeVIP', True, text_var1::TVarChar, vbUserId);
      END;    
      
      -- Расчет ЗП випам 
      BEGIN
         PERFORM gpInsertUpdate_Movement_WagesVIP_CalculationAllDay(inMovementId := Movement.Id,  inSession := inSession)
         FROM Movement
         WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
           AND Movement.DescId = zc_Movement_WagesVIP()
           AND Movement.StatusId = zc_Enum_Status_UnComplete();
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_Movement_WagesVIP_CalculationAllDay', True, text_var1::TVarChar, vbUserId);
      END;          
      
      -- Премия за приложение
      BEGIN
         PERFORM gpSelect_Movement_Wages_ApplicationAward(inOperDate := CURRENT_DATE,  inSession := inSession);
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Movement_Wages_ApplicationAward', True, text_var1::TVarChar, vbUserId);
      END;    
      
    END IF;    

    IF date_part('DAY',  CURRENT_DATE)::Integer <= 3 AND date_part('HOUR',  CURRENT_TIME)::Integer = 18 AND 
       date_part('MINUTE',  CURRENT_TIME)::Integer >= 0 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
    THEN

      -- Расчет ЗП випам за предыдущий месяц
      BEGIN
         PERFORM gpInsertUpdate_Movement_WagesVIP_CalculationAllDay(inMovementId := Movement.Id,  inSession := inSession)
         FROM Movement
         WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE - INTERVAL '10 DAY')
           AND Movement.DescId = zc_Movement_WagesVIP()
           AND Movement.StatusId = zc_Enum_Status_UnComplete();
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_Movement_WagesVIP_CalculationAllDay', True, text_var1::TVarChar, vbUserId);
      END;         

      -- Премия за приложение за предыдущий месяц
      BEGIN
         PERFORM gpSelect_Movement_Wages_ApplicationAward(inOperDate := CURRENT_DATE - INTERVAL '10 DAY',  inSession := inSession);
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Movement_Wages_ApplicationAward', True, text_var1::TVarChar, vbUserId);
      END;    
    END IF;    

    IF date_part('DAY',  CURRENT_DATE)::Integer = 4 AND date_part('HOUR',  CURRENT_TIME)::Integer = 21 AND 
       date_part('MINUTE',  CURRENT_TIME)::Integer >= 0 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
    THEN

      -- Расчет ЗП випам за предыдущий месяц
      BEGIN
         PERFORM gpInsertUpdate_Movement_WagesVIP_CalculationAllDay(inMovementId := Movement.Id,  inSession := inSession)
         FROM Movement
         WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE - INTERVAL '10 DAY')
           AND Movement.DescId = zc_Movement_WagesVIP()
           AND Movement.StatusId = zc_Enum_Status_UnComplete();
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpInsertUpdate_Movement_WagesVIP_CalculationAllDay', True, text_var1::TVarChar, vbUserId);
      END;         

    END IF;    

    IF date_part('isodow', CURRENT_DATE)::Integer in (6) AND date_part('HOUR',  CURRENT_TIME)::Integer = 8 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 30
    THEN

      -- Отложка возвратов поставщику перед полной инвентаризацией
      BEGIN
         PERFORM gpUpdate_Movement_ReturnOut_Deferred(Movement.Id, TRUE, inSession)
         FROM Object AS Object_Unit

               INNER JOIN ObjectBoolean AS ObjectBoolean_AlertRecounting
                                      ON ObjectBoolean_AlertRecounting.ObjectId = Object_Unit.Id
                                     AND ObjectBoolean_AlertRecounting.DescId = zc_ObjectBoolean_Unit_AlertRecounting()
                                     AND ObjectBoolean_AlertRecounting.ValueData = TRUE
                                     
              INNER JOIN  Movement ON Movement.DescId = zc_Movement_ReturnOut()
                                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                 
              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()
                                           AND MovementLinkObject_Unit.ObjectId = Object_Unit.Id  
 
              LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                        ON MovementBoolean_Deferred.MovementId = Movement.Id
                                       AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                          
           WHERE Object_Unit.DescId = zc_Object_Unit()
             AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE;
      EXCEPTION
         WHEN others THEN
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpUpdate_Movement_ReturnOut_Deferred', True, text_var1::TVarChar, vbUserId);
      END;         

    END IF;    

    -- Изменение признака ушел с рвка
    BEGIN
      IF date_part('isodow', CURRENT_DATE)::Integer in (1, 2, 3, 4, 7) AND date_part('HOUR',  CURRENT_TIME)::Integer = 23 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 25 
      THEN
         PERFORM * FROM gpSelect_Update_LeftTheMarket (inSession);    
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Update_LeftTheMarket', True, text_var1::TVarChar, vbUserId);
    END;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.03.20                                                       * add gpInsertUpdate_Movement_TechnicalRediscount_Formation
 15.02.20                                                       *
*/

-- SELECT * FROM Log_Run_Schedule_Function order by Log_Run_Schedule_Function.DateInsert desc LIMIT 50
-- SELECT * FROM Log_Run_Schedule_Function where isError = True order by Log_Run_Schedule_Function.DateInsert desc LIMIT 50
-- SELECT * FROM gpFarmacy_Scheduler (inSession := zfCalc_UserAdmin())