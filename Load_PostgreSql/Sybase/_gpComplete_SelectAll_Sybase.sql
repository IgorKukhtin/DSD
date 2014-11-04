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
     WITH tmpUnit AS (SELECT 8411 AS UnitId -- ����� �� �.����
                UNION SELECT 8413 AS UnitId -- �. ��.���
                UNION SELECT 8415 AS UnitId -- �. �������� ( ����������)
                UNION SELECT 8417 AS UnitId -- �. �������� (������)
                UNION SELECT 8421 AS UnitId -- �. ������
                UNION SELECT 8425 AS UnitId -- �. �������
--                UNION SELECT 301309 AS UnitId -- �. ���������
--                UNION SELECT 18341 AS UnitId -- �. ��������
--                UNION SELECT 8419 AS UnitId -- �. ����
--                UNION SELECT 8423 AS UnitId -- �. ������
               )
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM Movement
          /*JOIN MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id
                                                   AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                   AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()*/
          JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                             AND MLO_From.DescId = zc_MovementLinkObject_From()
          JOIN tmpUnit ON tmpUnit.UnitId = MLO_From.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Sale(), /*zc_Movement_Loss(),*/ zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
    UNION
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM Movement
          /*JOIN MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id
                                                   AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                   AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()*/
          JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
          JOIN tmpUnit ON tmpUnit.UnitId = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_ReturnIn())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
    UNION
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM Movement
          /*JOIN MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id
                                                   AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                   AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()*/
          JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
          JOIN tmpUnit ON tmpUnit.UnitId = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.11.14                                        *
*/
/*
create table dba._pgMovementReComlete
     MovementId integer
    ,OperDate date
    ,InvNumber TVarCharMedium
    ,Code  TVarCharMedium
    ,ItemName TVarCharMedium
 ,primary key (MovementId))
*/
-- ����
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014')
