-- Function: gpUnComplete_Movement()

-- DROP FUNCTION lpDelete_MovementItemContainer (Integer);


CREATE OR REPLACE FUNCTION lpDelete_MovementItemContainer (IN inMovementId Integer)
  RETURNS void AS
$BODY$
BEGIN

    -- �������� �������� �������
    UPDATE Container SET Amount = Container.Amount - _tmpMIContainer.Amount
    FROM (SELECT SUM (MIContainer.Amount) AS Amount
               , MIContainer.ContainerId
          FROM MovementItemContainer AS MIContainer
          WHERE MIContainer.MovementId = inMovementId
          GROUP BY MIContainer.ContainerId
         ) AS _tmpMIContainer
    WHERE Container.Id = _tmpMIContainer.ContainerId;

    -- ������� ��� ��������
    DELETE FROM MovementItemContainer WHERE MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_MovementItemContainer (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.08.13                                        * 1251Cyr
*/
