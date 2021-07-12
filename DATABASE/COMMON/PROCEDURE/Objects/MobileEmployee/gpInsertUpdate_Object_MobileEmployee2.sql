-- Function: gpInsertUpdate_Object_MobileEmployee  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MobileEmployee2(
 INOUT ioId                       Integer   ,    -- ключ объекта <> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inLimit                    TFloat    ,    -- Лимит 
    IN inDutyLimit                TFloat    ,    -- Служебный лимит
    IN inNavigator                TFloat    ,    -- Услуга навигатора
    IN inComment                  TVarChar  ,    -- Комментарий
    IN inPersonalId               Integer   ,    -- Сотрудник
    IN inMobileTariffId           Integer   ,    -- Тариф
    IN inRegionId                 Integer   ,    -- регион
    IN inMobilePackId             Integer   ,    -- Название пакета
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
   DECLARE vbObjectId Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MobileEmployee());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object_MobileEmployee2(ioId             :=  ioId
                                               , inCode           := inCode
                                               , inName           := inName
                                               , inLimit          := inLimit
                                               , inDutyLimit      := inDutyLimit
                                               , inNavigator      := inNavigator
                                               , inComment        := inComment
                                               , inPersonalId     := inPersonalId
                                               , inMobileTariffId := inMobileTariffId
                                               , inRegionId       := inRegionId
                                               , inMobilePackId   := inMobilePackId
                                               , inUserId         := vbUserId
                                                 );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.07.21         *
 03.02.17         * add inRegionId
 05.10.16         * parce
 23.09.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MobileEmployee2(ioId := 0 , inCode := 1 , inName := 'Белов' , inLimit := '4444' , DutyLimit := 'выа@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inPersonalId := 0 , inMobileEmployeeKindId := 153272 ,  inSession := '5');
