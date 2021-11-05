-- DROP TABLE IF EXISTS Log_Send_Telegram;

CREATE TABLE Log_Send_Telegram (
  Id                  Serial,     -- Id
  DateSend            TDateTime,  -- Дата отправки
  ObjectId            Integer,    -- Подразделение или сотрудник  
  TelegramId          TVarChar,   -- Id отправки
  
  isError             BOOLEAN,    -- Признак ошибка отправки
  Message             TBLOB,      -- Текст сообщения
  Error               TVarChar,   -- Текст ошибки

  CONSTRAINT Log_Send_Telegram_pkey PRIMARY KEY(Id)
);

-- Function: lpLog_Send_Telegram()

DROP FUNCTION IF EXISTS lpLog_Send_Telegram(Integer, TVarChar, BOOLEAN, TBLOB, TVarChar);

CREATE OR REPLACE FUNCTION lpLog_Send_Telegram(
  IN inObjectId            Integer,   -- Подразделение или сотрудник  
  IN inTelegramId          TVarChar,  -- Id отправки
  IN inisError             BOOLEAN,   -- Признак ошибка
  IN inMessage             TBLOB,     -- Текст сообщения
  IN inError               TVarChar    -- Признак ошибка

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
