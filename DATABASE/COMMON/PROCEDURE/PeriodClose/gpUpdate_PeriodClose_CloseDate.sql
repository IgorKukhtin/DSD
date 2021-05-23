-- Function: gpUpdate_PeriodClose_CloseDate (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_PeriodClose_all (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_PeriodClose_CloseDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_PeriodClose_CloseDate(
    IN inId	        Integer   ,     -- ���� �������
    IN inCloseDate      TDateTime ,     -- �������� ������
    IN inSession        TVarChar        -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

    --
    IF vbUserId = 9464 THEN vbUserId := 9464;
    ELSE
       -- �������� ���� ������������ �� ����� ���������
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_User()); -- �� ������, ������ ����� ������������ ���� �������
    END IF;

   -- �������� ������� ����������� �� �������� <���� �������>
   UPDATE PeriodClose SET OperDate  = CURRENT_TIMESTAMP
                        , UserId    = vbUserId
                        , CloseDate = inCloseDate
                        , Period    = '0 DAY' :: INTERVAL
   WHERE Id = inId;
  
   -- ������� ���������
   INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
      SELECT vbUserId, CURRENT_TIMESTAMP, vbUserId
           , '<XML>'
          || '<Field FieldName = "������ ������ ��" FieldValue = "' || zfConvert_DateToString (inCloseDate) || '"/>'
          || '</XML>' AS ProtocolData
           , TRUE AS isInsert
            ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.04.16                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_PeriodClose_CloseDate()
