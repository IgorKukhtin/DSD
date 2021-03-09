-- Function: gpSelect_MovementItem_ProfitLossResult()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProfitLossResult (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ProfitLossResult(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, AccountId Integer, AccountCode Integer, AccountName TVarChar
             , ContainerId TFloat
             , Amount TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ProfitLossResult());
     vbUserId:= lpGetUserBySession (inSession);

    -- ���������
     RETURN QUERY

       -- ���������
       SELECT
             MovementItem.Id            AS Id
           , Object_Account.Id          AS AccountId
           , Object_Account.ObjectCode  AS AccountCode
           , Object_Account.ValueData   AS AccountName

           , MIFloat_ContainerId.ValueData :: TFloat AS ContainerId
           , MovementItem.Amount           :: TFloat AS Amount
           , MovementItem.isErased                   AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Object AS Object_Account ON Object_Account.Id = MovementItem.ObjectId
             
            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId() 
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.03.21         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_ProfitLossResult (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_ProfitLossResult (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '2')