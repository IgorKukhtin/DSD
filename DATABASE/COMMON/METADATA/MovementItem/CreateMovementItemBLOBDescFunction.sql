CREATE OR REPLACE FUNCTION zc_MIBLOB_Question() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBlobDesc WHERE Code = 'zc_MIBLOB_Question'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBLOBDesc (Code ,itemname)
   SELECT 'zc_MIBLOB_Question','������' WHERE NOT EXISTS (SELECT * FROM MovementItemBlobDesc WHERE Code = 'zc_MIBLOB_Question');

CREATE OR REPLACE FUNCTION zc_MIBLOB_PossibleAnswer() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBlobDesc WHERE Code = 'zc_MIBLOB_PossibleAnswer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBLOBDesc (Code ,itemname)
   SELECT 'zc_MIBLOB_PossibleAnswer','������� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemBlobDesc WHERE Code = 'zc_MIBLOB_PossibleAnswer');



/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.   ������ �.�.
 06.07.21                                                                      * zc_MIBLOB_Question, zc_MIBLOB_PossibleAnswer
*/
