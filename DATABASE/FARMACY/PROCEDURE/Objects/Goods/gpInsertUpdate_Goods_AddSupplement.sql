-- Function: gpInsertUpdate_Goods_AddSupplement()

DROP FUNCTION IF EXISTS gpInsertUpdate_Goods_AddSupplement(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Goods_AddSupplement(
    IN inGoodsId             Integer   ,   -- ключ объекта <Товар>
    IN inSession             TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbGoodsMainId   Integer;
   DECLARE vbUnitId Integer;

   DECLARE vbUnit1Id Integer;
   DECLARE vbUnit2Id Integer;

   DECLARE vbUnitKey TVarChar;
   DECLARE vbDay Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
   
   vbUnit1Id := Null;
   vbUnit2Id := Null;
   vbGoodsMainId := (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inGoodsId);

   SELECT Object_Goods_Main.UnitSupplementSUN1OutId, Object_Goods_Main.UnitSupplementSUN2OutId
   INTO vbUnit1Id, vbUnit2Id
   FROM Object_Goods_Main  
   WHERE Object_Goods_Main.Id = vbGoodsMainId;
         
   IF EXISTS(SELECT 1
             FROM ObjectBoolean AS ObjectBoolean_SUN_v1_SupplementAdd30Cash
             WHERE ObjectBoolean_SUN_v1_SupplementAdd30Cash.ObjectId = vbUnitId
               AND ObjectBoolean_SUN_v1_SupplementAdd30Cash.DescId = zc_ObjectBoolean_Unit_SUN_SupplementAdd30Cash()
               AND ObjectBoolean_SUN_v1_SupplementAdd30Cash.ValueData = True)
   THEN
     vbDay := 30;
   ELSE 
     vbDay := 90;
   END IF;
   
   IF COALESCE (vbUnitId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка определения аптеки сотрудника.';          
   END IF;

   IF COALESCE (vbUnit1Id, 0) = vbUnitId OR COALESCE (vbUnit2Id, 0) = vbUnitId
   THEN
     IF EXISTS(SELECT Object_Goods_Main.Id
               FROM Object_Goods_Main  
               WHERE Object_Goods_Main.Id = vbGoodsMainId
                 AND COALESCE (Object_Goods_Main.isSupplementSUN1, False) = False)
        THEN     
          -- сохранили свойство <Дополнение СУН1>
          PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN1(), vbGoodsMainId, True);
          
          -- сохранили протокол
          PERFORM lpInsert_ObjectProtocol (vbGoodsMainId, vbUserId);
        END IF;
     RETURN;          
   END IF;
   
    -- Проверяем остаток и срок
   IF NOT EXISTS( SELECT Container.ObjectId
                  FROM Container

                       LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                          ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                       LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId

                       -- элемент прихода
                       LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                       -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                       LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                   ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                  AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                       -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                       LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                       LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                        AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                                        
                       LEFT JOIN Container AS ContainerPD
                                           ON ContainerPD.ParentId = Container.Id
                                          AND ContainerPD.DescId = zc_Container_CountPartionDate()  
                                          AND ContainerPD.Amount <> 0 

                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = ContainerPD.Id
                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                       LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                            ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                           AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()


                   WHERE Container.DescId = zc_Container_Count()
                     AND Container.Amount > 0 
                     AND Container.ObjectId = inGoodsId
                     AND Container.WhereObjectId = vbUnitId
                     AND COALESCE (ObjectDate_ExpirationDate.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd()) > CURRENT_DATE + (vbDay::TVarChar||' DAY')::INTERVAL
                   GROUP BY Container.ObjectId 
                   HAVING SUM(COALESCE(ContainerPD.Amount, Container.Amount)) >= 1)
   THEN
     RAISE EXCEPTION 'Для добавления товара необходим остаток как минимум 1 уп. сроком более % дней.', vbDay;          
   END IF;
      
   IF COALESCE (vbUnit1Id, 0) = 0
   THEN
     vbUnit1Id := vbUnitId;
   ELSE
     vbUnit2Id := vbUnitId;
   END IF;

   -- сохранили свойство <Дополнение СУН1>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN1(), vbGoodsMainId, True);
   -- сохранили свойство <Дополнение СУН1>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN1Out(), vbGoodsMainId, vbUnit1Id);
   -- сохранили свойство <Дополнение СУН1>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN2Out(), vbGoodsMainId, vbUnit2Id);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isSupplementSUN1 = True
                                , UnitSupplementSUN1OutId = vbUnit1Id
                                , UnitSupplementSUN2OutId = vbUnit2Id
     WHERE Object_Goods_Main.Id = vbGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inSupplementSUN1', text_var1::TVarChar, vbUserId);
   END;

   PERFORM gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out(inGoodsMainId               := vbGoodsMainId
                                                        , inUnitSupplementSUN1OutId   := vbUnitId
                                                        , inSession                   := inSession);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbGoodsMainId, vbUserId);

   -- !!!ВРЕМЕННО для ТЕСТА!!!
   IF inSession = zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%>', inGoodsId, vbGoodsMainId, vbUnitId, inSession;
   END IF;
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.20                                                       *  

*/

-- тест
--
-- select * from gpInsertUpdate_Goods_AddSupplement(inGoodsId := 4429  ,  inSession := '3');