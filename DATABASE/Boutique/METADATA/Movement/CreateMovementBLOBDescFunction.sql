
-- CREATE OR REPLACE FUNCTION zc_MovementBlob_Comment() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO MovementBLOBDesc (Code ,itemname)
--    SELECT 'zc_MovementBlob_Comment','������� ������' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comment');


/*-------------------------------------------------------------------------------
 !!!!!!!!!!!!!!!!!!! ������������ ����� �� �������� !!!!!!!!!!!!!!!!!!!
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������   �����
 25.02.17                                        * start
*/
