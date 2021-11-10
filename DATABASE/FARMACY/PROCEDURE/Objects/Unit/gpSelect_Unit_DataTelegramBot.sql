-- Function: gpSelect_Unit_DataTelegramBot()

DROP FUNCTION IF EXISTS gpSelect_Unit_DataTelegramBot(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Unit_DataTelegramBot(
    IN inUnitId             Integer  ,     -- ������������� 
   OUT outTelegramId        TVarChar ,     -- ID ������
   OUT outTelegramBotToken  TVarChar ,     -- ����� �������� ����
   OUT outisSend            Boolean  ,     -- ����������
    IN inSession            TVarChar       -- ������ ������������
)
AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   SELECT ObjectString_CashSettings_TelegramBotToken.ValueData                     AS TelegramBotToken
   INTO outTelegramBotToken
   FROM Object AS Object_CashSettings
        LEFT JOIN ObjectString AS ObjectString_CashSettings_TelegramBotToken
                               ON ObjectString_CashSettings_TelegramBotToken.ObjectId = Object_CashSettings.Id 
                              AND ObjectString_CashSettings_TelegramBotToken.DescId = zc_ObjectString_CashSettings_TelegramBotToken()

   WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
   LIMIT 1;
   
   SELECT ObjectString_Unit_TelegramId.ValueData    
   INTO outTelegramId
   FROM ObjectString AS ObjectString_Unit_TelegramId
   WHERE ObjectString_Unit_TelegramId.ObjectId = inUnitId
     AND ObjectString_Unit_TelegramId.DescId = zc_ObjectString_Unit_TelegramId();
  
   outisSend := COALESCE(outTelegramBotToken, '') <> '' AND COALESCE(outTelegramId, '') <> '';
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Unit_DataTelegramBot(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.11.21                                                       *

*/

-- ����
-- 
SELECT * FROM gpSelect_Unit_DataTelegramBot (183292, '3')