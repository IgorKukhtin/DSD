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
        AND COALESCE (Object_Goods_Juridical.GoodsMainId, 0) = 0;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run UPDATE Object_Goods_Juridical', True, text_var1::TVarChar, vbUserId);
    END;
    
    -- Заполнение кошелька
    BEGIN
      IF date_part('DAY',  CURRENT_TIME)::Integer IN (1,2,5,10,25) AND date_part('HOUR',  CURRENT_TIME)::Integer = 6
      THEN
         PERFORM gpSelect_Calculation_MoneyBoxSun (inUnitID := 0, inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Calculation_MoneyBoxSun', True, text_var1::TVarChar, vbUserId);
    END;
    
    -- Заполнение фонда
/*    BEGIN
      IF date_part('HOUR',  CURRENT_TIME)::Integer = '6' AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 30
      THEN
         PERFORM gpSelect_Calculation_Retail_Fund (inSession := zfCalc_UserAdmin());
      END IF;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpFarmacy_Scheduler Run gpSelect_Calculation_Unit_Fund', True, text_var1::TVarChar, vbUserId);
    END;
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.03.20                                                       * add gpInsertUpdate_Movement_TechnicalRediscount_Formation
 15.02.20                                                       *
*/

-- SELECT * FROM Log_Run_Schedule_Function
-- SELECT * FROM gpFarmacy_Scheduler (inSession := zfCalc_UserAdmin())


