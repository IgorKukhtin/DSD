-- Function: _replica.gpSelect_Slave_RewiringParams()

  DROP FUNCTION IF EXISTS _replica.gpSelect_Slave_RewiringParams (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Slave_RewiringParams (
  IN inSession   TVarChar
)
RETURNS TABLE (
  GroupId       Integer,
  isSale        Boolean,
  GroupName     TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= inSession::Integer;

   -- ���������
   RETURN QUERY 
     SELECT 0 AS GroupId, False AS isSale, '�.����� ��� �������/�������'::TVarChar AS TVarChar
     UNION ALL
     SELECT 1 AS GroupId, True AS isSale, '������ ����'::TVarChar AS TVarChar
     UNION ALL
     SELECT 2 AS GroupId, True AS isSale, '������ ������'::TVarChar AS TVarChar
     UNION ALL
     SELECT 3 AS GroupId, True AS isSale, '��������� �������'::TVarChar AS TVarChar
     UNION ALL
     SELECT 4 AS GroupId, True AS isSale, '�.����� ������ �������/�������'::TVarChar AS TVarChar;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- SELECT * FROM _replica.gpSelect_Slave_RewiringParams (zfCalc_UserAdmin());