-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory_Child(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UserId Integer, UserName TVarChar
             , Amount TFloat
             , Date_Insert TDateTime
             , isErased Boolean
             , isLast Boolean
             , Num Integer
             )
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;

  vbUnitId Integer;
  vbOperDate TDateTime;
  vbIsFullInvent Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
    vbUserId:= lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

        -- ���������
        RETURN QUERY
        WITH
                 -- �������� ����� ������
                 tmpMI AS (SELECT MovementItem.Id            AS Id
                                , MovementItem.ObjectId      AS GoodsId
                                , MovementItem.isErased
                            FROM MovementItem
                             WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                          --    AND (MovementItem.isErased  = FALSE OR inIsErased = TRUE)
                           )
         -- �������� ����� �����
         , tmpMI_Child AS (SELECT MovementItem.Id            AS Id
                                , MovementItem.ParentId      AS ParentId
                                , MovementItem.ObjectId      AS UserId
                                , MovementItem.Amount        AS Amount
                                , MIDate_Insert.ValueData    AS Date_Insert
                                , MovementItem.isErased 
                                , CAST (ROW_NUMBER() OVER (PARTITION BY  MovementItem.ObjectId ORDER BY MovementItem.ObjectId, MovementItem.Id) AS Integer) AS Num
                                , CAST (ROW_NUMBER() OVER (PARTITION BY  MovementItem.ParentId,MovementItem.ObjectId ORDER BY MovementItem.ParentId, MovementItem.ObjectId, MIDate_Insert.ValueData DESC) AS Integer) AS NumLast
                            FROM MovementItem
                                 LEFT JOIN MovementItemDate AS MIDate_Insert
                                                            ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                           AND MIDate_Insert.DescId = zc_MIDate_Insert()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                           )

            -- ���������
            SELECT
                tmpMI_Child.Id
              , tmpMI_Child.ParentId
              , Object_Goods.Id                                     AS GoodsId
              , Object_Goods.ObjectCode                             AS GoodsCode
              , (CASE WHEN tmpMI.GoodsId > 0 THEN '' ELSE '***' END || Object_Goods.ValueData) :: TVarChar AS GoodsName
              , Object_User.Id                                      AS UserId
              , Object_User.ValueData                  :: TVarChar  AS UserName
              , tmpMI_Child.Amount                                  AS Amount
              , tmpMI_Child.Date_Insert                             AS Date_Insert
              , COALESCE (tmpMI.isErased, FALSE)       :: Boolean   AS isErased
              , CASE WHEN tmpMI_Child.NumLast = 1 THEN TRUE ELSE FALSE END isLast
              , tmpMI_Child.Num
             
            FROM tmpMI
                INNER JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
                LEFT JOIN Object AS Object_User ON Object_User.Id = tmpMI_Child.UserId
            ORDER BY GoodsName
                   , UserName
                   , Date_Insert desc
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.   ��������� �.�.
 05.01.17         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Inventory_Child (inMovementId:= 3871646   , inIsErased:= false,  inSession:= '3')