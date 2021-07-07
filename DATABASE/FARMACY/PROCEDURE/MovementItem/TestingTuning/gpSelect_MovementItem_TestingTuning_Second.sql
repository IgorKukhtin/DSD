-- Function: gpSelect_MovementItem_TestingTuning_Second()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_TestingTuning_Second (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_TestingTuning_Second(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ParentId Integer
             , Orders Integer, isCorrectAnswer Boolean
             , PossibleAnswer TBLOB
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Loss());
   vbUserId:= lpGetUserBySession (inSession);
         
   -- ���������
   RETURN QUERY
        -- ���������
        SELECT MovementItem.Id                                     AS Id
             , MovementItem.ParentId                               AS ParentId
             , ROW_NUMBER()OVER(PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id)::Integer as Orders
             , MovementItem.Amount = 1                             AS isCorrectAnswer 
             , MIBLOB_PossibleAnswer.ValueData                     AS PossibleAnswer
             , COALESCE(MovementItem.IsErased, FALSE)                                       AS isErased
        FROM MovementItem 
            
            -- ������� ������
            LEFT JOIN MovementItemBLOB AS MIBLOB_PossibleAnswer
                                       ON MIBLOB_PossibleAnswer.MovementItemId = MovementItem.Id
                                      AND MIBLOB_PossibleAnswer.DescId = zc_MIBLOB_PossibleAnswer()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Second()
          AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
        ORDER BY MovementItem.ParentId, MovementItem.Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_TestingTuning_Second (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 06.07.21                                                                     *  
*/

-- ����
-- 
select * from gpSelect_MovementItem_TestingTuning_Second(inMovementId := 16461309 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');