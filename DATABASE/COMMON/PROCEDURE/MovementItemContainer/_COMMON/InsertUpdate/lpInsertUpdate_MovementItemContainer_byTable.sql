-- Function: lpInsertUpdate_MovementItemContainer_byTable ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer_byTable ();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer_byTable ()
RETURNS VOID
AS
$BODY$
   DECLARE vbCount Integer;
BEGIN
     -- ��� ��������� ��� � �� ���� ������: ���������� ����������������
     PERFORM Container.* FROM Container INNER JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.ContainerId = Container.Id FOR UPDATE;

     -- �������� �������� �������
     UPDATE Container SET Amount = Container.Amount + _tmpMIContainer.Amount
     FROM (SELECT ContainerId, SUM (COALESCE (_tmpMIContainer_insert.Amount, 0)) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId) AS _tmpMIContainer
     WHERE Container.Id = _tmpMIContainer.ContainerId;

     -- ��������� ��������
     INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId, AnalyzerId, Amount, OperDate, IsActive)
        SELECT DescId, MovementDescId, MovementId
             , CASE WHEN MovementItemId = 0 THEN NULL ELSE MovementItemId END
             , CASE WHEN ParentId = 0 THEN NULL ELSE ParentId END
             , ContainerId
             , CASE WHEN AnalyzerId = 0 THEN NULL ELSE AnalyzerId END
             , COALESCE (Amount, 0)
             , OperDate
             , IsActive
        FROM _tmpMIContainer_insert;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemContainer_byTable () OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.14                                        * add AnalyzerId
 17.08.14                                        * add MovementDescId
 13.08.14                                        * del ��� ��� ��������� ��� � �� ���� ������: ���������� ����������������
 14.04.14                                        * add ��� ��� ��������� ��� � �� ���� ������: ���������� ����������������
 02.09.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItemContainer_byTable ()
