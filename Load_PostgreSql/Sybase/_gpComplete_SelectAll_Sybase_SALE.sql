-- Function: gpComplete_SelectAll_Sybase()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inIsBefoHistoryCost  Boolean
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
     WITH tmpUnit AS (/*SELECT 8411 AS UnitId, FALSE AS isMain -- ����� �� �.����
                UNION SELECT 8413 AS UnitId, FALSE AS isMain  -- �. ��.���
                UNION SELECT 8415 AS UnitId, FALSE AS isMain  -- �. �������� ( ����������)
                UNION SELECT 8417 AS UnitId, FALSE AS isMain  -- �. �������� (������)
                UNION SELECT 8421 AS UnitId, FALSE AS isMain  -- �. ������
                UNION SELECT 8425 AS UnitId, FALSE AS isMain  -- �. �������
                UNION SELECT 301309 AS UnitId, FALSE AS isMain  -- ����� �� �.���������
                -- UNION SELECT 309599 AS UnitId, FALSE AS isMain  -- ����� ��������� �.���������
                UNION SELECT 18341 AS UnitId, FALSE AS isMain  -- �. ��������
                UNION SELECT 8419 AS UnitId, FALSE AS isMain  -- �. ����
                UNION SELECT 8423 AS UnitId, FALSE AS isMain  -- �. ������
                UNION SELECT 346093  AS UnitId, FALSE AS isMain  -- ����� �� �.������
                -- UNION SELECT 346094  AS UnitId, FALSE AS isMain  -- ����� ��������� �.������

                UNION SELECT tmp.UnitId, TRUE AS isMain FROM lfSelect_Object_Unit_byGroup (8446) AS tmp -- ��� �������+���-��
                UNION SELECT tmp.UnitId, TRUE AS isMain FROM lfSelect_Object_Unit_byGroup (8454) AS tmp -- ����� ������ � ���������

                UNION */SELECT tmp.UnitId, TRUE AS isMain FROM lfSelect_Object_Unit_byGroup (8432) AS tmp -- 30000 - ��������������������
               )
     -- 1. From: Sale + SendOnPrice
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Sale())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND (tmpUnit_from.UnitId > 0)
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.11.14                                        *
*/
