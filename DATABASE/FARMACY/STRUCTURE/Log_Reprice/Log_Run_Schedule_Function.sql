-- DROP TABLE IF EXISTS Log_Run_Schedule_Function;

CREATE TABLE Log_Run_Schedule_Function (
  Id                  Serial,     -- Id
  FunctionName        TVarChar,   -- Функция
  isError             BOOLEAN,    -- Признак ошибка
  Error               TVarChar,   -- Текст ошибки

  UserID              Integer,    -- Сотрудник
  DateInsert          TDateTime,  -- Дата

  CONSTRAINT Log_Run_Schedule_Function_pkey PRIMARY KEY(Id)
);

-- Function: lpLog_Run_Schedule_Function()

DROP FUNCTION IF EXISTS lpLog_Run_Schedule_Function(TVarChar, BOOLEAN, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpLog_Run_Schedule_Function(
  IN inFunctionName        TVarChar,   -- Функция
  IN inisError             BOOLEAN,   -- Признак ошибка
  IN inError               TVarChar,   -- Текст ошибки

  IN inUserID              Integer    -- Сотрудник
)
RETURNS VOID
AS
$BODY$
  DECLARE vbCode Integer;
BEGIN
  INSERT INTO Log_Run_Schedule_Function (FunctionName, isError, Error, UserID, DateInsert)
  VALUES (inFunctionName, inisError, inError, inUserID, CURRENT_TIMESTAMP);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpLog_Run_Schedule_Function(TVarChar, BOOLEAN, TVarChar, Integer) OWNER TO postgres;

-- SELECT * FROM Log_Run_Schedule_Function
