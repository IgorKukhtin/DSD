-- ����� "������" �������� ������������, �.�. ������ ���������� �� ����� ���� �����

DROP FUNCTION IF EXISTS lpInsert_LockUnique_log (TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsert_LockUnique_log(
    IN inKeyData      TVarChar,
    IN inUserId       Integer,
    IN inComment      TVarChar
)
RETURNS VOID
AS
$BODY$
BEGIN

     -- ��������
     IF TRIM (COALESCE (inKeyData, '' )) = ''
     THEN 
         RAISE EXCEPTION '������.�������� ���� � �������� ������������ - ������. <%>', inKeyData;
     END IF;

 
     -- �������� ���� ��� �����
     DELETE FROM LockUnique WHERE OperDate < CURRENT_DATE; -- - INTERVAL '1 DAY';

     IF 1=0 --AND inUserId = 5 AND EXISTS (SELECT 1 FROM LockUnique WHERE KeyData ILIKE inKeyData)
     THEN
         RAISE EXCEPTION '������.������� ������������ ��������� ������.<%> <%>', inKeyData, inUserId;
     ELSE
         -- ���� ������ ��������� - ������ ������������ �����������
         INSERT INTO LockUnique (KeyData, UserId, OperDate, Comment)
                         VALUES (inKeyData, inUserId, CURRENT_TIMESTAMP, inComment);
   
     END IF;

     EXCEPTION
              WHEN OTHERS THEN RAISE EXCEPTION '������.������� ������������ ��������� ������.��������� �������� ����� 1 ���.';
              
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.05.25                                        *
*/

-- ����
-- SELECT * FROM LockUnique WHERE KeyData like '%DC899%' ORDER BY OperDate DESC LIMIT 10
