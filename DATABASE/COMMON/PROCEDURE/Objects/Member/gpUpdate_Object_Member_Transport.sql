-- Function: gpUpdate_Object_Member_Transport(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Member_Transport (Integer, TVarChar, TDateTime, TDateTime, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, TVarChar);



CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_Transport(
    IN inId	             Integer   ,    -- ключ объекта <Физические лица> 
    IN inDriverCertificate   TVarChar  ,    -- Водительское удостоверение 
    IN inStartSummerDate     TDateTime ,    -- начальная дата для нормы авто лето
    IN inEndSummerDate       TDateTime ,    -- конечная дата для нормы авто лето
    IN inSummerFuel          Tfloat    ,    -- норма авто литры лето
    IN inWinterFuel          Tfloat    ,    -- норма авто литры зима
    IN inReparation          Tfloat    ,    -- амортизация за 1 км., грн.
    IN inLimit               Tfloat    ,    -- лимит грн
    IN inLimitDistance       Tfloat    ,    -- лимит литры
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- !!! это временно !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Member());
   -- END IF;

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Member_Transport());
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_DriverCertificate(), inId, inDriverCertificate);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_StartSummer(), inId, inStartSummerDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_EndSummer(), inId, inEndSummerDate);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Summer(), inId, inSummerFuel);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Winter(), inId, inWinterFuel);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Reparation(), inId, inReparation);


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Limit(), inId, inLimit);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_LimitDistance(), inId, inLimitDistance);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.16         * 
*/