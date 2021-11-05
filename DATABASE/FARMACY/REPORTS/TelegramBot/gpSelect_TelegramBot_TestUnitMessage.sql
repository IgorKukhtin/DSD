-- Function: gpSelect_TelegramBot_TestUnitMessage()

DROP FUNCTION IF EXISTS gpSelect_TelegramBot_TestUnitMessage (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_TelegramBot_TestUnitMessage(
    IN inOperDate      TDateTime ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (ObjectId Integer
             , TelegramId TVarChar
             , Message TBLOB
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- ���������
     RETURN QUERY
     SELECT Object_Unit.Id
           , ObjectString_Unit_TelegramId.ValueData::TVarChar
           , Object_Unit.ValueData::TBLOB
     FROM Object AS Object_Unit

          INNER JOIN ObjectString AS ObjectString_Unit_TelegramId
                                  ON ObjectString_Unit_TelegramId.ObjectId = Object_Unit.Id
                                 AND ObjectString_Unit_TelegramId.DescId = zc_ObjectString_Unit_TelegramId()
                                 
     WHERE Object_Unit.DescId = zc_Object_Unit()
       AND Object_Unit.isErased = False
       AND COALESCE (ObjectString_Unit_TelegramId.ValueData, '') <> ''
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.11.21                                                       * 
*/

-- ����

select * from gpSelect_TelegramBot_TestUnitMessage(inOperDate := CURRENT_TIMESTAMP::TDateTime,  inSession := '3');