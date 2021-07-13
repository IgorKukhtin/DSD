-- Function: gpSelect_MovementItem_TestingTuning_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_TestingTuning_Child (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_TestingTuning_Child(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ParentId Integer
             , Orders Integer, Replies Integer, CorrectAnswer Integer
             , Question TBLOB
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
    WITH
    tmpReplies AS (SELECT MovementItem.ParentId         AS Id
                        , count(*)                      AS Replies
                        , SUM(MovementItem.Amount)      AS CorrectAnswer
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Second()
                     AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                   GROUP BY MovementItem.ParentId 
                   )


        -- ���������
        SELECT MovementItem.Id                                     AS Id
             , MovementItem.ParentId                               AS ParentId
             , ROW_NUMBER()OVER(PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id)::Integer as Orders
             , tmpReplies.Replies::Integer                         AS Replies 
             , tmpReplies.CorrectAnswer::Integer                   AS CorrectAnswer 
             , MIBLOB_Question.ValueData                           AS Question
             , COALESCE(MovementItem.IsErased, FALSE)                                       AS isErased
        FROM MovementItem 
            
            LEFT JOIN tmpReplies ON tmpReplies.Id = MovementItem.Id
                
            -- ������
            LEFT JOIN MovementItemBLOB AS MIBLOB_Question
                                       ON MIBLOB_Question.MovementItemId = MovementItem.Id
                                      AND MIBLOB_Question.DescId = zc_MIBLOB_Question()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Child()
          AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
        ORDER BY MovementItem.ParentId, MovementItem.Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_TestingTuning_Child (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 06.07.21                                                                     *  
*/

-- ����
-- select * from gpSelect_MovementItem_TestingTuning_Child(inMovementId := 23977600 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');
