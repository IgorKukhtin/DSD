-- Function: gpInsert_TelegramBot_Protocol(TVarChar)

DROP FUNCTION IF EXISTS gpInsert_TelegramBot_Protocol(Boolean,integer,TVarChar,BOOLEAN,TBLOB,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_TelegramBot_Protocol(
    IN inisInsert           Boolean,   -- ������ ���
    IN inObjectId           Integer,   -- ������������� ��� ���������  
    IN inTelegramId         TVarChar,  -- Id ��������
    IN inisError            BOOLEAN,   -- ������� ������
    IN inMessage            TBLOB,     -- ����� ���������
    IN inError              TVarChar,  -- ������� ������
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());

  vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE(inisInsert, FALSE) <> TRUE
  THEN
    RETURN;
  END IF;

  INSERT INTO Log_Send_Telegram (DateSend, ObjectId, TelegramId, isError, Message, Error, UserId)
  VALUES (CURRENT_TIMESTAMP, inObjectId, inTelegramId, inisError, inMessage, inError, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.11.21                                                       *

*/

-- SELECT * FROM gpInsert_TelegramBot_Protocol(inMovementID := 25504550  ,inSession := '3')