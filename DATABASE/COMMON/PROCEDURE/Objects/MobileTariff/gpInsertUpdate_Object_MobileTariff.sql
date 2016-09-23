-- Function: gpInsertUpdate_Object_MobileTariff  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileTariff (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MobileTariff(
 INOUT ioId                       Integer   ,    -- ключ объекта <> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inMonthly                  TFloat  ,    -- 
    IN inPocketMinutes            TFloat  ,    --
    IN inPocketSMS                TFloat  ,    -- 
    IN inPocketInet               TFloat  ,    -- 
    IN inCostSMS                  TFloat  ,    -- 
    IN inCostMinu                 TFloat  ,    -- 
    IN inCostInet                 TFloat  ,    -- 
    IN inComment                  TVarChar  ,    --
    IN inContractId               Integer   ,    --
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
   DECLARE vbObjectId Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MobileTariff());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MobileTariff()); 
   

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MobileTariff(), vbCode_calc, inName);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_Monthly(), ioId, inMonthly);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_PocketMinutes(), ioId, inPocketMinutes);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_PocketSMS(), ioId, inPocketSMS);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_PocketInet(), ioId, inPocketInet);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_CostSMS(), ioId, inCostSMS);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_CostMinutes(), ioId, inCostMinutes);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_CostInet(), ioId, inCostInet);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MobileTariff_Comment(), ioId, inComment);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileTariff_Contract(), ioId, inContractId);



   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.09.16         *
*/

-- тест
-- select * from gpInsertUpdate_Object_MobileTariff(ioId := 0 , inCode := 1 , inName := 'Белов' , inMonthly := '4444' , PocketMinutes := 'выа@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inContractId := 0 , inMobileTariffKindId := 153272 ,  inSession := '5');
