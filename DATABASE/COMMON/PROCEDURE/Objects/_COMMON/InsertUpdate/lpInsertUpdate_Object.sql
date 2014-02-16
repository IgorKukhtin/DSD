-- Function: lpInsertUpdate_Object() - ������ �� �� ....

DROP FUNCTION IF EXISTS lpInsertUpdate_Object (Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object (Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object(
 INOUT ioId           Integer   ,    -- <���� �������>
    IN inDescId       Integer   , 
    IN inObjectCode   Integer   , 
    IN inValueData    TVarChar  , 
    IN inAccessKeyId  Integer DEFAULT NULL
)
AS
$BODY$
BEGIN
   IF COALESCE (ioId, 0) = 0 THEN
      -- �������� ����� ������� ����������� � ������� �������� <���� �������>
      INSERT INTO Object (DescId, ObjectCode, ValueData, AccessKeyId)
                  VALUES (inDescId, inObjectCode, inValueData, inAccessKeyId) RETURNING Id INTO ioId;
   ELSE
       -- �������� ������� ����������� �� �������� <���� �������>
       UPDATE Object SET ObjectCode = inObjectCode, ValueData = inValueData, AccessKeyId = inAccessKeyId WHERE Id = ioId AND DescId = inDescId;

       -- ���� ����� ������� �� ��� ������
       IF NOT FOUND THEN
          -- �������� ����� ������� ����������� �� ��������� <���� �������>
          INSERT INTO Object (Id, DescId, ObjectCode, ValueData, AccessKeyId)
                     VALUES (ioId, inDescId, inObjectCode, inValueData, inAccessKeyId);
       END IF; -- if NOT FOUND

   END IF; -- if COALESCE (ioId, 0) = 0

END;
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION lpInsertUpdate_Object (Integer, Integer, Integer, TVarChar, Integer) OWNER TO postgres; 

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.12.13                                        * add inAccessKeyId
 28.06.13                                        * add AND DescId = inDescId
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object (0, zc_Object_Goods(), -1, 'test-goods');
