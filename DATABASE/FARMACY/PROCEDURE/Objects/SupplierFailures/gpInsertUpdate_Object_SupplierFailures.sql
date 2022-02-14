-- Function: gpInsertUpdate_Object_SupplierFailures()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SupplierFailures(Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SupplierFailures(
 INOUT ioId             Integer   ,     -- ключ объекта <Id> 
    IN inName           TVarChar  ,     -- Название
    IN inGoodsId        Integer   ,     -- Товар
    IN inJuridicalId    Integer   ,     -- Юр. лицо
    IN inContractId     Integer   ,     -- Договор
    IN inAreaId         Integer   ,     -- Регион
    IN inUnitId         Integer   ,     -- Аптека
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   IF COALESCE (inGoodsId, 0) = 0 OR COALESCE (inJuridicalId, 0) = 0 OR COALESCE (inContractId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Коды товара, юр. лица и договора должны быть заполнены.';   
   END IF;
   
   IF NOT EXISTS(SELECT * 
                 FROM  MovementItemLinkObject AS MILinkObject_Goods

                       -- Прайс-лист (поставщика) - MovementItem
                       INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                                                            AND PriceList.isErased = False 
                       -- Прайс-лист (поставщика) - Movement
                       INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

                 WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                   AND MILinkObject_Goods.ObjectId = inGoodsId
                   AND LastPriceList_find_View.JuridicalId = inJuridicalId
                   AND LastPriceList_find_View.ContractId = inContractId
                   AND COALESCE(LastPriceList_find_View.AreaId, 0) = COALESCE(inAreaId, 0))
      AND COALESCE (inUnitId, 0) <> 0
   THEN 
   
     IF COALESCE (inUnitId, 0) <> 0 AND
        EXISTS(SELECT * 
               FROM  MovementItemLinkObject AS MILinkObject_Goods

                     -- Прайс-лист (поставщика) - MovementItem
                     INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                                                          AND PriceList.isErased = False 
                     -- Прайс-лист (поставщика) - Movement
                     INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId
                     
                     -- Регион аптеки
                     INNER JOIN ObjectLink AS ObjectLinkUnitArea ON ObjectLinkUnitArea.ObjectId = COALESCE (inUnitId, 0)
                                          AND ObjectLinkUnitArea.DescId = zc_ObjectLink_Unit_Area()

               WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                 AND MILinkObject_Goods.ObjectId = inGoodsId
                 AND LastPriceList_find_View.JuridicalId = inJuridicalId
                 AND LastPriceList_find_View.ContractId = inContractId
                 AND COALESCE(LastPriceList_find_View.AreaId, 0) = COALESCE(ObjectLinkUnitArea.ChildObjectId, 0))
     THEN
       SELECT COALESCE(LastPriceList_find_View.AreaId, 0)
       INTO inAreaId
       FROM  MovementItemLinkObject AS MILinkObject_Goods

             -- Прайс-лист (поставщика) - MovementItem
             INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                                                  AND PriceList.isErased = False 
             -- Прайс-лист (поставщика) - Movement
             INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId
                     
             -- Регион аптеки
             INNER JOIN ObjectLink AS ObjectLinkUnitArea ON ObjectLinkUnitArea.ObjectId = COALESCE (inUnitId, 0)
                                  AND ObjectLinkUnitArea.DescId = zc_ObjectLink_Unit_Area()

       WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
         AND MILinkObject_Goods.ObjectId = inGoodsId
         AND LastPriceList_find_View.JuridicalId = inJuridicalId
         AND LastPriceList_find_View.ContractId = inContractId
         AND COALESCE(LastPriceList_find_View.AreaId, 0) = COALESCE(ObjectLinkUnitArea.ChildObjectId, 0)    
       LIMIT 1;   
     ELSE
       SELECT COALESCE(ObjectLinkUnitArea.ChildObjectId, 0) 
       INTO inAreaId
       FROM ObjectLink AS ObjectLinkUnitArea 
       WHERE ObjectLinkUnitArea.ObjectId = COALESCE (inUnitId, 0)
         AND ObjectLinkUnitArea.DescId = zc_ObjectLink_Unit_Area();
      END IF;
   
   END IF;
   
   inName := COALESCE (inGoodsId, 0)::TVarChar||' '||COALESCE (inJuridicalId, 0)::TVarChar||' '||COALESCE (inContractId, 0)::TVarChar||' '||COALESCE (inAreaId, 0)::TVarChar;

   -- Ищем ицем может уже есть
   IF EXISTS (SELECT ValueData FROM Object WHERE Object.DescId = zc_Object_SupplierFailures() AND Object.ValueData = inName) 
   THEN
      SELECT ID INTO ioId 
      FROM Object WHERE Object.DescId = zc_Object_SupplierFailures() AND Object.ValueData = inName;
        
      IF EXISTS (SELECT ValueData FROM Object WHERE Object.DescId = zc_Object_SupplierFailures() AND Object.Id = ioId AND Object.isErased = TRUE)  
      THEN
        PERFORM gpUpdateObjectIsErased (ioId, inSession);
      END IF;
      RETURN;
   ELSE
     ioId := 0;
   END IF;    

   -- !!!ВРЕМЕННО для ТЕСТА!!!
   IF inSession = zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%> <%>', inName, inGoodsId, inJuridicalId, inContractId, inAreaId;
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_SupplierFailures());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_SupplierFailures(), vbCode_calc, inName);

   -- сохранили связь с <подразделение>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SupplierFailures_Goods(), ioId, inGoodsId);
   -- сохранили связь с <подразделение>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SupplierFailures_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <подразделение>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SupplierFailures_Contract(), ioId, inContractId);
   -- сохранили связь с <подразделение>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SupplierFailures_Area(), ioId, inAreaId);
      
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.02.22                                                       *
*/

-- select * from gpInsertUpdate_Object_SupplierFailures(ioId := 0 , inName := '' , inGoodsId := 7574919 , inJuridicalId := 59610 , inContractId := 183257 , inAreaId := 0 , inUnitId := 183289 ,  inSession := '3');

select * from gpInsertUpdate_Object_SupplierFailures(ioId := 0 , inName := '' , inGoodsId := 161059 , inJuridicalId := 59610 , inContractId := 183257 , inAreaId := 0 , inUnitId := 5120968 ,  inSession := '3');