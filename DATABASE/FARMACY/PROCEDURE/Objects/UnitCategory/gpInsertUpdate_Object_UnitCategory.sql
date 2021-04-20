-- Function: gpInsertUpdate_Object_UnitCategory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_UnitCategory (Integer, Integer, TVarChar, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UnitCategory(
 INOUT ioId                        Integer,   -- ключ объекта <>
    IN inCode                      Integer,   -- Код объекта
    IN inName                      TVarChar,  -- Название объекта
    IN inPenaltyNonMinPlan         TFloat,    -- % штрафа за невыполнение минимального плана
    IN inPremiumImplPlan           TFloat,    -- % премии за выполнение плана продаж
    IN inMinLineByLineImplPlan     TFloat,    -- Минимальный % построчного выполнения минимального плана для получения премии
    IN inScaleCalcMarketingPlanId  Integer,   -- Шкала расчета премии/штрафы в план по маркетингу
    IN inSession                   TVarChar   -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_UnitCategory());
   vbUserId := inSession;
  
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_UnitCategory());

   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_UnitCategory(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_UnitCategory(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_UnitCategory(), vbCode_calc, inName);

   -- % штрафа за невыполнение минимального плана
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan(), ioId, inPenaltyNonMinPlan);

   -- % премии за выполнение плана продаж
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_UnitCategory_PremiumImplPlan(), ioId, inPremiumImplPlan);
 
   -- Минимальный % построчного выполнения минимального плана для получения премии
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan(), ioId, inMinLineByLineImplPlan);

   -- сохранили связь с <Шкала расчета премии/штрафы в план по маркетингу>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UnitCategory_ScaleCalcMarketingPlan(), ioId, inScaleCalcMarketingPlanId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.05.18         *
 05.05.18         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_UnitCategory(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='3')