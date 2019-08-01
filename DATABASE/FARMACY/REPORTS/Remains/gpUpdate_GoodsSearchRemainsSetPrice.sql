-- Function: gpUpdate_GoodsSearchRemainsSetPrice()

DROP FUNCTION IF EXISTS gpUpdate_GoodsSearchRemainsSetPrice (TVarChar, TVarChar, integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_GoodsSearchRemainsSetPrice(
    IN inCodeSearch     TVarChar,    -- поиск товаров по коду
    IN inGoodsSearch    TVarChar,    -- поиск товаров
    IN inID             integer,     -- товар
    IN inPriceOut       TFloat,      -- Цена
    IN inSession        TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRemainsDate TDateTime;
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

    PERFORM lpInsertUpdate_Object_Price(inGoodsId := T1.Id,
                                        inUnitId  := T1.UnitID,
                                        inPrice   := ROUND (inPriceOut, 2),
                                        inDate    := CURRENT_DATE::TDateTime,
                                        inUserId  := vbUserId)
    FROM gpSelect_GoodsSearchRemains(inCodeSearch := inCodeSearch, inGoodsSearch := inGoodsSearch,  inSession := inSession) AS T1
    WHERE T1.ID = inID 
      AND PriceSale <> ROUND (inPriceOut, 2) 
    GROUP BY id, UnitID;
    
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
