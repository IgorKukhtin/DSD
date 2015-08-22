-- Function: gpSelect_CashRemains_Lite()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_Lite (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains_Lite (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_Lite(
    IN inMovementId    Integer,    --������� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, Remains TFloat, Reserve_Amount TFloat)
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbUnitKey TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    RETURN QUERY
        WITH
        RESERVE
        AS
        (
            SELECT
                MovementItem_Reserve.GoodsId,
                SUM(CASE 
                      WHEN MovementLinkObject_CheckMember.MovementId is null 
                        THEN MovementItem_Reserve.Amount
                    ELSE 0
                    END)::TFloat as Amount_Reserve,
                SUM(CASE 
                      WHEN MovementLinkObject_CheckMember.MovementId is not null 
                        THEN MovementItem_Reserve.Amount
                    ELSE 0
                    END)::TFloat as Amount_VIP
            FROM
                gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
                LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                             ON MovementLinkObject_CheckMember.MovementId = MovementItem_Reserve.MovementId
                                            AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
            WHERE
                MovementItem_Reserve.MovementId <> inMovementId
            Group By
                MovementItem_Reserve.GoodsId
        ),
        CurrentMovement
        AS
        (
            SELECT
                ObjectId,
                SUM(Amount)::TFloat as Amount
            FROM
                MovementItem
            WHERE
                MovementId = inMovementId
                AND
                Amount <> 0
            Group By
                ObjectId
        )
        SELECT 
            container.objectid
           ,(SUM(container.Amount) 
             - COALESCE(CurrentMovement.Amount,0) 
             - COALESCE(Reserve.Amount_VIP,0))::TFloat AS Remains
           ,RESERVE.Amount_Reserve                     AS Reserve_Amount 
        FROM container
            INNER JOIN containerlinkobject AS CLO_Unit
                                           ON CLO_Unit.containerid = container.id 
                                          AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                          AND CLO_Unit.objectid = vbUnitId
            LEFT OUTER JOIN RESERVE ON container.objectid = RESERVE.GoodsId
            LEFT OUTER JOIN CurrentMovement ON container.objectid = CurrentMovement.ObjectId
            
        WHERE 
            container.descid = zc_container_count() 
            AND 
            container.Amount<>0
        GROUP BY 
            container.objectid
           ,RESERVE.Amount_Reserve
           ,RESERVE.Amount_VIP
           ,CurrentMovement.Amount;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Lite (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 22.08.15                                                                       *���������� ��� � ���������
 19.08.15                                                                       *CurrentMovement
 29.07.15                                                                       *
*/
-- ����
-- SELECT * FROM gpSelect_CashRemains_Lite (inSession:= '308120')