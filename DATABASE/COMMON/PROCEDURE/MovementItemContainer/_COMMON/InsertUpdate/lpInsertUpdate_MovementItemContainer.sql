-- Function: lpInsertUpdate_MovementItemContainer

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer(
 INOUT ioId                      Integer               ,
    IN inDescId                  Integer               ,
    IN inMovementDescId          Integer               ,
    IN inMovementId              Integer               ,
    IN inMovementItemId          Integer               ,
    IN inParentId                Integer               ,
    IN inContainerId             Integer               ,
    IN inAnalyzerId              Integer               ,
    IN inAmount                  TFloat                ,
    IN inOperDate                TDateTime             ,
    IN inIsActive                Boolean
)
AS
$BODY$
BEGIN
     -- ��� ��������� ��� � �� ���� ������: ���������� ����������������
     PERFORM Container.* FROM Container WHERE Id = inContainerId FOR UPDATE;

     -- ������ ��������
     IF inParentId = 0 THEN inParentId:= NULL; END IF;

     -- �������� �������� �������
     UPDATE Container SET Amount = Amount + COALESCE (inAmount, 0) WHERE Id = inContainerId;
     -- ��������� ��������
     INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId, AnalyzerId, Amount, OperDate, IsActive)
                                VALUES (inDescId, inMovementDescId, inMovementId, inMovementItemId, inParentId, inContainerId, CASE WHEN inAnalyzerId = 0 THEN NULL ELSE inAnalyzerId END, COALESCE (inAmount, 0), inOperDate, inIsActive) RETURNING Id INTO ioId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.14                                        * add inAnalyzerId
 17.08.14                                        * add inMovementDescId
 13.08.14                                        * del ��� ��� ��������� ��� � �� ���� ������: ���������� ����������������
 15.04.14                                        * add ��� ��� ��������� ��� � �� ���� ������: ���������� ����������������
 07.08.13                                        * add inParentId and inIsActive
 25.07.13                                        * add inMovementItemId
 11.07.13                                        * !!! finich !!!
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItemContainer (ioId:=0, inDescId:= zc_MIContainer_Count(), )