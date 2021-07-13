-- Function: gpInsertUpdate_Object_MobileEmployee  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer,Integer,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_MobileEmployee2(
 INOUT ioId                       Integer   ,    -- ключ объекта <> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inLimit                    TFloat    ,    -- Лимит
    IN inDutyLimit                TFloat    ,    -- Служебный лимит
    IN inNavigator                TFloat    ,    -- Услуга Навигатор
    IN inComment                  TVarChar  ,    -- Комментарий
    IN inPersonalId               Integer   ,    -- Сотрудники
    IN inMobileTariffId           Integer   ,    -- Тарифы мобильных операторов
    IN inRegionId                 Integer   ,    -- регион
    IN inMobilePackId             Integer   ,    -- Название пакета
    IN inUserId                   Integer        -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbCode_calc Integer; 

BEGIN
   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MobileEmployee()); 
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MobileEmployee(), vbCode_calc, inName);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileEmployee_Limit(), ioId, inLimit);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileEmployee_DutyLimit(), ioId, inDutyLimit);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileEmployee_Navigator(), ioId, inNavigator);
  
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MobileEmployee_Comment(), ioId, inComment);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_Personal(), ioId, inPersonalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_MobileTariff(), ioId, inMobileTariffId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_Region(), ioId, inRegionId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_MobilePack(), ioId, inMobilePackId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.07.21         *
 05.10.16         * parce
 01.10.16         *
*/

-- тест
-- select * from lpInsertUpdate_Object_MobileEmployee2(ioId := 0 , inCode := 1 , inName := 'Белов' , inLimit := '4444' , DutyLimit := 'выа@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inPersonalId := 0 , inMobileEmployeeKindId := 153272 ,  inSession := '5');
