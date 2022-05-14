-- Function: gpInsertUpdate_Goods_AddSupplement()

DROP FUNCTION IF EXISTS gpInsertUpdate_Goods_AddSupplement(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Goods_AddSupplement(
    IN inGoodsId             Integer   ,   -- ключ объекта <Товар>
    IN inSession             TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbDay Integer;
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
   
   vbDay := 90;
   
   IF COALESCE (vbUnitId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка определения аптеки сотрудника.';          
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

   IF EXISTS(SELECT 1
             FROM Object_Goods_Retail
                  INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                              AND Object_Goods_Main.isSupplementSUN1 = TRUE
             WHERE Object_Goods_Retail.Id = inGoodsId ) AND 
      NOT EXISTS(SELECT
                 FROM Object_Goods_Retail
                      INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                                  AND (COALESCE(Object_Goods_Main.UnitSupplementSUN1OutId, 0) = vbUnitId
                                                    OR COALESCE(Object_Goods_Main.UnitSupplementSUN2OutId, 0) = vbUnitId)
                 WHERE Object_Goods_Retail.Id = inGoodsId)
   THEN

     IF EXISTS(SELECT
               FROM Object_Goods_Retail
                    INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                                AND COALESCE(Object_Goods_Main.UnitSupplementSUN1OutId, 0) <> 0
               WHERE Object_Goods_Retail.Id = inGoodsId)
     THEN
     
       IF EXISTS(SELECT
                 FROM Object_Goods_Retail
                      INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                                  AND COALESCE(Object_Goods_Main.UnitSupplementSUN2OutId, 0) <> 0
                 WHERE Object_Goods_Retail.Id = inGoodsId)
       THEN

         -- сохранили свойство <Дополнение СУН1> и <Прописали аптеку>
         PERFORM gpUpdate_Goods_UnitSupplementSUN1Out(inGoodsMainId := Object_Goods_Retail.GoodsMainId, inUnitSupplementSUN1OutiD := Null::Integer ,  inSession := inSession)
               , gpUpdate_Goods_UnitSupplementSUN2Out(inGoodsMainId := Object_Goods_Retail.GoodsMainId, inUnitSupplementSUN2OutiD := Null::Integer ,  inSession := inSession) 
         FROM Object_Goods_Retail
         WHERE Object_Goods_Retail.Id = inGoodsId;
       
       ELSE  
       
         -- сохранили свойство <Прописали аптеку 2>
         PERFORM gpUpdate_Goods_UnitSupplementSUN2Out(inGoodsMainId := Object_Goods_Retail.GoodsMainId, inUnitSupplementSUN2OutiD := vbUnitId ,  inSession := inSession)
         FROM Object_Goods_Retail
         WHERE Object_Goods_Retail.Id = inGoodsId;
         
       END IF;

     END IF;
   END IF;

   IF NOT EXISTS(SELECT 1
                 FROM Object_Goods_Retail
                      INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                  AND Object_Goods_Main.isSupplementSUN1 = TRUE
                 WHERE Object_Goods_Retail.Id = inGoodsId )
   THEN
   
     -- сохранили свойство <Дополнение СУН1> и <Прописали аптеку>
     PERFORM gpUpdate_Goods_inSupplementSUN1(inGoodsMainId := Object_Goods_Retail.GoodsMainId, inisSupplementSUN1 := True,  inSession := inSession)
           , gpUpdate_Goods_UnitSupplementSUN1Out(inGoodsMainId := Object_Goods_Retail.GoodsMainId, inUnitSupplementSUN1OutiD := vbUnitId ,  inSession := inSession)
     FROM Object_Goods_Retail
     WHERE Object_Goods_Retail.Id = inGoodsId;
   END IF;

   -- !!!ВРЕМЕННО для ТЕСТА!!!
   IF inSession = zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%>', inGoodsId, vbUnitId, inSession;
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
-- select * from gpInsertUpdate_Goods_AddSupplement(inGoodsId := 1231 ,  inSession := '3');