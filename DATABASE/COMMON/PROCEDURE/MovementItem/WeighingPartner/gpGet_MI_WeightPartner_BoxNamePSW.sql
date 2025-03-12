-- Function: gpGet_MI_WeightPartner_BoxNamePSW()

DROP FUNCTION IF EXISTS gpGet_MI_WeightPartner_BoxNamePSW (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_WeightPartner_BoxNamePSW(
    IN inId            Integer ,      --Ид строки
    IN inCountTare1    TFloat,
    IN inCountTare2    TFloat,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (BoxName TVarChar, Password TVarChar) AS
$BODY$
   DECLARE vbUserId Integer;
           vbCountTare1_old TFloat;
           vbCountTare2_old TFloat;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);
   
    vbCountTare1_old := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.DescId = zc_MIFloat_CountTare1() AND MIF.MovementItemId = inId) ::TFloat;
    vbCountTare2_old := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.DescId = zc_MIFloat_CountTare2() AND MIF.MovementItemId = inId) ::TFloat;
                                                                                                                                                                 
    
    IF COALESCE (inCountTare1,0) <> COALESCE (vbCountTare1_old,0)
    THEN
        RETURN QUERY 
          SELECT Object.ValueData ::TVarChar
               , NULL ::TVarChar AS Password
          FROM ObjectFloat AS ObjectFloat_NPP     
               INNER JOIN Object ON Object.Id = ObjectFloat_NPP.ObjectId
                                AND Object.DescId = zc_Object_Box()
          WHERE ObjectFloat_NPP.DescId = zc_ObjectFloat_Box_NPP()
            AND ObjectFloat_NPP.ValueData = 1
           ;
    ELSEIF COALESCE (inCountTare2,0) <> COALESCE (vbCountTare2_old,0)
    THEN
        RETURN QUERY 
          SELECT Object.ValueData ::TVarChar
               , NULL ::TVarChar AS Password
          FROM ObjectFloat AS ObjectFloat_NPP     
               INNER JOIN Object ON Object.Id = ObjectFloat_NPP.ObjectId
                                AND Object.DescId = zc_Object_Box()
          WHERE ObjectFloat_NPP.DescId = zc_ObjectFloat_Box_NPP()
            AND ObjectFloat_NPP.ValueData = 2
          ;
    ELSE
       RETURN QUERY 
          SELECT NULL ::TVarChar AS BoxName
               , NULL ::TVarChar AS Password
          ;
    END IF;

    
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.03.25         *
*/

-- тест
-- SELECT * FROM gpGet_MI_WeightPartner_BoxNamePSW(0,1,0, '183242')
