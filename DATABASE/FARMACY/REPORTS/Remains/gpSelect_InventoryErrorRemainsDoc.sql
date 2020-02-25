-- Function: gpSelect_InventoryErrorRemainsDoc()

DROP FUNCTION IF EXISTS gpSelect_InventoryErrorRemainsDoc (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_InventoryErrorRemainsDoc(
    IN inGoodsId          Integer  ,  -- �����
    IN inUnitId           Integer  ,  -- �������������
    IN inStartDate        TDateTime,  -- ���� ������ �������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (
    MovementId       Integer,   --�� ����������
    OperDate         TDateTime, --���� ���������
    InvNumber        TVarChar,  --� ���������
    MovementDescId   Integer,   --��� ���������
    MovementDescName TVarChar,  --�������� ���� ���������
    StatusName       TVarChar,  --������ ���������
    Amount           TFloat     --���-��
  )
AS
$BODY$
   DECLARE vbUserId Integer;
      DECLARE vbEndDate TDateTime;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    inStartDate := DATE_TRUNC ('DAY', inStartDate);
    vbEndDate := inStartDate + INTERVAL '12 DAY';

    -- ���������
    RETURN QUERY
    WITH tmpMovementAll AS (SELECT Movement.ID
                            FROM Movement

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId in (zc_MovementLinkObject_Unit(), zc_MovementLinkObject_From() , zc_MovementLinkObject_To())
                                                              AND MovementLinkObject_Unit.ObjectId = inUnitId
                            WHERE Movement.DescId in (zc_Movement_Send(), zc_Movement_ReturnOut())
                              AND Movement.OperDate >= inStartDate AND Movement.OperDate < vbEndDate
                            UNION ALL
                            SELECT Movement.ID
                            FROM Movement

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId in (zc_MovementLinkObject_Unit(), zc_MovementLinkObject_From() , zc_MovementLinkObject_To())
                                                              AND MovementLinkObject_Unit.ObjectId = inUnitId
                            WHERE Movement.DescId = zc_Movement_Check()
                              AND Movement.OperDate >= inStartDate AND Movement.OperDate < inStartDate + INTERVAL '1 DAY')
       , tmpMovement AS (SELECT DISTINCT Movement.ID,
                                MovementItem.Amount
                         FROM tmpMovementAll AS Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.ObjectId IN
                                                         (SELECT Object_Goods_Retail.ID FROM Object_Goods_Retail WHERE Object_Goods_Retail.GoodsMainId =
                                                           (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.ID = inGoodsId)))

       , tmpDelayed AS (SELECT DISTINCT Movement.ID
                        FROM tmpMovement AS  Movement
                              
                             INNER JOIN MovementProtocol ON MovementProtocol.MovementId =  Movement.ID
                                                        AND MovementProtocol.OperDate <= inStartDate + INTERVAL '1 DAY'
                                                        AND MovementProtocol.ProtocolData ILIKE '%�������" FieldValue = "true%')
    SELECT Movement.ID
         , Movement.OperDate
         , Movement.InvNumber
         , MovementDesc.ID
         , MovementDesc.ItemName
         , Object_Status.ValueData
         , tmpMovement.Amount
    FROM tmpMovement

       INNER JOIN Movement ON Movement.ID = tmpMovement.Id

       LEFT JOIN tmpDelayed ON tmpDelayed.ID = tmpMovement.Id

       INNER JOIN MovementDesc ON MovementDesc.id = Movement.DescId
       INNER JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
    
    WHERE COALESCE(tmpDelayed.ID, 0) <> 0 OR Movement.DescId = zc_Movement_Check();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.02.20                                                       *
*/

-- ���� select * from gpSelect_InventoryErrorRemainsDoc(inGoodsId := 17497 , inUnitId := 9771036 , inStartDate := ('07.02.2020')::TDateTime ,  inSession := '3');
