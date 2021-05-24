-- Function: gpInsertUpdate_Object_Print ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Print(
    IN inId            Integer,      --
    IN inAmount        Integer ,      --
    IN inSession       TVarChar      -- ������ ������������
)
RETURNS void
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!������� ������� ������ ���� ������������� ������ ��� �� 7 ����!!!
   --DELETE FROM ObjectPrint WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';
   
   -- ������� � ������� ����/�����
   vbInsertDate := CURRENT_TIMESTAMP;
   
   IF NOT EXISTS (SELECT 1 
                  FROM ObjectPrint 
                  WHERE (ObjectPrint.UserId = vbUserId) 
                    AND ObjectPrint.ObjectId = inId)
   THEN
       -- �������� �������
       INSERT INTO ObjectPrint (ObjectId, UserId, Amount, InsertDate)
                        VALUES (inId, vbUserId, inAmount, vbInsertDate);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.05.20         *
*/

-- ����
--