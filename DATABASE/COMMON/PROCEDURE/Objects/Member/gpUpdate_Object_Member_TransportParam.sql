-- Function: gpUpdate_Object_Member_TransportParam()

DROP FUNCTION IF EXISTS gpUpdate_Object_Member_TransportParam  ( Integer, TDateTime, TDateTime, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Member_TransportParam  ( Integer, Boolean, TDateTime, TDateTime, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_TransportParam(
    IN inId                  Integer   ,    -- Ключ объекта
    IN inisDate              Boolean   ,    -- изменять дату или нормы
    IN inStartSummerDate     TDateTime ,    -- начальная дата для нормы авто лето
    IN inEndSummerDate       TDateTime ,    -- конечная дата для нормы авто лето
    IN inSummerFuel          Tfloat    ,    -- норма авто литры лето
    IN inWinterFuel          Tfloat    ,    -- норма авто литры зима
    IN inReparation          Tfloat    ,    -- амортизация за 1 км., грн.
    IN inLimit               Tfloat    ,    -- лимит грн
    IN inLimitDistance       Tfloat    ,    -- лимит км
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Member_Transport());

     
     -- сохранили свойство <>

     IF inisDate = True and inId <> 0
     THEN
         PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_StartSummer(), inId, inStartSummerDate);
         PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_EndSummer(), inId, inEndSummerDate); 
     END IF;

     
    IF inisDate = False and inId <> 0
    THEN 
	PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Summer(), inId, inSummerFuel);
	PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Winter(), inId, inWinterFuel);
        PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Reparation(), inId, inReparation);
        PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Limit(), inId, inLimit);
        PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_LimitDistance(), inId, inLimitDistance);
 
     
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
  14.01.16        *
*/
 
