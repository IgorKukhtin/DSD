-- Function: gpUpdate_GoodsSearchRemainsSetPrice()

DROP FUNCTION IF EXISTS gpUpdate_GoodsSitePrice_SetPriceSite (integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_GoodsSitePrice_SetPriceSite(
    IN inID             integer,     -- товар
    IN inPriceSite      TFloat,      -- Цена
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
                  WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
    THEN
      RAISE EXCEPTION 'Ошибка. Выполнять переоценку вам запрещено.';
    END IF;

    IF COALESCE (inID, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Не выбран товар';
    END IF;

    IF COALESCE (inPriceSite, 0) <= 0
    THEN
        RAISE EXCEPTION 'Ошибка. Цена должна быть больше нуля';
    END IF;
    
    IF NOT EXISTS(SELECT * FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId AND Object_Goods_Retail.RetailId = 4)
    THEN
        RAISE EXCEPTION 'Ошибка. Переоценивать можно только ьовар сети "Не болей"';
    END IF;

    IF EXISTS(SELECT tmp.GoodsId
              FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
              WHERE tmp.GoodsId = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId AND Object_Goods_Retail.RetailId = 4))
    THEN
        RAISE EXCEPTION 'Ошибка. Переоценивать товар соц проекта нельзя.';
    END IF;

    PERFORM lpInsertUpdate_Object_PriceSite(inGoodsId := inId,
                                            inPrice   := ROUND (inPriceSite, 2),
                                            inDate    := CURRENT_DATE::TDateTime,
                                            inUserId  := vbUserId);
    


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.06.21                                                       *
*/

-- тест
-- select * from gpUpdate_GoodsSitePrice_SetPriceSite(inCodeSearch := '33460' , inGoodsSearch := '' , inID := 11649081 , inPriceOut := 111.33 ,  inSession := '3');