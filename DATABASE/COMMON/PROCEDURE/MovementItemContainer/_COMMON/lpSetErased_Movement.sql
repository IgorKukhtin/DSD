-- Function: lpSetErased_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_Movement (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement(
    IN inMovementId        Integer  , -- ���� ������� <��������>
    IN inUserId            Integer    -- ������������
)                              
  RETURNS void
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbCloseDate TDateTime;
BEGIN
  -- �������� <���������������>
  IF EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Registered() AND ValueData = TRUE)
  THEN
      RAISE EXCEPTION '������.�������� ���������������.<��������> ����������.';
  END IF;


  -- ����������� ������ ������ ���������
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementId
  RETURNING OperDate INTO vbOperDate;


  -- ������������ ���� ��� <�������� �������>
  SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END
         INTO vbCloseDate
  FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
             , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
        FROM PeriodClose
        -- select * FROM PeriodClose where Period = interval '1 day'
             LEFT JOIN ObjectLink_UserRole_View AS View_UserRole
                                                ON View_UserRole.RoleId = PeriodClose.RoleId
                                               AND View_UserRole.UserId = inUserId
        WHERE View_UserRole.UserId = inUserId OR PeriodClose.RoleId IS NULL
       ) AS tmp;
            
  -- �������� ���� ��� <�������� �������>
  IF vbOperDate < vbCloseDate
  THEN 
       RAISE EXCEPTION '������.��������� �� <%> �� ��������.������ ������ �� <%>.', TO_CHAR (vbOperDate, 'DD.MM.YYYY'), TO_CHAR (vbCloseDate, 'DD.MM.YYYY');
  END IF;


  -- ������� ��� ��������
  PERFORM lpDelete_MovementItemContainer (inMovementId);
  -- ������� ��� �������� ��� ������
  PERFORM lpDelete_MovementItemReport (inMovementId);


  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSetErased_Movement (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.14                                        * add �������� ���� ��� <�������� �������>
 10.05.14                                        * add �������� <���������������>
 10.05.14                                        * add lpInsert_MovementProtocol
 06.10.13                                        * add inUserId
 01.09.13                                        * add lpDelete_MovementItemReport
*/

-- ����
-- SELECT * FROM lpSetErased_Movement (inMovementId:= 55, inSession:= '2')
