

CREATE OR REPLACE FUNCTION zc_MovementBlob_Info1() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Info1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Info1','���������� 1' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Info1');


CREATE OR REPLACE FUNCTION zc_MovementBlob_Info2() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Info2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Info2','���������� 2' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Info2');


CREATE OR REPLACE FUNCTION zc_MovementBlob_Info3() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Info3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Info3','���������� 3' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Info3');

CREATE OR REPLACE FUNCTION zc_MovementBlob_11() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_11','���������� (���� �������������)' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_11');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.03.21         * zc_MovementBlob_Info...
 24.08.20                                        *
*/
