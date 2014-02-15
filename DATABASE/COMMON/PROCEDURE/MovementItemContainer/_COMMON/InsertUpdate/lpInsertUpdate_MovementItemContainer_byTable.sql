-- Function: lpInsertUpdate_MovementItemContainer_byTable ()

-- DROP FUNCTION lpInsertUpdate_MovementItemContainer_byTable ();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer_byTable ()
  RETURNS void
AS
$BODY$
BEGIN

     -- �������� �������� �������
     UPDATE Container SET Amount = Container.Amount + _tmpMIContainer.Amount
     FROM (SELECT ContainerId, SUM (COALESCE (_tmpMIContainer_insert.Amount, 0)) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId) AS _tmpMIContainer
     WHERE Container.Id = _tmpMIContainer.ContainerId;

     -- ��������� ��������
     INSERT INTO MovementItemContainer (DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
        SELECT DescId, MovementId, CASE WHEN MovementItemId = 0 THEN NULL ELSE MovementItemId END, ContainerId, CASE WHEN ParentId = 0 THEN NULL ELSE ParentId END, COALESCE (Amount, 0), OperDate, IsActive FROM _tmpMIContainer_insert;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemContainer_byTable () OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.09.13                                        *
*/

-- ����
-- CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
-- SELECT * FROM lpInsertUpdate_MovementItemContainer_byTable ()