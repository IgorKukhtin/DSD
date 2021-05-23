-- Function: gpInsertUpdate_Object_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SheetWorkTime(Integer, Integer, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SheetWorkTime(
 INOUT ioId                  Integer   ,    -- ключ объекта < Основные средства>
    IN inCode                Integer   ,    -- Код объекта 
    IN inStartTime           TDateTime ,    -- Время начала
    IN inWorkTime            TDateTime ,    -- Количество рабочих часов
    IN inDayOffPeriodDate    TDateTime ,    -- Начиная с какого числа расчет периодичности
    IN inDayOffPeriod        TVarChar  ,    -- Периодичность в днях
    IN inComment             TVarChar  ,    -- Примечание
    IN inValue1              Boolean   ,    -- Понедельник
    IN inValue2              Boolean   ,    -- Вторник
    IN inValue3              Boolean   ,    -- Среда
    IN inValue4              Boolean   ,    -- Четверг
    IN inValue5              Boolean   ,    -- Пятница
    IN inValue6              Boolean   ,    -- Суббота
    IN inValue7              Boolean   ,    -- Воскресенье
    IN inDayKindId           Integer   ,    -- ссылка на Тип дня
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbName TVarChar;
   DECLARE vbDayOffWeek TVarChar;
   DECLARE vbDayOffPeriod TVarChar;
   DECLARE vbStartTime TDateTime;
   DECLARE vbEndTime TDateTime;
   DECLARE vbWorkTime TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);


    -- Если код не установлен, определяем его как последний+1
    vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SheetWorkTime()); 

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SheetWorkTime(), vbCode_calc);
    
   vbStartTime:= ( '' ||CURRENT_DATE::Date || ' '||inStartTime ::Time):: TDateTime ;
   vbEndTime  := (vbStartTime + inWorkTime ::Time):: TDateTime ;
   vbWorkTime := ( '' ||CURRENT_DATE::Date || ' '||inWorkTime  ::Time):: TDateTime ;
 

   IF COALESCE (inDayKindId,0) =0 THEN

	RAISE EXCEPTION 'Не выбран реквизит - Тип дня.';

   ELSEIF COALESCE (inDayKindId,0) = zc_Enum_DayKind_Calendar() THEN

         vbName:= 'Рабочие дни - согласно календарным, с ' ||
                  lpad (EXTRACT (HOUR FROM inStartTime)::tvarchar ,2, '0')||':'||lpad (EXTRACT (MINUTE FROM inStartTime)::tvarchar,2, '0') ||  --inStartTime ::Time || 
         ' до ' ||lpad (EXTRACT (HOUR FROM vbEndTime) ::tvarchar ,2, '0') ||':'||lpad (EXTRACT (MINUTE FROM vbEndTime) ::tvarchar ,2, '0') ; -- inWorkTime ::Time;
         -- сохранили <Объект>
         ioId := lpInsertUpdate_Object(ioId, zc_Object_SheetWorkTime(), vbCode_calc, vbName);

         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffPeriod(), ioId, '');
         -- сохранили свойство <>
         vbDayOffWeek:= ('0,' || '0,' || '0,' || '0,' || '0,' ||'0,' || '0' ) ::TVarChar;
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffWeek(), ioId, vbDayOffWeek);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_DayOffPeriod(), ioId, zc_DateStart());

   ELSEIF COALESCE (inDayKindId,0) = zc_Enum_DayKind_Week() THEN

         vbName:= 'Рабочие дни - каждые 7 дней, с ' ||
                    lpad (EXTRACT (HOUR FROM inStartTime)::tvarchar, 2, '0')||':' ||lpad (EXTRACT (MINUTE FROM inStartTime)::tvarchar, 2, '0') ||  --inStartTime ::Time || 
           ' до '|| lpad (EXTRACT (HOUR FROM vbEndTime)  ::tvarchar, 2, '0')||':' ||lpad (EXTRACT (MINUTE FROM vbEndTime)  ::tvarchar, 2, '0')||
           ', выходных '||(CASE WHEN inValue1 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue2 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue3 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue4 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue5 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue6 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue7 = FALSE THEN 0 ELSE 1 END)||
            ' дн. '   ;
         -- сохранили <Объект>
         ioId := lpInsertUpdate_Object(ioId, zc_Object_SheetWorkTime(), vbCode_calc, vbName);

         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffPeriod(), ioId, '');
         -- сохранили свойство <>
         vbDayOffWeek:= (CASE WHEN inValue1 = TRUE THEN '1, ' ELSE '0,' END ||
                         CASE WHEN inValue2 = TRUE THEN '2, ' ELSE '0,' END ||
                         CASE WHEN inValue3 = TRUE THEN '3, ' ELSE '0,' END ||
                         CASE WHEN inValue4 = TRUE THEN '4, ' ELSE '0,' END ||
                         CASE WHEN inValue5 = TRUE THEN '5, ' ELSE '0,' END ||
                         CASE WHEN inValue6 = TRUE THEN '6, ' ELSE '0,' END ||
                         CASE WHEN inValue7 = TRUE THEN '7 '  ELSE '0'  END  ) ::TVarChar;
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffWeek(), ioId, vbDayOffWeek);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_DayOffPeriod(), ioId, zc_DateStart());

   ELSEIF COALESCE (inDayKindId,0) = zc_Enum_DayKind_Period() THEN
         IF COALESCE (inDayOffPeriod, '') =  '' THEN
            RAISE EXCEPTION 'Не заполнет реквизит - Периодичность в днях.';
         END IF;
         vbDayOffPeriod:= (SELECT EXTRACT (DAY FROM inDayOffPeriodDate)||'.'||EXTRACT (MONTH FROM inDayOffPeriodDate)||'.'||EXTRACT (YEAR FROM inDayOffPeriodDate));
         vbName:= 'Рабочие дни - посменно ' ||inDayOffPeriod||' начиная с '||vbDayOffPeriod||
         ', с ' || lpad (EXTRACT (HOUR FROM inStartTime)::tvarchar ,2, '0')||':' ||lpad (EXTRACT (MINUTE FROM inStartTime)::tvarchar,2, '0') ||  --inStartTime ::Time || 
          ' до '|| lpad (EXTRACT (HOUR FROM vbEndTime)::tvarchar ,2, '0')  ||':' ||lpad (EXTRACT (MINUTE FROM vbEndTime) ::tvarchar ,2, '0') ;
         -- сохранили <Объект>
         ioId := lpInsertUpdate_Object(ioId, zc_Object_SheetWorkTime(), vbCode_calc, vbName);

         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffPeriod(), ioId, inDayOffPeriod);
         -- сохранили свойство <>
         vbDayOffWeek:= ('0,' || '0,' || '0,' || '0,' || '0,' ||'0,' || '0' ) ::TVarChar;
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffWeek(), ioId, vbDayOffWeek);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_DayOffPeriod(), ioId, inDayOffPeriodDate);
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_Comment(), ioId, inComment);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_Start(), ioId, vbStartTime);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_Work(), ioId, vbWorkTime);
   -- сохранили связь <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SheetWorkTime_DayKind(), ioId, inDayKindId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.11.16         * 
*/
-- тест
-- select * from gpInsertUpdate_Object_SheetWorkTime(ioId := 736960 , inCode := 1 , inStartTime := ('01.01.2000 3:00:00')::TDateTime , inWorkTime := ('01.01.2000 20:00:00')::TDateTime , inDayOffPeriodDate := ('16.11.2016')::TDateTime , inDayOffPeriod := '3' , inComment := 'уаівтпоьлроі' , inValue1 := 'False' , inValue2 := 'True' , inValue3 := 'True' , inValue4 := 'True' , inValue5 := 'False' , inValue6 := 'False' , inValue7 := 'False' , inDayKindId := 736944 ,  inSession := '5');
