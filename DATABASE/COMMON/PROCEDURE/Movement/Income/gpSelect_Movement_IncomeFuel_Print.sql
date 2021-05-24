-- Function: gpSelect_Movement_IncomeFuel_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeFuel_Print (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeFuel_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbChangePercentTo TFloat;
    DECLARE vbPaidKindId Integer;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;
    DECLARE vbContractId Integer;
    DECLARE vbIsProcess_BranchIn Boolean;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= lpGetUserBySession (inSession);

    -- ����� ������ ��������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- ��� ��� �������� ������
       -- RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



      --
    OPEN Cursor1 FOR
      SELECT
               tmpGet_IncomeFuel.Id
             , tmpGet_IncomeFuel.InvNumber
             
             , tmpGet_IncomeFuel.OperDatePartner
             , EXTRACT (YEAR FROM tmpGet_IncomeFuel.OperDate ::TDateTime) ::TVarChar AS OperDatePartnerYear
             , zfCalc_MonthName(tmpGet_IncomeFuel.OperDatePartner)                   AS OperDatePartnerMonth
             , tmpGet_IncomeFuel.InvNumberPartner

             , tmpGet_IncomeFuel.FromName
             , tmpGet_IncomeFuel.ToName
             , COALESCE(Object_Position.ValueData,'' )::TVarChar  AS PositionName

             , tmpGet_IncomeFuel.StartOdometre
             , tmpGet_IncomeFuel.EndOdometre
             , tmpGet_IncomeFuel.AmountFuel
             , tmpGet_IncomeFuel.Reparation
             , tmpGet_IncomeFuel.LimitMoney
             , tmpGet_IncomeFuel.LimitDistance
             , tmpGet_IncomeFuel.LimitChange
             , tmpGet_IncomeFuel.LimitDistanceChange
             , tmpGet_IncomeFuel.Distance
             -- *������ ����� ��
           , tmpGet_IncomeFuel.DistanceReal
             -- ���-�� �. (��������)
           , tmpGet_IncomeFuel.FuelReal 
             -- ����� ��������
           , MovementFloat_TotalSumm.ValueData AS SummReal
             -- ���� ��������
           , CASE WHEN MovementFloat_TotalCount.ValueData <> 0 THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) / MovementFloat_TotalCount.ValueData ELSE 0 END :: TFloat AS PriceCalc

             -- *���-�� �. (����. �� ������ �.��.) = ������ �.��. * �����
           , tmpGet_IncomeFuel.FuelCalc
             -- *���-�� �. (������������) = ���� ���� ����� ��. ����� = ��� (������ �.��. ��� ����� ��.) * �����
           , tmpGet_IncomeFuel.FuelRealCalc
             -- *���-�� �. (������� �� ���. ��.) = ���� ���� ����� ��. ����� = �������� �.�. - ���-�� �. (������������)
           , tmpGet_IncomeFuel.FuelDiff
             -- *����� ��� (������� ���. ��.)= ���� ���� ����� ��. ����� = (���� �������� �. - "�� ��� ���� �.") * ���� ���� �������
           , tmpGet_IncomeFuel.FuelSummDiff
             -- *����� ��� (������� ���. ���) = ���� ���� ����� ���. � �� ������ ��� ���� �������� ���. ����� = ���� �������� ���. - ����� ���.
           , tmpGet_IncomeFuel.SummDiff
             -- *����� ��� (���. ���), !!!������������ ������ ��� ����������!!!
           , tmpGet_IncomeFuel.SummLimit
             -- *����� ��� (������� �����) = ������� ��� �� ���. ��. + ������� ��� �� ���. ���.
           , tmpGet_IncomeFuel.SummDiffTotal
             -- *����� ��� (�����������) = ���� ���. ��. = 0 ����� = ������ �.��. * ���� �����. ����� = ��� (������ �.��. ��� ����� ��.) * ���� �����.
           , tmpGet_IncomeFuel.SummReparation
             -- *����� ��� (�� ����) = ����� ��� (������� �����) - ����� ��� (�����������)
           , tmpGet_IncomeFuel.SummPersonal
           
       FROM gpGet_Movement_IncomeFuel (inMovementId := inMovementId, inOperDate:= NULL, inSession:= inSession) AS tmpGet_IncomeFuel
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  tmpGet_IncomeFuel.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  tmpGet_IncomeFuel.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            
           -- ��� ���.���� �������� ���������
           LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                            ON ObjectLink_Personal_Member.ChildObjectId = tmpGet_IncomeFuel.ToId
                           AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
           LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                               AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
;
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
             SELECT
             MovementItem.Id
           , CASE WHEN MovementItem.Id <> 0 THEN CAST (row_number() OVER (ORDER BY MIDate_OperDate.ValueData) AS Integer) ELSE 0 END AS LineNum
           , Object_RouteMember.Id                      AS RouteMemberId
           , Object_RouteMember.ObjectCode ::TVarChar   AS RouteMemberCode
           , OB_RouteMember_Description.ValueData       AS RouteMemberName
           , MIDate_OperDate.ValueData                  AS OperDate
           , tmpWeekDay.DayOfWeekName_Full              AS DayOfWeekName
           , MovementItem.Amount
           , MIFloat_StartOdometre.ValueData    AS StartOdometre
           , MIFloat_EndOdometre.ValueData      AS EndOdometre

           , CAST ((COALESCE (MIFloat_EndOdometre.ValueData, 0) - COALESCE (MIFloat_StartOdometre.ValueData, 0))  AS TFloat) AS Distance_calc

           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                        ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
            LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                        ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()
            LEFT JOIN Object AS Object_RouteMember ON Object_RouteMember.Id =  MovementItem.ObjectId 
            LEFT JOIN ObjectBlob AS OB_RouteMember_Description
                                 ON OB_RouteMember_Description.ObjectId =  Object_RouteMember.Id
                                AND OB_RouteMember_Description.DescId = zc_ObjectBlob_RouteMember_Description()

            LEFT JOIN MovementItemDate AS MIDate_OperDate
                                        ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                       AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
            LEFT JOIN zfCalc_DayOfWeekName (MIDate_OperDate.ValueData) AS tmpWeekDay ON 1=1
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = False

       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_IncomeFuel_Print (Integer,  TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.08.16         * 
*/

-- ����
-- SELECT * FROM gpSelect_Movement_IncomeFuel_Print (inMovementId := 432692, inSession:= '5');
