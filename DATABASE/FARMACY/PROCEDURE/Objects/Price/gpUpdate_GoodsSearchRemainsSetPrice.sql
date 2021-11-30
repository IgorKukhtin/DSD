-- Function: gpUpdate_GoodsSearchRemainsSetPrice()

DROP FUNCTION IF EXISTS gpUpdate_GoodsSearchRemainsSetPrice (integer, integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_GoodsSearchRemainsSetPrice(
    IN inID             integer,     -- товар
    IN inUnitID         integer,     -- Подразделение
    IN inPriceOut       TFloat,      -- Цена
    IN inSession        TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRemainsDate TDateTime;
   DECLARE vbPrice TFloat;
   DECLARE vbPriceMin TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- Для менеджеров
    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                  WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
    THEN
      RAISE EXCEPTION 'Ошибка. Выполнять переоценку вам запрещено.';
    END IF;

    IF COALESCE (inID, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Не выбран товар';
    END IF;

    IF COALESCE (inPriceOut, 0) <= 0
    THEN
        RAISE EXCEPTION 'Ошибка. Цена должна быть больше нуля';
    END IF;
    
/*    SELECT Price_Value.ValueData
    INTO vbPrice
    FROM ObjectLink AS ObjectLink_Price_Unit
         LEFT JOIN ObjectLink AS Price_Goods
                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
         LEFT JOIN ObjectFloat AS Price_Value
                               ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
    WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
      AND ObjectLink_Price_Unit.ChildObjectId = inUnitId    
      AND Price_Goods.ChildObjectId = inID;

    if inPriceOut < COALESCE(vbPrice,0)
    THEN
      SELECT tmp.PriceSaleMin
      INTO vbPriceMin
      FROM gpGet_GoodsPriceLastIncome(inUnitId := inUnitId , inGoodsId := inID ,  inSession := inSession) as tmp;
          
      IF COALESCE (vbPriceMin, 0) = 0
      THEN
        RAISE EXCEPTION 'Ошибка. Не найдена цена последнего прихода.';          
      END IF;

      IF inPriceOut < COALESCE (vbPriceMin, 0)
      THEN
        RAISE EXCEPTION '%', 'ВНИМАНИЕ!!!!!!'||Chr(13)||Chr(13)||
                             'Если вас просит точка удешевить препарат, то разрешено делать'||Chr(13)||
                             'для позиций из списка Маркетинговый контракт - 3%  от последней приходной цены на эту точку'||Chr(13)||
                             'для позиций , которых нет в списках по маркетинговым контрактам  - 4,5% от последней приходной цены на эту точку'||Chr(13)||Chr(13)||
                             'НЕ МЕНЕЕ '||zfConvert_FloatToString(vbPriceMin)||' грн. !!!!!!!!!!!!';          
      END IF;
    END IF;*/

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%>', inSession, inPriceOut, vbPrice, vbPriceMin;
    END IF;
    
    PERFORM lpInsertUpdate_Object_Price(inGoodsId := inId,
                                        inUnitId  := inUnitID,
                                        inPrice   := ROUND (inPriceOut, 2),
                                        inDate    := CURRENT_DATE::TDateTime,
                                        inUserId  := vbUserId);
    


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 31.07.19                                                       *
*/

-- тест
-- select * from gpUpdate_GoodsSearchRemainsSetPrice(inCodeSearch := '33460' , inGoodsSearch := '' , inID := 11649081 , inPriceOut := 111.33 ,  inSession := '3');