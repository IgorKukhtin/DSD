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
   DECLARE vbOperDate    TDateTime;
   DECLARE vbGoodsId     Integer;
   DECLARE vbUnitId      Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbContractId  Integer;
   DECLARE vbAreaId      Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   SELECT Movement.OperDate
        , MovementLinkObject_To.ObjectId
        , MovementLinkObject_From.ObjectId
        , MovementLinkObject_Contract.ObjectId
        , COALESCE(ObjectLinkUnitArea.ChildObjectId, 0)
   INTO vbOperDate, vbUnitId, vbJuridicalId, vbContractId, vbAreaId
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

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPriceList'))
    THEN
      DROP TABLE _tmpPriceList;
    END IF;
    
   CREATE TEMP TABLE _tmpPriceList ON COMMIT DROP AS
   SELECT * FROM gpSelect_PriceList_GoodsDate (inOperDate   := vbOperDate
                                            ,  inGoodsId    := vbGoodsId
                                            , inUnitId      := vbUnitId
                                            , inJuridicalId := vbJuridicalId
                                            , inContractId  := vbContractId
                                            , inSession     := inSession);
   
   IF NOT EXISTS(SELECT * FROM _tmpPriceList)
   THEN 
     RAISE NOTICE 'Ошибка. Не найден товар в прайсе по регионам аптеки.';   
     RETURN;
   END IF;

   SELECT _tmpPriceList.Id
   INTO vbPriceListId 
   FROM _tmpPriceList
   LIMIT 1;   
      
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
       RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%> <%>', vbGoodsId, vbUnitId, vbJuridicalId, vbContractId, vbPriceListId;
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

-- 
select * from gpInsertUpdate_MI_PriceList_SupplierFailures_Load(inMovementId := 27069713 , inGoodsCode := '413.0407' ,  inSession := '3');