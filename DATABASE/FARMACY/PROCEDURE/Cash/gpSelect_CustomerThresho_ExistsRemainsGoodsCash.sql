 -- Function: gpSelect_CustomerThresho_ExistsRemainsGoodsCash()

DROP FUNCTION IF EXISTS gpSelect_CustomerThresho_ExistsRemainsGoodsCash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CustomerThresho_ExistsRemainsGoodsCash(
    IN inGoodsId     Integer,       -- Товар
   OUT outThereIs    Boolean,       -- Есть что распределить
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
        
    IF EXISTS(SELECT * FROM ObjectBoolean AS ObjectBoolean_PauseDistribListDiff
              WHERE ObjectBoolean_PauseDistribListDiff.ObjectId = vbUnitId
                AND ObjectBoolean_PauseDistribListDiff.DescId = zc_ObjectBoolean_Unit_PauseDistribListDiff()
                AND ObjectBoolean_PauseDistribListDiff.ValueData = True)
    THEN
      outThereIs := False;
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PauseDistribListDiff(), vbUnitId, False);
    ELSE
      outThereIs := Exists(SELECT * FROM gpSelect_CustomerThresho_RemainsGoodsCash(inGoodsId := inGoodsId, inSession:= inSession));
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 28.07.21                                                      *
*/

--ТЕСТ
-- 

SELECT * FROM gpSelect_CustomerThresho_ExistsRemainsGoodsCash (inGoodsId := 13303, inSession:= '3')

