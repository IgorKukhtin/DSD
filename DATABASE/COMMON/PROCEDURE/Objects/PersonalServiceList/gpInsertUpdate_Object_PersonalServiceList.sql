-- Function: gpInsertUpdate_Object_PersonalServiceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar
                                                                , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar
                                                                , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar
                                                                , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalServiceList(
 INOUT ioId                    Integer   ,     -- ключ объекта <> 
    IN inCode                  Integer   ,     -- Код объекта  
    IN inName                  TVarChar  ,     -- Название объекта 
    IN inJuridicalId           Integer   ,     -- Юр. лицо
    IN inPaidKindId            Integer   ,     -- 
    IN inBranchId              Integer   ,     -- 
    IN inBankId                Integer   ,     -- 
    IN inMemberHeadManagerId   Integer   ,     -- Физ лица(исполнительный директор)
    IN inMemberManagerId       Integer   ,     -- Физ лица(директор)
    IN inMemberBookkeeperId    Integer   ,     -- Физ лица(бухгалтер)
    IN inPersonalHeadId        Integer   ,     -- Руководитель подразделения
    IN inBankAccountId         Integer   ,     --
    IN inPSLExportKindId       Integer   ,     -- 
    IN inPersonalServiceListId_AvanceF2 Integer , --  из какой ведомости "Аванс" формируются данные в "Карта БН (ввод) - 2ф."
    IN inCompensation          TFloat    ,     -- месяц компенсации
    IN inSummAvance            TFloat    ,     -- 
    IN inSummAvanceMax         TFloat    ,     -- 
    IN inHourAvance            TFloat    ,     -- 
    IN inKoeffSummCardSecond   TVarChar,      -- Коэфф для выгрузки ведомости Банк 2ф.   нужно * на 1000, т.к. много знаков после зпт, 
    IN inisSecond              Boolean   ,     -- 
    IN inisRecalc              Boolean   ,     -- 
    IN inisBankOut             Boolean   ,     -- 
    IN inisDetail              Boolean   ,     --
    IN inisAvanceNot           Boolean   ,     --
    IN inisBankNot             Boolean   ,     -- Исключить из расчета Выплата банк 2ф
    IN inisCompensationNot     Boolean   ,     -- Исключить из расчета компенсации для отпуска
    IN inisNotAuto             Boolean   ,     -- Исключить из авто-начисления ЗП
    IN inisNotRound            Boolean   ,     -- Исключить из округлений по кассе
    IN inContentType           TVarChar   ,     --
    IN inOnFlowType            TVarChar   ,     --
   -- IN inMemberId            Integer   ,     -- Физ лица(пользователь)
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PersonalServiceList());
   vbUserId:= lpGetUserBySession (inSession);

--RAISE EXCEPTION 'Ошибкa <%>', inKoeffSummCardSecond;

   IF TRIM (COALESCE (inName , '')) = ''
   THEN
       RAISE EXCEPTION 'Ошибкa.Название Ведомости не заполнено.';
   END IF;
   
   
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PersonalServiceList());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PersonalServiceList(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PersonalServiceList(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PersonalServiceList(), vbCode_calc, inName);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Juridical(), ioId, inJuridicalId);

   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_PaidKind(), ioId, inPaidKindId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Branch(), ioId, inBranchId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Bank(), ioId, inBankId);
   
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberHeadManager(), ioId, inMemberHeadManagerId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberManager(), ioId, inMemberManagerId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberBookkeeper(), ioId, inMemberBookkeeperId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_PersonalHead(), ioId, inPersonalHeadId);

   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_BankAccount(), ioId, inBankAccountId);
   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_PSLExportKind(), ioId, inPSLExportKindId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PersonalServiceList_OnFlowType(), ioId, inOnFlowType);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PersonalServiceList_ContentType(), ioId, inContentType);

   -- сохранили св-во 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Avance_F2(), ioId, inPersonalServiceListId_AvanceF2);


   -- сохранили св-во 
   --PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Member(), ioId, inMemberId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_Second(), ioId, inisSecond);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_Recalc(), ioId, inisRecalc);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_BankOut(), ioId, inisBankOut);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_Detail(), ioId, inisDetail);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_AvanceNot(), ioId, inisAvanceNot);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_BankNot(), ioId, inisBankNot);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_CompensationNot(), ioId, inisCompensationNot);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_NotAuto(), ioId, inisNotAuto);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_NotRound(), ioId, inisNotRound);
       
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_Compensation(), ioId, inCompensation);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond(), ioId, (CAST (inKoeffSummCardSecond AS NUMERIC (16,10)) * 1000));
 
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_SummAvance(), ioId, inSummAvance);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_SummAvanceMax(), ioId, inSummAvanceMax);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_HourAvance(), ioId, inHourAvance);          

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.25         * inisNotRound
 21.03.25         * inisNotAuto
 12.02.24         * inisBankNot
 29.01.24         * inisCompensationNot
 14.03.23         * 
 09.03.22         * inPersonalHeadId
 18.11.21         *
 28.04.21         * inisDetail
 18.03.21         * 
 17.11.20         * add inisBankOut
 17.02.20         * add inisRecalc
 27.01.20         * add inCompensation
 20.02.17         * add inisSecond
 26.08.15         * add inMemberId
 15.04.15         * add PaidKind, Branch, Bank
 12.09.14         *
*/

-- тест
-- select * from gpInsertUpdate_Object_PersonalServiceList(ioId := 957950 , inCode := 226 , inName := 'Ведомость Хлеб БН' , inJuridicalId := 131931 , inPaidKindId := 4 , inBranchId := 0 , inBankId := 0 , inMemberHeadManagerId := 0 , inMemberManagerId := 0 , inMemberBookkeeperId := 0 , inisSecond := 'False' , inisRecalc:=false,  inSession := '5');
