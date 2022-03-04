-- Function: gpInsertUpdate_MI_PriceList_SupplierFailures_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PriceList_SupplierFailures_Load(Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PriceList_SupplierFailures_Load(
    IN inMovementId     Integer   ,     -- Документ
    IN inGoodsCode      TVarChar  ,     -- Код товара
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbGoodsId     Integer;
   DECLARE vbUnitId      Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbContractId  Integer;
   DECLARE vbAreaId      Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   SELECT MovementLinkObject_To.ObjectId
        , MovementLinkObject_From.ObjectId
        , MovementLinkObject_Contract.ObjectId
        , COALESCE(ObjectLinkUnitArea.ChildObjectId, 0)
   INTO vbUnitId, vbJuridicalId, vbContractId, vbAreaId
   FROM Movement
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN ObjectLink AS ObjectLinkUnitArea 
                             ON ObjectLinkUnitArea.ObjectId = MovementLinkObject_To.ObjectId
                            AND ObjectLinkUnitArea.DescId = zc_ObjectLink_Unit_Area()
   WHERE Movement.Id =inMovementId;
    
   SELECT Object_Goods_Juridical.Id
   INTO vbGoodsId
   FROM Object_Goods_Juridical 
   WHERE Object_Goods_Juridical.JuridicalId = vbJuridicalId
     AND Object_Goods_Juridical.Code = inGoodsCode; 
   
   IF COALESCE (vbGoodsId, 0) = 0 OR COALESCE (vbJuridicalId, 0) = 0 OR COALESCE (vbContractId, 0) = 0
   THEN
     RAISE NOTICE 'Ошибка. Коды товара, юр. лица и договора должны быть заполнены.';   
     RETURN;
   END IF;
   
   IF NOT EXISTS(SELECT * 
                 FROM  MovementItemLinkObject AS MILinkObject_Goods

                       -- Прайс-лист (поставщика) - MovementItem
                       INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                       
                       -- Прайс-лист (поставщика) - Movement
                       INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

                 WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                   AND MILinkObject_Goods.ObjectId = vbGoodsId
                   AND LastPriceList_find_View.JuridicalId = vbJuridicalId
                   AND LastPriceList_find_View.ContractId = vbContractId)
   THEN 
     RAISE NOTICE 'Ошибка. В прайсах поставщика товар не найден.';      
     RETURN;
   END IF;

   IF EXISTS(SELECT * 
             FROM  MovementItemLinkObject AS MILinkObject_Goods

                   -- Прайс-лист (поставщика) - MovementItem
                   INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                   
                   -- Прайс-лист (поставщика) - Movement
                   INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

             WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
               AND MILinkObject_Goods.ObjectId = vbGoodsId
               AND LastPriceList_find_View.JuridicalId = vbJuridicalId
               AND LastPriceList_find_View.ContractId = vbContractId
               AND COALESCE(LastPriceList_find_View.AreaId, 0) <> 0)
   THEN 
   
      IF COALESCE (vbUnitId, 0) = 0
      THEN
        RAISE NOTICE 'Ошибка. Не заполнено подразделение для определения региона.';   
        RETURN;
      END IF;
   
      IF EXISTS(SELECT * 
                FROM  MovementItemLinkObject AS MILinkObject_Goods
 
                      -- Прайс-лист (поставщика) - MovementItem
                      INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                      
                      -- Прайс-лист (поставщика) - Movement
                      INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId
                       
                WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                  AND MILinkObject_Goods.ObjectId = vbGoodsId
                  AND LastPriceList_find_View.JuridicalId = vbJuridicalId
                  AND LastPriceList_find_View.ContractId = vbContractId
                  AND COALESCE(LastPriceList_find_View.AreaId, 0) IN 
                                     (SELECT DISTINCT tmp.AreaId_Juridical         AS AreaId
                                      FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId , 0) AS tmp
                                      WHERE tmp.JuridicalId = vbJuridicalId
                                      ))
      THEN
         SELECT PriceList.MovementId
         INTO vbPriceListId 
         FROM  MovementItemLinkObject AS MILinkObject_Goods

               -- Прайс-лист (поставщика) - MovementItem
               INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
               
               -- Прайс-лист (поставщика) - Movement
               INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId
                         
         WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
           AND MILinkObject_Goods.ObjectId = vbGoodsId
           AND LastPriceList_find_View.JuridicalId = vbJuridicalId
           AND LastPriceList_find_View.ContractId = vbContractId
           AND COALESCE(LastPriceList_find_View.AreaId, 0) IN 
                                     (SELECT DISTINCT tmp.AreaId_Juridical         AS AreaId
                                      FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId , 0) AS tmp
                                      WHERE tmp.JuridicalId = vbJuridicalId
                                      )    
         LIMIT 1;   
      ELSE
         RAISE NOTICE 'Ошибка. Не найден товар в прайсе по региону аптеки.';   
         RETURN;
      END IF;
   ELSE
   
     SELECT PriceList.MovementId
     INTO vbPriceListId 
     FROM  MovementItemLinkObject AS MILinkObject_Goods

           -- Прайс-лист (поставщика) - MovementItem
           INNER JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
           
           -- Прайс-лист (поставщика) - Movement
           INNER JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

     WHERE MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
       AND MILinkObject_Goods.ObjectId = vbGoodsId
       AND LastPriceList_find_View.JuridicalId = vbJuridicalId
       AND LastPriceList_find_View.ContractId = vbContractId
     LIMIT 1;
   
   END IF;
   
      
   IF NOT EXISTS(SELECT 1 
                 FROM MovementItem
                 
                      INNER JOIN MovementItemBoolean ON MovementItemBoolean.MovementItemId = MovementItem.Id
                                                     AND MovementItemBoolean.DescId = zc_MIBoolean_SupplierFailures()
                                                     AND MovementItemBoolean.ValueData = TRUE
                   
                 WHERE MovementItem.MovementId = vbPriceListId
                   AND MovementItem.DescId = zc_MI_Child()
                   AND MovementItem.ObjectId = vbGoodsId)
   THEN

     PERFORM lpInsertUpdate_MovementItem_PriceList_Child(ioId           := 0
                                                       , inMovementId   := vbPriceListId
                                                       , inGoodsId      := vbGoodsId
                                                       , inUserId       := vbUserId);

     -- !!!ВРЕМЕННО для ТЕСТА!!!
     IF inSession = zfCalc_UserAdmin()
     THEN
       RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%>', vbGoodsId, vbJuridicalId, vbContractId, vbPriceListId;
     END IF;

   ELSE
     RAISE NOTICE 'Ошибка. Отказ уже установлен.';      
     RETURN;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.22                                                       *
*/

-- select * from gpInsertUpdate_MI_PriceList_SupplierFailures_Load(inMovementId := 27069713 , inGoodsCode := '413.0407' ,  inSession := '3');