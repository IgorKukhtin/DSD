-- Function: gpInsertUpdate_EmployeeWorkLog_Cash()

--DROP FUNCTION IF EXISTS gpInsertUpdate_EmployeeWorkLog_Cash (TVarChar, Integer, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_EmployeeWorkLog_Cash (TVarChar, TVarChar, Integer, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_EmployeeWorkLog_Cash(
    IN inCashSessionId TVarChar,   -- Сессия кассового места
    IN inCashRegister  TVarChar,   -- Фискальный номер
    IN inUserId        Integer,    -- Текущая накладная
    IN inDateLogIn     TDateTime,  -- Дата и время входа
    IN inDateZReport   TDateTime,  -- Дата и время выполнения Z отчета
    IN inDateLogOut    TDateTime,  -- Дата и время выхода
    IN inOldProgram    Boolean,    -- Вход старой кассой
    IN inOldServise    Boolean,    -- Не обновлен сервис
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());


    IF EXISTS(SELECT 1 FROM EmployeeWorkLog WHERE CashSessionId = inCashSessionId AND UserId = inUserId AND UnitId = vbUnitId AND DateLogIn = inDateLogIn)
    THEN
      UPDATE EmployeeWorkLog SET RetailId = vbRetailId, DateZReport = inDateZReport, DateLogOut = inDateLogOut
      WHERE CashSessionId = inCashSessionId AND UserId = inUserId AND UnitId = vbUnitId AND DateLogIn = inDateLogIn;
    ELSE
      INSERT INTO EmployeeWorkLog (CashSessionId, CashRegister, UserId, UnitId, RetailId, DateLogIn, DateZReport, DateLogOut, OldProgram, OldServise)
      VALUES (inCashSessionId, inCashRegister, inUserId, vbUnitId, vbRetailId, inDateLogIn, inDateZReport, inDateLogOut, inOldProgram, inOldServise);
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.01.19                                                       *
*/