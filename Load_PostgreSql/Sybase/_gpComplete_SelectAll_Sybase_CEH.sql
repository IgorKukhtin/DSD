-- Function: gpComplete_SelectAll_Sybase_CEH()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase_CEH (TDateTime, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase_CEH(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inIsBefoHistoryCost  Boolean
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN

-- if EXTRACT (MONTH FROM inStartDate) IN (2, 3) then return; end if;

     RETURN QUERY 
     WITH tmpUnit AS (SELECT tmp.UnitId,       TRUE AS isMain FROM lfSelect_Object_Unit_byGroup (8446) AS tmp -- ��� �������+���-��
            -- UNION ALL SELECT tmp.Id AS UnitId, TRUE AS isMain FROM Object AS tmp WHERE Id = 951601 -- ��� �������� ����
            UNION ALL SELECT tmp.Id AS UnitId, TRUE AS isMain FROM Object AS tmp WHERE Id = 981821  -- ��� �����. ����
            UNION ALL SELECT tmp.Id AS UnitId, TRUE AS isMain FROM Object AS tmp WHERE Id = 8020711 -- ��� ������� + ���������� (����)
               )
     -- !!!Internal!!!
     -- 5. Send + ProductionUnion + ProductionSeparate
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

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       -- AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
       AND Movement.DescId IN (zc_Movement_ProductionUnion()) -- =  ��� �������+���-��
       AND tmpUnit_from.UnitId > 0 AND tmpUnit_To.UnitId IS NULL      -- =  ��� �������+���-��
       -- AND tmpUnit_from.UnitId IS NULL AND tmpUnit_To.UnitId IS NULL  -- <> ����� ������ � ���������
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.11.14                                        *
*/

-- SELECT * FROM gpComplete_SelectAll_Sybase_CEH (inStartDate:= '01.05.2023', inEndDate:= '31.05.2023', inIsBefoHistoryCost:= FALSE) WHERE MovementId = 5438021
