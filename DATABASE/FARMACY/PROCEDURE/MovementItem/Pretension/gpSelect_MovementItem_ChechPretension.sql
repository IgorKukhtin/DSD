-- Function: gpSelect_MovementItem_ChechPretension()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ChechPretension (Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ChechPretension(
    IN inGoodsCode              Integer   , -- ключ Документа
    IN inGoodsName              TVarChar  , --
    IN inReasonDifferencesName  TVarChar  , --
    IN inAmount                 TFloat    , --
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    
    IF COALESCE (inReasonDifferencesName, '') <> '' AND COALESCE (inAmount, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Для товара <%>  <%> с причиной разногласия <%> не заполнено "Кол-во по претензии"', inGoodsCode, inGoodsName, inReasonDifferencesName;
    END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.12.21                                                       *
 
*/

-- тест

select * from gpSelect_MovementItem_ChechPretension(inGoodsCode := 30451 , inGoodsName := 'Батончик Гранола 30г (Агросельпром)' , inReasonDifferencesName := 'Излишек' , inAmount := 5 ,  inSession := '3');