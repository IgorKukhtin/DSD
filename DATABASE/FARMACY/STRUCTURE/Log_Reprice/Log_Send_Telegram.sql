-- DROP TABLE IF EXISTS Log_Send_Telegram;

CREATE TABLE Log_Send_Telegram (
  Id                  Serial,     -- Id
  DateSend            TDateTime,  -- ���� ��������
  ObjectId            Integer,    -- ������������� ��� ���������  
  TelegramId          TVarChar,   -- Id ��������
  
  isError             BOOLEAN,    -- ������� ������ ��������
  Message             TBLOB,      -- ����� ���������
  Error               TVarChar,   -- ����� ������

  CONSTRAINT Log_Send_Telegram_pkey PRIMARY KEY(Id)
);

-- Function: lpLog_Send_Telegram()

DROP FUNCTION IF EXISTS lpLog_Send_Telegram(Integer, TVarChar, BOOLEAN, TBLOB, TVarChar);

CREATE OR REPLACE FUNCTION lpLog_Send_Telegram(
  IN inObjectId            Integer,   -- ������������� ��� ���������  
  IN inTelegramId          TVarChar,  -- Id ��������
  IN inisError             BOOLEAN,   -- ������� ������
  IN inMessage             TBLOB,     -- ����� ���������
  IN inError               TVarChar    -- ������� ������

)
RETURNS VOID
AS
$BODY$
BEGIN
  INSERT INTO Log_Send_Telegram (DateSend, ObjectId, TelegramId, isError, Message, Error)
  VALUES (CURRENT_TIMESTAMP, inObjectId, inTelegramId, inisError, inMessage, inError);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpLog_Send_Telegram(Integer, TVarChar, BOOLEAN, TBLOB, TVarChar) OWNER TO postgres;

-- SELECT * FROM Log_Send_Telegram
