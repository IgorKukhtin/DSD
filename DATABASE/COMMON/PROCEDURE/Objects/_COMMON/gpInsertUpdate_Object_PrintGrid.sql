-- Function: gpInsertUpdate_Object_PrintGrid ()
--������������, ��� � ����� ���� ������������  ��� ���� ����
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PrintGrid (Integer, Integer, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PrintGrid(
    IN inObjectId          Integer,
    IN inReportKindId      Integer,
    IN inValue             TFloat ,
    IN inValueDate         TDateTime,
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS void
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!������� ������� ������ �� ������������ ������ ��� �� 7 ����!!!
   --DELETE FROM Object_Print WHERE UserId = vbUserId;
   
   -- ������� � ������� ����/�����
   vbInsertDate := CURRENT_TIMESTAMP;
   
   IF NOT EXISTS (SELECT 1 
                  FROM Object_Print 
                  WHERE (Object_Print.UserId = vbUserId) 
                    AND Object_Print.ObjectId = inObjectId)
   THEN
       -- �������� �������
       INSERT INTO Object_Print (ObjectId, ReportKindId, UserId, Value, ValueDate, InsertDate)
                        VALUES (inObjectId
                              , inReportKindId
                              , vbUserId 
                              , inValue     ::TFloat
                              , inValueDate ::TDateTime
                              , vbInsertDate);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.09.24         *
*/

-- ����
--