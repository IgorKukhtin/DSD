-- Function: gpInsertUpdate_Object_Print_byGrid ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Print_byGrid (Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Print_byGrid(

    IN inMovementId        Integer,
    IN inGoodsId           Integer,
    IN inGoodsKindId       Integer, 
    IN inPartionGoodsDate  TDateTime,
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
                    AND Object_Print.ObjectId = inMovementId)
   THEN
       -- �������� �������
       INSERT INTO Object_Print (ObjectId, ReportKindId, UserId, ValueDate, InsertDate)
                        VALUES (inMovementId
                              , inGoodsId
                              , vbUserId 
                              , inPartionGoodsDate
                              , vbInsertDate);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.09.24         *
*/

-- ����
--