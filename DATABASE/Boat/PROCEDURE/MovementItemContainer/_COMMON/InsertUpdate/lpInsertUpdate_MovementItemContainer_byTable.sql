-- Function: lpInsertUpdate_MovementItemContainer_byTable ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer_byTable ();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer_byTable ()
RETURNS VOID
AS
$BODY$
   DECLARE vbLock Integer;
   DECLARE vbTmp Integer;
   DECLARE vbSec Integer;
BEGIN
    -- ��� ��������� ��� � �� ���� ������: ���������� ����������������
    IF zc_IsLockTable() = TRUE
    THEN
        -- LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
        LOCK TABLE LockProtocol IN SHARE UPDATE EXCLUSIVE MODE;
    ELSE
    IF zc_IsLockTableCycle() = TRUE
    THEN
        vbLock := 1;
        WHILE vbLock <> 0 LOOP
            BEGIN
               PERFORM Container.* FROM Container WHERE Container.Id IN (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert) FOR UPDATE;
               vbLock := 0;
            EXCEPTION 
                     WHEN OTHERS THEN vbLock := vbLock + 1;
                                      vbTmp:= (SELECT _tmpMIContainer_insert.MovementId FROM _tmpMIContainer_insert LIMIT 1);
                                      vbSec:= CASE WHEN 0 <> SUBSTR (vbTmp :: TVarChar,  0 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbTmp :: TVarChar,  0 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (vbTmp :: TVarChar, -1 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbTmp :: TVarChar, -1 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (vbTmp :: TVarChar, -2 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbTmp :: TVarChar, -2 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (vbTmp :: TVarChar, -3 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbTmp :: TVarChar, -3 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                   ELSE SUBSTR (vbTmp :: TVarChar, 1, 1) :: Integer
                                               END;
                                      --
                                      IF vbLock <= 5
                                      THEN PERFORM pg_sleep (zc_IsLockTableSecond());

                                      ELSE IF vbLock <= 10
                                      THEN PERFORM pg_sleep (vbLock - 5 + vbSec);

                                      ELSE IF vbLock <= 15
                                      THEN PERFORM pg_sleep (vbLock - 5 + vbSec);

                                      ELSE RAISE EXCEPTION 'Deadlock <%>', vbTmp;
                                      END IF;
                                      END IF;
                                      END IF;
            END;
        END LOOP;
    ELSE
        PERFORM Container.* FROM Container WHERE Container.Id IN (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert) FOR UPDATE;
    END IF;
    END IF;
    
     -- �������� �������� �������
     UPDATE Container SET Amount = Container.Amount + _tmpMIContainer.Amount
     FROM (SELECT ContainerId, SUM (COALESCE (_tmpMIContainer_insert.Amount, 0)) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId) AS _tmpMIContainer
     WHERE Container.Id = _tmpMIContainer.ContainerId;

     -- ��������� ��������
     INSERT INTO MovementItemContainer (DescId
                                      , MovementDescId          -- ��� ���������
                                      , MovementId
                                      , MovementItemId
                                      , ContainerId
                                      , ParentId

                                      , AccountId               -- ����
                                      , AnalyzerId              -- ���� �������� (��������)
                                      , ObjectId_Analyzer       -- MovementItem.ObjectId
                                      , PartionId               -- MovementItem.PartionId
                                      , WhereObjectId_Analyzer  -- ����� �����
                                      
                                      , AccountId_Analyzer      -- ���� - �������������
                                      
                                      , ContainerId_Analyzer    -- ��������� ���� - ������ ���� ��� ���������� � �������/�������
                                      , ContainerIntId_Analyzer -- ��������� - �������������

                                      , ObjectIntId_Analyzer    -- ������������� ���������� (������, �� ������ ��� ���-�� ��������� - �.�. ��� �� ��� �� ��������� � ��������� ����)
                                      , ObjectExtId_Analyzer    -- ������������� ���������� (������������� - �������������, ������������� ��, ���, ���������� � �.�. - �.�. ��� �� ��� �� ��������� � ��������� ����)

                                      , Amount
                                      , OperDate
                                      , IsActive
                                       )
        SELECT DescId, MovementDescId, MovementId
             , CASE WHEN MovementItemId          = 0 THEN NULL ELSE MovementItemId END
             , ContainerId
             , CASE WHEN ParentId                = 0 THEN NULL ELSE ParentId END

             , CASE WHEN AccountId               = 0 THEN NULL ELSE AccountId END
             , CASE WHEN AnalyzerId              = 0 THEN NULL ELSE AnalyzerId END
             , CASE WHEN ObjectId_Analyzer       = 0 THEN NULL ELSE ObjectId_Analyzer END
             , CASE WHEN PartionId               = 0 THEN NULL ELSE PartionId END
             , CASE WHEN WhereObjectId_Analyzer  = 0 THEN NULL ELSE WhereObjectId_Analyzer END

             , CASE WHEN AccountId_Analyzer      = 0 THEN NULL ELSE AccountId_Analyzer END

             , CASE WHEN ContainerId_Analyzer    = 0 THEN NULL ELSE ContainerId_Analyzer END
             , CASE WHEN ContainerIntId_Analyzer = 0 THEN NULL ELSE ContainerIntId_Analyzer END

             , CASE WHEN ObjectIntId_Analyzer    = 0 THEN NULL ELSE ObjectIntId_Analyzer END
             , CASE WHEN ObjectExtId_Analyzer    = 0 THEN NULL ELSE ObjectExtId_Analyzer END

             , COALESCE (Amount, 0)
             , OperDate
             , IsActive
     
        FROM _tmpMIContainer_insert;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemContainer_byTable() OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.17                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItemContainer_byTable ()
