-- Function: gpSelect_MovementItem_ChechPretension()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ChechPretension (Integer, TVarChar, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ChechPretension(
    IN inGoodsCode              Integer   , -- ключ Документа
    IN inGoodsName              TVarChar  , --
    IN inReasonDifferencesId    Integer   , --
    IN inReasonDifferencesName  TVarChar  , --
    IN inAmount                 TFloat    , --
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbisDeficit Boolean;
  DECLARE vbisSubstandard Boolean;
  DECLARE vbIsErased Boolean;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    
    IF COALESCE(inReasonDifferencesId, 0) <> 0
    THEN
    
      SELECT 
            COALESCE (PriceSite_Deficit.ValueData, FALSE)
          , COALESCE (PriceSite_Substandard.ValueData, FALSE)
          , Object_ReasonDifferences.IsErased
      INTO vbisDeficit, vbisSubstandard, vbIsErased    
      FROM 
           Object AS Object_ReasonDifferences

           LEFT JOIN ObjectBoolean AS PriceSite_Deficit
                                   ON PriceSite_Deficit.ObjectId = Object_ReasonDifferences.Id
                                  AND PriceSite_Deficit.DescId = zc_ObjectBoolean_ReasonDifferences_Deficit()
                                       
           LEFT JOIN ObjectBoolean AS PriceSite_Substandard
                                   ON PriceSite_Substandard.ObjectId = Object_ReasonDifferences.Id
                                  AND PriceSite_Substandard.DescId = zc_ObjectBoolean_ReasonDifferences_Substandard()
                                  
      WHERE Object_ReasonDifferences.Id = inReasonDifferencesId;  
      
      IF vbIsErased <> FALSE  
      THEN
        RAISE EXCEPTION 'Ошибка. Причина разногласия <%> запрещена к применению.', inReasonDifferencesName;
      END IF;
      
      IF COALESCE (inAmount, 0) > 0 AND vbisDeficit = TRUE
      THEN
        RAISE EXCEPTION 'Ошибка. С причиной разногласия <%> "Кол-во по претензии" должно быть отрицательным.', inReasonDifferencesName;
      END IF;

      IF COALESCE (inAmount, 0) < 0 AND vbisDeficit = FALSE
      THEN
        RAISE EXCEPTION 'Ошибка. С причиной разногласия <%> "Кол-во по претензии" должно быть положительным.', inReasonDifferencesName;
      END IF;

      IF COALESCE (inAmount, 0) = 0
      THEN
        RAISE EXCEPTION 'Ошибка. Для товара <%>  <%> с причиной разногласия <%> не заполнено "Кол-во по претензии".', inGoodsCode, inGoodsName, inReasonDifferencesName;
      END IF;

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

-- select * from gpSelect_MovementItem_ChechPretension(inGoodsCode := 30451 , inGoodsName := 'Батончик Гранола 30г (Агросельпром)' , inReasonDifferencesName := 'Излишек' , inAmount := 5 ,  inSession := '3');
