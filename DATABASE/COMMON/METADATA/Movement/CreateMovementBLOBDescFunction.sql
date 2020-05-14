CREATE OR REPLACE FUNCTION zc_MovementBlob_Comdoc() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comdoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Comdoc','������ COMDOC' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comdoc');

CREATE OR REPLACE FUNCTION zc_MovementBlob_Comment() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Comment','������� ������' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comment');

CREATE OR REPLACE FUNCTION zc_MovementBlob_Message() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Message'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Message','����� ���������' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Message');

CREATE OR REPLACE FUNCTION zc_MovementBlob_Description() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Description'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Description', '��������' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Description');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.   ������ �.�.
 12.05.20                                                                      * zc_MovementBlob_Description
 10.03.19                                                                      * zc_MovementBlob_Message
 09.02.15         												*
 05.08.14                         *
*/
