-- Function: gpInsertUpdate_Object_Car(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar)

-- DROP FUNCTION IF EXISTS gpUpdate_Object_GlobalConst (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_GlobalConst (Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GlobalConst(
 INOUT ioId                       Integer   ,    -- ключ объекта
 INOUT ioActualBankStatementDate  TDateTime ,    -- Дата
 INOUT ioComment                  TVarChar  ,    -- ключ объекта
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка прав пользователя (конечно кроме пользователя Админа)
     IF (NOT EXISTS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND AccessKeyId = ioId)
         AND vbUserId <> zfCalc_UserAdmin() :: Integer
         AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
        )
      OR ioId IN (zc_Enum_GlobalConst_ConnectParam(), zc_Enum_GlobalConst_ConnectReportParam(), zc_Enum_GlobalConst_ConnectStoredProcParam(), zc_Enum_GlobalConst_MedocTaxDate(), zc_Enum_GlobalConst_EndDateOlapSR(), zc_Enum_GlobalConst_ProtocolDateOlapSR())
     THEN
          RAISE EXCEPTION 'Ошибка.Нет прав изменять параметр <%>.', lfGet_Object_ValueData (ioId);
     END IF;


     IF ioId = zc_Enum_GlobalConst_StartDate_Auto_PrimeCost()
     THEN ioComment:= zfCalc_MonthName (ioActualBankStatementDate);
          -- всегда 01 число
          ioActualBankStatementDate:= DATE_TRUNC ('MONTH', ioActualBankStatementDate);

     ELSEIF ioId NOT IN (zc_Enum_GlobalConst_StartTime0_Auto_PrimeCost(), zc_Enum_GlobalConst_StartTime1_Auto_PrimeCost(), zc_Enum_GlobalConst_StartTime2_Auto_PrimeCost(), zc_Enum_GlobalConst_StartTime3_Auto_PrimeCost())
     THEN ioComment:= '';
--   THEN ioComment:= SUBSTRING (zfConvert_DateTimeShortToString (ioActualBankStatementDate), 10, 5)

     END IF;


     -- замена - добавим время
     IF ioId IN (zc_Enum_GlobalConst_StartTime0_Auto_PrimeCost(), zc_Enum_GlobalConst_StartTime1_Auto_PrimeCost(), zc_Enum_GlobalConst_StartTime2_Auto_PrimeCost(), zc_Enum_GlobalConst_StartTime3_Auto_PrimeCost())
     THEN
          --
          IF TRIM (ioComment) = '' THEN ioComment:= '00:00'; END IF;
          --
          ioActualBankStatementDate:= (zfConvert_DateToString (CURRENT_DATE) || ' ' || TRIM (ioComment)) :: TDateTime;

     END IF;


     -- сохранили <Дату ...>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GlobalConst_ActualBankStatement(), ioId, ioActualBankStatementDate);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_GlobalConst (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.15                                        * add проверка прав пользователя (конечно кроме пользователя Админа)
 07.06.15                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Car()
