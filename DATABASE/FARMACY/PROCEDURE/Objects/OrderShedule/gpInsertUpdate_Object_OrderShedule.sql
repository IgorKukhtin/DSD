-- Function: gpInsertUpdate_Object_OrderShedule()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderShedule (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderShedule(
 INOUT ioId                       Integer ,    -- ключ объекта <График заказа/доставки>
    IN inCode                     Integer ,    -- Код объекта <>
    IN inValue1                   TVarChar  ,  -- понедльник значение
    IN inValue2                   TVarChar  ,  -- вторник
    IN inValue3                   TVarChar  ,  -- среда
    IN inValue4                   TVarChar  ,  -- четверг
    IN inValue5                   TVarChar  ,  -- пятница
    IN inValue6                   TVarChar  ,  -- суббота
    IN inValue7                   TVarChar  ,  -- воскресенье
   OUT outInf_Text1               TVarChar  ,  -- инф. названия дней недели заказ
   OUT outInf_Text2               TVarChar  ,  -- инф. названия дней недели доставка
   OUT outColor_Calc1             Integer   ,  -- цвет понедельник
   OUT outColor_Calc2             Integer   ,  -- цвет вторник
   OUT outColor_Calc3             Integer   ,  -- цвет среда
   OUT outColor_Calc4             Integer   ,  -- цвет четверг
   OUT outColor_Calc5             Integer   ,  -- цвет пятница
   OUT outColor_Calc6             Integer   ,  -- цвет суббота
   OUT outColor_Calc7             Integer   ,  -- цвет воскресенье
    IN inUnitId                   Integer   ,  -- ссылка подразделение
    IN inContractId               Integer   ,  -- ссылка на договор
    IN inSession                  TVarChar     -- сессия пользователя
)
  RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
   DECLARE vbName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderShedule());
   vbUserId:= inSession;

   -- Если код не установлен, определяем его как последний+1 
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_OrderShedule());
    
    -- проверка уникальности  по договор и подразделение
    IF COALESCE (ioId,0) = 0 THEN
       IF EXISTS (SELECT ObjectLink_OrderShedule_Contract.ObjectId
                  FROM ObjectLink AS ObjectLink_OrderShedule_Contract
                     INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                             ON ObjectLink_OrderShedule_Unit.ObjectId = ObjectLink_OrderShedule_Contract.ObjectId
                            AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                            AND ObjectLink_OrderShedule_Unit.ChildObjectId = inUnitId
                  WHERE ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                    AND ObjectLink_OrderShedule_Contract.ChildObjectId = inContractId
                  ) 
       THEN
          RAISE EXCEPTION 'Данные не уникальны - Аптека = "%" Договор "%" .',  lfGet_Object_ValueData(inUnitId), lfGet_Object_ValueData(inContractId);
       END IF;
    END IF;
 
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_OrderShedule(), vbCode_calc);

   vbName:= (inValue1||';'||inValue2||';'||inValue3||';'||inValue4||';'||inValue5||';'||inValue6||';'||inValue7) :: TVarChar;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderShedule(), vbCode_calc, vbName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderShedule_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderShedule_Unit(), ioId, inUnitId);

 -- инф. названия дней недели заказ
 outInf_Text1:= (CASE WHEN CAST('0'||inValue1 AS TFloat) in (1,3) THEN 'Понедельник,' ELSE '' END ||
                 CASE WHEN CAST('0'||inValue2 AS TFloat) in (1,3) THEN 'Вторник,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue3 AS TFloat) in (1,3) THEN 'Среда,'       ELSE '' END ||
                 CASE WHEN CAST('0'||inValue4 AS TFloat) in (1,3) THEN 'Четверг,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue5 AS TFloat) in (1,3) THEN 'Пятница,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue6 AS TFloat) in (1,3) THEN 'Суббота,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue7 AS TFloat) in (1,3) THEN 'Воскресенье'  ELSE '' END) ::TVarChar;
 -- инф. названия дней недели доставка
 outInf_Text2:= (CASE WHEN CAST('0'||inValue1 AS TFloat) in (2,3) THEN 'Понедельник,' ELSE '' END ||
                 CASE WHEN CAST('0'||inValue2 AS TFloat) in (2,3) THEN 'Вторник,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue3 AS TFloat) in (2,3) THEN 'Среда,'       ELSE '' END ||
                 CASE WHEN CAST('0'||inValue4 AS TFloat) in (2,3) THEN 'Четверг,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue5 AS TFloat) in (2,3) THEN 'Пятница,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue6 AS TFloat) in (2,3) THEN 'Суббота,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue7 AS TFloat) in (2,3) THEN 'Воскресенье'  ELSE '' END) ::TVarChar;

 -- возвращаем цвет             
 outColor_Calc1:= CASE WHEN CAST('0'||inValue1 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue1 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue1 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc2:= CASE WHEN CAST('0'||inValue2 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue2 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue2 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc3:= CASE WHEN CAST('0'||inValue3 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue3 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue3 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc4:= CASE WHEN CAST('0'||inValue4 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue4 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue4 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc5:= CASE WHEN CAST('0'||inValue5 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue5 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue5 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc6:= CASE WHEN CAST('0'||inValue6 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue6 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue6 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc7:= CASE WHEN CAST('0'||inValue7 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue7 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue7 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.16         * parce
 20.09.16         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_OrderShedule ()                            
