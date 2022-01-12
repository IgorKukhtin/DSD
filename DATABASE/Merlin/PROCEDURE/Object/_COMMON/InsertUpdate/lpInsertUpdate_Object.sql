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
  DECLARE vbDescId Integer;
  DECLARE vbUserId Integer;
BEGIN
   --
   vbUserId := (SELECT Object_RoleAccessKey_View.UserId 
                FROM Object_RoleAccessKey_View
                WHERE Object_RoleAccessKey_View.AccessKeyId = inAccessKeyId
                LIMIT 1
                );

   IF COALESCE (ioId, 0) = 0 THEN
      -- �������� ����� ������� ����������� � ������� �������� <���� �������>
      INSERT INTO Object (DescId, ObjectCode, ValueData, AccessKeyId)
                  VALUES (inDescId, inObjectCode, inValueData, inAccessKeyId) RETURNING Id INTO ioId;

   ELSE
       -- �������� ������� ����������� �� �������� <���� �������>
       UPDATE Object SET ObjectCode = inObjectCode, ValueData = inValueData, AccessKeyId = inAccessKeyId
       WHERE  Id     = ioId
       -- AND DescId = inDescId
       RETURNING DescId INTO vbDescId
      ;

       -- ���� ����� ������� �� ��� ������
       IF NOT FOUND THEN
          -- ������
          --RAISE EXCEPTION '������. ��������� �������� ������ � ������������ ������ <%>', ioId;
          RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������. ��������� �������� ������ � ������������ ������ <%>' :: TVarChar
                                                , inProcedureName := 'lpInsertUpdate_Object' :: TVarChar
                                                , inUserId        := vbUserId
                                                , inParam1        := ioId                    :: TVarChar
                                                );

          -- �������� ����� ������� ����������� �� ��������� <���� �������>
          INSERT INTO Object (Id, DescId, ObjectCode, ValueData, AccessKeyId)
                     VALUES (ioId, inDescId, inObjectCode, inValueData, inAccessKeyId);
       END IF; -- if NOT FOUND


       -- �������� - �.�. DescId - !!!�� ��������!!!
       IF COALESCE (inDescId, -1) <> COALESCE (vbDescId, -2)
       THEN
           /*RAISE EXCEPTION '������ ��������� DescId � <%>(<%>) �� <%>(<%>)', (SELECT ItemName FROM ObjectDesc WHERE Id = vbDescId), vbDescId
                                                                           , (SELECT ItemName FROM ObjectDesc WHERE Id = inDescId), inDescId;
           */
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������ ��������� DescId � <%>(<%>) �� <%>(<%>)' :: TVarChar
                                                 , inProcedureName := 'lpInsertUpdate_Object' :: TVarChar
                                                 , inUserId        := vbUserId
                                                 , inParam1        := (SELECT ItemName FROM ObjectDesc WHERE Id = vbDescId) :: TVarChar
                                                 , inParam2        := vbDescId                                              :: TVarChar
                                                 , inParam3        := (SELECT ItemName FROM ObjectDesc WHERE Id = inDescId) :: TVarChar
                                                 , inParam4        := inDescId                                              :: TVarChar
                                                 );

       END IF;

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
