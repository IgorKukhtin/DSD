-- DROP TABLE IF EXISTS Log_Run_Schedule_Function;

CREATE TABLE Log_Run_Schedule_Function (
  Id                  Serial,     -- Id
  FunctionName        TVarChar,   -- �������
  isError             BOOLEAN,    -- ������� ������
  Error               TVarChar,   -- ����� ������

  UserID              Integer,    -- ���������
  DateInsert          TDateTime,  -- ����

  CONSTRAINT Log_Run_Schedule_Function_pkey PRIMARY KEY(Id)
);

-- Function: lpLog_Run_Schedule_Function()

DROP FUNCTION IF EXISTS lpLog_Run_Schedule_Function(TVarChar, BOOLEAN, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpLog_Run_Schedule_Function(
  IN inFunctionName        TVarChar,   -- �������
  IN inisError             BOOLEAN,   -- ������� ������
  IN inError               TVarChar,   -- ����� ������

  IN inUserID              Integer    -- ���������
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
