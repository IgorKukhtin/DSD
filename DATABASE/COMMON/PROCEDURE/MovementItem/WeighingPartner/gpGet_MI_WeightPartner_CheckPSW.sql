-- Function: gpGet_MI_WeightPartner_CheckPSW()

DROP FUNCTION IF EXISTS gpGet_MI_WeightPartner_CheckingPSW (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_WeightPartner_CheckPSW (Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_WeightPartner_CheckPSW(
    IN inId            Integer ,      --Ид строки
    IN inCountTare1    TFloat  ,
    IN inCountTare2    TFloat  ,
    IN inPassword      TVarChar,       -- проверка
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (isEdit Boolean, CountTare1 TFloat, CountTare2 TFloat
             , outMessageText Text) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);
    
    IF COALESCE (inPassword,'') <> '1234'
    THEN
        
        RETURN QUERY 
          SELECT FALSE AS isEdit
               , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.DescId = zc_MIFloat_CountTare1() AND MIF.MovementItemId = inId) ::TFloat AS CountTare1
               , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.DescId = zc_MIFloat_CountTare2() AND MIF.MovementItemId = inId) ::TFloat AS CountTare2
               , 'Ошибка.Введен не правильный Пароль.' ::Text AS outMessageText
          ;                                                     
    ELSE

      RETURN QUERY 
        SELECT TRUE AS isEdit
              , inCountTare1 ::TFloat AS CountTare1
              , inCountTare2 ::TFloat AS CountTare2
              , '' ::Text AS outMessageText
        ;                                                     
    END IF;

END;
$BODY$111

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.03.25         *
*/

-- тест
-- SELECT * FROM gpGet_MI_WeightPartner_CheckPSW(0,1,0,'1234', '183242')
